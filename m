Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D4DC3B811F;
	Mon, 17 Aug 2026 14:05:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975534; cv=none; b=pX34W2d3dYwek+meYEt+4JQG40fZzsb6XTkR6A81+UCEWCcGhr11RiT1zjRYAcmG2+MB8smmYHDBVoEVmA1IKTjsDxCeC31xoE/7VZ3HR6aOn/ud0KGCzqDbt6MtUejnJswiiTyN0iafpmmBf66pZTU0EidRx1w5rMCaUXHJBi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975534; c=relaxed/simple;
	bh=d97tFoI/vWOTImnuJNNrtttTR6jX0xDOksDoH8NfCs8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WzeLPukSYWTCy2LZ3kl/lz75urWqCVaZo97QxKCOQRuWTd0IK7zbWVSESNWhXc/vhP1CW4Fy2PTtGhSj2JbcudBWL9vFXPD/10Hd0ewmskS2WPH7V+bscbgC1aw3HZxfcinNs2qr1pVT9oWd+fSK5pjOzdOJ7KKmRTHDjgmxGPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h5XJGVTC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h5XJGVTC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EF8F1F00A3A;
	Mon, 17 Aug 2026 14:05:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975532;
	bh=PRFwKsLwqc/tysWE2h/JTpVrcrOhJAItSoNgKeuGtP0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h5XJGVTCdrIjT85wtzQ3VFdq9gXe2m9n4xdnal/VGI8qH3TKWK3/82uyeERqeUOFs
	 fFmfW7f6ioLmwxSwsmdMIcllRU7lgNcWj4z90W273EobY88qSuQJ5yH+JASpahqdMy
	 Az2D6iMk4xIt/iQJe6rj66owuWWhPdSELvmzpwgw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	STAR Labs SG <info@starlabs.sg>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Alexei Starovoitov <ast@kernel.org>,
	Philo Lu <lulie@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 059/389] bpf: Fix ld_{abs,ind} failure path analysis in subprogs
Date: Mon, 17 Aug 2026 15:28:18 +0200
Message-ID: <20260817132541.383330048@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Borkmann <daniel@iogearbox.net>

commit ee861486e377edc55361c08dcbceab3f6b6577bd upstream.

Usage of ld_{abs,ind} instructions got extended into subprogs some time
ago via commit 09b28d76eac4 ("bpf: Add abnormal return checks."). These
are only allowed in subprograms when the latter are BTF annotated and
have scalar return types.

The code generator in bpf_gen_ld_abs() has an abnormal exit path (r0=0 +
exit) from legacy cBPF times. While the enforcement is on scalar return
types, the verifier must also simulate the path of abnormal exit if the
packet data load via ld_{abs,ind} failed.

This is currently not the case. Fix it by having the verifier simulate
both success and failure paths, and extend it in similar ways as we do
for tail calls. The success path (r0=unknown, continue to next insn) is
pushed onto stack for later validation and the r0=0 and return to the
caller is done on the fall-through side.

Fixes: 09b28d76eac4 ("bpf: Add abnormal return checks.")
Reported-by: STAR Labs SG <info@starlabs.sg>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/r/20260408191242.526279-2-daniel@iogearbox.net
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
[ Dropped visit_abnormal_return_insn changes: depends on 7.0 symbols from
 e40f5a6bf88a ("bpf: correct stack liveness for tail calls");
 Hunk1: adapted IS_ERR/PTR_ERR to !branch/-EFAULT to match push_stack()
 NULL-on-failure convention;
 Dropped mark_reg_scratched(), which only affects log verbosity, introduced
 by 0f55f9ed21f9 ("bpf: Only print scratched registers and stack slots to
 verifier logs.").]
Signed-off-by: Philo Lu <lulie@linux.alibaba.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 19e1f7fff07a9c..058c05e7f144c7 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -8556,6 +8556,22 @@ static int check_ld_abs(struct bpf_verifier_env *env, struct bpf_insn *insn)
 	mark_reg_unknown(env, regs, BPF_REG_0);
 	/* ld_abs load up to 32-bit skb data. */
 	regs[BPF_REG_0].subreg_def = env->insn_idx + 1;
+	/*
+	 * See bpf_gen_ld_abs() which emits a hidden BPF_EXIT with r0=0
+	 * which must be explored by the verifier when in a subprog.
+	 */
+	if (env->cur_state->curframe) {
+		struct bpf_verifier_state *branch;
+
+		branch = push_stack(env, env->insn_idx + 1, env->insn_idx, false);
+		if (!branch)
+			return -EFAULT;
+		mark_reg_known_zero(env, regs, BPF_REG_0);
+		err = prepare_func_exit(env, &env->insn_idx);
+		if (err)
+			return err;
+		env->insn_idx--;
+	}
 	return 0;
 }
 
-- 
2.53.0



