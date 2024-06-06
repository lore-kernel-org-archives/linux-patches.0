Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 309C51A2559;
	Thu,  6 Jun 2024 14:22:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683745; cv=none; b=F7Xh18jZvuOMwp6IFUo1z3SzfBt84Gv91HBeSkcdCAhA4awHofuqOgIHxpPszwZ6QExfvQXs58BRVY0KeX/3BuweHmwUJ3QXZvHmgjeNdV0Mn4I82KAeT3svzlqugmXVECN0Komaex0LE5XNQX5eklV2gt+gdYA8NaKM8z9bH9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683745; c=relaxed/simple;
	bh=p4frLUFGOs7UgtYBSClkl9fBOeR8JccQBmxpWe8cIE8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q/LKa0oxb+TqTw/V7JFSjDgeI+PCZrLXUUtsVMbzkN9V5d3eRSdCWUH3iCpq3cZp9j5r77bcS3vrPGlzU5rc8oPoqCl+5gR1CjdqgbuxLcjD83N2S0a7woSfKKW1jnMKe35ZSM/XrpbBgReQnzg+ckYz4sqGMTa85ferv7VXk0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gVu0tryX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gVu0tryX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D761C32786;
	Thu,  6 Jun 2024 14:22:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683745;
	bh=p4frLUFGOs7UgtYBSClkl9fBOeR8JccQBmxpWe8cIE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gVu0tryXcjoFL81lU3Xj85aY5RpMzYcd1L94J2Bl6Xcj0MttF4FDrKUcHijH1oTZT
	 7+8iTlVEikeb3FPuOc4sdZAsJcDUVcVYgBJif/fm/UbELGtIpfKvSnep4VHPKdaPuk
	 HItxw61FIGc+frYqfP2spIh2SBRlBM76Q3AnXW10=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 709/744] ALSA: seq: Fix missing bank setup between MIDI1/MIDI2 UMP conversion
Date: Thu,  6 Jun 2024 16:06:21 +0200
Message-ID: <20240606131755.216004814@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

[ Upstream commit 8a42886cae307663f3f999846926bd6e64392000 ]

When a UMP packet is converted between MIDI1 and MIDI2 protocols, the
bank selection may be lost.  The conversion from MIDI1 to MIDI2 needs
the encoding of the bank into UMP_MSG_STATUS_PROGRAM bits, while the
conversion from MIDI2 to MIDI1 needs the extraction from that
instead.

This patch implements the missing bank selection mechanism in those
conversions.

Fixes: e9e02819a98a ("ALSA: seq: Automatic conversion of UMP events")
Link: https://lore.kernel.org/r/20240527151852.29036-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/seq/seq_ump_convert.c | 38 ++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/sound/core/seq/seq_ump_convert.c b/sound/core/seq/seq_ump_convert.c
index ee6ac649df836..c21be87f5da9e 100644
--- a/sound/core/seq/seq_ump_convert.c
+++ b/sound/core/seq/seq_ump_convert.c
@@ -368,6 +368,7 @@ static int cvt_ump_midi1_to_midi2(struct snd_seq_client *dest,
 	struct snd_seq_ump_event ev_cvt;
 	const union snd_ump_midi1_msg *midi1 = (const union snd_ump_midi1_msg *)event->ump;
 	union snd_ump_midi2_msg *midi2 = (union snd_ump_midi2_msg *)ev_cvt.ump;
+	struct snd_seq_ump_midi2_bank *cc;
 
 	ev_cvt = *event;
 	memset(&ev_cvt.ump, 0, sizeof(ev_cvt.ump));
@@ -387,11 +388,29 @@ static int cvt_ump_midi1_to_midi2(struct snd_seq_client *dest,
 		midi2->paf.data = upscale_7_to_32bit(midi1->paf.data);
 		break;
 	case UMP_MSG_STATUS_CC:
+		cc = &dest_port->midi2_bank[midi1->note.channel];
+		switch (midi1->cc.index) {
+		case UMP_CC_BANK_SELECT:
+			cc->bank_set = 1;
+			cc->cc_bank_msb = midi1->cc.data;
+			return 0; // skip
+		case UMP_CC_BANK_SELECT_LSB:
+			cc->bank_set = 1;
+			cc->cc_bank_lsb = midi1->cc.data;
+			return 0; // skip
+		}
 		midi2->cc.index = midi1->cc.index;
 		midi2->cc.data = upscale_7_to_32bit(midi1->cc.data);
 		break;
 	case UMP_MSG_STATUS_PROGRAM:
 		midi2->pg.program = midi1->pg.program;
+		cc = &dest_port->midi2_bank[midi1->note.channel];
+		if (cc->bank_set) {
+			midi2->pg.bank_valid = 1;
+			midi2->pg.bank_msb = cc->cc_bank_msb;
+			midi2->pg.bank_lsb = cc->cc_bank_lsb;
+			cc->bank_set = 0;
+		}
 		break;
 	case UMP_MSG_STATUS_CHANNEL_PRESSURE:
 		midi2->caf.data = upscale_7_to_32bit(midi1->caf.data);
@@ -419,6 +438,7 @@ static int cvt_ump_midi2_to_midi1(struct snd_seq_client *dest,
 	struct snd_seq_ump_event ev_cvt;
 	union snd_ump_midi1_msg *midi1 = (union snd_ump_midi1_msg *)ev_cvt.ump;
 	const union snd_ump_midi2_msg *midi2 = (const union snd_ump_midi2_msg *)event->ump;
+	int err;
 	u16 v;
 
 	ev_cvt = *event;
@@ -443,6 +463,24 @@ static int cvt_ump_midi2_to_midi1(struct snd_seq_client *dest,
 		midi1->cc.data = downscale_32_to_7bit(midi2->cc.data);
 		break;
 	case UMP_MSG_STATUS_PROGRAM:
+		if (midi2->pg.bank_valid) {
+			midi1->cc.status = UMP_MSG_STATUS_CC;
+			midi1->cc.index = UMP_CC_BANK_SELECT;
+			midi1->cc.data = midi2->pg.bank_msb;
+			err = __snd_seq_deliver_single_event(dest, dest_port,
+							     (struct snd_seq_event *)&ev_cvt,
+							     atomic, hop);
+			if (err < 0)
+				return err;
+			midi1->cc.index = UMP_CC_BANK_SELECT_LSB;
+			midi1->cc.data = midi2->pg.bank_lsb;
+			err = __snd_seq_deliver_single_event(dest, dest_port,
+							     (struct snd_seq_event *)&ev_cvt,
+							     atomic, hop);
+			if (err < 0)
+				return err;
+			midi1->note.status = midi2->note.status;
+		}
 		midi1->pg.program = midi2->pg.program;
 		break;
 	case UMP_MSG_STATUS_CHANNEL_PRESSURE:
-- 
2.43.0



