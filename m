Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AC6A37524E
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:59:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301567; cv=none; b=Ua4TXFxqF9i4k2/2FefD4+wvPchyl7UPzB6xSp0ikCPqzt+72a5wcp6MI2BNFwlM8jV9ywPIGCuNbE2SbzW0DB9Rp4Zz+8RmzU7SBfoPyt38N7HQNyg40cFh9mHIyEcUR4xJ6skr/4CE2n3B4pJ0A/QtnHsfsqgaUJTpj2ejzX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301567; c=relaxed/simple;
	bh=wlnoMeWexWJA2dF9SfOHwqItuv9hz4ScmW9Lp2Fq6Zc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sXpOxPE8eSinigq4cvjO6les9zaUMRIuehq3OWL7XdKqFi1530GHsCqWOoNdLCl2rub4VckxSwlrJDniclcVExwdgjLpWr6WVjsDTPNlTUXvwm3+gCmp5qgOn7EKFaeRB5gTDzVIZrGph+Gfk/g53pkY/Y+Z8hFEqcsSaQjJoLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VuDf8olK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VuDf8olK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CBA8C116D0;
	Sat, 28 Feb 2026 17:59:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301566;
	bh=wlnoMeWexWJA2dF9SfOHwqItuv9hz4ScmW9Lp2Fq6Zc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VuDf8olKIs8ppH+TR8RddGxvboZ3MsidcKgQJafsPKjQFEuTHdPHzCOk66ezu18Na
	 69U1wTDo//FiVJlHkxaiVq3QPBuOTpkN0Lmac07LYRXQqAys0sreHQUasswd/bxq3t
	 bxTIXnmYaXh4ISPrHwUXw0dCZ33ijaBChFmZ+f7zgGYMJsPcwsaJ+MbCkW0veBlXc0
	 A/HzoUGnwI9gb9adKZQ+aSAsqCWfLSL9eWShfMjXFxjuTezolP49NKgyevf9rmv38x
	 J+znP+ycwDbpfbyUtoBf9rh3lKC32bPzQfiLpM8MopcRF3ngdbIBzgwZwuvZFdgqXj
	 ryHV8K0DteoTg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Nathan Chancellor <nathan@kernel.org>,
	kernel test robot <lkp@intel.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 750/752] ALSA: pcm: Revert bufs move in snd_pcm_xfern_frames_ioctl()
Date: Sat, 28 Feb 2026 12:47:41 -0500
Message-ID: <20260228174750.1542406-750-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Nathan Chancellor <nathan@kernel.org>

[ Upstream commit 0585c53b21541cd6b17ad5ab41b371a0d52e358c ]

When building with clang older than 17 targeting architectures that use
asm goto for their get_user() and put_user(), such as arm64, after
commit f3d233daf011 ("ALSA: pcm: Relax __free() variable declarations"),
there are bogus errors around skipping over a variable declared with the
cleanup attribute:

  sound/core/pcm_native.c:3308:6: error: cannot jump from this asm goto statement to one of its possible targets
          if (put_user(result, &_xfern->result))
              ^
  ...
  arch/arm64/include/asm/uaccess.h:298:2: note: expanded from macro '__put_mem_asm'
          asm goto(
          ^
  sound/core/pcm_native.c:3295:6: note: possible target of asm goto statement
          if (put_user(0, &_xfern->result))
              ^
  ...
  sound/core/pcm_native.c:3300:8: note: jump exits scope of variable with __attribute__((cleanup))
          void *bufs __free(kfree) =
                ^

clang-17 fixed a bug in clang's jump scope checker [1] where all labels
in a function were checked as valid targets for all asm goto instances
in a function, regardless of whether they were actual targets in a
paricular asm goto's provided list of labels.

To workaround this, revert the change done to
snd_pcm_xfern_frames_ioctl() by commit f3d233daf011 ("ALSA: pcm: Relax
__free() variable declarations") to avoid a variable declared with
cleanup from existing between multiple uses of asm goto. There are no
other uses of cleanup in this function so there should be low risk from
moving this variable back to the top of the function.

Link: https://github.com/ClangBuiltLinux/linux/issues/1886 [1]
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202512190802.i4Jzbcsl-lkp@intel.com/
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Link: https://patch.msgid.link/20260106-pcm_native-revert-var-move-free-for-old-clang-v1-1-06a03693423d@kernel.org
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/pcm_native.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/core/pcm_native.c b/sound/core/pcm_native.c
index 844ee1b4d286f..0a358d94b17c6 100644
--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -3291,6 +3291,7 @@ static int snd_pcm_xfern_frames_ioctl(struct snd_pcm_substream *substream,
 {
 	struct snd_xfern xfern;
 	struct snd_pcm_runtime *runtime = substream->runtime;
+	void *bufs __free(kfree) = NULL;
 	snd_pcm_sframes_t result;
 
 	if (runtime->state == SNDRV_PCM_STATE_OPEN)
@@ -3302,8 +3303,7 @@ static int snd_pcm_xfern_frames_ioctl(struct snd_pcm_substream *substream,
 	if (copy_from_user(&xfern, _xfern, sizeof(xfern)))
 		return -EFAULT;
 
-	void *bufs __free(kfree) =
-		memdup_array_user(xfern.bufs, runtime->channels, sizeof(void *));
+	bufs = memdup_array_user(xfern.bufs, runtime->channels, sizeof(void *));
 	if (IS_ERR(bufs))
 		return PTR_ERR(bufs);
 	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK)
-- 
2.51.0

