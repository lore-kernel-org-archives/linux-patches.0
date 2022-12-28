Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7CD31863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:46:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 207B6C433EF;
	Wed, 28 Dec 2022 15:46:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672242381;
	bh=B4p6ac1vo6S4lnTO/r0DmYyqz4wQjAU534Px32b8+Ko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jHpVk0yWbuHJk3Zv2MI0cfAwEfVQFIxXaw8E2qxZPBhbaqL5SeL46ZBHxdg22DYIQ
	 qXR12vBggt//JcV+RI6dgsCWVfUpBA6ar/DUxuVVQiZe+58Xvsvr2y1g0mE0xTSpdg
	 HPafcK1P0nhYB24Cc/6TIGMrt0FHjLWKjMFMNVhY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bayi Cheng <bayi.cheng@mediatek.com>,
	Allen-KH Cheng <allen-kh.cheng@mediatek.com>,
	Tudor Ambarus <tudor.ambarus@microchip.com>,
	Dhruva Gole <d-gole@ti.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0363/1146] mtd: spi-nor: Fix the number of bytes for the dummy cycles
Date: Wed, 28 Dec 2022 15:31:42 +0100
Message-Id: <20221228144340.026535842@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Allen-KH Cheng <allen-kh.cheng@mediatek.com>

[ Upstream commit fdc20370d93e8c6d2f448a539d08c2c064af7694 ]

The number of bytes used by spi_nor_spimem_check_readop() may be
incorrect for the dummy cycles. Since nor->read_dummy is not initialized
before spi_nor_spimem_adjust_hwcaps().

We use both mode and wait state clock cycles instead of nor->read_dummy.

Fixes: 0e30f47232ab ("mtd: spi-nor: add support for DTR protocol")
Co-developed-by: Bayi Cheng <bayi.cheng@mediatek.com>
Signed-off-by: Bayi Cheng <bayi.cheng@mediatek.com>
Signed-off-by: Allen-KH Cheng <allen-kh.cheng@mediatek.com>
Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Tested-by: Dhruva Gole <d-gole@ti.com>
Tested-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
Link: https://lore.kernel.org/r/20221031124633.13189-1-allen-kh.cheng@mediatek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/spi-nor/core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/mtd/spi-nor/core.c b/drivers/mtd/spi-nor/core.c
index bee8fc4c9f07..0cf1a1797ea3 100644
--- a/drivers/mtd/spi-nor/core.c
+++ b/drivers/mtd/spi-nor/core.c
@@ -1914,7 +1914,8 @@ static int spi_nor_spimem_check_readop(struct spi_nor *nor,
 	spi_nor_spimem_setup_op(nor, &op, read->proto);
 
 	/* convert the dummy cycles to the number of bytes */
-	op.dummy.nbytes = (nor->read_dummy * op.dummy.buswidth) / 8;
+	op.dummy.nbytes = (read->num_mode_clocks + read->num_wait_states) *
+			  op.dummy.buswidth / 8;
 	if (spi_nor_protocol_is_dtr(nor->read_proto))
 		op.dummy.nbytes *= 2;
 
-- 
2.35.1



