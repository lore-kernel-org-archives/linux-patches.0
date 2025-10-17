Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7C71332EC6;
	Fri, 17 Oct 2025 15:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713292; cv=none; b=aHLqBBV5l0uz+Zmc1yfupwuSI1dSbdSaDOere8z3DYEoby745MuP82qhK5E5P4a9XqdzXJ+pG/yoBtPhqImCXEd1Oy/FYcw92Ckz/eKLkVXyH9HJcYSN+b2XKHm0PEDhaWiH9xR4N6rnRodHKiw9CfPf4LTdiJDl3M+dHcXdG6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713292; c=relaxed/simple;
	bh=ko0E3FFr2KymT57OKBPgIpAypK3s8LgMy1f44X4lzww=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HMAJYfBb7nhP57pjjIza8uRKUggbG5gtLQTLsVTWi+X3nxYTKwmNJaR5eF8p7leMXtIXFJum0qY9obj/e5iA1LIWgTG6sJgjWYTxFPhiLrdhqMorTmiI2YbQxAuzml2zSitS1+UiAF1pg6Q5KuJqWerQqcuKpaMPkOy1Vw9SC1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PUgnwjPe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PUgnwjPe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E51DC113D0;
	Fri, 17 Oct 2025 15:01:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713291;
	bh=ko0E3FFr2KymT57OKBPgIpAypK3s8LgMy1f44X4lzww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PUgnwjPe1aWkqAXCI42fgPWeS43y+EJM0mUzcxNOmffZZpSqaMoas40IhGO22i1FO
	 5jWhGgS1vWnoX+/iUprLKk85zuMt0MSoBo7kWaEpjWTyh14pdWhFhX7n/Nhpt7juwF
	 NlRCQjRlaeC42yUgoK5+92QZPtp1PSOokUH28VC0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Slaby <jirislaby@kernel.org>,
	Siddharth Vadapalli <s-vadapalli@ti.com>,
	Manivannan Sadhasivam <mani@kernel.org>
Subject: [PATCH 6.1 114/168] PCI: keystone: Use devm_request_irq() to free "ks-pcie-error-irq" on exit
Date: Fri, 17 Oct 2025 16:53:13 +0200
Message-ID: <20251017145133.225275318@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145129.000176255@linuxfoundation.org>
References: <20251017145129.000176255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Siddharth Vadapalli <s-vadapalli@ti.com>

commit e51d05f523e43ce5d2bad957943a2b14f68078cd upstream.

Commit under Fixes introduced the IRQ handler for "ks-pcie-error-irq".
The interrupt is acquired using "request_irq()" but is never freed if
the driver exits due to an error. Although the section in the driver that
invokes "request_irq()" has moved around over time, the issue hasn't been
addressed until now.

Fix this by using "devm_request_irq()" which automatically frees the
interrupt if the driver exits.

Fixes: 025dd3daeda7 ("PCI: keystone: Add error IRQ handler")
Reported-by: Jiri Slaby <jirislaby@kernel.org>
Closes: https://lore.kernel.org/r/3d3a4b52-e343-42f3-9d69-94c259812143@kernel.org
Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20250912100802.3136121-2-s-vadapalli@ti.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/dwc/pci-keystone.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/pci/controller/dwc/pci-keystone.c
+++ b/drivers/pci/controller/dwc/pci-keystone.c
@@ -1214,8 +1214,8 @@ static int ks_pcie_probe(struct platform
 	if (irq < 0)
 		return irq;
 
-	ret = request_irq(irq, ks_pcie_err_irq_handler, IRQF_SHARED,
-			  "ks-pcie-error-irq", ks_pcie);
+	ret = devm_request_irq(dev, irq, ks_pcie_err_irq_handler, IRQF_SHARED,
+			       "ks-pcie-error-irq", ks_pcie);
 	if (ret < 0) {
 		dev_err(dev, "failed to request error IRQ %d\n",
 			irq);


