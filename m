Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E76547F2CC;
	Sat, 12 Sep 2026 13:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789219460; cv=none; b=Nu/EhYkcyPPHahFGHyckpJD/kGXzyGt5uUbPOANRFmMhR0dib7wRbJ9HZAhAqfps4E8RXfZTuHFbh/swY6m3bU2ivT3Ocnt14D+LU1O9Im2LYWJX2wghX+k+mOicaNtQRnPzb4E8XWNlDt4qk/PUm5k/3jqJnj0cIg7uIzTgqfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789219460; c=relaxed/simple;
	bh=XYJaaA9niH+z4zrCYEBZbdxT1Xe1PDY3aMDCJikj+Bc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UhluzU62m8EksfisHEfSC1R21BGp8daFHb+mYu4MNXaGzLmATN3xarDL+IjSyUULldrfRS9v3B4IIv2Zo9CTiNhs43QOqG0iKa9bL7F4un72w2yPaqETRSEc5kcUGR3ZG5XjB8IHSq/gKY8CADNoKcFplQ10jl+wy0fNgy8Sl8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0hrYX6pd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0hrYX6pd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BB991F000FF;
	Sat, 12 Sep 2026 13:24:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789219459;
	bh=z6A7FpRtLj+3KfyQ8lvt9fPClPMHenMG5KVzL1B64D0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0hrYX6pdIF8flEgN/sBJ6OdCthZnfJcfFW7c8PJu+0omSzL4ZFo9jEWWth1D4JvQ+
	 cCOg38LkH5R2V9Ias6l4CkgnqJ3mHuta14WeWkKbtuXoGw0lubKY1TVyjbKBPGNOq5
	 m1Kr6siW/+rMmkbtZZBWOc7AYe6mjgqo05z6ttmU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ridong <chenridong@huawei.com>,
	Waiman Long <longman@redhat.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1356/1376] cpuset: fix warning when disabling remote partition
Date: Sat, 12 Sep 2026 09:03:02 +0200
Message-ID: <20260912065637.755135016@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Ridong <chenridong@huawei.com>

[ Upstream commit aa7d3a56a20f07978d9f401e13637a6479b13bd0 ]

A warning was triggered as follows:

WARNING: kernel/cgroup/cpuset.c:1651 at remote_partition_disable+0xf7/0x110
RIP: 0010:remote_partition_disable+0xf7/0x110
RSP: 0018:ffffc90001947d88 EFLAGS: 00000206
RAX: 0000000000007fff RBX: ffff888103b6e000 RCX: 0000000000006f40
RDX: 0000000000006f00 RSI: ffffc90001947da8 RDI: ffff888103b6e000
RBP: ffff888103b6e000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000001 R11: ffff88810b2e2728 R12: ffffc90001947da8
R13: 0000000000000000 R14: ffffc90001947da8 R15: ffff8881081f1c00
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f55c8bbe0b2 CR3: 000000010b14c000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 update_prstate+0x2d3/0x580
 cpuset_partition_write+0x94/0xf0
 kernfs_fop_write_iter+0x147/0x200
 vfs_write+0x35d/0x500
 ksys_write+0x66/0xe0
 do_syscall_64+0x6b/0x390
 entry_SYSCALL_64_after_hwframe+0x4b/0x53
RIP: 0033:0x7f55c8cd4887

Reproduction steps (on a 16-CPU machine):

        # cd /sys/fs/cgroup/
        # mkdir A1
        # echo +cpuset > A1/cgroup.subtree_control
        # echo "0-14" > A1/cpuset.cpus.exclusive
        # mkdir A1/A2
        # echo "0-14" > A1/A2/cpuset.cpus.exclusive
        # echo "root" > A1/A2/cpuset.cpus.partition
        # echo 0 > /sys/devices/system/cpu/cpu15/online
        # echo member > A1/A2/cpuset.cpus.partition

When CPU 15 is offlined, subpartitions_cpus gets cleared because no CPUs
remain available for the top_cpuset, forcing partitions to share CPUs with
the top_cpuset. In this scenario, disabling the remote partition triggers
a warning stating that effective_xcpus is not a subset of
subpartitions_cpus. Partitions should be invalidated in this case to
inform users that the partition is now invalid(cpus are shared with
top_cpuset).

To fix this issue:
1. Only emit the warning only if subpartitions_cpus is not empty and the
   effective_xcpus is not a subset of subpartitions_cpus.
2. During the CPU hotplug process, invalidate partitions if
   subpartitions_cpus is empty.

Fixes: f62a5d39368e ("cgroup/cpuset: Remove remote_partition_check() & make update_cpumasks_hier() handle remote partition")
Signed-off-by: Chen Ridong <chenridong@huawei.com>
Reviewed-by: Waiman Long <longman@redhat.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cgroup/cpuset.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index ae78380ca3dbb..ba023c19f502b 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1484,7 +1484,14 @@ static void remote_partition_disable(struct cpuset *cs, struct tmpmasks *tmp)
 	bool isolcpus_updated;
 
 	WARN_ON_ONCE(!is_remote_partition(cs));
-	WARN_ON_ONCE(!cpumask_subset(cs->effective_xcpus, subpartitions_cpus));
+	/*
+	 * When a CPU is offlined, top_cpuset may end up with no available CPUs,
+	 * which should clear subpartitions_cpus. We should not emit a warning for this
+	 * scenario: the hierarchy is updated from top to bottom, so subpartitions_cpus
+	 * may already be cleared when disabling the partition.
+	 */
+	WARN_ON_ONCE(!cpumask_subset(cs->effective_xcpus, subpartitions_cpus) &&
+		     !cpumask_empty(subpartitions_cpus));
 
 	spin_lock_irq(&callback_lock);
 	list_del_init(&cs->remote_sibling);
@@ -3816,8 +3823,9 @@ static void cpuset_hotplug_update_tasks(struct cpuset *cs, struct tmpmasks *tmp)
 	if (remote || (is_partition_valid(cs) && is_partition_valid(parent)))
 		compute_partition_effective_cpumask(cs, &new_cpus);
 
-	if (remote && cpumask_empty(&new_cpus) &&
-	    partition_is_populated(cs, NULL)) {
+	if (remote && (cpumask_empty(subpartitions_cpus) ||
+			(cpumask_empty(&new_cpus) &&
+			 partition_is_populated(cs, NULL)))) {
 		cs->prs_err = PERR_HOTPLUG;
 		remote_partition_disable(cs, tmp);
 		compute_effective_cpumask(&new_cpus, cs, parent);
@@ -3830,9 +3838,12 @@ static void cpuset_hotplug_update_tasks(struct cpuset *cs, struct tmpmasks *tmp)
 	 * 1) empty effective cpus but not valid empty partition.
 	 * 2) parent is invalid or doesn't grant any cpus to child
 	 *    partitions.
+	 * 3) subpartitions_cpus is empty.
 	 */
-	if (is_local_partition(cs) && (!is_partition_valid(parent) ||
-				tasks_nocpu_error(parent, cs, &new_cpus)))
+	if (is_local_partition(cs) &&
+	    (!is_partition_valid(parent) ||
+	     tasks_nocpu_error(parent, cs, &new_cpus) ||
+	     cpumask_empty(subpartitions_cpus)))
 		partcmd = partcmd_invalidate;
 	/*
 	 * On the other hand, an invalid partition root may be transitioned
-- 
2.53.0



