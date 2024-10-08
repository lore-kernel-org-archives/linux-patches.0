Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E34F1779B1;
	Tue,  8 Oct 2024 12:39:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391161; cv=none; b=XW5XGTd6ye1aInLz18LSm2jL0MDFrPZgSKyM7K0mQpzC89DNe1vmC+gQPG9hIXWYVOuoGKRZd2Ry1K7Bx53kvyKoNFzbGc7tJZCpZ8oQ0xsLjw1D1BpIu6vqQkjh+Osw21edujCddQgdhvd2jRhFF5McC65EfIaJ+gxbLRnOUrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391161; c=relaxed/simple;
	bh=kWDr+t2m1ZLr40TUTGjiGMobZefTSqPOhAfYvxjeWSs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GxU3Dyb5SW21eU50pCwBPrKayP6Lse2srwMHkme6Og88cGYgoThpMPJdqHV/7WYcS/Ryyj0MA77geVQ6oXQoTC159ilsMnkWdPakAFdXdtbyTiSzh3eVHJLucHQJVXaC3l1tvUnpe4J90zSpRqNL6aMp1ffqlajF5rgiC7MfHJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JJHSRsHG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JJHSRsHG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC8E2C4CEC7;
	Tue,  8 Oct 2024 12:39:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391161;
	bh=kWDr+t2m1ZLr40TUTGjiGMobZefTSqPOhAfYvxjeWSs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JJHSRsHGVsLlUUb1TA1CwBNz49VUgdEqCdxdRrx2+whCgxSTZ0vzlHXG/Om5qqkXh
	 e485VnO7K4ET55DlCv2UttRR9ygQGrZMHkyb+DsrrGoWwbZSvugppbapQARmbKvtsV
	 l2lUkSW20dPjNHJQpal9DBlMCmwWZnn8408ueM7A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Stefan Schmidt <stefan@datenfreihafen.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 026/558] net: ieee802154: mcr20a: Use IRQF_NO_AUTOEN flag in request_irq()
Date: Tue,  8 Oct 2024 14:00:56 +0200
Message-ID: <20241008115703.252714276@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 433fb58392031..020d392a98b69 100644
--- a/drivers/net/ieee802154/mcr20a.c
+++ b/drivers/net/ieee802154/mcr20a.c
@@ -1302,16 +1302,13 @@ mcr20a_probe(struct spi_device *spi)
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



