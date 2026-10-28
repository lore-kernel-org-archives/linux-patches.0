Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216894;
	b=qXXEJAFve9WMTENz7xUsK3m76or4zDgGkRdtCjWugxw4XNGQm89DGZuufkcjgGPBo65t
	 3YGClTX7FUHAB/S3hvo8YvNObtAqQgv+5RI5+EcYuCxRdd3Ygc8602yjDzwMHanwtzMyo
	 s6RVNgJKXPvaJJ4ILy8MShhoFVNykolQ7fAKuTLrB1fR1ynog0gOmz+l6vrGp907A3lkg
	 zziAAIGmXVuYhOmpMT2ga+RvMpPiAiUgvPadxv/XdT0BFIHPVc3AK6KoBHPMHJwmMwW8O
	 II1vVk5d+eTo6N6F1adQYHXihik0Gu9g1sAHdv5P1+Mu65BiokN55hHJBEIPKnTWy8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216894;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5AAySH02GlV2F6O0MHqhYUkOCImKMwcqIgcnev368bQ=;
	b=VgHIk/RiOtR+HObzKPgUvyBXSqQwk9iJHjKlvV2MUz3lIwWasIFhAY1E+RatLvQvhpOF
	 00KliNftasRGt23MUAlQ71rKJOIZ2bqrx3f1UBQIN5fH8vwi1KTH0h8klBFB+FoSel/Jb
	 Yl7LjcsOz3/q1WUAgc5nawPoXJdvTaC5KvBY1xwi9AFvy/47fAhEUZ9pawQApFbmVSJwI
	 e/1PlsQNPVqxmrSffZv3n4pVgq32RKnCYtDkusXh2PCeQgGzdpazi9/KbrelS12Keyh5i
	 RdYVbPZ6TI7cYxOphOtFi3agZcTA357UnTEjC+mMrw2vi55b1QsLvShq05GSw1u1KoQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pDKRZLl2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26737606A31A;
	Wed, 28 Oct 2026 19:48:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pDKRZLl2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BE541F01825;
	Wed, 28 Oct 2026 19:48:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216893;
	bh=5AAySH02GlV2F6O0MHqhYUkOCImKMwcqIgcnev368bQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pDKRZLl2ABxl6yeEkjII5RurjdzEzDx69+bcucDHFirssUw8tyuEGPDY9IzIVNKpC
	 zSeUTgFpFQjyZ9ljre1DxOlT/+Ayk47ohudXLmPkX4V45p8rvUM5YhCg4dWEz3UuwC
	 Wh7o47i6aC/zUJWTIKwFlbExc2UOnp1NmkqgwfOI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carlos Jones Jr <carlosjr.jones@analog.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1716/1887] spi: tegra114: assert CS GPIO for every transfer in a message
Date: Wed, 28 Oct 2026 18:03:32 +0100
Message-ID: <20261028170538.507657321@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index b2c9b90fc81c1..2489a2dbf0be3 100644
--- a/drivers/spi/spi-tegra114.c
+++ b/drivers/spi/spi-tegra114.c
@@ -860,6 +860,13 @@ static u32 tegra_spi_setup_transfer_one(struct spi_device *spi,
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



