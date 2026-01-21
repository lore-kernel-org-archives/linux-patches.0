Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AAC43D5228;
	Wed, 21 Jan 2026 18:35:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769020550; cv=none; b=hRvfssF2q4W1q6IMFG4jvIjuhEMZTmWdPtokl5RkwwMubDAPPM0KdR7Y7vNJHY6nJv4IuyHZruduJc+Cf/ik05+dMKMAixp/1+0dekqmPeGJRUd/zj/b/7tClvD3Yc6G9bxOHVGYlMec0lb1cXz4IZe7EOzmOlcA1WWVXApEVwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769020550; c=relaxed/simple;
	bh=BfiypYAZlj/jeeC4SLBYret3dOMm59qVW3uKM5srzSQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oKhEqCWGHRJfKuNwr1TVeKfnhO6Z3zO/lJAKnCTdZ9UxCFJimzH2rtlt0bUToX8/GOl5yZ3pNVl0e+ppjv7JDZTPypVSUK1GkIkFeBFdH76Vq0XoEdioR6T+G6jnNh1vmrYQjwGiCb4CfLlot2gFeGgI4GaPkdLLu3bNAB3ov5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ce1Xoave; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ce1Xoave"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6834BC4CEF1;
	Wed, 21 Jan 2026 18:35:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769020550;
	bh=BfiypYAZlj/jeeC4SLBYret3dOMm59qVW3uKM5srzSQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ce1XoaveARpNfD5eoMjrEys/RyC3t4OUNS7nqioBBuoFEYjxwbiBaWg1Oa1B11ZlM
	 /R0mQCSrNE0HAuseYguiYydtJ9GPWyLUFOx4wnPjElmrXpS7LK6obQP9kQpepnXEFV
	 1mEK09XDAg4LWNtUPCQQVUgor4qMnyM+c+1y5adA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Lixu <lixu.zhang@intel.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.18 191/198] HID: intel-ish-hid: Use dedicated unbound workqueues to prevent resume blocking
Date: Wed, 21 Jan 2026 19:16:59 +0100
Message-ID: <20260121181425.432039983@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181418.537774329@linuxfoundation.org>
References: <20260121181418.537774329@linuxfoundation.org>
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

From: Zhang Lixu <lixu.zhang@intel.com>

commit 0d30dae38fe01cd1de358c6039a0b1184689fe51 upstream.

During suspend/resume tests with S2IDLE, some ISH functional failures were
observed because of delay in executing ISH resume handler. Here
schedule_work() is used from resume handler to do actual work.
schedule_work() uses system_wq, which is a per CPU work queue. Although
the queuing is not bound to a CPU, but it prefers local CPU of the caller,
unless prohibited.

Users of this work queue are not supposed to queue long running work.
But in practice, there are scenarios where long running work items are
queued on other unbound workqueues, occupying the CPU. As a result, the
ISH resume handler may not get a chance to execute in a timely manner.

In one scenario, one of the ish_resume_handler() executions was delayed
nearly 1 second because another work item on an unbound workqueue occupied
the same CPU. This delay causes ISH functionality failures.

A similar issue was previously observed where the ISH HID driver timed out
while getting the HID descriptor during S4 resume in the recovery kernel,
likely caused by the same workqueue contention problem.

Create dedicated unbound workqueues for all ISH operations to allow work
items to execute on any available CPU, eliminating CPU-specific bottlenecks
and improving resume reliability under varying system loads. Also ISH has
three different components, a bus driver which implements ISH protocols, a
PCI interface layer and HID interface. Use one dedicated work queue for all
of them.

Signed-off-by: Zhang Lixu <lixu.zhang@intel.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/intel-ish-hid/ipc/ipc.c          |   21 ++++++++++++++++++++-
 drivers/hid/intel-ish-hid/ipc/pci-ish.c      |    2 +-
 drivers/hid/intel-ish-hid/ishtp-hid-client.c |    4 ++--
 drivers/hid/intel-ish-hid/ishtp/bus.c        |   18 +++++++++++++++++-
 drivers/hid/intel-ish-hid/ishtp/hbm.c        |    4 ++--
 drivers/hid/intel-ish-hid/ishtp/ishtp-dev.h  |    3 +++
 include/linux/intel-ish-client-if.h          |    2 ++
 7 files changed, 47 insertions(+), 7 deletions(-)

--- a/drivers/hid/intel-ish-hid/ipc/ipc.c
+++ b/drivers/hid/intel-ish-hid/ipc/ipc.c
@@ -628,7 +628,7 @@ static void	recv_ipc(struct ishtp_device
 		if (!ishtp_dev) {
 			ishtp_dev = dev;
 		}
-		schedule_work(&fw_reset_work);
+		queue_work(dev->unbound_wq, &fw_reset_work);
 		break;
 
 	case MNG_RESET_NOTIFY_ACK:
@@ -933,6 +933,21 @@ static const struct ishtp_hw_ops ish_hw_
 	.dma_no_cache_snooping = _dma_no_cache_snooping
 };
 
+static struct workqueue_struct *devm_ishtp_alloc_workqueue(struct device *dev)
+{
+	struct workqueue_struct *wq;
+
+	wq = alloc_workqueue("ishtp_unbound_%d", WQ_UNBOUND, 0, dev->id);
+	if (!wq)
+		return NULL;
+
+	if (devm_add_action_or_reset(dev, (void (*)(void *))destroy_workqueue,
+				     wq))
+		return NULL;
+
+	return wq;
+}
+
 /**
  * ish_dev_init() -Initialize ISH devoce
  * @pdev: PCI device
@@ -953,6 +968,10 @@ struct ishtp_device *ish_dev_init(struct
 	if (!dev)
 		return NULL;
 
+	dev->unbound_wq = devm_ishtp_alloc_workqueue(&pdev->dev);
+	if (!dev->unbound_wq)
+		return NULL;
+
 	dev->devc = &pdev->dev;
 	ishtp_device_init(dev);
 
--- a/drivers/hid/intel-ish-hid/ipc/pci-ish.c
+++ b/drivers/hid/intel-ish-hid/ipc/pci-ish.c
@@ -384,7 +384,7 @@ static int __maybe_unused ish_resume(str
 	ish_resume_device = device;
 	dev->resume_flag = 1;
 
-	schedule_work(&resume_work);
+	queue_work(dev->unbound_wq, &resume_work);
 
 	return 0;
 }
--- a/drivers/hid/intel-ish-hid/ishtp-hid-client.c
+++ b/drivers/hid/intel-ish-hid/ishtp-hid-client.c
@@ -860,7 +860,7 @@ static int hid_ishtp_cl_reset(struct ish
 	hid_ishtp_trace(client_data, "%s hid_ishtp_cl %p\n", __func__,
 			hid_ishtp_cl);
 
-	schedule_work(&client_data->work);
+	queue_work(ishtp_get_workqueue(cl_device), &client_data->work);
 
 	return 0;
 }
@@ -902,7 +902,7 @@ static int hid_ishtp_cl_resume(struct de
 
 	hid_ishtp_trace(client_data, "%s hid_ishtp_cl %p\n", __func__,
 			hid_ishtp_cl);
-	schedule_work(&client_data->resume_work);
+	queue_work(ishtp_get_workqueue(cl_device), &client_data->resume_work);
 	return 0;
 }
 
--- a/drivers/hid/intel-ish-hid/ishtp/bus.c
+++ b/drivers/hid/intel-ish-hid/ishtp/bus.c
@@ -541,7 +541,7 @@ void ishtp_cl_bus_rx_event(struct ishtp_
 		return;
 
 	if (device->event_cb)
-		schedule_work(&device->event_work);
+		queue_work(device->ishtp_dev->unbound_wq, &device->event_work);
 }
 
 /**
@@ -877,6 +877,22 @@ struct device *ishtp_get_pci_device(stru
 EXPORT_SYMBOL(ishtp_get_pci_device);
 
 /**
+ * ishtp_get_workqueue - Retrieve the workqueue associated with an ISHTP device
+ * @cl_device: Pointer to the ISHTP client device structure
+ *
+ * Returns the workqueue_struct pointer (unbound_wq) associated with the given
+ * ISHTP client device. This workqueue is typically used for scheduling work
+ * related to the device.
+ *
+ * Return: Pointer to struct workqueue_struct.
+ */
+struct workqueue_struct *ishtp_get_workqueue(struct ishtp_cl_device *cl_device)
+{
+	return cl_device->ishtp_dev->unbound_wq;
+}
+EXPORT_SYMBOL(ishtp_get_workqueue);
+
+/**
  * ishtp_trace_callback() - Return trace callback
  * @cl_device: ISH-TP client device instance
  *
--- a/drivers/hid/intel-ish-hid/ishtp/hbm.c
+++ b/drivers/hid/intel-ish-hid/ishtp/hbm.c
@@ -573,7 +573,7 @@ void ishtp_hbm_dispatch(struct ishtp_dev
 
 		/* Start firmware loading process if it has loader capability */
 		if (version_res->host_version_supported & ISHTP_SUPPORT_CAP_LOADER)
-			schedule_work(&dev->work_fw_loader);
+			queue_work(dev->unbound_wq, &dev->work_fw_loader);
 
 		dev->version.major_version = HBM_MAJOR_VERSION;
 		dev->version.minor_version = HBM_MINOR_VERSION;
@@ -864,7 +864,7 @@ void	recv_hbm(struct ishtp_device *dev,
 	dev->rd_msg_fifo_tail = (dev->rd_msg_fifo_tail + IPC_PAYLOAD_SIZE) %
 		(RD_INT_FIFO_SIZE * IPC_PAYLOAD_SIZE);
 	spin_unlock_irqrestore(&dev->rd_msg_spinlock, flags);
-	schedule_work(&dev->bh_hbm_work);
+	queue_work(dev->unbound_wq, &dev->bh_hbm_work);
 eoi:
 	return;
 }
--- a/drivers/hid/intel-ish-hid/ishtp/ishtp-dev.h
+++ b/drivers/hid/intel-ish-hid/ishtp/ishtp-dev.h
@@ -175,6 +175,9 @@ struct ishtp_device {
 	struct hbm_version version;
 	int transfer_path; /* Choice of transfer path: IPC or DMA */
 
+	/* Alloc a dedicated unbound workqueue for ishtp device */
+	struct workqueue_struct *unbound_wq;
+
 	/* work structure for scheduling firmware loading tasks */
 	struct work_struct work_fw_loader;
 	/* waitq for waiting for command response from the firmware loader */
--- a/include/linux/intel-ish-client-if.h
+++ b/include/linux/intel-ish-client-if.h
@@ -87,6 +87,8 @@ bool ishtp_wait_resume(struct ishtp_devi
 ishtp_print_log ishtp_trace_callback(struct ishtp_cl_device *cl_device);
 /* Get device pointer of PCI device for DMA acces */
 struct device *ishtp_get_pci_device(struct ishtp_cl_device *cl_device);
+/* Get the ISHTP workqueue */
+struct workqueue_struct *ishtp_get_workqueue(struct ishtp_cl_device *cl_device);
 
 struct ishtp_cl *ishtp_cl_allocate(struct ishtp_cl_device *cl_device);
 void ishtp_cl_free(struct ishtp_cl *cl);


