Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A979E657B3;
	Tue, 23 Jan 2024 01:03:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971790; cv=none; b=G2XSedJBG0BsW1h+V21Wx6AVdlzm3rxje7wLs3QnbZ0N5n0fWNx5S2/36PJQ43aUR79Gg7ZSFfUZhSwtwOvggMfByjey/8eeQqnooZ7yTGSKtE/qtMxn+sc1ty7STX4/FzhvGOfTOqckhtt7wScrpGaqZaOCE6tMlHYBnza8Rwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971790; c=relaxed/simple;
	bh=BBvrTcNv/2fr1JPn5Hc/egkv/T9wl1v1PnEfJmVUn3M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gtzQFM5/FdIN8SnTIxC4LALnj+hY5EbBlSebdgB1Kdsh/TSytDQfsvj36jzbqp3SnAXcfz6hdW7K0eRQLQm9SS6O6VEYQLXCZQdqTdN8+h8s0+u/Zg++I4nQuTYH6yjppbXtufJJnJsH9m6P7FzDqznDhh5uSSFnhrpPx7+MEjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TtHirYTD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TtHirYTD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5FEFC433F1;
	Tue, 23 Jan 2024 01:03:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971790;
	bh=BBvrTcNv/2fr1JPn5Hc/egkv/T9wl1v1PnEfJmVUn3M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TtHirYTDRMQ9aSVk3WgmenueksnqMK1ve8QGVzppCakWuK9XXsnG2heRtUPD+6nQb
	 Rdrg+JUjb9k8puCQ8nk5g3In5VulfTS+FKMQQdHkL+lIQJ+bn7UzCzHs8Aicza6o1V
	 4wPEucIQVH13rH1z95SnQU70RehA3WfDGYQbo2TI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hugo Villeneuve <hvilleneuve@dimonoff.com>
Subject: [PATCH 6.1 321/417] serial: sc16is7xx: add check for unsupported SPI modes during probe
Date: Mon, 22 Jan 2024 15:58:09 -0800
Message-ID: <20240122235802.929032551@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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
@@ -1716,7 +1716,10 @@ static int sc16is7xx_spi_probe(struct sp
 
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


