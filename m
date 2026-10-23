Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792773887;
	b=yyu3KWNsfGlYEkCZVWQJRmyoBjaAUxCItKIJvWSwtnsMmRpZHOZJKEcg1nihGPgzdV82
	 as6wRI1AQNySPi1AXXvggjyuy5SeMJNxWFjq9k3AEsy4UW83e9/9vQ3DydbZi8KZZ01lH
	 hNvsDeNBZ70ylpWyCdw9BvNTJHfcIHMuD3SmQbxLC2A6yVgwD//Hn8afySeggD25YNnML
	 igESbh5tJvwIQgnJLYhDQxGaTQBVlOxlSLVj8/Kc3iW55kCqyHgDD1j6HcWNfUXzGsYvG
	 /m9cB5YPbDpe1Mil6jnIjMGnulHty0REfqOSl/2rBsfJ0VuA1FKDWQINl4oqbLPqVVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792773887;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=StjKLcccOl+3ULPLOe7OnEX9iL11DeVAXq1ubRm/Zog=;
	b=uab6Xu8wS6CooPGy2c5cwo7FTq3TyMWIDacJhLaPQDcYT5HRTgXqq66g2rUwdu5Lr+3m
	 nlzl0BgNZ0CUUAn88tweNGLM6FrdDy1vlm5p5Qh4qH1Lha/pDv6CaMlf26zCILjM9wQKl
	 aV/sZ+RaLpw4UQtHwfGkv5Lq2uXrqH+DYudYmKA9eHr2XV8OFrUaQ0UAwfYBUWSQJPFQe
	 bTuoOY8wfVmZ2a3zY0GQwxlK3xw7shChIlEM/07rO1aUL/8Drhl4NlNW6R5qATl5Ugkm4
	 49lqL8SQMxmbUWE+Ad343LtWNRlzBOCEHAB85vOfiQu16glkAghDQk1LCVZ26Gc2xUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g7B7rUWi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE547606A31A;
	Fri, 23 Oct 2026 16:44:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g7B7rUWi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F0301F01825;
	Fri, 23 Oct 2026 16:44:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792773886;
	bh=StjKLcccOl+3ULPLOe7OnEX9iL11DeVAXq1ubRm/Zog=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g7B7rUWir4VH2v5TBBm9dANSUp04pxsuq1GTZS637J6zu41PfjdEpvW6ctmUIFDFB
	 ucN8gxE3xXSUCpBxZSm5fY+rZ40zH29JmAETPuM2lfMuKPqajEH8denEalsRkJ3vKT
	 WGq4Wk+oyDTt/Dzi7mf2ftnUIvm6vGBoCDORzbFA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carlos Jones Jr <carlosjr.jones@analog.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 048/193] spi: tegra114: assert CS GPIO for every transfer in a message
Date: Fri, 23 Oct 2026 18:35:25 +0200
Message-ID: <20261023163715.344240321@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Carlos Jones Jr <carlosjr.jones@analog.com>

[ Upstream commit 8980bc573ae2d2b9d86d76aeb86c76e1597070bf ]

The driver provides its own transfer_one_message() and therefore drives
the chip-select GPIO itself rather than through the SPI core. The GPIO is
asserted only in the is_first_of_msg path of
tegra_spi_setup_transfer_one(), but tegra_spi_transfer_end() deasserts it
whenever a transfer has cs_change set. For a multi-transfer message whose
earlier transfers request cs_change -- for example a register read that
sends the address in one transfer and clocks the data back in the next --
the CS GPIO is released after the first transfer and never re-asserted,
so the remaining transfers are clocked with chip-select inactive and the
peripheral never drives the bus.

This was observed with an ADIS16470 IMU (adis16475 driver), whose
register read is a two-transfer, cs_change-framed exchange: a logic
analyzer showed the data frame clocked with CS high, and the driver read
0 while the device drove 0x4056 on the wire.

Re-assert the CS GPIO for every transfer so that multi-transfer messages
keep chip-select active across the whole message. gpiod_set_value() is
idempotent and polarity-aware, so this is a no-op for the first transfer
and for messages that keep CS asserted throughout.

Fixes: 63c1440596ff ("spi: tegra114: add support for gpio based CS")
Signed-off-by: Carlos Jones Jr <carlosjr.jones@analog.com>
Link: https://patch.msgid.link/20261002085540.1625-1-carlosjr.jones@analog.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-tegra114.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/spi/spi-tegra114.c b/drivers/spi/spi-tegra114.c
index a28597b6b80d6..b696c34d83de3 100644
--- a/drivers/spi/spi-tegra114.c
+++ b/drivers/spi/spi-tegra114.c
@@ -859,6 +859,13 @@ static u32 tegra_spi_setup_transfer_one(struct spi_device *spi,
 		command1 |= SPI_BIT_LENGTH(bits_per_word - 1);
 	}
 
+	/*
+	 * Re-assert the CS GPIO for every transfer: transfer_end() drops it
+	 * on cs_change, and the assert above only covers is_first_of_msg.
+	 */
+	if (spi_get_csgpiod(spi, 0))
+		gpiod_set_value(spi_get_csgpiod(spi, 0), 1);
+
 	return command1;
 }
 
-- 
2.53.0



