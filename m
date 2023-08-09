Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A970F15AE3
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 10:47:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29FBEC433C8;
	Wed,  9 Aug 2023 10:47:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691578074;
	bh=eqMjIeACuqBaU+tdq/JmjYe2fBgD1+vLuvGkii3UAF8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0/ZMRZ6ttawUlcW41YrhtYS+mcqt2qa8UDgmJbWxgdz4tsFjyEMEzz8jeCUWBjX8k
	 HRS4BHv2JyYvJDV84gG6kN9Hb9CHQszR44kUgodnb24a0zZDKLLKMahiptcH12Ewgu
	 ggoyNosZAiTci/bL2kYvH9c4EfqdtvsIEA5jGqeQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrii Nakryiko <andrii@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Stanislav Fomichev <sdf@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 067/165] bpf: Inline map creation logic in map_create() function
Date: Wed,  9 Aug 2023 12:39:58 +0200
Message-ID: <20230809103645.006991822@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103642.720851262@linuxfoundation.org>
References: <20230809103642.720851262@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Andrii Nakryiko <andrii@kernel.org>

[ Upstream commit 22db41226b679768df8f0a4ff5de8e58f625f45b ]

Currently find_and_alloc_map() performs two separate functions: some
argument sanity checking and partial map creation workflow hanling.
Neither of those functions are self-sufficient and are augmented by
further checks and initialization logic in the caller (map_create()
function). So unify all the sanity checks, permission checks, and
creation and initialization logic in one linear piece of code in
map_create() instead. This also make it easier to further enhance
permission checks and keep them located in one place.

Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Stanislav Fomichev <sdf@google.com>
Link: https://lore.kernel.org/bpf/20230613223533.3689589-3-andrii@kernel.org
Stable-dep-of: 640a604585aa ("bpf, cpumap: Make sure kthread is running before map update returns")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/syscall.c | 57 +++++++++++++++++++-------------------------
 1 file changed, 24 insertions(+), 33 deletions(-)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 0a7238125e1a4..8fddf0eea9bf2 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -109,37 +109,6 @@ const struct bpf_map_ops bpf_map_offload_ops = {
 	.map_mem_usage = bpf_map_offload_map_mem_usage,
 };
 
-static struct bpf_map *find_and_alloc_map(union bpf_attr *attr)
-{
-	const struct bpf_map_ops *ops;
-	u32 type = attr->map_type;
-	struct bpf_map *map;
-	int err;
-
-	if (type >= ARRAY_SIZE(bpf_map_types))
-		return ERR_PTR(-EINVAL);
-	type = array_index_nospec(type, ARRAY_SIZE(bpf_map_types));
-	ops = bpf_map_types[type];
-	if (!ops)
-		return ERR_PTR(-EINVAL);
-
-	if (ops->map_alloc_check) {
-		err = ops->map_alloc_check(attr);
-		if (err)
-			return ERR_PTR(err);
-	}
-	if (attr->map_ifindex)
-		ops = &bpf_map_offload_ops;
-	if (!ops->map_mem_usage)
-		return ERR_PTR(-EINVAL);
-	map = ops->map_alloc(attr);
-	if (IS_ERR(map))
-		return map;
-	map->ops = ops;
-	map->map_type = type;
-	return map;
-}
-
 static void bpf_map_write_active_inc(struct bpf_map *map)
 {
 	atomic64_inc(&map->writecnt);
@@ -1127,7 +1096,9 @@ static int map_check_btf(struct bpf_map *map, const struct btf *btf,
 /* called via syscall */
 static int map_create(union bpf_attr *attr)
 {
+	const struct bpf_map_ops *ops;
 	int numa_node = bpf_map_attr_numa_node(attr);
+	u32 map_type = attr->map_type;
 	struct bpf_map *map;
 	int f_flags;
 	int err;
@@ -1157,6 +1128,25 @@ static int map_create(union bpf_attr *attr)
 	     !node_online(numa_node)))
 		return -EINVAL;
 
+	/* find map type and init map: hashtable vs rbtree vs bloom vs ... */
+	map_type = attr->map_type;
+	if (map_type >= ARRAY_SIZE(bpf_map_types))
+		return -EINVAL;
+	map_type = array_index_nospec(map_type, ARRAY_SIZE(bpf_map_types));
+	ops = bpf_map_types[map_type];
+	if (!ops)
+		return -EINVAL;
+
+	if (ops->map_alloc_check) {
+		err = ops->map_alloc_check(attr);
+		if (err)
+			return err;
+	}
+	if (attr->map_ifindex)
+		ops = &bpf_map_offload_ops;
+	if (!ops->map_mem_usage)
+		return -EINVAL;
+
 	/* Intent here is for unprivileged_bpf_disabled to block BPF map
 	 * creation for unprivileged users; other actions depend
 	 * on fd availability and access to bpffs, so are dependent on
@@ -1166,10 +1156,11 @@ static int map_create(union bpf_attr *attr)
 	if (sysctl_unprivileged_bpf_disabled && !bpf_capable())
 		return -EPERM;
 
-	/* find map type and init map: hashtable vs rbtree vs bloom vs ... */
-	map = find_and_alloc_map(attr);
+	map = ops->map_alloc(attr);
 	if (IS_ERR(map))
 		return PTR_ERR(map);
+	map->ops = ops;
+	map->map_type = map_type;
 
 	err = bpf_obj_name_cpy(map->name, attr->map_name,
 			       sizeof(attr->map_name));
-- 
2.40.1



