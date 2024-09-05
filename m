Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F91F198E89;
	Thu,  5 Sep 2024 09:53:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725530029; cv=none; b=n5EIndjx22r4kpEz2IhbXi4C8kmdL4WlI55SkxBbba3ga47X7SD96ZH87S5+8rei+soN36zdG3AzWS6WKkdVF1fUx6VKUTlZSzPwRMHHRgk9KwR+FxEeQcmp+xBNxa7unVu3KYp3oJdqd3dnaP673sivr8Lpuabwmb6KjcTBqnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725530029; c=relaxed/simple;
	bh=zmPjhsokOqE2OSL7NscQDa1BbuojYlMTwN1aQMjFnRI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C2Z+rNsJYhqFf8EndhyPfRTu6TMk+IL9EjQEIpnIWLqqFxYU2XpbPxUHK7wPe+iiCotwtgC6YyIBkiUGwHfhtLSQVLNY36xQxO9BiGE4m2GQWkW4HTh59j2uQDQN7TpXyp0ODYm4GIW8xmXQ1hpYjm9ed16ZMOrYY9RwXm9aqPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mo5ptqNV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mo5ptqNV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7D22C4CEC3;
	Thu,  5 Sep 2024 09:53:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725530029;
	bh=zmPjhsokOqE2OSL7NscQDa1BbuojYlMTwN1aQMjFnRI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mo5ptqNVTz3hfZjaKxUQ7MnJpQCV04ER4DId+WIDrBYGx8gmAQiChpSTyvW8UEu9Q
	 Uy4YwisZdZNpP0CF2Z8uoX7N+92D0/V8l2gSe9vXMqg4UuImHx23+E9zs2XwmVlged
	 08zRwbdEhxulFklSu0amsD9VhWOfPJY0B06YRQ64=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 009/132] ALSA: ump: Explicitly reset RPN with Null RPN
Date: Thu,  5 Sep 2024 11:39:56 +0200
Message-ID: <20240905093722.596679316@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093722.230767298@linuxfoundation.org>
References: <20240905093722.230767298@linuxfoundation.org>
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



