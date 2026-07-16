Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79F473D522F;
	Thu, 16 Jul 2026 13:52:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209977; cv=none; b=S8LFg6GIphVxRArBW+Nd8/A3/Qagv6PAtLEb+d8zhtuxtXvURhg2B/j23nl+Unwtj/ZI7krs8DUDdlSW2elfWW3YHtmF1mXSL/gdisGy1oswC/QwDNOdbhe4sd0t5nFQ8Ncs/q//uyCH0y7FEgcsWMcroe6iQXfQKqhsaVlMWc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209977; c=relaxed/simple;
	bh=IUcbuEWWlHx+i11ADwRKCeDvIooyuO3B0fnooR67Ns0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KKQgPwRWp7OmYW4v5d09wcXmRvI1BVXTANO42+/XKpbhYpkcdfNWKaApcIHZeSuOHcKmvffUG6vN+cVhM2mHZiePALtlg11hU2A4afAl33P1Ig8xcX8BnQcOFSR+XROW+jLAt/67QGDrR2re8CY4ww8XaCANDC1B3i3q6p8L28Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W9Nu3fL2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W9Nu3fL2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 537871F000E9;
	Thu, 16 Jul 2026 13:52:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209972;
	bh=a6RHXctmwhsJff6TUt4UicW34bZxtyG2vkn23NMOMYY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W9Nu3fL2vdXM+bj91j3dvTqJUt8sdMtaxwxCU84R8BT5yPPi7JFP84Xe41bTkZZf+
	 GvNIxgo10W6/iTrIgV95QMZiSKJRfznSR82i+q9XJojmHoXCrl6h7JTtMoaYPzPeas
	 T0FxT6Y0RGM7xU4/PJeLhsjNycp5LJVTkxi2LrA0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ahsan Atta <ahsan.atta@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Damian Muszynski <damian.muszynski@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 7.1 388/518] crypto: qat - factor out AER reset helpers
Date: Thu, 16 Jul 2026 15:30:56 +0200
Message-ID: <20260716133056.321184536@linuxfoundation.org>
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

From: Ahsan Atta <ahsan.atta@intel.com>

commit 56707afb92fee371c0f2e04332c9aa03cdb89793 upstream.

Move the shutdown and recovery sequences out of adf_error_detected()
and adf_slot_reset() into reset_prepare() and reset_done() helpers.

This makes the AER recovery path easier to follow and prepares the
common reset flow for reuse by additional PCI reset callbacks without
duplicating the logic.

No functional change intended.

Cc: stable@vger.kernel.org
Signed-off-by: Ahsan Atta <ahsan.atta@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Damian Muszynski <damian.muszynski@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/intel/qat/qat_common/adf_aer.c |   86 ++++++++++++++++----------
 1 file changed, 53 insertions(+), 33 deletions(-)

--- a/drivers/crypto/intel/qat/qat_common/adf_aer.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_aer.c
@@ -17,27 +17,18 @@ struct adf_fatal_error_data {
 static struct workqueue_struct *device_reset_wq;
 static struct workqueue_struct *device_sriov_wq;
 
-static pci_ers_result_t adf_error_detected(struct pci_dev *pdev,
-					   pci_channel_state_t state)
+static pci_ers_result_t reset_prepare(struct pci_dev *pdev)
 {
 	struct adf_accel_dev *accel_dev = adf_devmgr_pci_to_accel_dev(pdev);
 
-	dev_info(&pdev->dev, "Acceleration driver hardware error detected.\n");
 	if (!accel_dev) {
 		dev_err(&pdev->dev, "Can't find acceleration device\n");
 		return PCI_ERS_RESULT_DISCONNECT;
 	}
 
-	if (state == pci_channel_io_perm_failure) {
-		dev_err(&pdev->dev, "Can't recover from device error\n");
-		return PCI_ERS_RESULT_DISCONNECT;
-	}
-
 	if (!adf_dev_started(accel_dev))
 		return PCI_ERS_RESULT_CAN_RECOVER;
 
-	adf_error_notifier(accel_dev);
-	adf_pf2vf_notify_fatal_error(accel_dev);
 	set_bit(ADF_STATUS_RESTARTING, &accel_dev->status);
 	if (accel_dev->hw_device->exit_arb) {
 		dev_dbg(&pdev->dev, "Disabling arbitration\n");
@@ -49,6 +40,57 @@ static pci_ers_result_t adf_error_detect
 	return PCI_ERS_RESULT_NEED_RESET;
 }
 
+static pci_ers_result_t reset_done(struct pci_dev *pdev)
+{
+	struct adf_accel_dev *accel_dev = adf_devmgr_pci_to_accel_dev(pdev);
+	int res;
+
+	if (!accel_dev) {
+		dev_err(&pdev->dev, "Can't find acceleration device\n");
+		return PCI_ERS_RESULT_DISCONNECT;
+	}
+
+	if (!adf_devmgr_in_reset(accel_dev))
+		goto reset_complete;
+
+	pci_restore_state(pdev);
+	res = adf_dev_up(accel_dev, false);
+	if (res && res != -EALREADY)
+		return PCI_ERS_RESULT_DISCONNECT;
+
+	adf_reenable_sriov(accel_dev);
+	adf_pf2vf_notify_restarted(accel_dev);
+	adf_dev_restarted_notify(accel_dev);
+	clear_bit(ADF_STATUS_RESTARTING, &accel_dev->status);
+
+reset_complete:
+	dev_info(&pdev->dev, "Device reset completed successfully\n");
+
+	return PCI_ERS_RESULT_RECOVERED;
+}
+
+static pci_ers_result_t adf_error_detected(struct pci_dev *pdev,
+					   pci_channel_state_t state)
+{
+	struct adf_accel_dev *accel_dev = adf_devmgr_pci_to_accel_dev(pdev);
+
+	dev_info(&pdev->dev, "Acceleration driver hardware error detected.\n");
+	if (!accel_dev) {
+		dev_err(&pdev->dev, "Can't find acceleration device\n");
+		return PCI_ERS_RESULT_DISCONNECT;
+	}
+
+	if (state == pci_channel_io_perm_failure) {
+		dev_err(&pdev->dev, "Can't recover from device error\n");
+		return PCI_ERS_RESULT_DISCONNECT;
+	}
+
+	adf_error_notifier(accel_dev);
+	adf_pf2vf_notify_fatal_error(accel_dev);
+
+	return reset_prepare(pdev);
+}
+
 /* reset dev data */
 struct adf_reset_dev_data {
 	int mode;
@@ -200,29 +242,7 @@ static int adf_dev_aer_schedule_reset(st
 
 static pci_ers_result_t adf_slot_reset(struct pci_dev *pdev)
 {
-	struct adf_accel_dev *accel_dev = adf_devmgr_pci_to_accel_dev(pdev);
-	int res = 0;
-
-	if (!accel_dev) {
-		pr_err("QAT: Can't find acceleration device\n");
-		return PCI_ERS_RESULT_DISCONNECT;
-	}
-
-	if (!adf_devmgr_in_reset(accel_dev))
-		goto reset_complete;
-
-	pci_restore_state(pdev);
-	res = adf_dev_up(accel_dev, false);
-	if (res && res != -EALREADY)
-		return PCI_ERS_RESULT_DISCONNECT;
-
-	adf_reenable_sriov(accel_dev);
-	adf_pf2vf_notify_restarted(accel_dev);
-	adf_dev_restarted_notify(accel_dev);
-	clear_bit(ADF_STATUS_RESTARTING, &accel_dev->status);
-
-reset_complete:
-	return PCI_ERS_RESULT_RECOVERED;
+	return reset_done(pdev);
 }
 
 static void adf_resume(struct pci_dev *pdev)


