Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4E0C1925AA;
	Thu,  5 Sep 2024 09:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725529375; cv=none; b=NyLj8so27VuF4zmeZluJ6rHsHUNvrJ0uhhU370SRF7tj7HoXQlJxHAy2MA7uRmOa6kPmjA9HQsntUBadNqPzlElGC7wcd2gzywOxFuq8CUK/+FDq+iCz7g43O9uTogTlfv4009Vy0mGPH5cdCn8EJyiL0HkNROhq8IHuXAwzxo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725529375; c=relaxed/simple;
	bh=vwuyAgN3q4P6uHV6hCGlizgkHVl75mjse+z9dRk4IzM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O0Tqz4Vja+3Rq0JgnX4CZ3hgJKn2ixjF+Y+zGdrVhCFj7iU/tLkVr6kkgNvoI2+KLSijJZIfyqbv5/krABiUAUgvGGEJYSQwm9ckRNfPne3wgfjGPJ9YICGPxzs1zOC9c3hAYD/inR14fz29RO/1BL8goqCTNv/NjfBzPQkHGYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oYHIlyz3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oYHIlyz3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A644DC4CEC3;
	Thu,  5 Sep 2024 09:42:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725529375;
	bh=vwuyAgN3q4P6uHV6hCGlizgkHVl75mjse+z9dRk4IzM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oYHIlyz3Y4XvwPU2hftl5Oc6mA4lYT+E5zI0maCQ2dMGW9ipjzg2WbAzzK/fjjGFR
	 6/qbrHK8Qg3nKfcPWiMGQcysBgF6icQztA0ySBXeMgTzRAagux7jWckNT04TBgamfd
	 5FpWs8ITGOwq02/sNS2jnMw14wOyhIIccRjuUzj0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 013/184] ALSA: seq: ump: Explicitly reset RPN with Null RPN
Date: Thu,  5 Sep 2024 11:38:46 +0200
Message-ID: <20240905093732.759672182@linuxfoundation.org>
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

[ Upstream commit 98ea612dd1150adb61cd2a0e93875e1cc77e6b87 ]

RPN with 127:127 is treated as a Null RPN, just to reset the
parameters, and it's not translated to MIDI2.  Although the current
code can work as is in most cases, better to implement the RPN reset
explicitly for Null message.

Link: https://patch.msgid.link/20240731130528.12600-6-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/seq/seq_ump_convert.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/sound/core/seq/seq_ump_convert.c b/sound/core/seq/seq_ump_convert.c
index 7ca62667f28d3..4dd540cbb1cbb 100644
--- a/sound/core/seq/seq_ump_convert.c
+++ b/sound/core/seq/seq_ump_convert.c
@@ -789,6 +789,15 @@ static int paf_ev_to_ump_midi2(const struct snd_seq_event *event,
 	return 1;
 }
 
+static void reset_rpn(struct ump_cvt_to_ump_bank *cc)
+{
+	cc->rpn_set = 0;
+	cc->nrpn_set = 0;
+	cc->cc_rpn_msb = cc->cc_rpn_lsb = 0;
+	cc->cc_data_msb = cc->cc_data_lsb = 0;
+	cc->cc_data_msb_set = cc->cc_data_lsb_set = 0;
+}
+
 /* set up the MIDI2 RPN/NRPN packet data from the parsed info */
 static int fill_rpn(struct ump_cvt_to_ump_bank *cc,
 		    union snd_ump_midi2_msg *data,
@@ -817,11 +826,7 @@ static int fill_rpn(struct ump_cvt_to_ump_bank *cc,
 					     cc->cc_data_lsb);
 	data->rpn.channel = channel;
 
-	cc->rpn_set = 0;
-	cc->nrpn_set = 0;
-	cc->cc_rpn_msb = cc->cc_rpn_lsb = 0;
-	cc->cc_data_msb = cc->cc_data_lsb = 0;
-	cc->cc_data_msb_set = cc->cc_data_lsb_set = 0;
+	reset_rpn(cc);
 	return 1;
 }
 
@@ -843,11 +848,15 @@ static int cc_ev_to_ump_midi2(const struct snd_seq_event *event,
 		ret = fill_rpn(cc, data, channel, true);
 		cc->rpn_set = 1;
 		cc->cc_rpn_msb = val;
+		if (cc->cc_rpn_msb == 0x7f && cc->cc_rpn_lsb == 0x7f)
+			reset_rpn(cc);
 		return ret;
 	case UMP_CC_RPN_LSB:
 		ret = fill_rpn(cc, data, channel, true);
 		cc->rpn_set = 1;
 		cc->cc_rpn_lsb = val;
+		if (cc->cc_rpn_msb == 0x7f && cc->cc_rpn_lsb == 0x7f)
+			reset_rpn(cc);
 		return ret;
 	case UMP_CC_NRPN_MSB:
 		ret = fill_rpn(cc, data, channel, true);
@@ -961,6 +970,8 @@ static int ctrl14_ev_to_ump_midi2(const struct snd_seq_event *event,
 		cc->cc_rpn_msb = msb;
 		cc->cc_rpn_lsb = lsb;
 		cc->rpn_set = 1;
+		if (cc->cc_rpn_msb == 0x7f && cc->cc_rpn_lsb == 0x7f)
+			reset_rpn(cc);
 		return ret;
 	case UMP_CC_NRPN_MSB:
 	case UMP_CC_NRPN_LSB:
-- 
2.43.0



