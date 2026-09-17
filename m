Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0EA53C9886;
	Thu, 17 Sep 2026 19:01:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671718; cv=none; b=c4SkG6h64XZYWPrm1nC5fNeVbEDdtG7qptSjKsQQ62QDg0sF/LqEpKN755edqz9lZykvZnDsLmUWhZZL3maooixlgrPiNyfAeuVz8gisk/5DcANTS6W4gTvqNFX1BLuLvWT/J08JiUUSPtRqXMjgiVWcupsYJb31RC+iambX97U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671718; c=relaxed/simple;
	bh=C0VFnIghYTdw8TsVidA/GqYVuCXth671kWOGmXUIAXc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YccLobZY2u7wX7S7N3K1hB0f3Nk7FLSIUV+lPQo7uAtHJmr0KzxW0zHJe8d/OIhzPNrJYXVRs3TMhuC9Ss84fKxYutGMpIWdSGiPo7ZbJlCm1eQ16DAvEMGDwAuZyhtM3u/3J66Z42a/aOzK9Gm+oaE5IR3DiHMo2qwdX5C9iXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YDP3T/FP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YDP3T/FP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E97F31F000FF;
	Thu, 17 Sep 2026 19:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671716;
	bh=dmHkbx6677HhM6LpBiVXtUDyvHhLWmPsnkyaf+mvZeM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YDP3T/FPCp4+61+M5zqE2CLboO4fOOCVuvAtHOLgEXuQHLngsygjq8pbwsQeMXdVX
	 pBVzoXaebD6VCUPwfcwGt/13J1xk5zOCrKiRnF5RpMiCABrBbJjn5CGU+5hFCJygmx
	 W0EOxi9aCfIDH3GJA8yXjvce9+pir/YdsJXqHV84=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Olsa <jolsa@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1067/1102] bpf: Factor stackid_init function from __bpf_get_stackid
Date: Thu, 17 Sep 2026 16:16:50 +0100
Message-ID: <20260917151607.609630536@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: Jiri Olsa <jolsa@kernel.org>

[ Upstream commit 15b837759a97237d647962f9943afe0d55af615a ]

The new stackid_init function stores all the necessary bits for stackid
trace and it will be used by other functions in following changes.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20260803210149.296496-2-jolsa@kernel.org
Stable-dep-of: 15f1bd857466 ("bpf: Disable preemption in bpf_get_stackid")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/stackmap.c |   95 +++++++++++++++++++++++++++++++-------------------
 1 file changed, 59 insertions(+), 36 deletions(-)

--- a/kernel/bpf/stackmap.c
+++ b/kernel/bpf/stackmap.c
@@ -246,33 +246,54 @@ get_callchain_entry_for_task(struct task
 #endif
 }
 
-static long __bpf_get_stackid(struct bpf_map *map,
-			      struct perf_callchain_entry *trace, u64 flags)
+struct stackid {
+	struct stack_map_bucket *bucket;
+	u64 *ips;
+	u32  nr;
+	u32  len;
+	u32  hash;
+	u32  id;
+};
+
+static int stackid_init(struct stackid *stackid, struct bpf_map *map,
+			struct perf_callchain_entry *trace, u64 flags)
 {
 	struct bpf_stack_map *smap = container_of(map, struct bpf_stack_map, map);
-	struct stack_map_bucket *bucket, *new_bucket, *old_bucket;
-	u32 hash, id, trace_nr, trace_len, i, max_depth;
 	u32 skip = flags & BPF_F_SKIP_FIELD_MASK;
-	bool user = flags & BPF_F_USER_STACK;
-	u64 *ips;
-	bool hash_matches;
+	u32 max_depth;
 
 	if (trace->nr <= skip)
 		/* skipping more than usable stack trace */
 		return -EFAULT;
 
 	max_depth = stack_map_calculate_max_depth(map->value_size, stack_map_data_size(map), flags);
-	trace_nr = min_t(u32, trace->nr - skip, max_depth - skip);
-	trace_len = trace_nr * sizeof(u64);
-	ips = trace->ip + skip;
-	hash = jhash2((u32 *)ips, trace_len / sizeof(u32), 0);
-	id = hash & (smap->n_buckets - 1);
-	bucket = READ_ONCE(smap->buckets[id]);
+	stackid->nr = min_t(u32, trace->nr - skip, max_depth - skip);
+	stackid->len = stackid->nr * sizeof(u64);
+	stackid->ips = trace->ip + skip;
+	stackid->hash = jhash2((u32 *)stackid->ips, stackid->len / sizeof(u32), 0);
+	stackid->id = stackid->hash & (smap->n_buckets - 1);
+	stackid->bucket = READ_ONCE(smap->buckets[stackid->id]);
+	return 0;
+}
+
+static long __bpf_get_stackid(struct stackid *stackid, struct bpf_map *map,
+			      struct perf_callchain_entry *trace, u64 flags)
+{
+	struct bpf_stack_map *smap = container_of(map, struct bpf_stack_map, map);
+	struct stack_map_bucket *new_bucket, *old_bucket;
+	bool user = flags & BPF_F_USER_STACK;
+	bool hash_matches;
+	u32 trace_len, i;
+	int err;
+
+	err = stackid_init(stackid, map, trace, flags);
+	if (err)
+		return err;
 
-	hash_matches = bucket && bucket->hash == hash;
+	hash_matches = stackid->bucket && stackid->bucket->hash == stackid->hash;
 	/* fast cmp */
 	if (hash_matches && flags & BPF_F_FAST_STACK_CMP)
-		return id;
+		return stackid->id;
 
 	if (stack_map_use_build_id(map)) {
 		struct bpf_stack_build_id *id_offs;
@@ -282,42 +303,42 @@ static long __bpf_get_stackid(struct bpf
 			pcpu_freelist_pop(&smap->freelist);
 		if (unlikely(!new_bucket))
 			return -ENOMEM;
-		new_bucket->nr = trace_nr;
+		new_bucket->nr = stackid->nr;
 		id_offs = (struct bpf_stack_build_id *)new_bucket->data;
-		for (i = 0; i < trace_nr; i++)
-			id_offs[i].ip = ips[i];
-		stack_map_get_build_id_offset(id_offs, trace_nr, user, false /* !may_fault */);
-		trace_len = trace_nr * sizeof(struct bpf_stack_build_id);
-		if (hash_matches && bucket->nr == trace_nr &&
-		    memcmp(bucket->data, new_bucket->data, trace_len) == 0) {
+		for (i = 0; i < stackid->nr; i++)
+			id_offs[i].ip = stackid->ips[i];
+		stack_map_get_build_id_offset(id_offs, stackid->nr, user, false /* !may_fault */);
+		trace_len = stackid->nr * sizeof(struct bpf_stack_build_id);
+		if (hash_matches && stackid->bucket->nr == stackid->nr &&
+		    memcmp(stackid->bucket->data, new_bucket->data, trace_len) == 0) {
 			pcpu_freelist_push(&smap->freelist, &new_bucket->fnode);
-			return id;
+			return stackid->id;
 		}
-		if (bucket && !(flags & BPF_F_REUSE_STACKID)) {
+		if (stackid->bucket && !(flags & BPF_F_REUSE_STACKID)) {
 			pcpu_freelist_push(&smap->freelist, &new_bucket->fnode);
 			return -EEXIST;
 		}
 	} else {
-		if (hash_matches && bucket->nr == trace_nr &&
-		    memcmp(bucket->data, ips, trace_len) == 0)
-			return id;
-		if (bucket && !(flags & BPF_F_REUSE_STACKID))
+		if (hash_matches && stackid->bucket->nr == stackid->nr &&
+		    memcmp(stackid->bucket->data, stackid->ips, stackid->len) == 0)
+			return stackid->id;
+		if (stackid->bucket && !(flags & BPF_F_REUSE_STACKID))
 			return -EEXIST;
 
 		new_bucket = (struct stack_map_bucket *)
 			pcpu_freelist_pop(&smap->freelist);
 		if (unlikely(!new_bucket))
 			return -ENOMEM;
-		memcpy(new_bucket->data, ips, trace_len);
+		memcpy(new_bucket->data, stackid->ips, stackid->len);
 	}
 
-	new_bucket->hash = hash;
-	new_bucket->nr = trace_nr;
+	new_bucket->hash = stackid->hash;
+	new_bucket->nr = stackid->nr;
 
-	old_bucket = xchg(&smap->buckets[id], new_bucket);
+	old_bucket = xchg(&smap->buckets[stackid->id], new_bucket);
 	if (old_bucket)
 		pcpu_freelist_push(&smap->freelist, &old_bucket->fnode);
-	return id;
+	return stackid->id;
 }
 
 BPF_CALL_3(bpf_get_stackid, struct pt_regs *, regs, struct bpf_map *, map,
@@ -326,6 +347,7 @@ BPF_CALL_3(bpf_get_stackid, struct pt_re
 	u32 elem_size = stack_map_data_size(map);
 	bool user = flags & BPF_F_USER_STACK;
 	struct perf_callchain_entry *trace;
+	struct stackid stackid;
 	bool kernel = !user;
 	u32 max_depth;
 
@@ -341,7 +363,7 @@ BPF_CALL_3(bpf_get_stackid, struct pt_re
 		/* couldn't fetch the stack trace */
 		return -EFAULT;
 
-	return __bpf_get_stackid(map, trace, flags);
+	return __bpf_get_stackid(&stackid, map, trace, flags);
 }
 
 const struct bpf_func_proto bpf_get_stackid_proto = {
@@ -370,6 +392,7 @@ BPF_CALL_3(bpf_get_stackid_pe, struct bp
 {
 	struct perf_event *event = ctx->event;
 	struct perf_callchain_entry *trace;
+	struct stackid stackid;
 	bool kernel, user;
 	__u64 nr_kernel;
 	int ret;
@@ -395,7 +418,7 @@ BPF_CALL_3(bpf_get_stackid_pe, struct bp
 
 	if (kernel) {
 		trace->nr = nr_kernel;
-		ret = __bpf_get_stackid(map, trace, flags);
+		ret = __bpf_get_stackid(&stackid, map, trace, flags);
 	} else { /* user */
 		u64 skip = flags & BPF_F_SKIP_FIELD_MASK;
 
@@ -404,7 +427,7 @@ BPF_CALL_3(bpf_get_stackid_pe, struct bp
 			return -EFAULT;
 
 		flags = (flags & ~BPF_F_SKIP_FIELD_MASK) | skip;
-		ret = __bpf_get_stackid(map, trace, flags);
+		ret = __bpf_get_stackid(&stackid, map, trace, flags);
 	}
 
 	/* restore nr */


