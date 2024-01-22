Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D8E45EE70;
	Tue, 23 Jan 2024 01:46:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974409; cv=none; b=OzWRkZnSz8oUxveK9PHkKc9X4gmXuEZWexD6GnRx4NaD+G2na87InH/zckNAVK2EZX0G+W6viniTrAFhkaJEKRmaf/VlkPkL21Y7FRbkHIJZeafop+c6qtuBslHEJJw0rhuMbI2XDnXE49lf1l8vFwPVC0jZ1oExqjGQrc3nNKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974409; c=relaxed/simple;
	bh=Ka3vHaz08tJn5V0wk7ccSmKNf/3pZEkVCsSjYa8B3a0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LgG744DVwu6Sh604Ub5Gjxw7ADr/FXSVi5oLbcpZo2uXPvn2hI1HNiAhrtF2Niso0FTIVQ4cb7l8rQeQE+4UUeIZzpgqgOjiaE90S8eprtMMo/rF4NKAZ3w6NCF6M5wGfF94vxV7NFAjsCXYWqJT0VfMZNU7LREKWlnAvJwQ70I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VXX40tVw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VXX40tVw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 534EDC433F1;
	Tue, 23 Jan 2024 01:46:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974409;
	bh=Ka3vHaz08tJn5V0wk7ccSmKNf/3pZEkVCsSjYa8B3a0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VXX40tVwP1+ULjLN7rzyqrXXxBMrLQXIh0ZuqUQiUsQJhtdUT0NGId9kAsfqJ2YHT
	 sPF1XS2pLSx6y8EXoSQYlLyaMZpdX7lGx4Brtzek/y+bVGH1Ev1qXumC0knhFVpGg9
	 U6c1RjjB+NwbdLZot0w5tALtwfUQgV8448KmavAI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jordan Rome <jordalgo@meta.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 089/583] bpf: Add crosstask check to __bpf_get_stack
Date: Mon, 22 Jan 2024 15:52:20 -0800
Message-ID: <20240122235814.895130776@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jordan Rome <jordalgo@meta.com>

[ Upstream commit b8e3a87a627b575896e448021e5c2f8a3bc19931 ]

Currently get_perf_callchain only supports user stack walking for
the current task. Passing the correct *crosstask* param will return
0 frames if the task passed to __bpf_get_stack isn't the current
one instead of a single incorrect frame/address. This change
passes the correct *crosstask* param but also does a preemptive
check in __bpf_get_stack if the task is current and returns
-EOPNOTSUPP if it is not.

This issue was found using bpf_get_task_stack inside a BPF
iterator ("iter/task"), which iterates over all tasks.
bpf_get_task_stack works fine for fetching kernel stacks
but because get_perf_callchain relies on the caller to know
if the requested *task* is the current one (via *crosstask*)
it was failing in a confusing way.

It might be possible to get user stacks for all tasks utilizing
something like access_process_vm but that requires the bpf
program calling bpf_get_task_stack to be sleepable and would
therefore be a breaking change.

Fixes: fa28dcb82a38 ("bpf: Introduce helper bpf_get_task_stack()")
Signed-off-by: Jordan Rome <jordalgo@meta.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20231108112334.3433136-1-jordalgo@meta.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/bpf.h       |  3 +++
 kernel/bpf/stackmap.c          | 11 ++++++++++-
 tools/include/uapi/linux/bpf.h |  3 +++
 3 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 0448700890f7..ada7acb91a1b 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -4490,6 +4490,8 @@ union bpf_attr {
  * long bpf_get_task_stack(struct task_struct *task, void *buf, u32 size, u64 flags)
  *	Description
  *		Return a user or a kernel stack in bpf program provided buffer.
+ *		Note: the user stack will only be populated if the *task* is
+ *		the current task; all other tasks will return -EOPNOTSUPP.
  *		To achieve this, the helper needs *task*, which is a valid
  *		pointer to **struct task_struct**. To store the stacktrace, the
  *		bpf program provides *buf* with a nonnegative *size*.
@@ -4501,6 +4503,7 @@ union bpf_attr {
  *
  *		**BPF_F_USER_STACK**
  *			Collect a user space stack instead of a kernel stack.
+ *			The *task* must be the current task.
  *		**BPF_F_USER_BUILD_ID**
  *			Collect buildid+offset instead of ips for user stack,
  *			only valid if **BPF_F_USER_STACK** is also specified.
diff --git a/kernel/bpf/stackmap.c b/kernel/bpf/stackmap.c
index 458bb80b14d5..36775c4bc33f 100644
--- a/kernel/bpf/stackmap.c
+++ b/kernel/bpf/stackmap.c
@@ -388,6 +388,7 @@ static long __bpf_get_stack(struct pt_regs *regs, struct task_struct *task,
 {
 	u32 trace_nr, copy_len, elem_size, num_elem, max_depth;
 	bool user_build_id = flags & BPF_F_USER_BUILD_ID;
+	bool crosstask = task && task != current;
 	u32 skip = flags & BPF_F_SKIP_FIELD_MASK;
 	bool user = flags & BPF_F_USER_STACK;
 	struct perf_callchain_entry *trace;
@@ -410,6 +411,14 @@ static long __bpf_get_stack(struct pt_regs *regs, struct task_struct *task,
 	if (task && user && !user_mode(regs))
 		goto err_fault;
 
+	/* get_perf_callchain does not support crosstask user stack walking
+	 * but returns an empty stack instead of NULL.
+	 */
+	if (crosstask && user) {
+		err = -EOPNOTSUPP;
+		goto clear;
+	}
+
 	num_elem = size / elem_size;
 	max_depth = num_elem + skip;
 	if (sysctl_perf_event_max_stack < max_depth)
@@ -421,7 +430,7 @@ static long __bpf_get_stack(struct pt_regs *regs, struct task_struct *task,
 		trace = get_callchain_entry_for_task(task, max_depth);
 	else
 		trace = get_perf_callchain(regs, 0, kernel, user, max_depth,
-					   false, false);
+					   crosstask, false);
 	if (unlikely(!trace))
 		goto err_fault;
 
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 0448700890f7..ada7acb91a1b 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -4490,6 +4490,8 @@ union bpf_attr {
  * long bpf_get_task_stack(struct task_struct *task, void *buf, u32 size, u64 flags)
  *	Description
  *		Return a user or a kernel stack in bpf program provided buffer.
+ *		Note: the user stack will only be populated if the *task* is
+ *		the current task; all other tasks will return -EOPNOTSUPP.
  *		To achieve this, the helper needs *task*, which is a valid
  *		pointer to **struct task_struct**. To store the stacktrace, the
  *		bpf program provides *buf* with a nonnegative *size*.
@@ -4501,6 +4503,7 @@ union bpf_attr {
  *
  *		**BPF_F_USER_STACK**
  *			Collect a user space stack instead of a kernel stack.
+ *			The *task* must be the current task.
  *		**BPF_F_USER_BUILD_ID**
  *			Collect buildid+offset instead of ips for user stack,
  *			only valid if **BPF_F_USER_STACK** is also specified.
-- 
2.43.0



