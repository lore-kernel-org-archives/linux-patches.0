Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F6BE3769FD;
	Thu, 30 Jul 2026 15:53:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426788; cv=none; b=mds4BhPbfdgqihI2V+JYtp/K/bQ0oH6yeW6knLaq0nkXhMJqn4y5EZrYMI4Sb5LflBaACSr7rOz4vGL/zOHTfyBwIuDB7iYlVF25ikOwJwfu3dKIJ2Yqt21lhfJhr+lrrmtaTpdQ/Op6rernI0n54alxKOoDYztDWEqYCEgvZ/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426788; c=relaxed/simple;
	bh=9EI/EdRd7NAft3oFzUr/5YBDhL3htqxEdxdAyObbgBI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gxJwPVaVEUUg6w/HW872lMEh6xAUO80+VkSOrMuKDYgOc5sjoTLvL+irts3UlWC6TU2K4Bp08gKmSEuUBbUToIysH7TPKveaFgSTMgmQPKnRViduSbA8+pTzcDuKntFjwsxUVBePUZWCRu+VgFFZW58vKaZUqFMBpsLAqdKxCcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gsXmfsWv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gsXmfsWv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 862DA1F000E9;
	Thu, 30 Jul 2026 15:53:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426787;
	bh=FfBUzt4Xvol2UC9jXWzM0JBAaF708C4CgSu9q0aJ6GM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gsXmfsWvCa75wG4ZC5c/Dv7AFweOO7JZN6Ntfk2GvgKuFzKleJ4H8EfyBrBHQpCj9
	 8XXLQDlRBWrOIDP+C51s4206VObp0T/UC/YwhiopSBkGMzV1ziuBsVvzCc2hyr7Nj1
	 UiSdwunXtUdWlByjk25oFoDayiP6bg2NIpxFWlfc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amery Hung <ameryhung@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 542/602] bpf: Refactor check_ctx_access()
Date: Thu, 30 Jul 2026 16:15:34 +0200
Message-ID: <20260730141447.416815442@linuxfoundation.org>
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

From: Amery Hung <ameryhung@gmail.com>

[ Upstream commit 201b62ccc83153d2925d310a2afe762905e0c455 ]

Reduce the variable passing madness surrounding check_ctx_access().
Currently, check_mem_access() passes many pointers to local variables to
check_ctx_access(). They are used to initialize "struct
bpf_insn_access_aux info" in check_ctx_access() and then passed to
is_valid_access(). Then, check_ctx_access() takes the data our from
info and write them back the pointers to pass them back. This can be
simpilified by moving info up to check_mem_access().

No functional change.

Signed-off-by: Amery Hung <ameryhung@gmail.com>
Link: https://lore.kernel.org/r/20250221175644.1822383-1-ameryhung@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Stable-dep-of: 5e0b273e0a62 ("bpf: Reset register bounds before narrowing retval range in check_mem_access()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/verifier.c |   27 +++++----------------------
 1 file changed, 5 insertions(+), 22 deletions(-)

--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -5829,18 +5829,10 @@ static int check_packet_access(struct bp
 
 /* check access to 'struct bpf_context' fields.  Supports fixed offsets only */
 static int check_ctx_access(struct bpf_verifier_env *env, int insn_idx, int off, int size,
-			    enum bpf_access_type t, enum bpf_reg_type *reg_type,
-			    struct btf **btf, u32 *btf_id, bool *is_retval, bool is_ldsx)
+			    enum bpf_access_type t, struct bpf_insn_access_aux *info)
 {
-	struct bpf_insn_access_aux info = {
-		.reg_type = *reg_type,
-		.log = &env->log,
-		.is_retval = false,
-		.is_ldsx = is_ldsx,
-	};
-
 	if (env->ops->is_valid_access &&
-	    env->ops->is_valid_access(off, size, t, env->prog, &info)) {
+	    env->ops->is_valid_access(off, size, t, env->prog, info)) {
 		/* A non zero info.ctx_field_size indicates that this field is a
 		 * candidate for later verifier transformation to load the whole
 		 * field and then apply a mask when accessed with a narrower
@@ -5848,15 +5840,8 @@ static int check_ctx_access(struct bpf_v
 		 * will only allow for whole field access and rejects any other
 		 * type of narrower access.
 		 */
-		*reg_type = info.reg_type;
-		*is_retval = info.is_retval;
-
-		if (base_type(*reg_type) == PTR_TO_BTF_ID) {
-			*btf = info.btf;
-			*btf_id = info.btf_id;
-		} else {
-			env->insn_aux_data[insn_idx].ctx_field_size = info.ctx_field_size;
-		}
+		if (base_type(info->reg_type) != PTR_TO_BTF_ID)
+			env->insn_aux_data[insn_idx].ctx_field_size = info->ctx_field_size;
 		/* remember the offset of last byte accessed in ctx */
 		if (env->prog->aux->max_ctx_offset < off + size)
 			env->prog->aux->max_ctx_offset = off + size;
@@ -7224,9 +7209,7 @@ static int check_mem_access(struct bpf_v
 		if (err < 0)
 			return err;
 
-		err = check_ctx_access(env, insn_idx, off, size, t, &info.reg_type,
-				       &info.btf, &info.btf_id, &info.is_retval,
-				       info.is_ldsx);
+		err = check_ctx_access(env, insn_idx, off, size, t, &info);
 		if (err)
 			verbose_linfo(env, insn_idx, "; ");
 		if (!err && t == BPF_READ && value_regno >= 0) {


