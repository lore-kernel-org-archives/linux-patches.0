Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C38CA322764;
	Mon, 18 Aug 2025 13:37:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524223; cv=none; b=aAEwr9c7DHPnq4yC5acmLU/G8oZQAEGel0/Q9p1x6ak/XseI4M7de3lZ5/P1ehFqMUOfagIF/f9ZxweNDL6up3rU0C/uuc+qtWcTbMEYQvwOq8mHgcHMjAMnZb4e2Ga+MHGkWich6hXj5LF4CIDX1I8RyEN4Q2R3qq8zxkF5z5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524223; c=relaxed/simple;
	bh=pp6lmWFG00JiprghlRuMuBSHeiue9ePLLEdoWLJF6NE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sI0h0QjARq4KvsRnvSAdu9wB8Qniz6i2gpBeTMx9F+xxgekaq+Xwt1Zuk3slIYx0AnndEdEiWjTwdbbX9QXAIBPuM8xKIXe2MX8KKFgta6c7VHwzfCsthq9oZ7eMyS7yhODZcQdxMjJEQ56lw5JLlQxtJDeIPTsgBqZVg+GlJXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nZs+Wmnz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nZs+Wmnz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD7D2C4CEEB;
	Mon, 18 Aug 2025 13:37:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524223;
	bh=pp6lmWFG00JiprghlRuMuBSHeiue9ePLLEdoWLJF6NE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nZs+Wmnz7AcAlg9UyqGMnC9pEduQRukSwVfwEZYBtV8GyIDY5qSMlCDhS3QW962wT
	 EvGwI0yO9tFe+LXB7WWmlcuJo9ftcWghK52bWqmfi+IP1ExDZ8gCJrCxQUIsKRzjG8
	 nnbvkPqSuQc/fL0JCX8Y3howlfNd6o95uk00YsEc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Keith Busch <kbusch@kernel.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 406/515] vfio/type1: conditional rescheduling while pinning
Date: Mon, 18 Aug 2025 14:46:32 +0200
Message-ID: <20250818124514.038042214@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

From: Keith Busch <kbusch@kernel.org>

[ Upstream commit b1779e4f209c7ff7e32f3c79d69bca4e3a3a68b6 ]

A large DMA mapping request can loop through dma address pinning for
many pages. In cases where THP can not be used, the repeated vmf_insert_pfn can
be costly, so let the task reschedule as need to prevent CPU stalls. Failure to
do so has potential harmful side effects, like increased memory pressure
as unrelated rcu tasks are unable to make their reclaim callbacks and
result in OOM conditions.

 rcu: INFO: rcu_sched self-detected stall on CPU
 rcu:   36-....: (20999 ticks this GP) idle=b01c/1/0x4000000000000000 softirq=35839/35839 fqs=3538
 rcu:            hardirqs   softirqs   csw/system
 rcu:    number:        0        107            0
 rcu:   cputime:       50          0        10446   ==> 10556(ms)
 rcu:   (t=21075 jiffies g=377761 q=204059 ncpus=384)
...
  <TASK>
  ? asm_sysvec_apic_timer_interrupt+0x16/0x20
  ? walk_system_ram_range+0x63/0x120
  ? walk_system_ram_range+0x46/0x120
  ? pgprot_writethrough+0x20/0x20
  lookup_memtype+0x67/0xf0
  track_pfn_insert+0x20/0x40
  vmf_insert_pfn_prot+0x88/0x140
  vfio_pci_mmap_huge_fault+0xf9/0x1b0 [vfio_pci_core]
  __do_fault+0x28/0x1b0
  handle_mm_fault+0xef1/0x2560
  fixup_user_fault+0xf5/0x270
  vaddr_get_pfns+0x169/0x2f0 [vfio_iommu_type1]
  vfio_pin_pages_remote+0x162/0x8e0 [vfio_iommu_type1]
  vfio_iommu_type1_ioctl+0x1121/0x1810 [vfio_iommu_type1]
  ? futex_wake+0x1c1/0x260
  x64_sys_call+0x234/0x17a0
  do_syscall_64+0x63/0x130
  ? exc_page_fault+0x63/0x130
  entry_SYSCALL_64_after_hwframe+0x4b/0x53

Signed-off-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Paul E. McKenney <paulmck@kernel.org>
Link: https://lore.kernel.org/r/20250715184622.3561598-1-kbusch@meta.com
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/vfio_iommu_type1.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index ba5d91e576af..a685e01f73f5 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -648,6 +648,13 @@ static long vfio_pin_pages_remote(struct vfio_dma *dma, unsigned long vaddr,
 
 	while (npage) {
 		if (!batch->size) {
+			/*
+			 * Large mappings may take a while to repeatedly refill
+			 * the batch, so conditionally relinquish the CPU when
+			 * needed to avoid stalls.
+			 */
+			cond_resched();
+
 			/* Empty batch, so refill it. */
 			ret = vaddr_get_pfns(mm, vaddr, npage, dma->prot,
 					     &pfn, batch);
-- 
2.39.5



