Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D589F242EE4;
	Thu, 12 Dec 2024 15:59:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019157; cv=none; b=jHocbfzlY2Z7g3X6nSFTwEBOQ9Yrwmb2jMsioSdM0/pZECzY7kzP51XHhlf1QMNyvvRyp2++NwftPXMLXhaRK5BeRRPZk2Bk6Ts/AMVfl3O0XqNoQ+3KgG0WgYkB8QbFybMhGgWq7jgn/G6NEPmMh2R5rroUicLjJQhKppTwd8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019157; c=relaxed/simple;
	bh=pWihQ5OXIOlpQzm/vcyNVZwh56ab7RXKhWNDfb2mAmk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=grEKd9onDuO5Oj7fULg8qjJZAbfObIp5Naqavgv6itolkm6Y034Xt0Iu86r06HhrLx5fUb1/0/0isVHZst/IUfye0iumuXYNHlXsIr+GwVLvoNB2LV+kKGhhao2/XF59vbI3wAQVeUv52YhVAmzPe/PBHeR27pI7CXLIZ5wx7IM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bVix5v94; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bVix5v94"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00DACC4CEFC;
	Thu, 12 Dec 2024 15:59:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734019157;
	bh=pWihQ5OXIOlpQzm/vcyNVZwh56ab7RXKhWNDfb2mAmk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bVix5v94ZGboQJbzTahuEmb4rnjeye+xcUUsjstzyzaQGZsNQQW5MzABedRXz7/CI
	 2Hqs4OwjGBNg7jZYGoN+9V8uT60jKR1GL+9oAbzmPY2oboPJyGrBAjHaWP/RmXAcVX
	 Z6XhaUp8IipqkUD5E2qx8cPAqXqeprTKqo8bzBA4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 134/772] wifi: p54: Use IRQF_NO_AUTOEN flag in request_irq()
Date: Thu, 12 Dec 2024 15:51:19 +0100
Message-ID: <20241212144355.469701518@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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
index 19152fd449ba7..6fc694e8b7f80 100644
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



