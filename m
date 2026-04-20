Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4251D3314C4;
	Mon, 20 Apr 2026 15:54:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776700494; cv=none; b=Har6gIXyGgjd695USXIX4hI5qa0lRijAhldFUBB5et8ZSX0fZ63jy7pqm7mDHK8VyWdn2tryVPEFDqAUJ8yyxdFCTsxf5FHw1u42h9iBH3Zv7W3lrnqSgvdCMh30LhEsxK7WRcSi1t+hiZywnPeFN3EeRql2dtjg+L/iSj8srjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776700494; c=relaxed/simple;
	bh=EBj5qBCgiHZY3g29pn5HZ62OCaJhjaPV+4mB75tDq2w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LGhUh3TFYc8JshAZawtSDX6vJp8Vi1k80HOatmYkIEqSxUsqx/njxN2F+FkvRvM+GbzyeOFB9+ELcjlVMNbdphqWEiKyemol1XH5KOW0gQ6oBkWFBjKjlfyT9M2mZGMMXDlJOzmx1a3v13PNZ/ZyJem4AtMNvHAO0Phs7epij40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N7Y5/a7J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N7Y5/a7J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC5D6C19425;
	Mon, 20 Apr 2026 15:54:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776700494;
	bh=EBj5qBCgiHZY3g29pn5HZ62OCaJhjaPV+4mB75tDq2w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N7Y5/a7JWLhRJAgALQJeFmgIQK3ZNnc7ipAliOBUPmDQDcmuP4QJIfYs7g49qaoFc
	 V8W/UdKzfIxxEPccLiWKrSeN94AZjRtUiVbfv73qx0sDKZqNLKMtZG4w1fG6d8AoRY
	 rNZ+ToputKfnhcys4pu912IRrH5cjgLiqWqkAO5k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Chaignon <paul.chaignon@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Shung-Hsi Yu <shung-hsi.yu@suse.com>
Subject: [PATCH 6.19 194/220] selftests/bpf: Test refinement of single-value tnum
Date: Mon, 20 Apr 2026 17:42:15 +0200
Message-ID: <20260420153941.009960845@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153934.013228280@linuxfoundation.org>
References: <20260420153934.013228280@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Chaignon <paul.chaignon@gmail.com>

commit e6ad477d1bf8829973cddd9accbafa9d1a6cd15a upstream.

This patch introduces selftests to cover the new bounds refinement
logic introduced in the previous patch. Without the previous patch,
the first two tests fail because of the invariant violation they
trigger. The last test fails because the R10 access is not detected as
dead code. In addition, all three tests fail because of R0 having a
non-constant value in the verifier logs.

In addition, the last two cases are covering the negative cases: when we
shouldn't refine the bounds because the u64 and tnum overlap in at least
two values.

Signed-off-by: Paul Chaignon <paul.chaignon@gmail.com>
Link: https://lore.kernel.org/r/90d880c8cf587b9f7dc715d8961cd1b8111d01a8.1772225741.git.paul.chaignon@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
[shung-hsi.yu: test for backported upstream commit efc11a667878 ("bpf: Improve
bounds when tnum has a single possible value")]
Signed-off-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/bpf/progs/verifier_bounds.c |  137 ++++++++++++++++++++
 1 file changed, 137 insertions(+)

--- a/tools/testing/selftests/bpf/progs/verifier_bounds.c
+++ b/tools/testing/selftests/bpf/progs/verifier_bounds.c
@@ -1863,4 +1863,141 @@ l1_%=:	r0 = 1;				\
 	: __clobber_all);
 }
 
+/* This test covers the bounds deduction when the u64 range and the tnum
+ * overlap only at umax. After instruction 3, the ranges look as follows:
+ *
+ * 0    umin=0xe01     umax=0xf00                              U64_MAX
+ * |    [xxxxxxxxxxxxxx]                                       |
+ * |----------------------------|------------------------------|
+ * |   x               x                                       | tnum values
+ *
+ * The verifier can therefore deduce that the R0=0xf0=240.
+ */
+SEC("socket")
+__description("bounds refinement with single-value tnum on umax")
+__msg("3: (15) if r0 == 0xe0 {{.*}} R0=240")
+__success __log_level(2)
+__flag(BPF_F_TEST_REG_INVARIANTS)
+__naked void bounds_refinement_tnum_umax(void *ctx)
+{
+	asm volatile("			\
+	call %[bpf_get_prandom_u32];	\
+	r0 |= 0xe0;			\
+	r0 &= 0xf0;			\
+	if r0 == 0xe0 goto +2;		\
+	if r0 == 0xf0 goto +1;		\
+	r10 = 0;			\
+	exit;				\
+"	:
+	: __imm(bpf_get_prandom_u32)
+	: __clobber_all);
+}
+
+/* This test covers the bounds deduction when the u64 range and the tnum
+ * overlap only at umin. After instruction 3, the ranges look as follows:
+ *
+ * 0    umin=0xe00     umax=0xeff                              U64_MAX
+ * |    [xxxxxxxxxxxxxx]                                       |
+ * |----------------------------|------------------------------|
+ * |    x               x                                      | tnum values
+ *
+ * The verifier can therefore deduce that the R0=0xe0=224.
+ */
+SEC("socket")
+__description("bounds refinement with single-value tnum on umin")
+__msg("3: (15) if r0 == 0xf0 {{.*}} R0=224")
+__success __log_level(2)
+__flag(BPF_F_TEST_REG_INVARIANTS)
+__naked void bounds_refinement_tnum_umin(void *ctx)
+{
+	asm volatile("			\
+	call %[bpf_get_prandom_u32];	\
+	r0 |= 0xe0;			\
+	r0 &= 0xf0;			\
+	if r0 == 0xf0 goto +2;		\
+	if r0 == 0xe0 goto +1;		\
+	r10 = 0;			\
+	exit;				\
+"	:
+	: __imm(bpf_get_prandom_u32)
+	: __clobber_all);
+}
+
+/* This test covers the bounds deduction when the only possible tnum value is
+ * in the middle of the u64 range. After instruction 3, the ranges look as
+ * follows:
+ *
+ * 0    umin=0x7cf   umax=0x7df                                U64_MAX
+ * |    [xxxxxxxxxxxx]                                         |
+ * |----------------------------|------------------------------|
+ * |     x            x            x            x            x | tnum values
+ *       |            +--- 0x7e0
+ *       +--- 0x7d0
+ *
+ * Since the lower four bits are zero, the tnum and the u64 range only overlap
+ * in R0=0x7d0=2000. Instruction 5 is therefore dead code.
+ */
+SEC("socket")
+__description("bounds refinement with single-value tnum in middle of range")
+__msg("3: (a5) if r0 < 0x7cf {{.*}} R0=2000")
+__success __log_level(2)
+__naked void bounds_refinement_tnum_middle(void *ctx)
+{
+	asm volatile("			\
+	call %[bpf_get_prandom_u32];	\
+	if r0 & 0x0f goto +4;		\
+	if r0 > 0x7df goto +3;		\
+	if r0 < 0x7cf goto +2;		\
+	if r0 == 0x7d0 goto +1;		\
+	r10 = 0;			\
+	exit;				\
+"	:
+	: __imm(bpf_get_prandom_u32)
+	: __clobber_all);
+}
+
+/* This test cover the negative case for the tnum/u64 overlap. Since
+ * they contain the same two values (i.e., {0, 1}), we can't deduce
+ * anything more.
+ */
+SEC("socket")
+__description("bounds refinement: several overlaps between tnum and u64")
+__msg("2: (25) if r0 > 0x1 {{.*}} R0=scalar(smin=smin32=0,smax=umax=smax32=umax32=1,var_off=(0x0; 0x1))")
+__failure __log_level(2)
+__naked void bounds_refinement_several_overlaps(void *ctx)
+{
+	asm volatile("			\
+	call %[bpf_get_prandom_u32];	\
+	if r0 < 0 goto +3;		\
+	if r0 > 1 goto +2;		\
+	if r0 == 1 goto +1;		\
+	r10 = 0;			\
+	exit;				\
+"	:
+	: __imm(bpf_get_prandom_u32)
+	: __clobber_all);
+}
+
+/* This test cover the negative case for the tnum/u64 overlap. Since
+ * they overlap in the two values contained by the u64 range (i.e.,
+ * {0xf, 0x10}), we can't deduce anything more.
+ */
+SEC("socket")
+__description("bounds refinement: multiple overlaps between tnum and u64")
+__msg("2: (25) if r0 > 0x10 {{.*}} R0=scalar(smin=umin=smin32=umin32=15,smax=umax=smax32=umax32=16,var_off=(0x0; 0x1f))")
+__failure __log_level(2)
+__naked void bounds_refinement_multiple_overlaps(void *ctx)
+{
+	asm volatile("			\
+	call %[bpf_get_prandom_u32];	\
+	if r0 < 0xf goto +3;		\
+	if r0 > 0x10 goto +2;		\
+	if r0 == 0x10 goto +1;		\
+	r10 = 0;			\
+	exit;				\
+"	:
+	: __imm(bpf_get_prandom_u32)
+	: __clobber_all);
+}
+
 char _license[] SEC("license") = "GPL";


