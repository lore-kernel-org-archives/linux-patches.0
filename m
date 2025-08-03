Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BAA71F91D6;
	Sun,  3 Aug 2025 21:22:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754256139; cv=none; b=Snaz1G+SbuHiHlB6xVnpSIHdsv4dambaCoTF/W/eEKPTH6Nz50MYkrFlHAf9aSJ+z+HX1pFYZaitQI9uWvJrP0pVdS0Wjo7G5yQleLeIuaWtDVBRiZ2iW/pPVnA+Kvv47gleqlhm+D0//7ak8VJzlPDjgXpDfFaEouMnwbaRKZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754256139; c=relaxed/simple;
	bh=2vOuYJ+UoTSDXkCQHdn0iirmTd0W+dceISOgkSrRgEw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=LElJcdsmbIzrJ6QgsZbTwJ3xZj6MyQhxfSLgpAeglt4lqj+8JOAk0fHC9HiS9m072a3nYN51+3lBgG7GJfxZJo0spr0/CWNPnmiuhvEsGvl4771wfwIBCiJNJbhQrEmFptkf4zE6ilChHEO6cJoZbSLCwiernv6QQ89aZIOsMp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qiKL2OpH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qiKL2OpH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 359C4C4CEEB;
	Sun,  3 Aug 2025 21:22:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754256139;
	bh=2vOuYJ+UoTSDXkCQHdn0iirmTd0W+dceISOgkSrRgEw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qiKL2OpHHKZcpoOevFhnBsasdcCeF5DryfAqSvStdKRYwbLwibgt+MqssAgPmy6Ng
	 oebSv2g1VNs4Isd/4lF2O+/dTa3G006rHX6PNWdzI7kdxxhoGC4Q2FeEIckXusamfx
	 yhIwW01OS0P78uVdx3aOmBdXpE5o3gAOfaQB+Yc8EuKjVLDU1V2XSSzbtqwTWrQvx3
	 BtwDByFa3+ecfOLhAwaoPBCbheeGmjJk3je65E3yzjxXNUvzblCgA5WKtl1ly5FkGl
	 gXiaz2EOL83J19MWVlaxZTT5rDEuzMjb1jUKbhwMBVlSw1owZ1ckYRrjSC9fUClus9
	 hxztAKdXOoXkQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Kees Cook <kees@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.15 05/15] arm64: Handle KCOV __init vs inline mismatches
Date: Sun,  3 Aug 2025 17:21:55 -0400
Message-Id: <20250803212206.3548990-5-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250803212206.3548990-1-sashal@kernel.org>
References: <20250803212206.3548990-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 5.15.189
Content-Transfer-Encoding: 8bit

From: Kees Cook <kees@kernel.org>

[ Upstream commit 65c430906efffee9bd7551d474f01a6b1197df90 ]

GCC appears to have kind of fragile inlining heuristics, in the
sense that it can change whether or not it inlines something based on
optimizations. It looks like the kcov instrumentation being added (or in
this case, removed) from a function changes the optimization results,
and some functions marked "inline" are _not_ inlined. In that case,
we end up with __init code calling a function not marked __init, and we
get the build warnings I'm trying to eliminate in the coming patch that
adds __no_sanitize_coverage to __init functions:

WARNING: modpost: vmlinux: section mismatch in reference: acpi_get_enable_method+0x1c (section: .text.unlikely) -> acpi_psci_present (section: .init.text)

This problem is somewhat fragile (though using either __always_inline
or __init will deterministically solve it), but we've tripped over
this before with GCC and the solution has usually been to just use
__always_inline and move on.

For arm64 this requires forcing one ACPI function to be inlined with
__always_inline.

Link: https://lore.kernel.org/r/20250724055029.3623499-1-kees@kernel.org
Signed-off-by: Kees Cook <kees@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Based on my analysis, here is my determination:

**Backport Status: YES**

This commit should be backported to stable kernel trees for the
following reasons:

1. **Fixes a real build warning/bug**: The commit addresses section
   mismatch warnings that occur when GCC's inlining heuristics change
   due to KCOV instrumentation. These warnings indicate potential
   runtime issues where __init code (which gets discarded after boot)
   calls non-__init functions, which could lead to crashes if those
   functions are called after the __init sections are freed.

2. **Minimal and contained change**: The fix is extremely simple - it
   only changes one function declaration from `static inline` to `static
   __always_inline` in arch/arm64/include/asm/acpi.h:153. This is a
   minimal change with very low risk.


4. **Prevents build regressions**: Without this fix, enabling KCOV
   instrumentation could cause build failures or warnings in stable
   kernels, which would be a regression for users who need to use KCOV
   for testing.

5. **Well-understood issue**: The commit message clearly explains the
   root cause - GCC's fragile inlining heuristics that change based on
   optimizations/instrumentation. The solution (__always_inline) is a
   well-established pattern in the kernel for forcing inlining.

6. **No functional change**: The change only affects compilation
   behavior by forcing inlining. The actual runtime behavior remains
   identical - `acpi_get_enable_method()` still calls
   `acpi_psci_present()` (marked __init) and returns the same values.

The specific code change shows `acpi_get_enable_method()` being changed
from `static inline` to `static __always_inline`. This function calls
`acpi_psci_present()`, which is marked `__init` (as seen in
arch/arm64/kernel/acpi.c:110). Without forced inlining, GCC might not
inline `acpi_get_enable_method()`, resulting in non-__init code calling
__init code, triggering the section mismatch warning.

This is exactly the type of targeted, low-risk fix that stable trees are
meant to include.

 arch/arm64/include/asm/acpi.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/acpi.h b/arch/arm64/include/asm/acpi.h
index 702587fda70c..8cbbd08cc8c5 100644
--- a/arch/arm64/include/asm/acpi.h
+++ b/arch/arm64/include/asm/acpi.h
@@ -128,7 +128,7 @@ acpi_set_mailbox_entry(int cpu, struct acpi_madt_generic_interrupt *processor)
 {}
 #endif
 
-static inline const char *acpi_get_enable_method(int cpu)
+static __always_inline const char *acpi_get_enable_method(int cpu)
 {
 	if (acpi_psci_present())
 		return "psci";
-- 
2.39.5

