Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEAB31D04A2;
	Wed,  2 Oct 2024 13:33:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875986; cv=none; b=IvSGFMLk2Ye0if0PsyXYTppsF2ipvjrGcEZLYx85wyLd6oV6v1rwhiHfBjbBGwK0cy9rYp4/V+UHlmVXXb8Y3vt5Ri44Gk+UK7WxDgYNha9T/fFAfltnNx74R6W2Nq1istB57YbM4PkmVjP4RvMeVGM54cKJq1mbMo5hAHgnxOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875986; c=relaxed/simple;
	bh=vkVL7sBAuRdg2sbIiHzdcVnKGGbnr9p0t2kSx+/ZStM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X31REKuhOjfGzQFRtcQ3ASHIr+peEPOjIKzKo9ZCC3pGz+hLTgYJlmBPfyDeuG7TYhUwi8cNoF55Cdwf7MahfRxk5QbT9Om6yNyJAYy0gxfVcW4XJq8qoSgNXnyfOeu+xelwSZwO2n4mtdaJwWkMRBsxIQa6m5RfWh3+6JS9jkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rb3eiqHM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rb3eiqHM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F3AAC4CECD;
	Wed,  2 Oct 2024 13:33:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875986;
	bh=vkVL7sBAuRdg2sbIiHzdcVnKGGbnr9p0t2kSx+/ZStM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rb3eiqHMRvYjiwrI5Z5H1bvCTYnj3XY4PKMmhS8Z3RGqxOYj0yihNhRxB80amV35+
	 Js/w4KMM6Qmkp1oyxAd3oiwvFuZneqoZhxQmkTdx0YA+xnoc0av7HMvw8HIQSAcNnb
	 NOizexQAlyt72IGdxw4FHElVfu5UrwOHQfc+Hw2s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Kuohai <xukuohai@huawei.com>,
	Shung-Hsi Yu <shung-hsi.yu@suse.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 258/695] bpf: Fix compare error in function retval_range_within
Date: Wed,  2 Oct 2024 14:54:16 +0200
Message-ID: <20241002125832.746348250@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xu Kuohai <xukuohai@huawei.com>

[ Upstream commit 763aa759d3b2c4f95b11855e3d37b860860107e2 ]

After checking lsm hook return range in verifier, the test case
"test_progs -t test_lsm" failed, and the failure log says:

libbpf: prog 'test_int_hook': BPF program load failed: Invalid argument
libbpf: prog 'test_int_hook': -- BEGIN PROG LOAD LOG --
0: R1=ctx() R10=fp0
; int BPF_PROG(test_int_hook, struct vm_area_struct *vma, @ lsm.c:89
0: (79) r0 = *(u64 *)(r1 +24)         ; R0_w=scalar(smin=smin32=-4095,smax=smax32=0) R1=ctx()

[...]

24: (b4) w0 = -1                      ; R0_w=0xffffffff
; int BPF_PROG(test_int_hook, struct vm_area_struct *vma, @ lsm.c:89
25: (95) exit
At program exit the register R0 has smin=4294967295 smax=4294967295 should have been in [-4095, 0]

It can be seen that instruction "w0 = -1" zero extended -1 to 64-bit
register r0, setting both smin and smax values of r0 to 4294967295.
This resulted in a false reject when r0 was checked with range [-4095, 0].

Given bpf lsm does not return 64-bit values, this patch fixes it by changing
the compare between r0 and return range from 64-bit operation to 32-bit
operation for bpf lsm.

Fixes: 8fa4ecd49b81 ("bpf: enforce exact retval range on subprog/callback exit")
Signed-off-by: Xu Kuohai <xukuohai@huawei.com>
Acked-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>
Link: https://lore.kernel.org/r/20240719110059.797546-5-xukuohai@huaweicloud.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 665bd75193b03..4a528afb20620 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -9964,9 +9964,13 @@ static bool in_rbtree_lock_required_cb(struct bpf_verifier_env *env)
 	return is_rbtree_lock_required_kfunc(kfunc_btf_id);
 }
 
-static bool retval_range_within(struct bpf_retval_range range, const struct bpf_reg_state *reg)
+static bool retval_range_within(struct bpf_retval_range range, const struct bpf_reg_state *reg,
+				bool return_32bit)
 {
-	return range.minval <= reg->smin_value && reg->smax_value <= range.maxval;
+	if (return_32bit)
+		return range.minval <= reg->s32_min_value && reg->s32_max_value <= range.maxval;
+	else
+		return range.minval <= reg->smin_value && reg->smax_value <= range.maxval;
 }
 
 static int prepare_func_exit(struct bpf_verifier_env *env, int *insn_idx)
@@ -10003,8 +10007,8 @@ static int prepare_func_exit(struct bpf_verifier_env *env, int *insn_idx)
 		if (err)
 			return err;
 
-		/* enforce R0 return value range */
-		if (!retval_range_within(callee->callback_ret_range, r0)) {
+		/* enforce R0 return value range, and bpf_callback_t returns 64bit */
+		if (!retval_range_within(callee->callback_ret_range, r0, false)) {
 			verbose_invalid_scalar(env, r0, callee->callback_ret_range,
 					       "At callback return", "R0");
 			return -EINVAL;
@@ -15610,6 +15614,7 @@ static int check_return_code(struct bpf_verifier_env *env, int regno, const char
 	int err;
 	struct bpf_func_state *frame = env->cur_state->frame[0];
 	const bool is_subprog = frame->subprogno;
+	bool return_32bit = false;
 
 	/* LSM and struct_ops func-ptr's return type could be "void" */
 	if (!is_subprog || frame->in_exception_callback_fn) {
@@ -15721,6 +15726,7 @@ static int check_return_code(struct bpf_verifier_env *env, int regno, const char
 			/* no restricted range, any return value is allowed */
 			if (range.minval == S32_MIN && range.maxval == S32_MAX)
 				return 0;
+			return_32bit = true;
 		} else if (!env->prog->aux->attach_func_proto->type) {
 			/* Make sure programs that attach to void
 			 * hooks don't try to modify return value.
@@ -15751,7 +15757,7 @@ static int check_return_code(struct bpf_verifier_env *env, int regno, const char
 	if (err)
 		return err;
 
-	if (!retval_range_within(range, reg)) {
+	if (!retval_range_within(range, reg, return_32bit)) {
 		verbose_invalid_scalar(env, reg, range, exit_ctx, reg_name);
 		if (!is_subprog &&
 		    prog->expected_attach_type == BPF_LSM_CGROUP &&
-- 
2.43.0



