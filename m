Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D67471B424F;
	Sun,  7 Sep 2025 20:12:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757275961; cv=none; b=p8FK461dUnMZ7dr0BxdVZrZ8u7DZazAEc4TQa2WJNz1V7+QJShm762HvUwlQMvnxJcv6a0FAj4KZG6Nnod+py8TWYskQds1COBwvAurpZoXZG5+zyym1d5yZXJxN1VBKGe/UBbHO3z3f5n4QR8pDRFb6rbrQ+iwOBI/nvazozc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757275961; c=relaxed/simple;
	bh=XAUcrVrfyQ+iKEo9chtZqLVg3xmT7xGTtbn4V7cf/zw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kgadRzR6C3wYyJWIIpW6jNagTNr74ibczhsMvPWcV0GcSm6Y98mnO1bZQOD/LJz3+HEdJEN8hJX7TFSqaegQ9cUiuYJKcc/rbGOl5SrqQfIJ6I9L6Wawn6uY/mvUFHsrgLmlJ6QlwEGAl/pN7IuIittqblOmMYHlysA8Nh4F9hQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VgWXZaOH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VgWXZaOH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B449C4CEF0;
	Sun,  7 Sep 2025 20:12:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757275961;
	bh=XAUcrVrfyQ+iKEo9chtZqLVg3xmT7xGTtbn4V7cf/zw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VgWXZaOHm2V/IQsM39+T45FXPT1XyZoGWYFB/k8qMReTcaX2vG8mCvH08MC47DWhF
	 DVkwY1g3oW+R7bk7GopsOouznfMsN/x5fDNe0g7r8Fc38ryY9Hm1Ea4zaAay1HQwTb
	 RxVZA/UAnORJHGJWtT1IP+iH08pHw6NHKmS8drhk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Borkmann <daniel@iogearbox.net>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 02/64] bpf: Move cgroup iterator helpers to bpf.h
Date: Sun,  7 Sep 2025 21:57:44 +0200
Message-ID: <20250907195603.462681962@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195603.394640159@linuxfoundation.org>
References: <20250907195603.394640159@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Borkmann <daniel@iogearbox.net>

[ Upstream commit 9621e60f59eae87eb9ffe88d90f24f391a1ef0f0 ]

Move them into bpf.h given we also need them in core code.

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/r/20250730234733.530041-3-daniel@iogearbox.net
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/bpf-cgroup.h |   5 --
 include/linux/bpf.h        | 109 ++++++++++++++++++++++++++++++++++---
 2 files changed, 101 insertions(+), 13 deletions(-)

diff --git a/include/linux/bpf-cgroup.h b/include/linux/bpf-cgroup.h
index 3536ab432b30c..79c9d3d412cb6 100644
--- a/include/linux/bpf-cgroup.h
+++ b/include/linux/bpf-cgroup.h
@@ -91,9 +91,6 @@ to_cgroup_bpf_attach_type(enum bpf_attach_type attach_type)
 extern struct static_key_false cgroup_bpf_enabled_key[MAX_CGROUP_BPF_ATTACH_TYPE];
 #define cgroup_bpf_enabled(atype) static_branch_unlikely(&cgroup_bpf_enabled_key[atype])
 
-#define for_each_cgroup_storage_type(stype) \
-	for (stype = 0; stype < MAX_BPF_CGROUP_STORAGE_TYPE; stype++)
-
 struct bpf_cgroup_storage_map;
 
 struct bpf_storage_buffer {
@@ -545,8 +542,6 @@ static inline int bpf_percpu_cgroup_storage_update(struct bpf_map *map,
 #define BPF_CGROUP_RUN_PROG_SETSOCKOPT(sock, level, optname, optval, optlen, \
 				       kernel_optval) ({ 0; })
 
-#define for_each_cgroup_storage_type(stype) for (; false; )
-
 #endif /* CONFIG_CGROUP_BPF */
 
 #endif /* _BPF_CGROUP_H */
diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index dd6a62134e7d1..6cf63f4240bdd 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -157,6 +157,107 @@ struct bpf_map_ops {
 	const struct bpf_iter_seq_info *iter_seq_info;
 };
 
+enum {
+	/* Support at most 11 fields in a BTF type */
+	BTF_FIELDS_MAX	   = 11,
+};
+
+enum btf_field_type {
+	BPF_SPIN_LOCK  = (1 << 0),
+	BPF_TIMER      = (1 << 1),
+	BPF_KPTR_UNREF = (1 << 2),
+	BPF_KPTR_REF   = (1 << 3),
+	BPF_KPTR_PERCPU = (1 << 4),
+	BPF_KPTR       = BPF_KPTR_UNREF | BPF_KPTR_REF | BPF_KPTR_PERCPU,
+	BPF_LIST_HEAD  = (1 << 5),
+	BPF_LIST_NODE  = (1 << 6),
+	BPF_RB_ROOT    = (1 << 7),
+	BPF_RB_NODE    = (1 << 8),
+	BPF_GRAPH_NODE = BPF_RB_NODE | BPF_LIST_NODE,
+	BPF_GRAPH_ROOT = BPF_RB_ROOT | BPF_LIST_HEAD,
+	BPF_REFCOUNT   = (1 << 9),
+	BPF_WORKQUEUE  = (1 << 10),
+	BPF_UPTR       = (1 << 11),
+	BPF_RES_SPIN_LOCK = (1 << 12),
+};
+
+enum bpf_cgroup_storage_type {
+	BPF_CGROUP_STORAGE_SHARED,
+	BPF_CGROUP_STORAGE_PERCPU,
+	__BPF_CGROUP_STORAGE_MAX
+#define MAX_BPF_CGROUP_STORAGE_TYPE __BPF_CGROUP_STORAGE_MAX
+};
+
+#ifdef CONFIG_CGROUP_BPF
+# define for_each_cgroup_storage_type(stype) \
+	for (stype = 0; stype < MAX_BPF_CGROUP_STORAGE_TYPE; stype++)
+#else
+# define for_each_cgroup_storage_type(stype) for (; false; )
+#endif /* CONFIG_CGROUP_BPF */
+
+typedef void (*btf_dtor_kfunc_t)(void *);
+
+struct btf_field_kptr {
+	struct btf *btf;
+	struct module *module;
+	/* dtor used if btf_is_kernel(btf), otherwise the type is
+	 * program-allocated, dtor is NULL,  and __bpf_obj_drop_impl is used
+	 */
+	btf_dtor_kfunc_t dtor;
+	u32 btf_id;
+};
+
+struct btf_field_graph_root {
+	struct btf *btf;
+	u32 value_btf_id;
+	u32 node_offset;
+	struct btf_record *value_rec;
+};
+
+struct btf_field {
+	u32 offset;
+	u32 size;
+	enum btf_field_type type;
+	union {
+		struct btf_field_kptr kptr;
+		struct btf_field_graph_root graph_root;
+	};
+};
+
+struct btf_record {
+	u32 cnt;
+	u32 field_mask;
+	int spin_lock_off;
+	int res_spin_lock_off;
+	int timer_off;
+	int wq_off;
+	int refcount_off;
+	struct btf_field fields[];
+};
+
+/* Non-opaque version of bpf_rb_node in uapi/linux/bpf.h */
+struct bpf_rb_node_kern {
+	struct rb_node rb_node;
+	void *owner;
+} __attribute__((aligned(8)));
+
+/* Non-opaque version of bpf_list_node in uapi/linux/bpf.h */
+struct bpf_list_node_kern {
+	struct list_head list_head;
+	void *owner;
+} __attribute__((aligned(8)));
+
+/* 'Ownership' of program-containing map is claimed by the first program
+ * that is going to use this map or by the first program which FD is
+ * stored in the map to make sure that all callers and callees have the
+ * same prog type, JITed flag and xdp_has_frags flag.
+ */
+struct bpf_map_owner {
+	enum bpf_prog_type type;
+	bool jited;
+	bool xdp_has_frags;
+	const struct btf_type *attach_func_proto;
+};
 struct bpf_map {
 	/* The first two cachelines with read-mostly members of which some
 	 * are also accessed in fast-path (e.g. ops, max_entries).
@@ -614,14 +715,6 @@ struct bpf_prog_offload {
 	u32			jited_len;
 };
 
-enum bpf_cgroup_storage_type {
-	BPF_CGROUP_STORAGE_SHARED,
-	BPF_CGROUP_STORAGE_PERCPU,
-	__BPF_CGROUP_STORAGE_MAX
-};
-
-#define MAX_BPF_CGROUP_STORAGE_TYPE __BPF_CGROUP_STORAGE_MAX
-
 /* The longest tracepoint has 12 args.
  * See include/trace/bpf_probe.h
  */
-- 
2.50.1



