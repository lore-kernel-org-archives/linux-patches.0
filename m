Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC1C7211C;
	Tue, 30 Apr 2024 11:14:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475671; cv=none; b=E1LTRVlYZ7GsbWafpyrSuoX5na+mB6V8mzvYg2nQPHdBkyw8Qw+KID4PyaQL/FAgyIFGn4CX+zp+DYxe/6xgbpPS6S2TA4pHfJeZlJlZeHPfimXioiabVppoL7MTld7GZRHJjOQfmSlZkG3hnjS+mK7K+k1fZcfEMt56yjXpJgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475671; c=relaxed/simple;
	bh=JopcXuHVk5sHneoZ1ww5Za3LtXluvchCx6rsME/oeTc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ju4Nap9PtrAJcUiu1zU6xjFZAbUCIrasYJ9hiAdjwUni7QV8gV9o4nnxKE1F/twq3itWjEXdjDqf2XuioFhmnqZ2gCMkU3hYWyKbqxmA/dlnFtd4tvokR5jgyryKXLW22GBp5yrG8DiGGiDLiBbpKYMwAUPdkPcea6Ys3miR094=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=stoQLNxV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="stoQLNxV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B5B9C2BBFC;
	Tue, 30 Apr 2024 11:14:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475671;
	bh=JopcXuHVk5sHneoZ1ww5Za3LtXluvchCx6rsME/oeTc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=stoQLNxVEaxWFDqSkGB9vvifxWAnZP8ReKSdnn1qlFCUGEvXQ414YUkKhLFx8OSkQ
	 9vDkq5aJLEiBi39VZWtmrIB7HuS6kXaJ52gTsk+lQCLSa0huvSZDjEEYDSaQMQ25jd
	 lqDj2kaN2r88h/nbnwLaGS9qPqQ2sMu+S+nfzPqk=
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
Subject: [PATCH 6.6 169/186] dmaengine: idxd: Convert spinlock to mutex to lock evl workqueue
Date: Tue, 30 Apr 2024 12:40:21 +0200
Message-ID: <20240430103102.937340951@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103058.010791820@linuxfoundation.org>
References: <20240430103058.010791820@linuxfoundation.org>
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
index 4eeec95a66751..ad7b55dd9596d 100644
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
index fa0f880beae64..542d340552dd7 100644
--- a/drivers/dma/idxd/device.c
+++ b/drivers/dma/idxd/device.c
@@ -770,7 +770,7 @@ static int idxd_device_evl_setup(struct idxd_device *idxd)
 		goto err_alloc;
 	}
 
-	spin_lock(&evl->lock);
+	mutex_lock(&evl->lock);
 	evl->log = addr;
 	evl->dma = dma_addr;
 	evl->log_size = size;
@@ -791,7 +791,7 @@ static int idxd_device_evl_setup(struct idxd_device *idxd)
 	gencfg.evl_en = 1;
 	iowrite32(gencfg.bits, idxd->reg_base + IDXD_GENCFG_OFFSET);
 
-	spin_unlock(&evl->lock);
+	mutex_unlock(&evl->lock);
 	return 0;
 
 err_alloc:
@@ -814,7 +814,7 @@ static void idxd_device_evl_free(struct idxd_device *idxd)
 	if (!gencfg.evl_en)
 		return;
 
-	spin_lock(&evl->lock);
+	mutex_lock(&evl->lock);
 	gencfg.evl_en = 0;
 	iowrite32(gencfg.bits, idxd->reg_base + IDXD_GENCFG_OFFSET);
 
@@ -831,7 +831,7 @@ static void idxd_device_evl_free(struct idxd_device *idxd)
 	evl_dma = evl->dma;
 	evl->log = NULL;
 	evl->size = IDXD_EVL_SIZE_MIN;
-	spin_unlock(&evl->lock);
+	mutex_unlock(&evl->lock);
 
 	dma_free_coherent(dev, evl_log_size, evl_log, evl_dma);
 }
diff --git a/drivers/dma/idxd/idxd.h b/drivers/dma/idxd/idxd.h
index 6fc79deb99bfd..df62dd1291189 100644
--- a/drivers/dma/idxd/idxd.h
+++ b/drivers/dma/idxd/idxd.h
@@ -279,7 +279,7 @@ struct idxd_driver_data {
 
 struct idxd_evl {
 	/* Lock to protect event log access. */
-	spinlock_t lock;
+	struct mutex lock;
 	void *log;
 	dma_addr_t dma;
 	/* Total size of event log = number of entries * entry size. */
diff --git a/drivers/dma/idxd/init.c b/drivers/dma/idxd/init.c
index d09a8553ea71d..2e323c9b2068d 100644
--- a/drivers/dma/idxd/init.c
+++ b/drivers/dma/idxd/init.c
@@ -353,7 +353,7 @@ static int idxd_init_evl(struct idxd_device *idxd)
 	if (!evl)
 		return -ENOMEM;
 
-	spin_lock_init(&evl->lock);
+	mutex_init(&evl->lock);
 	evl->size = IDXD_EVL_SIZE_MIN;
 
 	idxd_name = dev_name(idxd_confdev(idxd));
diff --git a/drivers/dma/idxd/irq.c b/drivers/dma/idxd/irq.c
index 0bbc6bdc6145e..b2ca9c1f194c9 100644
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



