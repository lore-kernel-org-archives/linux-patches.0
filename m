Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43C6F2E041C;
	Tue,  8 Jul 2025 16:51:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993493; cv=none; b=FJ2g7ZIsJxYuL6tScypb93hA8EHegDrFZVcSDz4uAdgnQi53QsQ2HfORkcDF+/T9WD7eGuvb4Gw5ZSrv65bocqL9Sx474aaw0WF3Rv0CtFsSslULW/4/i/iUEAuBmNlJdSCgOk2wfJihNeYWCi6g9hNOayNbpHX2l+PwDjL15aE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993493; c=relaxed/simple;
	bh=D/QD7bWbhOo3Lo/OL3u+Nw2uOHch4PSivTTV2Q81ASo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cXvK9oEfoYL5GpFYnsP6Q87/VcyVjuUg2pGQ7zxnSeIAuMxkwytfmUdScU7m2XBZmjgjLIJAk2hd/oesIP3+yd6eXFG12eqCsDCPgjPRvqzuojzFQwaueSJvJ6t5pbolPYajas0gc/KPdeyCtUmy06HIEytklSAvd3/0FThdMQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=syUMAC+z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="syUMAC+z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70172C4CEED;
	Tue,  8 Jul 2025 16:51:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993492;
	bh=D/QD7bWbhOo3Lo/OL3u+Nw2uOHch4PSivTTV2Q81ASo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=syUMAC+z/Hy55sx+X+MnPoAO/a0ZA5/g/CeR3vpGPIBC/wW2XsA3R8gJOZ3O6EzQc
	 WkLfHs+JvzeWAKvzcAMxeIXB4Fl+tTR0tGIZOtnBhjCXy3DtBS8lGjdmWWyfJyxyIV
	 YwCWjswqsVOwdlWXvFsqst99WpfSP72xZ7tbI3EE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <tanggeliang@kylinos.cn>,
	Keith Busch <kbusch@kernel.org>,
	Hannes Reinecke <hare@suse.de>,
	Nilay Shroff <nilay@linux.ibm.com>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 092/178] nvme-multipath: fix suspicious RCU usage warning
Date: Tue,  8 Jul 2025 18:22:09 +0200
Message-ID: <20250708162239.063337679@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162236.549307806@linuxfoundation.org>
References: <20250708162236.549307806@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geliang Tang <tanggeliang@kylinos.cn>

[ Upstream commit d6811074203b13f715ce2480ac64c5b1c773f2a5 ]

When I run the NVME over TCP test in virtme-ng, I get the following
"suspicious RCU usage" warning in nvme_mpath_add_sysfs_link():

'''
[    5.024557][   T44] nvmet: Created nvm controller 1 for subsystem nqn.2025-06.org.nvmexpress.mptcp for NQN nqn.2014-08.org.nvmexpress:uuid:f7f6b5e0-ff97-4894-98ac-c85309e0bc77.
[    5.027401][  T183] nvme nvme0: creating 2 I/O queues.
[    5.029017][  T183] nvme nvme0: mapped 2/0/0 default/read/poll queues.
[    5.032587][  T183] nvme nvme0: new ctrl: NQN "nqn.2025-06.org.nvmexpress.mptcp", addr 127.0.0.1:4420, hostnqn: nqn.2014-08.org.nvmexpress:uuid:f7f6b5e0-ff97-4894-98ac-c85309e0bc77
[    5.042214][   T25]
[    5.042440][   T25] =============================
[    5.042579][   T25] WARNING: suspicious RCU usage
[    5.042705][   T25] 6.16.0-rc3+ #23 Not tainted
[    5.042812][   T25] -----------------------------
[    5.042934][   T25] drivers/nvme/host/multipath.c:1203 RCU-list traversed in non-reader section!!
[    5.043111][   T25]
[    5.043111][   T25] other info that might help us debug this:
[    5.043111][   T25]
[    5.043341][   T25]
[    5.043341][   T25] rcu_scheduler_active = 2, debug_locks = 1
[    5.043502][   T25] 3 locks held by kworker/u9:0/25:
[    5.043615][   T25]  #0: ffff888008730948 ((wq_completion)async){+.+.}-{0:0}, at: process_one_work+0x7ed/0x1350
[    5.043830][   T25]  #1: ffffc900001afd40 ((work_completion)(&entry->work)){+.+.}-{0:0}, at: process_one_work+0xcf3/0x1350
[    5.044084][   T25]  #2: ffff888013ee0020 (&head->srcu){.+.+}-{0:0}, at: nvme_mpath_add_sysfs_link.part.0+0xb4/0x3a0
[    5.044300][   T25]
[    5.044300][   T25] stack backtrace:
[    5.044439][   T25] CPU: 0 UID: 0 PID: 25 Comm: kworker/u9:0 Not tainted 6.16.0-rc3+ #23 PREEMPT(full)
[    5.044441][   T25] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    5.044442][   T25] Workqueue: async async_run_entry_fn
[    5.044445][   T25] Call Trace:
[    5.044446][   T25]  <TASK>
[    5.044449][   T25]  dump_stack_lvl+0x6f/0xb0
[    5.044453][   T25]  lockdep_rcu_suspicious.cold+0x4f/0xb1
[    5.044457][   T25]  nvme_mpath_add_sysfs_link.part.0+0x2fb/0x3a0
[    5.044459][   T25]  ? queue_work_on+0x90/0xf0
[    5.044461][   T25]  ? lockdep_hardirqs_on+0x78/0x110
[    5.044466][   T25]  nvme_mpath_set_live+0x1e9/0x4f0
[    5.044470][   T25]  nvme_mpath_add_disk+0x240/0x2f0
[    5.044472][   T25]  ? __pfx_nvme_mpath_add_disk+0x10/0x10
[    5.044475][   T25]  ? add_disk_fwnode+0x361/0x580
[    5.044480][   T25]  nvme_alloc_ns+0x81c/0x17c0
[    5.044483][   T25]  ? kasan_quarantine_put+0x104/0x240
[    5.044487][   T25]  ? __pfx_nvme_alloc_ns+0x10/0x10
[    5.044495][   T25]  ? __pfx_nvme_find_get_ns+0x10/0x10
[    5.044496][   T25]  ? rcu_read_lock_any_held+0x45/0xa0
[    5.044498][   T25]  ? validate_chain+0x232/0x4f0
[    5.044503][   T25]  nvme_scan_ns+0x4c8/0x810
[    5.044506][   T25]  ? __pfx_nvme_scan_ns+0x10/0x10
[    5.044508][   T25]  ? find_held_lock+0x2b/0x80
[    5.044512][   T25]  ? ktime_get+0x16d/0x220
[    5.044517][   T25]  ? kvm_clock_get_cycles+0x18/0x30
[    5.044520][   T25]  ? __pfx_nvme_scan_ns_async+0x10/0x10
[    5.044522][   T25]  async_run_entry_fn+0x97/0x560
[    5.044523][   T25]  ? rcu_is_watching+0x12/0xc0
[    5.044526][   T25]  process_one_work+0xd3c/0x1350
[    5.044532][   T25]  ? __pfx_process_one_work+0x10/0x10
[    5.044536][   T25]  ? assign_work+0x16c/0x240
[    5.044539][   T25]  worker_thread+0x4da/0xd50
[    5.044545][   T25]  ? __pfx_worker_thread+0x10/0x10
[    5.044546][   T25]  kthread+0x356/0x5c0
[    5.044548][   T25]  ? __pfx_kthread+0x10/0x10
[    5.044549][   T25]  ? ret_from_fork+0x1b/0x2e0
[    5.044552][   T25]  ? __lock_release.isra.0+0x5d/0x180
[    5.044553][   T25]  ? ret_from_fork+0x1b/0x2e0
[    5.044555][   T25]  ? rcu_is_watching+0x12/0xc0
[    5.044557][   T25]  ? __pfx_kthread+0x10/0x10
[    5.044559][   T25]  ret_from_fork+0x218/0x2e0
[    5.044561][   T25]  ? __pfx_kthread+0x10/0x10
[    5.044562][   T25]  ret_from_fork_asm+0x1a/0x30
[    5.044570][   T25]  </TASK>
'''

This patch uses sleepable RCU version of helper list_for_each_entry_srcu()
instead of list_for_each_entry_rcu() to fix it.

Fixes: 4dbd2b2ebe4c ("nvme-multipath: Add visibility for round-robin io-policy")
Signed-off-by: Geliang Tang <tanggeliang@kylinos.cn>
Reviewed-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Nilay Shroff <nilay@linux.ibm.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/multipath.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
index cf0ef4745564c..700dfbd5a4512 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -1050,7 +1050,8 @@ void nvme_mpath_add_sysfs_link(struct nvme_ns_head *head)
 	 */
 	srcu_idx = srcu_read_lock(&head->srcu);
 
-	list_for_each_entry_rcu(ns, &head->list, siblings) {
+	list_for_each_entry_srcu(ns, &head->list, siblings,
+				 srcu_read_lock_held(&head->srcu)) {
 		/*
 		 * Ensure that ns path disk node is already added otherwise we
 		 * may get invalid kobj name for target
-- 
2.39.5



