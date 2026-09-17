Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B83D5038F1;
	Thu, 17 Sep 2026 17:09:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664964; cv=none; b=BYsC82iF8zApLY3nfOk5+LCi14SAVgu6B06Hfes1Q415MIvcMWRNlI3f1G7vltMABL56XlgBPwCqM7cFKJRMtdLIoOFiTgeVkVaY9OBrjUzYjn3tP3KCQJ478LzG4x7V8jfxEgyQObTn38VJkVJ5ys6vnno9uvq5wEXLvaOvNtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664964; c=relaxed/simple;
	bh=xZXqvsKNv7hTFBY4XGqtszYHAvzhrd80Mm+bt3KiRYc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HsPnPm3NK9M3BTn969SPQlBTolfJMGfdOkCuu4VyPrgTIVCENDnCheQT3SK/WbibPx3faTbJB4ffxWCNPVfdOwX1a8ygpJUowHk/rQdO1z12wyLnIME11K/V79cYjGXsqmESH+7rmknYuL1OZDNQ7SCj6ywFhBxsTgwqpM3QSE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R3PKQq4q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R3PKQq4q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE37D1F000FF;
	Thu, 17 Sep 2026 17:09:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664963;
	bh=s6QZMdrhS2HRszzqIZxBuQYB/DyBO79MEORfvfWMvOU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R3PKQq4qARXmb149KDDbXvm38zBV74CKri4a5L13mxdo59NNlodCoDTqa4BslDOpB
	 85EHrFK6CD/U94dpIZfHBsY/vPe+Sxd1Ep/W3JXsQ/R9OgvPvswwUQXWw5dMxyQ1+N
	 MLQE+dcNv+GcwW7mEeVzZA1BVXLYQ+JxVqJff+2g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Markus Lindner <lindner.markus@outlook.at>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0546/1250] ALSA: usb-audio: Add dB map quirk for Razer Barracuda X 2.4
Date: Thu, 17 Sep 2026 16:05:41 +0100
Message-ID: <20260917151606.735276515@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Markus Lindner <lindner.markus@outlook.at>

[ Upstream commit acd8aa3c4b91a38c8521000790890bc9d1083f1d ]

The Razer Barracuda X 2.4 GHz USB headset dongle (0x1532:0x0552)
reports a minimum volume register value of cval->min = -16800.

In UAC 1/256 dB units, -16800 corresponds to -65.625 dB. However,
stock ALSA misinterprets this raw integer as 1/100 dB units
(-168.00 dB), causing user-space audio servers (PipeWire /
PulseAudio) to map their volume curves against an incorrectly wide
range.

Add an explicit usbmix_dB_map entry overriding Unit 2 to -6562
(-65.62 dB) to accurately report the physical hardware
attenuation bounds.

Signed-off-by: Markus Lindner <lindner.markus@outlook.at>
Link: https://patch.msgid.link/AS8P195MB2142F4EFF83980BD02BA6566E1C12@AS8P195MB2142.EURP195.PROD.OUTLOOK.COM
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/mixer_maps.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/sound/usb/mixer_maps.c b/sound/usb/mixer_maps.c
index faac7df1fbcf0..4d8dca04f87d0 100644
--- a/sound/usb/mixer_maps.c
+++ b/sound/usb/mixer_maps.c
@@ -344,6 +344,16 @@ static const struct usbmix_name_map bose_soundlink_map[] = {
 	{ 0 }	/* terminator */
 };
 
+/*
+ * Razer Barracuda X 2.4: Firmware reports cval->min = -16800 in 1/256 dB units
+ * (-65.62 dB), which stock ALSA misinterprets as a -168 dB floor
+ */
+static const struct usbmix_dB_map razer_barracuda_x_2_4_dB = {-6562, 0};
+static const struct usbmix_name_map razer_barracuda_x_2_4_map[] = {
+	{ 2, NULL, .dB = &razer_barracuda_x_2_4_dB },
+	{ 0 }   /* terminator */
+};
+
 /* Sennheiser Communications Headset [PC 8], the dB value is reported as -6 negative maximum  */
 static const struct usbmix_dB_map sennheiser_pc8_dB = {-9500, 0};
 static const struct usbmix_name_map sennheiser_pc8_map[] = {
@@ -689,6 +699,11 @@ static const struct usbmix_ctl_map usbmix_ctl_maps[] = {
 		.id = USB_ID(0x17aa, 0x1046),
 		.map = lenovo_p620_rear_map,
 	},
+	{
+		/* Razer Barracuda X 2.4 */
+		.id = USB_ID(0x1532, 0x0552),
+		.map = razer_barracuda_x_2_4_map,
+	},
 	{
 		/* Sennheiser Communications Headset [PC 8] */
 		.id = USB_ID(0x1395, 0x0025),
-- 
2.53.0



