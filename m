Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C02D1D07BC;
	Wed,  2 Oct 2024 14:17:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878661; cv=none; b=rdHJjz2d+C6kfGTKCYDJAHe1uSMVW159rbkfTX5bGMa79I1OP8vhHJQBxIwh9ZzKGbPGHCjqq881ftppeA3jvmMcbFKGTW9logSONw3JRo9eYSNS0mCnSJXM47gc71J8L5hbPFp7jFC6QPM8QW2HH7m8h+6kuFz3BPgTh0tsHBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878661; c=relaxed/simple;
	bh=GsnPNPN7XxjqnY1AhUgAnd+j8jqjjPPagzAytn+7IU8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eVXv8mi2Ss3h+g/x14TuB8TzB4SQKyqIqvKP/hOl3js6zJO0c0AOJ6+KGtg3LfYQ6xdYdjN9i2sOy1YKoketF5qAi+OXnskTu1uHHJtoOyWOZTbNJLFLzE0lqwCOiY8H9G/vV3myr/IaeQx8idEENnpCQQj12daKa6Khn73iFBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qTrRe6Fr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qTrRe6Fr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1925C4CEC2;
	Wed,  2 Oct 2024 14:17:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878661;
	bh=GsnPNPN7XxjqnY1AhUgAnd+j8jqjjPPagzAytn+7IU8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qTrRe6FrcFBvTaeKzQYLnISnSxvuqfnSCMC7/0FW82KL3mZyeU4miXZ+v2Ho42zqG
	 fcllT1g8P/MwaltgkWwLSfUwoHWYgJiFX3a9RLItdzTWVVuvClsktLfkfVBKoy2WTu
	 HWr9xwlHI3yMgqcgVYhD/Cv0Cd+YSifylRtvWzWI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Udit Kumar <u-kumar1@ti.com>,
	Siddharth Vadapalli <s-vadapalli@ti.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Kevin Hilman <khilman@baylibre.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH 6.10 472/634] PCI: dra7xx: Fix error handling when IRQ request fails in probe
Date: Wed,  2 Oct 2024 14:59:32 +0200
Message-ID: <20241002125829.739256698@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Siddharth Vadapalli <s-vadapalli@ti.com>

commit 4d60f6d4b8fa4d7bad4aeb2b3ee5c10425bc60a4 upstream.

Commit d4c7d1a089d6 ("PCI: dwc: dra7xx: Push request_irq()
call to the bottom of probe") moved the IRQ request for
"dra7xx-pcie-main" towards the end of dra7xx_pcie_probe().

However, the error handling does not take into account the
initialization performed by either dra7xx_add_pcie_port() or
dra7xx_add_pcie_ep(), depending on the mode of operation.

Fix the error handling to address this.

Fixes: d4c7d1a089d6 ("PCI: dwc: dra7xx: Push request_irq() call to the bottom of probe")
Link: https://lore.kernel.org/linux-pci/20240827122422.985547-3-s-vadapalli@ti.com
Tested-by: Udit Kumar <u-kumar1@ti.com>
Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
[kwilczynski: commit log]
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Reviewed-by: Kevin Hilman <khilman@baylibre.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/dwc/pci-dra7xx.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/pci/controller/dwc/pci-dra7xx.c
+++ b/drivers/pci/controller/dwc/pci-dra7xx.c
@@ -854,11 +854,17 @@ static int dra7xx_pcie_probe(struct plat
 					"dra7xx-pcie-main", dra7xx);
 	if (ret) {
 		dev_err(dev, "failed to request irq\n");
-		goto err_gpio;
+		goto err_deinit;
 	}
 
 	return 0;
 
+err_deinit:
+	if (dra7xx->mode == DW_PCIE_RC_TYPE)
+		dw_pcie_host_deinit(&dra7xx->pci->pp);
+	else
+		dw_pcie_ep_deinit(&dra7xx->pci->ep);
+
 err_gpio:
 err_get_sync:
 	pm_runtime_put(dev);


