Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 349A5146A9D;
	Tue, 25 Jun 2024 09:48:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308898; cv=none; b=gZqbh10svANtiIvbSHDhZgK5Q2VICrzeyxBObIaHkn5GXoWfK5uU/qlyoF/5mj5raz+oM9c0ZyFAG28cIr/rDoAoVsBjHAPV/4FQWXgknYDRX6o+V4gwhWmYPjxENjfsx/vRrNdKpCDsSY/a5UAejpq94VfA0MsasY256dufWPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308898; c=relaxed/simple;
	bh=iztwYX6sSg2RNTzttLIx52h49zLfuETlRzEBW4DmldA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zp7vKH02HFfDECmv7uWOjjaBbWGJeV6WmSINiZhR/1vPYYr+Jetz9yzOi8mgjMx8FIyrtAIqG11Uj2g4tgRKChd9VXxnDr2CIsTvZ0g8m1NEb68AkrNtUzfKNYw0lFmw9/i9rryUnb8eevPi64h1JIIZH+DzVcJz0D1Rqu7gq/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nZuOgIfI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nZuOgIfI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB8FEC32781;
	Tue, 25 Jun 2024 09:48:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308898;
	bh=iztwYX6sSg2RNTzttLIx52h49zLfuETlRzEBW4DmldA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nZuOgIfISTul8XEIeK3B10EcXQfEXpTDhepWXqOK9ft2uyDZsQP/VPitjJzU5jKLp
	 kLddY00475QJw8HK2nyFJeOUXUcW0sCz7Wqv2RVl+XkEgeJvQFnvgoRFrH6tLVhvSB
	 wBjBaV5D+hDyh4qxaLGwp1v7HfeKRN+81tTBAYXI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 027/192] ACPI: video: Add backlight=native quirk for Lenovo Slim 7 16ARH7
Date: Tue, 25 Jun 2024 11:31:39 +0200
Message-ID: <20240625085538.204067091@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085537.150087723@linuxfoundation.org>
References: <20240625085537.150087723@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit c901f63dc142c48326931f164f787dfff69273d9 ]

Lenovo Slim 7 16ARH7 is a machine with switchable graphics between AMD
and Nvidia, and the backlight can't be adjusted properly unless
acpi_backlight=native is passed.  Although nvidia-wmi-backlight is
present and loaded, this doesn't work as expected at all.

For making it working as default, add the corresponding quirk entry
with a DMI matching "LENOVO" "82UX".

Link: https://bugzilla.suse.com/show_bug.cgi?id=1217750
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/video_detect.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/acpi/video_detect.c b/drivers/acpi/video_detect.c
index 31205fee59d4a..16ab2d9ef67f3 100644
--- a/drivers/acpi/video_detect.c
+++ b/drivers/acpi/video_detect.c
@@ -505,6 +505,14 @@ static const struct dmi_system_id video_detect_dmi_table[] = {
 		DMI_MATCH(DMI_PRODUCT_NAME, "82BK"),
 		},
 	},
+	{
+	 .callback = video_detect_force_native,
+	 /* Lenovo Slim 7 16ARH7 */
+	 .matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+		DMI_MATCH(DMI_PRODUCT_NAME, "82UX"),
+		},
+	},
 	{
 	 .callback = video_detect_force_native,
 	 /* Lenovo ThinkPad X131e (3371 AMD version) */
-- 
2.43.0



