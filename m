Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31460338F26;
	Tue, 26 Aug 2025 11:36:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208203; cv=none; b=cCWWiW6XeXrd2mcXBuYsPpsWT/yYyxXpy1ibSk0nhEjPDnWF7EgldJMMN5pE50ffQjo//ynxW8KJleIEzSJXa9TlfrjURv5mn9o9bdJ3u1IFdfyCpVop+VnG+kg7OCkNDEEy9AUc6kzjlidjpDPpEnokgNXSg/hxEuJL8zA/1uo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208203; c=relaxed/simple;
	bh=SKK4QumqQxAV3O1Ecdsow51ch2qZILIiQBZoNmxXBZk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fEEE4opj7pZ9k2G3gDzAMUXTnK9rlNATfV52ari0j+HFYh6tj2uX4Ps2WvhbyoZ6qHs2N1VA/S3cQRPaSv5U15Ymi9eS9QNSryrphR3RV9wWy0dwL6e8tWECxgOVwI/u73ZJokIC0ZLE8N1cWxsxyA09hxvHOyx1Fz6M9dnR3Jw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MCDN+Sf9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MCDN+Sf9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B422BC4CEF1;
	Tue, 26 Aug 2025 11:36:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208203;
	bh=SKK4QumqQxAV3O1Ecdsow51ch2qZILIiQBZoNmxXBZk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MCDN+Sf9axFrSd/+0vGtlXI+uFXePwCHGjysSdAOSrjm9uu/ibXHtYXCiy47d3uxz
	 kQf5EI+h9wlj6Lz4vypgeb8lF3VCfySbF6/g2dSUxqRJI4WbYlC0KIp2ylJVMTFTtK
	 ZlmsLZuwydRtRrYe/cOSs1+LNg/KvLYzjMDRjvqE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Ahsan Atta <ahsan.atta@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.12 021/322] crypto: qat - flush misc workqueue during device shutdown
Date: Tue, 26 Aug 2025 13:07:16 +0200
Message-ID: <20250826110915.796599038@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>

commit 3d4df408ba9bad2b205c7fb8afc1836a6a4ca88a upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/intel/qat/qat_common/adf_common_drv.h |    1 +
 drivers/crypto/intel/qat/qat_common/adf_init.c       |    1 +
 drivers/crypto/intel/qat/qat_common/adf_isr.c        |    5 +++++
 3 files changed, 7 insertions(+)

--- a/drivers/crypto/intel/qat/qat_common/adf_common_drv.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_common_drv.h
@@ -190,6 +190,7 @@ void adf_exit_misc_wq(void);
 bool adf_misc_wq_queue_work(struct work_struct *work);
 bool adf_misc_wq_queue_delayed_work(struct delayed_work *work,
 				    unsigned long delay);
+void adf_misc_wq_flush(void);
 #if defined(CONFIG_PCI_IOV)
 int adf_sriov_configure(struct pci_dev *pdev, int numvfs);
 void adf_disable_sriov(struct adf_accel_dev *accel_dev);
--- a/drivers/crypto/intel/qat/qat_common/adf_init.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_init.c
@@ -404,6 +404,7 @@ static void adf_dev_shutdown(struct adf_
 		hw_data->exit_admin_comms(accel_dev);
 
 	adf_cleanup_etr_data(accel_dev);
+	adf_misc_wq_flush();
 	adf_dev_restore(accel_dev);
 }
 
--- a/drivers/crypto/intel/qat/qat_common/adf_isr.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_isr.c
@@ -407,3 +407,8 @@ bool adf_misc_wq_queue_delayed_work(stru
 {
 	return queue_delayed_work(adf_misc_wq, work, delay);
 }
+
+void adf_misc_wq_flush(void)
+{
+	flush_workqueue(adf_misc_wq);
+}


