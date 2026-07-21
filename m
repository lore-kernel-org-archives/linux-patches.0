Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0708347254B;
	Tue, 21 Jul 2026 20:03:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664235; cv=none; b=gFcGPsw57IHaPtl7EzeYNH8Ih3AMPgQb0m3HoL/otBiTnzt6nnA0yL1IFh5wunrOWPOGVR1QTASpfvPcbEsBQZlcvAQYl/dEGf/NN6ZbLOrt/Sdu7wfA8/izh6P9YsXs7Y8FbC6bL97sRNxEA2LYLWPRYwsxkZTMXUtrGcI8z8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664235; c=relaxed/simple;
	bh=q0mXJhg7iMo9HCABz+CjDca8gOmdrj/g2bihyQlkLgs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UzM1LoPMM42dTkgQCYpC5TqMj9TRQ0WATSqJKTgTLe591w9EULT673JcZY9ZwtqCwpi9tXFb/uw6m2eIoF3zI5aMdInpBIhjxCnXI3+79cpP6W9DDk3i9NbR17gYGFAn+g/PTyXG5aff7SFGBFeCsxr+wVWFxucOizkl7IoNa5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ERoJJNAY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ERoJJNAY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63F441F00A3A;
	Tue, 21 Jul 2026 20:03:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664233;
	bh=i34BATJCvLIwOW4fGn4eIIp7uqvcjABWb6El4IrPviU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ERoJJNAY3SX/Nkxam8346GNF73NrrMIxoQ1LLJKa+3XfzePiEkdtvMeyn0KyDUX5i
	 Fsaf+A7R7GePhxSllcLESUKzU1S7Us8D4TSjHSJBQiAwAj7+qZNcr2p469L+HIMcrJ
	 X5mXjcFqGBFNYkIRUcO9fkKkzvlNBGXgkwH9D3qk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.12 1124/1276] mtd: mchp23k256: use SPI match data for chip caps
Date: Tue, 21 Jul 2026 17:26:07 +0200
Message-ID: <20260721152511.146699685@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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
 


