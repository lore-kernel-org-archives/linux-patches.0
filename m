Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 645D61A9B24;
	Mon,  4 Aug 2025 00:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754267641; cv=none; b=KVnc+S5Rs5Hckb8kAO6wU+bvPEBgcPfmUnPLnCqUKFyo4fcVHArFeMhQ/FhaSZPeHqDY9PBXMzAltFbXUTStZYdF5mp5mSK4GuY3F9EH8AgZXrkS5wAtlJEkc+BnaZ5Tfb+1/PcGBBI0ERkyzNu8+RUcSZ+LAER9XRLHnXdz2FA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754267641; c=relaxed/simple;
	bh=RNGd4LR5JJIRL/35vtmrUevoPgZqbqjsqpTMuI97Fw0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=d3lxvvwj8p+S14ZoPc+LfqWAU3V7FsjtExqqQ0bUjBYhHdFGc+TK2dOoJGjnstTCIEIKpZrcmRkuk/ocYnP9TjszLZLNQ/w9qqk6PTQIv+cYqXvXBPNk4JHLHl6Q1MPiTvdoxZafXx3cc1rPmzgqT2vF8U4xdybNybknANYmUHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qvPlwgfP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qvPlwgfP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E6B0C4CEF0;
	Mon,  4 Aug 2025 00:33:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754267641;
	bh=RNGd4LR5JJIRL/35vtmrUevoPgZqbqjsqpTMuI97Fw0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qvPlwgfPjh//mVx5R4196VCcryXG5dZt4O4NHx0HWZp2evlBlaphE/LPTpocJWf89
	 nLvZvYNZQX2v/XWOC7BWAVSkq/HU/8FykJe1EuHMzXGuu+i0kP6C2kaXGa+/fmyIxx
	 JxY3wov1TSVYesZXonE+xA2+9zeOF5OV2UR2LyIqieIDxNoHsINO0TRalkySp6QTFf
	 2ouL4KKBiqZOqA9SGVsdCxdXCQ7JahoExGWj6TyfkhN55S3J5B1LO+y0yY27paqMPc
	 ETIrE+K/gFKum0wsYxxttGlX1ImIxgsXs2SrAqF3NmRuVbWL4iRqaQJdiD9oi97s9u
	 /cCeQf9ereOEQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	viro@zeniv.linux.org.uk,
	brauner@kernel.org,
	perex@perex.cz,
	chenyuan0y@gmail.com,
	jbrunet@baylibre.com
Subject: [PATCH AUTOSEL 6.12 65/69] ALSA: pcm: Rewrite recalculate_boundary() to avoid costly loop
Date: Sun,  3 Aug 2025 20:31:15 -0400
Message-Id: <20250804003119.3620476-65-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250804003119.3620476-1-sashal@kernel.org>
References: <20250804003119.3620476-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.41
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Christophe Leroy <christophe.leroy@csgroup.eu>

[ Upstream commit 92f59aeb13252265c20e7aef1379a8080c57e0a2 ]

At the time being recalculate_boundary() is implemented with a
loop which shows up as costly in a perf profile, as depicted by
the annotate below:

    0.00 :   c057e934:       3d 40 7f ff     lis     r10,32767
    0.03 :   c057e938:       61 4a ff ff     ori     r10,r10,65535
    0.21 :   c057e93c:       7d 49 50 50     subf    r10,r9,r10
    5.39 :   c057e940:       7d 3c 4b 78     mr      r28,r9
    2.11 :   c057e944:       55 29 08 3c     slwi    r9,r9,1
    3.04 :   c057e948:       7c 09 50 40     cmplw   r9,r10
    2.47 :   c057e94c:       40 81 ff f4     ble     c057e940 <snd_pcm_ioctl+0xee0>

Total: 13.2% on that simple loop.

But what the loop does is to multiply the boundary by 2 until it is
over the wanted border. This can be avoided by using fls() to get the
boundary value order and shift it by the appropriate number of bits at
once.

This change provides the following profile:

    0.04 :   c057f6e8:       3d 20 7f ff     lis     r9,32767
    0.02 :   c057f6ec:       61 29 ff ff     ori     r9,r9,65535
    0.34 :   c057f6f0:       7d 5a 48 50     subf    r10,r26,r9
    0.23 :   c057f6f4:       7c 1a 50 40     cmplw   r26,r10
    0.02 :   c057f6f8:       41 81 00 20     bgt     c057f718 <snd_pcm_ioctl+0xf08>
    0.26 :   c057f6fc:       7f 47 00 34     cntlzw  r7,r26
    0.09 :   c057f700:       7d 48 00 34     cntlzw  r8,r10
    0.22 :   c057f704:       7d 08 38 50     subf    r8,r8,r7
    0.04 :   c057f708:       7f 5a 40 30     slw     r26,r26,r8
    0.35 :   c057f70c:       7c 0a d0 40     cmplw   r10,r26
    0.13 :   c057f710:       40 80 05 f8     bge     c057fd08 <snd_pcm_ioctl+0x14f8>
    0.00 :   c057f714:       57 5a f8 7e     srwi    r26,r26,1

Total: 1.7% with that loopless alternative.

Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Link: https://patch.msgid.link/4836e2cde653eebaf2709ebe30eec736bb8c67fd.1749202237.git.christophe.leroy@csgroup.eu
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Based on my analysis of this commit, here's my determination:

**Backport Status: YES**

## Extensive Explanation:

This commit should be backported to stable kernel trees for the
following reasons:

### 1. **Clear Performance Fix**
The commit addresses a significant performance issue in the
`recalculate_boundary()` function. The profiling data shows:
- Original implementation: 13.2% CPU time spent in the loop
- New implementation: 1.7% CPU time (a ~7.7x improvement)

This is a substantial performance improvement for a function that's
called during PCM ioctl operations.

### 2. **Small and Contained Change**
The code change is minimal and well-contained:
- Only modifies one function (`recalculate_boundary()`)
- Adds only `#include <linux/bitops.h>` as a dependency
- The new implementation is mathematically equivalent to the old one
- Total change is about 20 lines of code

### 3. **Low Risk of Regression**
The change replaces a simple loop with bit manipulation operations:
- Old: Loop multiplying by 2 until boundary exceeds a limit
- New: Uses `__fls()` (find last set bit) to calculate the shift amount
  directly
- The logic is preserved: find the largest power-of-2 multiple of
  buffer_size that fits within the 32-bit boundary

### 4. **Affects User-Facing Performance**
This function is called from `snd_pcm_ioctl_sync_ptr_compat()`, which is
invoked during:
- 32-bit compatibility ioctl operations (`__SNDRV_PCM_IOCTL_SYNC_PTR32`)
- Audio playback/capture operations on 32-bit applications running on
  64-bit kernels
- These are common operations that directly impact audio latency and
  performance

### 5. **No Architectural Changes**
The commit:
- Doesn't change any APIs or data structures
- Doesn't modify the function's behavior or return values
- Only optimizes the algorithm used internally
- Maintains the same boundary calculation logic

### 6. **Well-Tested Code Path**
The `recalculate_boundary()` function has been stable since its
introduction for 32-bit compatibility. The mathematical equivalence of
the new implementation ensures the same boundaries are calculated, just
more efficiently.

### 7. **Follows Stable Tree Rules**
This commit aligns with stable kernel criteria:
- Fixes a real performance bug affecting users
- Is obviously correct and well-tested
- Has minimal risk of introducing new issues
- Doesn't add new features

The only minor consideration is that this is a performance optimization
rather than a correctness fix, but the significant performance impact
(13.2% → 1.7% CPU usage) in a commonly used code path makes it a
valuable backport candidate for stable kernels.

 sound/core/pcm_native.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/sound/core/pcm_native.c b/sound/core/pcm_native.c
index 0a1ba26872f8..9b91f68b3fff 100644
--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -24,6 +24,7 @@
 #include <sound/minors.h>
 #include <linux/uio.h>
 #include <linux/delay.h>
+#include <linux/bitops.h>
 
 #include "pcm_local.h"
 
@@ -3130,13 +3131,23 @@ struct snd_pcm_sync_ptr32 {
 static snd_pcm_uframes_t recalculate_boundary(struct snd_pcm_runtime *runtime)
 {
 	snd_pcm_uframes_t boundary;
+	snd_pcm_uframes_t border;
+	int order;
 
 	if (! runtime->buffer_size)
 		return 0;
-	boundary = runtime->buffer_size;
-	while (boundary * 2 <= 0x7fffffffUL - runtime->buffer_size)
-		boundary *= 2;
-	return boundary;
+
+	border = 0x7fffffffUL - runtime->buffer_size;
+	if (runtime->buffer_size > border)
+		return runtime->buffer_size;
+
+	order = __fls(border) - __fls(runtime->buffer_size);
+	boundary = runtime->buffer_size << order;
+
+	if (boundary <= border)
+		return boundary;
+	else
+		return boundary / 2;
 }
 
 static int snd_pcm_ioctl_sync_ptr_compat(struct snd_pcm_substream *substream,
-- 
2.39.5

