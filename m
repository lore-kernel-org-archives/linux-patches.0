Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7741A413D69;
	Thu, 16 Jul 2026 14:15:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211305; cv=none; b=TCPSlGBbJ2ngwIDSTjxLiTDkjnnXfkaXQub3K/FiUqgZ5oL+JXNgpFmCj40moW93faI6lqz+AxLiDSF8JlIMZWG00WgAvfOWjO/BrQNXiq0Yh86K1xx2qwtb3Fxe+S0odzwQhLgzpHDrr50hHK6bPVPNLsLVe2Br9BCvXUG/uus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211305; c=relaxed/simple;
	bh=OMsUxEdn3R+mjV84yEHyr7aVTgIRgLnG5KdOWaADwPA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ioyfuYCWqn0FXiKHdq4nNrlU2g8zcujhHzifRhylZFtBpP9im3NUUh7cDBm515suYe8C+cilZ9i+M7QxqrasZ+Y95qcBWy21tWI+amyKaWLdfamlG9h95D2+pwJLQHIA5hfTTekq4T9IYZZ4wmyh0OzVgDOxr3nloLuuwUXg6Zc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g8BkhLxy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g8BkhLxy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC90D1F000E9;
	Thu, 16 Jul 2026 14:15:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211304;
	bh=2keNvvzMn4wdZDyorZy8sP7yWSzvL/Ma4W7kTRwHruk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g8BkhLxyRLhAHMrGkHHcV3YCSiO5j3eY4Wg2JZvQHR3D4zTsLordQWZyNEXDMYdfQ
	 tbA33lW95Up+QV0PFWLyI26V6m4iLmy/8ZNw4QnexTbaKyIgxmYE+IGNy97NDi+ciy
	 cRoL2QWnZ0k5lgCyqx3JYvnvW0+rSwnQmsK7Sdko=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ahsan Atta <ahsan.atta@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Damian Muszynski <damian.muszynski@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.18 370/480] crypto: qat - factor out AER reset helpers
Date: Thu, 16 Jul 2026 15:31:57 +0200
Message-ID: <20260716133052.811297255@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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
@@ -199,29 +241,7 @@ static int adf_dev_aer_schedule_reset(st
 
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


