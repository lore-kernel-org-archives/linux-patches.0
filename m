Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14FB34AC152;
	Wed, 23 Sep 2026 14:54:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790175287; cv=none; b=krj7brVpbtQ3O/ZBYsEXwOP0pyyYvokozb8NqUNtyfI3rofhLPgHZa4Mce26ZPDFz/yHA89QcKNCZL6nSFsC1NKODyOf/bbdfVjc9vrR6JQKWV1VS/VsQ9gF7spfgUOh6M16c5loiQziztO7J94gD4nIJPMMI6uaU+36WmfepTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790175287; c=relaxed/simple;
	bh=kl1a9keIv2BecltdSSgo6KVE8TAces7JCOvP7+63H6w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KiLx9uB9ziCv7oG7AihpVvdtO3BCbJFSgqgVbEPuNJbVsLQeerXXWPrDUBFpZVWBOZYfnuNfCoWA/brb3Qcbroz9eLnMHecg9SrJOa7/OJ9Z/4qbiUDOmYrV25fZD+ebD7jr+Jnl9fpyFvao9QDqwIR3zmpJTCNAHAdssrgD/gA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lLu8tKBx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lLu8tKBx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2D391F00893;
	Wed, 23 Sep 2026 14:54:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790175286;
	bh=YMuhI7p1P+WgjFOakrSjyMNN1jZLHQOYeurXeW6QOxQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lLu8tKBxGyUO2Ws1mN9EtrtfaFiwF0azvxhv6bs/1AbN1zE7OryTnRUare8XpXwGL
	 yVtiKZbsxFu22cWivuj8FdhLMbJupdC/3P8ZWeAnEpfkW2+87uhQdz9Niw0GjyauKE
	 71CSZx+Nkpi2lEOuq+IqAVQ2DRZeHJcooMVDNEe4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sesidhar Baddela <sebaddel@cisco.com>,
	Arulprabhu Ponnusamy <arulponn@cisco.com>,
	Gian Carlo Boffa <gcboffa@cisco.com>,
	Karan Tilak Kumar <kartilak@cisco.com>,
	Arun Easi <aeasi@cisco.com>,
	Laurence Oberman <loberman@redhat.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 379/398] scsi: fnic: Fix missed link-up when critical IRQ targets offline CPU
Date: Wed, 23 Sep 2026 16:07:33 +0200
Message-ID: <20260923140653.281439685@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

From: Arun Easi <aeasi@cisco.com>

[ Upstream commit 0cb1fd924126f1f581621a5e804df98a02be9dff ]

When CPU Hyper Threading is disabled, sibling CPUs remain present but
are reported offline. Managed MSI-X IRQs can still receive affinity
masks that include those offline CPUs. If a driver-critical vector is
managed, it can be parked on an offline CPU and the driver may miss
critical events such as link-up.

Keep driver-critical vectors unmanaged so they can be migrated by the
IRQ core when their target CPU is offlined.

Since HWQ-0 is unmanaged now, in some queue combinations there can be no
mappings to it in mq_map. So without the blk-mq fix mentioned below,
system may crash during cpu offline/online tests.

Fixes: 8a8449ca5e33 ("scsi: fnic: Modify ISRs to support multiqueue (MQ)")
Cc: stable@vger.kernel.org
Depends-on: commit 10845a105bbc ("blk-mq: skip CPU offline notify on unmapped hctx")
Reviewed-by: Sesidhar Baddela <sebaddel@cisco.com>
Reviewed-by: Arulprabhu Ponnusamy <arulponn@cisco.com>
Reviewed-by: Gian Carlo Boffa <gcboffa@cisco.com>
Reviewed-by: Karan Tilak Kumar <kartilak@cisco.com>
Signed-off-by: Arun Easi <aeasi@cisco.com>
Reviewed-by: Laurence Oberman <loberman@redhat.com>
Link: https://patch.msgid.link/20260903175547.57971-1-aeasi@cisco.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/fnic/fnic.h      |    2 +-
 drivers/scsi/fnic/fnic_isr.c  |   13 ++++++++++---
 drivers/scsi/fnic/fnic_main.c |   33 ++++++++++++++++++++++++++++++++-
 3 files changed, 43 insertions(+), 5 deletions(-)

--- a/drivers/scsi/fnic/fnic.h
+++ b/drivers/scsi/fnic/fnic.h
@@ -30,7 +30,7 @@
 
 #define DRV_NAME		"fnic"
 #define DRV_DESCRIPTION		"Cisco FCoE HBA Driver"
-#define DRV_VERSION		"1.9.0.0"
+#define DRV_VERSION		"1.9.0.1"
 #define PFX			DRV_NAME ": "
 #define DFX                     DRV_NAME "%d: "
 
--- a/drivers/scsi/fnic/fnic_isr.c
+++ b/drivers/scsi/fnic/fnic_isr.c
@@ -245,7 +245,14 @@ int fnic_set_intr_mode_msix(struct fnic
 	unsigned int m = ARRAY_SIZE(fnic->wq);
 	unsigned int o = ARRAY_SIZE(fnic->hw_copy_wq);
 	unsigned int min_irqs = n + m + 1 + 1; /*rq, raw wq, wq, err*/
-
+	/*
+	 * Make driver critical vectors unmanaged, or else it can get tied
+	 * to an offline CPU. This can happen when hyper-threading is off.
+	 */
+	struct irq_affinity affd = {
+		.pre_vectors = n + m + 1, /* rq, raw wq, 1 ioq */
+		.post_vectors = 1, /* err */
+	};
 	/*
 	 * We need n RQs, m WQs, o Copy WQs, n+m+o CQs, and n+m+o+1 INTRs
 	 * (last INTR is used for WQ/RQ errors and notification area)
@@ -263,8 +270,8 @@ int fnic_set_intr_mode_msix(struct fnic
 		int vec_count = 0;
 		int vecs = fnic->rq_count + fnic->raw_wq_count + fnic->wq_copy_count + 1;
 
-		vec_count = pci_alloc_irq_vectors(fnic->pdev, min_irqs, vecs,
-					PCI_IRQ_MSIX | PCI_IRQ_AFFINITY);
+		vec_count = pci_alloc_irq_vectors_affinity(fnic->pdev, min_irqs,
+			    vecs, PCI_IRQ_MSIX|PCI_IRQ_AFFINITY, &affd);
 		FNIC_ISR_DBG(KERN_INFO, fnic,
 					"allocated %d MSI-X vectors\n",
 					vec_count);
--- a/drivers/scsi/fnic/fnic_main.c
+++ b/drivers/scsi/fnic/fnic_main.c
@@ -678,6 +678,8 @@ static int fnic_scsi_drv_init(struct fni
 
 void fnic_mq_map_queues_cpus(struct Scsi_Host *host)
 {
+	const struct cpumask *mask;
+	unsigned int queue, cpu;
 	struct fnic *fnic = *((struct fnic **) shost_priv(host));
 	struct pci_dev *l_pdev = fnic->pdev;
 	int intr_mode = fnic->config.intr_mode;
@@ -698,7 +700,36 @@ void fnic_mq_map_queues_cpus(struct Scsi
 		return;
 	}
 
-	blk_mq_map_hw_queues(qmap, &l_pdev->dev, FNIC_PCI_OFFSET);
+	for_each_possible_cpu(cpu)
+		qmap->mq_map[cpu] = 0;
+
+	/*
+	 * Setup CPU to Queue mapping for all managed MSI-X IRQs.
+	 * Q0 is driver critical and non-managed, hence start from Q1.
+	 */
+	for (queue = 1; queue < qmap->nr_queues; queue++) {
+		int irq_num = pci_irq_vector(fnic->pdev,
+					     queue + FNIC_PCI_OFFSET);
+
+		if (irq_num < 0)
+			continue;
+
+		mask = pci_irq_get_affinity(fnic->pdev,
+					    queue + FNIC_PCI_OFFSET);
+		if (!mask) {
+			shost_printk(KERN_ERR, host,
+				"failed to get irq_affinity map for queue:%d\n", irq_num);
+			continue;
+		}
+		FNIC_MAIN_DBG(KERN_INFO, fnic,
+				"got irq_affinity map for %d:\n", irq_num);
+		for_each_cpu(cpu, mask) {
+			qmap->mq_map[cpu] = qmap->queue_offset + queue;
+			FNIC_MAIN_DBG(KERN_INFO, fnic,
+				      "[Q%d] cpu:%d <=> irq:%d\n",
+				      queue, cpu, irq_num);
+		}
+	}
 }
 
 static int fnic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)


