Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3849343F4D2;
	Thu, 30 Jul 2026 14:21:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421281; cv=none; b=mJTR4oyfp4xe3Ytu1Pf17IHbPuDsMdR/4OZXiTMP/zC42WTLalDCwdDfpuSAvAsHsW0omJXaTFOqfzwqCKoJk4CCSdc+x9mOLKttGkGcLTGO3H4GpxNFTJkmEk/cVNrHQEEEBGXU2/F8SGaYFp7kgt1yyWAFxugtYgRtxFL9Psg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421281; c=relaxed/simple;
	bh=8LIn8GiOulxTsKaMvhjgsW19H99sYwENRXCh9l3G5D4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PUgKFI0mjJv4Ar2OrHvwxnwxnSxJ2e8GV7/HBH4Qy2gAOOA7yXhfNGw5hhyGqMmnpya33ziOMKMxC2Av+0PiIcQzTz8vViDPMBEc/3sgrc9rmpW/1KzDJDUlbkPd8CStw1U2U4O1BcQXLP99qUTW6tOqYHbke0iBPQwPVVC/lX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lmvXJnx/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lmvXJnx/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56EAF1F000E9;
	Thu, 30 Jul 2026 14:21:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421272;
	bh=kGGzgoIDsQus6/wbIOpuo3jCO5KyRj7iHjZzjt5Bn8s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lmvXJnx/CGztkKdF4G328Mmzb51NtV6F2oT82oFc5C7DCBhwjxcTokPBUzBQ5AbvU
	 BPlDBdtPeQ3ytgUXuVZCKvZQXFkgGdXPKJPtpLBo1Hnzq7F45uu+0ttGtwm1HYx8I3
	 t/eif95WaoG3Yv9ObJjDIfOyRiotTt10gEH1jswo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rong Zhang <i@rong.moe>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 049/744] ALSA: usb-audio: Fix imbalance per-channel volume of sticky mixers
Date: Thu, 30 Jul 2026 16:05:22 +0200
Message-ID: <20260730141445.322297518@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rong Zhang <i@rong.moe>

[ Upstream commit ea588e4c7484ea883d3dab308f1f2c2f0f51f7d6 ]

I accidentally made an off-by-a-line mistake when mimicking other code
paths that set all channels. The mistake breaks sticky mixers with
multiple channels.

I didn't realize this mistake at that time, as my device's mixer is
single-channel.

Fix it, so that per-channel volume of sticky mixers is balanced.

Fixes: aa2f4addab44 ("ALSA: usb-audio: Set the value of potential sticky mixers to maximum")
Signed-off-by: Rong Zhang <i@rong.moe>
Link: https://patch.msgid.link/20260706-uac-sticky-channels-fix-v1-1-92741c538283@rong.moe
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/mixer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/usb/mixer.c b/sound/usb/mixer.c
index fb37bb8ad9a9a6..dbcefcaf7c3612 100644
--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -1447,8 +1447,8 @@ static int get_min_max_with_quirks(struct usb_mixer_elem_info *cval,
 	if (!cval->cmask) {
 		snd_usb_set_cur_mix_value(cval, 0, 0, cval->max);
 	} else {
+		idx = 0;
 		for (i = 0; i < MAX_CHANNELS; i++) {
-			idx = 0;
 			if (cval->cmask & BIT(i)) {
 				snd_usb_set_cur_mix_value(cval, i + 1, idx, cval->max);
 				idx++;
-- 
2.53.0



