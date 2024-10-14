Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BD1E1A76A5;
	Mon, 14 Oct 2024 15:11:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918684; cv=none; b=Ner6G25g1pae6U83ItXXXVRB4Bif8OYiCdUHSGwlhPDAsUpZmra3QcSpoReCV4JDGE9/pDSDlU6/21vQDoXWb+ILy8cdRr2DNuQDWLBOH45aNdNr0gAxkyMfRgyNv8HRcb+wJT0ts+5WAzNIttQCIVQahB+gNSnMTaa5oCf6Z8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918684; c=relaxed/simple;
	bh=Wr+7CDrG623tWsTZ3LCZhOaEqXQWrZBi7N4edjiCNWk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UrfUeSEDWE3GaLa7ywv7BxiGTCqKJJkUyCdwtkxR+wPbSsmMrOwKa8g6JRCxpvaq0cXxpKTwiCocr8tcHPHwXnq2a3Cev4gNnVwlM5bR0X7aAbDRlSu4+kXoiQhbYLI2t3UrDDrbQEZ8UVOV8yfKnngb8QCKhjYaQtf4LNpYo+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h66k20Vx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h66k20Vx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F778C4CEC3;
	Mon, 14 Oct 2024 15:11:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918683;
	bh=Wr+7CDrG623tWsTZ3LCZhOaEqXQWrZBi7N4edjiCNWk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h66k20VxfS7aUEBBawzjTsMWuNSMa/RnRMN3ueNmTpQlGVuq5nbQwqbSgx+8lki/n
	 xTC1SsdPRu+/I/C/czx8KkXlWJ6K6jyTCpBr3DdU2IKw45aDXpCWn5QGOHVN9aq2RH
	 Hw9cVaAs6ms8JgTNg/RDBh5kwT0mqyjLEZrC5Dt8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Stefan Schmidt <stefan@datenfreihafen.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 391/798] net: ieee802154: mcr20a: Use IRQF_NO_AUTOEN flag in request_irq()
Date: Mon, 14 Oct 2024 16:15:45 +0200
Message-ID: <20241014141233.305923297@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

From: Jinjie Ruan <ruanjinjie@huawei.com>

[ Upstream commit 09573b1cc76e7ff8f056ab29ea1cdc152ec8c653 ]

disable_irq() after request_irq() still has a time gap in which
interrupts can come. request_irq() with IRQF_NO_AUTOEN flag will
disable IRQ auto-enable when request IRQ.

Fixes: 8c6ad9cc5157 ("ieee802154: Add NXP MCR20A IEEE 802.15.4 transceiver driver")
Reviewed-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Link: https://lore.kernel.org/20240911094234.1922418-1-ruanjinjie@huawei.com
Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ieee802154/mcr20a.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/ieee802154/mcr20a.c b/drivers/net/ieee802154/mcr20a.c
index 2fe0e4a0a0c4c..2a03bc22ef535 100644
--- a/drivers/net/ieee802154/mcr20a.c
+++ b/drivers/net/ieee802154/mcr20a.c
@@ -1306,16 +1306,13 @@ mcr20a_probe(struct spi_device *spi)
 		irq_type = IRQF_TRIGGER_FALLING;
 
 	ret = devm_request_irq(&spi->dev, spi->irq, mcr20a_irq_isr,
-			       irq_type, dev_name(&spi->dev), lp);
+			       irq_type | IRQF_NO_AUTOEN, dev_name(&spi->dev), lp);
 	if (ret) {
 		dev_err(&spi->dev, "could not request_irq for mcr20a\n");
 		ret = -ENODEV;
 		goto free_dev;
 	}
 
-	/* disable_irq by default and wait for starting hardware */
-	disable_irq(spi->irq);
-
 	ret = ieee802154_register_hw(hw);
 	if (ret) {
 		dev_crit(&spi->dev, "ieee802154_register_hw failed\n");
-- 
2.43.0



