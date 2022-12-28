Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C73A1C08
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:46:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E95FC433D2;
	Wed, 28 Dec 2022 16:46:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672245962;
	bh=F0urdnkucMtpBcL6F6n89t7nSeKSfvkxHBTux19h244=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NFS3OufRoELinipWA6m6uLhWnQF0bMY8kNBn52WvSmtIJvq/oi2/GFDx6DgoU3+JK
	 wfa2BOvz8DtuNGi3QZ3Seb3HlPMb4ot5ZLrw5H496wK3edDWQl2KcOV9cilC623d9F
	 vkYTkDI6QDeq1aNty/8/pwHNwalZUdXh1Fjpwdrg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0954/1146] ACPI: video: Change Sony Vaio VPCEH3U1E quirk to force_native
Date: Wed, 28 Dec 2022 15:41:33 +0100
Message-Id: <20221228144356.232506649@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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

[ Upstream commit 84d56f326a8ef0071df8c0c3b983b9e2c3b73006 ]

According to: https://bugzilla.kernel.org/show_bug.cgi?id=202401
the Sony Vaio VPCEH3U1E quirk was added to disable the acpi_video0
backlight interface because that was not working, so that userspace
will pick the actually working native nv_backlight interface instead.

With the new kernel behavior of hiding native interfaces unless
acpi_video_get_backlight_type() returns native, the current
video_detect_force_vendor quirk will cause the working nv_backlight
interface will be disabled too.

Change the quirk to video_detect_force_native to get the desired
result of only registering the nv_backlight interface.

After this all currently remaining force_vendor quirks in
video_detect_dmi_table[] are there to prefer a vendor interface over
a non working ACPI video interface, add a comment to document this.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/video_detect.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/acpi/video_detect.c b/drivers/acpi/video_detect.c
index 375d1ef8fbea..0ab98f2e484c 100644
--- a/drivers/acpi/video_detect.c
+++ b/drivers/acpi/video_detect.c
@@ -132,6 +132,10 @@ static int video_detect_force_none(const struct dmi_system_id *d)
 }
 
 static const struct dmi_system_id video_detect_dmi_table[] = {
+	/*
+	 * Models which should use the vendor backlight interface,
+	 * because of broken ACPI video backlight control.
+	 */
 	{
 	 /* https://bugzilla.redhat.com/show_bug.cgi?id=1128309 */
 	 .callback = video_detect_force_vendor,
@@ -224,14 +228,6 @@ static const struct dmi_system_id video_detect_dmi_table[] = {
 		DMI_MATCH(DMI_BOARD_NAME, "NC210/NC110"),
 		},
 	},
-	{
-	 .callback = video_detect_force_vendor,
-	 /* Sony VPCEH3U1E */
-	 .matches = {
-		DMI_MATCH(DMI_SYS_VENDOR, "Sony Corporation"),
-		DMI_MATCH(DMI_PRODUCT_NAME, "VPCEH3U1E"),
-		},
-	},
 	{
 	 .callback = video_detect_force_vendor,
 	 /* Xiaomi Mi Pad 2 */
@@ -601,6 +597,15 @@ static const struct dmi_system_id video_detect_dmi_table[] = {
 		DMI_MATCH(DMI_BOARD_NAME, "N250P"),
 		},
 	},
+	{
+	 /* https://bugzilla.kernel.org/show_bug.cgi?id=202401 */
+	 .callback = video_detect_force_native,
+	 /* Sony Vaio VPCEH3U1E */
+	 .matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "Sony Corporation"),
+		DMI_MATCH(DMI_PRODUCT_NAME, "VPCEH3U1E"),
+		},
+	},
 
 	/*
 	 * These Toshibas have a broken acpi-video interface for brightness
-- 
2.35.1



