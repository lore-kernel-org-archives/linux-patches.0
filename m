Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624123;
	b=Tc4bgBK3o6yRQZWSv4u/dvvthZpZ3EXT8pXlFkXD36iM04INgsoYQ7Ye1F3JPMaVvnzv
	 WEB+syAhaaiPgdH5uOjrDLXrsZie8vv3AAIZUpMaUJ2hJ5sEXUEt2PZPE55Qij3HtMeYZ
	 LYTtrx59QlKE3DnPapzwnOr5kcH5xmJDdCIkX+DUkYsl6RxIz2OuytB5Qj26zCd6X/8+V
	 mLAf1tTItBFfuJEhfWgW9qE+h0m2qdNPQEYmoDeg+ofob0Cp+iiIATfSG2bKH+kY3QWOV
	 fL35LOi+kXduZ0YoqhpyyPOcf47abS7bHd53YE4cRHmtNkLXr7iYeloc64gVzPdRWtw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624123;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/k1PQClvERW+s95AohSFXsWxn1EOaLZfdFRUljcoIhc=;
	b=vBKyBwKwprDluVfC25wc3T+vKsvTVrfj2vkeEFlUmHM++0PPAsLz3NeEvnP1QytffnQy
	 ff5AUGgcjt5IJuuFllwQOKkM8Fw+vCA2F91pt7+Dc7udbgS4Fxcj9+4Wv7qUIW9T/j57s
	 kRSOt9gohK6F76p2XNXTGeDGsakvgHKD2wDEovBRC1hoXzwXBZvECmihTVE5QLAOhEBdN
	 Xq+Nw5HnR9pEfQpm5wy/2649+r0RMudiWdZghB6a7/U1LvdiD8LwNktO7AKS6CLrp8VD6
	 Tz4ljWKDcfgtrLwHXITHEqGSMFcQT/UgHsDmT5CG33DvlyKHToja+pk9XU0yDp5WMAg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XvJIGwvj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA249606A33C;
	Wed, 25 Nov 2026 16:28:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XvJIGwvj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E23BB1F000ED;
	Wed, 25 Nov 2026 16:28:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624123;
	bh=/k1PQClvERW+s95AohSFXsWxn1EOaLZfdFRUljcoIhc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XvJIGwvjIYvmwVEw866FMelT62zLQyfmzo55aoWYLbwu+gII3CmEJENLzPKn2ZJsh
	 sxD9qFHjZ6w5LjudZukDtRSlXk/d/op193KwwjpWNt+X9ksJOLl9oVH9VaorqGd/8D
	 3rY9ZO7incT1+QlBpb+zt0JBmBC65lh20ogNBVnk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Olsa <jolsa@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 094/816] bpf: Avoid changing callchain in bpf_get_stackid_pe
Date: Wed, 25 Nov 2026 15:27:22 +0100
Message-ID: <20261125143851.397572649@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Olsa <jolsa@kernel.org>

[ Upstream commit a74594607a0b310c1533e713b9097cc1cbbb85bf ]

There's no need to modify the trace object bpf_get_stackid_pe, we just
need to pass the needed callchain length in separate argument.

This way we can have callchain pointers const and remove the trace->nr
modification and restoration.

Assisted-by: Codex:GPT-5.5

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20260803210149.296496-13-jolsa@kernel.org
Stable-dep-of: a08ba2ab79df ("bpf: Clamp the trace length before the skip test in stackid_init()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/stackmap.c | 39 +++++++++++++++++----------------------
 1 file changed, 17 insertions(+), 22 deletions(-)

diff --git a/kernel/bpf/stackmap.c b/kernel/bpf/stackmap.c
index d38d8e49a789d..43e27cd278c4a 100644
--- a/kernel/bpf/stackmap.c
+++ b/kernel/bpf/stackmap.c
@@ -253,7 +253,7 @@ get_callchain_entry_for_task(struct task_struct *task, u32 max_depth)
 
 struct stackid {
 	struct stack_map_bucket *bucket;
-	u64 *ips;
+	const u64 *ips;
 	u32  nr;
 	u32  len;
 	u32  hash;
@@ -262,21 +262,21 @@ struct stackid {
 };
 
 static int stackid_init(struct stackid *stackid, struct bpf_map *map,
-			struct perf_callchain_entry *trace, u64 flags)
+			const struct perf_callchain_entry *trace, u32 trace_nr, u64 flags)
 {
 	struct bpf_stack_map *smap = container_of(map, struct bpf_stack_map, map);
 	u32 skip = flags & BPF_F_SKIP_FIELD_MASK;
 	u32 max_depth;
 
-	if (trace->nr <= skip)
+	if (trace_nr <= skip)
 		/* skipping more than usable stack trace */
 		return -EFAULT;
 
 	max_depth = stack_map_calculate_max_depth(map->value_size, stack_map_data_size(map), flags);
-	stackid->nr = min_t(u32, trace->nr - skip, max_depth - skip);
+	stackid->nr = min_t(u32, trace_nr - skip, max_depth - skip);
 	stackid->len = stackid->nr * sizeof(u64);
 	stackid->ips = trace->ip + skip;
-	stackid->hash = jhash2((u32 *)stackid->ips, stackid->len / sizeof(u32), 0);
+	stackid->hash = jhash2((const u32 *)stackid->ips, stackid->len / sizeof(u32), 0);
 	stackid->id = stackid->hash & (smap->n_buckets - 1);
 	stackid->bucket = READ_ONCE(smap->buckets[stackid->id]);
 	stackid->hash_matches = stackid->bucket && stackid->bucket->hash == stackid->hash;
@@ -284,11 +284,12 @@ static int stackid_init(struct stackid *stackid, struct bpf_map *map,
 }
 
 static int stackid_fastpath(struct stackid *stackid, struct bpf_map *map,
-			    struct perf_callchain_entry *trace, u64 flags)
+			    const struct perf_callchain_entry *trace, u32 trace_nr,
+			    u64 flags)
 {
 	int err;
 
-	err = stackid_init(stackid, map, trace, flags);
+	err = stackid_init(stackid, map, trace, trace_nr, flags);
 	if (err)
 		return err;
 
@@ -387,7 +388,7 @@ BPF_CALL_3(bpf_get_stackid, struct pt_regs *, regs, struct bpf_map *, map,
 			/* couldn't fetch the stack trace */
 			return -EFAULT;
 
-		err = stackid_fastpath(&stackid, map, trace, flags);
+		err = stackid_fastpath(&stackid, map, trace, trace->nr, flags);
 		if (err != -ENOENT)
 			return err;
 
@@ -423,12 +424,13 @@ static __u64 count_kernel_ip(const struct perf_callchain_entry *trace)
 BPF_CALL_3(bpf_get_stackid_pe, struct bpf_perf_event_data_kern *, ctx,
 	   struct bpf_map *, map, u64, flags)
 {
+	const struct perf_callchain_entry *trace;
 	struct perf_event *event = ctx->event;
 	struct stack_map_bucket *new_bucket;
-	struct perf_callchain_entry *trace;
 	struct stackid stackid;
 	bool kernel, user;
 	__u64 nr_kernel;
+	u32 trace_nr;
 	int ret;
 
 	/* perf_sample_data doesn't have callchain, use bpf_get_stackid */
@@ -448,13 +450,13 @@ BPF_CALL_3(bpf_get_stackid_pe, struct bpf_perf_event_data_kern *, ctx,
 		return -EFAULT;
 
 	nr_kernel = count_kernel_ip(trace);
-	__u64 nr = trace->nr; /* save original */
 
 	if (kernel) {
-		trace->nr = nr_kernel;
+		trace_nr = nr_kernel;
 	} else { /* user */
 		u64 skip = flags & BPF_F_SKIP_FIELD_MASK;
 
+		trace_nr = trace->nr;
 		skip += nr_kernel;
 		if (skip > BPF_F_SKIP_FIELD_MASK)
 			return -EFAULT;
@@ -462,21 +464,14 @@ BPF_CALL_3(bpf_get_stackid_pe, struct bpf_perf_event_data_kern *, ctx,
 		flags = (flags & ~BPF_F_SKIP_FIELD_MASK) | skip;
 	}
 
-	ret = stackid_fastpath(&stackid, map, trace, flags);
+	ret = stackid_fastpath(&stackid, map, trace, trace_nr, flags);
 	if (ret != -ENOENT)
-		goto out;
+		return ret;
 
 	new_bucket = stackid_new_bucket(&stackid, map);
-	if (new_bucket) {
-		trace->nr = nr;
+	if (new_bucket)
 		return stackid_install(&stackid, map, new_bucket, flags);
-	}
-	ret = -ENOMEM;
-
-out:
-	/* restore nr */
-	trace->nr = nr;
-	return ret;
+	return -ENOMEM;
 }
 
 const struct bpf_func_proto bpf_get_stackid_proto_pe = {
-- 
2.53.0



