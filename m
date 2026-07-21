Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 985BE46D0B9;
	Tue, 21 Jul 2026 17:37:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655455; cv=none; b=Ao2G5iXKRojJZwlS1Abk83h3wavK7pNJ0OEGJqbNXSJqOccWxiERwyOky/D1wuBurvoIzCHqoPk23eDRczkiJYdDYoYs5mQnOjWx+KPcfQ9QKG9ApBdTvp9KBceo+iSHl3cx3JNfodmn4Mcs70mCfcHWKnWp2nsuLDlLhH0RWLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655455; c=relaxed/simple;
	bh=ROS/8BRUy+nK5lztUocDIjyVI3XyIYl/NQpbOfC6lkQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y/jOamz/p4X+K3DSi+BhjpanCftzFTFYWDKYncJnuYUAb70TH7pyUWzMq3KLdocB2XrB5Z4RoudsLCjliDMjJaSZE0BDwbqT3Obw0OR+3BEddkBcURsnhZLZdmpmCVvWT+OcPRht/CBO63rxwv/d+zHPyTcX6zWJObD8oEdstVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jrx9mjX/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jrx9mjX/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F40A01F000E9;
	Tue, 21 Jul 2026 17:37:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655454;
	bh=LY6eIWjFXen6nQvmDvXgC1tr8GAy5ZFDOOjJfT8KQuU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Jrx9mjX/gkvR25NOqgeVHGlKZivoBz5AxbzGE3SUc9DGNbj8Y6ldf78cqk4ILkQ4m
	 2ly511REzhbNI5yo4RW9TXYKwzdscWru5wwd6bnP3omAtI74mg2Sz5D/GJ1CwY8fxb
	 2hT8d+GU+KojUqro6vXbkNFSru4F9DDgClm+sLsI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Borkmann <daniel@iogearbox.net>,
	Alexei Starovoitov <ast@kernel.org>,
	Shung-Hsi Yu <shung-hsi.yu@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0016/1611] selftests/bpf: Add tests for stale delta leaking through id reassignment
Date: Tue, 21 Jul 2026 17:02:12 +0200
Message-ID: <20260721152515.157107494@linuxfoundation.org>
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

commit cac16ce1e3786bd98cec0c108e3bc06ed3d3c6a9 upstream.

Extend the verifier_linked_scalars BPF selftest with a stale delta test
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
  #612/22  verifier_linked_scalars/scalars_stale_delta_from_cleared_id:OK
  #612/23  verifier_linked_scalars/scalars_stale_delta_from_cleared_id_alu32:OK
  #612     verifier_linked_scalars:OK
  Summary: 1/23 PASSED, 0 SKIPPED, 0 FAILED

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/r/20260407192421.508817-4-daniel@iogearbox.net
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../bpf/progs/verifier_linked_scalars.c       | 55 +++++++++++++++++++
 1 file changed, 55 insertions(+)

diff --git a/tools/testing/selftests/bpf/progs/verifier_linked_scalars.c b/tools/testing/selftests/bpf/progs/verifier_linked_scalars.c
index 8741238b2ebd94..3b0c300c9cbd80 100644
--- a/tools/testing/selftests/bpf/progs/verifier_linked_scalars.c
+++ b/tools/testing/selftests/bpf/progs/verifier_linked_scalars.c
@@ -528,4 +528,59 @@ l_exit_%=:							\
 	: __clobber_all);
 }
 
+/*
+ * Test that stale delta from a cleared BPF_ADD_CONST does not leak
+ * through assign_scalar_id_before_mov() into a new id, causing
+ * sync_linked_regs() to compute an incorrect offset.
+ */
+SEC("socket")
+__failure
+__msg("div by zero")
+__naked void scalars_stale_delta_from_cleared_id(void)
+{
+	asm volatile ("						\
+	call %[bpf_get_prandom_u32];				\
+	r6 = r0;		/* r6 unknown, gets id A */	\
+	r6 += 5;		/* id A|ADD_CONST, delta 5 */	\
+	r6 ^= 0;		/* id cleared; delta stays 5 */	\
+	r8 = r6;		/* new id B, stale delta 5 */	\
+	r8 += 3;		/* id B|ADD_CONST, delta 3 */	\
+	r9 = r6;		/* id B, stale delta 5 */	\
+	if r9 != 10 goto l_exit_%=;				\
+	/* Bug: r8 = 10+(3-5) = 8; Fix: r8 = 10+(3-0) = 13 */	\
+	if r8 == 8 goto l_exit_%=;				\
+	r0 /= 0;						\
+l_exit_%=:							\
+	r0 = 0;							\
+	exit;							\
+"	:
+	: __imm(bpf_get_prandom_u32)
+	: __clobber_all);
+}
+
+/* Same as above but with alu32. */
+SEC("socket")
+__failure
+__msg("div by zero")
+__naked void scalars_stale_delta_from_cleared_id_alu32(void)
+{
+	asm volatile ("						\
+	call %[bpf_get_prandom_u32];				\
+	w6 = w0;						\
+	w6 += 5;						\
+	w6 ^= 0;						\
+	w8 = w6;						\
+	w8 += 3;						\
+	w9 = w6;						\
+	if w9 != 10 goto l_exit_%=;				\
+	if w8 == 8 goto l_exit_%=;				\
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



