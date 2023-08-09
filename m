Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9660515AE3
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 10:48:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F4BAC433C8;
	Wed,  9 Aug 2023 10:48:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691578105;
	bh=P1HFONah273a4XTIibG8t+qqj6C/fwPJw+aExfAFl48=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pZSfB3de+KbYw0c1poKqrZ2nyi5yAqsazvyk6/+svgWmXpJyx6l0CywxPfIX8OFnL
	 sGbEq+hmEPb8+SY8Pqs/GdtL3FN6+SNdutjrZw79EjZK4S51IbSnijrZy6HSArLOul
	 hG+ZvgoXz+8QjrY5cHcxU0Gmct5hbsr2vF/yydII=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olivier Maignial <olivier.maignial@hotmail.fr>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.4 108/165] mtd: spinand: winbond: Fix ecc_get_status
Date: Wed,  9 Aug 2023 12:40:39 +0200
Message-ID: <20230809103646.323540461@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103642.720851262@linuxfoundation.org>
References: <20230809103642.720851262@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Olivier Maignial <olivier.maignial@hotmail.fr>

commit f5a05060670a4d8d6523afc7963eb559c2e3615f upstream.

Reading ECC status is failing.

w25n02kv_ecc_get_status() is using on-stack buffer for
SPINAND_GET_FEATURE_OP() output. It is not suitable for
DMA needs of spi-mem.

Fix this by using the spi-mem operations dedicated buffer
spinand->scratchbuf.

See
spinand->scratchbuf:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/include/linux/mtd/spinand.h?h=v6.3#n418
spi_mem_check_op():
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/spi/spi-mem.c?h=v6.3#n199

Fixes: 6154c7a58348 ("mtd: spinand: winbond: add Winbond W25N02KV flash support")
Cc: stable@vger.kernel.org
Signed-off-by: Olivier Maignial <olivier.maignial@hotmail.fr>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/DB4P250MB1032EDB9E36B764A33769039FE23A@DB4P250MB1032.EURP250.PROD.OUTLOOK.COM
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/spi/winbond.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/mtd/nand/spi/winbond.c
+++ b/drivers/mtd/nand/spi/winbond.c
@@ -108,7 +108,7 @@ static int w25n02kv_ecc_get_status(struc
 {
 	struct nand_device *nand = spinand_to_nand(spinand);
 	u8 mbf = 0;
-	struct spi_mem_op op = SPINAND_GET_FEATURE_OP(0x30, &mbf);
+	struct spi_mem_op op = SPINAND_GET_FEATURE_OP(0x30, spinand->scratchbuf);
 
 	switch (status & STATUS_ECC_MASK) {
 	case STATUS_ECC_NO_BITFLIPS:
@@ -126,7 +126,7 @@ static int w25n02kv_ecc_get_status(struc
 		if (spi_mem_exec_op(spinand->spimem, &op))
 			return nanddev_get_ecc_conf(nand)->strength;
 
-		mbf >>= 4;
+		mbf = *(spinand->scratchbuf) >> 4;
 
 		if (WARN_ON(mbf > nanddev_get_ecc_conf(nand)->strength || !mbf))
 			return nanddev_get_ecc_conf(nand)->strength;


