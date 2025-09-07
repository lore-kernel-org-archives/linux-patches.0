Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 107A41A2389;
	Sun,  7 Sep 2025 20:22:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276535; cv=none; b=k4MmwV1d61SY91P0+TqZ6gIz+nFizfZtj3AmiAjvOVJZStbBMZ5mtki/1og1fq2FSd97neCmZOKG/hbekpJ1LJqWKbW/6UBLm2yRxhb1CXbKMg40TTR/rjJBx9Uf41OGN9PgFYDwq8iwMrEUW/XiJJr6bM5Q25b0WODAmLEmfBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276535; c=relaxed/simple;
	bh=zxeo+b42tfOvsQLWEWFfmSkOuItaFqp5OKrK+/3PxVs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N7Ss66+jzAQdcKKKSeWMIgXE2zgpimFQRXghzXuUBjNCPwJ6yd5WKN6civuHTVpthcAEqkGfscDQYk0E8VdOWFRq11y0B66yGm1Woy8yuor5gY3USO9EfC9dbXo0NfH1nyGA7C4Y+UGYw/SgacdRAAg5hP9DkPj9uIFHFuUE17c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jd2gzCss; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jd2gzCss"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74E24C4CEF0;
	Sun,  7 Sep 2025 20:22:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276534;
	bh=zxeo+b42tfOvsQLWEWFfmSkOuItaFqp5OKrK+/3PxVs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jd2gzCssSVEuCInIayLlEaWZY2XN/l4eL8a7HAi00dY4ijaFmj5Cg9PD7OBtFif1h
	 Ad2p3W7Vl4x21Z3BENTvSDbtTMaTns9iHtDbpeO0RugNenThEG57GYoshOoHex+P4h
	 yEjs0iPHGFz2j0mJplU9DRyl/CCT0f5BQRqBHvX4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Borkmann <daniel@iogearbox.net>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 003/121] bpf: Move bpf map owner out of common struct
Date: Sun,  7 Sep 2025 21:57:19 +0200
Message-ID: <20250907195609.906223287@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195609.817339617@linuxfoundation.org>
References: <20250907195609.817339617@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 include/linux/bpf.h  | 36 ++++++++++++++++++++++++------------
 kernel/bpf/core.c    | 35 ++++++++++++++++++-----------------
 kernel/bpf/syscall.c | 14 +++++++-------
 3 files changed, 49 insertions(+), 36 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 730e692e002ff..b8e0204992857 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -258,6 +258,18 @@ struct bpf_list_node_kern {
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
 	/* The first two cachelines with read-mostly members of which some
 	 * are also accessed in fast-path (e.g. ops, max_entries).
@@ -296,18 +308,8 @@ struct bpf_map {
 	};
 	struct mutex freeze_mutex;
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
@@ -1818,6 +1820,16 @@ static inline bool bpf_map_flags_access_ok(u32 access_flags)
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
index 5eaaf95048abc..c3369c66eae8f 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -2262,28 +2262,29 @@ static bool __bpf_prog_map_compatible(struct bpf_map *map,
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
@@ -2296,8 +2297,8 @@ static bool __bpf_prog_map_compatible(struct bpf_map *map,
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
index 1d6bd012de9e6..98f3f206d112e 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -698,6 +698,7 @@ static void bpf_map_free_deferred(struct work_struct *work)
 
 	security_bpf_map_free(map);
 	bpf_map_release_memcg(map);
+	bpf_map_owner_free(map);
 	/* implementation dependent freeing */
 	map->ops->map_free(map);
 	/* Delay freeing of btf_record for maps, as map_free
@@ -715,7 +716,6 @@ static void bpf_map_free_deferred(struct work_struct *work)
 	 */
 	btf_put(btf);
 }
-
 static void bpf_map_put_uref(struct bpf_map *map)
 {
 	if (atomic64_dec_and_test(&map->usercnt)) {
@@ -807,12 +807,12 @@ static void bpf_map_show_fdinfo(struct seq_file *m, struct file *filp)
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
@@ -1262,7 +1262,7 @@ static int map_create(union bpf_attr *attr)
 	atomic64_set(&map->refcnt, 1);
 	atomic64_set(&map->usercnt, 1);
 	mutex_init(&map->freeze_mutex);
-	spin_lock_init(&map->owner.lock);
+	spin_lock_init(&map->owner_lock);
 
 	if (attr->btf_key_type_id || attr->btf_value_type_id ||
 	    /* Even the map's value is a kernel's struct,
-- 
2.50.1



