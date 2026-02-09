Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F9BF3019CB;
	Mon,  9 Feb 2026 12:27:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770640050; cv=none; b=A7avw6MZA1mfwywPbTjJ4uWqcMdjcxkYtctGjyU6vebJBaxqPVMNY3pT9S66R78+oxVDmw1LDJIw2uRZROhrXb3M9ng5gYOJ9GGx+K4gLmH8bK0IsfTeHiRODUuJZg0Bul4IR54wIE3i8RQqj2vOGYiJICZK5lvTcSYHWkE0q58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770640050; c=relaxed/simple;
	bh=slYrVE2AFlmO1JfMmCJ5t+dzh+XdJL5sjVfhclgpwC8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=K+iy/jX2meui8wylwK0Hhq1qRpwdO2q5N0I2/0HbiE9DwZW4qIRvjZFaQlznHDNfR4r9f+oY9+ioDswhx2iKOtK22kKDrvCOn2EJyerVFgBsilVFgpPVN+TlgRhz3BCIZxAhEnAcVlzHtZFZpaDRJssLEb61802Z9hpGDc+Ietg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nTX/cfCS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nTX/cfCS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1673AC19423;
	Mon,  9 Feb 2026 12:27:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770640050;
	bh=slYrVE2AFlmO1JfMmCJ5t+dzh+XdJL5sjVfhclgpwC8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nTX/cfCS1H5oAFr2okwWRULI2GNPEEOspASIsnKzIljl9VfVOZohlYnIkFu7J7jRg
	 4zN2VSMCvZZ0FXjicUcTnyx391eeuEQPDnVBIrUbAxrXq3VGmYNV5dM7Ra6LD2AJ1h
	 Pt3BARCyLeJrKTOfvH9RD6s0iKYnVKzox3wYRgcMbeSGpdBezCYngr/sCA3fnay9qa
	 tmJRJww9395cT2W6oRSxMaS691LeSi8kPLMltVgsM4vb3/FyEqph8AsVdlqCvlMLQ6
	 xBf56+PIoEt6Se/USy/iGZ7WiRBjemvSMKdFmegH+c1ad7Boiv5PPWzX9KenoSy1oA
	 mOwepUldBGHjw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Ziyi Guo <n7l8m4@u.northwestern.edu>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	shengjiu.wang@gmail.com,
	Xiubo.Lee@gmail.com,
	linux-sound@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 6.18-5.15] ASoC: fsl_xcvr: fix missing lock in fsl_xcvr_mode_put()
Date: Mon,  9 Feb 2026 07:26:47 -0500
Message-ID: <20260209122714.1037915-8-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260209122714.1037915-1-sashal@kernel.org>
References: <20260209122714.1037915-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.9
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ziyi Guo <n7l8m4@u.northwestern.edu>

[ Upstream commit f514248727606b9087bc38a284ff686e0093abf1 ]

fsl_xcvr_activate_ctl() has
lockdep_assert_held(&card->snd_card->controls_rwsem),
but fsl_xcvr_mode_put() calls it without acquiring this lock.

Other callers of fsl_xcvr_activate_ctl() in fsl_xcvr_startup() and
fsl_xcvr_shutdown() properly acquire the lock with down_read()/up_read().

Add the missing down_read()/up_read() calls around fsl_xcvr_activate_ctl()
in fsl_xcvr_mode_put() to fix the lockdep assertion and prevent potential
race conditions when multiple userspace threads access the control.

Signed-off-by: Ziyi Guo <n7l8m4@u.northwestern.edu>
Link: https://patch.msgid.link/20260202174112.2018402-1-n7l8m4@u.northwestern.edu
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Line 194 confirms the `lockdep_assert_held` — this will trigger a
lockdep warning when `fsl_xcvr_mode_put()` is called without the lock
held.

The function modifies `kctl->vd[0].access` (lines 205-207) and calls
`snd_ctl_notify` — without the lock, concurrent access could corrupt the
control's access flags, leading to undefined behavior.

### 3. Classification

- **Bug type**: Missing locking — race condition and lockdep assertion
  violation
- **Category**: Synchronization fix
- **This is NOT**: A feature, refactoring, or cleanup — it's purely
  adding missing synchronization

### 4. Scope and Risk Assessment

- **Lines changed**: +3 (down_read, up_read, blank line)
- **Files changed**: 1 (sound/soc/fsl/fsl_xcvr.c)
- **Risk**: Extremely low — the fix follows the exact same pattern as
  all other callers of the same function
- **Could it break anything?**: The lock is a read-lock (`down_read`),
  and `fsl_xcvr_mode_put()` is called from the ALSA control put path
  which should not hold this lock already (no deadlock risk). The other
  callers also use `down_read`, so there's no write-lock contention
  introduced.

### 5. User Impact

- **Who is affected**: Users of NXP i.MX SoCs with XCVR (audio
  transceiver) — this is used on i.MX 8MP and similar
- **Trigger**: Changing the audio mode via ALSA controls (e.g.,
  switching between SPDIF/ARC/eARC modes)
- **Symptom**: lockdep WARNING at minimum; potential data race on
  control access flags that could cause inconsistent state
- **Severity**: Medium — lockdep warnings are real bugs that indicate
  potential for corruption

### 6. Stability and Dependencies

- **Reviewed-by**: Accepted by Mark Brown (ASoC maintainer) — strong
  confidence signal
- **Dependencies**: None — this is a standalone fix. The
  `controls_rwsem` and `fsl_xcvr_activate_ctl()` function have been
  present for a long time
- **Backport difficulty**: Trivial — the patch is small and the
  surrounding code is stable

### 7. Summary

This is a textbook stable backport candidate:
- **Obviously correct**: Follows the exact same locking pattern as the 2
  other callers of the same function
- **Fixes a real bug**: Missing lock causes lockdep assertion and
  potential race condition
- **Small and contained**: 3 lines added in 1 file
- **No new features**: Pure bug fix
- **Low risk**: Read-lock addition following established pattern,
  accepted by subsystem maintainer

**YES**

 sound/soc/fsl/fsl_xcvr.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/soc/fsl/fsl_xcvr.c b/sound/soc/fsl/fsl_xcvr.c
index 58db4906a01d5..51669e5fe8888 100644
--- a/sound/soc/fsl/fsl_xcvr.c
+++ b/sound/soc/fsl/fsl_xcvr.c
@@ -223,10 +223,13 @@ static int fsl_xcvr_mode_put(struct snd_kcontrol *kcontrol,
 
 	xcvr->mode = snd_soc_enum_item_to_val(e, item[0]);
 
+	down_read(&card->snd_card->controls_rwsem);
 	fsl_xcvr_activate_ctl(dai, fsl_xcvr_arc_mode_kctl.name,
 			      (xcvr->mode == FSL_XCVR_MODE_ARC));
 	fsl_xcvr_activate_ctl(dai, fsl_xcvr_earc_capds_kctl.name,
 			      (xcvr->mode == FSL_XCVR_MODE_EARC));
+	up_read(&card->snd_card->controls_rwsem);
+
 	/* Allow playback for SPDIF only */
 	rtd = snd_soc_get_pcm_runtime(card, card->dai_link);
 	rtd->pcm->streams[SNDRV_PCM_STREAM_PLAYBACK].substream_count =
-- 
2.51.0

