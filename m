Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C5EA522A;
	Wed,  5 Feb 2025 14:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765607; cv=none; b=LK/2vxlDG2PLBT9v/gCMJTVuQLdwGtEht2d3liYBEWCe7nXRbMJdCTLWsonqXivi7qtXZ+0ZTgY5hHIUqzFK/2rRmpLy/lOgLtBhr8nX2sRqfXKqWMujjHG65oin6guco+xnBP5KrJ0/2sY34NhQm+slGvoH0FhGJll8EI13qds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765607; c=relaxed/simple;
	bh=Ian6/xWloESS1CtM6xfYLTCPHc2B4WENJAW3o9+J4TE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GZl5MRxRIbRbHbFuzxVFT7ei8qhrXHe4ApxSgT8Wt+gDR27V4DfQjJSCR6nD4ViWr9FV5WpTluGHzCULtuAbdQqFY1SAQ6dm5G66HyYEnxeuOK4iBFDdretZ6N9UcjzoGPjnFoBhG0YCDMMwIEnyKTu/jQKKoU3IvtdG4lkhVxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aVtmG8BQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aVtmG8BQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF520C4CED1;
	Wed,  5 Feb 2025 14:26:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765607;
	bh=Ian6/xWloESS1CtM6xfYLTCPHc2B4WENJAW3o9+J4TE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aVtmG8BQ96JaCNFXPBuONOdX01D9W/ktRuGA/ID1JfggQDdzmAgfyDCzRifCz4tMw
	 CU8SetzQzfZe7mdbsapuifsw/By5j8Jt4bDJBKK4ac37yBpTFAtxfduEmmhJoU/6f5
	 DpnJ/scwjiAz+kOS/6pDckWi1Ux0xY72GsqxxGl0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	=?UTF-8?q?Andr=C3=A9=20Draszik?= <andre.draszik@linaro.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 236/590] pinctrl: samsung: Fix irq handling if an error occurs in exynos_irq_demux_eint16_31()
Date: Wed,  5 Feb 2025 14:39:51 +0100
Message-ID: <20250205134504.310297574@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit f686a2b52e9d78cf401f1b7f446bf0c3a81ebcc0 ]

chained_irq_enter(() should be paired with a corresponding
chained_irq_exit().

Here, if clk_enable() fails, a early return occurs and chained_irq_exit()
is not called.

Add a new label and a goto for fix it.

Fixes: f9c744747973 ("pinctrl: samsung: support a bus clock")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: André Draszik <andre.draszik@linaro.org>
Link: https://lore.kernel.org/r/f148d823acfb3326a115bd49a0eed60f2345f909.1731844995.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/samsung/pinctrl-exynos.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/pinctrl/samsung/pinctrl-exynos.c b/drivers/pinctrl/samsung/pinctrl-exynos.c
index b79c211c03749..ac6dc22b37c98 100644
--- a/drivers/pinctrl/samsung/pinctrl-exynos.c
+++ b/drivers/pinctrl/samsung/pinctrl-exynos.c
@@ -636,7 +636,7 @@ static void exynos_irq_demux_eint16_31(struct irq_desc *desc)
 		if (clk_enable(b->drvdata->pclk)) {
 			dev_err(b->gpio_chip.parent,
 				"unable to enable clock for pending IRQs\n");
-			return;
+			goto out;
 		}
 	}
 
@@ -652,6 +652,7 @@ static void exynos_irq_demux_eint16_31(struct irq_desc *desc)
 	if (eintd->nr_banks)
 		clk_disable(eintd->banks[0]->drvdata->pclk);
 
+out:
 	chained_irq_exit(chip, desc);
 }
 
-- 
2.39.5



