Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BAB85A114;
	Tue, 23 Jan 2024 00:31:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969881; cv=none; b=iC2OMrpnpoam1Y/OMtzbWHBZugveF2eNILqhhWmleKenWCb4E4dln9uvNAEzRem8l3AJyNwTpU9hz1wsi+jtyEu1v//EZMBYUocm4eIa8LI/Wzkcm75ONzXHgFCUEZqjCBQRNF31Oh5H8RnEPDN74dSLT8dKshwbeZurd3J0ifA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969881; c=relaxed/simple;
	bh=tYMzkpSF93reewwZOZ5n6oy1aZhiJyHmDqxJAhglUtw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=exV28snH2tBnIhClXj0DWWhQR36Ao1d31R90DOzSTYDUJJQBG9IEHSMDw6r/ASU8WMKgJ+k2hkaexaJFuxpl2W6PhQh0JtJGA65YdOIQAwtfC5lS/zRTqaYGofBFuznVi2D0dyqNk5ZR3nA9lB/Zrx59sdtKbYMu9UDcskkX8OU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ksZQeF9t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ksZQeF9t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB5E7C433C7;
	Tue, 23 Jan 2024 00:31:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969881;
	bh=tYMzkpSF93reewwZOZ5n6oy1aZhiJyHmDqxJAhglUtw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ksZQeF9tYfx6nNOZdTXRH/Q4eTExXc4dXVyaszgMaHHGStdebekY+5833SdsOfVT+
	 XTc5bhYep4EzRP69o0AQ/KJNLarPR3S58ztpK/l4SGbO94zP4Cf2YQ39DUab/tVqEn
	 fT18ov7cSKQSEk+OxptGzNJUH+K1hpzZ7qfN3itQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hugo Villeneuve <hvilleneuve@dimonoff.com>
Subject: [PATCH 6.7 479/641] serial: sc16is7xx: add check for unsupported SPI modes during probe
Date: Mon, 22 Jan 2024 15:56:23 -0800
Message-ID: <20240122235833.045688687@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1727,7 +1727,10 @@ static int sc16is7xx_spi_probe(struct sp
 
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


