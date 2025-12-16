Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9692034D3BE;
	Tue, 16 Dec 2025 11:42:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885364; cv=none; b=mFoAqAIsxsu/hTUtyPplfdadP6fFFGSpWNmm8R4tiq4GdOKs0FieCD/RGwvwHUE/5uxB++rEkI5cayhohipHhkV6f65V2x+3eYM0iIXJrwzV6DayF9q7l69pmU82I/tOM2/2St3lH65TnI+/3Xl9XCDWgC22V7T0EOeBg3rxNl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885364; c=relaxed/simple;
	bh=o2ylr4ONH/WC/Qv7169mIHMzn0m5emZytD0Bvvh+ons=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=in//tXuCKCTZ0XW6LReEVmd01z4Z1kvOhEfhU5SpDrc/IDEKhVtTcpcNZiFhiHqIEll9GImbVQidjTACtulDJnzOQIQGkrlAAA0R+FESu6Di9M830aN9xqSsGE3RwIVwRyH1rVlDUGDqGjp0z+dx9yK1SSgkl0CupuR/wyix34c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e3qIZSt1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e3qIZSt1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 094E4C4CEF1;
	Tue, 16 Dec 2025 11:42:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885364;
	bh=o2ylr4ONH/WC/Qv7169mIHMzn0m5emZytD0Bvvh+ons=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e3qIZSt1LdCFStHPujBxo4ovcslyuKJVBs9+yJxqAdJg3/dbToUtWB1Ewu2RcmW3s
	 +VbRUvvR64Bs+jjFTC52+Y2qSpfbznPls3N6h80Zy4LO0/HBX5f5SR4kBXLycC8NH5
	 MtEC+bfEtmDMbIuzjJr1ZCicIrqSs6X/OGWwVg1s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnaud Lecomte <contact@arnaud-lcm.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	Song Liu <song@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 117/507] bpf: Refactor stack map trace depth calculation into helper function
Date: Tue, 16 Dec 2025 12:09:18 +0100
Message-ID: <20251216111349.773306030@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaud Lecomte <contact@arnaud-lcm.com>

[ Upstream commit e17d62fedd10ae56e2426858bd0757da544dbc73 ]

Extract the duplicated maximum allowed depth computation for stack
traces stored in BPF stacks from bpf_get_stackid() and __bpf_get_stack()
into a dedicated stack_map_calculate_max_depth() helper function.

This unifies the logic for:
- The max depth computation
- Enforcing the sysctl_perf_event_max_stack limit

No functional changes for existing code paths.

Signed-off-by: Arnaud Lecomte <contact@arnaud-lcm.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Yonghong Song <yonghong.song@linux.dev>
Acked-by: Song Liu <song@kernel.org>
Link: https://lore.kernel.org/bpf/20251025192858.31424-1-contact@arnaud-lcm.com
Stable-dep-of: 23f852daa4ba ("bpf: Fix stackmap overflow check in __bpf_get_stackid()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/stackmap.c | 47 +++++++++++++++++++++++++++++--------------
 1 file changed, 32 insertions(+), 15 deletions(-)

diff --git a/kernel/bpf/stackmap.c b/kernel/bpf/stackmap.c
index ec3a57a5fba1f..d6027bac61c35 100644
--- a/kernel/bpf/stackmap.c
+++ b/kernel/bpf/stackmap.c
@@ -42,6 +42,28 @@ static inline int stack_map_data_size(struct bpf_map *map)
 		sizeof(struct bpf_stack_build_id) : sizeof(u64);
 }
 
+/**
+ * stack_map_calculate_max_depth - Calculate maximum allowed stack trace depth
+ * @size:  Size of the buffer/map value in bytes
+ * @elem_size:  Size of each stack trace element
+ * @flags:  BPF stack trace flags (BPF_F_USER_STACK, BPF_F_USER_BUILD_ID, ...)
+ *
+ * Return: Maximum number of stack trace entries that can be safely stored
+ */
+static u32 stack_map_calculate_max_depth(u32 size, u32 elem_size, u64 flags)
+{
+	u32 skip = flags & BPF_F_SKIP_FIELD_MASK;
+	u32 max_depth;
+	u32 curr_sysctl_max_stack = READ_ONCE(sysctl_perf_event_max_stack);
+
+	max_depth = size / elem_size;
+	max_depth += skip;
+	if (max_depth > curr_sysctl_max_stack)
+		return curr_sysctl_max_stack;
+
+	return max_depth;
+}
+
 static int prealloc_elems_and_freelist(struct bpf_stack_map *smap)
 {
 	u64 elem_size = sizeof(struct stack_map_bucket) +
@@ -300,20 +322,17 @@ static long __bpf_get_stackid(struct bpf_map *map,
 BPF_CALL_3(bpf_get_stackid, struct pt_regs *, regs, struct bpf_map *, map,
 	   u64, flags)
 {
-	u32 max_depth = map->value_size / stack_map_data_size(map);
-	u32 skip = flags & BPF_F_SKIP_FIELD_MASK;
+	u32 elem_size = stack_map_data_size(map);
 	bool user = flags & BPF_F_USER_STACK;
 	struct perf_callchain_entry *trace;
 	bool kernel = !user;
+	u32 max_depth;
 
 	if (unlikely(flags & ~(BPF_F_SKIP_FIELD_MASK | BPF_F_USER_STACK |
 			       BPF_F_FAST_STACK_CMP | BPF_F_REUSE_STACKID)))
 		return -EINVAL;
 
-	max_depth += skip;
-	if (max_depth > sysctl_perf_event_max_stack)
-		max_depth = sysctl_perf_event_max_stack;
-
+	max_depth = stack_map_calculate_max_depth(map->value_size, elem_size, flags);
 	trace = get_perf_callchain(regs, kernel, user, max_depth,
 				   false, false);
 
@@ -406,7 +425,7 @@ static long __bpf_get_stack(struct pt_regs *regs, struct task_struct *task,
 			    struct perf_callchain_entry *trace_in,
 			    void *buf, u32 size, u64 flags, bool may_fault)
 {
-	u32 trace_nr, copy_len, elem_size, num_elem, max_depth;
+	u32 trace_nr, copy_len, elem_size, max_depth;
 	bool user_build_id = flags & BPF_F_USER_BUILD_ID;
 	bool crosstask = task && task != current;
 	u32 skip = flags & BPF_F_SKIP_FIELD_MASK;
@@ -438,21 +457,20 @@ static long __bpf_get_stack(struct pt_regs *regs, struct task_struct *task,
 		goto clear;
 	}
 
-	num_elem = size / elem_size;
-	max_depth = num_elem + skip;
-	if (sysctl_perf_event_max_stack < max_depth)
-		max_depth = sysctl_perf_event_max_stack;
+	max_depth = stack_map_calculate_max_depth(size, elem_size, flags);
 
 	if (may_fault)
 		rcu_read_lock(); /* need RCU for perf's callchain below */
 
-	if (trace_in)
+	if (trace_in) {
 		trace = trace_in;
-	else if (kernel && task)
+		trace->nr = min_t(u32, trace->nr, max_depth);
+	} else if (kernel && task) {
 		trace = get_callchain_entry_for_task(task, max_depth);
-	else
+	} else {
 		trace = get_perf_callchain(regs, kernel, user, max_depth,
 					   crosstask, false);
+	}
 
 	if (unlikely(!trace) || trace->nr < skip) {
 		if (may_fault)
@@ -461,7 +479,6 @@ static long __bpf_get_stack(struct pt_regs *regs, struct task_struct *task,
 	}
 
 	trace_nr = trace->nr - skip;
-	trace_nr = (trace_nr <= num_elem) ? trace_nr : num_elem;
 	copy_len = trace_nr * elem_size;
 
 	ips = trace->ip + skip;
-- 
2.51.0



