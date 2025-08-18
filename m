Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2CAA3218CA;
	Mon, 18 Aug 2025 13:08:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522527; cv=none; b=i3KEVEYOxL5zV1AaFG+hT1I6SYlkaPHXXZsnu4En+OuFkwNix+oSlbyidljE2h6NTRbQUeCCrKsuJdY8tRrlYYLbM979ndcSQCm1PmmJmVdaNbnfhvrUvS6Ohjcn23PgYqD0NxY3t42h5ePj3yrH7CA6yt+CP2o+MnB3/VybYcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522527; c=relaxed/simple;
	bh=oMbUCmBrymL2c5mDcjXFaX5JYZhz3m6LFPgM4rt/fcg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iKp21PL1c4hAbK3pD+VXdFFrZ+g9IPKdKKnikwLyD3cc9L9nMGMK9P7lD0PRa4AkEZL5H06ybm9837NHZE9ayxvkf9pkn1/sIMiU19H+llx9djI2Np7ixMsi64924EYpRiN/ba6XT2Kd3CZVvkz+SGBv3HeKa2m3Y7s+11U/p40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lGP3jlCo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lGP3jlCo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60B79C4CEF1;
	Mon, 18 Aug 2025 13:08:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522526;
	bh=oMbUCmBrymL2c5mDcjXFaX5JYZhz3m6LFPgM4rt/fcg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lGP3jlCoc27bcTTTeyR0E22SZB0O6OVYOIbI79tDpaFInxtp5mWvS3pRKMmYsPQkx
	 r5lAYQjAHZRzbTkuXhOTS5B9VlmaePTlnopKo4cDTe3K3ezGXuuMz9U/eQzkg7QslW
	 Hz53XWB31ZLOxbegyArKuwJRy7ta0Y6SC+1oEomc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Keith Busch <kbusch@kernel.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 343/444] vfio/type1: conditional rescheduling while pinning
Date: Mon, 18 Aug 2025 14:46:09 +0200
Message-ID: <20250818124501.787891295@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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
index 8338cfd61fe1..124997ce00d6 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -619,6 +619,13 @@ static long vfio_pin_pages_remote(struct vfio_dma *dma, unsigned long vaddr,
 
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
 			long req_pages = min_t(long, npage, batch->capacity);
 
-- 
2.39.5



