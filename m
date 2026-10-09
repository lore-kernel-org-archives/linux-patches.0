Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A168634D3BE;
	Fri,  9 Oct 2026 14:45:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557113; cv=none; b=oWeujM++b+bWvgSlZ+4oWcjgKBTVXgZ9iPNikgHi3E6wS0FN+Sgp42pPFTFC9bl+fOCbKsjLjsuaALiV2DJ5kkXdPAhg6A1CSiOcjw6b8ve6ScWV87ll14sqSw53MgQWCk2n9jiMuWatwWb1MyGgOWsOjzELlzo9CECx/b5R4Dw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557113; c=relaxed/simple;
	bh=EqMBVKXvXViB0kyQZDaxaD9VU5Fjnvmbr54nlTw4bbQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gKvsquAGsPTSJhq2OmP1PaKExa8YLQyBkaGPhD9JrlpknmC+jz2DeYV0DKSiY67ZusEItGgLr55LYiO8KoMUsAwl6/+bJjJ5HcR4/XpAv630hRVbvqhXK/F21/NgvdpeLDVP2pCN+OU4/HEv3fZDi+101/7gUS6MW4mEP6zoUfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GkKFcqpe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GkKFcqpe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02B7B1F000FF;
	Fri,  9 Oct 2026 14:45:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557112;
	bh=Xkz0scCyC33gePHRpKpPNSe5Y7fbUPJF+Vi0dAXjCEw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GkKFcqpeCQG6kVBwrSJ4Uw8KATS5KNCogmfXzge+xAXjARQ+1TfAU3TwyT6SCc9U1
	 mh/m4bAsTglPz2aMTMUmKB2iQ+HtXfKKKJ8QipAI5cPW2ySx1af34fIsdGzvw1tMPX
	 9PQu5mexdQIDCWOp7K+hanhPH4dqBdSmspUv9bfg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu-Hsiang Tseng <asas1asas200@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 7.2 271/428] ALSA: hda/realtek: Fix silent speaker on Higole F9B
Date: Fri,  9 Oct 2026 16:10:08 +0200
Message-ID: <20261009140952.045276515@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yu-Hsiang Tseng <asas1asas200@gmail.com>

commit 2a8ee6897302ca12ff39e8eb180503956797c60c upstream.

The Higole F9B is an Alder Lake-N mini PC with a 7" touchscreen and an
ALC269VC codec (subsystem ID 0x10ec111e). Its DMI strings are all
"Default string", so the SSID is the only way to identify it.

The internal speaker is silent out of the box. The generic parser
assigns DAC 0x03 to the speaker pin 0x14 and DAC 0x02 to the headphone
pin 0x15, but the speaker only reproduces what DAC 0x02 plays, whatever
its connection selection says. Checked one path at a time, only the
gain of DAC 0x02 and the mute of pin 0x14 change what comes out of the
speaker. User space only knows the path it was told the speaker uses,
so selecting the speaker turns the path that actually reaches it all
the way down.

Route both 0x14 and 0x15 through mixer 0x0c (DAC 0x02), which is what
ALC290_FIXUP_MONO_SPEAKERS already does. Tested on the device: the
speaker plays.

Cc: <stable@vger.kernel.org>
Assisted-by: LLM
Signed-off-by: Yu-Hsiang Tseng <asas1asas200@gmail.com>
Link: https://patch.msgid.link/20260923141344.1543158-1-asas1asas200@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/hda/codecs/realtek/alc269.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -7705,6 +7705,7 @@ static const struct hda_quirk alc269_fix
 	SND_PCI_QUIRK(0x10cf, 0x1757, "Lifebook E752", ALC269_FIXUP_LIFEBOOK_HP_PIN),
 	SND_PCI_QUIRK(0x10cf, 0x1845, "Lifebook U904", ALC269_FIXUP_LIFEBOOK_EXTMIC),
 	SND_PCI_QUIRK(0x10ec, 0x10f2, "Intel Reference board", ALC700_FIXUP_INTEL_REFERENCE),
+	SND_PCI_QUIRK(0x10ec, 0x111e, "Higole F9B", ALC290_FIXUP_MONO_SPEAKERS),
 	SND_PCI_QUIRK(0x10ec, 0x118c, "Medion EE4254 MD62100", ALC256_FIXUP_MEDION_HEADSET_NO_PRESENCE),
 	SND_PCI_QUIRK(0x10ec, 0x119e, "Positivo SU C1400", ALC269_FIXUP_ASPIRE_HEADSET_MIC),
 	SND_PCI_QUIRK(0x10ec, 0x11bc, "VAIO VJFE-IL", ALC269_FIXUP_LIMIT_INT_MIC_BOOST),


