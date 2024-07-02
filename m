Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9D6A63D;
	Tue,  2 Jul 2024 17:32:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719941529; cv=none; b=Fyz0ebkk1RXWEEHsGH08Nvzmnl4oHU9aXMblOE0tGH+wCFw0huNdV9YplBngaMk5tdox7STpWer2+XHwRXKVkJxJk+u8Vsfz0B69yj7ANZI8f7anHPd7+78hctP5Cz5fJzikVi/SIKT9FzbZzaYFCeUkWksRs3Jx05UiIab1zeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719941529; c=relaxed/simple;
	bh=8a5dx8GlvgdaqbP0b8adJtJUSRQ5aYGW1ik4THe+Cwc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=la+TzjRNQFq0+Yh/pYMwHhZll9NpRGT5XG9ASqkr123RatrAOBa71ntW5QfmfMoBOIbvnnIHQVyjh/5Lhb7JxhCJz/H99Cax25wqjVoU/R1Uw5j8ho2KveSB7VeVEg8reFyLHv9S4NkqEC9A60h5+Fmg+rfr4/CB2cmtmNT0wD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CGkkkS8C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CGkkkS8C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F2AFC116B1;
	Tue,  2 Jul 2024 17:32:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719941528;
	bh=8a5dx8GlvgdaqbP0b8adJtJUSRQ5aYGW1ik4THe+Cwc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CGkkkS8CBuuB/XO+iUr6v7JBa2LwNVmGpc1EbxxkoUIBuMYdrnxcHC/cx9/LjJaYG
	 4bdoB9V+57isIzCi9mPv0mrvqaIxjOERWQ1jdq/bT7FOqQcujRoR0UoMyW6YeYuRLi
	 WxOQ4sFKo246YofJD9a1Gcd1ALPa2dZa3ZLcx4Cg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 6.1 064/128] Revert "MIPS: pci: lantiq: restore reset gpio polarity"
Date: Tue,  2 Jul 2024 19:04:25 +0200
Message-ID: <20240702170228.652728858@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170226.231899085@linuxfoundation.org>
References: <20240702170226.231899085@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


