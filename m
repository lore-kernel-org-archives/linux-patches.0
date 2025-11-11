Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6F59261B77;
	Tue, 11 Nov 2025 01:10:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823430; cv=none; b=Avzai7P4cn7u45qTQgWiD95zXLSBQuhsHVf087dVvKfIlU8Qr/5YCikvIzlTTdUEe/kEqtKSDpldtN50q6W8VQ4Vvnf6NAVmWwL58dZAtLMfHUf7rEfu/wmF8Tm8X1q7pofJBHS1hjPFn8ohbbUII2C+koyGYljq9Fwf3v/61So=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823430; c=relaxed/simple;
	bh=IutzpxaQUWi38vj7HlPPv4sNdDjrfy9jvtflUDMwxTU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K+iqNHFgwvlmUe267y9mpxik0RpBp3r7e2bDyLOA4QWKGVqXR3RBLO4yKA4t138azZMT8pk5LI0n6waMy8T3QG6fB6xPZMdmzcqua9Cfp2al659AzR2hSngJ8Ubb3cdpMSGdAs/wOkRGSPN7JrX98iJ8tra9+US6/qLIWBec0po=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vMKdpSS/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vMKdpSS/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73B5CC113D0;
	Tue, 11 Nov 2025 01:10:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823430;
	bh=IutzpxaQUWi38vj7HlPPv4sNdDjrfy9jvtflUDMwxTU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vMKdpSS/+4fmCwCX4r2LwIG2Y7294RH4HpLSAtbORjTk8tzdnhHE9vwvPreA0erod
	 0Ms3LFy6t9n8LbOMFEeBPeSqre0Y9ifkousJAkd/gQaBjAHZM05364+0EuA145W9gq
	 TdriScOfI0I6MQFhKgeYGlwMRo+dPtLIEjA+MeOg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Lukas Wunner <lukas@wunner.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 299/849] s390/pci: Use pci_uevent_ers() in PCI recovery
Date: Tue, 11 Nov 2025 09:37:49 +0900
Message-ID: <20251111004543.639865015@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index da0de34d2e5ca..27db1e72c623f 100644
--- a/arch/s390/pci/pci_event.c
+++ b/arch/s390/pci/pci_event.c
@@ -88,6 +88,7 @@ static pci_ers_result_t zpci_event_notify_error_detected(struct pci_dev *pdev,
 	pci_ers_result_t ers_res = PCI_ERS_RESULT_DISCONNECT;
 
 	ers_res = driver->err_handler->error_detected(pdev,  pdev->error_state);
+	pci_uevent_ers(pdev, ers_res);
 	if (ers_result_indicates_abort(ers_res))
 		pr_info("%s: Automatic recovery failed after initial reporting\n", pci_name(pdev));
 	else if (ers_res == PCI_ERS_RESULT_NEED_RESET)
@@ -244,6 +245,7 @@ static pci_ers_result_t zpci_event_attempt_error_recovery(struct pci_dev *pdev)
 		ers_res = PCI_ERS_RESULT_RECOVERED;
 
 	if (ers_res != PCI_ERS_RESULT_RECOVERED) {
+		pci_uevent_ers(pdev, PCI_ERS_RESULT_DISCONNECT);
 		pr_err("%s: Automatic recovery failed; operator intervention is required\n",
 		       pci_name(pdev));
 		status_str = "failed (driver can't recover)";
@@ -253,6 +255,7 @@ static pci_ers_result_t zpci_event_attempt_error_recovery(struct pci_dev *pdev)
 	pr_info("%s: The device is ready to resume operations\n", pci_name(pdev));
 	if (driver->err_handler->resume)
 		driver->err_handler->resume(pdev);
+	pci_uevent_ers(pdev, PCI_ERS_RESULT_RECOVERED);
 out_unlock:
 	device_unlock(&pdev->dev);
 	zpci_report_status(zdev, "recovery", status_str);
diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index 6405acdb5d0f3..302d61783f6c0 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -1582,7 +1582,7 @@ static int pci_uevent(const struct device *dev, struct kobj_uevent_env *env)
 	return 0;
 }
 
-#if defined(CONFIG_PCIEAER) || defined(CONFIG_EEH)
+#if defined(CONFIG_PCIEAER) || defined(CONFIG_EEH) || defined(CONFIG_S390)
 /**
  * pci_uevent_ers - emit a uevent during recovery path of PCI device
  * @pdev: PCI device undergoing error recovery
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 59876de13860d..7735acf6f3490 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -2764,7 +2764,7 @@ static inline bool pci_is_thunderbolt_attached(struct pci_dev *pdev)
 	return false;
 }
 
-#if defined(CONFIG_PCIEPORTBUS) || defined(CONFIG_EEH)
+#if defined(CONFIG_PCIEPORTBUS) || defined(CONFIG_EEH) || defined(CONFIG_S390)
 void pci_uevent_ers(struct pci_dev *pdev, enum  pci_ers_result err_type);
 #endif
 
-- 
2.51.0



