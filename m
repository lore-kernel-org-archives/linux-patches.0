Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 092433D9DA8;
	Thu, 17 Sep 2026 19:02:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671721; cv=none; b=ZXMClksybdQRAy9F+JayDd5yh+v+FWY6rp+NnJhL9V331vozvZZQBun1ZPY6h2SIrRuc1bkOHk/6CS3M6Y8xGR9Id3dd5OG3nigB2/tD+iPs9SX2uYcNDUCR6BSGNNiBBeVZ2N517wX0gfGcTNfXHi+XoCEuAjYG/0ZpktQznCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671721; c=relaxed/simple;
	bh=9lwrkdneHXouQHiPWO9Inw69tro0VXTwal77bd6wn/0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kQr6wle8Qt4SOqMQQpmlkJ1lk/bNz/xj5m0kZxU9txxGpmIgiaxeNyCPZBa//of+GjCJPRSxNF1bHghHUI+XMHZUQgLmj4ufcESZG3wHtQT3LTMBmULDu4VxJclOO+Vdg0WKPBOw9iuN8E+LPUyZ4GMOYYK6t8R0AlHpqiOqaew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gLbwLDsR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gLbwLDsR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D7531F000FF;
	Thu, 17 Sep 2026 19:01:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671719;
	bh=IsYhxOfk8O7omZbDvqNSB9ynpoX3pSRhhteVEkIgy+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gLbwLDsRB9nprLNUVwLDu5v4S0c/xd3iYczm8qU5xD94aDnciG/v+4wa4uVd6pahR
	 pd6yD8ianheTs8BdV4xbvHktw92FInjHZlWgl8RMlGrPd7FeGMH7dkr8FNJfekrU3V
	 4j94QH97FRWZD8Ouq7dr3Npa6/9g6CA8mwr/z8zE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Olsa <jolsa@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1068/1102] bpf: Factor stackid_fastpath function from __bpf_get_stackid
Date: Thu, 17 Sep 2026 16:16:51 +0100
Message-ID: <20260917151607.635523215@linuxfoundation.org>
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

[ Upstream commit 0ca56befcffec3a6c9d1842eae06c74e1cf41f11 ]

The new stackid_fastpath does the fast stack hash and trace check, that
does not need new bucket allocation. It covers both just-ip and buildid
code paths.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20260803210149.296496-3-jolsa@kernel.org
Stable-dep-of: 15f1bd857466 ("bpf: Disable preemption in bpf_get_stackid")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/stackmap.c |   43 ++++++++++++++++++++++++++++---------------
 1 file changed, 28 insertions(+), 15 deletions(-)

--- a/kernel/bpf/stackmap.c
+++ b/kernel/bpf/stackmap.c
@@ -253,6 +253,7 @@ struct stackid {
 	u32  len;
 	u32  hash;
 	u32  id;
+	bool hash_matches;
 };
 
 static int stackid_init(struct stackid *stackid, struct bpf_map *map,
@@ -273,28 +274,46 @@ static int stackid_init(struct stackid *
 	stackid->hash = jhash2((u32 *)stackid->ips, stackid->len / sizeof(u32), 0);
 	stackid->id = stackid->hash & (smap->n_buckets - 1);
 	stackid->bucket = READ_ONCE(smap->buckets[stackid->id]);
+	stackid->hash_matches = stackid->bucket && stackid->bucket->hash == stackid->hash;
 	return 0;
 }
 
+static int stackid_fastpath(struct stackid *stackid, struct bpf_map *map,
+			    struct perf_callchain_entry *trace, u64 flags)
+{
+	int err;
+
+	err = stackid_init(stackid, map, trace, flags);
+	if (err)
+		return err;
+
+	/* fast cmp */
+	if (stackid->hash_matches && flags & BPF_F_FAST_STACK_CMP)
+		return stackid->id;
+
+	if (stack_map_use_build_id(map))
+		return -ENOENT;
+	if (stackid->hash_matches && stackid->bucket->nr == stackid->nr &&
+	    memcmp(stackid->bucket->data, stackid->ips, stackid->len) == 0)
+		return stackid->id;
+	if (stackid->bucket && !(flags & BPF_F_REUSE_STACKID))
+		return -EEXIST;
+	return -ENOENT;
+}
+
 static long __bpf_get_stackid(struct stackid *stackid, struct bpf_map *map,
 			      struct perf_callchain_entry *trace, u64 flags)
 {
 	struct bpf_stack_map *smap = container_of(map, struct bpf_stack_map, map);
 	struct stack_map_bucket *new_bucket, *old_bucket;
 	bool user = flags & BPF_F_USER_STACK;
-	bool hash_matches;
 	u32 trace_len, i;
 	int err;
 
-	err = stackid_init(stackid, map, trace, flags);
-	if (err)
+	err = stackid_fastpath(stackid, map, trace, flags);
+	if (err != -ENOENT)
 		return err;
 
-	hash_matches = stackid->bucket && stackid->bucket->hash == stackid->hash;
-	/* fast cmp */
-	if (hash_matches && flags & BPF_F_FAST_STACK_CMP)
-		return stackid->id;
-
 	if (stack_map_use_build_id(map)) {
 		struct bpf_stack_build_id *id_offs;
 
@@ -309,7 +328,7 @@ static long __bpf_get_stackid(struct sta
 			id_offs[i].ip = stackid->ips[i];
 		stack_map_get_build_id_offset(id_offs, stackid->nr, user, false /* !may_fault */);
 		trace_len = stackid->nr * sizeof(struct bpf_stack_build_id);
-		if (hash_matches && stackid->bucket->nr == stackid->nr &&
+		if (stackid->hash_matches && stackid->bucket->nr == stackid->nr &&
 		    memcmp(stackid->bucket->data, new_bucket->data, trace_len) == 0) {
 			pcpu_freelist_push(&smap->freelist, &new_bucket->fnode);
 			return stackid->id;
@@ -319,12 +338,6 @@ static long __bpf_get_stackid(struct sta
 			return -EEXIST;
 		}
 	} else {
-		if (hash_matches && stackid->bucket->nr == stackid->nr &&
-		    memcmp(stackid->bucket->data, stackid->ips, stackid->len) == 0)
-			return stackid->id;
-		if (stackid->bucket && !(flags & BPF_F_REUSE_STACKID))
-			return -EEXIST;
-
 		new_bucket = (struct stack_map_bucket *)
 			pcpu_freelist_pop(&smap->freelist);
 		if (unlikely(!new_bucket))


