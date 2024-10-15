Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66E961C07DF;
	Tue, 15 Oct 2024 13:10:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997846; cv=none; b=Jhool8LfdKJmA1H2oniuQNFxl0LnSQEvD0EMSpSd+97DyfwhG6jypMxFt6qsRnKtiCk0zEq+hrRLtMMnYUtOmMCY4C8/lcshWrELXWyqFJyz1cCb9F5zgrD0CkEHWud7d0+3If6XisgAqMNB01iV/TXC1i2HkybzfpjCGcdwTak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997846; c=relaxed/simple;
	bh=AHhQCh/G+jvIePIpxFE0/nDNVN0kjw6yySAzi+u8u7Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ges/HWiN2VTHPLiCl7H3mlxaKmMwvQFBciuvt7HVPgsKcewxkTbe+jt9z99A0JF6yv0wENT2P8gp0JU/Y+jnjhe7T8vlexIlKlp3xemcG98Ak99MuNRVdMJHtCAH4NfSzN0L0cQMgChNPLc9NMvNGaWn8neDcX2PdeA/7JwS/IY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k71To6qB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k71To6qB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D77E8C4CEC6;
	Tue, 15 Oct 2024 13:10:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997846;
	bh=AHhQCh/G+jvIePIpxFE0/nDNVN0kjw6yySAzi+u8u7Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k71To6qBaeAwQH2fiDjWQVF5lzFUb2pN26yH4ulI4OY+i6CUgBu47+gk6CTt76f5P
	 Hvun5+2zpm3Hpf+JH5LLVzAJWoO1CPhvYF7TntwrdetG0S/fFpf2P1LOA7r+feqSRN
	 Gx+uP5mmPcYVWRE5cKrRLbZwxwjvCgPqRJR8/wHU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Stefan Schmidt <stefan@datenfreihafen.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 273/518] net: ieee802154: mcr20a: Use IRQF_NO_AUTOEN flag in request_irq()
Date: Tue, 15 Oct 2024 14:42:57 +0200
Message-ID: <20241015123927.531457134@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 383231b854642..16474990dc01e 100644
--- a/drivers/net/ieee802154/mcr20a.c
+++ b/drivers/net/ieee802154/mcr20a.c
@@ -1311,16 +1311,13 @@ mcr20a_probe(struct spi_device *spi)
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



