Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 227102248B0;
	Tue, 24 Jun 2025 04:11:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750738313; cv=none; b=jLFCEO5G+fSDVtLmgcARPzrII8eLHZ+b6/DSk/mDvZGgiser+4fgDN2YxvFjyH0pTf3pUkSxoB/wSoEmjN50fbKeJkdGzfqg0c+VlgIPGbJCs2Zk1Vu+O/MsdMXThrFuSNPGUxSb/k42rmDkCkPeNqmFXy1mR/90Lh20kuO/Dqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750738313; c=relaxed/simple;
	bh=5wc6WxSmEFH9oULUCiFzSCfKbTl0q6N8kAB6yyfyVH4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=EH+htk6jw5x7Kp6jJSDFcbj0lY561uT/OCztZg/8Tx1JvR8q2Pj3L6Y5pjFCd8JCHyDuyLlMjLiiLzBvxTybyw2UkpbGP8VQwXhUYPhe0UjtmbWWQLdjBWEVEphhAbTs8SRYToT9PICGhDNI32AbfnD9EtIIpwmDeTS4snNKgME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Db8NqbcA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Db8NqbcA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64817C4CEE3;
	Tue, 24 Jun 2025 04:11:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750738312;
	bh=5wc6WxSmEFH9oULUCiFzSCfKbTl0q6N8kAB6yyfyVH4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Db8NqbcA4h9/taEdXMD6KDlPyfM2ovp0OMTtfb52i8/j4pLxij2sl3RlnpgulBq/X
	 pN/wQDY69hWbeq3MHbSyMY6vi2UjUxCWbEOh87vkfGzCEPfCk5IwA7NUaMQjG6ViT6
	 +syCSyt4UgKd9yUkqjQe3lgvWKFeBKmgnayUnSlQ3/D3KsWkJ3Floqe0wVViS4a5yE
	 h5/xxOSNn8IxLxaK8OczWaUuxgZr0Br5AAJ7v0T/PG8H6o7nGpgT460yGbgXoFJQjy
	 YmU2ZLbpN3cPddnrgGmScL10WcsAs766KeRvhZC3ohyVPKVrYDIeorcaE1j4qxUmqD
	 1axAS41byXtXw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	perex@perex.cz
Subject: [PATCH AUTOSEL 6.12 03/19] ALSA: sb: Don't allow changing the DMA mode during operations
Date: Tue, 24 Jun 2025 00:11:32 -0400
Message-Id: <20250624041149.83674-3-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250624041149.83674-1-sashal@kernel.org>
References: <20250624041149.83674-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.34
Content-Transfer-Encoding: 8bit

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit ed29e073ba93f2d52832804cabdd831d5d357d33 ]

When a PCM stream is already running, one shouldn't change the DMA
mode via kcontrol, which may screw up the hardware.  Return -EBUSY
instead.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=218185
Link: https://patch.msgid.link/20250610064322.26787-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

**YES**

This commit should be backported to stable kernel trees. Here's my
extensive analysis:

## Key Reasons for Backporting:

1. **Critical Bug Fix for Race Condition**: The commit fixes a race
   condition where changing DMA mode via kcontrol while PCM streams are
   running can corrupt hardware state. Looking at the code:
   - The `chip->mode` field tracks active playback/capture operations
     using `SB_MODE_PLAYBACK` and `SB_MODE_CAPTURE` flags
   - The DMA mode control (`force_mode16`) affects how DMA transfers are
     configured
   - Changing this while streams are active can cause hardware
     inconsistencies

2. **Clear User-Visible Bug**: The commit references Bugzilla #218185,
   indicating this is a real user-reported issue that affects system
   stability and audio functionality.

3. **Minimal and Contained Fix**: The change is extremely small and
   focused:
  ```c
  +       if (chip->mode & (SB_MODE_PLAYBACK | SB_MODE_CAPTURE))
  +               return -EBUSY;
  ```
  It simply adds a check to prevent mode changes during active
  operations, returning -EBUSY to userspace.

4. **No Architectural Changes**: This is a straightforward defensive
   check that doesn't alter any core functionality or introduce new
   features. It only prevents an invalid operation.

5. **Low Risk of Regression**: The fix:
   - Only affects the SB16 sound driver
   - Only changes behavior when someone tries to modify DMA mode during
     active streaming
   - Returns a standard error code (-EBUSY) that applications should
     already handle
   - Doesn't affect normal audio operations

6. **Follows Stable Kernel Rules**: This perfectly matches stable kernel
   criteria:
   - Fixes a real bug that affects users
   - Obviously correct with no subtleties
   - Small change (2 lines of actual code)
   - Already tested in mainline
   - No new features added

## Technical Analysis:

From examining the code flow:
- During `snd_sb16_playback_open()` and `snd_sb16_capture_open()`, the
  driver sets `chip->mode` flags
- These flags remain set until `snd_sb16_playback_close()` and
  `snd_sb16_capture_close()` clear them
- The `force_mode16` setting affects DMA channel selection throughout
  the driver
- Without this fix, userspace can change `force_mode16` while DMA
  operations are active, potentially causing:
  - DMA channel mismatches
  - Audio corruption
  - System instability

This is similar to the first example commit that was backported, which
also prevented operations during inappropriate states (DMA
synchronization during PAUSE state).

 sound/isa/sb/sb16_main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/isa/sb/sb16_main.c b/sound/isa/sb/sb16_main.c
index 74db115250030..c4930efd44e3a 100644
--- a/sound/isa/sb/sb16_main.c
+++ b/sound/isa/sb/sb16_main.c
@@ -703,6 +703,9 @@ static int snd_sb16_dma_control_put(struct snd_kcontrol *kcontrol, struct snd_ct
 	unsigned char nval, oval;
 	int change;
 	
+	if (chip->mode & (SB_MODE_PLAYBACK | SB_MODE_CAPTURE))
+		return -EBUSY;
+
 	nval = ucontrol->value.enumerated.item[0];
 	if (nval > 2)
 		return -EINVAL;
-- 
2.39.5

