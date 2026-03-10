Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0CA6352C4F;
	Tue, 10 Mar 2026 11:11:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141066; cv=none; b=oAvNwMXQ+9QMWsSm6MDnknvb6YkaeS1m/lNLy+EPbIOUkOgiGBfnwuAj1QEh0dAPyOjr3Wk9KLZI2DP1Dt1YlJu9ySDggZibj0Y3IsgDBy2ScwOXYECGma8YkvQCl9AFWpOBUvKGIa68DN8EZGjxjjd18ZF49OQktc3q95ju2nE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141066; c=relaxed/simple;
	bh=dW9jyH6C2krHoUzgXZRT8TB8aT0rL+G+VRJcHjqUxZI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZWQWuG7n5owQiQKECqGlHaT/z8U4JvCePcIrRWRE3n6/B6pO4hwtdkynRsPSmVbLGLOuKKaqOHSIwOhvtR5X6xy8eMNFh3kS+VgD6dG2zIH17c/Q0pE7pOcjZsQYcSO649hvt1LKBuw1KsB/2Dbp2vCL9AbL+wESy5Sk5ib0RPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Hqp9jW3m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Hqp9jW3m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C63FAC2BC9E;
	Tue, 10 Mar 2026 11:11:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141066;
	bh=dW9jyH6C2krHoUzgXZRT8TB8aT0rL+G+VRJcHjqUxZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hqp9jW3mm1xrKWNHVT8Fp1X+FZVL0CW2tTGJrPyqQDElrIY70e8K5/uqYy73XDmcP
	 WlKyyRkhoAIiEp6Y0tkzzW/hjH6Ewyc9sFeRgVfNzwb7KVrk+ZVMwpcaN8ct5QRqkb
	 HUFpW1PG5U2iYH42nZ47QpfyavFtbe0bZxeCBFv05S3F4VD8k+dekRrODTm0Sdjqe4
	 Q8SbhjATwrPAygM6kuQjDZARX2rdMfzIoVlqpdK8TnQlg73XgoIwK3IlIptEXwMVFk
	 6Uc3I8I9WqUQqn50WHRGZjbbIg2RyVm1U7DOxi04nA5Vy3lcfN7WXjP2Q91L7jkNJe
	 j0O6Kxg3xRjCA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Niklas Cassel <cassel@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 066/311] PCI: dwc: ep: Flush MSI-X write before unmapping its ATU entry
Date: Tue, 10 Mar 2026 07:01:53 -0400
Message-ID: <542c61209b92791aea163046f87a9029aa01b799.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
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
index 77f27295b0a80..7ebb01fa5076f 100644
--- a/drivers/pci/controller/dwc/pcie-designware-ep.c
+++ b/drivers/pci/controller/dwc/pcie-designware-ep.c
@@ -1013,6 +1013,9 @@ int dw_pcie_ep_raise_msix_irq(struct dw_pcie_ep *ep, u8 func_no,
 
 	writel(msg_data, ep->msi_mem + offset);
 
+	/* flush posted write before unmap */
+	readl(ep->msi_mem + offset);
+
 	dw_pcie_ep_unmap_addr(epc, func_no, 0, ep->msi_mem_phys);
 
 	return 0;
-- 
2.51.0

