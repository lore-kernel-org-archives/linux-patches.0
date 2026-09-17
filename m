Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3424154706C;
	Thu, 17 Sep 2026 19:02:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671724; cv=none; b=JoZcLJkEe4DQoxRXxxh91n+X/KfE2Lj9JayGcowIJQ9jXNJZcyGEcVha940V3LpT1bYdyDao+I9u0eHRYWzjaUlwBf/fMW2zIYYSoBA/fliXFQYU8l2uPS2lesMlLjkaV6v9TzLxei0DKu1Ui6EVgyM8bHGRj26jVBVLZguOyxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671724; c=relaxed/simple;
	bh=JmGSIqk2xruZ72Ms2kUEv4KUAP3YntV4ymvFUN6rQmU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gMjV+HamnzIPmBSf4u41P4EGFCQ8866PQwunsFQZT6ft9SDPNpmOKnmynGM6t3TLGI9tebABCWgt1sJcD5EA0TDi5Ewkjvx0C1NouNobas18nMemhtmSQvpOfUKkijVyfdZZ6sMyNSXMb89C0Wa1KQoQp9U7mqNHLdZ/DVG0Sms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XOZa1Mgg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XOZa1Mgg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 759961F000FF;
	Thu, 17 Sep 2026 19:02:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671722;
	bh=HbZpJyzSX4kBQJLADdZxGyvIsKj+BJp0jFeVgVL8Z10=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XOZa1Mgg+YurUOCVx3GhZrtQyQ+dy8yC//NojjAopVHdL9+5++WlWyN0oZkGVEjcZ
	 r9/cIQv2YfYlmFORSB5L0CwDPMyie/KdfFswmdSoeD5J6BpxnLgYp/4ujBi9cmOiHd
	 6aHkXUJXsMtaGgrT+z/vxBZbBle1eBjiqWK2O8CY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Olsa <jolsa@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1069/1102] bpf: Factor stackid_new_bucket from __bpf_get_stackid
Date: Thu, 17 Sep 2026 16:16:52 +0100
Message-ID: <20260917151607.661823138@linuxfoundation.org>
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

[ Upstream commit bb4e6f4e1b68fe60c04ca04c564c6624e837dbf4 ]

The new stackid_new_bucket allocates the new bucket and initializes it
with the trace data.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20260803210149.296496-4-jolsa@kernel.org
Stable-dep-of: 15f1bd857466 ("bpf: Disable preemption in bpf_get_stackid")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/stackmap.c |   48 ++++++++++++++++++++++++++++++------------------
 1 file changed, 30 insertions(+), 18 deletions(-)

--- a/kernel/bpf/stackmap.c
+++ b/kernel/bpf/stackmap.c
@@ -301,31 +301,52 @@ static int stackid_fastpath(struct stack
 	return -ENOENT;
 }
 
+static struct stack_map_bucket *
+stackid_new_bucket(struct stackid *stackid, struct bpf_map *map)
+{
+	struct bpf_stack_map *smap = container_of(map, struct bpf_stack_map, map);
+	struct bpf_stack_build_id *id_offs;
+	struct stack_map_bucket *bucket;
+	u32 i;
+
+	bucket = (struct stack_map_bucket *) pcpu_freelist_pop(&smap->freelist);
+	if (unlikely(!bucket))
+		return NULL;
+
+	if (stack_map_use_build_id(map)) {
+		id_offs = (struct bpf_stack_build_id *)bucket->data;
+		for (i = 0; i < stackid->nr; i++)
+			id_offs[i].ip = stackid->ips[i];
+	} else {
+		memcpy(bucket->data, stackid->ips, stackid->len);
+	}
+
+	bucket->hash = stackid->hash;
+	bucket->nr = stackid->nr;
+	return bucket;
+}
+
 static long __bpf_get_stackid(struct stackid *stackid, struct bpf_map *map,
 			      struct perf_callchain_entry *trace, u64 flags)
 {
 	struct bpf_stack_map *smap = container_of(map, struct bpf_stack_map, map);
 	struct stack_map_bucket *new_bucket, *old_bucket;
 	bool user = flags & BPF_F_USER_STACK;
-	u32 trace_len, i;
+	u32 trace_len;
 	int err;
 
 	err = stackid_fastpath(stackid, map, trace, flags);
 	if (err != -ENOENT)
 		return err;
 
+	new_bucket = stackid_new_bucket(stackid, map);
+	if (!new_bucket)
+		return -ENOMEM;
+
 	if (stack_map_use_build_id(map)) {
 		struct bpf_stack_build_id *id_offs;
 
-		/* for build_id+offset, pop a bucket before slow cmp */
-		new_bucket = (struct stack_map_bucket *)
-			pcpu_freelist_pop(&smap->freelist);
-		if (unlikely(!new_bucket))
-			return -ENOMEM;
-		new_bucket->nr = stackid->nr;
 		id_offs = (struct bpf_stack_build_id *)new_bucket->data;
-		for (i = 0; i < stackid->nr; i++)
-			id_offs[i].ip = stackid->ips[i];
 		stack_map_get_build_id_offset(id_offs, stackid->nr, user, false /* !may_fault */);
 		trace_len = stackid->nr * sizeof(struct bpf_stack_build_id);
 		if (stackid->hash_matches && stackid->bucket->nr == stackid->nr &&
@@ -337,17 +358,8 @@ static long __bpf_get_stackid(struct sta
 			pcpu_freelist_push(&smap->freelist, &new_bucket->fnode);
 			return -EEXIST;
 		}
-	} else {
-		new_bucket = (struct stack_map_bucket *)
-			pcpu_freelist_pop(&smap->freelist);
-		if (unlikely(!new_bucket))
-			return -ENOMEM;
-		memcpy(new_bucket->data, stackid->ips, stackid->len);
 	}
 
-	new_bucket->hash = stackid->hash;
-	new_bucket->nr = stackid->nr;
-
 	old_bucket = xchg(&smap->buckets[stackid->id], new_bucket);
 	if (old_bucket)
 		pcpu_freelist_push(&smap->freelist, &old_bucket->fnode);


