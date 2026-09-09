Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 210252DEA7B;
	Wed,  9 Sep 2026 14:36:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964610; cv=none; b=Vp0I6W/0eJ1t4RH8Vw6ShxhXCP47CQimJU1CY3plwJTRsuXqpH3kZJaMKNeiLDaHza0hZd6BANW+Cmj7qw8Yiz8qGUQL0/PHVxmdRfrtAS5HNJlDcFssTXDitse80NtVyzDELi0dJT4f6LkLTHsl39h0m1nrZPHgGAuz5Os4CaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964610; c=relaxed/simple;
	bh=ri/2HoIi8Lx0ooq3sdEeHTHbUv+Nny7CeHImRqgT6Fc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YlSQUlrhfPyQyL+4lFxCo0xXfnvxfUEFYj5WF+aTUE6eKMOWLf8Qh0pMl7hNvis4QBKQnFp+CoVl3ioQOcphCCwz0nH4rIkO1Xp884vd8lOQxbwpYm1KYmRGDK5XY1wXzT8PZVeySX+tNra5hoeixgHVwioBTY0Hii1VHYi61+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EfY54o+K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EfY54o+K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 735A61F00A3A;
	Wed,  9 Sep 2026 14:36:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964609;
	bh=S6MWA/3kOZnvo4c9DXi3uWXcp4E1kRzG11klAzrKGkY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EfY54o+K1U0zhImZCT8a6krmqNUs3hVsc9i8n3Y8/bM978MM+jLpzYXR4hrKuYLvI
	 TS+KK94cY3NndnIjVnqn+11QpJLNnOupKYWiDv4CKtxaxdrOVZKFg/SRz2RlA6v2tu
	 Q11ePBYNfYM0l3DYUKsiRuXIjO2QWWgDxmDPFqpM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Olsa <jolsa@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 483/583] bpf: Factor stackid_fastpath function from __bpf_get_stackid
Date: Wed,  9 Sep 2026 15:42:48 +0200
Message-ID: <20260909134254.563517647@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


