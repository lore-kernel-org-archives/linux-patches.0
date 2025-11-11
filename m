Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2478230276C;
	Tue, 11 Nov 2025 01:08:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823285; cv=none; b=jGyymkBIGBd54f0s0UCluDc6i6KdpboCNGs3yD67ej6SLSuCTHht5sBgvdYiPHokIUue/9wmXOuCdS7555Cig9Y9hbt+koMgA9/25icEp9fTrzy4U1pJlEjnZXNcdsrBYtw8/IrrmQ8J3FaSfBzrzZkBXoGonlnro+0mZFQRxuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823285; c=relaxed/simple;
	bh=PSN5SGYda/KlbfOFsOzXJPq+s3WAJ8vIN26V1BBboRU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i5fU66MwFLa06Y9YAOM9s5iWdyNpFe5PlhvRWds8FFhJUBSt2zXIlBXwnUUZ00/zxlbIDi2OX1DpIRu2KB8+GnbbgcU7ByruikUNSVv0R1TcCG43zVtAjcPnvfNGOQ/lMU7RQpgL4cZqmTb4oycOmvkdu0YMVtWx/UMSXWNgwu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dKP807gY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dKP807gY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B47A3C4CEFB;
	Tue, 11 Nov 2025 01:08:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823285;
	bh=PSN5SGYda/KlbfOFsOzXJPq+s3WAJ8vIN26V1BBboRU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dKP807gYRuYbE059+I4t2HasRIXQJlJNJvdNXixUwG4sEDIt3VuVPVbmMkvqsLKSx
	 Jf5UVwwmxI1WMdlx/KW1hYrwIPJM69Sws0nc/gkyDQUIjSMld32lvjuLhefsngGjf8
	 Q1zL9S9HREAihdPYLfifBIfTakPJ+2F4mxmrzLVY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Lukas Wunner <lukas@wunner.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 212/565] s390/pci: Use pci_uevent_ers() in PCI recovery
Date: Tue, 11 Nov 2025 09:41:08 +0900
Message-ID: <20251111004531.694330864@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -90,6 +90,7 @@ static pci_ers_result_t zpci_event_notif
 	pci_ers_result_t ers_res = PCI_ERS_RESULT_DISCONNECT;
 
 	ers_res = driver->err_handler->error_detected(pdev,  pdev->error_state);
+	pci_uevent_ers(pdev, ers_res);
 	if (ers_result_indicates_abort(ers_res))
 		pr_info("%s: Automatic recovery failed after initial reporting\n", pci_name(pdev));
 	else if (ers_res == PCI_ERS_RESULT_NEED_RESET)
@@ -219,6 +220,7 @@ static pci_ers_result_t zpci_event_attem
 		ers_res = zpci_event_do_reset(pdev, driver);
 
 	if (ers_res != PCI_ERS_RESULT_RECOVERED) {
+		pci_uevent_ers(pdev, PCI_ERS_RESULT_DISCONNECT);
 		pr_err("%s: Automatic recovery failed; operator intervention is required\n",
 		       pci_name(pdev));
 		goto out_unlock;
@@ -227,6 +229,7 @@ static pci_ers_result_t zpci_event_attem
 	pr_info("%s: The device is ready to resume operations\n", pci_name(pdev));
 	if (driver->err_handler->resume)
 		driver->err_handler->resume(pdev);
+	pci_uevent_ers(pdev, PCI_ERS_RESULT_RECOVERED);
 out_unlock:
 	device_unlock(&pdev->dev);
 
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -1586,7 +1586,7 @@ static int pci_uevent(const struct devic
 	return 0;
 }
 
-#if defined(CONFIG_PCIEAER) || defined(CONFIG_EEH)
+#if defined(CONFIG_PCIEAER) || defined(CONFIG_EEH) || defined(CONFIG_S390)
 /**
  * pci_uevent_ers - emit a uevent during recovery path of PCI device
  * @pdev: PCI device undergoing error recovery
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -2707,7 +2707,7 @@ static inline bool pci_is_thunderbolt_at
 	return false;
 }
 
-#if defined(CONFIG_PCIEPORTBUS) || defined(CONFIG_EEH)
+#if defined(CONFIG_PCIEPORTBUS) || defined(CONFIG_EEH) || defined(CONFIG_S390)
 void pci_uevent_ers(struct pci_dev *pdev, enum  pci_ers_result err_type);
 #endif
 


