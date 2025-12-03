Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1068222579E;
	Wed,  3 Dec 2025 16:24:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779089; cv=none; b=Yl6gtUl44CwCWSCAKJNinAQ6YKJh3Z3V74rXB603vBmTBpGgMEBwZuYFiNOinG5xf0npo/t3nB4CA5/BBfRJmAHNLY18fmUKvx03yCOlvzDy15MHqzDdFokUarxM6AtJoV4B5GGNvnO9SJPwWUtmd1FGHkCjsl5f8cAcPXtGG14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779089; c=relaxed/simple;
	bh=F/chLMgYdHGulz5efL7LpLOHK/t/MxmjyG2ZWvsFngk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jJV+dEmQR2bnRM0tV6lfcPv6iRXVlC/DvjenDbI094jfe6KzOA7xjPmuXwMlMPdd651unDVkUy1PumCSqgSL8UPSambLMbMyQfvQOg/IeXgyzkgtwFGE2V5zIaTbt1m060Vxm9qWyxOuccPj01cl3d5fYAK9vKsTNli/FIGU9hg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z7hMQh6I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z7hMQh6I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 727A9C4CEF5;
	Wed,  3 Dec 2025 16:24:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779088;
	bh=F/chLMgYdHGulz5efL7LpLOHK/t/MxmjyG2ZWvsFngk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z7hMQh6IKIFJXuVC/w6g5Rff6zbdvEwD3YVW16ZvlqBj7bV0XAZoiQAFzyiPDHzYS
	 cPLlPCPTGgbxro9vwpNkE5nr6fO5TPvXjRhvahlAdn69LIl/6064MkMOyp6NfvuRSA
	 QTMDDwv7bPn7tQpDjBzIaqlG4HQA8lXL5ZShj8PY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Lukas Wunner <lukas@wunner.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 152/568] s390/pci: Use pci_uevent_ers() in PCI recovery
Date: Wed,  3 Dec 2025 16:22:34 +0100
Message-ID: <20251203152446.293861123@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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
 arch/s390/pci/pci_event.c |    3 +++
 drivers/pci/pci-driver.c  |    2 +-
 include/linux/pci.h       |    2 +-
 3 files changed, 5 insertions(+), 2 deletions(-)

--- a/arch/s390/pci/pci_event.c
+++ b/arch/s390/pci/pci_event.c
@@ -83,6 +83,7 @@ static pci_ers_result_t zpci_event_notif
 	pci_ers_result_t ers_res = PCI_ERS_RESULT_DISCONNECT;
 
 	ers_res = driver->err_handler->error_detected(pdev,  pdev->error_state);
+	pci_uevent_ers(pdev, ers_res);
 	if (ers_result_indicates_abort(ers_res))
 		pr_info("%s: Automatic recovery failed after initial reporting\n", pci_name(pdev));
 	else if (ers_res == PCI_ERS_RESULT_NEED_RESET)
@@ -212,6 +213,7 @@ static pci_ers_result_t zpci_event_attem
 		ers_res = zpci_event_do_reset(pdev, driver);
 
 	if (ers_res != PCI_ERS_RESULT_RECOVERED) {
+		pci_uevent_ers(pdev, PCI_ERS_RESULT_DISCONNECT);
 		pr_err("%s: Automatic recovery failed; operator intervention is required\n",
 		       pci_name(pdev));
 		goto out_unlock;
@@ -220,6 +222,7 @@ static pci_ers_result_t zpci_event_attem
 	pr_info("%s: The device is ready to resume operations\n", pci_name(pdev));
 	if (driver->err_handler->resume)
 		driver->err_handler->resume(pdev);
+	pci_uevent_ers(pdev, PCI_ERS_RESULT_RECOVERED);
 out_unlock:
 	device_unlock(&pdev->dev);
 
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -1597,7 +1597,7 @@ static int pci_uevent(struct device *dev
 	return 0;
 }
 
-#if defined(CONFIG_PCIEAER) || defined(CONFIG_EEH)
+#if defined(CONFIG_PCIEAER) || defined(CONFIG_EEH) || defined(CONFIG_S390)
 /**
  * pci_uevent_ers - emit a uevent during recovery path of PCI device
  * @pdev: PCI device undergoing error recovery
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -2561,7 +2561,7 @@ static inline bool pci_is_thunderbolt_at
 	return false;
 }
 
-#if defined(CONFIG_PCIEPORTBUS) || defined(CONFIG_EEH)
+#if defined(CONFIG_PCIEPORTBUS) || defined(CONFIG_EEH) || defined(CONFIG_S390)
 void pci_uevent_ers(struct pci_dev *pdev, enum  pci_ers_result err_type);
 #endif
 


