Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3EA81F55F7;
	Tue, 21 Jan 2025 18:01:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482499; cv=none; b=MtF5jKMWhXrQr0D+yo8oVDK4LIhC1hopDIjqXn2JJbaCIJbDNYT+q4jXSfTHPlcp2xs1m8Dc7hRczPknmXBKUlatabm1ZNsnl17IUXiyGN35OERQiJRD702sqAZzWbmgV1ouqEyhyQ7Y+MZD0WcdSY3LoSE1r5qLZBt+WXqoJfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482499; c=relaxed/simple;
	bh=yc10w2QZBHD1UOZ6mUyjsVv1GCJrBWM4DNjS+XkPmVc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hHzC+/Q+ZokhnrAvAtoQSPoo9SMIUfWyT3qIutVBkX51CJza5TV3Jz/Kjq0jSrKavRfrcfGmXFcyt1AQ3vCIMqp6AjEbOdRNRBGY7RjtvuY+a9Y0PZEUcP3WDZ7JOaimNMDex/v7Rgh1Q4SBJERPYgJ1TmjDIHJ3RLxn11CO6hc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UfAo5Y+G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UfAo5Y+G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60511C4CEDF;
	Tue, 21 Jan 2025 18:01:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482498;
	bh=yc10w2QZBHD1UOZ6mUyjsVv1GCJrBWM4DNjS+XkPmVc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UfAo5Y+G4lZW1Giyw/97QGuG4c673l9qmHeP/Z8MXH8POD+dbnfQ39xrx5geworU+
	 ivVuu7qNMyY2fNWLd9kWX/Bzikoe7bPpGhv7WIg+nves90o6IL1BZ+zepucZzcyM6A
	 aDPPg9TtW5qOMIw54y+SPwSEL0uf+gFzVa3vSHHs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Vernet <void@manifault.com>,
	Andrea Righi <arighi@nvidia.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 068/122] scx: Fix maximal BPF selftest prog
Date: Tue, 21 Jan 2025 18:51:56 +0100
Message-ID: <20250121174535.616787055@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174532.991109301@linuxfoundation.org>
References: <20250121174532.991109301@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: David Vernet <void@manifault.com>

[ Upstream commit b8f614207b0d5e4abd6df8d5cb3cc11f009d1d93 ]

maximal.bpf.c is still dispatching to and consuming from SCX_DSQ_GLOBAL.
Let's have it use its own DSQ to avoid any runtime errors.

Signed-off-by: David Vernet <void@manifault.com>
Tested-by: Andrea Righi <arighi@nvidia.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/sched_ext/maximal.bpf.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/sched_ext/maximal.bpf.c b/tools/testing/selftests/sched_ext/maximal.bpf.c
index 4c005fa718103..430f5e13bf554 100644
--- a/tools/testing/selftests/sched_ext/maximal.bpf.c
+++ b/tools/testing/selftests/sched_ext/maximal.bpf.c
@@ -12,6 +12,8 @@
 
 char _license[] SEC("license") = "GPL";
 
+#define DSQ_ID 0
+
 s32 BPF_STRUCT_OPS(maximal_select_cpu, struct task_struct *p, s32 prev_cpu,
 		   u64 wake_flags)
 {
@@ -20,7 +22,7 @@ s32 BPF_STRUCT_OPS(maximal_select_cpu, struct task_struct *p, s32 prev_cpu,
 
 void BPF_STRUCT_OPS(maximal_enqueue, struct task_struct *p, u64 enq_flags)
 {
-	scx_bpf_dsq_insert(p, SCX_DSQ_GLOBAL, SCX_SLICE_DFL, enq_flags);
+	scx_bpf_dsq_insert(p, DSQ_ID, SCX_SLICE_DFL, enq_flags);
 }
 
 void BPF_STRUCT_OPS(maximal_dequeue, struct task_struct *p, u64 deq_flags)
@@ -28,7 +30,7 @@ void BPF_STRUCT_OPS(maximal_dequeue, struct task_struct *p, u64 deq_flags)
 
 void BPF_STRUCT_OPS(maximal_dispatch, s32 cpu, struct task_struct *prev)
 {
-	scx_bpf_dsq_move_to_local(SCX_DSQ_GLOBAL);
+	scx_bpf_dsq_move_to_local(DSQ_ID);
 }
 
 void BPF_STRUCT_OPS(maximal_runnable, struct task_struct *p, u64 enq_flags)
@@ -123,7 +125,7 @@ void BPF_STRUCT_OPS(maximal_cgroup_set_weight, struct cgroup *cgrp, u32 weight)
 
 s32 BPF_STRUCT_OPS_SLEEPABLE(maximal_init)
 {
-	return 0;
+	return scx_bpf_create_dsq(DSQ_ID, -1);
 }
 
 void BPF_STRUCT_OPS(maximal_exit, struct scx_exit_info *info)
-- 
2.39.5



