Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E240546D2DA;
	Tue, 21 Jul 2026 17:37:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655453; cv=none; b=ZHKr2rCSqfsp2bV5nxJtj+67rWOzRrbgbIUaYHEs1yLfvQ8pFnEz+X4dV9ObNzxDIu2GtIRwfiiBlhN58FVIMyDlFo8Qk8An0r8Jq9+gXjcn0cmaSRzD5V/N0gj5QO+YK2KQgiVYqtSREpjDAFECCJI/QlG4OHp2k3gfHiQGoz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655453; c=relaxed/simple;
	bh=WO9g8V7Iu8f9T15o772qmvASc+8W7KyzexNzSdC6EV8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nYVphYLl2mezwjiWHuntcdOYrC04aeOG5xriXAfOHJCGTsK74mz/eGtXMQ6Dxbwquk1VKs8nJGFDBbuQJy5Jj2Q8JX+Vw6DqGrH/Z16SzFWW9O5LoW0NxFM04+NaM8kRImETXUBfNyB2pDq12tDSGlGy+O9UqcvOYqi1WDNGKSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f9vKLXG6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f9vKLXG6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 552DF1F000E9;
	Tue, 21 Jul 2026 17:37:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655451;
	bh=VG9vXtffKRWCx+GSCy2xFrE3ymjvv6OjmKwKT5zZnbw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f9vKLXG656ukQrcQHAjWosv0qaiS3mGZjZHwUgCNufRWBfgnRAwcuNu3BxQ+cC231
	 g0YbbJE47WD58NSSDYklyM7gXeVeFSOQ3kqVUEdUNlVcgeJFX5yw8eLABEUT91qDUv
	 DA/nigiNEZ5XdV3uZBFcaxOxGojk9T5mZdiXQ59A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Borkmann <daniel@iogearbox.net>,
	Alexei Starovoitov <ast@kernel.org>,
	Shung-Hsi Yu <shung-hsi.yu@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0015/1611] selftests/bpf: Add tests for delta tracking when src_reg == dst_reg
Date: Tue, 21 Jul 2026 17:02:11 +0200
Message-ID: <20260721152515.134187294@linuxfoundation.org>
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

From: Daniel Borkmann <daniel@iogearbox.net>

commit ed2eecdc0c6613353bc1565e900d2b23237713da upstream.

Extend the verifier_linked_scalars BPF selftest with a rX += rX test
such that the div-by-zero path is rejected in the fixed case.

  # LDLIBS=-static PKG_CONFIG='pkg-config --static' ./vmtest.sh -- ./test_progs -t verifier_linked_scalars
  [...]
  ./test_progs -t verifier_linked_scalars
  #612/1   verifier_linked_scalars/scalars: find linked scalars:OK
  #612/2   verifier_linked_scalars/sync_linked_regs_preserves_id:OK
  #612/3   verifier_linked_scalars/scalars_neg:OK
  #612/4   verifier_linked_scalars/scalars_neg_sub:OK
  #612/5   verifier_linked_scalars/scalars_neg_alu32_add:OK
  #612/6   verifier_linked_scalars/scalars_neg_alu32_sub:OK
  #612/7   verifier_linked_scalars/scalars_pos:OK
  #612/8   verifier_linked_scalars/scalars_sub_neg_imm:OK
  #612/9   verifier_linked_scalars/scalars_double_add:OK
  #612/10  verifier_linked_scalars/scalars_sync_delta_overflow:OK
  #612/11  verifier_linked_scalars/scalars_sync_delta_overflow_large_range:OK
  #612/12  verifier_linked_scalars/scalars_alu32_big_offset:OK
  #612/13  verifier_linked_scalars/scalars_alu32_basic:OK
  #612/14  verifier_linked_scalars/scalars_alu32_wrap:OK
  #612/15  verifier_linked_scalars/scalars_alu32_zext_linked_reg:OK
  #612/16  verifier_linked_scalars/scalars_alu32_alu64_cross_type:OK
  #612/17  verifier_linked_scalars/scalars_alu32_alu64_regsafe_pruning:OK
  #612/18  verifier_linked_scalars/alu32_negative_offset:OK
  #612/19  verifier_linked_scalars/spurious_precision_marks:OK
  #612/20  verifier_linked_scalars/scalars_self_add_clears_id:OK
  #612/21  verifier_linked_scalars/scalars_self_add_alu32_clears_id:OK
  #612     verifier_linked_scalars:OK
  Summary: 1/21 PASSED, 0 SKIPPED, 0 FAILED

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/r/20260407192421.508817-3-daniel@iogearbox.net
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
[shung-hsi.yu: missing context from commit 223ffb6a3d05 ("selftests/bpf: add
reproducer for spurious precision propagation through calls").]
Signed-off-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../bpf/progs/verifier_linked_scalars.c       | 57 +++++++++++++++++++
 1 file changed, 57 insertions(+)

diff --git a/tools/testing/selftests/bpf/progs/verifier_linked_scalars.c b/tools/testing/selftests/bpf/progs/verifier_linked_scalars.c
index 87930b5e7b784f..8741238b2ebd94 100644
--- a/tools/testing/selftests/bpf/progs/verifier_linked_scalars.c
+++ b/tools/testing/selftests/bpf/progs/verifier_linked_scalars.c
@@ -471,4 +471,61 @@ void alu32_negative_offset(void)
 	__sink(path[0]);
 }
 
+/*
+ * Test that r += r (self-add, src_reg == dst_reg) clears the scalar ID
+ * so that sync_linked_regs() does not propagate an incorrect delta.
+ */
+SEC("socket")
+__failure
+__msg("div by zero")
+__naked void scalars_self_add_clears_id(void)
+{
+	asm volatile ("						\
+	call %[bpf_get_prandom_u32];				\
+	r6 = r0;		/* r6 unknown, id A */		\
+	r7 = r6;		/* r7 linked to r6, id A */	\
+	call %[bpf_get_prandom_u32];				\
+	r8 = r0;		/* r8 unknown, id B */		\
+	r9 = r8;		/* r9 linked to r8, id B */	\
+	if r7 != 1 goto l_exit_%=;				\
+	/* r7 == 1; sync propagates: r6 = 1 (known, id A) */	\
+	r6 += r6;		/* r6 = 2; should clear id */	\
+	if r7 == r9 goto l_exit_%=;				\
+	/* Bug: r6 synced to r7(1)+delta(2)=3; Fix: r6 = 2 */	\
+	if r6 == 3 goto l_exit_%=;				\
+	r0 /= 0;						\
+l_exit_%=:							\
+	r0 = 0;							\
+	exit;							\
+"	:
+	: __imm(bpf_get_prandom_u32)
+	: __clobber_all);
+}
+
+/* Same as above but with alu32 such that w6 += w6 also clears id. */
+SEC("socket")
+__failure
+__msg("div by zero")
+__naked void scalars_self_add_alu32_clears_id(void)
+{
+	asm volatile ("						\
+	call %[bpf_get_prandom_u32];				\
+	w6 = w0;						\
+	w7 = w6;						\
+	call %[bpf_get_prandom_u32];				\
+	w8 = w0;						\
+	w9 = w8;						\
+	if w7 != 1 goto l_exit_%=;				\
+	w6 += w6;						\
+	if w7 == w9 goto l_exit_%=;				\
+	if w6 == 3 goto l_exit_%=;				\
+	r0 /= 0;						\
+l_exit_%=:							\
+	r0 = 0;							\
+	exit;							\
+"	:
+	: __imm(bpf_get_prandom_u32)
+	: __clobber_all);
+}
+
 char _license[] SEC("license") = "GPL";
-- 
2.53.0



