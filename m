Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB2F7205501;
	Thu, 12 Dec 2024 17:17:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023842; cv=none; b=HcxzlEGep2MnvFwQR5iAvfxd1r65Y3Zh2K+HgfxlP15l1gRnCLbYmMytNoNJlKIBmVFAOmSD2DGeFNrO7VI+DQy0oE2/Lbs9BJLEJjZEqNVSNqz2d4OzB7EO9/34V3RVbpeYHfEzRYwAcGYYRbMRhl6wrhKlZVuLk4y8cZlu1IE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023842; c=relaxed/simple;
	bh=hXmffrSAEvRe6Dc6IoC31r608eiLzrt7GYh02+3NA9w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MSLfX2V3JoXolBE6FIT7x+bIjLeuHEz2ni+WNyOPfxgVtaah9imFG3f0Tq+MJfRmQ7E+I3MmXWm5NAWXDhx58P95/jwGIHKoaH9VBy40GVb8w/Z6NlafGFd2O7p07X2tz/CQwNZZRB/exNcfz2MMOIYNuCY7qgushetQgIY++0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xn58DjQ+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xn58DjQ+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A139C4CECE;
	Thu, 12 Dec 2024 17:17:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023842;
	bh=hXmffrSAEvRe6Dc6IoC31r608eiLzrt7GYh02+3NA9w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xn58DjQ+YzoStpRoVT4oadia2qtAtJsepPtpPeDCSKW9MOr/h9v8ayHFl2rPddozL
	 PFSHqs0CiLggQVuDjsXn3SBiUQjAYROAvlqr7aXSOt49O/thpPLb8bRzIQq6fRckdb
	 DXA/CW6ApJRaFJo34NM2Hq2swmBbsg/S27B9lLjg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 101/459] wifi: p54: Use IRQF_NO_AUTOEN flag in request_irq()
Date: Thu, 12 Dec 2024 15:57:19 +0100
Message-ID: <20241212144257.502961762@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

[ Upstream commit bcd1371bd85e560ccc9159b7747f94bfe43b77a6 ]

disable_irq() after request_irq() still has a time gap in which
interrupts can come. request_irq() with IRQF_NO_AUTOEN flag will
disable IRQ auto-enable when request IRQ.

Fixes: cd8d3d321285 ("p54spi: p54spi driver")
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://patch.msgid.link/20240910124314.698896-2-ruanjinjie@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intersil/p54/p54spi.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intersil/p54/p54spi.c b/drivers/net/wireless/intersil/p54/p54spi.c
index cdb57819684ae..8a9168aac7281 100644
--- a/drivers/net/wireless/intersil/p54/p54spi.c
+++ b/drivers/net/wireless/intersil/p54/p54spi.c
@@ -623,7 +623,7 @@ static int p54spi_probe(struct spi_device *spi)
 	gpio_direction_input(p54spi_gpio_irq);
 
 	ret = request_irq(gpio_to_irq(p54spi_gpio_irq),
-			  p54spi_interrupt, 0, "p54spi",
+			  p54spi_interrupt, IRQF_NO_AUTOEN, "p54spi",
 			  priv->spi);
 	if (ret < 0) {
 		dev_err(&priv->spi->dev, "request_irq() failed");
@@ -632,8 +632,6 @@ static int p54spi_probe(struct spi_device *spi)
 
 	irq_set_irq_type(gpio_to_irq(p54spi_gpio_irq), IRQ_TYPE_EDGE_RISING);
 
-	disable_irq(gpio_to_irq(p54spi_gpio_irq));
-
 	INIT_WORK(&priv->work, p54spi_work);
 	init_completion(&priv->fw_comp);
 	INIT_LIST_HEAD(&priv->tx_pending);
-- 
2.43.0



