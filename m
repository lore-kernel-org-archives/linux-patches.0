Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DB6823D7E8;
	Tue, 21 Oct 2025 20:06:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761077199; cv=none; b=LLmkItKQtps+j4dERoreFw6K4niZIirIBpSQUeTJdhcTHfUQBjSHY/p2l3mWUc2EH0V69ElVRl/AqehJptiyD3Ioy1szkbO1X4Ywl+AzsQP1Od2+ezJbUmeWPfTmSzNkeVrgyJnmBoSLzsbFV6+rxIpqG/ujGif7Ce1QaTgO3e8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761077199; c=relaxed/simple;
	bh=vN3bG8HZF2gygsjJo0uh+FhGBrj81LGRnduYBkbqnIs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ud4CUxSrUrUDkkYkYdAHijpdg7Lmdir6WtPN5smR/Q2S0WcSLpP5TYJRnGaS2PIAlEs/Y5tOH42ahsxJWhVtERnZpvcNdZjPlc4JwfMfl0ZK2g19fnc2VjOL3mbKGEqlHLqaNygsU7jDa8o9tTrSboL441Z9UQAcZqpOu3O5lu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Odizybiw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Odizybiw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9692C4CEF1;
	Tue, 21 Oct 2025 20:06:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761077199;
	bh=vN3bG8HZF2gygsjJo0uh+FhGBrj81LGRnduYBkbqnIs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OdizybiwqakUJSKcmwk2qBzeBhCVuiUtvJNr0pQwAUYSWJDZYANtoxVkRb9gyI9og
	 JVg/LtuFeo69yT8lIvO7YpGxLjm3ItNxfxeECcR/rsHGSXXkrcWB9JW/ybUiYDEfVZ
	 DftK6fyfqvT+01M6RWEH+CrrW9o/Kop3rzqLoyVw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kenneth Crudup <kenny@panix.com>,
	Genes Lists <lists@sapience.com>,
	Todd Brandt <todd.e.brandt@intel.com>,
	Oliver Hartkopp <socketcan@hartkopp.net>,
	=?UTF-8?q?Herv=C3=A9?= <herve@dxcv.net>,
	Inochi Amaoto <inochiama@gmail.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Todd Brandt <todd.e.brandt@linux.intel.com>
Subject: [PATCH 6.17 003/159] PCI: vmd: Override irq_startup()/irq_shutdown() in vmd_init_dev_msi_info()
Date: Tue, 21 Oct 2025 21:49:40 +0200
Message-ID: <20251021195043.267235879@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195043.182511864@linuxfoundation.org>
References: <20251021195043.182511864@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Inochi Amaoto <inochiama@gmail.com>

commit e433110eb5bf067f74d3d15c5fb252206c66ae0b upstream.

Since commit 54f45a30c0d0 ("PCI/MSI: Add startup/shutdown for per
device domains") set callback irq_startup() and irq_shutdown() of
the struct pci_msi[x]_template, __irq_startup() will always invokes
irq_startup() callback instead of irq_enable() callback overridden
in vmd_init_dev_msi_info(). This will not start the IRQ correctly.

Also override irq_startup()/irq_shutdown() in vmd_init_dev_msi_info(),
so the irq_startup() can invoke the real logic.

Fixes: 54f45a30c0d0 ("PCI/MSI: Add startup/shutdown for per device domains")
Reported-by: Kenneth Crudup <kenny@panix.com>
Closes: https://lore.kernel.org/r/8a923590-5b3a-406f-a324-7bd1cf894d8f@panix.com/
Reported-by: Genes Lists <lists@sapience.com>
Closes: https://lore.kernel.org/r/4b392af8847cc19720ffcd53865f60ab3edc56b3.camel@sapience.com
Reported-by: Todd Brandt <todd.e.brandt@intel.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=220658
Reported-by: Oliver Hartkopp <socketcan@hartkopp.net>
Closes: https://lore.kernel.org/r/8d6887a5-60bc-423c-8f7a-87b4ab739f6a@hartkopp.net
Reported-by: Hervé <herve@dxcv.net>
Signed-off-by: Inochi Amaoto <inochiama@gmail.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Tested-by: Kenneth R. Crudup <kenny@panix.com>
Tested-by: Genes Lists <lists@sapience.com>
Tested-by: Oliver Hartkopp <socketcan@hartkopp.net>
Tested-by: Todd Brandt <todd.e.brandt@linux.intel.com>
Tested-by: Hervé <herve@dxcv.net>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20251014014607.612586-1-inochiama@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/vmd.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/pci/controller/vmd.c b/drivers/pci/controller/vmd.c
index 1bd5bf4a6097..b4b62b9ccc45 100644
--- a/drivers/pci/controller/vmd.c
+++ b/drivers/pci/controller/vmd.c
@@ -192,6 +192,12 @@ static void vmd_pci_msi_enable(struct irq_data *data)
 	data->chip->irq_unmask(data);
 }
 
+static unsigned int vmd_pci_msi_startup(struct irq_data *data)
+{
+	vmd_pci_msi_enable(data);
+	return 0;
+}
+
 static void vmd_irq_disable(struct irq_data *data)
 {
 	struct vmd_irq *vmdirq = data->chip_data;
@@ -210,6 +216,11 @@ static void vmd_pci_msi_disable(struct irq_data *data)
 	vmd_irq_disable(data->parent_data);
 }
 
+static void vmd_pci_msi_shutdown(struct irq_data *data)
+{
+	vmd_pci_msi_disable(data);
+}
+
 static struct irq_chip vmd_msi_controller = {
 	.name			= "VMD-MSI",
 	.irq_compose_msi_msg	= vmd_compose_msi_msg,
@@ -309,6 +320,8 @@ static bool vmd_init_dev_msi_info(struct device *dev, struct irq_domain *domain,
 	if (!msi_lib_init_dev_msi_info(dev, domain, real_parent, info))
 		return false;
 
+	info->chip->irq_startup		= vmd_pci_msi_startup;
+	info->chip->irq_shutdown	= vmd_pci_msi_shutdown;
 	info->chip->irq_enable		= vmd_pci_msi_enable;
 	info->chip->irq_disable		= vmd_pci_msi_disable;
 	return true;
-- 
2.51.1.dirty



