Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2DCA1CAA8F;
	Tue, 11 Mar 2025 15:33:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741707230; cv=none; b=nT9rNqohbKFUbco4I+LGbKyymiEjTrQkO2IHwwBBzxNw6puKtNy1QsN/pImmufOAvn/DWQMrog+sMmvAgRp+U/9WNduOnGFJ1+2zff161l1oMr7VxkZ8eL1uLYLr8Pwd5LkgEMS+aAGhDnmpQ0zpYsm43ojEcUalaetF6Is2GKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741707230; c=relaxed/simple;
	bh=EUomllhsRYQvC2DZBl7xWsxNLF1y/O/lURcwdRIJLPg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QvViYRLzadvvfN8mJWDURQF+1IgcMawyyCwu5NCrtsUQewtuaTMYiscROv7uPQxy3G1s+hT2fCJei5QQ6Ryn6dhiQwbbEwHvPKOtGHP0PYlZ2oC3+03ifLCbmtgGDvKwFKdrKcG3EN7dTwFX2ZPLV8Wu/+ACphztgJs9WQqApEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eMz8nqMH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eMz8nqMH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B439C4CEE9;
	Tue, 11 Mar 2025 15:33:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741707230;
	bh=EUomllhsRYQvC2DZBl7xWsxNLF1y/O/lURcwdRIJLPg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eMz8nqMHBRGTUjemVUL9NKCwpcZsBm23lME3Cz6ZUpTlcjLzdwBFSVHtFgUiISJSL
	 FdrqfA3l5+N259MwjA3amS2VeniKOtpgk2Phyqc7Dh+8sk666VwUO9NhZ9d8tP/+Tb
	 ecWt/2nd71wp2xc63vQUPxrUEhbhxZ73wbezOyuE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Casey Chen <cachen@purestorage.com>,
	Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Noah Meyerhans <noahm@debian.org>,
	Yuanyuan Zhong <yzhong@purestorage.com>
Subject: [PATCH 5.10 311/462] nvme-pci: fix multiple races in nvme_setup_io_queues
Date: Tue, 11 Mar 2025 15:59:37 +0100
Message-ID: <20250311145810.648754200@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Casey Chen <cachen@purestorage.com>

commit e4b9852a0f4afe40604afb442e3af4452722050a upstream.

Below two paths could overlap each other if we power off a drive quickly
after powering it on. There are multiple races in nvme_setup_io_queues()
because of shutdown_lock missing and improper use of NVMEQ_ENABLED bit.

nvme_reset_work()                                nvme_remove()
  nvme_setup_io_queues()                           nvme_dev_disable()
  ...                                              ...
A1  clear NVMEQ_ENABLED bit for admin queue          lock
    retry:                                       B1  nvme_suspend_io_queues()
A2    pci_free_irq() admin queue                 B2  nvme_suspend_queue() admin queue
A3    pci_free_irq_vectors()                         nvme_pci_disable()
A4    nvme_setup_irqs();                         B3    pci_free_irq_vectors()
      ...                                            unlock
A5    queue_request_irq() for admin queue
      set NVMEQ_ENABLED bit
      ...
      nvme_create_io_queues()
A6      result = queue_request_irq();
        set NVMEQ_ENABLED bit
      ...
      fail to allocate enough IO queues:
A7      nvme_suspend_io_queues()
        goto retry

If B3 runs in between A1 and A2, it will crash if irqaction haven't
been freed by A2. B2 is supposed to free admin queue IRQ but it simply
can't fulfill the job as A1 has cleared NVMEQ_ENABLED bit.

Fix: combine A1 A2 so IRQ get freed as soon as the NVMEQ_ENABLED bit
gets cleared.

After solved #1, A2 could race with B3 if A2 is freeing IRQ while B3
is checking irqaction. A3 also could race with B2 if B2 is freeing
IRQ while A3 is checking irqaction.

Fix: A2 and A3 take lock for mutual exclusion.

A3 could race with B3 since they could run free_msi_irqs() in parallel.

Fix: A3 takes lock for mutual exclusion.

A4 could fail to allocate all needed IRQ vectors if A3 and A4 are
interrupted by B3.

Fix: A4 takes lock for mutual exclusion.

If A5/A6 happened after B2/B1, B3 will crash since irqaction is not NULL.
They are just allocated by A5/A6.

Fix: Lock queue_request_irq() and setting of NVMEQ_ENABLED bit.

A7 could get chance to pci_free_irq() for certain IO queue while B3 is
checking irqaction.

Fix: A7 takes lock.

nvme_dev->online_queues need to be protected by shutdown_lock. Since it
is not atomic, both paths could modify it using its own copy.

Co-developed-by: Yuanyuan Zhong <yzhong@purestorage.com>
Signed-off-by: Casey Chen <cachen@purestorage.com>
Reviewed-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
[noahm@debian.org: backported to 5.10]
Link: https://lore.kernel.org/linux-nvme/20210707211432.29536-1-cachen@purestorage.com/
Signed-off-by: Noah Meyerhans <noahm@debian.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/host/pci.c |   66 ++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 58 insertions(+), 8 deletions(-)

--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -1563,6 +1563,28 @@ static void nvme_init_queue(struct nvme_
 	wmb(); /* ensure the first interrupt sees the initialization */
 }
 
+/*
+ * Try getting shutdown_lock while setting up IO queues.
+ */
+static int nvme_setup_io_queues_trylock(struct nvme_dev *dev)
+{
+	/*
+	 * Give up if the lock is being held by nvme_dev_disable.
+	 */
+	if (!mutex_trylock(&dev->shutdown_lock))
+		return -ENODEV;
+
+	/*
+	 * Controller is in wrong state, fail early.
+	 */
+	if (dev->ctrl.state != NVME_CTRL_CONNECTING) {
+		mutex_unlock(&dev->shutdown_lock);
+		return -ENODEV;
+	}
+
+	return 0;
+}
+
 static int nvme_create_queue(struct nvme_queue *nvmeq, int qid, bool polled)
 {
 	struct nvme_dev *dev = nvmeq->dev;
@@ -1591,8 +1613,11 @@ static int nvme_create_queue(struct nvme
 		goto release_cq;
 
 	nvmeq->cq_vector = vector;
-	nvme_init_queue(nvmeq, qid);
 
+	result = nvme_setup_io_queues_trylock(dev);
+	if (result)
+		return result;
+	nvme_init_queue(nvmeq, qid);
 	if (!polled) {
 		result = queue_request_irq(nvmeq);
 		if (result < 0)
@@ -1600,10 +1625,12 @@ static int nvme_create_queue(struct nvme
 	}
 
 	set_bit(NVMEQ_ENABLED, &nvmeq->flags);
+	mutex_unlock(&dev->shutdown_lock);
 	return result;
 
 release_sq:
 	dev->online_queues--;
+	mutex_unlock(&dev->shutdown_lock);
 	adapter_delete_sq(dev, qid);
 release_cq:
 	adapter_delete_cq(dev, qid);
@@ -2182,7 +2209,18 @@ static int nvme_setup_io_queues(struct n
 	if (nr_io_queues == 0)
 		return 0;
 	
-	clear_bit(NVMEQ_ENABLED, &adminq->flags);
+	/*
+	 * Free IRQ resources as soon as NVMEQ_ENABLED bit transitions
+	 * from set to unset. If there is a window to it is truely freed,
+	 * pci_free_irq_vectors() jumping into this window will crash.
+	 * And take lock to avoid racing with pci_free_irq_vectors() in
+	 * nvme_dev_disable() path.
+	 */
+	result = nvme_setup_io_queues_trylock(dev);
+	if (result)
+		return result;
+	if (test_and_clear_bit(NVMEQ_ENABLED, &adminq->flags))
+		pci_free_irq(pdev, 0, adminq);
 
 	if (dev->cmb_use_sqes) {
 		result = nvme_cmb_qdepth(dev, nr_io_queues,
@@ -2198,14 +2236,17 @@ static int nvme_setup_io_queues(struct n
 		result = nvme_remap_bar(dev, size);
 		if (!result)
 			break;
-		if (!--nr_io_queues)
-			return -ENOMEM;
+		if (!--nr_io_queues) {
+			result = -ENOMEM;
+			goto out_unlock;
+		}
 	} while (1);
 	adminq->q_db = dev->dbs;
 
  retry:
 	/* Deregister the admin queue's interrupt */
-	pci_free_irq(pdev, 0, adminq);
+	if (test_and_clear_bit(NVMEQ_ENABLED, &adminq->flags))
+		pci_free_irq(pdev, 0, adminq);
 
 	/*
 	 * If we enable msix early due to not intx, disable it again before
@@ -2214,8 +2255,10 @@ static int nvme_setup_io_queues(struct n
 	pci_free_irq_vectors(pdev);
 
 	result = nvme_setup_irqs(dev, nr_io_queues);
-	if (result <= 0)
-		return -EIO;
+	if (result <= 0) {
+		result = -EIO;
+		goto out_unlock;
+	}
 
 	dev->num_vecs = result;
 	result = max(result - 1, 1);
@@ -2229,8 +2272,9 @@ static int nvme_setup_io_queues(struct n
 	 */
 	result = queue_request_irq(adminq);
 	if (result)
-		return result;
+		goto out_unlock;
 	set_bit(NVMEQ_ENABLED, &adminq->flags);
+	mutex_unlock(&dev->shutdown_lock);
 
 	result = nvme_create_io_queues(dev);
 	if (result || dev->online_queues < 2)
@@ -2239,6 +2283,9 @@ static int nvme_setup_io_queues(struct n
 	if (dev->online_queues - 1 < dev->max_qid) {
 		nr_io_queues = dev->online_queues - 1;
 		nvme_disable_io_queues(dev);
+		result = nvme_setup_io_queues_trylock(dev);
+		if (result)
+			return result;
 		nvme_suspend_io_queues(dev);
 		goto retry;
 	}
@@ -2247,6 +2294,9 @@ static int nvme_setup_io_queues(struct n
 					dev->io_queues[HCTX_TYPE_READ],
 					dev->io_queues[HCTX_TYPE_POLL]);
 	return 0;
+out_unlock:
+	mutex_unlock(&dev->shutdown_lock);
+	return result;
 }
 
 static void nvme_del_queue_end(struct request *req, blk_status_t error)


