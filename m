Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83122217722;
	Fri, 17 Oct 2025 15:10:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713817; cv=none; b=Vlh5KXQobNQqCcAraLLILcG0na+lV9ND8SXRLtyNj3TYAzE2H0c2JdVFmDlpemcwjh6aRL2R4ddKfW3LyHeM/SiJxcmY2vqwaePfl/pZLuhrPpNfROMjN8iedWqxzi7Odmg1g2RDr1cMurkrDUhmxf0sQxL838Wnt3xRtPcLCUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713817; c=relaxed/simple;
	bh=ZWgkloJajqlO1jzPvjOWBVb4fvfA6Be5cA0VpBWafJA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TCJBJPlOSptVMHFBN2JxWINUIPQtVE5o+zQMFgJ2gBUJrr9ri7eYwxKgRFuSVQEj0/2ksQsDBxEfJ4kImbqGKo+y3e3cXn8kFFCmVPneWQ1VCY8RsNcl7YS7QvZqo3U4y7tFgiNb/EYtE2/1x6HFR6kkp160pC5S4QNKtPGcyH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LT64U8iW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LT64U8iW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B4A2C4CEE7;
	Fri, 17 Oct 2025 15:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713817;
	bh=ZWgkloJajqlO1jzPvjOWBVb4fvfA6Be5cA0VpBWafJA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LT64U8iWkcUa7EJ8pdux3rUWKkns3fu/D9KBgSqgRUsqlaDtCHXtXcYqqJu9hBB8V
	 P44mC5wMtl5p73g5khYX5N32eH81IPlteoneKWbs8oYHbhyJCi61RsLEkUaKEL2Mou
	 KXT+cCQbsEeAKwOGd6RgGUTVr/GWrICZLEQPS1WM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Slaby <jirislaby@kernel.org>,
	Siddharth Vadapalli <s-vadapalli@ti.com>,
	Manivannan Sadhasivam <mani@kernel.org>
Subject: [PATCH 6.6 131/201] PCI: keystone: Use devm_request_irq() to free "ks-pcie-error-irq" on exit
Date: Fri, 17 Oct 2025 16:53:12 +0200
Message-ID: <20251017145139.552260111@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145134.710337454@linuxfoundation.org>
References: <20251017145134.710337454@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1213,8 +1213,8 @@ static int ks_pcie_probe(struct platform
 	if (irq < 0)
 		return irq;
 
-	ret = request_irq(irq, ks_pcie_err_irq_handler, IRQF_SHARED,
-			  "ks-pcie-error-irq", ks_pcie);
+	ret = devm_request_irq(dev, irq, ks_pcie_err_irq_handler, IRQF_SHARED,
+			       "ks-pcie-error-irq", ks_pcie);
 	if (ret < 0) {
 		dev_err(dev, "failed to request error IRQ %d\n",
 			irq);


