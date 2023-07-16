Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 461078F70
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 19:59:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56146C433C8;
	Sun, 16 Jul 2023 19:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689537571;
	bh=3nyrhwRm6a+EYnTLEq8Gr/gby3jonHe+zCXHUCLvLlE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H071vYvM5diQkrrPDIeymW1h0g1JBuacRQKeeYXGbKWMoNHpJtKm8FZf7QDpSzOEy
	 9Lwy7gfnUVogNPTRIVYRrWxLMbSh8CBOOqSgcVOiznVOSyr+j6NbrMuuN4FXHn46eU
	 PbcKrfeef2A7G/tjYTgdCH2cSTIvp4MZafXQ6wDs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Marchevsky <davemarchevsky@fb.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 142/800] bpf: Set kptr_struct_meta for node param to list and rbtree insert funcs
Date: Sun, 16 Jul 2023 21:39:55 +0200
Message-ID: <20230716194952.394684282@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dave Marchevsky <davemarchevsky@fb.com>

[ Upstream commit 2140a6e3422de22e6ebe77d4d18b6c0c9c425426 ]

In verifier.c, fixup_kfunc_call uses struct bpf_insn_aux_data's
kptr_struct_meta field to pass information about local kptr types to
various helpers and kfuncs at runtime. The recent bpf_refcount series
added a few functions to the set that need this information:

  * bpf_refcount_acquire
    * Needs to know where the refcount field is in order to increment
  * Graph collection insert kfuncs: bpf_rbtree_add, bpf_list_push_{front,back}
    * Were migrated to possibly fail by the bpf_refcount series. If
      insert fails, the input node is bpf_obj_drop'd. bpf_obj_drop needs
      the kptr_struct_meta in order to decr refcount and properly free
      special fields.

Unfortunately the verifier handling of collection insert kfuncs was not
modified to actually populate kptr_struct_meta. Accordingly, when the
node input to those kfuncs is passed to bpf_obj_drop, it is done so
without the information necessary to decr refcount.

This patch fixes the issue by populating kptr_struct_meta for those
kfuncs.

Fixes: d2dcc67df910 ("bpf: Migrate bpf_rbtree_add and bpf_list_push_{front,back} to possibly fail")
Signed-off-by: Dave Marchevsky <davemarchevsky@fb.com>
Link: https://lore.kernel.org/r/20230602022647.1571784-3-davemarchevsky@fb.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 4b3d0ead703f4..405f29079a8cb 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -10286,6 +10286,8 @@ __process_kf_arg_ptr_to_graph_node(struct bpf_verifier_env *env,
 			node_off, btf_name_by_offset(reg->btf, t->name_off));
 		return -EINVAL;
 	}
+	meta->arg_btf = reg->btf;
+	meta->arg_btf_id = reg->btf_id;
 
 	if (node_off != field->graph_root.node_offset) {
 		verbose(env, "arg#1 offset=%d, but expected %s at offset=%d in struct %s\n",
@@ -10833,6 +10835,7 @@ static int check_kfunc_call(struct bpf_verifier_env *env, struct bpf_insn *insn,
 	    meta.func_id == special_kfunc_list[KF_bpf_rbtree_add_impl]) {
 		release_ref_obj_id = regs[BPF_REG_2].ref_obj_id;
 		insn_aux->insert_off = regs[BPF_REG_2].off;
+		insn_aux->kptr_struct_meta = btf_find_struct_meta(meta.arg_btf, meta.arg_btf_id);
 		err = ref_convert_owning_non_owning(env, release_ref_obj_id);
 		if (err) {
 			verbose(env, "kfunc %s#%d conversion of owning ref to non-owning failed\n",
-- 
2.39.2



