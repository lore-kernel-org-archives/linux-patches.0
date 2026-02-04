Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55D742BE7C0;
	Wed,  4 Feb 2026 15:17:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218258; cv=none; b=QafT8GdqJtY42BhrANTuaHvkhhQOYchJLNqcq9Pt67xxU+poIhrHCDbpzzJ3Y8Dxw2Kk4GQwDc/VnILmtMR0Bc9BateeDpCqGUL6E4wPykkZaUb2fGSrCkfSj/vkE/Ia+98uR3H9ilAR8g2GP5acOGJjz30lxVBc8+3+XI9tKnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218258; c=relaxed/simple;
	bh=pdf5cZZ09vEADgp60qb/htJ5vneH+dlsArCwjMSm6/k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m3/KS1miipXIygKe8X/IzJpaVD5O0hFSDCmkyyxo8Z0cAMLzh+hy2A2mdPnHBm+GDpyH5E4e8PpFMl8+NcSIV6SIGBz0ZMB4y7krgCBiyQGwI3dFnuqp+L/mqAMOp8IKNXJWVWL+16Y/PbADX7d54dHeTeD2BCXrC9klUFaDNvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S4+6io8F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S4+6io8F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD1B4C4CEF7;
	Wed,  4 Feb 2026 15:17:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770218258;
	bh=pdf5cZZ09vEADgp60qb/htJ5vneH+dlsArCwjMSm6/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S4+6io8Fbj60j8RFKSJZS3q+KAT+GuGI2gSITz9kqPM4BzOmd5MEO/PH7W7iv2d2P
	 kq11ha5sskrjKFdSrkS41r2F3ps1JGo7wkIuLs7nHxoddYjnLK1p626Qr2vJCxrDcC
	 FtU3qdBlHHDmM2O7p99xt3ySW5AyEuDgEhEKRHRY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Ahsan Atta <ahsan.atta@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Wenshan Lan <jetlan9@163.com>
Subject: [PATCH 6.1 258/280] crypto: qat - flush misc workqueue during device shutdown
Date: Wed,  4 Feb 2026 15:40:32 +0100
Message-ID: <20260204143918.978934511@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143909.614719725@linuxfoundation.org>
References: <20260204143909.614719725@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>

[ Upstream commit 3d4df408ba9bad2b205c7fb8afc1836a6a4ca88a ]

Repeated loading and unloading of a device specific QAT driver, for
example qat_4xxx, in a tight loop can lead to a crash due to a
use-after-free scenario. This occurs when a power management (PM)
interrupt triggers just before the device-specific driver (e.g.,
qat_4xxx.ko) is unloaded, while the core driver (intel_qat.ko) remains
loaded.

Since the driver uses a shared workqueue (`qat_misc_wq`) across all
devices and owned by intel_qat.ko, a deferred routine from the
device-specific driver may still be pending in the queue. If this
routine executes after the driver is unloaded, it can dereference freed
memory, resulting in a page fault and kernel crash like the following:

    BUG: unable to handle page fault for address: ffa000002e50a01c
    #PF: supervisor read access in kernel mode
    RIP: 0010:pm_bh_handler+0x1d2/0x250 [intel_qat]
    Call Trace:
      pm_bh_handler+0x1d2/0x250 [intel_qat]
      process_one_work+0x171/0x340
      worker_thread+0x277/0x3a0
      kthread+0xf0/0x120
      ret_from_fork+0x2d/0x50

To prevent this, flush the misc workqueue during device shutdown to
ensure that all pending work items are completed before the driver is
unloaded.

Note: This approach may slightly increase shutdown latency if the
workqueue contains jobs from other devices, but it ensures correctness
and stability.

Fixes: e5745f34113b ("crypto: qat - enable power management for QAT GEN4")
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc: stable@vger.kernel.org
Reviewed-by: Ahsan Atta <ahsan.atta@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
[ Intel crypto drivers was moved by
  a4b16dad4657 ("crypto: qat - Move driver to drivers/crypto/intel/qat")
  so apply the patch to files under drivers/crypto/qat/qat_common in
  6.1.y. ]
Signed-off-by: Wenshan Lan <jetlan9@163.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/qat/qat_common/adf_common_drv.h |    1 +
 drivers/crypto/qat/qat_common/adf_init.c       |    1 +
 drivers/crypto/qat/qat_common/adf_isr.c        |    5 +++++
 3 files changed, 7 insertions(+)

--- a/drivers/crypto/qat/qat_common/adf_common_drv.h
+++ b/drivers/crypto/qat/qat_common/adf_common_drv.h
@@ -194,6 +194,7 @@ int qat_uclo_set_cfg_ae_mask(struct icp_
 int adf_init_misc_wq(void);
 void adf_exit_misc_wq(void);
 bool adf_misc_wq_queue_work(struct work_struct *work);
+void adf_misc_wq_flush(void);
 #if defined(CONFIG_PCI_IOV)
 int adf_sriov_configure(struct pci_dev *pdev, int numvfs);
 void adf_disable_sriov(struct adf_accel_dev *accel_dev);
--- a/drivers/crypto/qat/qat_common/adf_init.c
+++ b/drivers/crypto/qat/qat_common/adf_init.c
@@ -337,6 +337,7 @@ void adf_dev_shutdown(struct adf_accel_d
 		hw_data->exit_admin_comms(accel_dev);
 
 	adf_cleanup_etr_data(accel_dev);
+	adf_misc_wq_flush();
 	adf_dev_restore(accel_dev);
 }
 EXPORT_SYMBOL_GPL(adf_dev_shutdown);
--- a/drivers/crypto/qat/qat_common/adf_isr.c
+++ b/drivers/crypto/qat/qat_common/adf_isr.c
@@ -380,3 +380,8 @@ bool adf_misc_wq_queue_work(struct work_
 {
 	return queue_work(adf_misc_wq, work);
 }
+
+void adf_misc_wq_flush(void)
+{
+	flush_workqueue(adf_misc_wq);
+}


