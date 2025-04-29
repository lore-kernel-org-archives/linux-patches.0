Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 205BE253351;
	Tue, 29 Apr 2025 18:15:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745950523; cv=none; b=FMnWeCuAo2yMJGvUoG9zlr+MCE/7WPjs2AqXSKfkq61m4TO4nzztVa0AzWexmdTovVoBDqn+k+nwienpxv75CqcBgvNV4EGiwhoRlzt3l3AY8aE/fjj7W4TNJQjPn7pXZ8C5c685x+YxB+arjxS7phe9GC4qgQWbS5K9v2+Qa6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745950523; c=relaxed/simple;
	bh=Utd9y3eTbyXSzcBvaU47tAch6VzNtBIf79d8kA7PvPI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NDslY/e77/PMnxODhdmx6QLK+I8PoNUqt7q5X+D/hu4AnzurBAsCcEPd/LYgj+6OsrZE4QYPHiT3+51c5irGj+3akJlvQRIOiQI6pQGQZkD+qKfGkksmk07PCemiE/uosCKViQz0oQzQ5W0yPBcg7Y3czx3BbQ+WOIQmPtmY50k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ruUPorJB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ruUPorJB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90537C4CEEA;
	Tue, 29 Apr 2025 18:15:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745950523;
	bh=Utd9y3eTbyXSzcBvaU47tAch6VzNtBIf79d8kA7PvPI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ruUPorJBYfkr6b+yFoIbPESUqREx9NlIbTa4zNVmRG0W3kJxuVkCkpGBpn1vyC9BF
	 u9L+PimFQOMrblAwQivwa8Vqpeo7TSp83Bafl6nnL+8iCEKeTZV9hwo+q2h9UXIDmj
	 gD7w3s8r48lSbzkjYVTp53uXRvbDPXMs5aLFdwUo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Starovoitov <ast@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 121/204] bpf: Fix deadlock between rcu_tasks_trace and event_mutex.
Date: Tue, 29 Apr 2025 18:43:29 +0200
Message-ID: <20250429161104.384098496@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161059.396852607@linuxfoundation.org>
References: <20250429161059.396852607@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 545393601be8c..97f660a8ddc73 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -400,7 +400,7 @@ static const struct bpf_func_proto bpf_trace_printk_proto = {
 	.arg2_type	= ARG_CONST_SIZE,
 };
 
-static void __set_printk_clr_event(void)
+static void __set_printk_clr_event(struct work_struct *work)
 {
 	/*
 	 * This program might be calling bpf_trace_printk,
@@ -413,10 +413,11 @@ static void __set_printk_clr_event(void)
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
 
@@ -459,7 +460,7 @@ static const struct bpf_func_proto bpf_trace_vprintk_proto = {
 
 const struct bpf_func_proto *bpf_get_trace_vprintk_proto(void)
 {
-	__set_printk_clr_event();
+	schedule_work(&set_printk_work);
 	return &bpf_trace_vprintk_proto;
 }
 
-- 
2.39.5



