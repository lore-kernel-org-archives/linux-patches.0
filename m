Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 079C3424674;
	Thu, 16 Jul 2026 13:41:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209291; cv=none; b=gNW64p9lkr+ekTG472notTT6TLBvZ1+1ZN4Nc66YphTuHj9b0Fxh3xO/2q87g+hDWMMpCA5cZPSdZi025PyGW4B2+sr664NqmWe3d6wbW4OHnfDtTrn2hc8rWQgGbKsoE3ZWL4IGrbT+YSvjNJmoW1lAOo1Wgh3W5GoBWeDeKFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209291; c=relaxed/simple;
	bh=qVCK+GjA5ihJkycQ05kcwn1J5C7Es1/vA0k7SIV5h2o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pgP/xHNj7jDLw7Sl108vVA/DDvSg441Adxif43ZOuEGf2mTxFimA2wXzhoNINHTbV+lieCZwvhLn9cexkIjIR7+9K3HGj5+hcFVtefH9L6hXXiHrF4xiR7X7agd5OdDq9ByipvEgL/DOOTD+tQ1seMha4MBY3CpxYlNlYoDYLcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FB8wJbAe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FB8wJbAe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B5271F000E9;
	Thu, 16 Jul 2026 13:41:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209289;
	bh=ovuKYALo4s7oG2JC7QCFIdNti897IryJFcPd9YzLUkM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FB8wJbAeSb5U+CRvERA2EDEvw/zc5f2+FsLTDZm6Z3vT3xZQjSHDJKWPKGdE8gaGQ
	 uI5RyOCufX1rFFqsOIzD+SUGTcvgzlp9WjkZoJOQJ/UeAxvxe6qtvPFRCX1KgwDh9R
	 npRtvr8awK5W51ZKlctllzFkXesWXpryzpSNCLwg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mahesh Vaidya <mahesh.vaidya@altera.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	"Subhransu S. Prusty" <subhransu.sekhar.prusty@altera.com>
Subject: [PATCH 7.1 130/518] PCI: altera: Fix resource leaks on probe failure
Date: Thu, 16 Jul 2026 15:26:38 +0200
Message-ID: <20260716133050.703866552@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mahesh Vaidya <mahesh.vaidya@altera.com>

commit 7a94138caeb27f3c49c1dbd93bf422098925bb28 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/pcie-altera.c |   35 +++++++++++++++++++++++++++++++++--
 1 file changed, 33 insertions(+), 2 deletions(-)

--- a/drivers/pci/controller/pcie-altera.c
+++ b/drivers/pci/controller/pcie-altera.c
@@ -864,8 +864,23 @@ static int altera_pcie_init_irq_domain(s
 	return 0;
 }
 
+static void altera_pcie_disable_irq(struct altera_pcie *pcie)
+{
+	if (pcie->pcie_data->version == ALTERA_PCIE_V1 ||
+	    pcie->pcie_data->version == ALTERA_PCIE_V2) {
+		/* Disable all P2A interrupts */
+		cra_writel(pcie, 0, P2A_INT_ENABLE);
+	} else if (pcie->pcie_data->version == ALTERA_PCIE_V3) {
+		/* Disable port-level interrupts (CFG_AER, etc.) */
+		writel(0, pcie->hip_base +
+			  pcie->pcie_data->port_conf_offset +
+			  pcie->pcie_data->port_irq_enable_offset);
+	}
+}
+
 static void altera_pcie_irq_teardown(struct altera_pcie *pcie)
 {
+	altera_pcie_disable_irq(pcie);
 	irq_set_chained_handler_and_data(pcie->irq, NULL, NULL);
 	irq_domain_remove(pcie->irq_domain);
 }
@@ -890,7 +905,6 @@ static int altera_pcie_parse_dt(struct a
 	if (pcie->irq < 0)
 		return pcie->irq;
 
-	irq_set_chained_handler_and_data(pcie->irq, pcie->pcie_data->ops->rp_isr, pcie);
 	return 0;
 }
 
@@ -1019,6 +1033,14 @@ static int altera_pcie_probe(struct plat
 		return ret;
 	}
 
+	/*
+	 * The chained handler uses pcie->irq_domain, so set it only after the
+	 * INTx domain has been created.
+	 */
+	irq_set_chained_handler_and_data(pcie->irq,
+					 pcie->pcie_data->ops->rp_isr,
+					 pcie);
+
 	if (pcie->pcie_data->version == ALTERA_PCIE_V1 ||
 	    pcie->pcie_data->version == ALTERA_PCIE_V2) {
 		/* clear all interrupts */
@@ -1036,7 +1058,16 @@ static int altera_pcie_probe(struct plat
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
 
 static void altera_pcie_remove(struct platform_device *pdev)


