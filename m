Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE96C58126;
	Tue, 23 Jan 2024 01:41:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974062; cv=none; b=Fr03k+cOj4i8GbKSGH54pRnj3FOZPBIM2Wk2PnogijkFgcNlT+aRXDKHG7G1puVVbhAGsltO2Rk6/6hFMS2WubUys4qX6N+wJkKP5I9AoZUqRK5tZwBczelwGg4vQufM8/1zRST7mztuoKziQjJzvDD+527eXvXVD/XMqJ1tQiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974062; c=relaxed/simple;
	bh=9xhHdMLITR2ISLinQmnIf0Sh1HyTHPuMccNLvxZpKvQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p0jQwsLaiZgNM4CVD0XPqOzEiyJLN5/uTdlOe3y81mIZasCw16b2wMgbPRnOsyQ99Xh/owZf2JoBq7+5ex/MqQoVqN7xVatZNo49xQCUVNb1Il0dnz6OmLZL/fNx6qWByC+FKJ87qAGJJ6EUKadw8E1jNRxwcf+rCSI2nc5UV5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VuE9OOTU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VuE9OOTU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55D33C43394;
	Tue, 23 Jan 2024 01:41:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974062;
	bh=9xhHdMLITR2ISLinQmnIf0Sh1HyTHPuMccNLvxZpKvQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VuE9OOTUcV/XcszV1/RHYiJq6AZOBHX0H9O36UEMeIo9osf/vDJqDQYEgZ2JOCTyM
	 DhhRKjH85BEpgJI6opJMYZ9JwbhnRFjCwhfYAaHwtPCfA2KFfN+ZOULWqHz63mNP/L
	 L3Yk0fqXqAGDOzF969RG6G0j90rvd+kQ7K41jqYk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jordan Rome <jordalgo@meta.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 119/374] bpf: Add crosstask check to __bpf_get_stack
Date: Mon, 22 Jan 2024 15:56:15 -0800
Message-ID: <20240122235748.772476061@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 9fb06a511250..1da082a8c4ec 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -4245,6 +4245,8 @@ union bpf_attr {
  * long bpf_get_task_stack(struct task_struct *task, void *buf, u32 size, u64 flags)
  *	Description
  *		Return a user or a kernel stack in bpf program provided buffer.
+ *		Note: the user stack will only be populated if the *task* is
+ *		the current task; all other tasks will return -EOPNOTSUPP.
  *		To achieve this, the helper needs *task*, which is a valid
  *		pointer to **struct task_struct**. To store the stacktrace, the
  *		bpf program provides *buf* with a nonnegative *size*.
@@ -4256,6 +4258,7 @@ union bpf_attr {
  *
  *		**BPF_F_USER_STACK**
  *			Collect a user space stack instead of a kernel stack.
+ *			The *task* must be the current task.
  *		**BPF_F_USER_BUILD_ID**
  *			Collect buildid+offset instead of ips for user stack,
  *			only valid if **BPF_F_USER_STACK** is also specified.
diff --git a/kernel/bpf/stackmap.c b/kernel/bpf/stackmap.c
index 7efae3af6201..f8587abef73c 100644
--- a/kernel/bpf/stackmap.c
+++ b/kernel/bpf/stackmap.c
@@ -435,6 +435,7 @@ static long __bpf_get_stack(struct pt_regs *regs, struct task_struct *task,
 {
 	u32 trace_nr, copy_len, elem_size, num_elem, max_depth;
 	bool user_build_id = flags & BPF_F_USER_BUILD_ID;
+	bool crosstask = task && task != current;
 	u32 skip = flags & BPF_F_SKIP_FIELD_MASK;
 	bool user = flags & BPF_F_USER_STACK;
 	struct perf_callchain_entry *trace;
@@ -457,6 +458,14 @@ static long __bpf_get_stack(struct pt_regs *regs, struct task_struct *task,
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
@@ -468,7 +477,7 @@ static long __bpf_get_stack(struct pt_regs *regs, struct task_struct *task,
 		trace = get_callchain_entry_for_task(task, max_depth);
 	else
 		trace = get_perf_callchain(regs, 0, kernel, user, max_depth,
-					   false, false);
+					   crosstask, false);
 	if (unlikely(!trace))
 		goto err_fault;
 
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 1e3e3f16eabc..d83eaa35c581 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -4245,6 +4245,8 @@ union bpf_attr {
  * long bpf_get_task_stack(struct task_struct *task, void *buf, u32 size, u64 flags)
  *	Description
  *		Return a user or a kernel stack in bpf program provided buffer.
+ *		Note: the user stack will only be populated if the *task* is
+ *		the current task; all other tasks will return -EOPNOTSUPP.
  *		To achieve this, the helper needs *task*, which is a valid
  *		pointer to **struct task_struct**. To store the stacktrace, the
  *		bpf program provides *buf* with a nonnegative *size*.
@@ -4256,6 +4258,7 @@ union bpf_attr {
  *
  *		**BPF_F_USER_STACK**
  *			Collect a user space stack instead of a kernel stack.
+ *			The *task* must be the current task.
  *		**BPF_F_USER_BUILD_ID**
  *			Collect buildid+offset instead of ips for user stack,
  *			only valid if **BPF_F_USER_STACK** is also specified.
-- 
2.43.0



