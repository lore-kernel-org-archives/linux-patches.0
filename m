Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA3737D414;
	Mon,  8 Apr 2024 13:37:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583469; cv=none; b=k46JmjWvMjQEHiBefvT7fS/IMc/q7obhH9ewP2yyrgfFm4Gaj8TD0gRniqnE61YRBnJEuqlP70kr/zPVpKZWEwt0Uxi1rCrrahEbBAskZLI+ZB50tyQRRU+bu7s5xEpyyPAHLToTzosAJ9/DBhYmHWHjXjiML9h3tlCXPSY/QXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583469; c=relaxed/simple;
	bh=QeoSi8vrkwftq80rPE6SUNfyH8RKkw37JG1q6Su8QQs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KcEmvDjzDCt6R6ImsoXUz4sWNM9CUF1uuOGPimNJ76GSGsPu6Bq1go2uFO+R9gxxQc+fBS4ZRRse7F6uhyGvkZFGV6m0bDPiuXSSw2OpJ9uHTmgWIsHAZDkK908LBo+A7OxMWKAaHbMbZflTiuLk0vL2HGxkn/0VvsOFQNDxuwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FlGaQRWk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FlGaQRWk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42126C433F1;
	Mon,  8 Apr 2024 13:37:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583469;
	bh=QeoSi8vrkwftq80rPE6SUNfyH8RKkw37JG1q6Su8QQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FlGaQRWkpWFsl3yVP6C4MPDBWwaOjnJNcK1tI5dq+fa8PqLvF9NP1IvADPaxXAzUZ
	 uniDGZePDQ4Yr/Oe7bVNwLQa5wsrYbN90lrYXGR6hwc9bo4pdJ9/2UkP/K+AjY7ioZ
	 nfINfxE9jWFFA+rYXufroMt3UpesPbgoBDsFC41c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oswald Buddenhagen <oswald.buddenhagen@gmx.de>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 187/252] Revert "ALSA: emu10k1: fix synthesizer sample playback position and caching"
Date: Mon,  8 Apr 2024 14:58:06 +0200
Message-ID: <20240408125312.466208475@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125306.643546457@linuxfoundation.org>
References: <20240408125306.643546457@linuxfoundation.org>
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

From: Oswald Buddenhagen <oswald.buddenhagen@gmx.de>

[ Upstream commit 03f56ed4ead162551ac596c9e3076ff01f1c5836 ]

As already anticipated in the original commit, playback was broken for
very short samples. I just didn't expect it to be an actual problem,
because we're talking about less than 1.5 milliseconds here. But clearly
such wavetable samples do actually exist.

The problem was that for such short samples we'd set the current
position beyond the end of the loop, so we'd run off the end of the
sample and play garbage.
This is a bigger (more audible) problem than the original one, which was
that we'd start playback with garbage (whatever was still in the cache),
which would be mostly masked by the note's attack phase.

So revert to the old behavior for now. We'll subsequently fix it
properly with a bigger patch series.
Note that this isn't a full revert - the dead code is not re-introduced,
because that would be silly.

Fixes: df335e9a8bcb ("ALSA: emu10k1: fix synthesizer sample playback position and caching")
Link: https://bugzilla.kernel.org/show_bug.cgi?id=218625
Signed-off-by: Oswald Buddenhagen <oswald.buddenhagen@gmx.de>
Message-ID: <20240401145805.528794-1-oswald.buddenhagen@gmx.de>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/emu10k1/emu10k1_callback.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/sound/pci/emu10k1/emu10k1_callback.c b/sound/pci/emu10k1/emu10k1_callback.c
index d36234b88fb42..941bfbf812ed3 100644
--- a/sound/pci/emu10k1/emu10k1_callback.c
+++ b/sound/pci/emu10k1/emu10k1_callback.c
@@ -255,7 +255,7 @@ lookup_voices(struct snd_emux *emu, struct snd_emu10k1 *hw,
 		/* check if sample is finished playing (non-looping only) */
 		if (bp != best + V_OFF && bp != best + V_FREE &&
 		    (vp->reg.sample_mode & SNDRV_SFNT_SAMPLE_SINGLESHOT)) {
-			val = snd_emu10k1_ptr_read(hw, CCCA_CURRADDR, vp->ch) - 64;
+			val = snd_emu10k1_ptr_read(hw, CCCA_CURRADDR, vp->ch);
 			if (val >= vp->reg.loopstart)
 				bp = best + V_OFF;
 		}
@@ -362,7 +362,7 @@ start_voice(struct snd_emux_voice *vp)
 
 	map = (hw->silent_page.addr << hw->address_mode) | (hw->address_mode ? MAP_PTI_MASK1 : MAP_PTI_MASK0);
 
-	addr = vp->reg.start + 64;
+	addr = vp->reg.start;
 	temp = vp->reg.parm.filterQ;
 	ccca = (temp << 28) | addr;
 	if (vp->apitch < 0xe400)
@@ -430,9 +430,6 @@ start_voice(struct snd_emux_voice *vp)
 		/* Q & current address (Q 4bit value, MSB) */
 		CCCA, ccca,
 
-		/* cache */
-		CCR, REG_VAL_PUT(CCR_CACHEINVALIDSIZE, 64),
-
 		/* reset volume */
 		VTFT, vtarget | vp->ftarget,
 		CVCF, vtarget | CVCF_CURRENTFILTER_MASK,
-- 
2.43.0



