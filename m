Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF11B1B424F;
	Sun,  7 Sep 2025 20:13:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757275987; cv=none; b=T0Bgv6MD6O2Aa8RcMmi0hPYhmv9l8cgsbCO/VKtuI7Qpyn3i1bGULFn4iX/+kfZJKOHMsGqaSjK4nZ4HlsjzGT1CZc7482paxXXGaHp10241e22Eg0sEpCxRZDSy4jiaev3tCo0HhThT4z7cRr0p7uI6FajOgVlnDmdX1E6YD6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757275987; c=relaxed/simple;
	bh=ImRZFlMejHtBl+EAekETkuEOIyCclLJuXh78Yv5065U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AJk9VdUY9h8fkivqVXkaS2KgD4IYWXzq2S2MMd+XcX9XAa36VjVM0CQpusvV47F9f7lv6rEkUdpEw++rCZwNoP7gmFmpPzCC63W2PEdapUs95SVWgQ6xsq82+nIf5RNObDeY10QVujH9tG9LwmDLUQZRgeyZ419BV8bG2EbaM6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f1ou2IMo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f1ou2IMo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C6A9C4CEF0;
	Sun,  7 Sep 2025 20:13:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757275987;
	bh=ImRZFlMejHtBl+EAekETkuEOIyCclLJuXh78Yv5065U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f1ou2IMom68bVilAMXm4nTiU3dMeQLU80FLaHMk6rcC5q2Na2RwR0a3Nu2WXK/cWZ
	 8GjVAxzmrNeBvt74jnZkqRlTRDjj19UCZj8NybOmQZwfX3La9IkZKv6mpjgSjNOnd0
	 WTl+Xp8tVVR7TJ5zSGhZ3iDPFRKikXMg29IH+/2A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Borkmann <daniel@iogearbox.net>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 03/64] bpf: Move bpf map owner out of common struct
Date: Sun,  7 Sep 2025 21:57:45 +0200
Message-ID: <20250907195603.489323792@linuxfoundation.org>
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

[ Upstream commit fd1c98f0ef5cbcec842209776505d9e70d8fcd53 ]

Given this is only relevant for BPF tail call maps, it is adding up space
and penalizing other map types. We also need to extend this with further
objects to track / compare to. Therefore, lets move this out into a separate
structure and dynamically allocate it only for BPF tail call maps.

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/r/20250730234733.530041-2-daniel@iogearbox.net
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/bpf.h   | 23 +++++++++--------
 kernel/bpf/arraymap.c |  1 -
 kernel/bpf/core.c     | 58 ++++++++++++++++++++++++++++++++-----------
 kernel/bpf/syscall.c  | 16 ++++++------
 4 files changed, 64 insertions(+), 34 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 6cf63f4240bdd..ea6728c304fe0 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -258,6 +258,7 @@ struct bpf_map_owner {
 	bool xdp_has_frags;
 	const struct btf_type *attach_func_proto;
 };
+
 struct bpf_map {
 	/* The first two cachelines with read-mostly members of which some
 	 * are also accessed in fast-path (e.g. ops, max_entries).
@@ -300,6 +301,8 @@ struct bpf_map {
 	};
 	struct mutex freeze_mutex;
 	atomic64_t writecnt;
+	spinlock_t owner_lock;
+	struct bpf_map_owner *owner;
 	bool free_after_mult_rcu_gp;
 	u64 cookie; /* write-once */
 };
@@ -1091,16 +1094,6 @@ struct bpf_prog_aux {
 };
 
 struct bpf_array_aux {
-	/* 'Ownership' of prog array is claimed by the first program that
-	 * is going to use this map or by the first program which FD is
-	 * stored in the map to make sure that all callers and callees have
-	 * the same prog type and JITed flag.
-	 */
-	struct {
-		spinlock_t lock;
-		enum bpf_prog_type type;
-		bool jited;
-	} owner;
 	/* Programs with direct jumps into programs part of this array. */
 	struct list_head poke_progs;
 	struct bpf_map *map;
@@ -1248,6 +1241,16 @@ static inline bool bpf_map_flags_access_ok(u32 access_flags)
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
diff --git a/kernel/bpf/arraymap.c b/kernel/bpf/arraymap.c
index 2788da290c216..dc42970dda975 100644
--- a/kernel/bpf/arraymap.c
+++ b/kernel/bpf/arraymap.c
@@ -1044,7 +1044,6 @@ static struct bpf_map *prog_array_map_alloc(union bpf_attr *attr)
 	INIT_WORK(&aux->work, prog_array_map_clear_deferred);
 	INIT_LIST_HEAD(&aux->poke_progs);
 	mutex_init(&aux->poke_mutex);
-	spin_lock_init(&aux->owner.lock);
 
 	map = array_map_alloc(attr);
 	if (IS_ERR(map)) {
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 1ded3eb492b8e..aa3487e244549 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -1832,31 +1832,59 @@ static unsigned int __bpf_prog_ret0_warn(const void *ctx,
 }
 #endif
 
-bool bpf_prog_array_compatible(struct bpf_array *array,
-			       const struct bpf_prog *fp)
+static bool __bpf_prog_map_compatible(struct bpf_map *map,
+				      const struct bpf_prog *fp)
 {
-	bool ret;
+	enum bpf_prog_type prog_type = fp->aux->dst_prog ? fp->aux->dst_prog->type : fp->type;
+	struct bpf_prog_aux *aux = fp->aux;
+	bool ret = false;
 
 	if (fp->kprobe_override)
-		return false;
-
-	spin_lock(&array->aux->owner.lock);
+		return ret;
 
-	if (!array->aux->owner.type) {
-		/* There's no owner yet where we could check for
-		 * compatibility.
-		 */
-		array->aux->owner.type  = fp->type;
-		array->aux->owner.jited = fp->jited;
+	spin_lock(&map->owner_lock);
+	/* There's no owner yet where we could check for compatibility. */
+	if (!map->owner) {
+		map->owner = bpf_map_owner_alloc(map);
+		if (!map->owner)
+			goto err;
+		map->owner->type  = prog_type;
+		map->owner->jited = fp->jited;
+		/* Note: xdp_has_frags doesn't exist in aux yet in our branch */
+		/* map->owner->xdp_has_frags = aux->xdp_has_frags; */
+		map->owner->attach_func_proto = aux->attach_func_proto;
 		ret = true;
 	} else {
-		ret = array->aux->owner.type  == fp->type &&
-		      array->aux->owner.jited == fp->jited;
+		ret = map->owner->type  == prog_type &&
+		      map->owner->jited == fp->jited;
+		/* Note: xdp_has_frags check would go here when available */
+		/* && map->owner->xdp_has_frags == aux->xdp_has_frags; */
+		if (ret &&
+		    map->owner->attach_func_proto != aux->attach_func_proto) {
+			switch (prog_type) {
+			case BPF_PROG_TYPE_TRACING:
+			case BPF_PROG_TYPE_LSM:
+			case BPF_PROG_TYPE_EXT:
+			case BPF_PROG_TYPE_STRUCT_OPS:
+				ret = false;
+				break;
+			default:
+				break;
+			}
+		}
 	}
-	spin_unlock(&array->aux->owner.lock);
+err:
+	spin_unlock(&map->owner_lock);
 	return ret;
 }
 
+bool bpf_prog_array_compatible(struct bpf_array *array,
+			       const struct bpf_prog *fp)
+{
+	struct bpf_map *map = &array->map;
+	return __bpf_prog_map_compatible(map, fp);
+}
+
 static int bpf_check_tail_call(const struct bpf_prog *fp)
 {
 	struct bpf_prog_aux *aux = fp->aux;
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 6d4d08f57ad38..b80d125dcea97 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -477,6 +477,7 @@ static void bpf_map_free_deferred(struct work_struct *work)
 
 	security_bpf_map_free(map);
 	bpf_map_release_memcg(map);
+	bpf_map_owner_free(map);
 	/* implementation dependent freeing */
 	map->ops->map_free(map);
 }
@@ -576,17 +577,15 @@ static unsigned long bpf_map_memory_footprint(const struct bpf_map *map)
 
 static void bpf_map_show_fdinfo(struct seq_file *m, struct file *filp)
 {
-	const struct bpf_map *map = filp->private_data;
-	const struct bpf_array *array;
+	struct bpf_map *map = filp->private_data;
 	u32 type = 0, jited = 0;
 
-	if (map->map_type == BPF_MAP_TYPE_PROG_ARRAY) {
-		array = container_of(map, struct bpf_array, map);
-		spin_lock(&array->aux->owner.lock);
-		type  = array->aux->owner.type;
-		jited = array->aux->owner.jited;
-		spin_unlock(&array->aux->owner.lock);
+	spin_lock(&map->owner_lock);
+	if (map->owner) {
+		type  = map->owner->type;
+		jited = map->owner->jited;
 	}
+	spin_unlock(&map->owner_lock);
 
 	seq_printf(m,
 		   "map_type:\t%u\n"
@@ -895,6 +894,7 @@ static int map_create(union bpf_attr *attr)
 	atomic64_set(&map->refcnt, 1);
 	atomic64_set(&map->usercnt, 1);
 	mutex_init(&map->freeze_mutex);
+	spin_lock_init(&map->owner_lock);
 
 	map->spin_lock_off = -EINVAL;
 	map->timer_off = -EINVAL;
-- 
2.50.1



