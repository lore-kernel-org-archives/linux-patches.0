Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D290713B2BE;
	Tue, 27 Feb 2024 13:39:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041148; cv=none; b=lVMIWSU8OrHE7bEGVx++2PIaeks1KQtiAygOgFA/KUjNVHklhcnCfjMMxBWFAjR6H0bz38ZgeWm9Yz80cIBBZNYSLpDg1Io50MOdYjk9nLIOpjrH81W/IznWOr50fhVzeihahUj6Pfdn3HOOsmb6valOriGYiulhMgB04Ye9+1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041148; c=relaxed/simple;
	bh=xVgzLn3rPX7bpXW6B5iJd2oCp9p+extLE3ZQFjFaBWo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tWB7pdEe2soBm6fB156iWQJhuQojFqbID0zEvjOkVdL/Gr7D2apcE75PsCLlIN6y46He+L1B9t9EJDysZmlkvlT6gQjk7wHVfmGlG/5nr9KcJNIOgtKRjn+G25mF7Hh7YLBJB/STJf2LHM8dYjpODUq4Gq0RvvIct5lVYf8TgWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1VaNq+4g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1VaNq+4g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62FAFC433F1;
	Tue, 27 Feb 2024 13:39:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041148;
	bh=xVgzLn3rPX7bpXW6B5iJd2oCp9p+extLE3ZQFjFaBWo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1VaNq+4guojJndkt4pQFYvVQtLxI9TfHbrdgkP09zKcMf7UOxe8kM3a9YwAg9KOOI
	 aYGOYCCEniTWMoMBh1/1iioLGS+S/tznJ/hBH714VzL2RKxY1rhoXXqDdrsTbfLgL+
	 7qRjWcfvdIF0vdiyYoZDceNxkToOO0vlrFDSOUfk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Marciniszyn <mike.marciniszyn@intel.com>,
	Shiraz Saleem <shiraz.saleem@intel.com>,
	Sindhu Devale <sindhu.devale@intel.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 237/334] RDMA/irdma: Fix KASAN issue with tasklet
Date: Tue, 27 Feb 2024 14:21:35 +0100
Message-ID: <20240227131638.520683710@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index bd4b2b8964444..2f8d18d8be3b7 100644
--- a/drivers/infiniband/hw/irdma/hw.c
+++ b/drivers/infiniband/hw/irdma/hw.c
@@ -570,6 +570,13 @@ static void irdma_destroy_irq(struct irdma_pci_f *rf,
 	dev->irq_ops->irdma_dis_irq(dev, msix_vec->idx);
 	irq_update_affinity_hint(msix_vec->irq, NULL);
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



