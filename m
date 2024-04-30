Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EFB512C490;
	Tue, 30 Apr 2024 10:57:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474622; cv=none; b=YpNH211NrpOUaV0Uds+3sbatuZnRZmmNDt6h2Ha8RJ9z7hiewKKA7fAJMONb8PZLa1td3mbpYcaWDnbB4y4b6xV6mFMlZ3shlnsD/wV/gdd+ykVwxa8ziq2v81hfUFqpcZEh0ZqohM0nTf4HOjfs+LcuK1LUX10+94CdB6E+S7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474622; c=relaxed/simple;
	bh=o3vUvh89CO+3TG7w/r7Y/IN7ud7jxsY5lGhfa0uTWvc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=smvS8yEDASSLdRCINjS9GLQv69l/X9RAdhoahftVU/XJwo5FBKe9iq82RZ+KvuOPlNJkhvRz0j7vDIQiVZgqIAkZveBbvV6jjNx+m0louDZeQewYXpvJ/5g8fefk4WdtFznORpPUCdqCcuTBaPQ9UPW4U6A2XluRekm4W5VOQKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e6Ai+7dp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e6Ai+7dp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9F76C2BBFC;
	Tue, 30 Apr 2024 10:57:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474622;
	bh=o3vUvh89CO+3TG7w/r7Y/IN7ud7jxsY5lGhfa0uTWvc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e6Ai+7dpnc6ifqmg3wuFWSQRCNe+PhvhOt86mxBbk5wWiJMsEz2ik8I+vNW30yE4B
	 DO1eXVrcFdzDNqOhGH4sFbp34to92Xlx8wrXrmQyAkLpyuV6UO4i4Z8P0W++TGfzwn
	 6BIBEkkcZKXHBFp0bebvOXUsAgUCcw9wcfh1JRz0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rex Zhang <rex.zhang@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Fenghua Yu <fenghua.yu@intel.com>,
	Lijun Pan <lijun.pan@intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 211/228] dmaengine: idxd: Convert spinlock to mutex to lock evl workqueue
Date: Tue, 30 Apr 2024 12:39:49 +0200
Message-ID: <20240430103109.894315922@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103103.806426847@linuxfoundation.org>
References: <20240430103103.806426847@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rex Zhang <rex.zhang@intel.com>

[ Upstream commit d5638de827cff0fce77007e426ec0ffdedf68a44 ]

drain_workqueue() cannot be called safely in a spinlocked context due to
possible task rescheduling. In the multi-task scenario, calling
queue_work() while drain_workqueue() will lead to a Call Trace as
pushing a work on a draining workqueue is not permitted in spinlocked
context.
    Call Trace:
    <TASK>
    ? __warn+0x7d/0x140
    ? __queue_work+0x2b2/0x440
    ? report_bug+0x1f8/0x200
    ? handle_bug+0x3c/0x70
    ? exc_invalid_op+0x18/0x70
    ? asm_exc_invalid_op+0x1a/0x20
    ? __queue_work+0x2b2/0x440
    queue_work_on+0x28/0x30
    idxd_misc_thread+0x303/0x5a0 [idxd]
    ? __schedule+0x369/0xb40
    ? __pfx_irq_thread_fn+0x10/0x10
    ? irq_thread+0xbc/0x1b0
    irq_thread_fn+0x21/0x70
    irq_thread+0x102/0x1b0
    ? preempt_count_add+0x74/0xa0
    ? __pfx_irq_thread_dtor+0x10/0x10
    ? __pfx_irq_thread+0x10/0x10
    kthread+0x103/0x140
    ? __pfx_kthread+0x10/0x10
    ret_from_fork+0x31/0x50
    ? __pfx_kthread+0x10/0x10
    ret_from_fork_asm+0x1b/0x30
    </TASK>

The current implementation uses a spinlock to protect event log workqueue
and will lead to the Call Trace due to potential task rescheduling.

To address the locking issue, convert the spinlock to mutex, allowing
the drain_workqueue() to be called in a safe mutex-locked context.

This change ensures proper synchronization when accessing the event log
workqueue, preventing potential Call Trace and improving the overall
robustness of the code.

Fixes: c40bd7d9737b ("dmaengine: idxd: process user page faults for completion record")
Signed-off-by: Rex Zhang <rex.zhang@intel.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Fenghua Yu <fenghua.yu@intel.com>
Reviewed-by: Lijun Pan <lijun.pan@intel.com>
Link: https://lore.kernel.org/r/20240404223949.2885604-1-fenghua.yu@intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/idxd/cdev.c    | 5 ++---
 drivers/dma/idxd/debugfs.c | 4 ++--
 drivers/dma/idxd/device.c  | 8 ++++----
 drivers/dma/idxd/idxd.h    | 2 +-
 drivers/dma/idxd/init.c    | 2 +-
 drivers/dma/idxd/irq.c     | 4 ++--
 6 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/drivers/dma/idxd/cdev.c b/drivers/dma/idxd/cdev.c
index e5a94a93a3cc4..59456f21778b4 100644
--- a/drivers/dma/idxd/cdev.c
+++ b/drivers/dma/idxd/cdev.c
@@ -342,7 +342,7 @@ static void idxd_cdev_evl_drain_pasid(struct idxd_wq *wq, u32 pasid)
 	if (!evl)
 		return;
 
-	spin_lock(&evl->lock);
+	mutex_lock(&evl->lock);
 	status.bits = ioread64(idxd->reg_base + IDXD_EVLSTATUS_OFFSET);
 	t = status.tail;
 	h = status.head;
@@ -354,9 +354,8 @@ static void idxd_cdev_evl_drain_pasid(struct idxd_wq *wq, u32 pasid)
 			set_bit(h, evl->bmap);
 		h = (h + 1) % size;
 	}
-	spin_unlock(&evl->lock);
-
 	drain_workqueue(wq->wq);
+	mutex_unlock(&evl->lock);
 }
 
 static int idxd_cdev_release(struct inode *node, struct file *filep)
diff --git a/drivers/dma/idxd/debugfs.c b/drivers/dma/idxd/debugfs.c
index f3f25ee676f30..ad4245cb301d5 100644
--- a/drivers/dma/idxd/debugfs.c
+++ b/drivers/dma/idxd/debugfs.c
@@ -66,7 +66,7 @@ static int debugfs_evl_show(struct seq_file *s, void *d)
 	if (!evl || !evl->log)
 		return 0;
 
-	spin_lock(&evl->lock);
+	mutex_lock(&evl->lock);
 
 	evl_status.bits = ioread64(idxd->reg_base + IDXD_EVLSTATUS_OFFSET);
 	t = evl_status.tail;
@@ -87,7 +87,7 @@ static int debugfs_evl_show(struct seq_file *s, void *d)
 		dump_event_entry(idxd, s, i, &count, processed);
 	}
 
-	spin_unlock(&evl->lock);
+	mutex_unlock(&evl->lock);
 	return 0;
 }
 
diff --git a/drivers/dma/idxd/device.c b/drivers/dma/idxd/device.c
index ecfdf4a8f1f83..c41ef195eeb9f 100644
--- a/drivers/dma/idxd/device.c
+++ b/drivers/dma/idxd/device.c
@@ -775,7 +775,7 @@ static int idxd_device_evl_setup(struct idxd_device *idxd)
 		goto err_alloc;
 	}
 
-	spin_lock(&evl->lock);
+	mutex_lock(&evl->lock);
 	evl->log = addr;
 	evl->dma = dma_addr;
 	evl->log_size = size;
@@ -796,7 +796,7 @@ static int idxd_device_evl_setup(struct idxd_device *idxd)
 	gencfg.evl_en = 1;
 	iowrite32(gencfg.bits, idxd->reg_base + IDXD_GENCFG_OFFSET);
 
-	spin_unlock(&evl->lock);
+	mutex_unlock(&evl->lock);
 	return 0;
 
 err_alloc:
@@ -819,7 +819,7 @@ static void idxd_device_evl_free(struct idxd_device *idxd)
 	if (!gencfg.evl_en)
 		return;
 
-	spin_lock(&evl->lock);
+	mutex_lock(&evl->lock);
 	gencfg.evl_en = 0;
 	iowrite32(gencfg.bits, idxd->reg_base + IDXD_GENCFG_OFFSET);
 
@@ -836,7 +836,7 @@ static void idxd_device_evl_free(struct idxd_device *idxd)
 	evl_dma = evl->dma;
 	evl->log = NULL;
 	evl->size = IDXD_EVL_SIZE_MIN;
-	spin_unlock(&evl->lock);
+	mutex_unlock(&evl->lock);
 
 	dma_free_coherent(dev, evl_log_size, evl_log, evl_dma);
 }
diff --git a/drivers/dma/idxd/idxd.h b/drivers/dma/idxd/idxd.h
index d0f5db6cf1eda..df91472f0f5b1 100644
--- a/drivers/dma/idxd/idxd.h
+++ b/drivers/dma/idxd/idxd.h
@@ -293,7 +293,7 @@ struct idxd_driver_data {
 
 struct idxd_evl {
 	/* Lock to protect event log access. */
-	spinlock_t lock;
+	struct mutex lock;
 	void *log;
 	dma_addr_t dma;
 	/* Total size of event log = number of entries * entry size. */
diff --git a/drivers/dma/idxd/init.c b/drivers/dma/idxd/init.c
index 4954adc6bb609..264c4e47d7cca 100644
--- a/drivers/dma/idxd/init.c
+++ b/drivers/dma/idxd/init.c
@@ -354,7 +354,7 @@ static int idxd_init_evl(struct idxd_device *idxd)
 	if (!evl)
 		return -ENOMEM;
 
-	spin_lock_init(&evl->lock);
+	mutex_init(&evl->lock);
 	evl->size = IDXD_EVL_SIZE_MIN;
 
 	idxd_name = dev_name(idxd_confdev(idxd));
diff --git a/drivers/dma/idxd/irq.c b/drivers/dma/idxd/irq.c
index 348aa21389a9f..8dc029c865515 100644
--- a/drivers/dma/idxd/irq.c
+++ b/drivers/dma/idxd/irq.c
@@ -363,7 +363,7 @@ static void process_evl_entries(struct idxd_device *idxd)
 	evl_status.bits = 0;
 	evl_status.int_pending = 1;
 
-	spin_lock(&evl->lock);
+	mutex_lock(&evl->lock);
 	/* Clear interrupt pending bit */
 	iowrite32(evl_status.bits_upper32,
 		  idxd->reg_base + IDXD_EVLSTATUS_OFFSET + sizeof(u32));
@@ -380,7 +380,7 @@ static void process_evl_entries(struct idxd_device *idxd)
 
 	evl_status.head = h;
 	iowrite32(evl_status.bits_lower32, idxd->reg_base + IDXD_EVLSTATUS_OFFSET);
-	spin_unlock(&evl->lock);
+	mutex_unlock(&evl->lock);
 }
 
 irqreturn_t idxd_misc_thread(int vec, void *data)
-- 
2.43.0



