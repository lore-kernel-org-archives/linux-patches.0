Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1D8B38945D;
	Tue, 10 Mar 2026 11:25:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141923; cv=none; b=d8WMXjs17z7I3xnHhmtRAlZSufgdP/P6e6Xeu3oFdapndExlIZKWIXoR3qg3arsyVEFbRQ6K0Yf9yWmhmzGygW+yQe88+U+oHZ19Zc/BVECwujAh7erjm/gTz60r8RiJ0muwI809d9iDkAce2BI2q1YHrAGPErJ9p92gUUw5mmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141923; c=relaxed/simple;
	bh=1H8tS93g5vML4WV+PRvfLEjMaib0+B+pkC6ZNtQU62Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c5RLp05xny0E2WyNlHoBp6mzTZ3/s+7tKFmCL0VdgbEdHJw5y6AZt6MaVQfhv4bSP11lIt+8ZNzxaPkzRBPtC5412uihnbQ9YNppPPB/N51SLjZ9vM1TPbC2n8G/jFEDkfE6ui8OD1pQNXGrfrgZwgCUsKmrad5k8kvn7Aj1tJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cCXj6ucx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cCXj6ucx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B536FC2BCB8;
	Tue, 10 Mar 2026 11:25:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141923;
	bh=1H8tS93g5vML4WV+PRvfLEjMaib0+B+pkC6ZNtQU62Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cCXj6ucxxmmaDDcL9yhZWHBFfMnrPobpBqLmONz0437ZOq/H+veXxhOfJKibFUogj
	 6KF6jdSJMfrqul3CPLQZeiiWyCupDAKtw+TXGuClq8QXxNqteYTeR0BgO5zDRBdnFu
	 tBT5VFmh3Mr3PWOuaFGVUEDNClmE0LLJTN/tpCmW1FLeTcqG+8EdsxpQX+szgQGEZF
	 wVHxGmroQBzKg4FqgrVPzcKWTBzVOwHryEjh35zwFzQPlHs1jIgc+pVZ2m9FR4oh/n
	 mg+X3ePi8H4RyiVbHGM1nm3TEoYoBTuSrTqLDS+g94M9jGG/588hn189NB6vwssntR
	 1wjxgKGHm3U+g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Niklas Cassel <cassel@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 047/314] PCI: dwc: ep: Flush MSI-X write before unmapping its ATU entry
Date: Tue, 10 Mar 2026 07:15:06 -0400
Message-ID: <1759518c6ce0b162cb2e3334e8266eab89223e19.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Niklas Cassel <cassel@kernel.org>

[ Upstream commit c22533c66ccae10511ad6a7afc34bb26c47577e3 ]

Endpoint drivers use dw_pcie_ep_raise_msix_irq() to raise an MSI-X
interrupt to the host using a writel(), which generates a PCI posted write
transaction.  There's no completion for posted writes, so the writel() may
return before the PCI write completes.  dw_pcie_ep_raise_msix_irq() also
unmaps the outbound ATU entry used for the PCI write, so the write races
with the unmap.

If the PCI write loses the race with the ATU unmap, the write may corrupt
host memory or cause IOMMU errors, e.g., these when running fio with a
larger queue depth against nvmet-pci-epf:

  arm-smmu-v3 fc900000.iommu:      0x0000010000000010
  arm-smmu-v3 fc900000.iommu:      0x0000020000000000
  arm-smmu-v3 fc900000.iommu:      0x000000090000f040
  arm-smmu-v3 fc900000.iommu:      0x0000000000000000
  arm-smmu-v3 fc900000.iommu: event: F_TRANSLATION client: 0000:01:00.0 sid: 0x100 ssid: 0x0 iova: 0x90000f040 ipa: 0x0
  arm-smmu-v3 fc900000.iommu: unpriv data write s1 "Input address caused fault" stag: 0x0

Flush the write by performing a readl() of the same address to ensure that
the write has reached the destination before the ATU entry is unmapped.

The same problem was solved for dw_pcie_ep_raise_msi_irq() in commit
8719c64e76bf ("PCI: dwc: ep: Cache MSI outbound iATU mapping"), but there
it was solved by dedicating an outbound iATU only for MSI. We can't do the
same for MSI-X because each vector can have a different msg_addr and the
msg_addr may be changed while the vector is masked.

Fixes: beb4641a787d ("PCI: dwc: Add MSI-X callbacks handler")
Signed-off-by: Niklas Cassel <cassel@kernel.org>
[bhelgaas: commit log]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260211175540.105677-2-cassel@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-designware-ep.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/pci/controller/dwc/pcie-designware-ep.c b/drivers/pci/controller/dwc/pcie-designware-ep.c
index 7f2112c2fb215..6d3beec92b54e 100644
--- a/drivers/pci/controller/dwc/pcie-designware-ep.c
+++ b/drivers/pci/controller/dwc/pcie-designware-ep.c
@@ -793,6 +793,9 @@ int dw_pcie_ep_raise_msix_irq(struct dw_pcie_ep *ep, u8 func_no,
 
 	writel(msg_data, ep->msi_mem + offset);
 
+	/* flush posted write before unmap */
+	readl(ep->msi_mem + offset);
+
 	dw_pcie_ep_unmap_addr(epc, func_no, 0, ep->msi_mem_phys);
 
 	return 0;
-- 
2.51.0

