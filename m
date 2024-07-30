Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C681156F30;
	Tue, 30 Jul 2024 17:00:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358847; cv=none; b=tgpi9JdDT0zIN0A2v7rcpI6XqD4LYuPFtcek2hh3LHjRAPAlslf1eGlrX7KGhC8SXz8j2g6L2LgUnDOXzl66UmWemgzetRD5Eml0rCiGqupSiUF9rxNqfC57T4AsAIGe/DfFM9B0jM6ZtCCqkQQQ6nONVAl9yrg6qxGyHT2P94M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358847; c=relaxed/simple;
	bh=mKscQO2xYEsYfI1DW0T2D53skK1EmJWDq+jngWmlHyw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=blHA1YMN9KsA8UsNIrt+k3tUL7UVGwl4t8FfRoOcN9Erm3QKm/foGr6+3AUxkxbzcr4hRkLtldflpnA86wXloIKB5ZoIJt1LinXN6vifXyiNDHeGLiCXGoVUZaDQz1OqZmoH5bQTQQ4uqCWsn0KHdwhNnZ/G6gSGHZ+INrzeqa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oN1JX6d5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oN1JX6d5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10C86C32782;
	Tue, 30 Jul 2024 17:00:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358847;
	bh=mKscQO2xYEsYfI1DW0T2D53skK1EmJWDq+jngWmlHyw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oN1JX6d5Lkxvdn6PVP03/gCc9JHG/hGrZ7B+nLpE4/dty69/3sVgO8yFRr36bfUJZ
	 Z5MplZ0n1sUXtSzRHMqeBZF3IASOUkYGVzMv0qXjP+CsgmhoklIr51JykqynnVQqO3
	 ZxDf7y4a4uRA5Nti2sibw9s/0640hX8UC1qP5ABw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steve Wilkins <steve.wilkins@raymarine.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 427/440] spi: microchip-core: fix init function not setting the master and motorola modes
Date: Tue, 30 Jul 2024 17:51:00 +0200
Message-ID: <20240730151632.458718078@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

From: Steve Wilkins <steve.wilkins@raymarine.com>

[ Upstream commit 3a5e76283672efddf47cea39ccfe9f5735cc91d5 ]

mchp_corespi_init() reads the CONTROL register, sets the master and
motorola bits, but doesn't write the value back to the register. The
function also doesn't ensure the controller is disabled at the start,
which may present a problem if the controller was used by an
earlier boot stage as some settings (including the mode) can only be
modified while the controller is disabled.

Fixes: 9ac8d17694b6 ("spi: add support for microchip fpga spi controllers")
Signed-off-by: Steve Wilkins <steve.wilkins@raymarine.com>
Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
Link: https://patch.msgid.link/20240715-designing-thus-05f7c26e1da7@wendy
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-microchip-core.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/spi/spi-microchip-core.c b/drivers/spi/spi-microchip-core.c
index a5173d820ac2e..bfad0fe743ad7 100644
--- a/drivers/spi/spi-microchip-core.c
+++ b/drivers/spi/spi-microchip-core.c
@@ -289,17 +289,13 @@ static void mchp_corespi_init(struct spi_controller *host, struct mchp_corespi *
 	unsigned long clk_hz;
 	u32 control = mchp_corespi_read(spi, REG_CONTROL);
 
-	control |= CONTROL_MASTER;
+	control &= ~CONTROL_ENABLE;
+	mchp_corespi_write(spi, REG_CONTROL, control);
 
+	control |= CONTROL_MASTER;
 	control &= ~CONTROL_MODE_MASK;
 	control |= MOTOROLA_MODE;
 
-	mchp_corespi_set_framesize(spi, DEFAULT_FRAMESIZE);
-
-	/* max. possible spi clock rate is the apb clock rate */
-	clk_hz = clk_get_rate(spi->clk);
-	host->max_speed_hz = clk_hz;
-
 	/*
 	 * The controller must be configured so that it doesn't remove Chip
 	 * Select until the entire message has been transferred, even if at
@@ -308,11 +304,16 @@ static void mchp_corespi_init(struct spi_controller *host, struct mchp_corespi *
 	 * BIGFIFO mode is also enabled, which sets the fifo depth to 32 frames
 	 * for the 8 bit transfers that this driver uses.
 	 */
-	control = mchp_corespi_read(spi, REG_CONTROL);
 	control |= CONTROL_SPS | CONTROL_BIGFIFO;
 
 	mchp_corespi_write(spi, REG_CONTROL, control);
 
+	mchp_corespi_set_framesize(spi, DEFAULT_FRAMESIZE);
+
+	/* max. possible spi clock rate is the apb clock rate */
+	clk_hz = clk_get_rate(spi->clk);
+	host->max_speed_hz = clk_hz;
+
 	mchp_corespi_enable_ints(spi);
 
 	/*
-- 
2.43.0



