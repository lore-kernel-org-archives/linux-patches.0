Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45EF9168A7
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:35:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9BA9C433EF;
	Mon,  8 May 2023 10:35:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683542122;
	bh=hg/KFHBAtfsniRzgX2C5mI4ws4DXWZ7wEF6gSEBFwuA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JexQd405arwhVnAs5iKdajfmdrjul5yBkvucKbanLFTZloN1Sf3zaplygUXRduV58
	 PTRyb1R8ibCkHRBOuz4tS37xt3NqQBC7a1kmyGM3gAiSMoFewn1dfKVOeZO9oycfHn
	 uavPpnGIwdLMlFx1usto+UbbTv5bkINBiHKijjbs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Marchevsky <davemarchevsky@fb.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 333/663] bpf: Add bpf_rbtree_{add,remove,first} kfuncs
Date: Mon,  8 May 2023 11:42:39 +0200
Message-Id: <20230508094438.975453865@linuxfoundation.org>
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

[ Upstream commit bd1279ae8a691d7ec75852c6d0a22139afb034a4 ]

This patch adds implementations of bpf_rbtree_{add,remove,first}
and teaches verifier about their BTF_IDs as well as those of
bpf_rb_{root,node}.

All three kfuncs have some nonstandard component to their verification
that needs to be addressed in future patches before programs can
properly use them:

  * bpf_rbtree_add:     Takes 'less' callback, need to verify it

  * bpf_rbtree_first:   Returns ptr_to_node_type(off=rb_node_off) instead
                        of ptr_to_rb_node(off=0). Return value ref is
			non-owning.

  * bpf_rbtree_remove:  Returns ptr_to_node_type(off=rb_node_off) instead
                        of ptr_to_rb_node(off=0). 2nd arg (node) is a
			non-owning reference.

Signed-off-by: Dave Marchevsky <davemarchevsky@fb.com>
Link: https://lore.kernel.org/r/20230214004017.2534011-3-davemarchevsky@fb.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Stable-dep-of: f6a6a5a97628 ("bpf: Fix struct_meta lookup for bpf_obj_free_fields kfunc call")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/helpers.c  | 54 +++++++++++++++++++++++++++++++++++++++++++
 kernel/bpf/verifier.c | 14 ++++++++++-
 2 files changed, 67 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index 92a57cc106656..5b692a5f2946b 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -1873,6 +1873,56 @@ struct bpf_list_node *bpf_list_pop_back(struct bpf_list_head *head)
 	return __bpf_list_del(head, true);
 }
 
+__bpf_kfunc struct bpf_rb_node *bpf_rbtree_remove(struct bpf_rb_root *root,
+						  struct bpf_rb_node *node)
+{
+	struct rb_root_cached *r = (struct rb_root_cached *)root;
+	struct rb_node *n = (struct rb_node *)node;
+
+	rb_erase_cached(n, r);
+	RB_CLEAR_NODE(n);
+	return (struct bpf_rb_node *)n;
+}
+
+/* Need to copy rbtree_add_cached's logic here because our 'less' is a BPF
+ * program
+ */
+static void __bpf_rbtree_add(struct bpf_rb_root *root, struct bpf_rb_node *node,
+			     void *less)
+{
+	struct rb_node **link = &((struct rb_root_cached *)root)->rb_root.rb_node;
+	bpf_callback_t cb = (bpf_callback_t)less;
+	struct rb_node *parent = NULL;
+	bool leftmost = true;
+
+	while (*link) {
+		parent = *link;
+		if (cb((uintptr_t)node, (uintptr_t)parent, 0, 0, 0)) {
+			link = &parent->rb_left;
+		} else {
+			link = &parent->rb_right;
+			leftmost = false;
+		}
+	}
+
+	rb_link_node((struct rb_node *)node, parent, link);
+	rb_insert_color_cached((struct rb_node *)node,
+			       (struct rb_root_cached *)root, leftmost);
+}
+
+__bpf_kfunc void bpf_rbtree_add(struct bpf_rb_root *root, struct bpf_rb_node *node,
+				bool (less)(struct bpf_rb_node *a, const struct bpf_rb_node *b))
+{
+	__bpf_rbtree_add(root, node, (void *)less);
+}
+
+__bpf_kfunc struct bpf_rb_node *bpf_rbtree_first(struct bpf_rb_root *root)
+{
+	struct rb_root_cached *r = (struct rb_root_cached *)root;
+
+	return (struct bpf_rb_node *)rb_first_cached(r);
+}
+
 /**
  * bpf_task_acquire - Acquire a reference to a task. A task acquired by this
  * kfunc which is not stored in a map as a kptr, must be released by calling
@@ -2097,6 +2147,10 @@ BTF_ID_FLAGS(func, bpf_task_acquire, KF_ACQUIRE | KF_TRUSTED_ARGS)
 BTF_ID_FLAGS(func, bpf_task_acquire_not_zero, KF_ACQUIRE | KF_RCU | KF_RET_NULL)
 BTF_ID_FLAGS(func, bpf_task_kptr_get, KF_ACQUIRE | KF_KPTR_GET | KF_RET_NULL)
 BTF_ID_FLAGS(func, bpf_task_release, KF_RELEASE)
+BTF_ID_FLAGS(func, bpf_rbtree_remove, KF_ACQUIRE)
+BTF_ID_FLAGS(func, bpf_rbtree_add)
+BTF_ID_FLAGS(func, bpf_rbtree_first, KF_RET_NULL)
+
 #ifdef CONFIG_CGROUPS
 BTF_ID_FLAGS(func, bpf_cgroup_acquire, KF_ACQUIRE | KF_TRUSTED_ARGS)
 BTF_ID_FLAGS(func, bpf_cgroup_kptr_get, KF_ACQUIRE | KF_KPTR_GET | KF_RET_NULL)
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 975f30e4f8612..2997869917613 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -8555,6 +8555,8 @@ BTF_ID_LIST(kf_arg_btf_ids)
 BTF_ID(struct, bpf_dynptr_kern)
 BTF_ID(struct, bpf_list_head)
 BTF_ID(struct, bpf_list_node)
+BTF_ID(struct, bpf_rb_root)
+BTF_ID(struct, bpf_rb_node)
 
 static bool __is_kfunc_ptr_arg_type(const struct btf *btf,
 				    const struct btf_param *arg, int type)
@@ -8660,6 +8662,9 @@ enum special_kfunc_type {
 	KF_bpf_rdonly_cast,
 	KF_bpf_rcu_read_lock,
 	KF_bpf_rcu_read_unlock,
+	KF_bpf_rbtree_remove,
+	KF_bpf_rbtree_add,
+	KF_bpf_rbtree_first,
 };
 
 BTF_SET_START(special_kfunc_set)
@@ -8671,6 +8676,9 @@ BTF_ID(func, bpf_list_pop_front)
 BTF_ID(func, bpf_list_pop_back)
 BTF_ID(func, bpf_cast_to_kern_ctx)
 BTF_ID(func, bpf_rdonly_cast)
+BTF_ID(func, bpf_rbtree_remove)
+BTF_ID(func, bpf_rbtree_add)
+BTF_ID(func, bpf_rbtree_first)
 BTF_SET_END(special_kfunc_set)
 
 BTF_ID_LIST(special_kfunc_list)
@@ -8684,6 +8692,9 @@ BTF_ID(func, bpf_cast_to_kern_ctx)
 BTF_ID(func, bpf_rdonly_cast)
 BTF_ID(func, bpf_rcu_read_lock)
 BTF_ID(func, bpf_rcu_read_unlock)
+BTF_ID(func, bpf_rbtree_remove)
+BTF_ID(func, bpf_rbtree_add)
+BTF_ID(func, bpf_rbtree_first)
 
 static bool is_kfunc_bpf_rcu_read_lock(struct bpf_kfunc_call_arg_meta *meta)
 {
@@ -9439,7 +9450,8 @@ static int check_kfunc_call(struct bpf_verifier_env *env, struct bpf_insn *insn,
 	}
 
 	if (meta.func_id == special_kfunc_list[KF_bpf_list_push_front] ||
-	    meta.func_id == special_kfunc_list[KF_bpf_list_push_back]) {
+	    meta.func_id == special_kfunc_list[KF_bpf_list_push_back] ||
+	    meta.func_id == special_kfunc_list[KF_bpf_rbtree_add]) {
 		release_ref_obj_id = regs[BPF_REG_2].ref_obj_id;
 		err = ref_convert_owning_non_owning(env, release_ref_obj_id);
 		if (err) {
-- 
2.39.2



