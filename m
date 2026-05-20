Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3B8B352022;
	Wed, 20 May 2026 16:34:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294857; cv=none; b=Pt93eqvpl3Z84CTptJ77Cjk6j26jmKgkeAiWtRGb7uTKEs2MkJt0t+m8mgqpl6K9v8o3hIEReM8qnKsdkspfWvDyW9PDK1Kfq5LKEv0DrK5vSl76L8FrrbnPVQHEX5vmpca+el1mfAm8zAfK6pTUGvo3j05OScYYVGkcWmTgLS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294857; c=relaxed/simple;
	bh=PtUoYhD204YLyk3Yc56xb3eGkxYSOWqtGyuNP7fzLDU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qU2DR6CJLY0rbKQrkpbXIrx+bkDfP8wYlQCgINsYGI6NIYIixfUwZeo4tFmNAPudfbRavDCavokqhZKQwTexDXNaVDsRxNk/8xTMS9H7RZxJxPO5DV9VtHUXyVppGHnVzgB2cnTRpGDjcRTXFvQwPskAM4B6vliv079CHif2Cv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yIW+/rQP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yIW+/rQP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 310DD1F000E9;
	Wed, 20 May 2026 16:34:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294855;
	bh=cGnkX3zkEGoVJShp95vUVp0emkw1X2YXIsKcHQQd+0I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yIW+/rQPmZIB8QU0wvrGKCNCN+WYaP7Q5djnU0RGGBRG23SoaE1kmhPQu8xLqyRxs
	 z7iU04w9rjxZ/0Qj1axj+S5DYPAQJdVqVHuttibFfVCDB2sQgGrUeuy/IlbdnQIkCw
	 uW4uMFD8Nf6OUJPNY1+9UlOa3ZZeQlYU50F2V4fo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eduard Zingerman <eddyz87@gmail.com>,
	Paul Chaignon <paul.chaignon@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0197/1146] selftests/bpf: Fix reg_bounds to match new tnum-based refinement
Date: Wed, 20 May 2026 18:07:27 +0200
Message-ID: <20260520162152.733685669@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Chaignon <paul.chaignon@gmail.com>

[ Upstream commit 2fefa9c81a25534464911447d51ddb44b04a8e5b ]

Commit efc11a667878 ("bpf: Improve bounds when tnum has a single
possible value") improved the bounds refinement to detect when the tnum
and u64 range overlap in a single value (and the bounds can thus be set
to that value).

Eduard then noticed that it broke the slow-mode reg_bounds selftests
because they don't have an equivalent logic and are therefore unable to
refine the bounds as much as the verifier. The following test case
illustrates this.

  ACTUAL   TRUE1:  scalar(u64=0xffffffff00000000,u32=0,s64=0xffffffff00000000,s32=0)
  EXPECTED TRUE1:  scalar(u64=[0xfffffffe00000001; 0xffffffff00000000],u32=0,s64=[0xfffffffe00000001; 0xffffffff00000000],s32=0)
  [...]
  #323/1007 reg_bounds_gen_consts_s64_s32/(s64)[0xfffffffe00000001; 0xffffffff00000000] (s32)<op> S64_MIN:FAIL

with the verifier logs:

  [...]
  19: w0 = w6                 ; R0=scalar(smin=0,smax=umax=0xffffffff,
                                          var_off=(0x0; 0xffffffff))
                                R6=scalar(smin=0xfffffffe00000001,smax=0xffffffff00000000,
                                          umin=0xfffffffe00000001,umax=0xffffffff00000000,
                                          var_off=(0xfffffffe00000000; 0x1ffffffff))
  20: w0 = w7                 ; R0=0 R7=0x8000000000000000
  21: if w6 == w7 goto pc+3
  [...]
  from 21 to 25: [...]
  25: w0 = w6                 ; R0=0 R6=0xffffffff00000000
                              ;         ^
                              ;         unexpected refined value
  26: w0 = w7                 ; R0=0 R7=0x8000000000000000
  27: exit

When w6 == w7 is true, the verifier can deduce that the R6's tnum is
equal to (0xfffffffe00000000; 0x100000000) and then use that information
to refine the bounds: the tnum only overlap with the u64 range in
0xffffffff00000000. The reg_bounds selftest doesn't know about tnums
and therefore fails to perform the same refinement.

This issue happens when the tnum carries information that cannot be
represented in the ranges, as otherwise the selftest could reach the
same refined value using just the ranges. The tnum thus needs to
represent non-contiguous values (ex., R6's tnum above, after the
condition). The only way this can happen in the reg_bounds selftest is
at the boundary between the 32 and 64bit ranges. We therefore only need
to handle that case.

This patch fixes the selftest refinement logic by checking if the u32
and u64 ranges overlap in a single value. If so, the ranges can be set
to that value. We need to handle two cases: either they overlap in
umin64...

  u64 values
  matching u32 range:     xxx        xxx        xxx        xxx
                      |--------------------------------------|
  u64 range:          0                xxxxx                 UMAX64

or in umax64:

  u64 values
  matching u32 range:     xxx        xxx        xxx        xxx
                      |--------------------------------------|
  u64 range:          0          xxxxx                       UMAX64

To detect the first case, we decrease umax64 to the maximum value that
matches the u32 range. If that happens to be umin64, then umin64 is the
only overlap. We proceed similarly for the second case, increasing
umin64 to the minimum value that matches the u32 range.

Note this is similar to how the verifier handles the general case using
tnum, but we don't need to care about a single-value overlap in the
middle of the range. That case is not possible when comparing two
ranges.

This patch also adds two test cases reproducing this bug as part of the
normal test runs (without SLOW_TESTS=1).

Fixes: efc11a667878 ("bpf: Improve bounds when tnum has a single possible value")
Reported-by: Eduard Zingerman <eddyz87@gmail.com>
Closes: https://lore.kernel.org/bpf/4e6dd64a162b3cab3635706ae6abfdd0be4db5db.camel@gmail.com/
Signed-off-by: Paul Chaignon <paul.chaignon@gmail.com>
Link: https://lore.kernel.org/r/ada9UuSQi2SE2IfB@mail.gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/bpf/prog_tests/reg_bounds.c     | 35 +++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/reg_bounds.c b/tools/testing/selftests/bpf/prog_tests/reg_bounds.c
index cb8dd2f63296b..05fc9a7cf7c92 100644
--- a/tools/testing/selftests/bpf/prog_tests/reg_bounds.c
+++ b/tools/testing/selftests/bpf/prog_tests/reg_bounds.c
@@ -500,6 +500,39 @@ static struct range range_refine(enum num_t x_t, struct range x, enum num_t y_t,
 	    (s64)x.a >= S32_MIN && (s64)x.b <= S32_MAX)
 		return range_intersection(x_t, x, y_cast);
 
+	if (y_t == U32 && x_t == U64) {
+		u64 xmin_swap, xmax_swap, xmin_lower32, xmax_lower32;
+
+		xmin_lower32 = x.a & 0xffffffff;
+		xmax_lower32 = x.b & 0xffffffff;
+		if (xmin_lower32 < y.a || xmin_lower32 > y.b) {
+			/* The 32 lower bits of the umin64 are outside the u32
+			 * range. Let's update umin64 to match the u32 range.
+			 * We want to *increase* the umin64 to the *minimum*
+			 * value that matches the u32 range.
+			 */
+			xmin_swap = swap_low32(x.a, y.a);
+			/* We should always only increase the minimum, so if
+			 * the new value is lower than before, we need to
+			 * increase the 32 upper bits by 1.
+			 */
+			if (xmin_swap < x.a)
+				xmin_swap += 0x100000000;
+			if (xmin_swap == x.b)
+				return range(x_t, x.b, x.b);
+		} else if (xmax_lower32 < y.a || xmax_lower32 > y.b) {
+			/* Same for the umax64, but we want to *decrease*
+			 * umax64 to the *maximum* value that matches the u32
+			 * range.
+			 */
+			xmax_swap = swap_low32(x.b, y.b);
+			if (xmax_swap > x.b)
+				xmax_swap -= 0x100000000;
+			if (xmax_swap == x.a)
+				return range(x_t, x.a, x.a);
+		}
+	}
+
 	/* the case when new range knowledge, *y*, is a 32-bit subregister
 	 * range, while previous range knowledge, *x*, is a full register
 	 * 64-bit range, needs special treatment to take into account upper 32
@@ -2129,6 +2162,8 @@ static struct subtest_case crafted_cases[] = {
 	{U64, S64, {0x7fffffff00000001ULL, 0xffffffff00000000ULL}, {0, 0}},
 	{U64, S64, {0, 0xffffffffULL}, {1, 1}},
 	{U64, S64, {0, 0xffffffffULL}, {0x7fffffff, 0x7fffffff}},
+	{U64, S32, {0xfffffffe00000001, 0xffffffff00000000}, {S64_MIN, S64_MIN}},
+	{U64, U32, {0xfffffffe00000000, U64_MAX - 1}, {U64_MAX, U64_MAX}},
 
 	{U64, U32, {0, 0x100000000}, {0, 0}},
 	{U64, U32, {0xfffffffe, 0x300000000}, {0x80000000, 0x80000000}},
-- 
2.53.0



