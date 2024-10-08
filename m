Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C6A81C9DDF;
	Tue,  8 Oct 2024 13:09:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392982; cv=none; b=qwnQqty0skt2Dl1rk9JGZvZGmkrPabd+om766+7zHqTW1kw97B+w55Xg3E/T3WWBAj0gIrozDQuPcWeQ4fXsw8XLb62JapKhG3+ec2AvEDWdREXw9ObVm/8rdUno1MeJQtWd6TSX1vqoQb5+feT5u6cPkbioBfRX3a3aX4qvJHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392982; c=relaxed/simple;
	bh=9URjn7JKuJZYGFaJLMZ1zRZkHuseKqDwZ4l9UI8R92o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KXV2GznUllUihRtnFlmljwAF6N6vWrAhJvQ6xlC/vPEtdJgvCd/GMDzKiR43uK+XwWYukjgINRy4MlJMhvHdLn3Rc2rk5K8ywlHG2P4uvDzKQTEmIneSrFVRrcY/o0NRXltf1X9H36hisBXss9iTK9M4Otly3Dbc/qayxAqNlx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h3EeQJff; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h3EeQJff"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53CDFC4CEC7;
	Tue,  8 Oct 2024 13:09:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392981;
	bh=9URjn7JKuJZYGFaJLMZ1zRZkHuseKqDwZ4l9UI8R92o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h3EeQJfffcMd8az0zv5t9cIy+Q/DArlcglQXetySb3Lcs/SNyhQudqwg7d0SC+u63
	 SVi3klNbj/HJgxkDakwIRU8ZU9aDcw/MGCgx4rDRJMsczXMB8Mt7qHi55Nx6OtnScE
	 daf+hrekEzQqpiJ2SZQTxcCCXQ3bW4eC7IygItxo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Stefan Schmidt <stefan@datenfreihafen.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 018/386] net: ieee802154: mcr20a: Use IRQF_NO_AUTOEN flag in request_irq()
Date: Tue,  8 Oct 2024 14:04:23 +0200
Message-ID: <20241008115630.041567337@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 87abe3b46316e..bab92f19c4f48 100644
--- a/drivers/net/ieee802154/mcr20a.c
+++ b/drivers/net/ieee802154/mcr20a.c
@@ -1303,16 +1303,13 @@ mcr20a_probe(struct spi_device *spi)
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



