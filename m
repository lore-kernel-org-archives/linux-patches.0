Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62C071F426E;
	Wed,  6 Nov 2024 12:54:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897640; cv=none; b=ruVAb8mRgxu/zw72cAAomqQt9R32Hym560gQQIZQ0kEOpfI1ssBRY8o3scb07K1iVaFlsAMwRb9N2mP1s3YzBzXOHynpO19ecoelCGDJ9aqO2biMVL0rQFaw8M9CJiPWa+5Rcy8mYbhiCG0MPYu1GBrnFUYIWBw+kzjvGWZvAKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897640; c=relaxed/simple;
	bh=LU8K3uISj+S73M1eftBZKrULqkAa0wQu3srLAsu/Nk0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nXsTUC3kWjufkewIzUMQ9ssCx934Sa+wRHVrMNpEUoLylNZ5/qlbSe3PvrdOjgLZmUm3Afko0JdrlJJ6YzPCTTTp2o4QICLKU/DlrJvAAPdT1H28b/es862r+2jbi1xn8mHvL+gD5Pl04qMz24Md3wOf6OqY9EJkqyY387pGDpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XiZOCKci; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XiZOCKci"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4617C4CECD;
	Wed,  6 Nov 2024 12:53:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897640;
	bh=LU8K3uISj+S73M1eftBZKrULqkAa0wQu3srLAsu/Nk0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XiZOCKciQ+D5tN/Te0hbQbjD4b9yEUpWEu+zhl9IH7ZVk0EMJ1A9N4AWnqcvpdxv7
	 yiEKJ1F9ajORfAv3oTpD5ZEw6EfFjG4rArX8IkULWpBQfGPi6Pz2nAAAx4WGjjPjbC
	 BBmvWWjeyrr1eh6mOmtLQR/qGU3auVygB2NaVEeY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shawn Wang <shawnwang@linux.alibaba.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 122/151] sched/numa: Fix the potential null pointer dereference in task_numa_work()
Date: Wed,  6 Nov 2024 13:05:10 +0100
Message-ID: <20241106120312.220005822@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120308.841299741@linuxfoundation.org>
References: <20241106120308.841299741@linuxfoundation.org>
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

From: Shawn Wang <shawnwang@linux.alibaba.com>

[ Upstream commit 9c70b2a33cd2aa6a5a59c5523ef053bd42265209 ]

When running stress-ng-vm-segv test, we found a null pointer dereference
error in task_numa_work(). Here is the backtrace:

  [323676.066985] Unable to handle kernel NULL pointer dereference at virtual address 0000000000000020
  ......
  [323676.067108] CPU: 35 PID: 2694524 Comm: stress-ng-vm-se
  ......
  [323676.067113] pstate: 23401009 (nzCv daif +PAN -UAO +TCO +DIT +SSBS BTYPE=--)
  [323676.067115] pc : vma_migratable+0x1c/0xd0
  [323676.067122] lr : task_numa_work+0x1ec/0x4e0
  [323676.067127] sp : ffff8000ada73d20
  [323676.067128] x29: ffff8000ada73d20 x28: 0000000000000000 x27: 000000003e89f010
  [323676.067130] x26: 0000000000080000 x25: ffff800081b5c0d8 x24: ffff800081b27000
  [323676.067133] x23: 0000000000010000 x22: 0000000104d18cc0 x21: ffff0009f7158000
  [323676.067135] x20: 0000000000000000 x19: 0000000000000000 x18: ffff8000ada73db8
  [323676.067138] x17: 0001400000000000 x16: ffff800080df40b0 x15: 0000000000000035
  [323676.067140] x14: ffff8000ada73cc8 x13: 1fffe0017cc72001 x12: ffff8000ada73cc8
  [323676.067142] x11: ffff80008001160c x10: ffff000be639000c x9 : ffff8000800f4ba4
  [323676.067145] x8 : ffff000810375000 x7 : ffff8000ada73974 x6 : 0000000000000001
  [323676.067147] x5 : 0068000b33e26707 x4 : 0000000000000001 x3 : ffff0009f7158000
  [323676.067149] x2 : 0000000000000041 x1 : 0000000000004400 x0 : 0000000000000000
  [323676.067152] Call trace:
  [323676.067153]  vma_migratable+0x1c/0xd0
  [323676.067155]  task_numa_work+0x1ec/0x4e0
  [323676.067157]  task_work_run+0x78/0xd8
  [323676.067161]  do_notify_resume+0x1ec/0x290
  [323676.067163]  el0_svc+0x150/0x160
  [323676.067167]  el0t_64_sync_handler+0xf8/0x128
  [323676.067170]  el0t_64_sync+0x17c/0x180
  [323676.067173] Code: d2888001 910003fd f9000bf3 aa0003f3 (f9401000)
  [323676.067177] SMP: stopping secondary CPUs
  [323676.070184] Starting crashdump kernel...

stress-ng-vm-segv in stress-ng is used to stress test the SIGSEGV error
handling function of the system, which tries to cause a SIGSEGV error on
return from unmapping the whole address space of the child process.

Normally this program will not cause kernel crashes. But before the
munmap system call returns to user mode, a potential task_numa_work()
for numa balancing could be added and executed. In this scenario, since the
child process has no vma after munmap, the vma_next() in task_numa_work()
will return a null pointer even if the vma iterator restarts from 0.

Recheck the vma pointer before dereferencing it in task_numa_work().

Fixes: 214dbc428137 ("sched: convert to vma iterator")
Signed-off-by: Shawn Wang <shawnwang@linux.alibaba.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org # v6.2+
Link: https://lkml.kernel.org/r/20241025022208.125527-1-shawnwang@linux.alibaba.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 5eb4807bad209..db59bf549c644 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3314,7 +3314,7 @@ static void task_numa_work(struct callback_head *work)
 		vma = vma_next(&vmi);
 	}
 
-	do {
+	for (; vma; vma = vma_next(&vmi)) {
 		if (!vma_migratable(vma) || !vma_policy_mof(vma) ||
 			is_vm_hugetlb_page(vma) || (vma->vm_flags & VM_MIXEDMAP)) {
 			trace_sched_skip_vma_numa(mm, vma, NUMAB_SKIP_UNSUITABLE);
@@ -3434,7 +3434,7 @@ static void task_numa_work(struct callback_head *work)
 		 */
 		if (vma_pids_forced)
 			break;
-	} for_each_vma(vmi, vma);
+	}
 
 	/*
 	 * If no VMAs are remaining and VMAs were skipped due to the PID
-- 
2.43.0



