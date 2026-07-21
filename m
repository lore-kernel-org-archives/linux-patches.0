Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FE1634DCE4;
	Tue, 21 Jul 2026 22:25:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672760; cv=none; b=B58oEox3iIftvllSPAmludlRlI4twt1kipYCD8i8jbuY7SNUGdM6xNol+8fXuF1kqLo+dwrfdWS1GrAyRiNfK/eH9v74RaJFm9wiSJLFLLCQl1uHCEGKDgu3WxBfeuu+cYvEZYSWux12AbVpYIFbF64tT+bb3ThoftoFQxO4sso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672760; c=relaxed/simple;
	bh=LJ3jlDGsMNtbnwDCuvyYsLMz78hqUNGjztDw9d/toL4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MPYcNDb8g3iW+w589opPUmsCqTaGxMW0edhnPHsAhFNJ75ijOHEha2ulpgDIn10n2F+kJNEX1L2/9bi0a1KnaKslYc0ffLhM7JNk+Xl8jlG/iC20vVrbkojZKZWFz3QPWv7nYdtnJ9ECxKrBOExjh0znjZ59HEJfCG6vfVSD/to=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fWbxOCU/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fWbxOCU/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 845271F00A3A;
	Tue, 21 Jul 2026 22:25:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672759;
	bh=f0q65P+O2VAR45aHtPzV8mwYbWR6mjs11dDCLA5okuw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fWbxOCU/bCR/JnbOZuz6vdAfXeKjKo56AA+TsSymoMVKfLl7gW00aXYGswCz6R0ro
	 JuYXERb0rvyWPqjjuf7ft2nAVR9lp8CSWyFYi2mgs5cjgMLyM08zDU9Yn38qTZfo9z
	 4W0aRfcWKA+2WOsT7Zp5t3td5rEsFrHgqNWhZbfQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mahesh Vaidya <mahesh.vaidya@altera.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	"Subhransu S. Prusty" <subhransu.sekhar.prusty@altera.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 746/843] PCI: altera: Fix resource leaks on probe failure
Date: Tue, 21 Jul 2026 17:26:21 +0200
Message-ID: <20260721152422.831325426@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mahesh Vaidya <mahesh.vaidya@altera.com>

[ Upstream commit 7a94138caeb27f3c49c1dbd93bf422098925bb28 ]

The chained IRQ handler is set during probe, but is only removed during the
driver remove(). If pci_host_probe() fails, the handler and INTx IRQ
domain remain set even though the devm-managed host bridge storage
containing struct altera_pcie will be released, leaving the handler with
a stale data pointer.

Interrupts are also enabled before pci_host_probe() is called. If probe
fails after that point, the controller interrupt source should be disabled
before the chained handler and INTx domain are removed.

So set the chained handler only after the INTx domain has been created.
Disable controller interrupts during IRQ teardown, and tear the IRQ setup
down if pci_host_probe() fails.

Fixes: c63aed7334c2 ("PCI: altera: Use pci_host_probe() to register host")
Signed-off-by: Mahesh Vaidya <mahesh.vaidya@altera.com>
[mani: commit log]
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Reviewed-by: Subhransu S. Prusty <subhransu.sekhar.prusty@altera.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260430204330.3121003-3-mahesh.vaidya@altera.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/pcie-altera.c |   28 ++++++++++++++++++++++++++--
 1 file changed, 26 insertions(+), 2 deletions(-)

--- a/drivers/pci/controller/pcie-altera.c
+++ b/drivers/pci/controller/pcie-altera.c
@@ -683,8 +683,18 @@ static int altera_pcie_init_irq_domain(s
 	return 0;
 }
 
+static void altera_pcie_disable_irq(struct altera_pcie *pcie)
+{
+	if (pcie->pcie_data->version == ALTERA_PCIE_V1 ||
+	    pcie->pcie_data->version == ALTERA_PCIE_V2) {
+		/* Disable all P2A interrupts */
+		cra_writel(pcie, 0, P2A_INT_ENABLE);
+	}
+}
+
 static void altera_pcie_irq_teardown(struct altera_pcie *pcie)
 {
+	altera_pcie_disable_irq(pcie);
 	irq_set_chained_handler_and_data(pcie->irq, NULL, NULL);
 	irq_domain_remove(pcie->irq_domain);
 }
@@ -709,7 +719,6 @@ static int altera_pcie_parse_dt(struct a
 	if (pcie->irq < 0)
 		return pcie->irq;
 
-	irq_set_chained_handler_and_data(pcie->irq, altera_pcie_isr, pcie);
 	return 0;
 }
 
@@ -794,6 +803,12 @@ static int altera_pcie_probe(struct plat
 		return ret;
 	}
 
+	/*
+	 * The chained handler uses pcie->irq_domain, so set it only after the
+	 * INTx domain has been created.
+	 */
+	irq_set_chained_handler_and_data(pcie->irq, altera_pcie_isr, pcie);
+
 	/* clear all interrupts */
 	cra_writel(pcie, P2A_INT_STS_ALL, P2A_INT_STATUS);
 	/* enable all interrupts */
@@ -804,7 +819,16 @@ static int altera_pcie_probe(struct plat
 	bridge->busnr = pcie->root_bus_nr;
 	bridge->ops = &altera_pcie_ops;
 
-	return pci_host_probe(bridge);
+	ret = pci_host_probe(bridge);
+	if (ret)
+		goto err_teardown_irq;
+
+	return 0;
+
+err_teardown_irq:
+	altera_pcie_irq_teardown(pcie);
+
+	return ret;
 }
 
 static int altera_pcie_remove(struct platform_device *pdev)


