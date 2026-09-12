Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 724553A1690;
	Sat, 12 Sep 2026 08:33:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789202032; cv=none; b=pLarrJ/PV7ckrOOl7bu+r5uv5i7Rh3ArCf5yV/erGi2BiagoozgDOGRch+puNRQFfZm0RpkDpv6waiLo+xAhFVopSpEi3kWb5u7qXUuMtRGL4IbowFwY9oT38UKAetD4IiI+vDTk6yR3/ZfFtYq0hGb2WQ7E/uiuBGr5YgQsM3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789202032; c=relaxed/simple;
	bh=7vRCSe5x/hXdAB0cJvPapB8S1AtwmE6iaUc4doSS6sY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YL7iICY93B7ag/+tMSKmlpTgfjTOdpa+Z3vw2cwMOqZypfgZ+5RXFiT71+AeusOwZf6VW30UefW9t8VOZNtkR1g5obT9TOppomHDwjBDiIg/0GCCu9ZjjgK1IO64rCl6HZE20VIL8fwOmbJiIKKWkwng46sPWQ0HK0swxd/BICY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vFefy0cd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vFefy0cd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC38A1F000FF;
	Sat, 12 Sep 2026 08:33:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789202031;
	bh=Y3G/LqRCJI1fNWzNpz3pt8jUU/Wp4mLU+9qQVRh0zj4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vFefy0cdhh3jTvrBJH1AW2HhwqXLgGyE58LA/6IV7zcE3KhtKVvrBeSmuX6NoZdje
	 X24vw4T6oqNykBcJc5bybut2JkxwUkVy/2VvpOyRKr1z6wvK1glCEemNCU899e4EzY
	 m9piiczqTdQng9mqISXw6wICt8kq8d/CH/dY391A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Olsa <jolsa@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1119/1815] bpf: Remove trace_in argument from __bpf_get_stack
Date: Sat, 12 Sep 2026 08:47:49 +0200
Message-ID: <20260912065715.288458135@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

[ Upstream commit 58cfc2201d964163fe9c4a703136eb64db799f08 ]

Now with the new callchain_* helper functions we can process trace_in
case directly in bpf_get_stack_pe function and remove it from
__bpf_get_stack which makes things easier for preemption fix in
following change.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20260803210149.296496-9-jolsa@kernel.org
Stable-dep-of: f5d242825ca4 ("bpf: Clear buf on error in __bpf_get_task_stack")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/stackmap.c | 49 ++++++++++++++++++++++++++++++-------------
 1 file changed, 35 insertions(+), 14 deletions(-)

diff --git a/kernel/bpf/stackmap.c b/kernel/bpf/stackmap.c
index 5611ad5ff98df..ebeea95f45f2e 100644
--- a/kernel/bpf/stackmap.c
+++ b/kernel/bpf/stackmap.c
@@ -780,7 +780,6 @@ static long callchain_finalize(void *buf, u32 size, u32 trace_nr, u32 elem_size,
 }
 
 static long __bpf_get_stack(struct pt_regs *regs, struct task_struct *task,
-			    struct perf_callchain_entry *trace_in,
 			    void *buf, u32 size, u64 flags, bool may_fault)
 {
 	bool user_build_id = flags & BPF_F_USER_BUILD_ID;
@@ -820,10 +819,7 @@ static long __bpf_get_stack(struct pt_regs *regs, struct task_struct *task,
 	if (may_fault)
 		rcu_read_lock(); /* need RCU for perf's callchain below */
 
-	if (trace_in) {
-		trace = trace_in;
-		trace->nr = min_t(u32, trace->nr, max_depth);
-	} else if (kernel && task) {
+	if (kernel && task) {
 		trace = get_callchain_entry_for_task(task, max_depth);
 	} else {
 		trace = get_perf_callchain(regs, kernel, user, max_depth,
@@ -856,7 +852,7 @@ static long __bpf_get_stack(struct pt_regs *regs, struct task_struct *task,
 BPF_CALL_4(bpf_get_stack, struct pt_regs *, regs, void *, buf, u32, size,
 	   u64, flags)
 {
-	return __bpf_get_stack(regs, NULL, NULL, buf, size, flags, false /* !may_fault */);
+	return __bpf_get_stack(regs, NULL, buf, size, flags, false /* !may_fault */);
 }
 
 const struct bpf_func_proto bpf_get_stack_proto = {
@@ -872,7 +868,7 @@ const struct bpf_func_proto bpf_get_stack_proto = {
 BPF_CALL_4(bpf_get_stack_sleepable, struct pt_regs *, regs, void *, buf, u32, size,
 	   u64, flags)
 {
-	return __bpf_get_stack(regs, NULL, NULL, buf, size, flags, true /* may_fault */);
+	return __bpf_get_stack(regs, NULL, buf, size, flags, true /* may_fault */);
 }
 
 const struct bpf_func_proto bpf_get_stack_sleepable_proto = {
@@ -896,7 +892,7 @@ static long __bpf_get_task_stack(struct task_struct *task, void *buf, u32 size,
 
 	regs = task_pt_regs(task);
 	if (regs)
-		res = __bpf_get_stack(regs, task, NULL, buf, size, flags, may_fault);
+		res = __bpf_get_stack(regs, task, buf, size, flags, may_fault);
 	put_task_stack(task);
 
 	return res;
@@ -936,6 +932,32 @@ const struct bpf_func_proto bpf_get_task_stack_sleepable_proto = {
 	.arg4_type	= ARG_ANYTHING,
 };
 
+static int __bpf_get_stack_pe(struct perf_callchain_entry *trace, void *buf, u32 size,
+			      u64 flags)
+{
+	bool user_build_id = flags & BPF_F_USER_BUILD_ID;
+	u64 skip = flags & BPF_F_SKIP_FIELD_MASK;
+	bool user = flags & BPF_F_USER_STACK;
+	u32 elem_size, max_depth, nr_trace;
+	bool kernel = !user;
+
+	if (kernel && user_build_id)
+		return -EINVAL;
+
+	elem_size = user_build_id ? sizeof(struct bpf_stack_build_id) : sizeof(u64);
+	if (unlikely(size % elem_size))
+		return -EINVAL;
+
+	max_depth = stack_map_calculate_max_depth(size, elem_size, flags);
+	trace->nr = min_t(u32, trace->nr, max_depth);
+
+	if (trace->nr < skip)
+		return -EFAULT;
+
+	nr_trace = callchain_store(trace, buf, elem_size, flags);
+	return callchain_finalize(buf, size, nr_trace, elem_size, flags, false /* !may_fault */);
+}
+
 BPF_CALL_4(bpf_get_stack_pe, struct bpf_perf_event_data_kern *, ctx,
 	   void *, buf, u32, size, u64, flags)
 {
@@ -947,7 +969,7 @@ BPF_CALL_4(bpf_get_stack_pe, struct bpf_perf_event_data_kern *, ctx,
 	__u64 nr_kernel;
 
 	if (!(event->attr.sample_type & PERF_SAMPLE_CALLCHAIN))
-		return __bpf_get_stack(regs, NULL, NULL, buf, size, flags, false /* !may_fault */);
+		return __bpf_get_stack(regs, NULL, buf, size, flags, false /* !may_fault */);
 
 	if (unlikely(flags & ~(BPF_F_SKIP_FIELD_MASK | BPF_F_USER_STACK |
 			       BPF_F_USER_BUILD_ID)))
@@ -967,7 +989,7 @@ BPF_CALL_4(bpf_get_stack_pe, struct bpf_perf_event_data_kern *, ctx,
 		__u64 nr = trace->nr;
 
 		trace->nr = nr_kernel;
-		err = __bpf_get_stack(regs, NULL, trace, buf, size, flags, false /* !may_fault */);
+		err = __bpf_get_stack_pe(trace, buf, size, flags);
 
 		/* restore nr */
 		trace->nr = nr;
@@ -977,14 +999,13 @@ BPF_CALL_4(bpf_get_stack_pe, struct bpf_perf_event_data_kern *, ctx,
 		skip += nr_kernel;
 		if (skip > BPF_F_SKIP_FIELD_MASK)
 			goto clear;
-
 		flags = (flags & ~BPF_F_SKIP_FIELD_MASK) | skip;
-		err = __bpf_get_stack(regs, NULL, trace, buf, size, flags, false /* !may_fault */);
+		err = __bpf_get_stack_pe(trace, buf, size, flags);
 	}
-	return err;
 
 clear:
-	memset(buf, 0, size);
+	if (err < 0)
+		memset(buf, 0, size);
 	return err;
 
 }
-- 
2.53.0



