Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E913873176;
	Tue, 23 Jan 2024 02:04:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975481; cv=none; b=fonp9z03vyH4Y8lNcD2tblbeRsQ2hXH3K5I/6i7ZFEs4fF3i32mveFgnek/r4ZDXQOFcqQ+lmHsddMcAUr2tRUGPL7Lhu4sOWZnFT3Zbz0neJEb7h36Zrk9VrimXMYywMqF/S0t66CWBgPb14d+/3juq1Par01SkQaeZ6K40NS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975481; c=relaxed/simple;
	bh=B7YZYQKyC5+0kmomc1V9W4HxOkbkDCE7AJi6hr5gxyM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LhBdCAuTMUgNIY8OIE/lJLJSjHrmOd4C+6mkMIvt0w9eIn4PByr6HTUEoyOzywv2W40gIxdSOoMUMCYDFN6TRJkD7pVQwxT6suwSUVu2xfFhwF+VP5ub7LWFhPKM2OrMODF7Zo6ExIXOELJGeMV20QElMh7FiYXO9/y8UrnFojI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2l6cms2C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2l6cms2C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADE8BC433C7;
	Tue, 23 Jan 2024 02:04:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975480;
	bh=B7YZYQKyC5+0kmomc1V9W4HxOkbkDCE7AJi6hr5gxyM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2l6cms2CTA625igmzcebBNpFVHwBGYqhlho+Sg9uxxSCqyck3iIj8RsPsLvP6BoHM
	 m16FL4ILffW7tOM48bOZ+slpzldPpvBeydrSXEqdem8YzKc4F4SCJ8C/iek4OEMjpS
	 DL6gunKMNOFGwIsycoNQ9oI3H3FWe1C0/u3vHBcs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hugo Villeneuve <hvilleneuve@dimonoff.com>
Subject: [PATCH 6.6 435/583] serial: sc16is7xx: add check for unsupported SPI modes during probe
Date: Mon, 22 Jan 2024 15:58:06 -0800
Message-ID: <20240122235825.293065879@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hugo Villeneuve <hvilleneuve@dimonoff.com>

commit 6d710b769c1f5f0d55c9ad9bb49b7dce009ec103 upstream.

The original comment is confusing because it implies that variants other
than the SC16IS762 supports other SPI modes beside SPI_MODE_0.

Extract from datasheet:
    The SC16IS762 differs from the SC16IS752 in that it supports SPI clock
    speeds up to 15 Mbit/s instead of the 4 Mbit/s supported by the
    SC16IS752... In all other aspects, the SC16IS762 is functionally and
    electrically the same as the SC16IS752.

The same is also true of the SC16IS760 variant versus the SC16IS740 and
SC16IS750 variants.

For all variants, only SPI mode 0 is supported.

Change comment and abort probing if the specified SPI mode is not
SPI_MODE_0.

Fixes: 2c837a8a8f9f ("sc16is7xx: spi interface is added")
Cc:  <stable@vger.kernel.org>
Signed-off-by: Hugo Villeneuve <hvilleneuve@dimonoff.com>
Link: https://lore.kernel.org/r/20231221231823.2327894-3-hugo@hugovil.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/sc16is7xx.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/tty/serial/sc16is7xx.c
+++ b/drivers/tty/serial/sc16is7xx.c
@@ -1714,7 +1714,10 @@ static int sc16is7xx_spi_probe(struct sp
 
 	/* Setup SPI bus */
 	spi->bits_per_word	= 8;
-	/* only supports mode 0 on SC16IS762 */
+	/* For all variants, only mode 0 is supported */
+	if ((spi->mode & SPI_MODE_X_MASK) != SPI_MODE_0)
+		return dev_err_probe(&spi->dev, -EINVAL, "Unsupported SPI mode\n");
+
 	spi->mode		= spi->mode ? : SPI_MODE_0;
 	spi->max_speed_hz	= spi->max_speed_hz ? : 15000000;
 	ret = spi_setup(spi);


