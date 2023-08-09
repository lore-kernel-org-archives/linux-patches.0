Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE601174CA
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:00:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4092DC433C8;
	Wed,  9 Aug 2023 11:00:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691578800;
	bh=ogEyB2jafn+lL0XcfemZLOnlaxUvSvCl+NBfFQsP8A8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q9+bdKSpBGwSeZevCxT6BsLfSQwJT2V9bnmXiaG+LzVwuMYAYtw3AozwkbtEn0OEr
	 DnKHp5PwdeI8vVgydU19Ok+doeT/NqakoCAmXr+4vasSsFDAhgan8zS9NzOaoPFk28
	 LHzLPWkyAfQC07HTPjbSEmy0hZ/klMLU9gr0K3aM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olivier Maignial <olivier.maignial@hotmail.fr>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.15 62/92] mtd: spinand: toshiba: Fix ecc_get_status
Date: Wed,  9 Aug 2023 12:41:38 +0200
Message-ID: <20230809103635.743500570@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103633.485906560@linuxfoundation.org>
References: <20230809103633.485906560@linuxfoundation.org>
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

commit 8544cda94dae6be3f1359539079c68bb731428b1 upstream.

Reading ECC status is failing.

tx58cxgxsxraix_ecc_get_status() is using on-stack buffer
for SPINAND_GET_FEATURE_OP() output. It is not suitable
for DMA needs of spi-mem.

Fix this by using the spi-mem operations dedicated buffer
spinand->scratchbuf.

See
spinand->scratchbuf:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/include/linux/mtd/spinand.h?h=v6.3#n418
spi_mem_check_op():
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/spi/spi-mem.c?h=v6.3#n199

Fixes: 10949af1681d ("mtd: spinand: Add initial support for Toshiba TC58CVG2S0H")
Cc: stable@vger.kernel.org
Signed-off-by: Olivier Maignial <olivier.maignial@hotmail.fr>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/DB4P250MB1032553D05FBE36DEE0D311EFE23A@DB4P250MB1032.EURP250.PROD.OUTLOOK.COM
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/spi/toshiba.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/mtd/nand/spi/toshiba.c
+++ b/drivers/mtd/nand/spi/toshiba.c
@@ -73,7 +73,7 @@ static int tx58cxgxsxraix_ecc_get_status
 {
 	struct nand_device *nand = spinand_to_nand(spinand);
 	u8 mbf = 0;
-	struct spi_mem_op op = SPINAND_GET_FEATURE_OP(0x30, &mbf);
+	struct spi_mem_op op = SPINAND_GET_FEATURE_OP(0x30, spinand->scratchbuf);
 
 	switch (status & STATUS_ECC_MASK) {
 	case STATUS_ECC_NO_BITFLIPS:
@@ -92,7 +92,7 @@ static int tx58cxgxsxraix_ecc_get_status
 		if (spi_mem_exec_op(spinand->spimem, &op))
 			return nanddev_get_ecc_conf(nand)->strength;
 
-		mbf >>= 4;
+		mbf = *(spinand->scratchbuf) >> 4;
 
 		if (WARN_ON(mbf > nanddev_get_ecc_conf(nand)->strength || !mbf))
 			return nanddev_get_ecc_conf(nand)->strength;


