Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D21143D6664;
	Fri,  4 Sep 2026 05:29:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499747; cv=none; b=CQgEaXcNtueWO+9R1slaASExVteV+Quqpd82P5p/SSUURfWeVsyRtJ5VWl4W5seTLTrIYp9ihAnTNBaL3IaIoE1t/8tNrrQ8i3lU3Sy0BFWSbNzEfMQsxXEMhfTJrJQ0+W+DVh9+w6jKWTP9SVRFG0udJqgHCcZI8rnCUyd+dpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499747; c=relaxed/simple;
	bh=zg+zPjFcSAS+jxjrtHt8cJljT3Py1i52xL6vMiJYt0A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h6E+ynRWaQbzUZXaqw94FUEetDR2ZC/W21bBu2XeLudLhOJ5mmuyzyHdFcblKGIMjSHXbQxqMZ4mNi+VGFk0QD2o6oe007z6G7MFIW9/5+6RIl2coGcmznPegKQASmUvQ9uWgM5ppiiE5UIqdbwFH6Cp0Whv9L00+ECTshUzD0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RRCIRLBU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RRCIRLBU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3186C1F00A3D;
	Fri,  4 Sep 2026 05:29:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499745;
	bh=hhvRI6ZyVV7qcElPgaRu+h/mHx/4TwYIT3xACR1zzpc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RRCIRLBUS1NkutRAMORPi68Xs9bEGA+fRkIaOfLaT5OElxSfvXZnMm284FwdEc1ui
	 6MZ8CkYW8U9/BIH86v1fQAy9tY70wutm3cyY+kxfJMEPeVqOiF6dIi/3A4Ebio/Ha6
	 uCFNTFmp+jFYan9px8CkGy/0FV/iXlHNBYuifOso=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ali Tariq <alitariq45892@gmail.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Subject: [PATCH 7.2 525/713] PCI: plda: Fix IRQ domain leaks in the error paths of plda_init_interrupts()
Date: Fri,  4 Sep 2026 06:58:13 +0200
Message-ID: <20260904045815.588466897@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

From: Ali Tariq <alitariq45892@gmail.com>

commit 19a30bbb6477bfd7e3109b7a2943e6597ee9de37 upstream.

plda_init_interrupts() initializes IRQ domains and creates IRQ mapping but
does not unwind them when later step fails.

If platform_get_irq() or either irq_create_mapping() fails
in plda_init_interrupts(), the domains are never deinitialized. If
irq_create_mapping() fails, port->intx_irq stays initialized.

Hence, remove the IRQ domains in the error path by calling
plda_pcie_irq_domain_deinit().

Since plda_pcie_irq_domain_deinit() now disposes of the intx_irq and
msi_irq mappings itself before removing their domains, the msi_irq
mapping failure path can go directly to err_irq_domain_deinit instead of
disposing of port->intx_irq separately first.

This issue was found by automated review of sashiko-bot

Fixes: 4602c370bdf6 ("PCI: microchip: Move IRQ functions to pcie-plda-host.c")
Fixes: 76c911396807 ("PCI: plda: Add host init/deinit and map bus functions")
Closes: https://lore.kernel.org/linux-pci/20260718120701.DF4111F000E9@smtp.kernel.org/
Signed-off-by: Ali Tariq <alitariq45892@gmail.com>
[mani: commit log]
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260723142824.726655-1-alitariq45892@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/plda/pcie-plda-host.c |   28 ++++++++++++++++++++-------
 1 file changed, 21 insertions(+), 7 deletions(-)

--- a/drivers/pci/controller/plda/pcie-plda-host.c
+++ b/drivers/pci/controller/plda/pcie-plda-host.c
@@ -419,6 +419,8 @@ static int plda_pcie_init_irq_domains(st
 	return plda_allocate_msi_domains(port);
 }
 
+static void plda_pcie_irq_domain_deinit(struct plda_pcie_rp *pcie);
+
 int plda_init_interrupts(struct platform_device *pdev,
 			 struct plda_pcie_rp *port,
 			 const struct plda_event *event)
@@ -440,14 +442,17 @@ int plda_init_interrupts(struct platform
 	}
 
 	port->irq = platform_get_irq(pdev, 0);
-	if (port->irq < 0)
-		return -ENODEV;
+	if (port->irq < 0) {
+		ret = -ENODEV;
+		goto err_irq_domain_deinit;
+	}
 
 	for_each_set_bit(i, &port->events_bitmap, port->num_events) {
 		event_irq = irq_create_mapping(port->event_domain, i);
 		if (!event_irq) {
 			dev_err(dev, "failed to map hwirq %d\n", i);
-			return -ENXIO;
+			ret = -ENXIO;
+			goto err_irq_domain_deinit;
 		}
 
 		if (event->request_event_irq)
@@ -459,7 +464,7 @@ int plda_init_interrupts(struct platform
 
 		if (ret) {
 			dev_err(dev, "failed to request IRQ %d\n", event_irq);
-			return ret;
+			goto err_irq_domain_deinit;
 		}
 	}
 
@@ -467,7 +472,8 @@ int plda_init_interrupts(struct platform
 					    event->intx_event);
 	if (!port->intx_irq) {
 		dev_err(dev, "failed to map INTx interrupt\n");
-		return -ENXIO;
+		ret = -ENXIO;
+		goto err_irq_domain_deinit;
 	}
 
 	/* Plug the INTx chained handler */
@@ -475,8 +481,11 @@ int plda_init_interrupts(struct platform
 
 	port->msi_irq = irq_create_mapping(port->event_domain,
 					   event->msi_event);
-	if (!port->msi_irq)
-		return -ENXIO;
+	if (!port->msi_irq) {
+		dev_err(dev, "failed to map MSI interrupt\n");
+		ret = -ENXIO;
+		goto err_irq_domain_deinit;
+	}
 
 	/* Plug the MSI chained handler */
 	irq_set_chained_handler_and_data(port->msi_irq, plda_handle_msi, port);
@@ -485,6 +494,11 @@ int plda_init_interrupts(struct platform
 	irq_set_chained_handler_and_data(port->irq, plda_handle_event, port);
 
 	return 0;
+
+err_irq_domain_deinit:
+	plda_pcie_irq_domain_deinit(port);
+
+	return ret;
 }
 EXPORT_SYMBOL_GPL(plda_init_interrupts);
 


