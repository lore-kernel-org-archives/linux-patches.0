Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9608E27A91D;
	Thu, 16 Jul 2026 13:45:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209514; cv=none; b=lMYraxvHd3n476x9Bh25hpstbH49X8NT/7S1UyBCHK89C+McjuXI6tX8Nt9rsco7V3CP3TZCxjRvO8vf2nYdRulZLU4J8xynOXwFB57L4LTfUjUqMkGAcxdMiVPXn9CjKO6AnnF9YM0NHzaL8VYU57bMnL38glizWHHA2EdA+lQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209514; c=relaxed/simple;
	bh=TnqpMvzhU/N4oBGWIWnNqhOUdzSlEHK/QFDI4TLnOyA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gigw0DO1jA+fXomIgBmFWpa7AwTeE3S3Du2re4GVOHefk0nqfP9s2E739KnsB3qxJxvb+NBrglsBblSKQMSAkm18RFiaugl9hKUmLaqqQHMhsZDYYtsamXKl7jhWWW4ckNdmJc6MJ2Q4mxNAQboyGuMutukxVV/8IpPAmQAtXIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Av4Vh73z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Av4Vh73z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C443C1F000E9;
	Thu, 16 Jul 2026 13:45:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209513;
	bh=zPMEHrDJpZUUq2//ZwuWVBGofLjYemDIFy9uJej8Gi8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Av4Vh73z5b8RiUpzPAn7nPzI+cRKzfuT2qHe7t2pAhlERGn3yg+h6RPEOyZdjiUdN
	 RxDtLKZ5vJ1D+OVj1DetoPWVUqHFOU+62ecv0I3DxYJDrwKXiBfeRRWAGoTF9ThfLx
	 QAUReORQHw0r4XT+Ihn8r6vSaaCa5kzXWMBaCxlw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Ahsan Atta <ahsan.atta@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 7.1 170/518] crypto: qat - fix VF2PF work teardown race in adf_disable_sriov()
Date: Thu, 16 Jul 2026 15:27:18 +0200
Message-ID: <20260716133051.559792339@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>

commit 277281c10c63791067d24d421f7c43a15faa9096 upstream.

The VF2PF interrupt handler queues PF-side response work that stores a
raw pointer to per-VF state (struct adf_accel_vf_info). Currently,
adf_disable_sriov() destroys per-VF mutexes and frees vf_info without
stopping new VF2PF work or waiting for in-flight workers to complete. A
concurrently scheduled or already queued worker can then dereference
freed memory.

This manifests as a use-after-free when KASAN is enabled:

  BUG: KASAN: null-ptr-deref in mutex_lock+0x76/0xe0
  Write of size 8 at addr 0000000000000260 by task kworker/24:2/...
  Workqueue: qat_pf2vf_resp_wq adf_iov_send_resp [intel_qat]
  Call Trace:
    kasan_report+0x119/0x140
    mutex_lock+0x76/0xe0
    adf_gen4_pfvf_send+0xd4/0x1f0 [intel_qat]
    adf_recv_and_handle_vf2pf_msg+0x290/0x360 [intel_qat]
    adf_iov_send_resp+0x8c/0xe0 [intel_qat]
    process_one_work+0x6ac/0xfd0
    worker_thread+0x4dd/0xd30
    kthread+0x326/0x410
    ret_from_fork+0x33b/0x670

Add a PF-local flag, vf2pf_disabled, that gates work queueing, worker
processing, and interrupt re-enabling during teardown. Set this flag
atomically with the hardware interrupt mask inside
adf_disable_all_vf2pf_interrupts(). After masking, synchronize the AE
cluster MSI-X interrupt and flush the PF response workqueue before
tearing down per-VF locks and state so all in-flight work completes
before vf_info is destroyed.

Introduce adf_enable_all_vf2pf_interrupts() to clear the flag and
unmask all VF2PF interrupts under the same lock when SR-IOV is
re-enabled. This ensures the software flag and hardware state transition
atomically on both the enable and disable paths.

Cc: stable@vger.kernel.org
Fixes: ed8ccaef52fa ("crypto: qat - Add support for SRIOV")
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Ahsan Atta <ahsan.atta@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/intel/qat/qat_common/adf_accel_devices.h |    2 
 drivers/crypto/intel/qat/qat_common/adf_common_drv.h    |    2 
 drivers/crypto/intel/qat/qat_common/adf_isr.c           |   39 ++++++++++++++++
 drivers/crypto/intel/qat/qat_common/adf_sriov.c         |   20 +++++++-
 4 files changed, 61 insertions(+), 2 deletions(-)

--- a/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h
@@ -475,6 +475,8 @@ struct adf_accel_dev {
 		struct {
 			/* protects VF2PF interrupts access */
 			spinlock_t vf2pf_ints_lock;
+			/* prevents VF2PF handling from racing with VF state teardown */
+			bool vf2pf_disabled;
 			/* vf_info is non-zero when SR-IOV is init'ed */
 			struct adf_accel_vf_info *vf_info;
 		} pf;
--- a/drivers/crypto/intel/qat/qat_common/adf_common_drv.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_common_drv.h
@@ -118,6 +118,7 @@ void qat_comp_alg_callback(void *resp);
 
 int adf_isr_resource_alloc(struct adf_accel_dev *accel_dev);
 void adf_isr_resource_free(struct adf_accel_dev *accel_dev);
+void adf_isr_sync_ae_cluster(struct adf_accel_dev *accel_dev);
 int adf_vf_isr_resource_alloc(struct adf_accel_dev *accel_dev);
 void adf_vf_isr_resource_free(struct adf_accel_dev *accel_dev);
 
@@ -191,6 +192,7 @@ int adf_sriov_configure(struct pci_dev *
 void adf_disable_sriov(struct adf_accel_dev *accel_dev);
 void adf_reenable_sriov(struct adf_accel_dev *accel_dev);
 void adf_enable_vf2pf_interrupts(struct adf_accel_dev *accel_dev, u32 vf_mask);
+void adf_enable_all_vf2pf_interrupts(struct adf_accel_dev *accel_dev, u32 num_vfs);
 void adf_disable_all_vf2pf_interrupts(struct adf_accel_dev *accel_dev);
 bool adf_recv_and_handle_pf2vf_msg(struct adf_accel_dev *accel_dev);
 bool adf_recv_and_handle_vf2pf_msg(struct adf_accel_dev *accel_dev, u32 vf_nr);
--- a/drivers/crypto/intel/qat/qat_common/adf_isr.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_isr.c
@@ -62,6 +62,23 @@ void adf_enable_vf2pf_interrupts(struct
 	unsigned long flags;
 
 	spin_lock_irqsave(&accel_dev->pf.vf2pf_ints_lock, flags);
+	if (!READ_ONCE(accel_dev->pf.vf2pf_disabled))
+		GET_PFVF_OPS(accel_dev)->enable_vf2pf_interrupts(pmisc_addr, vf_mask);
+	spin_unlock_irqrestore(&accel_dev->pf.vf2pf_ints_lock, flags);
+}
+
+void adf_enable_all_vf2pf_interrupts(struct adf_accel_dev *accel_dev, u32 num_vfs)
+{
+	void __iomem *pmisc_addr = adf_get_pmisc_base(accel_dev);
+	unsigned long flags;
+	u32 vf_mask;
+
+	vf_mask = BIT_ULL(num_vfs) - 1;
+	if (!vf_mask)
+		return;
+
+	spin_lock_irqsave(&accel_dev->pf.vf2pf_ints_lock, flags);
+	WRITE_ONCE(accel_dev->pf.vf2pf_disabled, false);
 	GET_PFVF_OPS(accel_dev)->enable_vf2pf_interrupts(pmisc_addr, vf_mask);
 	spin_unlock_irqrestore(&accel_dev->pf.vf2pf_ints_lock, flags);
 }
@@ -72,6 +89,7 @@ void adf_disable_all_vf2pf_interrupts(st
 	unsigned long flags;
 
 	spin_lock_irqsave(&accel_dev->pf.vf2pf_ints_lock, flags);
+	WRITE_ONCE(accel_dev->pf.vf2pf_disabled, true);
 	GET_PFVF_OPS(accel_dev)->disable_all_vf2pf_interrupts(pmisc_addr);
 	spin_unlock_irqrestore(&accel_dev->pf.vf2pf_ints_lock, flags);
 }
@@ -174,6 +192,27 @@ static irqreturn_t adf_msix_isr_ae(int i
 	return IRQ_NONE;
 }
 
+void adf_isr_sync_ae_cluster(struct adf_accel_dev *accel_dev)
+{
+	struct adf_accel_pci *pci_dev_info = &accel_dev->accel_pci_dev;
+	struct adf_hw_device_data *hw_data = GET_HW_DATA(accel_dev);
+	u32 num_entries = pci_dev_info->msix_entries.num_entries;
+	struct adf_irq *irqs = pci_dev_info->msix_entries.irqs;
+	u32 irq_idx;
+	int irq;
+
+	if (!test_bit(ADF_STATUS_IRQ_ALLOCATED, &accel_dev->status) || !irqs)
+		return;
+
+	irq_idx = num_entries > 1 ? hw_data->num_banks : 0;
+	if (irq_idx >= num_entries || !irqs[irq_idx].enabled)
+		return;
+
+	irq = pci_irq_vector(pci_dev_info->pci_dev, hw_data->num_banks);
+	if (irq > 0)
+		synchronize_irq(irq);
+}
+
 static void adf_free_irqs(struct adf_accel_dev *accel_dev)
 {
 	struct adf_accel_pci *pci_dev_info = &accel_dev->accel_pci_dev;
--- a/drivers/crypto/intel/qat/qat_common/adf_sriov.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_sriov.c
@@ -26,6 +26,9 @@ static void adf_iov_send_resp(struct wor
 	u32 vf_nr = vf_info->vf_nr;
 	bool ret;
 
+	if (READ_ONCE(accel_dev->pf.vf2pf_disabled))
+		goto out;
+
 	mutex_lock(&vf_info->pfvf_mig_lock);
 	ret = adf_recv_and_handle_vf2pf_msg(accel_dev, vf_nr);
 	if (ret)
@@ -33,13 +36,18 @@ static void adf_iov_send_resp(struct wor
 		adf_enable_vf2pf_interrupts(accel_dev, 1 << vf_nr);
 	mutex_unlock(&vf_info->pfvf_mig_lock);
 
+out:
 	kfree(pf2vf_resp);
 }
 
 void adf_schedule_vf2pf_handler(struct adf_accel_vf_info *vf_info)
 {
+	struct adf_accel_dev *accel_dev = vf_info->accel_dev;
 	struct adf_pf2vf_resp *pf2vf_resp;
 
+	if (READ_ONCE(accel_dev->pf.vf2pf_disabled))
+		return;
+
 	pf2vf_resp = kzalloc_obj(*pf2vf_resp, GFP_ATOMIC);
 	if (!pf2vf_resp)
 		return;
@@ -49,6 +57,12 @@ void adf_schedule_vf2pf_handler(struct a
 	queue_work(pf2vf_resp_wq, &pf2vf_resp->pf2vf_resp_work);
 }
 
+static void adf_flush_pf2vf_resp_wq(void)
+{
+	if (pf2vf_resp_wq)
+		flush_workqueue(pf2vf_resp_wq);
+}
+
 static int adf_enable_sriov(struct adf_accel_dev *accel_dev)
 {
 	struct pci_dev *pdev = accel_to_pci_dev(accel_dev);
@@ -75,7 +89,7 @@ static int adf_enable_sriov(struct adf_a
 		hw_data->configure_iov_threads(accel_dev, true);
 
 	/* Enable VF to PF interrupts for all VFs */
-	adf_enable_vf2pf_interrupts(accel_dev, BIT_ULL(totalvfs) - 1);
+	adf_enable_all_vf2pf_interrupts(accel_dev, totalvfs);
 
 	/*
 	 * Due to the hardware design, when SR-IOV and the ring arbiter
@@ -248,8 +262,10 @@ void adf_disable_sriov(struct adf_accel_
 	adf_pf2vf_wait_for_restarting_complete(accel_dev);
 	pci_disable_sriov(accel_to_pci_dev(accel_dev));
 
-	/* Disable VF to PF interrupts */
+	/* Block VF2PF work and disable VF to PF interrupts */
 	adf_disable_all_vf2pf_interrupts(accel_dev);
+	adf_isr_sync_ae_cluster(accel_dev);
+	adf_flush_pf2vf_resp_wq();
 
 	/* Clear Valid bits in AE Thread to PCIe Function Mapping */
 	if (hw_data->configure_iov_threads)


