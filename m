Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAD742222A9;
	Tue, 24 Jun 2025 04:11:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750738315; cv=none; b=G5EmoDuIxWuvBL4S2YXRrF3LcTKQqX2/ARHDN21AXKcCNwlbwTPeI1H+xLZYoe9DeCNyqN+EpsbSmICQi5ud9HlVGZ32UOcXYqERzBJIEGGsl6F+CuEOmeOU9IrAckRFKj2WLaLk4knPtMqZEM4nX5lgEJpUHhM52qZlnuq8cdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750738315; c=relaxed/simple;
	bh=Fuw5aw9Z+NPfdGQBnIQ9g26Ly4UP5Q5uofgW3uGaGTk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=JL0Un3ZiBxzSWBDXPvwmZAFiT/P495b0JIBAy/vfjFGOPe0K+uQZHyLDB74Yg4WF3Q4z+Bz1fzB5Cx4GTgTqmt4CajB5i2Ile6J5xddSBXBBE5bXtrh8LDuG1hsIFIU85Se8C1AWvKk1IBkagRvWih7P2498CHEuvwr1GZ4F8LA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=puXcf8I8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="puXcf8I8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D93CC4CEE3;
	Tue, 24 Jun 2025 04:11:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750738314;
	bh=Fuw5aw9Z+NPfdGQBnIQ9g26Ly4UP5Q5uofgW3uGaGTk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=puXcf8I84TScm3AsnxpCAoBF7S9E9tY6c/FPSeNUb5PHDZCXkH9xRY3oBLKI3qs7U
	 CksvZSBeJT2H0A5FaJH1FiBZak9s6gV3xJHnz+FVLTrLjOCBrEQAWz1hZ7eFhnoULp
	 66zxJ0ZXtCM1J16tR50+C8RDkbY9LXI9Sd+ERumumQ3VPZfmYIo8MLwVfOJMiVyhgX
	 kIi5UHJrxwUnjlXtzW/j+Iqe2xk84kcD53vbXkdixdsSt9s2NQV+SJEdUJp+/CCkX8
	 AzR4x2D/+VGxNRVvb74T6XwGOWlO3Q7ZMB8TL2eDhfKF4SFlEaycMw8xbL4BtelEaZ
	 s3FIKNOV+vQ1g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	perex@perex.cz
Subject: [PATCH AUTOSEL 6.12 04/19] ALSA: sb: Force to disable DMAs once when DMA mode is changed
Date: Tue, 24 Jun 2025 00:11:33 -0400
Message-Id: <20250624041149.83674-4-sashal@kernel.org>
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

[ Upstream commit 4c267ae2ef349639b4d9ebf00dd28586a82fdbe6 ]

When the DMA mode is changed on the (still real!) SB AWE32 after
playing a stream and closing, the previous DMA setup was still
silently kept, and it can confuse the hardware, resulting in the
unexpected noises.  As a workaround, enforce the disablement of DMA
setups when the DMA setup is changed by the kcontrol.

https://bugzilla.kernel.org/show_bug.cgi?id=218185
Link: https://patch.msgid.link/20250610064322.26787-2-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

Based on my analysis of the commit message and code changes, here is my
assessment:

**YES** - This commit should be backported to stable kernel trees.

## Extensive Explanation:

### 1. **Bug Fix Nature**
This commit fixes a real bug that causes "unexpected noises" on SB AWE32
hardware when DMA mode is changed after playing a stream. The fix
addresses a situation where "the previous DMA setup was still silently
kept, and it can confuse the hardware."

### 2. **Code Change Analysis**
The fix is minimal and surgical:
```c
if (change) {
    snd_dma_disable(chip->dma8);
    snd_dma_disable(chip->dma16);
}
```
This adds only 4 lines that disable both DMA channels when the DMA mode
control changes. The fix is:
- **Small and contained**: Only affects the `snd_sb16_dma_control_put()`
  function
- **Low risk**: Simply ensures DMA channels are disabled during mode
  switches
- **Clear purpose**: Prevents hardware confusion from stale DMA
  configurations

### 3. **Hardware Bug Context**
The kernel repository analysis reveals this is addressing a known class
of hardware issues with SB16 cards:
- The driver documents hardware bugs with DMA mode switching (lines
  14-18 in sb16_main.c)
- The hardware has separate 8-bit and 16-bit DMA channels that cannot
  mix
- Certain chip revisions have bugs where DMA transfers can block when
  switching modes

### 4. **Safety and Side Effects**
The change has minimal side effects:
- Only executes when user changes the DMA mode control
- The driver already checks for active playback/capture before allowing
  changes (`if (chip->mode & (SB_MODE_PLAYBACK | SB_MODE_CAPTURE))
  return -EBUSY;`)
- `snd_dma_disable()` is a standard ISA DMA function that safely
  disables DMA transfers
- The prepare functions already disable/enable DMAs during normal
  operation

### 5. **Stable Tree Criteria**
This meets stable tree criteria:
- **Fixes a real bug**: Users experience actual audio problems
  (unexpected noises)
- **No new features**: Pure bug fix, no feature additions
- **Minimal change**: 4 lines of straightforward code
- **Low regression risk**: Only affects legacy ISA hardware (SB16/AWE32)
- **Clear bug report**: References kernel bugzilla #218185

### 6. **Legacy Hardware Consideration**
While SB16 is legacy hardware, it's still used:
- The bug report is recent (bugzilla #218185)
- The commit message states this affects "still real!" hardware
- Linux maintains support for legacy hardware in stable trees
- The fix prevents audio corruption which significantly impacts user
  experience

The commit follows the pattern of similar audio driver fixes that were
backported (like commit #1 in the examples which fixed DMA
synchronization issues). It's a targeted fix for a specific hardware
problem with no architectural changes.

 sound/isa/sb/sb16_main.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/sound/isa/sb/sb16_main.c b/sound/isa/sb/sb16_main.c
index c4930efd44e3a..5a083eecaa6b9 100644
--- a/sound/isa/sb/sb16_main.c
+++ b/sound/isa/sb/sb16_main.c
@@ -714,6 +714,10 @@ static int snd_sb16_dma_control_put(struct snd_kcontrol *kcontrol, struct snd_ct
 	change = nval != oval;
 	snd_sb16_set_dma_mode(chip, nval);
 	spin_unlock_irqrestore(&chip->reg_lock, flags);
+	if (change) {
+		snd_dma_disable(chip->dma8);
+		snd_dma_disable(chip->dma16);
+	}
 	return change;
 }
 
-- 
2.39.5

