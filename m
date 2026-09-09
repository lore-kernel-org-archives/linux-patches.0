Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C30956B87E;
	Wed,  9 Sep 2026 14:12:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963176; cv=none; b=jfbDuS0Y/malAbboPv/kWzphBIz1Dt4rZgkkAB7kJ2rkzvVWynBIW44GySnr+MkgAyMXwCPH7KpEja4vcZSQ67+AxnzaCxf1rM6rkeAXy9HVMzywqJBxhi3sj3I/o8vnjF+RNQo2qd/ieOZ/2HFFBy47MJB4qt6UHYfjcWkr71Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963176; c=relaxed/simple;
	bh=ZOvK4/EGE1UVxB+CPVFzgq8qCsaErrYGYMfIpjegU4I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h4R4FrZvXZ3x8IG6i798xTAXLt45rm2d6PL/rx1RsVV+iIU1FUbJgVo6y55GrjPhpNSU0MfNK4GsyfS09b5gOpF3Yooy9BHK1Kz4etzX7bLksbX2IhkhLmFM5E3pm0bS0svbf7XyJF4hC/mL0kuOxTKrpjgpAYqLmzPc5eE8MXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uYMp6JsY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uYMp6JsY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FEB31F00A3E;
	Wed,  9 Sep 2026 14:12:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963175;
	bh=zJZ2nrs9t8yc4KNHVdhenK2anFK5panU9EZH0ryw5gw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uYMp6JsYuJ0xPlYF7WtL/FF0WeEr0ISH4J26mMlyTfqM5wwP8fLiRDVPZxaEslUp5
	 g15tkRvfv0Tp99lP7LtVT30XDNZlzG/gGMM3zTysFOSuHYW7PsID5H6AV+gKSR63cf
	 w95Me+BYZrAAf1WCjGe2AVkUBZ2vGdnS5m7Jei68=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Olsa <jolsa@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 545/556] bpf: Use stack id functions instead of __bpf_get_stackid
Date: Wed,  9 Sep 2026 15:43:45 +0200
Message-ID: <20260909134249.564066170@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Olsa <jolsa@kernel.org>

[ Upstream commit 09b3fd6caa0b57f8a39254ee5db3af30bdd53c18 ]

Replacing __bpf_get_stackid calls with sequence of following functions:

  stackid_fastpath
  stackid_new_bucket
  stackid_install

This makes code more structured and allows us to easily disable
preemption only in bpf_get_stackid in following changes.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20260803210149.296496-5-jolsa@kernel.org
Stable-dep-of: 15f1bd857466 ("bpf: Disable preemption in bpf_get_stackid")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/stackmap.c |   43 +++++++++++++++++++++++++++----------------
 1 file changed, 27 insertions(+), 16 deletions(-)

--- a/kernel/bpf/stackmap.c
+++ b/kernel/bpf/stackmap.c
@@ -584,22 +584,13 @@ stackid_new_bucket(struct stackid *stack
 	return bucket;
 }
 
-static long __bpf_get_stackid(struct stackid *stackid, struct bpf_map *map,
-			      struct perf_callchain_entry *trace, u64 flags)
+static long stackid_install(struct stackid *stackid, struct bpf_map *map,
+			    struct stack_map_bucket *new_bucket, u64 flags)
 {
 	struct bpf_stack_map *smap = container_of(map, struct bpf_stack_map, map);
-	struct stack_map_bucket *new_bucket, *old_bucket;
 	bool user = flags & BPF_F_USER_STACK;
+	struct stack_map_bucket *old_bucket;
 	u32 trace_len;
-	int err;
-
-	err = stackid_fastpath(stackid, map, trace, flags);
-	if (err != -ENOENT)
-		return err;
-
-	new_bucket = stackid_new_bucket(stackid, map);
-	if (!new_bucket)
-		return -ENOMEM;
 
 	if (stack_map_use_build_id(map)) {
 		struct bpf_stack_build_id *id_offs;
@@ -629,10 +620,12 @@ BPF_CALL_3(bpf_get_stackid, struct pt_re
 {
 	u32 elem_size = stack_map_data_size(map);
 	bool user = flags & BPF_F_USER_STACK;
+	struct stack_map_bucket *new_bucket;
 	struct perf_callchain_entry *trace;
 	struct stackid stackid;
 	bool kernel = !user;
 	u32 max_depth;
+	int err;
 
 	if (unlikely(flags & ~(BPF_F_SKIP_FIELD_MASK | BPF_F_USER_STACK |
 			       BPF_F_FAST_STACK_CMP | BPF_F_REUSE_STACKID)))
@@ -646,7 +639,15 @@ BPF_CALL_3(bpf_get_stackid, struct pt_re
 		/* couldn't fetch the stack trace */
 		return -EFAULT;
 
-	return __bpf_get_stackid(&stackid, map, trace, flags);
+	err = stackid_fastpath(&stackid, map, trace, flags);
+	if (err != -ENOENT)
+		return err;
+
+	new_bucket = stackid_new_bucket(&stackid, map);
+	if (!new_bucket)
+		return -ENOMEM;
+
+	return stackid_install(&stackid, map, new_bucket, flags);
 }
 
 const struct bpf_func_proto bpf_get_stackid_proto = {
@@ -674,6 +675,7 @@ BPF_CALL_3(bpf_get_stackid_pe, struct bp
 	   struct bpf_map *, map, u64, flags)
 {
 	struct perf_event *event = ctx->event;
+	struct stack_map_bucket *new_bucket;
 	struct perf_callchain_entry *trace;
 	struct stackid stackid;
 	bool kernel, user;
@@ -701,7 +703,6 @@ BPF_CALL_3(bpf_get_stackid_pe, struct bp
 
 	if (kernel) {
 		trace->nr = nr_kernel;
-		ret = __bpf_get_stackid(&stackid, map, trace, flags);
 	} else { /* user */
 		u64 skip = flags & BPF_F_SKIP_FIELD_MASK;
 
@@ -710,12 +711,22 @@ BPF_CALL_3(bpf_get_stackid_pe, struct bp
 			return -EFAULT;
 
 		flags = (flags & ~BPF_F_SKIP_FIELD_MASK) | skip;
-		ret = __bpf_get_stackid(&stackid, map, trace, flags);
 	}
 
+	ret = stackid_fastpath(&stackid, map, trace, flags);
+	if (ret != -ENOENT)
+		goto out;
+
+	new_bucket = stackid_new_bucket(&stackid, map);
+	if (new_bucket) {
+		trace->nr = nr;
+		return stackid_install(&stackid, map, new_bucket, flags);
+	}
+	ret = -ENOMEM;
+
+out:
 	/* restore nr */
 	trace->nr = nr;
-
 	return ret;
 }
 


