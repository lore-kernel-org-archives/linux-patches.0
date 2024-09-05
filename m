Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CA681925AA;
	Thu,  5 Sep 2024 09:42:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725529365; cv=none; b=OIU47mBu1PY6x2ThGj+bad9FLXHuc3D1LBcmILZJDKPW+BpGNpHB8yB03mIiuCVlE1wJ5tmnHrIFUlfboO1UCzZQlWdhESazRQ+j83MJTUsvTp5j2UHygoVGE9THWSHXzXubzTBZHEcFMEPcHHwQNKxj3TUdxhQfYjVrqRx/Kr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725529365; c=relaxed/simple;
	bh=jHWrfgaA+voy6MkLJbVcqeRjZzeyutX6XRs/dXgWHPI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sA9b8Qffs4qUOHI8HSGXh0EOeUm77jK2nSpjHHlg9PM3RhDX/qYLod5OJPwOrwusnqc9PaT3N4JSl0cHMTMEJzVGtMZ4gmmpv9Na9/f6YhEpRWIQNf4cG63oQW7lM29s/WgF2LZAQOu+XIGVtMba7Zp8E97BrzJ3t7pDJoXg5nA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VopJ5dgy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VopJ5dgy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77758C4CEC3;
	Thu,  5 Sep 2024 09:42:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725529364;
	bh=jHWrfgaA+voy6MkLJbVcqeRjZzeyutX6XRs/dXgWHPI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VopJ5dgyNTMkno6K9mO4YUIILLH+L9LN+FoOrNFeA3jRg7ek9GBOwE1g+WDZk0CHe
	 l8XQXG+doadF96yqEQhscBQzdDMP229gP+Ooo5BzPCN3LjJ0AHHr2sCIEFNcfbG5Q7
	 VxOBa98fVEV1V5P0TSstJ/eL2lMt9iul57vWNt7o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 010/184] ALSA: ump: Explicitly reset RPN with Null RPN
Date: Thu,  5 Sep 2024 11:38:43 +0200
Message-ID: <20240905093732.642056588@linuxfoundation.org>
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

[ Upstream commit 50a6dd19dca9446475f023eaa652016bfe5b1cbe ]

RPN with 127:127 is treated as a Null RPN, just to reset the
parameters, and it's not translated to MIDI2.  Although the current
code can work as is in most cases, better to implement the RPN reset
explicitly for Null message.

Link: https://patch.msgid.link/20240731130528.12600-3-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/ump_convert.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/sound/core/ump_convert.c b/sound/core/ump_convert.c
index 5d1b85e7ac165..0fe13d0316568 100644
--- a/sound/core/ump_convert.c
+++ b/sound/core/ump_convert.c
@@ -287,6 +287,15 @@ static int cvt_legacy_system_to_ump(struct ump_cvt_to_ump *cvt,
 	return 4;
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
 static int fill_rpn(struct ump_cvt_to_ump_bank *cc,
 		    union snd_ump_midi2_msg *midi2,
 		    bool flush)
@@ -312,11 +321,7 @@ static int fill_rpn(struct ump_cvt_to_ump_bank *cc,
 	midi2->rpn.data = upscale_14_to_32bit((cc->cc_data_msb << 7) |
 					      cc->cc_data_lsb);
 
-	cc->rpn_set = 0;
-	cc->nrpn_set = 0;
-	cc->cc_rpn_msb = cc->cc_rpn_lsb = 0;
-	cc->cc_data_msb = cc->cc_data_lsb = 0;
-	cc->cc_data_msb_set = cc->cc_data_lsb_set = 0;
+	reset_rpn(cc);
 	return 1;
 }
 
@@ -374,11 +379,15 @@ static int cvt_legacy_cmd_to_ump(struct ump_cvt_to_ump *cvt,
 			ret = fill_rpn(cc, midi2, true);
 			cc->rpn_set = 1;
 			cc->cc_rpn_msb = buf[2];
+			if (cc->cc_rpn_msb == 0x7f && cc->cc_rpn_lsb == 0x7f)
+				reset_rpn(cc);
 			return ret;
 		case UMP_CC_RPN_LSB:
 			ret = fill_rpn(cc, midi2, true);
 			cc->rpn_set = 1;
 			cc->cc_rpn_lsb = buf[2];
+			if (cc->cc_rpn_msb == 0x7f && cc->cc_rpn_lsb == 0x7f)
+				reset_rpn(cc);
 			return ret;
 		case UMP_CC_NRPN_MSB:
 			ret = fill_rpn(cc, midi2, true);
-- 
2.43.0



