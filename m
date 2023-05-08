Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C604A168A7
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:35:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0337C4339B;
	Mon,  8 May 2023 10:35:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683542135;
	bh=iL/e9aizyfYW53nVb+CjFb+RT/NMzfVpnhXxe6pGbxE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gLYsguF6DmCehKV7/tNm7CTLIwq428ER0ewk9tAVCRhxAPxfEtdhCgrO4byo+Uu3H
	 k6o/YzYEu4qCxSpdSRO1Ai4UTNJhlezt78xZcV1LwS5eHhmpk5PsBIBTtb3gCVZGU/
	 m9Qdd14C/nHuJ4Kl3rqt0YvFjkMHUp351mK0p5KA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Dave Marchevsky <davemarchevsky@fb.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 337/663] bpf: Fix struct_meta lookup for bpf_obj_free_fields kfunc call
Date: Mon,  8 May 2023 11:42:43 +0200
Message-Id: <20230508094439.100832895@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094428.384831245@linuxfoundation.org>
References: <20230508094428.384831245@linuxfoundation.org>
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

[ Upstream commit f6a6a5a976288e4d0d94eb1c6c9e983e8e5cdb31 ]

bpf_obj_drop_impl has a void return type. In check_kfunc_call, the "else
if" which sets insn_aux->kptr_struct_meta for bpf_obj_drop_impl is
surrounded by a larger if statement which checks btf_type_is_ptr. As a
result:

  * The bpf_obj_drop_impl-specific code will never execute
  * The btf_struct_meta input to bpf_obj_drop is always NULL
  * __bpf_obj_drop_impl will always see a NULL btf_record when called
    from BPF program, and won't call bpf_obj_free_fields
  * program-allocated kptrs which have fields that should be cleaned up
    by bpf_obj_free_fields may instead leak resources

This patch adds a btf_type_is_void branch to the larger if and moves
special handling for bpf_obj_drop_impl there, fixing the issue.

Fixes: ac9f06050a35 ("bpf: Introduce bpf_obj_drop")
Cc: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Dave Marchevsky <davemarchevsky@fb.com>
Link: https://lore.kernel.org/r/20230403200027.2271029-1-davemarchevsky@fb.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 6db3589f0e7cc..1c7dad0e79b92 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -9841,10 +9841,6 @@ static int check_kfunc_call(struct bpf_verifier_env *env, struct bpf_insn *insn,
 				insn_aux->obj_new_size = ret_t->size;
 				insn_aux->kptr_struct_meta =
 					btf_find_struct_meta(ret_btf, ret_btf_id);
-			} else if (meta.func_id == special_kfunc_list[KF_bpf_obj_drop_impl]) {
-				insn_aux->kptr_struct_meta =
-					btf_find_struct_meta(meta.arg_obj_drop.btf,
-							     meta.arg_obj_drop.btf_id);
 			} else if (meta.func_id == special_kfunc_list[KF_bpf_list_pop_front] ||
 				   meta.func_id == special_kfunc_list[KF_bpf_list_pop_back]) {
 				struct btf_field *field = meta.arg_list_head.field;
@@ -9922,7 +9918,15 @@ static int check_kfunc_call(struct bpf_verifier_env *env, struct bpf_insn *insn,
 		}
 		if (reg_may_point_to_spin_lock(&regs[BPF_REG_0]) && !regs[BPF_REG_0].id)
 			regs[BPF_REG_0].id = ++env->id_gen;
-	} /* else { add_kfunc_call() ensures it is btf_type_is_void(t) } */
+	} else if (btf_type_is_void(t)) {
+		if (meta.btf == btf_vmlinux && btf_id_set_contains(&special_kfunc_set, meta.func_id)) {
+			if (meta.func_id == special_kfunc_list[KF_bpf_obj_drop_impl]) {
+				insn_aux->kptr_struct_meta =
+					btf_find_struct_meta(meta.arg_obj_drop.btf,
+							     meta.arg_obj_drop.btf_id);
+			}
+		}
+	}
 
 	nargs = btf_type_vlen(meta.func_proto);
 	args = (const struct btf_param *)(meta.func_proto + 1);
-- 
2.39.2



