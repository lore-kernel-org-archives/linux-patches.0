Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DDD244A730;
	Tue, 10 Mar 2026 09:02:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773133329; cv=none; b=JI02k0G/0ECh7U5sm3LQ6BKZu7Bj6s+aoVgArd0cQQquZiJdzpfWjguVYXZdq4J0iZced8VBFEeD/l4wagNG9ec9chCJhK4/BeN71/ArsTh8H0J/zpe1fW7N5Bj3DlFpzxaXFLmSXOAJpcus9KZPw55YsZ+z7ERCtcUN2bc+P3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773133329; c=relaxed/simple;
	bh=7/+CScebjqrwjU/XOKnAk989QkKtZNfgllipDqNazeI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LRivcDb5BLAdz84lOavkAG4TPINR9HfxjlKzOoW+pPjEFof6YePeuwi0Pgzvu23A0wsHy5mPkUgckLWsLf9pR0L/367q4KRmWSrnALpxlQ7BIOx5s9dWtvrdJIqTg5NIq1g9oQwD8MSjTb+1wlBbTzN9eoUfD9RcHyflRemHF9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mP8URUXu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mP8URUXu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A158FC2BC86;
	Tue, 10 Mar 2026 09:02:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773133329;
	bh=7/+CScebjqrwjU/XOKnAk989QkKtZNfgllipDqNazeI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mP8URUXu+gs9UEViDQlvYV+n+TMFtmHuTXHhxdvyLZbokokALF50uLvL1UnkQL/G2
	 Yk19UQVyYC1mn8IXOS+C8TjvUO96vS21umZVHAeGUKENQuSZ3RASvqhJfaICAgPcCI
	 ox9lq4XjUTqP1rQ0+iQLfWqoTmHS6vRjuN++dM2iRGsXQePwSMBHMurrCaxxgl5ECS
	 dKF5Lb8sGO81NJHXwaQXG4Zyhc2xnYYnMSSaBjCXNQ82R017qhftwaDGPgVTgegkDs
	 7CDAuSGVI0bZDrm8DTYoXW/zk+TGRGX/zk1QByP+JRrWsDr0kJIra4rQ3SmxDkeU8v
	 +rlaY2Mb1XiXw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Eduard Zingerman <eddyz87@gmail.com>,
	Andrea Righi <arighi@nvidia.com>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Shung-Hsi Yu <shung-hsi.yu@suse.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	daniel@iogearbox.net,
	andrii@kernel.org,
	shuah@kernel.org,
	bpf@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-6.12] bpf: Fix u32/s32 bounds when ranges cross min/max boundary
Date: Tue, 10 Mar 2026 05:01:15 -0400
Message-ID: <20260310090145.2709021-15-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260310090145.2709021-1-sashal@kernel.org>
References: <20260310090145.2709021-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19.6
Content-Transfer-Encoding: 8bit

From: Eduard Zingerman <eddyz87@gmail.com>

[ Upstream commit fbc7aef517d8765e4c425d2792409bb9bf2e1f13 ]

Same as in __reg64_deduce_bounds(), refine s32/u32 ranges
in __reg32_deduce_bounds() in the following situations:

- s32 range crosses U32_MAX/0 boundary, positive part of the s32 range
  overlaps with u32 range:

  0                                                   U32_MAX
  |  [xxxxxxxxxxxxxx u32 range xxxxxxxxxxxxxx]              |
  |----------------------------|----------------------------|
  |xxxxx s32 range xxxxxxxxx]                       [xxxxxxx|
  0                     S32_MAX S32_MIN                    -1

- s32 range crosses U32_MAX/0 boundary, negative part of the s32 range
  overlaps with u32 range:

  0                                                   U32_MAX
  |              [xxxxxxxxxxxxxx u32 range xxxxxxxxxxxxxx]  |
  |----------------------------|----------------------------|
  |xxxxxxxxx]                       [xxxxxxxxxxxx s32 range |
  0                     S32_MAX S32_MIN                    -1

- No refinement if ranges overlap in two intervals.

This helps for e.g. consider the following program:

   call %[bpf_get_prandom_u32];
   w0 &= 0xffffffff;
   if w0 < 0x3 goto 1f;    // on fall-through u32 range [3..U32_MAX]
   if w0 s> 0x1 goto 1f;   // on fall-through s32 range [S32_MIN..1]
   if w0 s< 0x0 goto 1f;   // range can be narrowed to  [S32_MIN..-1]
   r10 = 0;
1: ...;

The reg_bounds.c selftest is updated to incorporate identical logic,
refinement based on non-overflowing range halves:

  ((x ∩ [0, smax]) ∩ (y ∩ [0, smax])) ∪
  ((x ∩ [smin,-1]) ∩ (y ∩ [smin,-1]))

Reported-by: Andrea Righi <arighi@nvidia.com>
Reported-by: Emil Tsalapatis <emil@etsalapatis.com>
Closes: https://lore.kernel.org/bpf/aakqucg4vcujVwif@gpd4/T/
Reviewed-by: Emil Tsalapatis <emil@etsalapatis.com>
Acked-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>
Signed-off-by: Eduard Zingerman <eddyz87@gmail.com>
Link: https://lore.kernel.org/r/20260306-bpf-32-bit-range-overflow-v3-1-f7f67e060a6b@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have a comprehensive understanding of this commit. Let me provide
my analysis.

## Analysis

### What the commit fixes

This commit fixes a correctness bug in the BPF verifier's
`__reg32_deduce_bounds()` function. The function was missing logic to
refine u32/s32 ranges when the s32 range crosses the sign boundary
(wraps from positive to negative values). The 64-bit counterpart
`__reg64_deduce_bounds()` already handled this case (added by commit
00bf8d0c6c9be), but the 32-bit version was incomplete.

### Bug mechanism

When an s32 range crosses the U32_MAX/0 boundary, it splits into two
intervals: a positive part [0..s32_max] and a negative part
[s32_min..-1]. If the u32 range overlaps with only ONE of these halves,
the verifier should be able to narrow both ranges. Without this fix, the
verifier falls into states where `u32_min_value > u32_max_value`,
causing **REG INVARIANTS VIOLATION** warnings and rejecting valid BPF
programs.

### Real-world impact

- **Reported-by**: Andrea Righi (NVIDIA) and Emil Tsalapatis - two
  independent reporters indicating real-world impact
- The bug prevents legitimate BPF programs from loading (e.g., scx
  scheduler programs)
- The commit message includes a concrete example BPF program that fails
  without this fix
- BPF verifier bugs can have **security implications** since incorrect
  range tracking could potentially allow out-of-bounds memory access if
  the verifier is too permissive (though this specific bug makes it too
  restrictive)

### Code change analysis

The kernel change is **small and surgical** - only 24 lines added to
`__reg32_deduce_bounds()` in `verifier.c`. The logic directly mirrors
the already-proven 64-bit equivalent at lines 2606-2621, just using
u32/s32 types instead of u64/s64. The two cases are:

1. u32 range entirely in the positive half of the split s32 range →
   narrow both
2. u32 range entirely in the negative half of the split s32 range →
   narrow both

### Selftest changes

The selftest changes (reg_bounds.c) are more extensive but are test-
only. They add `range_refine_in_halves()` and `range_union()` helper
functions and rename `range_improve` to `range_intersection` for
clarity. These changes mirror the verifier logic and ensure exhaustive
testing.

### Dependencies

- The 64-bit equivalent (commit 00bf8d0c6c9be) should ideally be present
  in the stable tree, as the new 32-bit code references
  `__reg64_deduce_bounds()` in its comments. However, the actual kernel
  code change is self-contained within `__reg32_deduce_bounds()`.
- The companion commit d8f4532f56dd1 ("Revert selftests/bpf: Update
  reg_bound range refinement logic") removes test logic now superseded
  by this fix's test changes. For backporting, only the verifier.c
  change is strictly needed.

### Risk assessment

- **Low risk**: The kernel change adds an `else` branch to existing
  code, only activated when s32 range crosses the sign boundary. When
  the ranges overlap in two intervals, no refinement is done (safe
  fallback).
- **Well-tested**: Has Reviewed-by and Acked-by tags from BPF subsystem
  experts. Includes comprehensive selftest updates.
- **Mirrors proven logic**: Directly copies the approach from
  `__reg64_deduce_bounds()` which has been in mainline since July 2025.

### Stable criteria assessment

- **Fixes a real bug**: YES - verifier invariant violations, program
  rejection
- **Obviously correct**: YES - mirrors existing 64-bit logic, reviewed
  by multiple experts
- **Small and contained**: YES - 24 lines of kernel code in one function
- **No new features**: Correct - fixes existing range deduction, no API
  changes
- **Security relevant**: BPF verifier correctness is always security-
  sensitive

## Verification

- Verified `__reg64_deduce_bounds()` at lines 2567-2622 contains the
  exact same pattern being added to `__reg32_deduce_bounds()` (read from
  verifier.c)
- Verified commit 00bf8d0c6c9be ("bpf: Improve bounds when s64 crosses
  sign boundary") is the 64-bit predecessor by Paul Chaignon (git log +
  git show)
- Verified the revert commit d8f4532f56dd1 is companion cleanup of
  superseded test logic
- Confirmed two independent Reported-by tags (Andrea Righi/NVIDIA and
  Emil Tsalapatis) from the commit message
- Verified the code change is self-contained within
  `__reg32_deduce_bounds()` by reading verifier.c lines 2460-2488
- Confirmed the `else` branch only activates when `(u32)s32_min >
  (u32)s32_max`, meaning s32 range crosses the sign boundary - this is
  the expected guard condition

**YES**

 kernel/bpf/verifier.c                         | 24 +++++++
 .../selftests/bpf/prog_tests/reg_bounds.c     | 62 +++++++++++++++++--
 2 files changed, 82 insertions(+), 4 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 783d984d7884d..48698c617bebc 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -2460,6 +2460,30 @@ static void __reg32_deduce_bounds(struct bpf_reg_state *reg)
 	if ((u32)reg->s32_min_value <= (u32)reg->s32_max_value) {
 		reg->u32_min_value = max_t(u32, reg->s32_min_value, reg->u32_min_value);
 		reg->u32_max_value = min_t(u32, reg->s32_max_value, reg->u32_max_value);
+	} else {
+		if (reg->u32_max_value < (u32)reg->s32_min_value) {
+			/* See __reg64_deduce_bounds() for detailed explanation.
+			 * Refine ranges in the following situation:
+			 *
+			 * 0                                                   U32_MAX
+			 * |  [xxxxxxxxxxxxxx u32 range xxxxxxxxxxxxxx]              |
+			 * |----------------------------|----------------------------|
+			 * |xxxxx s32 range xxxxxxxxx]                       [xxxxxxx|
+			 * 0                     S32_MAX S32_MIN                    -1
+			 */
+			reg->s32_min_value = (s32)reg->u32_min_value;
+			reg->u32_max_value = min_t(u32, reg->u32_max_value, reg->s32_max_value);
+		} else if ((u32)reg->s32_max_value < reg->u32_min_value) {
+			/*
+			 * 0                                                   U32_MAX
+			 * |              [xxxxxxxxxxxxxx u32 range xxxxxxxxxxxxxx]  |
+			 * |----------------------------|----------------------------|
+			 * |xxxxxxxxx]                       [xxxxxxxxxxxx s32 range |
+			 * 0                     S32_MAX S32_MIN                    -1
+			 */
+			reg->s32_max_value = (s32)reg->u32_max_value;
+			reg->u32_min_value = max_t(u32, reg->u32_min_value, reg->s32_min_value);
+		}
 	}
 }
 
diff --git a/tools/testing/selftests/bpf/prog_tests/reg_bounds.c b/tools/testing/selftests/bpf/prog_tests/reg_bounds.c
index d93a0c7b1786f..db3e25685b68f 100644
--- a/tools/testing/selftests/bpf/prog_tests/reg_bounds.c
+++ b/tools/testing/selftests/bpf/prog_tests/reg_bounds.c
@@ -422,15 +422,69 @@ static bool is_valid_range(enum num_t t, struct range x)
 	}
 }
 
-static struct range range_improve(enum num_t t, struct range old, struct range new)
+static struct range range_intersection(enum num_t t, struct range old, struct range new)
 {
 	return range(t, max_t(t, old.a, new.a), min_t(t, old.b, new.b));
 }
 
+/*
+ * Result is precise when 'x' and 'y' overlap or form a continuous range,
+ * result is an over-approximation if 'x' and 'y' do not overlap.
+ */
+static struct range range_union(enum num_t t, struct range x, struct range y)
+{
+	if (!is_valid_range(t, x))
+		return y;
+	if (!is_valid_range(t, y))
+		return x;
+	return range(t, min_t(t, x.a, y.a), max_t(t, x.b, y.b));
+}
+
+/*
+ * This function attempts to improve x range intersecting it with y.
+ * range_cast(... to_t ...) looses precision for ranges that pass to_t
+ * min/max boundaries. To avoid such precision loses this function
+ * splits both x and y into halves corresponding to non-overflowing
+ * sub-ranges: [0, smin] and [smax, -1].
+ * Final result is computed as follows:
+ *
+ *   ((x ∩ [0, smax]) ∩ (y ∩ [0, smax])) ∪
+ *   ((x ∩ [smin,-1]) ∩ (y ∩ [smin,-1]))
+ *
+ * Precision might still be lost if final union is not a continuous range.
+ */
+static struct range range_refine_in_halves(enum num_t x_t, struct range x,
+					   enum num_t y_t, struct range y)
+{
+	struct range x_pos, x_neg, y_pos, y_neg, r_pos, r_neg;
+	u64 smax, smin, neg_one;
+
+	if (t_is_32(x_t)) {
+		smax = (u64)(u32)S32_MAX;
+		smin = (u64)(u32)S32_MIN;
+		neg_one = (u64)(u32)(s32)(-1);
+	} else {
+		smax = (u64)S64_MAX;
+		smin = (u64)S64_MIN;
+		neg_one = U64_MAX;
+	}
+	x_pos = range_intersection(x_t, x, range(x_t, 0, smax));
+	x_neg = range_intersection(x_t, x, range(x_t, smin, neg_one));
+	y_pos = range_intersection(y_t, y, range(x_t, 0, smax));
+	y_neg = range_intersection(y_t, y, range(y_t, smin, neg_one));
+	r_pos = range_intersection(x_t, x_pos, range_cast(y_t, x_t, y_pos));
+	r_neg = range_intersection(x_t, x_neg, range_cast(y_t, x_t, y_neg));
+	return range_union(x_t, r_pos, r_neg);
+
+}
+
 static struct range range_refine(enum num_t x_t, struct range x, enum num_t y_t, struct range y)
 {
 	struct range y_cast;
 
+	if (t_is_32(x_t) == t_is_32(y_t))
+		x = range_refine_in_halves(x_t, x, y_t, y);
+
 	y_cast = range_cast(y_t, x_t, y);
 
 	/* If we know that
@@ -444,7 +498,7 @@ static struct range range_refine(enum num_t x_t, struct range x, enum num_t y_t,
 	 */
 	if (x_t == S64 && y_t == S32 && y_cast.a <= S32_MAX  && y_cast.b <= S32_MAX &&
 	    (s64)x.a >= S32_MIN && (s64)x.b <= S32_MAX)
-		return range_improve(x_t, x, y_cast);
+		return range_intersection(x_t, x, y_cast);
 
 	/* the case when new range knowledge, *y*, is a 32-bit subregister
 	 * range, while previous range knowledge, *x*, is a full register
@@ -462,7 +516,7 @@ static struct range range_refine(enum num_t x_t, struct range x, enum num_t y_t,
 		x_swap = range(x_t, swap_low32(x.a, y_cast.a), swap_low32(x.b, y_cast.b));
 		if (!is_valid_range(x_t, x_swap))
 			return x;
-		return range_improve(x_t, x, x_swap);
+		return range_intersection(x_t, x, x_swap);
 	}
 
 	if (!t_is_32(x_t) && !t_is_32(y_t) && x_t != y_t) {
@@ -480,7 +534,7 @@ static struct range range_refine(enum num_t x_t, struct range x, enum num_t y_t,
 	}
 
 	/* otherwise, plain range cast and intersection works */
-	return range_improve(x_t, x, y_cast);
+	return range_intersection(x_t, x, y_cast);
 }
 
 /* =======================
-- 
2.51.0

