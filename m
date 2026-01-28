Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF12E2F5479;
	Wed, 28 Jan 2026 15:40:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614856; cv=none; b=sbi9qOkR/XYdEZREKArWof8oPmhmCpmzXL6z4q9h7gPok32yFLAIh4WVNYo8qFHBdQOUqrKqDiwYivy3nryXwpGTWX2NVGgkyBx48WWqvowlZLkxWMBYlmSUePvPlIDyyFqygb/2pVPMQFXPlg1qqFsYAgZRG8z+2mDBFAFU5uM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614856; c=relaxed/simple;
	bh=Isd0tM3ZH4npfgHNmaPQaEMKY1G+qFT5nvtaerXxCYI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eEq5OaWmS4czXU9reuE0ToEZriCOp1oCqFrnViqL9Oc2UXEiJ2vI6EEi370vGbENDV9iBmoQ1nu7+FzX4HRBYt3K8U3oUyTzgK1iZuc0tVCIP8mqGZSBFnJc2LE7nuiKj4oTE++wRg1iRdQ5dk6KEuGYdFSChv9H00T9ntCf3C4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=csr/MPQ5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="csr/MPQ5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2244C4CEF1;
	Wed, 28 Jan 2026 15:40:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614856;
	bh=Isd0tM3ZH4npfgHNmaPQaEMKY1G+qFT5nvtaerXxCYI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=csr/MPQ5YVehHPYMNOQK03K468T0KoSw5Iy7KRhrmNSJL+KYt/snfFA7dsodeKXyV
	 jzfQ6sj/zKwFU7JrZKXIOAj7gpJRBgxo76bh/mDWx0FWga3jgKIj/VFYfaCU3e1+PE
	 5EoN1dhsg/R5gGf7wSFGUYyPhwPAn1LmCVyhJtnA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nilay Shroff <nilay@linux.ibm.com>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 243/254] nvme-pci: do not directly handle subsys reset fallout
Date: Wed, 28 Jan 2026 16:23:39 +0100
Message-ID: <20260128145353.540639879@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.698118637@linuxfoundation.org>
References: <20260128145344.698118637@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Keith Busch <kbusch@kernel.org>

[ Upstream commit 210b1f6576e8b367907e7ff51ef425062e1468e4 ]

Scheduling reset_work after a nvme subsystem reset is expected to fail
on pcie, but this also prevents potential handling the platform's pcie
services may provide that might successfully recovering the link without
re-enumeration. Such examples include AER, DPC, and power's EEH.

Provide a pci specific operation that safely initiates a subsystem
reset, and instead of scheduling reset work, read back the status
register to trigger a pcie read error.

Since this only affects pci, the other fabrics drivers subscribe to a
generic nvmf subsystem reset that is exactly the same as before. The
loop fabric doesn't use it because nvmet doesn't support setting that
property anyway.

And since we're using the magic NSSR value in two places now, provide a
symbolic define for it.

Reported-by: Nilay Shroff <nilay@linux.ibm.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Stable-dep-of: 0edb475ac0a7 ("nvme: fix PCIe subsystem reset controller state transition")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/host/fabrics.c |   15 +++++++++++++++
 drivers/nvme/host/fabrics.h |    1 +
 drivers/nvme/host/fc.c      |    1 +
 drivers/nvme/host/nvme.h    |   14 +++-----------
 drivers/nvme/host/pci.c     |   36 ++++++++++++++++++++++++++++++++++++
 drivers/nvme/host/rdma.c    |    1 +
 drivers/nvme/host/tcp.c     |    1 +
 include/linux/nvme.h        |    3 +++
 8 files changed, 61 insertions(+), 11 deletions(-)

--- a/drivers/nvme/host/fabrics.c
+++ b/drivers/nvme/host/fabrics.c
@@ -279,6 +279,21 @@ int nvmf_reg_write32(struct nvme_ctrl *c
 }
 EXPORT_SYMBOL_GPL(nvmf_reg_write32);
 
+int nvmf_subsystem_reset(struct nvme_ctrl *ctrl)
+{
+	int ret;
+
+	if (!nvme_wait_reset(ctrl))
+		return -EBUSY;
+
+	ret = ctrl->ops->reg_write32(ctrl, NVME_REG_NSSR, NVME_SUBSYS_RESET);
+	if (ret)
+		return ret;
+
+	return nvme_try_sched_reset(ctrl);
+}
+EXPORT_SYMBOL_GPL(nvmf_subsystem_reset);
+
 /**
  * nvmf_log_connect_error() - Error-parsing-diagnostic print out function for
  * 				connect() errors.
--- a/drivers/nvme/host/fabrics.h
+++ b/drivers/nvme/host/fabrics.h
@@ -206,6 +206,7 @@ static inline unsigned int nvmf_nr_io_qu
 int nvmf_reg_read32(struct nvme_ctrl *ctrl, u32 off, u32 *val);
 int nvmf_reg_read64(struct nvme_ctrl *ctrl, u32 off, u64 *val);
 int nvmf_reg_write32(struct nvme_ctrl *ctrl, u32 off, u32 val);
+int nvmf_subsystem_reset(struct nvme_ctrl *ctrl);
 int nvmf_connect_admin_queue(struct nvme_ctrl *ctrl);
 int nvmf_connect_io_queue(struct nvme_ctrl *ctrl, u16 qid);
 int nvmf_register_transport(struct nvmf_transport_ops *ops);
--- a/drivers/nvme/host/fc.c
+++ b/drivers/nvme/host/fc.c
@@ -3349,6 +3349,7 @@ static const struct nvme_ctrl_ops nvme_f
 	.reg_read32		= nvmf_reg_read32,
 	.reg_read64		= nvmf_reg_read64,
 	.reg_write32		= nvmf_reg_write32,
+	.subsystem_reset	= nvmf_subsystem_reset,
 	.free_ctrl		= nvme_fc_free_ctrl,
 	.submit_async_event	= nvme_fc_submit_async_event,
 	.delete_ctrl		= nvme_fc_delete_ctrl,
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -562,6 +562,7 @@ struct nvme_ctrl_ops {
 	int (*reg_read64)(struct nvme_ctrl *ctrl, u32 off, u64 *val);
 	void (*free_ctrl)(struct nvme_ctrl *ctrl);
 	void (*submit_async_event)(struct nvme_ctrl *ctrl);
+	int (*subsystem_reset)(struct nvme_ctrl *ctrl);
 	void (*delete_ctrl)(struct nvme_ctrl *ctrl);
 	void (*stop_ctrl)(struct nvme_ctrl *ctrl);
 	int (*get_address)(struct nvme_ctrl *ctrl, char *buf, int size);
@@ -660,18 +661,9 @@ int nvme_try_sched_reset(struct nvme_ctr
 
 static inline int nvme_reset_subsystem(struct nvme_ctrl *ctrl)
 {
-	int ret;
-
-	if (!ctrl->subsystem)
+	if (!ctrl->subsystem || !ctrl->ops->subsystem_reset)
 		return -ENOTTY;
-	if (!nvme_wait_reset(ctrl))
-		return -EBUSY;
-
-	ret = ctrl->ops->reg_write32(ctrl, NVME_REG_NSSR, 0x4E564D65);
-	if (ret)
-		return ret;
-
-	return nvme_try_sched_reset(ctrl);
+	return ctrl->ops->subsystem_reset(ctrl);
 }
 
 /*
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -1143,6 +1143,41 @@ static void nvme_pci_submit_async_event(
 	spin_unlock(&nvmeq->sq_lock);
 }
 
+static int nvme_pci_subsystem_reset(struct nvme_ctrl *ctrl)
+{
+	struct nvme_dev *dev = to_nvme_dev(ctrl);
+	int ret = 0;
+
+	/*
+	 * Taking the shutdown_lock ensures the BAR mapping is not being
+	 * altered by reset_work. Holding this lock before the RESETTING state
+	 * change, if successful, also ensures nvme_remove won't be able to
+	 * proceed to iounmap until we're done.
+	 */
+	mutex_lock(&dev->shutdown_lock);
+	if (!dev->bar_mapped_size) {
+		ret = -ENODEV;
+		goto unlock;
+	}
+
+	if (!nvme_change_ctrl_state(ctrl, NVME_CTRL_RESETTING)) {
+		ret = -EBUSY;
+		goto unlock;
+	}
+
+	writel(NVME_SUBSYS_RESET, dev->bar + NVME_REG_NSSR);
+	nvme_change_ctrl_state(ctrl, NVME_CTRL_LIVE);
+
+	/*
+	 * Read controller status to flush the previous write and trigger a
+	 * pcie read error.
+	 */
+	readl(dev->bar + NVME_REG_CSTS);
+unlock:
+	mutex_unlock(&dev->shutdown_lock);
+	return ret;
+}
+
 static int adapter_delete_queue(struct nvme_dev *dev, u8 opcode, u16 id)
 {
 	struct nvme_command c = { };
@@ -2910,6 +2945,7 @@ static const struct nvme_ctrl_ops nvme_p
 	.reg_read64		= nvme_pci_reg_read64,
 	.free_ctrl		= nvme_pci_free_ctrl,
 	.submit_async_event	= nvme_pci_submit_async_event,
+	.subsystem_reset	= nvme_pci_subsystem_reset,
 	.get_address		= nvme_pci_get_address,
 	.print_device_info	= nvme_pci_print_device_info,
 	.supports_pci_p2pdma	= nvme_pci_supports_pci_p2pdma,
--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@ -2174,6 +2174,7 @@ static const struct nvme_ctrl_ops nvme_r
 	.reg_read32		= nvmf_reg_read32,
 	.reg_read64		= nvmf_reg_read64,
 	.reg_write32		= nvmf_reg_write32,
+	.subsystem_reset	= nvmf_subsystem_reset,
 	.free_ctrl		= nvme_rdma_free_ctrl,
 	.submit_async_event	= nvme_rdma_submit_async_event,
 	.delete_ctrl		= nvme_rdma_delete_ctrl,
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -2561,6 +2561,7 @@ static const struct nvme_ctrl_ops nvme_t
 	.reg_read32		= nvmf_reg_read32,
 	.reg_read64		= nvmf_reg_read64,
 	.reg_write32		= nvmf_reg_write32,
+	.subsystem_reset	= nvmf_subsystem_reset,
 	.free_ctrl		= nvme_tcp_free_ctrl,
 	.submit_async_event	= nvme_tcp_submit_async_event,
 	.delete_ctrl		= nvme_tcp_delete_ctrl,
--- a/include/linux/nvme.h
+++ b/include/linux/nvme.h
@@ -28,6 +28,9 @@
 
 #define NVME_NSID_ALL		0xffffffff
 
+/* Special NSSR value, 'NVMe' */
+#define NVME_SUBSYS_RESET	0x4E564D65
+
 enum nvme_subsys_type {
 	/* Referral to another discovery type target subsystem */
 	NVME_NQN_DISC	= 1,


