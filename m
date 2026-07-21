Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B77F0375AC3;
	Tue, 21 Jul 2026 17:24:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654689; cv=none; b=K57rBwvPxDcm6e4m0kQB2Ch4AUlVyZtlTYqv8kZIyKT3Y6xz3z8ubq50tY9lC+Ml7Q0Q1I2EkfCTX4bRt6izJqmuEUAG260M/JjqS5o0J19mYlte6zb0gsP9QT2YTNKPxM9HywIRympkgNx9th5wePEpb9V/f9IvcN5d1C2LNYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654689; c=relaxed/simple;
	bh=mrKDlcGtcrxy1WUVD7RUIj13r7GZlj/Kb68noxHLvzI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CGOdzd2hr/Lb8fpDz56XuaavkIgd+1PKBR8UU5S30QwvsZMI6qbpdGdZR/K5gKR6wXbZAn8/ojcKkKVCi1Q1mUgLaQjMHyZrlg/y9GzzMulpsQ//QUv4rK38brTz3G1XhmKXUGLflrKM7CKDrJYTn3YpQ9rudbDX54sIBx16oyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T8cmxkdZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T8cmxkdZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A3041F000E9;
	Tue, 21 Jul 2026 17:24:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654688;
	bh=99RQ+P4zoESLSHAsmuJBNqeTxmCxGPMhpyNyLAs9Qw4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T8cmxkdZkb6rh5C0PmaZ+CGqG+K73Y66DDmfV5/K+XbQzFucQaGvZ19IbXFd7gsR8
	 5kCqrksVZoKEDjjzDEu20lNgnRbyK09sQKbJ0OyMkdhfBy/+n35n+s20NEKzlOYofO
	 nYVvHnzXz0TwlGq2Lo2Cve+eX4N50QlpdzP7FouA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Slark Xiao <slark_xiao@163.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Subject: [PATCH 7.1 1757/2077] bus: mhi: host: pci_generic: Fix the physical function check
Date: Tue, 21 Jul 2026 17:23:50 +0200
Message-ID: <20260721152634.186506265@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

From: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>

commit 32845111e8ea6ef5e837b6d25080e69e99bd4561 upstream.

Commit b4d01c5b9a9d ("bus: mhi: host: pci_generic: Read SUBSYSTEM_VENDOR_ID
for VF's to check status") added the check for physical function by
checking for 'pdev->is_physfn. But 'pdev->is_physfn' is only set for the
physical function of a SR-IOV capable device. But for the non-SR-IOV device
this variable will be 0. So this check ended up breaking the health check
functionality for all non-SR-IOV devices.

Fix it by checking for '!pdev->is_virtfn' to make sure that the check is
only skipped for virtual functions.

Cc: stable@vger.kernel.org # 6.18
Reported-by: Slark Xiao <slark_xiao@163.com>
Tested-by: Slark Xiao <slark_xiao@163.com>
Fixes: b4d01c5b9a9d ("bus: mhi: host: pci_generic: Read SUBSYSTEM_VENDOR_ID for VF's to check status")
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bus/mhi/host/pci_generic.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

--- a/drivers/bus/mhi/host/pci_generic.c
+++ b/drivers/bus/mhi/host/pci_generic.c
@@ -1247,7 +1247,7 @@ static void mhi_pci_recovery_work(struct
 
 	dev_warn(&pdev->dev, "device recovery started\n");
 
-	if (pdev->is_physfn)
+	if (!pdev->is_virtfn)
 		timer_delete(&mhi_pdev->health_check_timer);
 
 	pm_runtime_forbid(&pdev->dev);
@@ -1277,7 +1277,7 @@ static void mhi_pci_recovery_work(struct
 
 	set_bit(MHI_PCI_DEV_STARTED, &mhi_pdev->status);
 
-	if (pdev->is_physfn)
+	if (!pdev->is_virtfn)
 		mod_timer(&mhi_pdev->health_check_timer, jiffies + HEALTH_CHECK_PERIOD);
 
 	return;
@@ -1368,7 +1368,7 @@ static int mhi_pci_probe(struct pci_dev
 		mhi_cntrl_config = info->config;
 
 	/* Initialize health check monitor only for Physical functions */
-	if (pdev->is_physfn)
+	if (!pdev->is_virtfn)
 		timer_setup(&mhi_pdev->health_check_timer, health_check, 0);
 
 	mhi_cntrl = &mhi_pdev->mhi_cntrl;
@@ -1390,7 +1390,7 @@ static int mhi_pci_probe(struct pci_dev
 	mhi_cntrl->mru = info->mru_default;
 	mhi_cntrl->name = info->name;
 
-	if (pdev->is_physfn)
+	if (!pdev->is_virtfn)
 		mhi_pdev->reset_on_remove = info->reset_on_remove;
 
 	if (info->edl_trigger)
@@ -1439,7 +1439,7 @@ static int mhi_pci_probe(struct pci_dev
 	set_bit(MHI_PCI_DEV_STARTED, &mhi_pdev->status);
 
 	/* start health check */
-	if (pdev->is_physfn)
+	if (!pdev->is_virtfn)
 		mod_timer(&mhi_pdev->health_check_timer, jiffies + HEALTH_CHECK_PERIOD);
 
 	/* Allow runtime suspend only if both PME from D3Hot and M3 are supported */
@@ -1468,7 +1468,7 @@ static void mhi_pci_remove(struct pci_de
 	pm_runtime_forbid(&pdev->dev);
 	pci_disable_sriov(pdev);
 
-	if (pdev->is_physfn)
+	if (!pdev->is_virtfn)
 		timer_delete_sync(&mhi_pdev->health_check_timer);
 	cancel_work_sync(&mhi_pdev->recovery_work);
 
@@ -1500,7 +1500,7 @@ static void mhi_pci_reset_prepare(struct
 
 	dev_info(&pdev->dev, "reset\n");
 
-	if (pdev->is_physfn)
+	if (!pdev->is_virtfn)
 		timer_delete(&mhi_pdev->health_check_timer);
 
 	/* Clean up MHI state */
@@ -1546,7 +1546,7 @@ static void mhi_pci_reset_done(struct pc
 	}
 
 	set_bit(MHI_PCI_DEV_STARTED, &mhi_pdev->status);
-	if (pdev->is_physfn)
+	if (!pdev->is_virtfn)
 		mod_timer(&mhi_pdev->health_check_timer, jiffies + HEALTH_CHECK_PERIOD);
 }
 
@@ -1612,7 +1612,7 @@ static int  __maybe_unused mhi_pci_runti
 	if (test_and_set_bit(MHI_PCI_DEV_SUSPENDED, &mhi_pdev->status))
 		return 0;
 
-	if (pdev->is_physfn)
+	if (!pdev->is_virtfn)
 		timer_delete(&mhi_pdev->health_check_timer);
 
 	cancel_work_sync(&mhi_pdev->recovery_work);
@@ -1665,7 +1665,7 @@ static int __maybe_unused mhi_pci_runtim
 	}
 
 	/* Resume health check */
-	if (pdev->is_physfn)
+	if (!pdev->is_virtfn)
 		mod_timer(&mhi_pdev->health_check_timer, jiffies + HEALTH_CHECK_PERIOD);
 
 	/* It can be a remote wakeup (no mhi runtime_get), update access time */


