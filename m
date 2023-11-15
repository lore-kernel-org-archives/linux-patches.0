Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 613093C472
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:39:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CrsG9Jz3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14EAFC433CD;
	Wed, 15 Nov 2023 19:39:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077155;
	bh=K7k8mqqWr57kKNKnsvXHmuLOokPuVllAsnEdTQr7ifQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CrsG9Jz3nEh9OQsLUZLMps9lFQVHkUVg47a5k9JgEJjr1we9A7J3JL2bdTrf8iVQd
	 gCdRnwB64CM5S0+LnuYsYJMWRgAMnVORgZ4gLQyj7ctLX9va+Sn5v8b7vKj13E//JO
	 TNVA4rSfSCCxrg9Y027OhMu0/AVjeWX0p+0vHS78=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yafang Shao <laoar.shao@gmail.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Stanislav Fomichev <sdf@google.com>,
	Feng Zhou <zhoufeng.zf@bytedance.com>,
	KP Singh <kpsingh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 125/603] bpf: Fix missed rcu read lock in bpf_task_under_cgroup()
Date: Wed, 15 Nov 2023 14:11:10 -0500
Message-ID: <20231115191621.888871255@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
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

From: Yafang Shao <laoar.shao@gmail.com>

[ Upstream commit 29a7e00ffadddd8d68eff311de1bf12ae10687bb ]

When employed within a sleepable program not under RCU protection, the
use of 'bpf_task_under_cgroup()' may trigger a warning in the kernel log,
particularly when CONFIG_PROVE_RCU is enabled:

  [ 1259.662357] WARNING: suspicious RCU usage
  [ 1259.662358] 6.5.0+ #33 Not tainted
  [ 1259.662360] -----------------------------
  [ 1259.662361] include/linux/cgroup.h:423 suspicious rcu_dereference_check() usage!

Other info that might help to debug this:

  [ 1259.662366] rcu_scheduler_active = 2, debug_locks = 1
  [ 1259.662368] 1 lock held by trace/72954:
  [ 1259.662369]  #0: ffffffffb5e3eda0 (rcu_read_lock_trace){....}-{0:0}, at: __bpf_prog_enter_sleepable+0x0/0xb0

Stack backtrace:

  [ 1259.662385] CPU: 50 PID: 72954 Comm: trace Kdump: loaded Not tainted 6.5.0+ #33
  [ 1259.662391] Call Trace:
  [ 1259.662393]  <TASK>
  [ 1259.662395]  dump_stack_lvl+0x6e/0x90
  [ 1259.662401]  dump_stack+0x10/0x20
  [ 1259.662404]  lockdep_rcu_suspicious+0x163/0x1b0
  [ 1259.662412]  task_css_set.part.0+0x23/0x30
  [ 1259.662417]  bpf_task_under_cgroup+0xe7/0xf0
  [ 1259.662422]  bpf_prog_7fffba481a3bcf88_lsm_run+0x5c/0x93
  [ 1259.662431]  bpf_trampoline_6442505574+0x60/0x1000
  [ 1259.662439]  bpf_lsm_bpf+0x5/0x20
  [ 1259.662443]  ? security_bpf+0x32/0x50
  [ 1259.662452]  __sys_bpf+0xe6/0xdd0
  [ 1259.662463]  __x64_sys_bpf+0x1a/0x30
  [ 1259.662467]  do_syscall_64+0x38/0x90
  [ 1259.662472]  entry_SYSCALL_64_after_hwframe+0x6e/0xd8
  [ 1259.662479] RIP: 0033:0x7f487baf8e29
  [...]
  [ 1259.662504]  </TASK>

This issue can be reproduced by executing a straightforward program, as
demonstrated below:

SEC("lsm.s/bpf")
int BPF_PROG(lsm_run, int cmd, union bpf_attr *attr, unsigned int size)
{
        struct cgroup *cgrp = NULL;
        struct task_struct *task;
        int ret = 0;

        if (cmd != BPF_LINK_CREATE)
                return 0;

        // The cgroup2 should be mounted first
        cgrp = bpf_cgroup_from_id(1);
        if (!cgrp)
                goto out;
        task = bpf_get_current_task_btf();
        if (bpf_task_under_cgroup(task, cgrp))
                ret = -1;
        bpf_cgroup_release(cgrp);

out:
        return ret;
}

After running the program, if you subsequently execute another BPF program,
you will encounter the warning.

It's worth noting that task_under_cgroup_hierarchy() is also utilized by
bpf_current_task_under_cgroup(). However, bpf_current_task_under_cgroup()
doesn't exhibit this issue because it cannot be used in sleepable BPF
programs.

Fixes: b5ad4cdc46c7 ("bpf: Add bpf_task_under_cgroup() kfunc")
Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Stanislav Fomichev <sdf@google.com>
Cc: Feng Zhou <zhoufeng.zf@bytedance.com>
Cc: KP Singh <kpsingh@kernel.org>
Link: https://lore.kernel.org/bpf/20231007135945.4306-1-laoar.shao@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/helpers.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index 8bd3812fb8df4..68f54e16c7be0 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -2197,7 +2197,12 @@ __bpf_kfunc struct cgroup *bpf_cgroup_from_id(u64 cgid)
 __bpf_kfunc long bpf_task_under_cgroup(struct task_struct *task,
 				       struct cgroup *ancestor)
 {
-	return task_under_cgroup_hierarchy(task, ancestor);
+	long ret;
+
+	rcu_read_lock();
+	ret = task_under_cgroup_hierarchy(task, ancestor);
+	rcu_read_unlock();
+	return ret;
 }
 #endif /* CONFIG_CGROUPS */
 
-- 
2.42.0



