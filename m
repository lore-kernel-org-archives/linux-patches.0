Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D33B81A072D;
	Tue, 27 Aug 2024 15:13:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771619; cv=none; b=SgHsZjNurguXj46SZ1Qrb4GvD159niGK4w2qGJecq+XWfVG7cT63BqzaK403588jgTILYWzv41Qm2IdlEo/140c96J62qb+KBLIK7hru1Ay9mpC5yJnyAwIwlhAKt0z3pd4S/k1y5Tp5zm3DUrg4IlkoMCwXSCGoqHjnm5uf/Ng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771619; c=relaxed/simple;
	bh=gPWKzNWdkTPiHzNXLcdUawOizd/2dc5MV719/QSbo2I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WPYMU0jQOZn/33nJdV8f6773v57T/InNtEdB6Aowm6Dh9Y0ndtrP2etrbncLpJTBCMYdHjs49s+ojrxMdlQObFqoriFUMuGvLKQfRBJwFWVRaEF7zuWxIhW1/yy8XmEWxJIZ5bICT/dufcJ2VVNyWhdvN+6qEcW6oPiplYptyX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SSiO9l3d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SSiO9l3d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 433ADC6105F;
	Tue, 27 Aug 2024 15:13:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771619;
	bh=gPWKzNWdkTPiHzNXLcdUawOizd/2dc5MV719/QSbo2I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SSiO9l3dwSmxrv9Jspiys4EfLxba8cdFJZa4FzekMKxQV91SC5822bgQWhluBMwwA
	 NFi1JfgKKmc0UwWY19IO5Dgq4ZfBeC0UEt3dbwDylLdcw5U0Zanc+wJ6fYjlvJiENd
	 8Z16IfFmQnUnVjEBzu5Ih517CwMeV1Bmv/IacDdk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ridong <chenridong@huawei.com>,
	Waiman Long <longman@redhat.com>,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH 6.10 244/273] cgroup/cpuset: fix panic caused by partcmd_update
Date: Tue, 27 Aug 2024 16:39:28 +0200
Message-ID: <20240827143842.687355537@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Ridong <chenridong@huawei.com>

commit 959ab6350add903e352890af53e86663739fcb9a upstream.

We find a bug as below:
BUG: unable to handle page fault for address: 00000003
PGD 0 P4D 0
Oops: 0000 [#1] PREEMPT SMP NOPTI
CPU: 3 PID: 358 Comm: bash Tainted: G        W I        6.6.0-10893-g60d6
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/4
RIP: 0010:partition_sched_domains_locked+0x483/0x600
Code: 01 48 85 d2 74 0d 48 83 05 29 3f f8 03 01 f3 48 0f bc c2 89 c0 48 9
RSP: 0018:ffffc90000fdbc58 EFLAGS: 00000202
RAX: 0000000100000003 RBX: ffff888100b3dfa0 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 000000000002fe80
RBP: ffff888100b3dfb0 R08: 0000000000000001 R09: 0000000000000000
R10: ffffc90000fdbcb0 R11: 0000000000000004 R12: 0000000000000002
R13: ffff888100a92b48 R14: 0000000000000000 R15: 0000000000000000
FS:  00007f44a5425740(0000) GS:ffff888237d80000(0000) knlGS:0000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000100030973 CR3: 000000010722c000 CR4: 00000000000006e0
Call Trace:
 <TASK>
 ? show_regs+0x8c/0xa0
 ? __die_body+0x23/0xa0
 ? __die+0x3a/0x50
 ? page_fault_oops+0x1d2/0x5c0
 ? partition_sched_domains_locked+0x483/0x600
 ? search_module_extables+0x2a/0xb0
 ? search_exception_tables+0x67/0x90
 ? kernelmode_fixup_or_oops+0x144/0x1b0
 ? __bad_area_nosemaphore+0x211/0x360
 ? up_read+0x3b/0x50
 ? bad_area_nosemaphore+0x1a/0x30
 ? exc_page_fault+0x890/0xd90
 ? __lock_acquire.constprop.0+0x24f/0x8d0
 ? __lock_acquire.constprop.0+0x24f/0x8d0
 ? asm_exc_page_fault+0x26/0x30
 ? partition_sched_domains_locked+0x483/0x600
 ? partition_sched_domains_locked+0xf0/0x600
 rebuild_sched_domains_locked+0x806/0xdc0
 update_partition_sd_lb+0x118/0x130
 cpuset_write_resmask+0xffc/0x1420
 cgroup_file_write+0xb2/0x290
 kernfs_fop_write_iter+0x194/0x290
 new_sync_write+0xeb/0x160
 vfs_write+0x16f/0x1d0
 ksys_write+0x81/0x180
 __x64_sys_write+0x21/0x30
 x64_sys_call+0x2f25/0x4630
 do_syscall_64+0x44/0xb0
 entry_SYSCALL_64_after_hwframe+0x78/0xe2
RIP: 0033:0x7f44a553c887

It can be reproduced with cammands:
cd /sys/fs/cgroup/
mkdir test
cd test/
echo +cpuset > ../cgroup.subtree_control
echo root > cpuset.cpus.partition
cat /sys/fs/cgroup/cpuset.cpus.effective
0-3
echo 0-3 > cpuset.cpus // taking away all cpus from root

This issue is caused by the incorrect rebuilding of scheduling domains.
In this scenario, test/cpuset.cpus.partition should be an invalid root
and should not trigger the rebuilding of scheduling domains. When calling
update_parent_effective_cpumask with partcmd_update, if newmask is not
null, it should recheck newmask whether there are cpus is available
for parect/cs that has tasks.

Fixes: 0c7f293efc87 ("cgroup/cpuset: Add cpuset.cpus.exclusive.effective for v2")
Cc: stable@vger.kernel.org # v6.7+
Signed-off-by: Chen Ridong <chenridong@huawei.com>
Signed-off-by: Waiman Long <longman@redhat.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/cgroup/cpuset.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1940,6 +1940,8 @@ static int update_parent_effective_cpuma
 			part_error = PERR_CPUSEMPTY;
 			goto write_error;
 		}
+		/* Check newmask again, whether cpus are available for parent/cs */
+		nocpu |= tasks_nocpu_error(parent, cs, newmask);
 
 		/*
 		 * partcmd_update with newmask:


