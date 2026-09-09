Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDA0A2DEA7B;
	Wed,  9 Sep 2026 14:36:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964616; cv=none; b=VycATffrdtSY1pfi+IQ/qrj2EwcjAjkdCEyjKBWL40xIOy4q1IHESyCs8/9si1vYMJWxfYa0KA7jGoXBfva3XrVtku1ekihK3LgNsUuz2xYOuIwCr7GLZ2be5dE7PYIAh3MzkBjpQ/ICt1qtj444pJ3nLQj3PA6TQCXeDN9czbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964616; c=relaxed/simple;
	bh=zHG5TGSHR/G6SdlRBBSwSfZzDuOlSAqe9XVJ9AMNsu4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ccWKPqkVIwQSpKApbMHVWQ7Oben7Y94VTdCpfKCCFqHrMZFbNIE7DafB6a5aee1t71U0QG1iJQ3cH2PklEwWUZZtPXSHklq5Y0fmPlm7Jlj+ecdlqORCcQgpNiOa8uhNXzIoWN8l88ocFhdjzMRcsKav49kptfoISUI1n6xem+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QVCfF0FE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QVCfF0FE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 344541F00A3A;
	Wed,  9 Sep 2026 14:36:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964614;
	bh=dE8S2yCR9YnfuujmkE2tSuZwQOsH/F/WkjEnDwD8wl4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QVCfF0FEX/8tzBgosWM1iTqtmwdkxI8UVKf7SuluqD2iDXUZKukaCrzs/9AmgFLdk
	 dGxf3S0P5acCOaT1hAFxBrui7R5zpvXB2GVx0ibifBfZQpcW+36PBbkOqsRrNeGnKT
	 rCDpzDX2K+9ZF4oBJxPq7UW19rA4PvBnDJk3WsWE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Olsa <jolsa@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 485/583] bpf: Use stack id functions instead of __bpf_get_stackid
Date: Wed,  9 Sep 2026 15:42:50 +0200
Message-ID: <20260909134254.624819229@linuxfoundation.org>
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
@@ -326,22 +326,13 @@ stackid_new_bucket(struct stackid *stack
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
@@ -371,10 +362,12 @@ BPF_CALL_3(bpf_get_stackid, struct pt_re
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
@@ -388,7 +381,15 @@ BPF_CALL_3(bpf_get_stackid, struct pt_re
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
@@ -416,6 +417,7 @@ BPF_CALL_3(bpf_get_stackid_pe, struct bp
 	   struct bpf_map *, map, u64, flags)
 {
 	struct perf_event *event = ctx->event;
+	struct stack_map_bucket *new_bucket;
 	struct perf_callchain_entry *trace;
 	struct stackid stackid;
 	bool kernel, user;
@@ -443,7 +445,6 @@ BPF_CALL_3(bpf_get_stackid_pe, struct bp
 
 	if (kernel) {
 		trace->nr = nr_kernel;
-		ret = __bpf_get_stackid(&stackid, map, trace, flags);
 	} else { /* user */
 		u64 skip = flags & BPF_F_SKIP_FIELD_MASK;
 
@@ -452,12 +453,22 @@ BPF_CALL_3(bpf_get_stackid_pe, struct bp
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
 


