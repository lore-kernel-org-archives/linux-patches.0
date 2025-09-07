Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C71F22F74D;
	Sun,  7 Sep 2025 20:28:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276887; cv=none; b=WjtE3utaQ1MnSTHM/FWn1yy3ysD3pUnKSpwytVIUy2kfMUDERGxM7NJSZFK45TmB193noabMr+Ysb2T9Ng+dHqUziobDJmlAvJc5LSsgKcPWM6N8oIEyIyRkZh9hUaN3G9yRBbpJv9wN8tdJZh86gJydmls0bpR+iJhCJlEgDao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276887; c=relaxed/simple;
	bh=VuljK0UU1aUSa3gTlk6Wz3l7v2fnT0f5VcsLm+gQNGo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ca1Wk87cxy/eEjnDZsLxEgxVMeSxGe6nY10OeG80pIbhjDIR7/NBqqwZNA2kSMGqtJD0RbBhRsXcXsSUPgVzUkGZEiYljtMcOlMxeb/UMI+y2n02o5EupeD/LStk/seKyl1BuusVTIRpbCBRFU7oqPTAOspTrG7Xpc7K+MnTqk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A65G/o3f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A65G/o3f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8347AC4CEF0;
	Sun,  7 Sep 2025 20:28:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276886;
	bh=VuljK0UU1aUSa3gTlk6Wz3l7v2fnT0f5VcsLm+gQNGo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A65G/o3flzS1WIas6UwSZduzmGKcnI9ApdG/+Q5u8pp4Voir0YLPRQW+nA6F4+op6
	 lC/E0Ae+23XuroU5TRqhF21dkg+YR+QjJQrgY6/uMQ2D63xFWnU6J8hfLKil2G8tCR
	 r6gOM2ncL7o6d+PuXCBAkF5F6NfDeNH9AGMJjKa8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Borkmann <daniel@iogearbox.net>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 002/175] bpf: Move bpf map owner out of common struct
Date: Sun,  7 Sep 2025 21:56:37 +0200
Message-ID: <20250907195614.948663604@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195614.892725141@linuxfoundation.org>
References: <20250907195614.892725141@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Borkmann <daniel@iogearbox.net>

[ Upstream commit fd1c98f0ef5cbcec842209776505d9e70d8fcd53 ]

Given this is only relevant for BPF tail call maps, it is adding up space
and penalizing other map types. We also need to extend this with further
objects to track / compare to. Therefore, lets move this out into a separate
structure and dynamically allocate it only for BPF tail call maps.

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/r/20250730234733.530041-2-daniel@iogearbox.net
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Stable-dep-of: abad3d0bad72 ("bpf: Fix oob access in cgroup local storage")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/bpf.h  | 36 ++++++++++++++++++++++++------------
 kernel/bpf/core.c    | 35 ++++++++++++++++++-----------------
 kernel/bpf/syscall.c | 13 +++++++------
 3 files changed, 49 insertions(+), 35 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index fcf48bd746001..cf3ca7b7f4487 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -256,6 +256,18 @@ struct bpf_list_node_kern {
 	void *owner;
 } __attribute__((aligned(8)));
 
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
+
 struct bpf_map {
 	const struct bpf_map_ops *ops;
 	struct bpf_map *inner_map_meta;
@@ -288,18 +300,8 @@ struct bpf_map {
 		struct rcu_head rcu;
 	};
 	atomic64_t writecnt;
-	/* 'Ownership' of program-containing map is claimed by the first program
-	 * that is going to use this map or by the first program which FD is
-	 * stored in the map to make sure that all callers and callees have the
-	 * same prog type, JITed flag and xdp_has_frags flag.
-	 */
-	struct {
-		const struct btf_type *attach_func_proto;
-		spinlock_t lock;
-		enum bpf_prog_type type;
-		bool jited;
-		bool xdp_has_frags;
-	} owner;
+	spinlock_t owner_lock;
+	struct bpf_map_owner *owner;
 	bool bypass_spec_v1;
 	bool frozen; /* write-once; write-protected by freeze_mutex */
 	bool free_after_mult_rcu_gp;
@@ -1981,6 +1983,16 @@ static inline bool bpf_map_flags_access_ok(u32 access_flags)
 	       (BPF_F_RDONLY_PROG | BPF_F_WRONLY_PROG);
 }
 
+static inline struct bpf_map_owner *bpf_map_owner_alloc(struct bpf_map *map)
+{
+	return kzalloc(sizeof(*map->owner), GFP_ATOMIC);
+}
+
+static inline void bpf_map_owner_free(struct bpf_map *map)
+{
+	kfree(map->owner);
+}
+
 struct bpf_event_entry {
 	struct perf_event *event;
 	struct file *perf_file;
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 767dcb8471f63..0e2daea7e1efc 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -2310,28 +2310,29 @@ static bool __bpf_prog_map_compatible(struct bpf_map *map,
 				      const struct bpf_prog *fp)
 {
 	enum bpf_prog_type prog_type = resolve_prog_type(fp);
-	bool ret;
 	struct bpf_prog_aux *aux = fp->aux;
+	bool ret = false;
 
 	if (fp->kprobe_override)
-		return false;
+		return ret;
 
-	spin_lock(&map->owner.lock);
-	if (!map->owner.type) {
-		/* There's no owner yet where we could check for
-		 * compatibility.
-		 */
-		map->owner.type  = prog_type;
-		map->owner.jited = fp->jited;
-		map->owner.xdp_has_frags = aux->xdp_has_frags;
-		map->owner.attach_func_proto = aux->attach_func_proto;
+	spin_lock(&map->owner_lock);
+	/* There's no owner yet where we could check for compatibility. */
+	if (!map->owner) {
+		map->owner = bpf_map_owner_alloc(map);
+		if (!map->owner)
+			goto err;
+		map->owner->type  = prog_type;
+		map->owner->jited = fp->jited;
+		map->owner->xdp_has_frags = aux->xdp_has_frags;
+		map->owner->attach_func_proto = aux->attach_func_proto;
 		ret = true;
 	} else {
-		ret = map->owner.type  == prog_type &&
-		      map->owner.jited == fp->jited &&
-		      map->owner.xdp_has_frags == aux->xdp_has_frags;
+		ret = map->owner->type  == prog_type &&
+		      map->owner->jited == fp->jited &&
+		      map->owner->xdp_has_frags == aux->xdp_has_frags;
 		if (ret &&
-		    map->owner.attach_func_proto != aux->attach_func_proto) {
+		    map->owner->attach_func_proto != aux->attach_func_proto) {
 			switch (prog_type) {
 			case BPF_PROG_TYPE_TRACING:
 			case BPF_PROG_TYPE_LSM:
@@ -2344,8 +2345,8 @@ static bool __bpf_prog_map_compatible(struct bpf_map *map,
 			}
 		}
 	}
-	spin_unlock(&map->owner.lock);
-
+err:
+	spin_unlock(&map->owner_lock);
 	return ret;
 }
 
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 27cacdde359e8..ba4543e771a6e 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -767,6 +767,7 @@ static void bpf_map_free_deferred(struct work_struct *work)
 
 	security_bpf_map_free(map);
 	bpf_map_release_memcg(map);
+	bpf_map_owner_free(map);
 	bpf_map_free(map);
 }
 
@@ -861,12 +862,12 @@ static void bpf_map_show_fdinfo(struct seq_file *m, struct file *filp)
 	struct bpf_map *map = filp->private_data;
 	u32 type = 0, jited = 0;
 
-	if (map_type_contains_progs(map)) {
-		spin_lock(&map->owner.lock);
-		type  = map->owner.type;
-		jited = map->owner.jited;
-		spin_unlock(&map->owner.lock);
+	spin_lock(&map->owner_lock);
+	if (map->owner) {
+		type  = map->owner->type;
+		jited = map->owner->jited;
 	}
+	spin_unlock(&map->owner_lock);
 
 	seq_printf(m,
 		   "map_type:\t%u\n"
@@ -1369,7 +1370,7 @@ static int map_create(union bpf_attr *attr)
 	atomic64_set(&map->refcnt, 1);
 	atomic64_set(&map->usercnt, 1);
 	mutex_init(&map->freeze_mutex);
-	spin_lock_init(&map->owner.lock);
+	spin_lock_init(&map->owner_lock);
 
 	if (attr->btf_key_type_id || attr->btf_value_type_id ||
 	    /* Even the map's value is a kernel's struct,
-- 
2.50.1



