Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5D86148FEB;
	Thu, 13 Jun 2024 12:04:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280245; cv=none; b=LiwtUwTS1SurfOcfbRptyptI2YskGOJvMHdjAAbaQQSKnHuEjNVDOhbUR6oN0/hd1DBJ3z9CBpMGQoBPFyi9/z9pIvPK9qNzK//OcZT/Q+66Yht7yFt9RQlziCvDCBwIRHtQo6TeOiFXXH3I8QLMKFB+D9ETW+o+5FzKmdvR+gY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280245; c=relaxed/simple;
	bh=GttNBXVhwFq9aq5g1wYGviZpLEcktvdQgTVVdGaGjno=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UbFVCUQVtQ5u/RiKWzt32+W4q94GESszMzIGYPxD/w+iPdqrp3phHAvL9o8mXsWm+Wz2N/vNZd5W55Zb6cAoML6R4zZng8JXLMoL9IkJl6AieHVzYaaTli6z8dY+wv4pe/tpjdrGftLOxNyxWKdT4djfSHE2udsN3MQeMbWQJ+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OVvpsRXC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OVvpsRXC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CC7BC2BBFC;
	Thu, 13 Jun 2024 12:04:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280245;
	bh=GttNBXVhwFq9aq5g1wYGviZpLEcktvdQgTVVdGaGjno=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OVvpsRXCYGSWPcVNu7uhFOw0viIa8Hpz8/WITbM9uer4cef1/XlunINVImWbfDL41
	 T5pWasK/Clu5BHoyOhLrhSMSTvDJEijE8X6UZAyeCtxTe8Jzjs4vT88uYNZY2Rgmq9
	 c3IwLqH64kTzp4H3evW09DqytSTwm3NFGaR8fJxo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 160/202] spi: stm32: Dont warn about spurious interrupts
Date: Thu, 13 Jun 2024 13:34:18 +0200
Message-ID: <20240613113233.922000020@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.759341286@linuxfoundation.org>
References: <20240613113227.759341286@linuxfoundation.org>
User-Agent: quilt/0.67
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit 95d7c452a26564ef0c427f2806761b857106d8c4 ]

The dev_warn to notify about a spurious interrupt was introduced with
the reasoning that these are unexpected. However spurious interrupts
tend to trigger continously and the error message on the serial console
prevents that the core's detection of spurious interrupts kicks in
(which disables the irq) and just floods the console.

Fixes: c64e7efe46b7 ("spi: stm32: make spurious and overrun interrupts visible")
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Link: https://msgid.link/r/20240521105241.62400-2-u.kleine-koenig@pengutronix.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-stm32.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi-stm32.c b/drivers/spi/spi-stm32.c
index e843e9453c71c..759c502b094da 100644
--- a/drivers/spi/spi-stm32.c
+++ b/drivers/spi/spi-stm32.c
@@ -927,7 +927,7 @@ static irqreturn_t stm32h7_spi_irq_thread(int irq, void *dev_id)
 		mask |= STM32H7_SPI_SR_TXP | STM32H7_SPI_SR_RXP;
 
 	if (!(sr & mask)) {
-		dev_warn(spi->dev, "spurious IT (sr=0x%08x, ier=0x%08x)\n",
+		dev_vdbg(spi->dev, "spurious IT (sr=0x%08x, ier=0x%08x)\n",
 			 sr, ier);
 		spin_unlock_irqrestore(&spi->lock, flags);
 		return IRQ_NONE;
-- 
2.43.0



