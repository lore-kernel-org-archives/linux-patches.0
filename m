Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96AC31F76AE;
	Tue,  3 Dec 2024 16:02:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241741; cv=none; b=gZZDGJ+RQZWnyuy0fqsB/L0/1VJTasJAt/k3uSPo7t7CDB+OHsiJyLF+SWi4veEvsKpYxe9m/31HlEDeHOeTeCs7apeHs7ITOymmM9G6jvvZ+L4kW+sLElLRYx7tkQtEjNA+7eMsSGs0hL2qi5ikVO8oAYN3kSR/NPQzwkidk2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241741; c=relaxed/simple;
	bh=7to+yEVMXWELQ/WqZScCjS8BJbxh+Cyruy/+qfN9DDw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=l/rVgN8bCcQwRtyvkieMW53M4wAWjW7sDlYfNiclCB9h1zeOszhepQj0dWgaUjI9Thz/zCGfaGekdnc3x+rPD5uwiE68tbfMCWDqH7atbRrAgld0SPQbguRNiPqZ0J/kib5z4NZY1D2E+JfKFbQNmrw6UOPJ70wxxUHvC6vylDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jyz25doL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jyz25doL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDDEFC4CED8;
	Tue,  3 Dec 2024 16:02:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241741;
	bh=7to+yEVMXWELQ/WqZScCjS8BJbxh+Cyruy/+qfN9DDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jyz25doLmWFcSqx6DCLzyKX0A0rbvrErXbr02BB3ZHawkC+v+RooxQeL8JLRXISwG
	 wDqRBEhlUiMk4uOGZpzJHfb21D9Ks1hYqXv2oqT/0FdRvLn+5Xuqs6kWLjcMxPu3SY
	 FWOalpjDDzTTaxXV+xh/9rRMXiADLLP94gnobqIg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konradybcio@kernel.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Qiang Yu <quic_qianyu@quicinc.com>,
	Sasha Levin <sashal@kernel.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Subject: [PATCH 6.12 502/826] PCI: qcom: Enable MSI interrupts together with Link up if Global IRQ is supported
Date: Tue,  3 Dec 2024 15:43:49 +0100
Message-ID: <20241203144803.337433699@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

[ Upstream commit ba4a2e2317b9faeca9193ed6d3193ddc3cf2aba3 ]

Currently, if 'Global IRQ' is supported by the platform, only the Link up
interrupt is enabled in the PARF_INT_ALL_MASK register. This masks MSIs
on some platforms. The MSI bits in PARF_INT_ALL_MASK register are enabled
by default in the hardware, but commit 4581403f6792 ("PCI: qcom: Enumerate
endpoints based on Link up event in 'global_irq' interrupt") disabled them
and enabled only the Link up interrupt. While MSI continued to work on the
SM8450 platform that was used to test the offending commit, on other
platforms like SM8250, X1E80100, MSIs are getting masked. And they require
enabling the MSI interrupt bits in the register to unmask (enable) the
MSIs.

Even though the MSI interrupt enable bits in PARF_INT_ALL_MASK are
described as 'diagnostic' interrupts in the internal documentation,
disabling them masks MSI on these platforms. Due to this, MSIs were not
reported to be received these platforms while supporting 'Global IRQ'.

So, enable the MSI interrupts along with the Link up interrupt in the
PARF_INT_ALL_MASK register if 'Global IRQ' is supported. This ensures that
the MSIs continue to work and also the driver is able to catch the Link
up interrupt for enumerating endpoint devices.

Fixes: 4581403f6792 ("PCI: qcom: Enumerate endpoints based on Link up event in 'global_irq' interrupt")
Closes: https://lore.kernel.org/linux-pci/9a692c98-eb0a-4d86-b642-ea655981ff53@kernel.org/
Link: https://lore.kernel.org/r/20241007051255.4378-1-manivannan.sadhasivam@linaro.org
Reported-by: Konrad Dybcio <konradybcio@kernel.org>
Tested-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com> # SL7
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Reviewed-by: Qiang Yu <quic_qianyu@quicinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-qcom.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/controller/dwc/pcie-qcom.c b/drivers/pci/controller/dwc/pcie-qcom.c
index ef44a82be058b..2b33d03ed0541 100644
--- a/drivers/pci/controller/dwc/pcie-qcom.c
+++ b/drivers/pci/controller/dwc/pcie-qcom.c
@@ -133,6 +133,7 @@
 
 /* PARF_INT_ALL_{STATUS/CLEAR/MASK} register fields */
 #define PARF_INT_ALL_LINK_UP			BIT(13)
+#define PARF_INT_MSI_DEV_0_7			GENMASK(30, 23)
 
 /* PARF_NO_SNOOP_OVERIDE register fields */
 #define WR_NO_SNOOP_OVERIDE_EN			BIT(1)
@@ -1716,7 +1717,8 @@ static int qcom_pcie_probe(struct platform_device *pdev)
 			goto err_host_deinit;
 		}
 
-		writel_relaxed(PARF_INT_ALL_LINK_UP, pcie->parf + PARF_INT_ALL_MASK);
+		writel_relaxed(PARF_INT_ALL_LINK_UP | PARF_INT_MSI_DEV_0_7,
+			       pcie->parf + PARF_INT_ALL_MASK);
 	}
 
 	qcom_pcie_icc_opp_update(pcie);
-- 
2.43.0



