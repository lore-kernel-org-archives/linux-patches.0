Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C15636B93B;
	Sat, 17 Oct 2026 16:20:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254042; cv=none; b=IGb3/msRLa9wQiAD82W3EIH0uXBVhthG9/uPD0xBy5n9AeOD0qD8T9TRG77cCQHcLwG5IDtnoONrZnPOetCqKZ7OHNdh+SolOLuXk49yQtFGEYx/HtVC7eAm0NzgKRT2hlPzNpxhqN2DvzLE6KyBqlzXshFrQifQ22hlGyxwQso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254042; c=relaxed/simple;
	bh=OQ1fFDZwUQxzXNeNxNR8bGJ569AAWvM4jJf3GM7pC0o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ElI+56e1zAIRRXpbSbp1EZxRuH6Q4MPgn7je5UIDOh+pkTfZwzaNVrSRjc5WL3uVVDAjVwK0VU0D6d129fENA43ZpiRGkofJsNcNlx7Z8G/ritvPjbCHpKjaHWEXPHwz57S5eFrZ8bXk9NWrMxHxLz2zbsl7NanU2UxV9IWuB0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kt1qM3S2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kt1qM3S2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B867E1F000C4;
	Sat, 17 Oct 2026 16:20:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254041;
	bh=CZYnJl+qFO2R43NbvhFI2ncNQxarpEhAMwRalhmc7+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Kt1qM3S2dkqVRNq+tGrNTpc01yxMNh0EY8h1UeHyrEbS8Uq1W6MzkpCsRoyUv8s+k
	 ulqJ3cin2XxYzm+022TYsWUHVr69vLxUXRP9QZlCTHOBxDfCZrI3VNLDqly0DTKQFa
	 L5Ht9Yp2g+YzJ1Ik3Gj/x4xmwxVvBSfYlszvKOfo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Conor Dooley <conor.dooley@microchip.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 289/869] spi: microchip-core-qspi: set min_speed_hz during probe
Date: Sat, 17 Oct 2026 17:52:10 +0200
Message-ID: <20261017160044.483869131@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Conor Dooley <conor.dooley@microchip.com>

[ Upstream commit 76f03ce1c6f22805ecf689b1f3ecfb56582eddd5 ]

The controller's minimum possible bus clock is 1/30 the rate of the
input clock. Naively set the minimum bus clock speed the controller
is capable of during probe, assuming that the rate will never reduce
further.

Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
Link: https://patch.msgid.link/20250620-drained-widen-ac311bd5f172@spud
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 7672749e1496 ("spi: microchip-core-qspi: control built-in cs manually")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-microchip-core-qspi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/spi/spi-microchip-core-qspi.c b/drivers/spi/spi-microchip-core-qspi.c
index bda9a43dbf2ef..8bce9aeb259a4 100644
--- a/drivers/spi/spi-microchip-core-qspi.c
+++ b/drivers/spi/spi-microchip-core-qspi.c
@@ -562,6 +562,7 @@ static int mchp_coreqspi_probe(struct platform_device *pdev)
 	ctlr->mode_bits = SPI_CPOL | SPI_CPHA | SPI_RX_DUAL | SPI_RX_QUAD |
 			  SPI_TX_DUAL | SPI_TX_QUAD;
 	ctlr->dev.of_node = np;
+	ctlr->min_speed_hz = clk_get_rate(qspi->clk) / 30;
 
 	ret = spi_register_controller(ctlr);
 	if (ret)
-- 
2.53.0



