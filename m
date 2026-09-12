Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B8CA35AC1E;
	Sat, 12 Sep 2026 08:24:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201473; cv=none; b=IRCfmvKGH13zexcfba02hyGcqkwTgI86o8HKGlLcyDLl5B6IzW8ddN0i0dI6O/+RX15GQWefwki18zOtiZVfWOm+k4EwS1kBbO4H7KO/a1O08ZQJVzXJ3TnxiyXNemrppBgRs7i2tGbu5hbgfdB5TiEBhqnfS1zTyNsszD5bt4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201473; c=relaxed/simple;
	bh=OA9KStQRsKDtREwvk+Tyh0N29ZLOn3eiRvFNkUIkklY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WnmFXc/C+BKhQotN32nRd7GX8BdTTBcvV01ovXCvr7ZarCq3VBAxyWQCMao14MQpoUqhNzM2Qm1I+Lpau8r5U7ogPZ4h++ZCvIxnpVeB75RqvPG9MxMdpT2/75pem1dqOIa+jhZ6t8Gt337uqUGQEyTtJNlpWCPHB7FojvT+RnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EJX8nCiu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EJX8nCiu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAF591F000FF;
	Sat, 12 Sep 2026 08:24:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201471;
	bh=JUJHq1zG7Y0wlc38nyyYjJzvE1e6OpSa0fHCwVwaPQk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EJX8nCiucgN8e/t7K7zW/4vESQMEAJ7g9IrB6RWbkgleslBLZ241qt6IlBtyM/Ig0
	 kl91RmktBiSIK9NYMsWM3ZWy21METGOByZmmbjpocPmZXTe0nUGxsKh15SyQ6+/iNF
	 CaXOuUF0e1GNJtDERta0gITOvjurjfn+90fGqnkU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1001/1815] PCI: dwc: ep: Flush cached MSI write before unmapping the iATU
Date: Sat, 12 Sep 2026 08:45:51 +0200
Message-ID: <20260912065712.507259050@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niklas Cassel <cassel@kernel.org>

[ Upstream commit 1b01d725d8b42450b86a857bab3c46856c740166 ]

The MSI-X path already flushes any posted MSI-X write before tearing down
its iATU mapping. That was added by commit c22533c66cca ("PCI: dwc: ep:
Flush MSI-X write before unmapping its ATU entry") to make sure the write
reaches the Root Complex before the outbound window that translates it
disappears.

The MSI path has the same problem but no equivalent flush. When the
Endpoint driver caches an MSI target address and later observes that the
Root Complex has changed it, dw_pcie_ep_raise_msi_irq() unmaps the existing
iATU entry and reprograms it for the new address. Between the last MSI
writel() and the unmap there may still be a posted write sitting in the
fabric, and unmapping the iATU entry can drop or misroute that write.

Fix this by reading back from the mapped MSI window before the unmap. The
readback drains any posted MSI writes through the same iATU entry that
mapped them, which is the same logic the MSI-X path uses.

Fixes: 468711a40d5d ("PCI: dwc: ep: Refresh MSI Message Address cache on change")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/linux-pci/20260729214859.B9E2B1F00A3A@smtp.kernel.org
Signed-off-by: Niklas Cassel <cassel@kernel.org>
[mani: commit log]
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Link: https://patch.msgid.link/20260730133123.1420413-5-cassel@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-designware-ep.c | 3 +++
 drivers/pci/controller/dwc/pcie-designware.h    | 1 +
 2 files changed, 4 insertions(+)

diff --git a/drivers/pci/controller/dwc/pcie-designware-ep.c b/drivers/pci/controller/dwc/pcie-designware-ep.c
index 31402ae218c79..9e50c589b308f 100644
--- a/drivers/pci/controller/dwc/pcie-designware-ep.c
+++ b/drivers/pci/controller/dwc/pcie-designware-ep.c
@@ -1032,6 +1032,8 @@ int dw_pcie_ep_raise_msi_irq(struct dw_pcie_ep *ep, u8 func_no,
 		 * there is no unified way to check if we have operations in
 		 * flight, thus we don't know if we should WARN() or not.
 		 */
+		/* flush posted write before unmap */
+		readl(ep->msi_mem + ep->msi_iatu_mapped_offset);
 		dw_pcie_ep_unmap_addr(epc, func_no, 0, ep->msi_mem_phys);
 		ep->msi_iatu_mapped = false;
 	}
@@ -1044,6 +1046,7 @@ int dw_pcie_ep_raise_msi_irq(struct dw_pcie_ep *ep, u8 func_no,
 			return ret;
 
 		ep->msi_iatu_mapped = true;
+		ep->msi_iatu_mapped_offset = offset;
 		ep->msi_msg_addr = msg_addr;
 		ep->msi_map_size = map_size;
 	}
diff --git a/drivers/pci/controller/dwc/pcie-designware.h b/drivers/pci/controller/dwc/pcie-designware.h
index de4b245b1758c..1d21394741572 100644
--- a/drivers/pci/controller/dwc/pcie-designware.h
+++ b/drivers/pci/controller/dwc/pcie-designware.h
@@ -518,6 +518,7 @@ struct dw_pcie_ep {
 
 	/* MSI outbound iATU state */
 	bool			msi_iatu_mapped;
+	size_t			msi_iatu_mapped_offset;
 	u64			msi_msg_addr;
 	size_t			msi_map_size;
 };
-- 
2.53.0



