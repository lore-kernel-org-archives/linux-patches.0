Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F20D2EE608;
	Thu,  9 Oct 2025 15:58:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760025501; cv=none; b=pEQCkqrItBD2TWUgGRidWK3N+Ez5wwzoxGSJYiPeiexEfuoXOpssir9kkiX49gAkhPrrlbB8kUcnoy9xtIQKnotudDhlOc7bQAogVbufMVL/RFknnUd8Rgf20g4irLY4KkAbMkt8fioeE653Cf9e2iBpm3Nkq8GIKI571HBr6fQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760025501; c=relaxed/simple;
	bh=l4o1Wo9ZAq+anKdCih6uevSIcfQ3LbIUix80h9iXPsA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=thS491PjrqFr4S3PC7hQNaHgJUw3fniM+cfn5yTMDT+YAz74RVrSWflb6/rPSbgBb3DqjD06xCdLWeLaHlt4CMjhw0jMiETpaL5niQkWUPMWp5KQKzjKAI4OMtb6MDwIKHVze9SSnbk8wvsnsj2ANFbAJrtNt5fjBPBzxsE9AGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ab1us6xF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ab1us6xF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46AA0C4CEE7;
	Thu,  9 Oct 2025 15:58:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760025501;
	bh=l4o1Wo9ZAq+anKdCih6uevSIcfQ3LbIUix80h9iXPsA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ab1us6xFsCtrFmkZq9JLXyoPYULO3E4fyhTiZu4M8aysafy0fgWriCheSCH4+Chqf
	 h7/ultQrwPoax4G5eexn+2DriDLMYy84cgAQmPPxslBeTcDnCZ7SWlq4ss0Z4U1c27
	 3Kit+WrNteoo6nRr+Zy1FT85vXzK3aSpCU55CexlcKb3B/sxFtlVju5spRRLfgMpjL
	 XYwaTv+RUX3FaZ19LlIbe11vljGWdtzJWH8kqF1WVEUVVBjJoN3zgkmYFR5isbeSVG
	 XQOqaMQmJ4V/L1oNud7Rq/UfS/Y/2c5LmaVmEOpgbEX9fCHv0FLc6yryZL3ZCKdnr3
	 +kcMWyfwf/9uQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Kees Cook <kees@kernel.org>,
	kernel test robot <lkp@intel.com>,
	Vineet Gupta <vgupta@kernel.org>,
	"Yury Norov (NVIDIA)" <yury.norov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 6.17-5.4] arc: Fix __fls() const-foldability via __builtin_clzl()
Date: Thu,  9 Oct 2025 11:54:46 -0400
Message-ID: <20251009155752.773732-20-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251009155752.773732-1-sashal@kernel.org>
References: <20251009155752.773732-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kees Cook <kees@kernel.org>

[ Upstream commit a3fecb9160482367365cc384c59dd220b162b066 ]

While tracking down a problem where constant expressions used by
BUILD_BUG_ON() suddenly stopped working[1], we found that an added static
initializer was convincing the compiler that it couldn't track the state
of the prior statically initialized value. Tracing this down found that
ffs() was used in the initializer macro, but since it wasn't marked with
__attribute__const__, the compiler had to assume the function might
change variable states as a side-effect (which is not true for ffs(),
which provides deterministic math results).

For arc architecture with CONFIG_ISA_ARCV2=y, the __fls() function
uses __builtin_arc_fls() which lacks GCC's const attribute, preventing
compile-time constant folding, and KUnit testing of ffs/fls fails on
arc[3]. A patch[2] to GCC to solve this has been sent.

Add a fix for this by handling compile-time constants with the standard
__builtin_clzl() builtin (which has const attribute) while preserving
the optimized arc-specific builtin for runtime cases. This has the added
benefit of skipping runtime calculation of compile-time constant values.
Even with the GCC bug fixed (which is about "attribute const") this is a
good change to avoid needless runtime costs, and should be done
regardless of the state of GCC's bug.

Build tested ARCH=arc allyesconfig with GCC arc-linux 15.2.0.

Link: https://github.com/KSPP/linux/issues/364 [1]
Link: https://gcc.gnu.org/pipermail/gcc-patches/2025-August/693273.html
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202508031025.doWxtzzc-lkp@intel.com/ [3]
Signed-off-by: Kees Cook <kees@kernel.org>
Acked-by: Vineet Gupta <vgupta@kernel.org>
Signed-off-by: Yury Norov (NVIDIA) <yury.norov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Based on my comprehensive analysis of this commit, here is my
assessment:

## **Answer: YES**

This commit should be backported to stable kernel trees.

### **Extensive Analysis:**

#### **Code Changes Analysis (arch/arc/include/asm/bitops.h:134-138)**

The change adds just 2 lines to the `__fls()` function:

```c
static inline __attribute__ ((const)) unsigned long __fls(unsigned long
x)
{
+       if (__builtin_constant_p(x))
+               return x ? BITS_PER_LONG - 1 - __builtin_clzl(x) : 0;
        /* FLS insn has exactly same semantics as the API */
        return  __builtin_arc_fls(x);
}
```

**Mathematical Correctness:** The formula `BITS_PER_LONG - 1 -
__builtin_clzl(x)` is mathematically equivalent to `__fls(x)`:
- `__builtin_clzl(x)` counts leading zeros
- For a value with the MSB at position N, there are `BITS_PER_LONG - 1 -
  N` leading zeros
- Therefore, `BITS_PER_LONG - 1 - clz(x)` gives the position of the MSB
  (which is what `__fls()` returns)
- The zero-check `x ? ... : 0` handles the edge case correctly

#### **Bug Fix Characteristics:**

1. **Fixes Real User-Visible Issues:**
   - BUILD_BUG_ON() failures when ffs/fls is used in static initializers
     (reported via KSPP issue #364)
   - KUnit test failures on ARC architecture (kernel test robot report
     lore.kernel.org/oe-kbuild-all/202508031025.doWxtzzc-lkp@intel.com/)
   - Part of a kernel-wide effort to fix const-foldability across all
     architectures (evidenced by commit 95719dfa32370 "KUnit: ffs:
     Validate all the __attribute_const__ annotations")

2. **Risk Assessment - MINIMAL:**
   - **Scope:** Only affects ARC architecture with CONFIG_ISA_ARCV2=y
   - **Size:** 2-line addition
   - **Runtime behavior:** Completely preserved - the runtime path using
     `__builtin_arc_fls()` is unchanged
   - **Compile-time optimization:** Only adds a new code path for
     compile-time constants, which cannot introduce runtime regressions
   - **Pattern precedent:** Uses `__builtin_constant_p()` which is
     already extensively used in kernel bitops (see
     include/linux/bitops.h:42-47)

3. **Part of Systematic Fix Series:**
   - Multiple similar commits for other architectures (x86:
     fca08b748d177, powerpc: 69057d3db759c, s390: b77fee88bfdfc, etc.)
   - All adding `__attribute_const__` to ffs()-family implementations
   - Demonstrates this is a recognized kernel-wide issue being
     systematically addressed

#### **Stable Tree Backport Criteria Evaluation:**

**✅ Fixes important bugs:** Yes - breaks BUILD_BUG_ON() and KUnit tests
**✅ Small and contained:** Yes - 2 lines, one function, one architecture
**✅ No harmful side effects:** Correct - only adds optimization,
preserves runtime behavior
**✅ No architectural changes:** Correct - just adds compile-time
constant handling
**✅ Minimal regression risk:** Yes - compile-time optimization cannot
break runtime code
**✅ Maintainer approval:** Acked-by: Vineet Gupta <vgupta@kernel.org>
(ARC maintainer)
**✅ Addresses test failures:** Fixes kernel test robot reported failures

**⚠️ Missing Cc: stable tag:** The commit lacks explicit stable tagging,
but this appears to be an oversight given:
- It fixes actual test failures
- It's part of a systematic bugfix series
- Similar fixes are being applied across all architectures
- The commit message states "Even with the GCC bug fixed... this is a
  good change to avoid needless runtime costs, and should be done
  regardless"

#### **Dependencies:**

No dependencies identified. The change:
- Uses standard kernel macros (BITS_PER_LONG, __builtin_constant_p,
  __builtin_clzl)
- Doesn't require the KUnit test commit to be present (works standalone)
- Doesn't depend on GCC version changes

#### **Impact Assessment:**

**ARC users:** Fixes build breakage when BUILD_BUG_ON is used with
ffs/fls in static initializers
**Other architectures:** Zero impact (change is ARC-specific)
**Performance:** Slight improvement - compile-time constants avoid
runtime calculation
**Testing:** Fixes KUnit test failures, improving test coverage on ARC

### **Conclusion:**

This is a **low-risk, high-value bugfix** that addresses real test
failures and build issues on ARC architecture. The mathematical
correctness is sound, the implementation follows established kernel
patterns, and it has maintainer approval. Despite lacking an explicit
Cc: stable tag, this commit meets all the criteria for stable tree
backporting and should be included to fix the BUILD_BUG_ON() failures
and KUnit test issues on ARC systems.

**Backport Status: YES**

 arch/arc/include/asm/bitops.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arc/include/asm/bitops.h b/arch/arc/include/asm/bitops.h
index 5340c28713927..df894235fdbc6 100644
--- a/arch/arc/include/asm/bitops.h
+++ b/arch/arc/include/asm/bitops.h
@@ -133,6 +133,8 @@ static inline __attribute__ ((const)) int fls(unsigned int x)
  */
 static inline __attribute__ ((const)) unsigned long __fls(unsigned long x)
 {
+	if (__builtin_constant_p(x))
+		return x ? BITS_PER_LONG - 1 - __builtin_clzl(x) : 0;
 	/* FLS insn has exactly same semantics as the API */
 	return	__builtin_arc_fls(x);
 }
-- 
2.51.0

