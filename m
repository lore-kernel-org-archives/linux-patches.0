Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6833198E74;
	Thu,  6 Jun 2024 14:11:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683077; cv=none; b=dbCWoMKcdNjD8bsb0cvyIG1eOUIad5Yhc2ZHWGkljivYA/o0lv1Vz5R26h7txoqrft5MzOr7JQYus0HWRfSEftsGGmwe/bHm4UKoxCJjKNGh+bI5eYDBplywC1ETrFe8e/aDAUXMj+Y9Adk8b7PYlApaFeHkAGw7zSdPoTm5fWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683077; c=relaxed/simple;
	bh=+NPDw7O5pxpK9qFRLtapfJCRZbyKWf9sPADqj5j6R/U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VsrR7ZI9S3s8nUA/zM7r6l1O6IKymTP/XrbtQjYpmvtDpI23+2PRco4XVfq7Djz6MpqTSLsLd2ICUSI5bYJEX0wnYak17rGfiM43oh9B3dEeXX1GeufT/q/17T9aTPZilc0AmohJh3x/NC9kZFAgwD8+TrHZtRw9PJajsARNjqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a8PCXEHL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a8PCXEHL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49753C4AF11;
	Thu,  6 Jun 2024 14:11:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683077;
	bh=+NPDw7O5pxpK9qFRLtapfJCRZbyKWf9sPADqj5j6R/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a8PCXEHLKpJ1yMErG6iys5Hg2NuttJCPpl+PqWGOsPEby9rT02yb4edYirphFipnG
	 efQGIW2DBe/a70/CBfQTGLXdjvoHXkIwKcZyZmDbmFl3mfrriQFNfq3ja6Y2xvF9ZX
	 AVvbA9C7jRYl7wMOC3DPG1cVsyd1nRZKZsjh0lew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 344/374] spi: stm32: Dont warn about spurious interrupts
Date: Thu,  6 Jun 2024 16:05:23 +0200
Message-ID: <20240606131703.376807285@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index e4e7ddb7524a9..4c4ff074e3f6f 100644
--- a/drivers/spi/spi-stm32.c
+++ b/drivers/spi/spi-stm32.c
@@ -1057,7 +1057,7 @@ static irqreturn_t stm32h7_spi_irq_thread(int irq, void *dev_id)
 		mask |= STM32H7_SPI_SR_TXP | STM32H7_SPI_SR_RXP;
 
 	if (!(sr & mask)) {
-		dev_warn(spi->dev, "spurious IT (sr=0x%08x, ier=0x%08x)\n",
+		dev_vdbg(spi->dev, "spurious IT (sr=0x%08x, ier=0x%08x)\n",
 			 sr, ier);
 		spin_unlock_irqrestore(&spi->lock, flags);
 		return IRQ_NONE;
-- 
2.43.0



