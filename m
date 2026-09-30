Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 696873C09F5;
	Wed, 30 Sep 2026 19:01:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794905; cv=none; b=T4XgO3NfRt25d0OXx89XkclMVg9TawckrIf5Y/Qmg9sDLuPmAY1bWMwOhM931rAjq6rJKrHgLAW5H329YrhbfjQ8Z2x2CuOMiOlxTUEORzbcEP6RYh12hheawNIc0uqlKMw+ZUtT4n7J1k8+FW3ueyhlpKexuRs4Wr0DnA2EcxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794905; c=relaxed/simple;
	bh=ZTxNW0KmfJHS2PTjLm08QQPAfdlC5TkfWpr7jLD+JY8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MikSkKiwG56Oo/8cTryiFsyyDzIW8Mz2klJJlpw4jx/1I+EVZ3omqstP5EtbbH+1I6LRjMnpwZFpdZ2ZtFuwDCCdDYNDfyrOwWiU3MZqvug9/Jj2AF2dnjnd/CgEEFkiCcdowEHpdEw2uHODU/sg7pGP05JCHzPeL+MIQtZgNZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ctdDI5A/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ctdDI5A/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 851721F000FF;
	Wed, 30 Sep 2026 19:01:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794904;
	bh=APX6u3IHBV4rE+/VXiowiLiQEiP74EWubJ8gXoo4j2Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ctdDI5A/ejb3Y2IUmy/MOptxYAFBbIWOT2yzxMvAPYxGywV+Vx2B91WLOBDvMg8k1
	 qbqO0vxxM7RWxkoMuoj/NUjtYLxltntKoisIpHc+VOHgLIyWOo+QiRcOOGzOdF2TO0
	 JOXtiJyhQvqWs9/XprI23ZTfJPTmkfL6G3DV9PeQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Markus Lindner <lindner.markus@outlook.at>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0329/1193] ALSA: usb-audio: Add dB map quirk for Razer Barracuda X 2.4
Date: Wed, 30 Sep 2026 17:16:53 +0200
Message-ID: <20260930152441.450881582@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



