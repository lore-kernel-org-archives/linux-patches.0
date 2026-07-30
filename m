Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FAD841A4FF;
	Thu, 30 Jul 2026 15:53:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426785; cv=none; b=e4hLBLYF4c1NwxfDlsm5YIjaUhgnWv34xmqBSCHkU68gm3y5C4CO88BQ97y6DjfWxjsgNHuholyss3WuWsI88Tr14476BX5mBQxczGiZgToFUGmhEu60M82Ww8fanUhuzMPfB0xA+sADVLQkv1P9A3Pjtvr1/Y2GS7peRsN4VpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426785; c=relaxed/simple;
	bh=CHMNGfUwdbUcXq3KldsPhJ1PtCS2wvjIAMnERsq21Dk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oBCf1bpKaRJkKa640yhqgR3o4qflc4/vr1rBr3vJyvS4BAGAPbylbf0lVU8f9exE/fYnwV9SjYw8InvZxmPgMOSbQvAv9vSueWJ9at8PfG3wEO1aPfrI36kjnvjdhcWonSsTzotGf54v+JdREVekOGxh4a7VcrIU7HCj6u0qoXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q52GGIcr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q52GGIcr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB8831F000E9;
	Thu, 30 Jul 2026 15:53:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426784;
	bh=9b7uw6F9VUI/zlbhp+AjC3IGWgYKnYUuy5zAz7KI1lA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q52GGIcr1zzLQi4w7MSCZI8u+4TYRPtNdXu9maqXyrs6EEPIirJpmISu3qnafZIXL
	 N1dN3cHhmQMqqR9U8yesBbMjiVWygoeb9rg2ihnkwIHiMg7CxLTpulWWW6L2xVDMLQ
	 d2w88pduA3XWFMyHpwhx2q9gfJaLaTDvZYjOIOI4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 541/602] bpf: Refactor {acquire,release}_reference_state
Date: Thu, 30 Jul 2026 16:15:33 +0200
Message-ID: <20260730141447.394161782@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kumar Kartikeya Dwivedi <memxor@gmail.com>

[ Upstream commit 769b0f1c821455ab29baf42491e1ea1d726451fa ]

In preparation for introducing support for more reference types which
have to add and remove reference state, refactor the
acquire_reference_state and release_reference_state functions to share
common logic.

The acquire_reference_state function simply handles growing the acquired
refs and returning the pointer to the new uninitialized element, which
can be filled in by the caller.

The release_reference_state function simply erases a reference state
entry in the acquired_refs array and shrinks it. The callers are
responsible for finding the suitable element by matching on various
fields of the reference state and requesting deletion through this
function. It is not supposed to be called directly.

Existing callers of release_reference_state were using it to find and
remove state for a given ref_obj_id without scrubbing the associated
registers in the verifier state. Introduce release_reference_nomark to
provide this functionality and convert callers. We now use this new
release_reference_nomark function within release_reference as well.
It needs to operate on a verifier state instead of taking verifier env
as mark_ptr_or_null_regs requires operating on verifier state of the
two branches of a NULL condition check, therefore env->cur_state cannot
be used directly.

Acked-by: Eduard Zingerman <eddyz87@gmail.com>
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Link: https://lore.kernel.org/r/20241204030400.208005-3-memxor@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Stable-dep-of: 5e0b273e0a62 ("bpf: Reset register bounds before narrowing retval range in check_mem_access()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/verifier.c |   28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -7207,11 +7207,12 @@ static int check_mem_access(struct bpf_v
 		if (!err && value_regno >= 0 && (t == BPF_READ || rdonly_mem))
 			mark_reg_unknown(env, regs, value_regno);
 	} else if (reg->type == PTR_TO_CTX) {
-		bool is_retval = false;
+		struct bpf_insn_access_aux info = {
+			.reg_type = SCALAR_VALUE,
+			.is_ldsx = is_ldsx,
+			.log = &env->log,
+		};
 		struct bpf_retval_range range;
-		enum bpf_reg_type reg_type = SCALAR_VALUE;
-		struct btf *btf = NULL;
-		u32 btf_id = 0;
 
 		if (t == BPF_WRITE && value_regno >= 0 &&
 		    is_pointer_value(env, value_regno)) {
@@ -7223,8 +7224,9 @@ static int check_mem_access(struct bpf_v
 		if (err < 0)
 			return err;
 
-		err = check_ctx_access(env, insn_idx, off, size, t, &reg_type, &btf,
-				       &btf_id, &is_retval, is_ldsx);
+		err = check_ctx_access(env, insn_idx, off, size, t, &info.reg_type,
+				       &info.btf, &info.btf_id, &info.is_retval,
+				       info.is_ldsx);
 		if (err)
 			verbose_linfo(env, insn_idx, "; ");
 		if (!err && t == BPF_READ && value_regno >= 0) {
@@ -7232,8 +7234,8 @@ static int check_mem_access(struct bpf_v
 			 * PTR_TO_PACKET[_META,_END]. In the latter
 			 * case, we know the offset is zero.
 			 */
-			if (reg_type == SCALAR_VALUE) {
-				if (is_retval && get_func_retval_range(env->prog, &range)) {
+			if (info.reg_type == SCALAR_VALUE) {
+				if (info.is_retval && get_func_retval_range(env->prog, &range)) {
 					err = __mark_reg_s32_range(env, regs, value_regno,
 								   range.minval, range.maxval);
 					if (err)
@@ -7244,7 +7246,7 @@ static int check_mem_access(struct bpf_v
 			} else {
 				mark_reg_known_zero(env, regs,
 						    value_regno);
-				if (type_may_be_null(reg_type))
+				if (type_may_be_null(info.reg_type))
 					regs[value_regno].id = ++env->id_gen;
 				/* A load of ctx field could have different
 				 * actual load size with the one encoded in the
@@ -7252,12 +7254,12 @@ static int check_mem_access(struct bpf_v
 				 * a sub-register.
 				 */
 				regs[value_regno].subreg_def = DEF_NOT_SUBREG;
-				if (base_type(reg_type) == PTR_TO_BTF_ID) {
-					regs[value_regno].btf = btf;
-					regs[value_regno].btf_id = btf_id;
+				if (base_type(info.reg_type) == PTR_TO_BTF_ID) {
+					regs[value_regno].btf = info.btf;
+					regs[value_regno].btf_id = info.btf_id;
 				}
 			}
-			regs[value_regno].type = reg_type;
+			regs[value_regno].type = info.reg_type;
 		}
 
 	} else if (reg->type == PTR_TO_STACK) {


