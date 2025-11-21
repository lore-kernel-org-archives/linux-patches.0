Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6A16346FB8;
	Fri, 21 Nov 2025 13:41:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732490; cv=none; b=ohw41zKndqWn28NoVyO0aaIxbbW1dCfuAHAj7uVcOWrrDlFQVhZVTV16rLmZ0kSazgnK/LXprh4eRgsea2Cby5vQu16vrdniSVMsjl6FIEep0BKdWsk4QxylGWZRUqRYmM68cZnyTjuG3BlHtecmvfv20G2EU6Eyi3mEH1fwbjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732490; c=relaxed/simple;
	bh=R+g9c4aKCmwKAjCcIkLq9R7DRv5Tdqr+nauZvcT45S8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZJOFCDTdstPTuLM2o0V/ZajX8RuB5jZruVoU5N0wjH2nd7pcwliPDBFR2a2R4HfapAsPo0ybcKuOTA3JLWXJzDTWEvlwnRq16HR8I2jCq/0rrDS6tUtHJb5DsRqVGOZIe8B45hEB9DBiGwiOWOzXRwqfqYMgS9l2Xs9wZAi/FRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z+gijSr7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z+gijSr7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3824CC4CEF1;
	Fri, 21 Nov 2025 13:41:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732490;
	bh=R+g9c4aKCmwKAjCcIkLq9R7DRv5Tdqr+nauZvcT45S8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z+gijSr7M4MWKujzR9TIfm+rjYZFk8qfDHARh3pElsGlOu/+IylmxdKrxuHBgxTo+
	 ykgWSNk4c/UUlI9Bj81nubH1M2IkFmZfmNroMZxczP3tV3ikhtbyqOEJ7ihVAOAXbX
	 tqrR6sEfci8wXcDTXMN2p+s/1pbCG3S41v9qbi8M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Lukas Wunner <lukas@wunner.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 140/529] s390/pci: Use pci_uevent_ers() in PCI recovery
Date: Fri, 21 Nov 2025 14:07:19 +0100
Message-ID: <20251121130235.998445028@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

From: Niklas Schnelle <schnelle@linux.ibm.com>

[ Upstream commit dab32f2576a39d5f54f3dbbbc718d92fa5109ce9 ]

Issue uevents on s390 during PCI recovery using pci_uevent_ers() as done by
EEH and AER PCIe recovery routines.

Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Lukas Wunner <lukas@wunner.de>
Link: https://patch.msgid.link/20250807-add_err_uevents-v5-2-adf85b0620b0@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/pci/pci_event.c | 3 +++
 drivers/pci/pci-driver.c  | 2 +-
 include/linux/pci.h       | 2 +-
 3 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/s390/pci/pci_event.c b/arch/s390/pci/pci_event.c
index e60a66dd8c400..bd4172db26345 100644
--- a/arch/s390/pci/pci_event.c
+++ b/arch/s390/pci/pci_event.c
@@ -83,6 +83,7 @@ static pci_ers_result_t zpci_event_notify_error_detected(struct pci_dev *pdev,
 	pci_ers_result_t ers_res = PCI_ERS_RESULT_DISCONNECT;
 
 	ers_res = driver->err_handler->error_detected(pdev,  pdev->error_state);
+	pci_uevent_ers(pdev, ers_res);
 	if (ers_result_indicates_abort(ers_res))
 		pr_info("%s: Automatic recovery failed after initial reporting\n", pci_name(pdev));
 	else if (ers_res == PCI_ERS_RESULT_NEED_RESET)
@@ -212,6 +213,7 @@ static pci_ers_result_t zpci_event_attempt_error_recovery(struct pci_dev *pdev)
 		ers_res = zpci_event_do_reset(pdev, driver);
 
 	if (ers_res != PCI_ERS_RESULT_RECOVERED) {
+		pci_uevent_ers(pdev, PCI_ERS_RESULT_DISCONNECT);
 		pr_err("%s: Automatic recovery failed; operator intervention is required\n",
 		       pci_name(pdev));
 		goto out_unlock;
@@ -220,6 +222,7 @@ static pci_ers_result_t zpci_event_attempt_error_recovery(struct pci_dev *pdev)
 	pr_info("%s: The device is ready to resume operations\n", pci_name(pdev));
 	if (driver->err_handler->resume)
 		driver->err_handler->resume(pdev);
+	pci_uevent_ers(pdev, PCI_ERS_RESULT_RECOVERED);
 out_unlock:
 	device_unlock(&pdev->dev);
 
diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index 1705d2d0ed126..11a90b55c1873 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -1598,7 +1598,7 @@ static int pci_uevent(const struct device *dev, struct kobj_uevent_env *env)
 	return 0;
 }
 
-#if defined(CONFIG_PCIEAER) || defined(CONFIG_EEH)
+#if defined(CONFIG_PCIEAER) || defined(CONFIG_EEH) || defined(CONFIG_S390)
 /**
  * pci_uevent_ers - emit a uevent during recovery path of PCI device
  * @pdev: PCI device undergoing error recovery
diff --git a/include/linux/pci.h b/include/linux/pci.h
index e4338237a0545..052d956d3ba1f 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -2667,7 +2667,7 @@ static inline bool pci_is_thunderbolt_attached(struct pci_dev *pdev)
 	return false;
 }
 
-#if defined(CONFIG_PCIEPORTBUS) || defined(CONFIG_EEH)
+#if defined(CONFIG_PCIEPORTBUS) || defined(CONFIG_EEH) || defined(CONFIG_S390)
 void pci_uevent_ers(struct pci_dev *pdev, enum  pci_ers_result err_type);
 #endif
 
-- 
2.51.0



