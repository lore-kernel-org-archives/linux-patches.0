Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621091;
	b=Vk0BvyXv7Yde0nnvqsnnKUiVo83vsX0mhqYs8UIKBkNN6vECyhPvpFCAOaBGMpWSp3Wi
	 R6n4Cb+j6BhRy14d/fFVA88DpGZfA+keYUBca6OmAj1Y+637ktHuhFS7d2UX2aAKrDlLw
	 oUVhhgTj0LV0qLVjJDry5NGwNxyHk671+TxZnrdHD5PObf88FAbzDAwP2Y9QX3U8FEaMi
	 aUS7uh1bmjGfswkl6UjF6EDaaRY7ETYqMqqS0Ln+vIKWG2YyvczX2lCnZyUJ4wB5+cyZY
	 F27Sozabs/g1KlE1+MgcP+q9zderNiKs8wFKxSH2UmmZa/GfAMV6uOlO3qrHr+sUu8g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621091;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=L9eVqkXJnmEdthNdGn5shrgv3vD8WuFFnAzIkrld9Rw=;
	b=YoG2aTOGOIUH/8WKObG+f4SpWW6Q6bo8uYyhFvIfL10k0CNtu0Yabr2bSQu4rLLY5fg0
	 Hn7MfYB/cSWq2DQr0LQcJUeh41A0IiJe7TEJaeYWdD5Pow24YSpIUf57O9tgsu/7zZURH
	 lFj/E56G8AxSdrUqktqOZ2e08h9tQ4GPEePBHnLKrqIVJaqEjIwK9XfCs/3JdN8dEmVka
	 33hKY/Z3TqcQmAjAzD7r40fXZYoVduCkFhRhy4mkPaeR0OU/rgLapLu+MZbZNqLpua1t2
	 mGaCC/ycVez9adqoSFn8+4jiNWYkiOS149++UEiral5Vg1o75AQ2dpeVELUrUpPfXmQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XfAMb+ZV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16FE7606A326;
	Wed, 25 Nov 2026 15:38:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XfAMb+ZV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EFC61F000C6;
	Wed, 25 Nov 2026 15:38:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621090;
	bh=L9eVqkXJnmEdthNdGn5shrgv3vD8WuFFnAzIkrld9Rw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XfAMb+ZVKH+N7j4W4xmk0RTO8ZFNP/Yal3R7l+qAojqjw00WFRV72/soZbaf+r4ED
	 xGoRFyQCF6elb2DsMmllBOSxbfnkNqsTgzYNJfw//0BeTbzEzhrm+kTKofGpNH0nuY
	 ysOnkjozOM5JJ2QtlqVgURqHI/mQo08bBdxg2+rs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Olsa <jolsa@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 111/990] bpf: Avoid changing callchain in bpf_get_stackid_pe
Date: Wed, 25 Nov 2026 15:24:38 +0100
Message-ID: <20261125143824.688525720@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index f56333c9a8053..128c8d61070e4 100644
--- a/kernel/bpf/stackmap.c
+++ b/kernel/bpf/stackmap.c
@@ -386,7 +386,7 @@ get_callchain_entry_for_task(struct task_struct *task, u32 max_depth)
 
 struct stackid {
 	struct stack_map_bucket *bucket;
-	u64 *ips;
+	const u64 *ips;
 	u32  nr;
 	u32  len;
 	u32  hash;
@@ -395,21 +395,21 @@ struct stackid {
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
@@ -417,11 +417,12 @@ static int stackid_init(struct stackid *stackid, struct bpf_map *map,
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
 
@@ -520,7 +521,7 @@ BPF_CALL_3(bpf_get_stackid, struct pt_regs *, regs, struct bpf_map *, map,
 			/* couldn't fetch the stack trace */
 			return -EFAULT;
 
-		err = stackid_fastpath(&stackid, map, trace, flags);
+		err = stackid_fastpath(&stackid, map, trace, trace->nr, flags);
 		if (err != -ENOENT)
 			return err;
 
@@ -556,12 +557,13 @@ static __u64 count_kernel_ip(const struct perf_callchain_entry *trace)
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
@@ -581,13 +583,13 @@ BPF_CALL_3(bpf_get_stackid_pe, struct bpf_perf_event_data_kern *, ctx,
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
@@ -595,21 +597,14 @@ BPF_CALL_3(bpf_get_stackid_pe, struct bpf_perf_event_data_kern *, ctx,
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



