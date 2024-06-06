Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC64C1A01DE;
	Thu,  6 Jun 2024 14:20:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683643; cv=none; b=kEUgf9/DubvQ/OD4NEa8N/FESXuN3gJqhlP5HuS8GJCn/BUz9Ar3DWmHWLN6D0ziULwO5oZ4TQS35dtiivcj5T5Hxstcmtu1Ki2G1nRVUiz0YBhq+WUD8XvoDfAA7rGGsEQ8PR/5x7P7V4JvIvtKB3dy0lUdy8XoxQk7RvicfkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683643; c=relaxed/simple;
	bh=SI2P0sppquuw/Gc87xQ7lpv8tR7kQ/GF1/ow+Fk7rK8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TGdDRKPPa1gZDrOLul1q0EW1sBVqSf7Erbei6ZGpgUa2kIHR5QyHZcum9LgEzuNUGBKMfqICPzIVqLQ590dlFtHd5XW7h7+lFYgc33MNZIh4Jqh+jjZJbnGvkEW60YKNGIDsitlEh0CVYWwjy2VXeqTcfawXXXHq36Dlg5sxUTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O07z8aIF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O07z8aIF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 899E6C32782;
	Thu,  6 Jun 2024 14:20:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683643;
	bh=SI2P0sppquuw/Gc87xQ7lpv8tR7kQ/GF1/ow+Fk7rK8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O07z8aIFipl1s0A+M64/NqOG3SPVo0yDiUTcqr7t44mLywgy+GJZBqGh8DtQshX8L
	 EDsvAvyOKpRwaZZiJv9X/5In+JDkRlwo/D6OBXZA8z1D0ZXS86cp8mTH2dGjKIVB7z
	 hpqipcZhedcRqB+s95fUGfy6x9nWhtumxiUanYfA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 463/473] spi: stm32: Dont warn about spurious interrupts
Date: Thu,  6 Jun 2024 16:06:32 +0200
Message-ID: <20240606131714.988119409@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 12241815510d4..c37d557f7d03c 100644
--- a/drivers/spi/spi-stm32.c
+++ b/drivers/spi/spi-stm32.c
@@ -884,7 +884,7 @@ static irqreturn_t stm32h7_spi_irq_thread(int irq, void *dev_id)
 		mask |= STM32H7_SPI_SR_TXP | STM32H7_SPI_SR_RXP;
 
 	if (!(sr & mask)) {
-		dev_warn(spi->dev, "spurious IT (sr=0x%08x, ier=0x%08x)\n",
+		dev_vdbg(spi->dev, "spurious IT (sr=0x%08x, ier=0x%08x)\n",
 			 sr, ier);
 		spin_unlock_irqrestore(&spi->lock, flags);
 		return IRQ_NONE;
-- 
2.43.0



