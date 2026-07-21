Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59A4D363081;
	Tue, 21 Jul 2026 17:39:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655558; cv=none; b=K0c4VLq1Rq5lknmwKpWvHTSmLMT1QolQkYVOxIknDHN0qlHcEhIzXhHnhc8kqiyhZc/M6IOZ8fzQ9PN2dcRuaiFPW0yKrJI/qGzCIAWtijc8JxPIfAW7eH2Jep6D5a2OXqgWw8InRnckvSdzJz62kRv3D/mJy9gsSiAXOueSfcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655558; c=relaxed/simple;
	bh=oqQodpLHBkbis2GzaEIDki7Rq4qm4WXeZAuOzXNMsDI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OjShPZ/KgMFd4fOltGAbn1+t5wyXNgFQOSzq0yvY0gKox+BViaVFKnmHZQOB5oiaDXFn8bumPFKiL3ABNYJ0ElBYH6aN2StbTjk+vjt5oa1CZb4yJELICVyQhHjeNRqqaUbxbYXFukMCDOVW1hRPvzcQMCJnthrv+S4hpGcasiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b9axzguj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b9axzguj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEED61F000E9;
	Tue, 21 Jul 2026 17:39:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655557;
	bh=zzJOfILipbgnDVjblGYd7Iz+CJ/fC4bIfzgFA4UM7I4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b9axzguj1btiFavA/jRb6B7HklmJzJTl2+xHGX+nroqLVFvfyrN3rmDcHdQwJHCTO
	 eq8cQ94QE6FN9cMWt/Tdo6Rn95pQ0POIqqQIn3lMDwqi7e5Zvnr1QEv7p4CTJRHkza
	 8lN8Lo4AWxOWXTHr52ra550tQR1UKrtki+EdmwGU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Puranjay Mohan <puranjay@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Shung-Hsi Yu <shung-hsi.yu@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0012/1611] selftests/bpf: Add tests for improved linked register tracking
Date: Tue, 21 Jul 2026 17:02:08 +0200
Message-ID: <20260721152515.060680957@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Puranjay Mohan <puranjay@kernel.org>

commit 47fcf4dc0a346dd0b873a679c547d6848bd85a37 upstream.

Add tests for linked register tracking with negative offsets, BPF_SUB,
and alu32. These test for all edge cases like overflows, etc.

Signed-off-by: Puranjay Mohan <puranjay@kernel.org>
Acked-by: Eduard Zingerman <eddyz87@gmail.com>
Link: https://lore.kernel.org/r/20260204151741.2678118-3-puranjay@kernel.org
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../bpf/progs/verifier_linked_scalars.c       | 303 +++++++++++++++++-
 1 file changed, 301 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/progs/verifier_linked_scalars.c b/tools/testing/selftests/bpf/progs/verifier_linked_scalars.c
index 5f41bbb730a713..2ef346c827c25b 100644
--- a/tools/testing/selftests/bpf/progs/verifier_linked_scalars.c
+++ b/tools/testing/selftests/bpf/progs/verifier_linked_scalars.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 
 #include <linux/bpf.h>
+#include <limits.h>
 #include <bpf/bpf_helpers.h>
 #include "bpf_misc.h"
 
@@ -18,9 +19,9 @@ __naked void scalars(void)
 	r4 = r1;				\
 	w2 += 0x7FFFFFFF;			\
 	w4 += 0;				\
-	if r2 == 0 goto l1;			\
+	if r2 == 0 goto l0_%=;			\
 	exit;					\
-l1:						\
+l0_%=:						\
 	r4 >>= 63;				\
 	r3 = 1;					\
 	r3 -= r4;				\
@@ -64,4 +65,302 @@ l0_%=:								\
 	: __clobber_all);
 }
 
+SEC("socket")
+__success
+__naked void scalars_neg(void)
+{
+	asm volatile ("					\
+	call %[bpf_get_prandom_u32];			\
+	r0 &= 0xff;					\
+	r1 = r0;					\
+	r1 += -4;					\
+	if r1 s< 0 goto l0_%=;				\
+	if r0 != 0 goto l0_%=;				\
+	r0 /= 0;					\
+l0_%=:							\
+	r0 = 0;						\
+	exit;						\
+"	:
+	: __imm(bpf_get_prandom_u32)
+	: __clobber_all);
+}
+
+/* Same test but using BPF_SUB instead of BPF_ADD with negative immediate */
+SEC("socket")
+__success
+__naked void scalars_neg_sub(void)
+{
+	asm volatile ("					\
+	call %[bpf_get_prandom_u32];			\
+	r0 &= 0xff;					\
+	r1 = r0;					\
+	r1 -= 4;					\
+	if r1 s< 0 goto l0_%=;				\
+	if r0 != 0 goto l0_%=;				\
+	r0 /= 0;					\
+l0_%=:							\
+	r0 = 0;						\
+	exit;						\
+"	:
+	: __imm(bpf_get_prandom_u32)
+	: __clobber_all);
+}
+
+/* alu32 with negative offset */
+SEC("socket")
+__success
+__naked void scalars_neg_alu32_add(void)
+{
+	asm volatile ("					\
+	call %[bpf_get_prandom_u32];			\
+	w0 &= 0xff;					\
+	w1 = w0;					\
+	w1 += -4;					\
+	if w1 s< 0 goto l0_%=;				\
+	if w0 != 0 goto l0_%=;				\
+	r0 /= 0;					\
+l0_%=:							\
+	r0 = 0;						\
+	exit;						\
+"	:
+	: __imm(bpf_get_prandom_u32)
+	: __clobber_all);
+}
+
+/* alu32 with negative offset using SUB */
+SEC("socket")
+__success
+__naked void scalars_neg_alu32_sub(void)
+{
+	asm volatile ("					\
+	call %[bpf_get_prandom_u32];			\
+	w0 &= 0xff;					\
+	w1 = w0;					\
+	w1 -= 4;					\
+	if w1 s< 0 goto l0_%=;				\
+	if w0 != 0 goto l0_%=;				\
+	r0 /= 0;					\
+l0_%=:							\
+	r0 = 0;						\
+	exit;						\
+"	:
+	: __imm(bpf_get_prandom_u32)
+	: __clobber_all);
+}
+
+/* Positive offset: r1 = r0 + 4, then if r1 >= 6, r0 >= 2, so r0 != 0 */
+SEC("socket")
+__success
+__naked void scalars_pos(void)
+{
+	asm volatile ("					\
+	call %[bpf_get_prandom_u32];			\
+	r0 &= 0xff;					\
+	r1 = r0;					\
+	r1 += 4;					\
+	if r1 < 6 goto l0_%=;				\
+	if r0 != 0 goto l0_%=;				\
+	r0 /= 0;					\
+l0_%=:							\
+	r0 = 0;						\
+	exit;						\
+"	:
+	: __imm(bpf_get_prandom_u32)
+	: __clobber_all);
+}
+
+/* SUB with negative immediate: r1 -= -4 is equivalent to r1 += 4 */
+SEC("socket")
+__success
+__naked void scalars_sub_neg_imm(void)
+{
+	asm volatile ("					\
+	call %[bpf_get_prandom_u32];			\
+	r0 &= 0xff;					\
+	r1 = r0;					\
+	r1 -= -4;					\
+	if r1 < 6 goto l0_%=;				\
+	if r0 != 0 goto l0_%=;				\
+	r0 /= 0;					\
+l0_%=:							\
+	r0 = 0;						\
+	exit;						\
+"	:
+	: __imm(bpf_get_prandom_u32)
+	: __clobber_all);
+}
+
+/* Double ADD clears the ID (can't accumulate offsets) */
+SEC("socket")
+__failure
+__msg("div by zero")
+__naked void scalars_double_add(void)
+{
+	asm volatile ("					\
+	call %[bpf_get_prandom_u32];			\
+	r0 &= 0xff;					\
+	r1 = r0;					\
+	r1 += 2;					\
+	r1 += 2;					\
+	if r1 < 6 goto l0_%=;				\
+	if r0 != 0 goto l0_%=;				\
+	r0 /= 0;					\
+l0_%=:							\
+	r0 = 0;						\
+	exit;						\
+"	:
+	: __imm(bpf_get_prandom_u32)
+	: __clobber_all);
+}
+
+/*
+ * Test that sync_linked_regs() correctly handles large offset differences.
+ * r1.off = S32_MIN, r2.off = 1, delta = S32_MIN - 1 requires 64-bit math.
+ */
+SEC("socket")
+__success
+__naked void scalars_sync_delta_overflow(void)
+{
+	asm volatile ("					\
+	call %[bpf_get_prandom_u32];			\
+	r0 &= 0xff;					\
+	r1 = r0;					\
+	r2 = r0;					\
+	r1 += %[s32_min];				\
+	r2 += 1;					\
+	if r2 s< 100 goto l0_%=;			\
+	if r1 s< 0 goto l0_%=;				\
+	r0 /= 0;					\
+l0_%=:							\
+	r0 = 0;						\
+	exit;						\
+"	:
+	: __imm(bpf_get_prandom_u32),
+	  [s32_min]"i"(INT_MIN)
+	: __clobber_all);
+}
+
+/*
+ * Another large delta case: r1.off = S32_MAX, r2.off = -1.
+ * delta = S32_MAX - (-1) = S32_MAX + 1 requires 64-bit math.
+ */
+SEC("socket")
+__success
+__naked void scalars_sync_delta_overflow_large_range(void)
+{
+	asm volatile ("					\
+	call %[bpf_get_prandom_u32];			\
+	r0 &= 0xff;					\
+	r1 = r0;					\
+	r2 = r0;					\
+	r1 += %[s32_max];				\
+	r2 += -1;					\
+	if r2 s< 0 goto l0_%=;				\
+	if r1 s>= 0 goto l0_%=;				\
+	r0 /= 0;					\
+l0_%=:							\
+	r0 = 0;						\
+	exit;						\
+"	:
+	: __imm(bpf_get_prandom_u32),
+	  [s32_max]"i"(INT_MAX)
+	: __clobber_all);
+}
+
+/*
+ * Test linked scalar tracking with alu32 and large positive offset (0x7FFFFFFF).
+ * After w1 += 0x7FFFFFFF, w1 wraps to negative for any r0 >= 1.
+ * If w1 is signed-negative, then r0 >= 1, so r0 != 0.
+ */
+SEC("socket")
+__success
+__naked void scalars_alu32_big_offset(void)
+{
+	asm volatile ("					\
+	call %[bpf_get_prandom_u32];			\
+	w0 &= 0xff;					\
+	w1 = w0;					\
+	w1 += 0x7FFFFFFF;				\
+	if w1 s>= 0 goto l0_%=;				\
+	if w0 != 0 goto l0_%=;				\
+	r0 /= 0;					\
+l0_%=:							\
+	r0 = 0;						\
+	exit;						\
+"	:
+	: __imm(bpf_get_prandom_u32)
+	: __clobber_all);
+}
+
+SEC("socket")
+__failure
+__msg("div by zero")
+__naked void scalars_alu32_basic(void)
+{
+	asm volatile ("					\
+	call %[bpf_get_prandom_u32];			\
+	r1 = r0;					\
+	w1 += 1;					\
+	if r1 > 10 goto 1f;				\
+	r0 >>= 32;					\
+	if r0 == 0 goto 1f;				\
+	r0 /= 0;					\
+1:							\
+	r0 = 0;						\
+	exit;						\
+"	:
+	: __imm(bpf_get_prandom_u32)
+	: __clobber_all);
+}
+
+/*
+ * Test alu32 linked register tracking with wrapping.
+ * R0 is bounded to [0xffffff00, 0xffffffff] (high 32-bit values)
+ * w1 += 0x100 causes R1 to wrap to [0, 0xff]
+ *
+ * After sync_linked_regs, if bounds are computed correctly:
+ *   R0 should be [0x00000000_ffffff00, 0x00000000_ffffff80]
+ *   R0 >> 32 == 0, so div by zero is unreachable
+ *
+ * If bounds are computed incorrectly (64-bit underflow):
+ *   R0 becomes [0xffffffff_ffffff00, 0xffffffff_ffffff80]
+ *   R0 >> 32 == 0xffffffff != 0, so div by zero is reachable
+ */
+SEC("socket")
+__success
+__naked void scalars_alu32_wrap(void)
+{
+	asm volatile ("					\
+	call %[bpf_get_prandom_u32];			\
+	w0 |= 0xffffff00;				\
+	r1 = r0;					\
+	w1 += 0x100;					\
+	if r1 > 0x80 goto l0_%=;			\
+	r2 = r0;					\
+	r2 >>= 32;					\
+	if r2 == 0 goto l0_%=;				\
+	r0 /= 0;					\
+l0_%=:							\
+	r0 = 0;						\
+	exit;						\
+"	:
+	: __imm(bpf_get_prandom_u32)
+	: __clobber_all);
+}
+
+SEC("socket")
+__success
+void alu32_negative_offset(void)
+{
+	volatile char path[5];
+	volatile int offset = bpf_get_prandom_u32();
+	int off = offset;
+
+	if (off >= 5 && off < 10)
+		path[off - 5] = '.';
+
+	/* So compiler doesn't say: error: variable 'path' set but not used */
+	__sink(path[0]);
+}
+
 char _license[] SEC("license") = "GPL";
-- 
2.53.0



