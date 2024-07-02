Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F307315B0FE;
	Tue,  2 Jul 2024 17:13:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940435; cv=none; b=mrfMnjXjKV6k85EvIwtUU0NpPSqF37gAAOBIE+Yy2izXqQMn7t37hMmk/ROy68EThMoNlcMdZ0SJwEDGuHgM2Nijarh+AoI/Z8fpfvSNrbHjGDe2VRMqAeYEEVrOJiHiUPdW7+ZKwrsaizXtPn2FdJvxvgtEQ46aIW/Yq1k92Wc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940435; c=relaxed/simple;
	bh=UyTIzAQQGFI09v1zVYZezqmwSj5RSeSKEF+3BIgJyRE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mXqMDc2IR5Ha9c3NtcOWNuQqyQ+uqrHCskLm5KGY6nUBq6cIFH2XtPChETSvFGTFMFS1ITbHtLWvLUxg4fGmHvksaZqKIitGofBrYmmV5M9OvHMVF7amAx6h3hh6vBodkn5AoS53jp8QI869oZwZ1GhQdGnpRTx507vDzS+//9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uQVZAXFQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uQVZAXFQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76655C116B1;
	Tue,  2 Jul 2024 17:13:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940434;
	bh=UyTIzAQQGFI09v1zVYZezqmwSj5RSeSKEF+3BIgJyRE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uQVZAXFQaSzvW4n7H70xnhmquMgdRSMh+yUw5aUHbKY4lw/lCPbAoaaREau35cD1I
	 atYbB3+fs5uwKgzbuYVzLjaUzoKX5XT5MhI79wExHASxRxzI34T9Oi0TlmvwWH1zCl
	 aXADVQKyaNPoaPrHyFFqHv0V5UHzGdCJXSP5/6Lw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 6.9 113/222] Revert "MIPS: pci: lantiq: restore reset gpio polarity"
Date: Tue,  2 Jul 2024 19:02:31 +0200
Message-ID: <20240702170248.288069122@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170243.963426416@linuxfoundation.org>
References: <20240702170243.963426416@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Bogendoerfer <tsbogend@alpha.franken.de>

commit 6e5aee08bd2517397c9572243a816664f2ead547 upstream.

This reverts commit 277a0363120276645ae598d8d5fea7265e076ae9.

While fixing old boards with broken DTs, this change will break
newer ones with correct gpio polarity annotation.

Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/mips/pci/pci-lantiq.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/arch/mips/pci/pci-lantiq.c
+++ b/arch/mips/pci/pci-lantiq.c
@@ -124,14 +124,14 @@ static int ltq_pci_startup(struct platfo
 		clk_disable(clk_external);
 
 	/* setup reset gpio used by pci */
-	reset_gpio = devm_gpiod_get_optional(&pdev->dev, "reset", GPIOD_ASIS);
+	reset_gpio = devm_gpiod_get_optional(&pdev->dev, "reset",
+					     GPIOD_OUT_LOW);
 	error = PTR_ERR_OR_ZERO(reset_gpio);
 	if (error) {
 		dev_err(&pdev->dev, "failed to request gpio: %d\n", error);
 		return error;
 	}
 	gpiod_set_consumer_name(reset_gpio, "pci_reset");
-	gpiod_direction_output(reset_gpio, 1);
 
 	/* enable auto-switching between PCI and EBU */
 	ltq_pci_w32(0xa, PCI_CR_CLK_CTRL);
@@ -194,10 +194,10 @@ static int ltq_pci_startup(struct platfo
 
 	/* toggle reset pin */
 	if (reset_gpio) {
-		gpiod_set_value_cansleep(reset_gpio, 0);
+		gpiod_set_value_cansleep(reset_gpio, 1);
 		wmb();
 		mdelay(1);
-		gpiod_set_value_cansleep(reset_gpio, 1);
+		gpiod_set_value_cansleep(reset_gpio, 0);
 	}
 	return 0;
 }


