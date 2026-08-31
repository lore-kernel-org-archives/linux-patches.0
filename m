Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65A2655D863;
	Mon, 31 Aug 2026 13:47:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184051; cv=none; b=ChfyI2vJDQSwEriObXQnsejnX41GpGkynYkJ5nlmhQ+xpd34ytUDZm0X++bL9mqIasV9RFNCIdwGY6oo7E5dkfVmNZ9VR54XSseQdnxOgSpEVhMVVTbTylL+nx9ikSMjBTBMcxSRtdH1fBzAv7pTpQiefIkvzZAzYcFVuMJbxJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184051; c=relaxed/simple;
	bh=J+jQFYaucxEOWqW3yf0UhZjsWJzOiScJ1kL9CFAoUSA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hKtfrc0Yc5FVz7UfPSw10yN14cUC9j7tocUEnfk1V2dau+8tVMvruBsWRlSJ2puTDiEluBS+SmJKDIi9GBYUZd2MkCmwCetY0INTFd+pD2KfJIb0PuIBtahddrI3FYljL5xya0eXxp3X9fyBXRQewocPRgfEMY74zG9DSAAL2MU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UZ/ahsCV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UZ/ahsCV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 161D41F00A3F;
	Mon, 31 Aug 2026 13:47:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184049;
	bh=ds1ysNFYTR+NgjJ/YOnzzaH4ibJAxib2md01bLonLbM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UZ/ahsCVszyhkeoaVgZ9MQO5tWWN6m0cBIukOfxiOxPgztRebI8GclxqX8pO95fbT
	 1y8SFPTSW8wrAIFLDzMmwKeEQkSp6X4WoNRo7BBAUhAf6if+r1IPYloICSpXDJ4QWK
	 kKb7a9UDKTXA2OWwYNACcKtGE0c1PRxkwDfrwvonvZR8UWqC0lFo1cdnKxUcJ5OaTR
	 Xv5GnivWcYbSHiTlq3mFUjGXQMwrrx1Jy3zCmtVaD2w2UV/MvL8yL2qi/T7d0/Yubi
	 /ksmnOWhz+81+QMZB+iVrpjKg83UV15w/UaUJ+jEA1zqsWU5hWmoCB8APYYXmj6owS
	 +NX7RIx6SP9MQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Markus Lindner <lindner.markus@outlook.at>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.1] ALSA: usb-audio: Add dB map quirk for Razer Barracuda X 2.4
Date: Mon, 31 Aug 2026 09:28:09 -0400
Message-ID: <20260831133314.4125787-461-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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

LLM Generated explanations, may be completely bogus:

The background searches finished:

- **Mainline lookup** found the commit: `acd8aa3c4b91` — “ALSA: usb-
  audio: Add dB map quirk for Razer Barracuda X 2.4” by Markus Lindner,
  merged 2026-07-24 (+15 lines, one file). That matches the patch under
  review and confirms it’s in mainline but not yet in this 6.18.44 tree.
- **Bose SoundLink history search** in this checkout wasn’t useful: `git
  log -S` only surfaced the usb-6.18-rc8 merge, so the original quirk
  introduction isn’t visible here.

The earlier **YES** backport recommendation stands.

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

