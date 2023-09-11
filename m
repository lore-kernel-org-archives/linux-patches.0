Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5F6811706
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:55:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21B0EC433C7;
	Mon, 11 Sep 2023 14:55:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694444129;
	bh=/1jtHE7ESuefcnY7ne7h5cA3S7s+KfvVx7Z6j690/LI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RCMU9W0camgymh6CiuzdZA/i63xbHhLTuveTHMVC6omA3gH1c4aSQE70Qm33c5ZEv
	 VrJ/KTIm2WpqpvNaACOqeFfVIZ9xIbgAj9gZbsnSKFxYgpvLHHGrDfjfvcQakxoKFM
	 E3hQr3qpEK6fYZk4ayKWSfUyWRjG87WKw4o1L38Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Walle <michael@walle.cc>,
	Tudor Ambarus <tudor.ambarus@linaro.org>,
	Hsin-Yi Wang <hsinyi@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 621/737] mtd: spi-nor: Check bus width while setting QE bit
Date: Mon, 11 Sep 2023 15:48:00 +0200
Message-ID: <20230911134707.878447709@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.286315610@linuxfoundation.org>
References: <20230911134650.286315610@linuxfoundation.org>
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

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hsin-Yi Wang <hsinyi@chromium.org>

[ Upstream commit f01d8155a92e33cdaa85d20bfbe6c441907b3c1f ]

spi_nor_write_16bit_sr_and_check() should also check if bus width is
4 before setting QE bit.

Fixes: 39d1e3340c73 ("mtd: spi-nor: Fix clearing of QE bit on lock()/unlock()")
Suggested-by: Michael Walle <michael@walle.cc>
Suggested-by: Tudor Ambarus <tudor.ambarus@linaro.org>
Signed-off-by: Hsin-Yi Wang <hsinyi@chromium.org>
Reviewed-by: Michael Walle <michael@walle.cc>
Link: https://lore.kernel.org/r/20230818064524.1229100-2-hsinyi@chromium.org
Signed-off-by: Tudor Ambarus <tudor.ambarus@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/spi-nor/core.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/mtd/spi-nor/core.c b/drivers/mtd/spi-nor/core.c
index 5f29fac8669a3..55f4a902b8be9 100644
--- a/drivers/mtd/spi-nor/core.c
+++ b/drivers/mtd/spi-nor/core.c
@@ -870,21 +870,22 @@ static int spi_nor_write_16bit_sr_and_check(struct spi_nor *nor, u8 sr1)
 		ret = spi_nor_read_cr(nor, &sr_cr[1]);
 		if (ret)
 			return ret;
-	} else if (nor->params->quad_enable) {
+	} else if (spi_nor_get_protocol_width(nor->read_proto) == 4 &&
+		   spi_nor_get_protocol_width(nor->write_proto) == 4 &&
+		   nor->params->quad_enable) {
 		/*
 		 * If the Status Register 2 Read command (35h) is not
 		 * supported, we should at least be sure we don't
 		 * change the value of the SR2 Quad Enable bit.
 		 *
-		 * We can safely assume that when the Quad Enable method is
-		 * set, the value of the QE bit is one, as a consequence of the
-		 * nor->params->quad_enable() call.
+		 * When the Quad Enable method is set and the buswidth is 4, we
+		 * can safely assume that the value of the QE bit is one, as a
+		 * consequence of the nor->params->quad_enable() call.
 		 *
-		 * We can safely assume that the Quad Enable bit is present in
-		 * the Status Register 2 at BIT(1). According to the JESD216
-		 * revB standard, BFPT DWORDS[15], bits 22:20, the 16-bit
-		 * Write Status (01h) command is available just for the cases
-		 * in which the QE bit is described in SR2 at BIT(1).
+		 * According to the JESD216 revB standard, BFPT DWORDS[15],
+		 * bits 22:20, the 16-bit Write Status (01h) command is
+		 * available just for the cases in which the QE bit is
+		 * described in SR2 at BIT(1).
 		 */
 		sr_cr[1] = SR2_QUAD_EN_BIT1;
 	} else {
-- 
2.40.1



