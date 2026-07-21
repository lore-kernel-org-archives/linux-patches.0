Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1954D471243;
	Tue, 21 Jul 2026 19:06:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660802; cv=none; b=bmcqyanDN2IKVBPwGSdhmV+OdfGauqx2RPQrhH8STDS5velR9/cfCcigrxEiw4dAP5wIHqbXiX5EFj3ryf2bVGs4UcfKiW4CggnbFO08vZsD0PoDE6L+b89PGQ3fRkFtIWbxtfLBY93/ujhr9C1Bj83m/7hBBerYdZW8bkh/xCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660802; c=relaxed/simple;
	bh=Q6v84aocTTj5Zldy24ct0XR/vUWtZvUaw1FGeHMAxqw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Frp3zAWrKl5YAUffuUAIn+RsN0Cv5q2L8ErVoS4Gkr4o/ETNZE3oVp2BIN7V6A4RvRwCqBf5AROqIe63EeixLuaf4+kzPkmE1rvkh+Z8bzesXz4iAaxK4o7u5Sa05XtyObrZFHl9Ez4MPiYyOlUxe7frrFa4JNe9OgFt+t15HOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Evmorpve; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Evmorpve"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E1B01F000E9;
	Tue, 21 Jul 2026 19:06:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660801;
	bh=xWTdY6gNwZCZBcLXVES0xA4vrCq7Vg/rFKXJyjmQHBg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Evmorpve6WoIu54YBKIQfmIVWnhoXjP0OdDotK63Eu3dEZl3L9nCtwJWWPk9m33NJ
	 +tVQuP8a8zaEnJJtoamIai2NS5OqftouQRbzaCOGMRtQARyd77cWiHbgL6cvxNuFHq
	 NNFhqL0R3nzKNmrgS0+7431IdMmeySNQPZPW2rnk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quang Nguyen <quang.nguyen.wx@renesas.com>,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1118/2077] spi: rpc-if: Use correct device for hardware reinitialization on resume
Date: Tue, 21 Jul 2026 17:13:11 +0200
Message-ID: <20260721152619.190483273@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Quang Nguyen <quang.nguyen.wx@renesas.com>

[ Upstream commit 7b25dbafa2fce50b1a48c1d057adb35da3563f9b ]

rpcif_spi_resume() currently passes the SPI controller device to
rpcif_hw_init(), but the function should be called with the RPC
interface device.

Retrieve the rpcif private data from the SPI controller and pass
rpc->dev instead. Also propagate the return value of rpcif_hw_init() so
that a failure during resume is properly reported rather than silently
ignored.

Fixes: ad4728740bd6 ("spi: rpc-if: Add resume support for RZ/G3E")
Signed-off-by: Quang Nguyen <quang.nguyen.wx@renesas.com>
Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://patch.msgid.link/20260618081932.172168-1-biju.das.jz@bp.renesas.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-rpc-if.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-rpc-if.c b/drivers/spi/spi-rpc-if.c
index 6edc0c4db854db..c2f9c86c1d8d4f 100644
--- a/drivers/spi/spi-rpc-if.c
+++ b/drivers/spi/spi-rpc-if.c
@@ -206,8 +206,12 @@ static int rpcif_spi_suspend(struct device *dev)
 static int rpcif_spi_resume(struct device *dev)
 {
 	struct spi_controller *ctlr = dev_get_drvdata(dev);
+	struct rpcif *rpc = spi_controller_get_devdata(ctlr);
+	int ret;
 
-	rpcif_hw_init(dev, false);
+	ret = rpcif_hw_init(rpc->dev, false);
+	if (ret)
+		return ret;
 
 	return spi_controller_resume(ctlr);
 }
-- 
2.53.0



