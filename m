Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DB6A479873;
	Tue, 21 Jul 2026 21:01:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667664; cv=none; b=II+/vEQOGBcxyX4flzrjkjZqngyr4UG6FuLJRL37nh9zVWcs2XNaDaEkKEbZDam+LCwwa71pnygiqOo9k/oXqXdF4jvbKrK+13+72tt5qHSKqehtF6IrVyb3ryQgxMzP9lPwBJcMJF5+/EYioOpRlstWl7TYfOuYvCvNW+MYua4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667664; c=relaxed/simple;
	bh=8zwuLurVSUkyPiyEoilw1Kx4wA9COfCaxM2z6hdRpl0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tKtvFzREa7nGfHfmAKgkhr3WRaeD60tEguvZF1qpaPGHDSzWmYZ9bQKRs0NnXy2E5G49+UvMucxA9PUyf06FNfY7GWgabhYNmY+aEWhiLw5+DPR/AALClUKA4OYQwzDZMzGUStu0NWhrVZ/N8KGMrD7lIn32I7xaHaimz4kG0KY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mUu9i/PX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mUu9i/PX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A53581F00A3A;
	Tue, 21 Jul 2026 21:01:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667663;
	bh=NgUCjThgBNqG62kwYMU4sTlluwTO5pPi+cWojCaUUmw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mUu9i/PXF1NBgPmsxx/7QXbSuQnsnT6z/tQntNkgv4piB6i7xFWCXuziRC+bsoEkJ
	 +O1W1p0HsH2wlMWbdud53filLA49OnnkWKNkkzSRzS7IJH8GfGBYWtClI5gvNfIQCw
	 LcVlwUFomiV5TG29AwB+5NPHch4vmwAdDqF8YzjY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.6 1144/1266] mtd: mchp23k256: use SPI match data for chip caps
Date: Tue, 21 Jul 2026 17:26:21 +0200
Message-ID: <20260721152507.387575955@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

commit d322e40f4edf92bf0ca329e5aa4ae1c0316feb38 upstream.

The driver stores chip capacity information in both the OF match table
and the SPI id table. Probe currently uses of_device_get_match_data(),
so a non-OF SPI modalias match falls back to mchp23k256_caps even when
the SPI id table selected a different part.

Use spi_get_device_match_data() so SPI id-table driver_data is consumed
when OF match data is absent. This keeps the existing default fallback
while avoiding the wrong MTD geometry for id-table-only matches.

Fixes: 4379075a870b ("mtd: mchp23k256: Add support for mchp23lcv1024")
Cc: stable@vger.kernel.org
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/devices/mchp23k256.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mtd/devices/mchp23k256.c
+++ b/drivers/mtd/devices/mchp23k256.c
@@ -188,7 +188,7 @@ static int mchp23k256_probe(struct spi_d
 
 	data = dev_get_platdata(&spi->dev);
 
-	flash->caps = of_device_get_match_data(&spi->dev);
+	flash->caps = spi_get_device_match_data(spi);
 	if (!flash->caps)
 		flash->caps = &mchp23k256_caps;
 


