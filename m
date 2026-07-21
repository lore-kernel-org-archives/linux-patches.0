Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1050246DFFD;
	Tue, 21 Jul 2026 18:33:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658792; cv=none; b=dQnA5T3eeP863BIVZJd//Tgz3rjMoZzyfc+F9gP/Kf+sCZvwZMY9uAVTKR41pvzAGoppro/2bcV81ulhnh3KXzLE2F+ZCwYnAt7z1ULn8rfpZP1qt2I2I0DVlGaFi8S58HDK8N5xCosQQUJpnsEoO5qKI1pv8V7mB9Di1zKpNgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658792; c=relaxed/simple;
	bh=MdSVEUAnZqWD9awaNRpzMoSgc83u3/2mibiHa7LVJ+o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SZOxtMlaA0Rq6BMC8Yh5VpXIMQeuMa1OnzjQmDWD3jjSvUYBg2PwoD4HXXLI55t6IREXvs3lsfzP3n29HnUZiyuGDJfJWF1vEIYzE5TjqMjjx6aUVTR5FMnGJIp65qkfK3RFKdbxivpcNXxvmvuMfGPNcFKKXnD2z0iL38jQI8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n9G4l5w7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n9G4l5w7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7309C1F000E9;
	Tue, 21 Jul 2026 18:33:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658791;
	bh=DB2CPxlEyukQE7J4aNGcXmZhfeNMJ408kkmZi18zsJw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n9G4l5w7AmvLFPBCARpm+dHMWzdlLSvwXFdDCaAY0e5pD32Pz+tJP6fuz9MyzJQgP
	 dmxUxG4eR0eYwik6x0grokdUjkgZNPJb3mVNizSEf0XSsFcSmZembzM9gMS0sUC4Vg
	 dXnkb7h7lO+oDMLB3dt8zOStcAlz/Duc8pxKHzZc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Slark Xiao <slark_xiao@163.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Subject: [PATCH 6.18 1277/1611] bus: mhi: host: pci_generic: Fix the physical function check
Date: Tue, 21 Jul 2026 17:23:13 +0200
Message-ID: <20260721152544.168210057@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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
@@ -1197,7 +1197,7 @@ static void mhi_pci_recovery_work(struct
 
 	dev_warn(&pdev->dev, "device recovery started\n");
 
-	if (pdev->is_physfn)
+	if (!pdev->is_virtfn)
 		timer_delete(&mhi_pdev->health_check_timer);
 
 	pm_runtime_forbid(&pdev->dev);
@@ -1227,7 +1227,7 @@ static void mhi_pci_recovery_work(struct
 
 	set_bit(MHI_PCI_DEV_STARTED, &mhi_pdev->status);
 
-	if (pdev->is_physfn)
+	if (!pdev->is_virtfn)
 		mod_timer(&mhi_pdev->health_check_timer, jiffies + HEALTH_CHECK_PERIOD);
 
 	return;
@@ -1318,7 +1318,7 @@ static int mhi_pci_probe(struct pci_dev
 		mhi_cntrl_config = info->config;
 
 	/* Initialize health check monitor only for Physical functions */
-	if (pdev->is_physfn)
+	if (!pdev->is_virtfn)
 		timer_setup(&mhi_pdev->health_check_timer, health_check, 0);
 
 	mhi_cntrl = &mhi_pdev->mhi_cntrl;
@@ -1340,7 +1340,7 @@ static int mhi_pci_probe(struct pci_dev
 	mhi_cntrl->mru = info->mru_default;
 	mhi_cntrl->name = info->name;
 
-	if (pdev->is_physfn)
+	if (!pdev->is_virtfn)
 		mhi_pdev->reset_on_remove = info->reset_on_remove;
 
 	if (info->edl_trigger)
@@ -1389,7 +1389,7 @@ static int mhi_pci_probe(struct pci_dev
 	set_bit(MHI_PCI_DEV_STARTED, &mhi_pdev->status);
 
 	/* start health check */
-	if (pdev->is_physfn)
+	if (!pdev->is_virtfn)
 		mod_timer(&mhi_pdev->health_check_timer, jiffies + HEALTH_CHECK_PERIOD);
 
 	/* Allow runtime suspend only if both PME from D3Hot and M3 are supported */
@@ -1417,7 +1417,7 @@ static void mhi_pci_remove(struct pci_de
 
 	pci_disable_sriov(pdev);
 
-	if (pdev->is_physfn)
+	if (!pdev->is_virtfn)
 		timer_delete_sync(&mhi_pdev->health_check_timer);
 	cancel_work_sync(&mhi_pdev->recovery_work);
 
@@ -1449,7 +1449,7 @@ static void mhi_pci_reset_prepare(struct
 
 	dev_info(&pdev->dev, "reset\n");
 
-	if (pdev->is_physfn)
+	if (!pdev->is_virtfn)
 		timer_delete(&mhi_pdev->health_check_timer);
 
 	/* Clean up MHI state */
@@ -1495,7 +1495,7 @@ static void mhi_pci_reset_done(struct pc
 	}
 
 	set_bit(MHI_PCI_DEV_STARTED, &mhi_pdev->status);
-	if (pdev->is_physfn)
+	if (!pdev->is_virtfn)
 		mod_timer(&mhi_pdev->health_check_timer, jiffies + HEALTH_CHECK_PERIOD);
 }
 
@@ -1561,7 +1561,7 @@ static int  __maybe_unused mhi_pci_runti
 	if (test_and_set_bit(MHI_PCI_DEV_SUSPENDED, &mhi_pdev->status))
 		return 0;
 
-	if (pdev->is_physfn)
+	if (!pdev->is_virtfn)
 		timer_delete(&mhi_pdev->health_check_timer);
 
 	cancel_work_sync(&mhi_pdev->recovery_work);
@@ -1614,7 +1614,7 @@ static int __maybe_unused mhi_pci_runtim
 	}
 
 	/* Resume health check */
-	if (pdev->is_physfn)
+	if (!pdev->is_virtfn)
 		mod_timer(&mhi_pdev->health_check_timer, jiffies + HEALTH_CHECK_PERIOD);
 
 	/* It can be a remote wakeup (no mhi runtime_get), update access time */


