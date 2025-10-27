Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AE6431B82B;
	Mon, 27 Oct 2025 18:44:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761590652; cv=none; b=WuY/bTXV5xDKVqbtQLf+SKz5f8rUV/Z1CZOi0unKGZded+87ZZHW+Wf3MFcitZK6sxH1dOG/HIMQr/t/OwJZq1q8VsCYwFADAor6k0OhdAZgQqDZa7GHYQUcRonUDEpaTsXhQYcfnmIaARlQHSEBadLOXzM3yoR8IXOTDzYfrlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761590652; c=relaxed/simple;
	bh=97Mfm1c1O8vUh4YG0PG8I6h9Vn4SWWCfaWbD9dWIouU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c3LlOoVBPKGzEB6Aa/thWa9tk2WXrdvsVrypza0oETbGHhnQg/TQook1PIO41Z0qIbevc9mITHXPccsZvcHrAyvBAyS4tA9Oko3OQLRGrqUNiqTHgH0iKd2SbS1SW9s7c45ZTfknkpTRzjurPYt+9cdt3UMGGxGzp0NMUtdKa70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zMbeNyJQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zMbeNyJQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45F5EC4CEFD;
	Mon, 27 Oct 2025 18:44:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761590651;
	bh=97Mfm1c1O8vUh4YG0PG8I6h9Vn4SWWCfaWbD9dWIouU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zMbeNyJQzpnd/lhc4Wr+q7tNRCbz+gnZoAQ1eCxSVIUaQWbE/mEdYchewbcjC/vmk
	 WDQpK7yT2O1KCENUJTtv7f4kT39VnFc2TaiR8FJE0MqT91gmE5gMY8C/8NRfRvxyWd
	 Dlb0ij178Lie1/ALXow0M3vXiiylMz/XCYhjQCC8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Slaby <jirislaby@kernel.org>,
	Siddharth Vadapalli <s-vadapalli@ti.com>,
	Manivannan Sadhasivam <mani@kernel.org>
Subject: [PATCH 5.4 125/224] PCI: keystone: Use devm_request_irq() to free "ks-pcie-error-irq" on exit
Date: Mon, 27 Oct 2025 19:34:31 +0100
Message-ID: <20251027183512.325515262@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183508.963233542@linuxfoundation.org>
References: <20251027183508.963233542@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1294,8 +1294,8 @@ static int ks_pcie_probe(struct platform
 		return irq;
 	}
 
-	ret = request_irq(irq, ks_pcie_err_irq_handler, IRQF_SHARED,
-			  "ks-pcie-error-irq", ks_pcie);
+	ret = devm_request_irq(dev, irq, ks_pcie_err_irq_handler, IRQF_SHARED,
+			       "ks-pcie-error-irq", ks_pcie);
 	if (ret < 0) {
 		dev_err(dev, "failed to request error IRQ %d\n",
 			irq);


