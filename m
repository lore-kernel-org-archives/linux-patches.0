Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 709E31863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 14:56:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9830C433D2;
	Wed, 28 Dec 2022 14:56:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672239393;
	bh=3UZsrscQAhHUPMxHaWIwGPS1ErmCZxHE+xGCGOML0+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gfk1lKi+bv3ydn3R1cYZfOtpwvqMfM8ctOxA/OPrcpHXD16+w/Euw873E9ke2A7N2
	 yyBZNIXsyZt4USNqyUYeoQZy59cYR/ghSoZwYvzGwRt1zAHc7xDM4DeoqGyhojpaJ9
	 K/UHYtzcfWyRJmW6pZXsexU7zvllLVK2mjDPxarQ=
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
Subject: [PATCH 5.15 217/731] mtd: spi-nor: Fix the number of bytes for the dummy cycles
Date: Wed, 28 Dec 2022 15:35:24 +0100
Message-Id: <20221228144302.850842359@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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
index eb5d7b3d1860..aad7076ae020 100644
--- a/drivers/mtd/spi-nor/core.c
+++ b/drivers/mtd/spi-nor/core.c
@@ -2155,7 +2155,8 @@ static int spi_nor_spimem_check_readop(struct spi_nor *nor,
 	spi_nor_spimem_setup_op(nor, &op, read->proto);
 
 	/* convert the dummy cycles to the number of bytes */
-	op.dummy.nbytes = (nor->read_dummy * op.dummy.buswidth) / 8;
+	op.dummy.nbytes = (read->num_mode_clocks + read->num_wait_states) *
+			  op.dummy.buswidth / 8;
 	if (spi_nor_protocol_is_dtr(nor->read_proto))
 		op.dummy.nbytes *= 2;
 
-- 
2.35.1



