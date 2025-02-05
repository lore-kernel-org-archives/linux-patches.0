Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB4BC33993;
	Wed,  5 Feb 2025 14:54:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767248; cv=none; b=MJPfmFUszgfejvTpYzeO3Q+o8aZ5BaxIC9X7BwO5TqrnNS4wN81DvMoMfGm0eee1R7Aru1v6JQ7WVCdiVT9zWE2JInAGousU5HPXaw8f9XuHOccsZlWNWGi3QbMTjmCGhYzWuQXUdXJmHYXgkhCQVzxb3V5SeZcGtRoIr4kZieg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767248; c=relaxed/simple;
	bh=9nqX5HzN8GobDWVhUgNmTsms4vdtRuUg1Ki1fKc30sg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Y+OJGYhRiOScY2gM9NTAGOb+GXjAlJPmKwchQqEg16Cgso8DBJYmCGLFkKXdZs2+idWUSB7prHiQGKnRYiJrx00oGnkVy1f3ckM155NMYcsCA/CjnizzOzw0zOt/cxshGPQ19j+A95kq7OC6a0J2APNtkmAIcykmlKVpPCuFxus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2syTNd1y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2syTNd1y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02880C4CED1;
	Wed,  5 Feb 2025 14:54:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767248;
	bh=9nqX5HzN8GobDWVhUgNmTsms4vdtRuUg1Ki1fKc30sg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2syTNd1ygidaxCE4dlXr0kkoL12CYmYH/JQJ4fLY3O+DNB36rM63ER5AJmLw9MmZo
	 zJwkY8NGAxdbBs7reURoYiXvdqCOIhW0sHVx/SX0MGcF0rKUnWY/EjpihqvXdFUUVX
	 s3xr+QU9G4gC5OWF6EwYoICi8nlhpQDL6zf4cExU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krishna chaitanya chundru <quic_krichai@quicinc.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 429/590] PCI: qcom: Update ICC and OPP values after Link Up event
Date: Wed,  5 Feb 2025 14:43:04 +0100
Message-ID: <20250205134511.677914027@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krishna chaitanya chundru <quic_krichai@quicinc.com>

[ Upstream commit f0639013d340580b72df95d012a93f35eeb0da64 ]

4581403f6792 ("PCI: qcom: Enumerate endpoints based on Link up event in
'global_irq' interrupt") added the Link Up-based enumeration support, but
did not update the ICC/OPP vote once link is up. Before that, the update
happened during probe and the endpoints may or may not be enumerated at
that time, so the ICC/OPP vote was not guaranteed to be accurate.

With Link Up-based enumeration support, the driver can request the accurate
vote based on the PCIe link.

Call qcom_pcie_icc_opp_update() in qcom_pcie_global_irq_thread() after
enumerating the endpoints.

Fixes: 4581403f6792 ("PCI: qcom: Enumerate endpoints based on Link up event in 'global_irq' interrupt")
Link: https://lore.kernel.org/r/20241123-remove_wait2-v5-3-b5f9e6b794c2@quicinc.com
Signed-off-by: Krishna chaitanya chundru <quic_krichai@quicinc.com>
[kwilczynski: commit log]
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Reviewed-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-qcom.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/pci/controller/dwc/pcie-qcom.c b/drivers/pci/controller/dwc/pcie-qcom.c
index 6483e1874477e..4c141e05f84e9 100644
--- a/drivers/pci/controller/dwc/pcie-qcom.c
+++ b/drivers/pci/controller/dwc/pcie-qcom.c
@@ -1559,6 +1559,8 @@ static irqreturn_t qcom_pcie_global_irq_thread(int irq, void *data)
 		pci_lock_rescan_remove();
 		pci_rescan_bus(pp->bridge->bus);
 		pci_unlock_rescan_remove();
+
+		qcom_pcie_icc_opp_update(pcie);
 	} else {
 		dev_WARN_ONCE(dev, 1, "Received unknown event. INT_STATUS: 0x%08x\n",
 			      status);
-- 
2.39.5



