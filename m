Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACC402698AE;
	Tue,  8 Apr 2025 11:01:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110115; cv=none; b=rnDs+NteDOV2wzVFLzUyZD0fSoCB1cxv3KwBeqe48XEJCQYnxsFPBewpEOABsNDq44bwqQkNzHZgCd1nQDwd/2j9imerHLWtyKeRXyi3oFmAseT176kc72Tw0QCpI/+W1MJXLVn6Lpp/SpmNO5nGpo5FjihzYwsHpKANqclAhCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110115; c=relaxed/simple;
	bh=E7Wwo1lmUH1uVa1rXcmUfJ8WhnM8wI6vjmXHPJ7Vhi4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jgyTxLCfscJzPvaqsvHpBr8VxP0HL76QFJJARHqV7N8HLA1bbuyLBo5x1cPJjJS0NJgwKGAhVMGtbGCh0a/EGNSP5umLIGVh11Ob6zRabaELGg5aq1zZwfUyC4LYaR77KpabgMl4eoAPE3M+cpX28Dq93Qi7kUQL+fNm968AB8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Urp1UskX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Urp1UskX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 391A6C4CEE5;
	Tue,  8 Apr 2025 11:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110115;
	bh=E7Wwo1lmUH1uVa1rXcmUfJ8WhnM8wI6vjmXHPJ7Vhi4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Urp1UskXQu48ffSsZF2+h88xwiqI/y+RyZe7YoIk7AWGVokzH8yI8/zn+MhgDvSf6
	 7D15cuhmgkI8le59ECsrXKfpqlP7xkLiBYpgaha895NQKwoPECabCuQVs/hdG71If8
	 9BgABEujEouKjlpdmuu+/YquoEiij4TnSsHyIMTY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Zhang <18255117159@163.com>,
	Hans Zhang <hans.zhang@cixtech.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 133/227] PCI: cadence-ep: Fix the driver to send MSG TLP for INTx without data payload
Date: Tue,  8 Apr 2025 12:48:31 +0200
Message-ID: <20250408104824.311034977@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.353768086@linuxfoundation.org>
References: <20250408104820.353768086@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans Zhang <18255117159@163.com>

[ Upstream commit 3ac47fbf4f6e8c3a7c3855fac68cc3246f90f850 ]

Per the Cadence's "PCIe Controller IP for AX14" user guide, Version
1.04, Section 9.1.7.1, "AXI Subordinate to PCIe Address Translation
Registers", Table 9.4, the bit 16 of the AXI Subordinate Address
(axi_s_awaddr) when set corresponds to MSG with data, and when not set,
to MSG without data.

However, the driver is currently doing the opposite and due to this,
the INTx is never received on the host.

So, fix the driver to reflect the documentation and also make INTx work.

Fixes: 37dddf14f1ae ("PCI: cadence: Add EndPoint Controller driver for Cadence PCIe controller")
Signed-off-by: Hans Zhang <18255117159@163.com>
Signed-off-by: Hans Zhang <hans.zhang@cixtech.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Link: https://lore.kernel.org/r/20250214165724.184599-1-18255117159@163.com
[kwilczynski: commit log]
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/cadence/pcie-cadence-ep.c | 3 +--
 drivers/pci/controller/cadence/pcie-cadence.h    | 2 +-
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/controller/cadence/pcie-cadence-ep.c b/drivers/pci/controller/cadence/pcie-cadence-ep.c
index 4c5e6349d78ce..403ff93bc8509 100644
--- a/drivers/pci/controller/cadence/pcie-cadence-ep.c
+++ b/drivers/pci/controller/cadence/pcie-cadence-ep.c
@@ -311,8 +311,7 @@ static void cdns_pcie_ep_assert_intx(struct cdns_pcie_ep *ep, u8 fn,
 	spin_unlock_irqrestore(&ep->lock, flags);
 
 	offset = CDNS_PCIE_NORMAL_MSG_ROUTING(MSG_ROUTING_LOCAL) |
-		 CDNS_PCIE_NORMAL_MSG_CODE(msg_code) |
-		 CDNS_PCIE_MSG_NO_DATA;
+		 CDNS_PCIE_NORMAL_MSG_CODE(msg_code);
 	writel(0, ep->irq_cpu_addr + offset);
 }
 
diff --git a/drivers/pci/controller/cadence/pcie-cadence.h b/drivers/pci/controller/cadence/pcie-cadence.h
index e0b59730bffb7..3139ea9f02c89 100644
--- a/drivers/pci/controller/cadence/pcie-cadence.h
+++ b/drivers/pci/controller/cadence/pcie-cadence.h
@@ -224,7 +224,7 @@ struct cdns_pcie_rp_ib_bar {
 #define CDNS_PCIE_NORMAL_MSG_CODE_MASK		GENMASK(15, 8)
 #define CDNS_PCIE_NORMAL_MSG_CODE(code) \
 	(((code) << 8) & CDNS_PCIE_NORMAL_MSG_CODE_MASK)
-#define CDNS_PCIE_MSG_NO_DATA			BIT(16)
+#define CDNS_PCIE_MSG_DATA			BIT(16)
 
 struct cdns_pcie;
 
-- 
2.39.5



