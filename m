Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC1AC46C4D1;
	Tue, 21 Jul 2026 17:35:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655313; cv=none; b=CnXKYHyVyUmuUZ3KmvDX9zgS3qhMI8WrZ0Lakl048SOzwJaumz3/ycoGLgGuHC+gQAT/E3RiJUVNZiZoZYcklyEOwQaqTltH5C4qOimwYIoAm2MtXxrZdIlD46SbQ/B6R5aAjGd/ySv3dpezXNmSkx7Wuo/JkxaKxXLS7xcqHTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655313; c=relaxed/simple;
	bh=ovVNnIkpV/00G4y9sEBodtIte+mTEcoWZkY9S6QqBjc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hU7+Aqo+Yn+JE1z42NlGcZ+hXbPfo4arkGIhg0nx9aeltYEIPLsP4vPjNhy2PdaYYxltPFOrk70edwQ6AHZFaHWFUZ9WS3UB+arA2ClXFNzkqd1g7vEFzk/ETgIOmPwLNVQg9aGPAOAAEtaDLwjK8j2q3QR960Rttg/r64WGOaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x3EWPtu0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x3EWPtu0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DAFF1F000E9;
	Tue, 21 Jul 2026 17:35:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655311;
	bh=ukNDWztxe8xwCjPdVTQ5z+YW+/JHa9Ne3IPeTpOWoDI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x3EWPtu0WXm7BohHRRqBfASxyrc/zow+2O8T7AtT1+QolDNL2QlzOvVDa2MY7kidr
	 xIsumfe8y5k+irwZdL1bSwNQ23YM4P57/lPjM82zHWJ85Qdq1YTN0Hnx9jRZ3PDucq
	 s3cpqJTrvtonexa9WP299r1v+mqcOFC0wAYoUtUQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 7.1 2029/2077] mtd: mchp23k256: use SPI match data for chip caps
Date: Tue, 21 Jul 2026 17:28:22 +0200
Message-ID: <20260721152640.554776939@linuxfoundation.org>
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
 


