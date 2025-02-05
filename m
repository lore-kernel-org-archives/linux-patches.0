Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06810DF59;
	Wed,  5 Feb 2025 15:06:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767991; cv=none; b=NIn2WD28CFOo+e9403UCitxNCFwfQlwrDdACLYPe7n7NsHRxLH7Ol6hxyr+BdHcmneJvh4cjuURHoBkz93UEIGMp+oeXJkqfxThfhG3+QLYbzXhMyleOHhQ6HZZMDt/IUBUk8UXYyHzGSrry+pRK1nIPoa6/oyk+Sk9sZGX0qXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767991; c=relaxed/simple;
	bh=78clmqIj4ljUzyAFGeeSoXMAQt1PrwoV/3O7V2gsZFc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=I27wFepM3NeAyBRjbrO+0icxTHRQ55P3JABsq/cFegzAaw8K13M3dNrWNZ9r1YqASeCSnku6GeBRUrOVJOsW8j5hpMBy6NdwW1irX9I39Y7Yt1qVa6EHc668c+7A9HGUEhZAdquYZ0b/lYV1BXwA1Kpb0glrtty3V1Hb8JYx1tQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0sSDPmhl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0sSDPmhl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83EEDC4CED6;
	Wed,  5 Feb 2025 15:06:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767990;
	bh=78clmqIj4ljUzyAFGeeSoXMAQt1PrwoV/3O7V2gsZFc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0sSDPmhlUDtzUN2xMuBqcb6uVficjpb1uBi1iiAbULHQEc1EqBQ8BEz81ExmPQFxq
	 DUFkiWazP3LSKSskRCcgdhHOmR6ARYzJLtxJmEdKiCfzG2RkA3YS5OzNfeSDd5mNUa
	 2e86zpZ1TOxDSM114gMKsMGb4J1GCravye1f1Rnw=
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
Subject: [PATCH 6.13 468/623] PCI: qcom: Update ICC and OPP values after Link Up event
Date: Wed,  5 Feb 2025 14:43:30 +0100
Message-ID: <20250205134514.123414075@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index dc102d8bd58c6..91b7f9ec78bcc 100644
--- a/drivers/pci/controller/dwc/pcie-qcom.c
+++ b/drivers/pci/controller/dwc/pcie-qcom.c
@@ -1569,6 +1569,8 @@ static irqreturn_t qcom_pcie_global_irq_thread(int irq, void *data)
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



