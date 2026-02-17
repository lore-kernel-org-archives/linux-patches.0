Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07AD8274B4A;
	Tue, 17 Feb 2026 01:01:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771290088; cv=none; b=RMcD/qBA167mSnqiSfJrHaSk87qXRAGiE/kfIEFmDzsQDwb6hcLD/bAQ91rTR4ft4ZjZHZ0rKlHf8bx4TCfRK/W510OIaDk1zWA2dn0RLdQ2p/tJA6iYmwZC/IrSY6fKC5loLKtgy5XPjYg2SYIICG4FG/BfjDQfw0qQ+duoEJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771290088; c=relaxed/simple;
	bh=5A/TcNE2nbiBSpB6QpU3prs9NlE3Ibbyi7+LGPCUg+g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DDmb8moDu+9FCONblLzH3aOWwiL9KBAVpB76FhPs8BcQOCqPzc8go4h7iFsT6/QFTp6Ivkqb5OgqvpYjbaqSWujFL3i5hoxJ971gzNXGFnVyVpoCROe5VOVwyNvaicN9dE2pLvjPRvY1bzDJRkdF9p6lsbwO2Xj9SkcoyMh39Ec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B46nS4CD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B46nS4CD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E954DC4AF09;
	Tue, 17 Feb 2026 01:01:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771290087;
	bh=5A/TcNE2nbiBSpB6QpU3prs9NlE3Ibbyi7+LGPCUg+g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B46nS4CDDJRuI6yRjYBn4NJL6H8JKxCbrsj5Ww/+SDqQpUweYfje3cP9OokolvuIE
	 6PGPZ4NCfgpH87VNnAcvOBWZgX3as11o7SRcM2MdqvMhMLcIhMqOl6CT7qrT2bO5WX
	 nmYeymkp/bRXHbyODYGerRvic2em9gOISyAz1X6fOAiNOPa0WJ8z4BA5cXQ62qM1HJ
	 7N/83SAUIMDNVFPvVs11cvXG3rgwHSyMWF2tC45ikxKaeel/Bv7Bss0A3Ihmr0C3fD
	 toOZBuvgcLiBw4vs8aMaZIv51tDrTU0DwLcATzqPtv9O5SPTr8JbxXaXXTnR/GuOKE
	 1De8wWSxzx2jw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Daniel Palmer <daniel@thingy.jp>,
	Greg Ungerer <gerg@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	geert@linux-m68k.org,
	linux-m68k@lists.linux-m68k.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-5.10] m68k: nommu: fix memmove() with differently aligned src and dest for 68000
Date: Mon, 16 Feb 2026 20:01:17 -0500
Message-ID: <20260217010118.3503621-6-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260217010118.3503621-1-sashal@kernel.org>
References: <20260217010118.3503621-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Daniel Palmer <daniel@thingy.jp>

[ Upstream commit 590fe2f46c8698bb758f9002cb247ca10ce95569 ]

68000 has different alignment needs to 68020+.
memcpy() checks if the destination is aligned and does a smaller copy
to fix the alignment and then critically for 68000 it checks if the
source is still unaligned and if it is reverts to smaller copies.

memmove() does not currently do the second part and malfunctions if
one of the pointers is aligned and the other isn't.

This is apparently getting triggered by printk. If I put breakpoints
into the new checks added by this commit the first hit looks like this:

memmove (n=205, src=0x2f3971 <printk_shared_pbufs+205>, dest=0x2f3980 <printk_shared_pbufs+220>) at arch/m68k/lib/memmove.c:82

Signed-off-by: Daniel Palmer <daniel@thingy.jp>
Signed-off-by: Greg Ungerer <gerg@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This file has existed since 2011, so it's in all current stable trees.
Let me also verify the CONFIG_M68000 check in memcpy to confirm the
pattern.

## Summary of Analysis

### Problem Being Fixed
On 68000 CPUs (CONFIG_M68000), `memmove()` performs word and long-word
memory accesses through a source pointer that may be at an odd address.
The 68000 CPU (unlike 68020+) generates an **address error exception**
(essentially a bus error/crash) on unaligned word or long-word accesses.

The existing `memcpy()` implementation already handles this correctly:
after aligning the destination pointer, it checks if the source is still
misaligned and falls back to byte-by-byte copy. The `memmove()`
implementation was missing this identical check.

### Real-World Impact
The commit message explicitly states this is triggered by `printk` — one
of the most fundamental kernel functions. This means:
- **Any kernel message output** on a 68000 system can crash the kernel
- The bug is easily triggered in normal operation
- It affects basic kernel boot and operation

### Code Change Assessment
- **Size**: +18 lines (two identical 9-line blocks for forward and
  backward copy paths)
- **Scope**: Single file, single function, architecture-specific
  (`CONFIG_M68000` only)
- **Pattern**: Exactly mirrors existing, tested `memcpy()` code
- **Risk**: Very low — the added code is conditionally compiled only for
  CONFIG_M68000, and follows an established pattern already used in
  `memcpy.c`
- **No new features**: This is purely a bug fix bringing `memmove()` to
  parity with `memcpy()`

### Stable Kernel Rules Compliance
1. **Obviously correct and tested**: Yes — mirrors `memcpy()` and author
   shows concrete triggering example
2. **Fixes a real bug**: Yes — unaligned access causes CPU
   exception/crash on 68000
3. **Fixes an important issue**: Yes — crashes on basic `printk`
   operations
4. **Small and contained**: Yes — 18 lines, single file, single
   function, only affects CONFIG_M68000
5. **No new features**: Correct — this is a bug fix only
6. **Clean application**: The file has minimal history, so this should
   apply cleanly to any stable tree

### Verification

- **Verified** that `memcpy.c` (lines 25-32) already has the identical
  `CONFIG_M68000` alignment fallback pattern that this patch adds to
  `memmove.c`
- **Verified** that `memmove.c` (the unpatched version read above) is
  missing this check — after aligning `dest`, it proceeds directly to
  word/long copies without checking `src` alignment
- **Verified** that the file `arch/m68k/lib/memmove.c` was originally
  added in commit 982cd252ca0b6 (2011), meaning it exists in all current
  stable kernel trees
- **Verified** the patch adds two `#if defined(CONFIG_M68000)` blocks,
  one for each copy direction (forward and backward), matching the
  structure of the existing `memcpy()` fix
- **Verified** via `git log` that this file has had very few changes
  since creation (only 2 commits in history: original creation and a
  dedup cleanup), meaning it should apply cleanly
- **Unverified**: Exact stable tree versions affected — but since the
  file dates to 2011 and the bug has existed since then, all current
  stable trees are affected

### Risk vs. Benefit
- **Risk**: Extremely low. The change is guarded by `#if
  defined(CONFIG_M68000)`, affects only 68000 CPUs, and mirrors proven
  code from `memcpy()`
- **Benefit**: Prevents crashes on a fundamental kernel operation
  (`printk` → `memmove`) on all 68000 systems

This is a clear, well-understood bug fix for a crash that affects basic
kernel operation on 68000 platforms. It's small, surgical, follows an
established pattern, and has zero risk to non-68000 systems.

**YES**

 arch/m68k/lib/memmove.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/arch/m68k/lib/memmove.c b/arch/m68k/lib/memmove.c
index 6519f7f349f66..e33f00b02e4c0 100644
--- a/arch/m68k/lib/memmove.c
+++ b/arch/m68k/lib/memmove.c
@@ -24,6 +24,15 @@ void *memmove(void *dest, const void *src, size_t n)
 			src = csrc;
 			n--;
 		}
+#if defined(CONFIG_M68000)
+		if ((long)src & 1) {
+			char *cdest = dest;
+			const char *csrc = src;
+			for (; n; n--)
+				*cdest++ = *csrc++;
+			return xdest;
+		}
+#endif
 		if (n > 2 && (long)dest & 2) {
 			short *sdest = dest;
 			const short *ssrc = src;
@@ -66,6 +75,15 @@ void *memmove(void *dest, const void *src, size_t n)
 			src = csrc;
 			n--;
 		}
+#if defined(CONFIG_M68000)
+		if ((long)src & 1) {
+			char *cdest = dest;
+			const char *csrc = src;
+			for (; n; n--)
+				*--cdest = *--csrc;
+			return xdest;
+		}
+#endif
 		if (n > 2 && (long)dest & 2) {
 			short *sdest = dest;
 			const short *ssrc = src;
-- 
2.51.0

