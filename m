Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACE4A194A60;
	Thu,  5 Sep 2024 09:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725529424; cv=none; b=QWae8XgivgQEM0KS9d2w5f6dK0savV7VrVJkynnzbh9V07yvGRw/A5Kvgy0eLjdqJGwqAAsOeEBLFTIsHugiK9W2cvYlvZ7LPDrAs9Vdqx8VFU3ta4eKKbMyaLtbXsSRsbyd1JiTgtT6p0gczjhG4L91u4kqt6RYvNH2/en+Olw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725529424; c=relaxed/simple;
	bh=YzSR8pKyV4lC+hOhWowXQPndlmsbBPhhc4Vo6Zdnoio=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PMhOlysSnPFEj0AncJ/f80yT9ckC93gxLiUdkocJApn82sk7o5YSEN6W3aP+R3llBo8hPcguIP1kCMWCPI0fme/6Ex7CtKoAq/YsawWR6FqpZe1IhfzswmCyFjv5IEHnqaHnl7AhD3uoybgY4ydnZmnr/fn72irQ3IetUZc/3yo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=grVWWO0D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="grVWWO0D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFA86C4CEC3;
	Thu,  5 Sep 2024 09:43:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725529424;
	bh=YzSR8pKyV4lC+hOhWowXQPndlmsbBPhhc4Vo6Zdnoio=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=grVWWO0Dw7FTyf/2qB4l+cZgaVe0YCrTgffnTJlkfNTZqM7udBM9vWsLaW2iJ1L/g
	 Gb4WUCloWBy/ug9xdF0nQye0lfn9AD+jow51w6W+qKNMK1+Ft2PVHC0K/aTAYhJrBu
	 91OVfdBGMlEeaVr6T8ag/cFSoLhaZ6CFXdWNGgNQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 009/184] ALSA: ump: Transmit RPN/NRPN message at each MSB/LSB data reception
Date: Thu,  5 Sep 2024 11:38:42 +0200
Message-ID: <20240905093732.603960308@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093732.239411633@linuxfoundation.org>
References: <20240905093732.239411633@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit e6ce8a28c768dbbad3f818db286cd0f4c7a921a8 ]

The UMP 1.1 spec says that an RPN/NRPN should be sent when one of the
following occurs:
* a CC 38 is received
* a subsequent CC 6 is received
* a CC 98, 99, 100, and 101 is received, indicating the last RPN/NRPN
  message has ended and a new one has started

That said, we should send a partial data even if it's not fully
filled.  Let's change the UMP conversion helper code to follow that
rule.

Link: https://patch.msgid.link/20240731130528.12600-2-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/sound/ump_convert.h |  1 +
 sound/core/ump_convert.c    | 49 ++++++++++++++++++++++++-------------
 2 files changed, 33 insertions(+), 17 deletions(-)

diff --git a/include/sound/ump_convert.h b/include/sound/ump_convert.h
index 28c364c63245d..d099ae27f8491 100644
--- a/include/sound/ump_convert.h
+++ b/include/sound/ump_convert.h
@@ -13,6 +13,7 @@ struct ump_cvt_to_ump_bank {
 	unsigned char cc_nrpn_msb, cc_nrpn_lsb;
 	unsigned char cc_data_msb, cc_data_lsb;
 	unsigned char cc_bank_msb, cc_bank_lsb;
+	bool cc_data_msb_set, cc_data_lsb_set;
 };
 
 /* context for converting from MIDI1 byte stream to UMP packet */
diff --git a/sound/core/ump_convert.c b/sound/core/ump_convert.c
index f67c44c83fde4..5d1b85e7ac165 100644
--- a/sound/core/ump_convert.c
+++ b/sound/core/ump_convert.c
@@ -287,25 +287,37 @@ static int cvt_legacy_system_to_ump(struct ump_cvt_to_ump *cvt,
 	return 4;
 }
 
-static void fill_rpn(struct ump_cvt_to_ump_bank *cc,
-		     union snd_ump_midi2_msg *midi2)
+static int fill_rpn(struct ump_cvt_to_ump_bank *cc,
+		    union snd_ump_midi2_msg *midi2,
+		    bool flush)
 {
+	if (!(cc->cc_data_lsb_set || cc->cc_data_msb_set))
+		return 0; // skip
+	/* when not flushing, wait for complete data set */
+	if (!flush && (!cc->cc_data_lsb_set || !cc->cc_data_msb_set))
+		return 0; // skip
+
 	if (cc->rpn_set) {
 		midi2->rpn.status = UMP_MSG_STATUS_RPN;
 		midi2->rpn.bank = cc->cc_rpn_msb;
 		midi2->rpn.index = cc->cc_rpn_lsb;
-		cc->rpn_set = 0;
-		cc->cc_rpn_msb = cc->cc_rpn_lsb = 0;
-	} else {
+	} else if (cc->nrpn_set) {
 		midi2->rpn.status = UMP_MSG_STATUS_NRPN;
 		midi2->rpn.bank = cc->cc_nrpn_msb;
 		midi2->rpn.index = cc->cc_nrpn_lsb;
-		cc->nrpn_set = 0;
-		cc->cc_nrpn_msb = cc->cc_nrpn_lsb = 0;
+	} else {
+		return 0; // skip
 	}
+
 	midi2->rpn.data = upscale_14_to_32bit((cc->cc_data_msb << 7) |
 					      cc->cc_data_lsb);
+
+	cc->rpn_set = 0;
+	cc->nrpn_set = 0;
+	cc->cc_rpn_msb = cc->cc_rpn_lsb = 0;
 	cc->cc_data_msb = cc->cc_data_lsb = 0;
+	cc->cc_data_msb_set = cc->cc_data_lsb_set = 0;
+	return 1;
 }
 
 /* convert to a MIDI 1.0 Channel Voice message */
@@ -318,6 +330,7 @@ static int cvt_legacy_cmd_to_ump(struct ump_cvt_to_ump *cvt,
 	struct ump_cvt_to_ump_bank *cc;
 	union snd_ump_midi2_msg *midi2 = (union snd_ump_midi2_msg *)data;
 	unsigned char status, channel;
+	int ret;
 
 	BUILD_BUG_ON(sizeof(union snd_ump_midi1_msg) != 4);
 	BUILD_BUG_ON(sizeof(union snd_ump_midi2_msg) != 8);
@@ -358,24 +371,29 @@ static int cvt_legacy_cmd_to_ump(struct ump_cvt_to_ump *cvt,
 	case UMP_MSG_STATUS_CC:
 		switch (buf[1]) {
 		case UMP_CC_RPN_MSB:
+			ret = fill_rpn(cc, midi2, true);
 			cc->rpn_set = 1;
 			cc->cc_rpn_msb = buf[2];
-			return 0; // skip
+			return ret;
 		case UMP_CC_RPN_LSB:
+			ret = fill_rpn(cc, midi2, true);
 			cc->rpn_set = 1;
 			cc->cc_rpn_lsb = buf[2];
-			return 0; // skip
+			return ret;
 		case UMP_CC_NRPN_MSB:
+			ret = fill_rpn(cc, midi2, true);
 			cc->nrpn_set = 1;
 			cc->cc_nrpn_msb = buf[2];
-			return 0; // skip
+			return ret;
 		case UMP_CC_NRPN_LSB:
+			ret = fill_rpn(cc, midi2, true);
 			cc->nrpn_set = 1;
 			cc->cc_nrpn_lsb = buf[2];
-			return 0; // skip
+			return ret;
 		case UMP_CC_DATA:
+			cc->cc_data_msb_set = 1;
 			cc->cc_data_msb = buf[2];
-			return 0; // skip
+			return fill_rpn(cc, midi2, false);
 		case UMP_CC_BANK_SELECT:
 			cc->bank_set = 1;
 			cc->cc_bank_msb = buf[2];
@@ -385,12 +403,9 @@ static int cvt_legacy_cmd_to_ump(struct ump_cvt_to_ump *cvt,
 			cc->cc_bank_lsb = buf[2];
 			return 0; // skip
 		case UMP_CC_DATA_LSB:
+			cc->cc_data_lsb_set = 1;
 			cc->cc_data_lsb = buf[2];
-			if (cc->rpn_set || cc->nrpn_set)
-				fill_rpn(cc, midi2);
-			else
-				return 0; // skip
-			break;
+			return fill_rpn(cc, midi2, false);
 		default:
 			midi2->cc.index = buf[1];
 			midi2->cc.data = upscale_7_to_32bit(buf[2]);
-- 
2.43.0



