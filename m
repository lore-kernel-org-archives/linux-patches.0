Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D7C33403F4;
	Wed, 20 May 2026 17:06:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296771; cv=none; b=FcTN/0xsqt3LiYMGRw+Rsw6iaL9gHUUMDfyEzz3qvuucjnSXtEioBWi0DJDWyjO58bhSF3sEKY5VJJebwTSjH0zkq97U+zUyrfNClSxP39l9uQ88T8TmJz+JUvZaZs2Zmvbk/TujrjKx3bJiJ9km6lTbcQiQuHkCYIfXjgni0ug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296771; c=relaxed/simple;
	bh=b5exD2yXQ/GM2xVHbWHIy3BMeTzt/0qukbRwybug9F8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FXVZ2RDRTTNQIoyWt5xQ6cjppE7nmIsX94UQHXxVB2rTFwG1aKGGMUcVw/mJZJLajaOoQl6stVdHaW9W1dJCzeLLZ27g5BDAaU1T/0Csd83jMtHz2TLojovD4WYMqCFe8AoRMpv1xRjigolWUiSzbJeU96k7FrwnQn5QXmh+Bmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hEitOtvq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hEitOtvq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30D681F000E9;
	Wed, 20 May 2026 17:06:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296769;
	bh=HKoEKbi0qkQAHNWtiFtFeQwM6XNpnZr2yMV0Vw6X9lA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hEitOtvquK4vGgjKLqPOeHirF6Tfr0a6F2RB1cslc0XkXxsV8CcxxclOrYYf4H36M
	 Fu5NkMn7e0gLsoxEtP69MU7Zz+9vzxPm6MsH/ru7tNuMYa56H0UaCE4nFTGW4/kZZK
	 Q7I3zbRXaTxY8cJJ7Z42qRMUMVl6hTomnQHkXzn4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0926/1146] spi: axiado: replace usleep_range() with udelay() in IRQ path
Date: Wed, 20 May 2026 18:19:36 +0200
Message-ID: <20260520162209.195306867@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Gu <ustc.gu@gmail.com>

[ Upstream commit f5c6a272b699b9a0698535e1a56e683207e50030 ]

ax_spi_fill_tx_fifo() can be called from ax_spi_irq() which is a hard
irq handler. Replace usleep_range(10, 10) with udelay(10) in atomic
context.

Fixes: e75a6b00ad79 ("spi: axiado: Add driver for Axiado SPI DB controller")
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Link: https://patch.msgid.link/20260428-axiado-v1-1-cd767500af72@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-axiado.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi-axiado.c b/drivers/spi/spi-axiado.c
index dc55c55ae63c8..2cefc8917b710 100644
--- a/drivers/spi/spi-axiado.c
+++ b/drivers/spi/spi-axiado.c
@@ -201,7 +201,7 @@ static void ax_spi_fill_tx_fifo(struct ax_spi *xspi)
 		 * then spi control did't work thoroughly, add one byte delay
 		 */
 		if (ax_spi_read(xspi, AX_SPI_IVR) & AX_SPI_IVR_TFOV)
-			usleep_range(10, 10);
+			udelay(10);
 		if (xspi->tx_buf)
 			ax_spi_write_b(xspi, AX_SPI_TXFIFO, *xspi->tx_buf++);
 		else
-- 
2.53.0



