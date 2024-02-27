Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24BE513A26F;
	Tue, 27 Feb 2024 14:10:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043017; cv=none; b=HF6wgA1VBBMcmNJndp6CVLGfsrzZPi6OX2kaOMobMalUbDOVLm+tPmTQ9o5QdzSWjhb3bSbKbRgqB7yaSYLEB04Ir6W/t0j11yiwIvgiN/+TNvUbwOuOWicsUwLeYX/4Ct0yAqvMpknt1KrcOW60b0E55IFtayU48Ws7Ju4FKG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043017; c=relaxed/simple;
	bh=q8CcwXoLKqaT8pP1fXG4UIHx4jV9r8ATzBlFkeOaKCU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DpD4CN0TPpPeffgo7tUWsKPLFMYcChloesM9Jw2lrfnfxNziTOXwgrHMhuzcBHBPWqDHtiBqyzF/aidzH+wWVmy2IN4SJs+KwUcH0mPor5Wr/r+NUYRRy8HeoFTh/2hk8JzN8KafuDsrbGrg9ZCWY7y6VMLI4DyLRdw3IFifzeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0Ax7bJGQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0Ax7bJGQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C9EDC433C7;
	Tue, 27 Feb 2024 14:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043016;
	bh=q8CcwXoLKqaT8pP1fXG4UIHx4jV9r8ATzBlFkeOaKCU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0Ax7bJGQoT1v9PksvF3V9g4R5xBR92zhKZAS3z62lq8MOyKBEeJ7wGgKyVy9c+9z2
	 IidhIiqONpoblWel03T/WRySen214BuJvYAw5yBvGdvzxiPDgKwhQYwSfsdzesK8B4
	 5YNmNkmPhvH8l8Xu//aYAR6cHxY1a7t8z8YpAEgA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Marciniszyn <mike.marciniszyn@intel.com>,
	Shiraz Saleem <shiraz.saleem@intel.com>,
	Sindhu Devale <sindhu.devale@intel.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 203/245] RDMA/irdma: Fix KASAN issue with tasklet
Date: Tue, 27 Feb 2024 14:26:31 +0100
Message-ID: <20240227131621.798722556@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131615.098467438@linuxfoundation.org>
References: <20240227131615.098467438@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Marciniszyn <mike.marciniszyn@intel.com>

[ Upstream commit bd97cea7b18a0a553773af806dfbfac27a7c4acb ]

KASAN testing revealed the following issue assocated with freeing an IRQ.

[50006.466686] Call Trace:
[50006.466691]  <IRQ>
[50006.489538]  dump_stack+0x5c/0x80
[50006.493475]  print_address_description.constprop.6+0x1a/0x150
[50006.499872]  ? irdma_sc_process_ceq+0x483/0x790 [irdma]
[50006.505742]  ? irdma_sc_process_ceq+0x483/0x790 [irdma]
[50006.511644]  kasan_report.cold.11+0x7f/0x118
[50006.516572]  ? irdma_sc_process_ceq+0x483/0x790 [irdma]
[50006.522473]  irdma_sc_process_ceq+0x483/0x790 [irdma]
[50006.528232]  irdma_process_ceq+0xb2/0x400 [irdma]
[50006.533601]  ? irdma_hw_flush_wqes_callback+0x370/0x370 [irdma]
[50006.540298]  irdma_ceq_dpc+0x44/0x100 [irdma]
[50006.545306]  tasklet_action_common.isra.14+0x148/0x2c0
[50006.551096]  __do_softirq+0x1d0/0xaf8
[50006.555396]  irq_exit_rcu+0x219/0x260
[50006.559670]  irq_exit+0xa/0x20
[50006.563320]  smp_apic_timer_interrupt+0x1bf/0x690
[50006.568645]  apic_timer_interrupt+0xf/0x20
[50006.573341]  </IRQ>

The issue is that a tasklet could be pending on another core racing
the delete of the irq.

Fix by insuring any scheduled tasklet is killed after deleting the
irq.

Fixes: 44d9e52977a1 ("RDMA/irdma: Implement device initialization definitions")
Signed-off-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
Signed-off-by: Sindhu Devale <sindhu.devale@intel.com>
Link: https://lore.kernel.org/r/20240131233849.400285-2-sindhu.devale@intel.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/irdma/hw.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/infiniband/hw/irdma/hw.c b/drivers/infiniband/hw/irdma/hw.c
index 0359f415280c8..21d55a12ebd9f 100644
--- a/drivers/infiniband/hw/irdma/hw.c
+++ b/drivers/infiniband/hw/irdma/hw.c
@@ -562,6 +562,13 @@ static void irdma_destroy_irq(struct irdma_pci_f *rf,
 	dev->irq_ops->irdma_dis_irq(dev, msix_vec->idx);
 	irq_set_affinity_hint(msix_vec->irq, NULL);
 	free_irq(msix_vec->irq, dev_id);
+	if (rf == dev_id) {
+		tasklet_kill(&rf->dpc_tasklet);
+	} else {
+		struct irdma_ceq *iwceq = (struct irdma_ceq *)dev_id;
+
+		tasklet_kill(&iwceq->dpc_tasklet);
+	}
 }
 
 /**
-- 
2.43.0



