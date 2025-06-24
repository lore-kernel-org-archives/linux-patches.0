Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CB9F223DC6;
	Tue, 24 Jun 2025 04:12:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750738340; cv=none; b=TzGvxGNcBKYK+C1oJSCesWdJe9GMEZaww25lF/5+FQ0oNsEFgz5Gz6eGD8f20P8+8hy7kSNAIw9hx56urO9T8JJNMOBIavoyZ+zu24J/Tzwvjydb0v9RDyEWuBj31ltypVz5B1/kESjcgwF+7lF+v63sACXGnMoqQ4HKwkkjiIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750738340; c=relaxed/simple;
	bh=NY4w0ySqVXa7gGOIoo3AUDtVMnjiiW8QxUeTpQaevFw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=VOHrLfpeEyfZvQcX89UrQSBtZ5rJkwKAiSLZCBrN0PWUE2eA4cUgPhuiw4kBWe0REGN5sFjvdjzmZakO7BUMZkoPJ2Oc5uZyxDZ64zkH47QIHFeMFl8qMzhP0TkaYF0h6g7bUoXY+7hLd7TrKYaugUBzr9CtEKHbOpuV9sJPuPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sk4mNYv0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sk4mNYv0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1CB9C4CEF2;
	Tue, 24 Jun 2025 04:12:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750738340;
	bh=NY4w0ySqVXa7gGOIoo3AUDtVMnjiiW8QxUeTpQaevFw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sk4mNYv0homEX7hD2XClgcDUcAePyw2A45fe2+rMlO9wI5tlMqqRhs791NycwJf+y
	 dbGe5FLOCPu+ygUKIxUBpFrH6lkx5WBJcF2lJumbANilojrOXbsCmdWzvyXUbKwHC9
	 zX+vj+xOMiNn6J9C/GbYAQZVyp9yI45dd35oyBIrwv0jtSH69b7UJiKnIpHcDKxOtt
	 G4+I8ARJuUoFliBKpaCDxak4Hm0w1V9AxiEhh1SIqYh7TRPttKbzdtNkDFeXkOibE+
	 Yb6uFV9CYzl0f47BrvrTSEgGqUi3HH8j0PEmWH22oZT96/T6eEKbaLy5/i+zu90xOl
	 RgFKjnlsgyvpg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	perex@perex.cz
Subject: [PATCH AUTOSEL 6.6 04/18] ALSA: sb: Force to disable DMAs once when DMA mode is changed
Date: Tue, 24 Jun 2025 00:12:00 -0400
Message-Id: <20250624041214.84135-4-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250624041214.84135-1-sashal@kernel.org>
References: <20250624041214.84135-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.6.94
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
index 5efbd0a41312b..1497a7822eee6 100644
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

