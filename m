Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59CCD35F8DA;
	Tue,  6 Jan 2026 17:48:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721728; cv=none; b=p4h2Ky0SMZwMjYch19IBJYu4wE4g/WMAToGQBCZZkpdYpYB4eGJFDDbG6Dpp5QcnQhcZW9VXeoWuDJ8JC1J2Q1ERa+xHREFPLL9V3NVQqo/k4TYXnzK+c7IIn6290jf0FTm+n8zpBT8ne0cbr9BZgW0rOCo1dS2RhEcaAmqveXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721728; c=relaxed/simple;
	bh=Jep1JRCCKCINjLesbYH/z6OCUpAMDfcGUBrEUqKgxiE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EiSd3nlFkCNNQwWwK8AD4YyhDg/iNyQ95M36cuxuiS83PHOBatHY4yhZC33egZseaHTd+hXLoE25Tj503qMxAknaItqb2W2mGRTm2cnEwCNZmL4gflZP6h71AAi4wIl7rwc1XdwfAg/xsHrTdCo00pVFozmRcpwMsAGfXnrFsJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SC8L/5Vn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SC8L/5Vn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8C5CC116C6;
	Tue,  6 Jan 2026 17:48:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721728;
	bh=Jep1JRCCKCINjLesbYH/z6OCUpAMDfcGUBrEUqKgxiE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SC8L/5VnFvZa9puvoEuz1Y6lotGElihffedIETjNfnmM/xQKJ8H9PBQUQNgBEpaiU
	 7tqW1ylOeoMthanPlPiKC9A9+o4pTnSQu1WXTHMmRQD5wqB31LI15rwklrP/hnO67K
	 80Jv/bn8+gS7kw7MM3wAKJFfvh1eJblx6bNAu3jE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ridong <chenridong@huawei.com>,
	Waiman Long <longman@redhat.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 022/312] cpuset: fix warning when disabling remote partition
Date: Tue,  6 Jan 2026 18:01:36 +0100
Message-ID: <20260106170548.658214981@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 4dcd633fd6df..61b56b6ca66a 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1600,7 +1600,14 @@ static void remote_partition_disable(struct cpuset *cs, struct tmpmasks *tmp)
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
@@ -3927,8 +3934,9 @@ static void cpuset_hotplug_update_tasks(struct cpuset *cs, struct tmpmasks *tmp)
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
@@ -3941,9 +3949,12 @@ static void cpuset_hotplug_update_tasks(struct cpuset *cs, struct tmpmasks *tmp)
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
2.51.0



