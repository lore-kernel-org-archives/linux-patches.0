Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DE8138E8CE;
	Wed, 30 Sep 2026 18:02:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791367; cv=none; b=T0Xjqo1GtvSa902S5ddg5FKonLhjKbXoCIxroZdkJ0QWXecn50uzdxy+D3bWMMHoLsyXIRP/z8uwz3ljLIrurrYH3qtB/tzAycWIokXSPEOLaxkSgHInJuu7UBIHjm12ot4n7XH82QRnZvuuK3mNuibeJ5VTKWAo16Ein6JIIm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791367; c=relaxed/simple;
	bh=tB7eyQBwktjdMVdppjEoc5JnZzWAEum8eDsKOVZnP/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hwpdJdjZyeAsoW5YDRD9vj+WLBf52Jx/5UdspR0c9mYLPziaFz9gHmXO3YixUXlYCJlVL5iCfRZDbEv1W755oAyrbRPGJqQXjbXP+EVo/2j7ZnKjmfF2jBvv+QzNAS4etbiROnGc1f6fUKgDuF3P7gXvB8ikfz+lAQvZJDxaMko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qm+f4V+O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qm+f4V+O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6F021F000FF;
	Wed, 30 Sep 2026 18:02:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791366;
	bh=5dk8sCKJ65K2yqEL7+bJ185nK1v+Gst0vaPiztkrHZg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qm+f4V+OLw1CL1huonb3kR/ZcKpCm8u5Cef5sz42bFtWFWUCsJqGguhtV0y7i/XcP
	 HxO8/PpzEF9t+tElQ1WRhqU+FHGiYMJg0zP51AYZy4t7XsC7IeazsDLJ8FkvUJllXW
	 pd+wnwGH68scFz3myNWP+vw0PwYECtBLceY7+Rhs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nitesh Narayan Lal <nitesh@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 270/752] scsi: mpt3sas: Use irq_set_affinity_and_hint()
Date: Wed, 30 Sep 2026 17:22:20 +0200
Message-ID: <20260930152404.126807841@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nitesh Narayan Lal <nitesh@redhat.com>

[ Upstream commit fdb8ed13a77270c8e6e05b3ff9f4cb2f57e16d6a ]

The driver uses irq_set_affinity_hint() specifically for the high IOPS
queue interrupts for two purposes:

 - To set the affinity_hint which is consumed by the userspace for
   distributing the interrupts

 - To apply an affinity that it provides

The driver enforces its own affinity to bind the high IOPS queue interrupts
to the local NUMA node. However, irq_set_affinity_hint() applying the
provided cpumask as an affinity (if not NULL) for the interrupt is an
undocumented side effect.

To remove this side effect irq_set_affinity_hint() has been marked
as deprecated and new interfaces have been introduced. Hence, replace the
irq_set_affinity_hint() with the new interface irq_set_affinity_and_hint()
where the provided mask needs to be applied as the affinity and
affinity_hint pointer needs to be set and replace with
irq_update_affinity_hint() where only affinity_hint needs to be updated.

Signed-off-by: Nitesh Narayan Lal <nitesh@redhat.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Link: https://lore.kernel.org/r/20210903152430.244937-6-nitesh@redhat.com
Stable-dep-of: e0d26fe176a8 ("scsi: mpt3sas: Avoid out-of-bounds cpumask_of_node() call in _base_assign_reply_queues()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 32c8f5728d4cb..80c12b5a468cf 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -3114,6 +3114,7 @@ _base_check_enable_msix(struct MPT3SAS_ADAPTER *ioc)
 void
 mpt3sas_base_free_irq(struct MPT3SAS_ADAPTER *ioc)
 {
+	unsigned int irq;
 	struct adapter_reply_queue *reply_q, *next;
 
 	if (list_empty(&ioc->reply_queue_list))
@@ -3126,9 +3127,10 @@ mpt3sas_base_free_irq(struct MPT3SAS_ADAPTER *ioc)
 			continue;
 		}
 
-		if (ioc->smp_affinity_enable)
-			irq_set_affinity_hint(pci_irq_vector(ioc->pdev,
-			    reply_q->msix_index), NULL);
+		if (ioc->smp_affinity_enable) {
+			irq = pci_irq_vector(ioc->pdev, reply_q->msix_index);
+			irq_update_affinity_hint(irq, NULL);
+		}
 		free_irq(pci_irq_vector(ioc->pdev, reply_q->msix_index),
 			 reply_q);
 		kfree(reply_q);
@@ -3195,18 +3197,15 @@ _base_request_irq(struct MPT3SAS_ADAPTER *ioc, u8 index)
  * @ioc: per adapter object
  *
  * The enduser would need to set the affinity via /proc/irq/#/smp_affinity
- *
- * It would nice if we could call irq_set_affinity, however it is not
- * an exported symbol
  */
 static void
 _base_assign_reply_queues(struct MPT3SAS_ADAPTER *ioc)
 {
-	unsigned int cpu, nr_cpus, nr_msix, index = 0;
+	unsigned int cpu, nr_cpus, nr_msix, index = 0, irq;
 	struct adapter_reply_queue *reply_q;
-	int local_numa_node;
 	int iopoll_q_count = ioc->reply_queue_count -
 	    ioc->iopoll_q_start_index;
+	const struct cpumask *mask;
 
 	if (!_base_is_controller_msix_enabled(ioc))
 		return;
@@ -3229,11 +3228,11 @@ _base_assign_reply_queues(struct MPT3SAS_ADAPTER *ioc)
 		 * corresponding to high iops queues.
 		 */
 		if (ioc->high_iops_queues) {
-			local_numa_node = dev_to_node(&ioc->pdev->dev);
+			mask = cpumask_of_node(dev_to_node(&ioc->pdev->dev));
 			for (index = 0; index < ioc->high_iops_queues;
 			    index++) {
-				irq_set_affinity_hint(pci_irq_vector(ioc->pdev,
-				    index), cpumask_of_node(local_numa_node));
+				irq = pci_irq_vector(ioc->pdev, index);
+				irq_set_affinity_and_hint(irq, mask);
 			}
 		}
 
-- 
2.53.0



