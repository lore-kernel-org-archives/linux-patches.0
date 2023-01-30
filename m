Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D40A28EB
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 14:06:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A481C433D2;
	Mon, 30 Jan 2023 14:06:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675087608;
	bh=oI1QoXv9dNopkbyJTTg6+f0WrzO0tW4HFl+XeDOGJl4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n/1acJUsCDh9ABjS91lXf5EFWBVnDVdC2BRSMgcgNu0+oKpAOGodXrg4lMQIGp9So
	 x+uHzIwITcHyIf0rXw5916IcImYhxpRR9fXaqLaPRme/2QPLuHfS37fMyVLiJqBsM3
	 qne4zKZwf6lY5Aw4CbY4lE3zotolV8HVGaoTZmEc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 263/313] ACPI: video: Add backlight=native DMI quirk for Asus U46E
Date: Mon, 30 Jan 2023 14:51:38 +0100
Message-Id: <20230130134348.994273641@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit e6b3086fddc0065a5ffb947d4d29dd0e6efc327b ]

The Asus U46E backlight tables have a set of interesting problems:

1. Its ACPI tables do make _OSI ("Windows 2012") checks, so
   acpi_osi_is_win8() should return true.

   But the tables have 2 sets of _OSI calls, one from the usual global
   _INI method setting a global OSYS variable and a second set of _OSI
   calls from a MSOS method and the MSOS method is the only one calling
   _OSI ("Windows 2012").

   The MSOS method only gets called in the following cases:
   1. From some Asus specific WMI methods
   2. From _DOD, which only runs after acpi_video_get_backlight_type()
      has already been called by the i915 driver
   3. From other ACPI video bus methods which never run (see below)
   4. From some EC query callbacks

   So when i915 calls acpi_video_get_backlight_type() MSOS has never run
   and acpi_osi_is_win8() returns false, so acpi_video_get_backlight_type()
   returns acpi_video as the desired backlight type, which causes
   the intel_backlight device to not register.

2. _DOD effectively does this:

                    Return (Package (0x01)
                    {
                        0x0400
                    })

   causing acpi_video_device_in_dod() to return false, which causes
   the acpi_video backlight device to not register.

Leaving the user with no backlight device at all. Note that before 6.1.y
the i915 driver would register the intel_backlight device unconditionally
and since that then was the only backlight device userspace would use that.

Add a backlight=native DMI quirk for this special laptop to restore
the old (and working) behavior of the intel_backlight device registering.

Fixes: fb1836c91317 ("ACPI: video: Prefer native over vendor")
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/video_detect.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/acpi/video_detect.c b/drivers/acpi/video_detect.c
index 4719978b8aa3..04f3b26e3a75 100644
--- a/drivers/acpi/video_detect.c
+++ b/drivers/acpi/video_detect.c
@@ -600,6 +600,14 @@ static const struct dmi_system_id video_detect_dmi_table[] = {
 		DMI_MATCH(DMI_PRODUCT_NAME, "GA503"),
 		},
 	},
+	{
+	 .callback = video_detect_force_native,
+	 /* Asus U46E */
+	 .matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK Computer Inc."),
+		DMI_MATCH(DMI_PRODUCT_NAME, "U46E"),
+		},
+	},
 	{
 	 .callback = video_detect_force_native,
 	 /* Asus UX303UB */
-- 
2.39.0



