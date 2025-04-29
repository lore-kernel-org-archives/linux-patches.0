Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0562C233713;
	Tue, 29 Apr 2025 17:33:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947981; cv=none; b=r5D4TINwa7/UTnbvcyTCvBrOs5mBOGZfFj9AdLxWvK8huNc8u1F+gckNb0Z69f0YLlB5s4SaSXZX/U2gaPGm6eIeSgJVF36Ek2GYLrfO/9eylydAontywVuEKjm9b8u0yNP1iHmdJF+HbM07F4LD8+0u7MvCAkJXF/1n85iwsEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947981; c=relaxed/simple;
	bh=NLDF6N5p3Gw7xC6nyHFSfV+71wbxB7sSbBCvOC6N5Gc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D83jn5E8LvtXNDzyh58BEivfW3757qD0raNgEGmjF5A+Bit1s0pV+0hWk3bIf2IkGNGLSh4LJaocwW8WflMKQP4mhvfB41C4O1/FCeFeOM9K/5fVnmCZDDxulqSZkpZGTkEWJMEM+Uoosx82BD2zcZhgyDtTEvl+Qw3Sj7xoxUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gmkt7G9J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gmkt7G9J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B93EC4CEE3;
	Tue, 29 Apr 2025 17:33:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947980;
	bh=NLDF6N5p3Gw7xC6nyHFSfV+71wbxB7sSbBCvOC6N5Gc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gmkt7G9JNj33jbZQh2q7Mvk4LhnNHn/fl2rI/6IttjpOVIRdrdX1qDIKRvMafuel3
	 X74ZnrvdHbqa6xeikyVDTxcg0jcU1GsC7HaMeVOOhiOyvdwLDT3hEZfY4iaLsKEvwE
	 mdcaBkjMqOEmduLE6hky3gbM0yoIeKk+NC67hIMU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Starovoitov <ast@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 160/280] bpf: Fix deadlock between rcu_tasks_trace and event_mutex.
Date: Tue, 29 Apr 2025 18:41:41 +0200
Message-ID: <20250429161121.664735750@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
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

From: Alexei Starovoitov <ast@kernel.org>

[ Upstream commit 4580f4e0ebdf8dc8d506ae926b88510395a0c1d1 ]

Fix the following deadlock:
CPU A
_free_event()
  perf_kprobe_destroy()
    mutex_lock(&event_mutex)
      perf_trace_event_unreg()
        synchronize_rcu_tasks_trace()

There are several paths where _free_event() grabs event_mutex
and calls sync_rcu_tasks_trace. Above is one such case.

CPU B
bpf_prog_test_run_syscall()
  rcu_read_lock_trace()
    bpf_prog_run_pin_on_cpu()
      bpf_prog_load()
        bpf_tracing_func_proto()
          trace_set_clr_event()
            mutex_lock(&event_mutex)

Delegate trace_set_clr_event() to workqueue to avoid
such lock dependency.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20250224221637.4780-1-alexei.starovoitov@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/bpf_trace.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 55f279ddfd63d..e5c063fc8ef97 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -403,7 +403,7 @@ static const struct bpf_func_proto bpf_trace_printk_proto = {
 	.arg2_type	= ARG_CONST_SIZE,
 };
 
-static void __set_printk_clr_event(void)
+static void __set_printk_clr_event(struct work_struct *work)
 {
 	/*
 	 * This program might be calling bpf_trace_printk,
@@ -416,10 +416,11 @@ static void __set_printk_clr_event(void)
 	if (trace_set_clr_event("bpf_trace", "bpf_trace_printk", 1))
 		pr_warn_ratelimited("could not enable bpf_trace_printk events");
 }
+static DECLARE_WORK(set_printk_work, __set_printk_clr_event);
 
 const struct bpf_func_proto *bpf_get_trace_printk_proto(void)
 {
-	__set_printk_clr_event();
+	schedule_work(&set_printk_work);
 	return &bpf_trace_printk_proto;
 }
 
@@ -462,7 +463,7 @@ static const struct bpf_func_proto bpf_trace_vprintk_proto = {
 
 const struct bpf_func_proto *bpf_get_trace_vprintk_proto(void)
 {
-	__set_printk_clr_event();
+	schedule_work(&set_printk_work);
 	return &bpf_trace_vprintk_proto;
 }
 
-- 
2.39.5



