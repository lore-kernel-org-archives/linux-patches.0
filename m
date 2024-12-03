Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 708AF1F7561;
	Tue,  3 Dec 2024 15:43:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240636; cv=none; b=sSXNtENhmPD91Kr/BoekOIv0WmyiY1XmMgEJN2X1Tav8cD4CvRpY7V+mcOPJs9MlXLbLJfvzz7PsC4wURhd5ZqBvU6dTPbn5YwU1kUyoNYI8AkKVz8gm6nDUQ7r5L9gT9+SuJPKRlz3pnjdTvvR2+NwTC7ZGh6emGuWTj65QspI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240636; c=relaxed/simple;
	bh=q+O94rqs10RUVYphMT/kuta7acEEuPKYh4/4jaDTm3w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q3s3dZWC+/stvVdv0P23PDV7NniSAOPjYOv637P0jKptR39bGdi1NE5OASaXddhk27CSZ1tLMeo0//WWE9rrdm9NjlvGAVVtrrtZvvv2y1wxCYUw7WA1LxRzgpV+cph+bQHKJ1YglxZ6JOhVo5Fp8b6oJ8hM0oBuLZEM9SgB0xY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZCIuY0iO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZCIuY0iO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3E78C4CED8;
	Tue,  3 Dec 2024 15:43:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240636;
	bh=q+O94rqs10RUVYphMT/kuta7acEEuPKYh4/4jaDTm3w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZCIuY0iOTJsy/14wkw3Uql0TZBqJ8z9ZKDERGwHMYWQFJ9i13HtBcUjGMy97NLb7t
	 WRwO+WMP60MQ1WCZUgxolBtsROSO5iC/RND6fafJmVV7iyVj/9/mxQ6rWcwdEcBV9C
	 97K9MoVyoD8sMk+qR91WIhBbTQZTCVJ2Jldl8lRc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 193/826] wifi: p54: Use IRQF_NO_AUTOEN flag in request_irq()
Date: Tue,  3 Dec 2024 15:38:40 +0100
Message-ID: <20241203144751.276674287@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index d33a994906a7b..27f44a9f0bc1f 100644
--- a/drivers/net/wireless/intersil/p54/p54spi.c
+++ b/drivers/net/wireless/intersil/p54/p54spi.c
@@ -624,7 +624,7 @@ static int p54spi_probe(struct spi_device *spi)
 	gpio_direction_input(p54spi_gpio_irq);
 
 	ret = request_irq(gpio_to_irq(p54spi_gpio_irq),
-			  p54spi_interrupt, 0, "p54spi",
+			  p54spi_interrupt, IRQF_NO_AUTOEN, "p54spi",
 			  priv->spi);
 	if (ret < 0) {
 		dev_err(&priv->spi->dev, "request_irq() failed");
@@ -633,8 +633,6 @@ static int p54spi_probe(struct spi_device *spi)
 
 	irq_set_irq_type(gpio_to_irq(p54spi_gpio_irq), IRQ_TYPE_EDGE_RISING);
 
-	disable_irq(gpio_to_irq(p54spi_gpio_irq));
-
 	INIT_WORK(&priv->work, p54spi_work);
 	init_completion(&priv->fw_comp);
 	INIT_LIST_HEAD(&priv->tx_pending);
-- 
2.43.0



