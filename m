Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFEB07CF39;
	Mon,  8 Apr 2024 13:34:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583299; cv=none; b=LlW45/XbXZQkK2d7z80A6COODy7DLLFNNSV4AU4vhdyXBNCzRqkNemVxE9NrzCEuwn+6hOpTHnbGljjfGPjvDy4/9lyYrMMKwqHBNO2vfEx0QwB16O03+BEFehDoUOOHInBgeX0Qvcxw8NBkEuj7ppC3x1pHMCfvgK5mG8TQcQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583299; c=relaxed/simple;
	bh=5M0mv19YUyxQ0C8kTJ9dSWNai5PtlCot+IqAL++E2/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XyHzMl7ckm7/yXC3dK1cvvkkATp+Dw7e8yw+DFI+YQRsScrMf/1PLZLuqV2RT6SU/qtmjQX/5Tq8MJjeC4yBV8qiSA3ZIhoxV3U6Qc2OvOd5P/AAyGKuBClE6lRxtYAlgH1Rt9UX4nv/8HZYq2VbeRZqfpW6ptt4WEvsk6rA1VM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iVh0kXbx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iVh0kXbx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44D52C433F1;
	Mon,  8 Apr 2024 13:34:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583299;
	bh=5M0mv19YUyxQ0C8kTJ9dSWNai5PtlCot+IqAL++E2/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iVh0kXbxAlDau0NmZSs7x0wYLxDuX3ZiCLMbGfENk1caX3NxJSlwSULvRve1JOWu/
	 DBRNRM+eCYwjPO5jRc+VLkGZAKh27ucp5E+rJUq7NpxIOniNWi6joatuOV0oxgGt6e
	 kD5woSZi+KxmYC5yAZhXDSlLfXyxSJhm77/Uzgr0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tudor Ambarus <tudor.ambarus@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 179/252] spi: s3c64xx: allow full FIFO masks
Date: Mon,  8 Apr 2024 14:57:58 +0200
Message-ID: <20240408125312.214388047@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125306.643546457@linuxfoundation.org>
References: <20240408125306.643546457@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tudor Ambarus <tudor.ambarus@linaro.org>

[ Upstream commit d6911cf27e5c8491cbfedd4ae2d1ee74a3e685b4 ]

The driver is wrong because is using partial register field masks for the
SPI_STATUS.{RX, TX}_FIFO_LVL register fields.

We see s3c64xx_spi_port_config.fifo_lvl_mask with different values for
different instances of the same IP. Take s5pv210_spi_port_config for
example, it defines:
	.fifo_lvl_mask  = { 0x1ff, 0x7F },

fifo_lvl_mask is used to determine the FIFO depth of the instance of the
IP. In this case, the integrator uses a 256 bytes FIFO for the first SPI
instance of the IP, and a 64 bytes FIFO for the second instance. While
the first mask reflects the SPI_STATUS.{RX, TX}_FIFO_LVL register
fields, the second one is two bits short. Using partial field masks is
misleading and can hide problems of the driver's logic.

Allow platforms to specify the full FIFO mask, regardless of the FIFO
depth.

Introduce {rx, tx}_fifomask to represent the SPI_STATUS.{RX, TX}_FIFO_LVL
register fields. It's a shifted mask defining the field's length and
position. We'll be able to deprecate the use of @rx_lvl_offset, as the
shift value can be determined from the mask. The existing compatibles
shall start using {rx, tx}_fifomask so that they use the full field mask
and to avoid shifting the mask to position, and then shifting it back to
zero in the {TX, RX}_FIFO_LVL macros.

@rx_lvl_offset will be deprecated in a further patch, after we have the
infrastructure to deprecate @fifo_lvl_mask as well.

No functional change intended.

Signed-off-by: Tudor Ambarus <tudor.ambarus@linaro.org>
Link: https://msgid.link/r/20240216070555.2483977-4-tudor.ambarus@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: a3d3eab627bb ("spi: s3c64xx: Use DMA mode from fifo size")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-s3c64xx.c | 40 +++++++++++++++++++++++++++++++++++----
 1 file changed, 36 insertions(+), 4 deletions(-)

diff --git a/drivers/spi/spi-s3c64xx.c b/drivers/spi/spi-s3c64xx.c
index 3da940e6299f0..688b8fad9e2fd 100644
--- a/drivers/spi/spi-s3c64xx.c
+++ b/drivers/spi/spi-s3c64xx.c
@@ -3,6 +3,7 @@
 // Copyright (c) 2009 Samsung Electronics Co., Ltd.
 //      Jaswinder Singh <jassi.brar@samsung.com>
 
+#include <linux/bitops.h>
 #include <linux/bits.h>
 #include <linux/clk.h>
 #include <linux/delay.h>
@@ -107,10 +108,10 @@
 #define FIFO_LVL_MASK(i) ((i)->port_conf->fifo_lvl_mask[i->port_id])
 #define S3C64XX_SPI_ST_TX_DONE(v, i) (((v) & \
 				(1 << (i)->port_conf->tx_st_done)) ? 1 : 0)
-#define TX_FIFO_LVL(v, i) (((v) >> S3C64XX_SPI_ST_TX_FIFO_LVL_SHIFT) &	\
-			   FIFO_LVL_MASK(i))
-#define RX_FIFO_LVL(v, i) (((v) >> (i)->port_conf->rx_lvl_offset) & \
-					FIFO_LVL_MASK(i))
+#define TX_FIFO_LVL(v, sdd)	(((v) & (sdd)->tx_fifomask) >>		\
+				 __ffs((sdd)->tx_fifomask))
+#define RX_FIFO_LVL(v, sdd)	(((v) & (sdd)->rx_fifomask) >>		\
+				 __ffs((sdd)->rx_fifomask))
 #define FIFO_DEPTH(i) ((FIFO_LVL_MASK(i) >> 1) + 1)
 
 #define S3C64XX_SPI_MAX_TRAILCNT	0x3ff
@@ -136,6 +137,10 @@ struct s3c64xx_spi_dma_data {
  * struct s3c64xx_spi_port_config - SPI Controller hardware info
  * @fifo_lvl_mask: Bit-mask for {TX|RX}_FIFO_LVL bits in SPI_STATUS register.
  * @rx_lvl_offset: Bit offset of RX_FIFO_LVL bits in SPI_STATUS regiter.
+ * @rx_fifomask: SPI_STATUS.RX_FIFO_LVL mask. Shifted mask defining the field's
+ *               length and position.
+ * @tx_fifomask: SPI_STATUS.TX_FIFO_LVL mask. Shifted mask defining the field's
+ *               length and position.
  * @tx_st_done: Bit offset of TX_DONE bit in SPI_STATUS regiter.
  * @clk_div: Internal clock divider
  * @quirks: Bitmask of known quirks
@@ -153,6 +158,8 @@ struct s3c64xx_spi_dma_data {
 struct s3c64xx_spi_port_config {
 	int	fifo_lvl_mask[MAX_SPI_PORTS];
 	int	rx_lvl_offset;
+	u32	rx_fifomask;
+	u32	tx_fifomask;
 	int	tx_st_done;
 	int	quirks;
 	int	clk_div;
@@ -182,6 +189,10 @@ struct s3c64xx_spi_port_config {
  * @tx_dma: Local transmit DMA data (e.g. chan and direction)
  * @port_conf: Local SPI port configuartion data
  * @port_id: Port identification number
+ * @rx_fifomask: SPI_STATUS.RX_FIFO_LVL mask. Shifted mask defining the field's
+ *               length and position.
+ * @tx_fifomask: SPI_STATUS.TX_FIFO_LVL mask. Shifted mask defining the field's
+ *               length and position.
  */
 struct s3c64xx_spi_driver_data {
 	void __iomem                    *regs;
@@ -201,6 +212,8 @@ struct s3c64xx_spi_driver_data {
 	struct s3c64xx_spi_dma_data	tx_dma;
 	const struct s3c64xx_spi_port_config	*port_conf;
 	unsigned int			port_id;
+	u32				rx_fifomask;
+	u32				tx_fifomask;
 };
 
 static void s3c64xx_flush_fifo(struct s3c64xx_spi_driver_data *sdd)
@@ -1145,6 +1158,23 @@ static inline const struct s3c64xx_spi_port_config *s3c64xx_spi_get_port_config(
 	return (const struct s3c64xx_spi_port_config *)platform_get_device_id(pdev)->driver_data;
 }
 
+static void s3c64xx_spi_set_fifomask(struct s3c64xx_spi_driver_data *sdd)
+{
+	const struct s3c64xx_spi_port_config *port_conf = sdd->port_conf;
+
+	if (port_conf->rx_fifomask)
+		sdd->rx_fifomask = port_conf->rx_fifomask;
+	else
+		sdd->rx_fifomask = FIFO_LVL_MASK(sdd) <<
+			port_conf->rx_lvl_offset;
+
+	if (port_conf->tx_fifomask)
+		sdd->tx_fifomask = port_conf->tx_fifomask;
+	else
+		sdd->tx_fifomask = FIFO_LVL_MASK(sdd) <<
+			S3C64XX_SPI_ST_TX_FIFO_LVL_SHIFT;
+}
+
 static int s3c64xx_spi_probe(struct platform_device *pdev)
 {
 	struct resource	*mem_res;
@@ -1190,6 +1220,8 @@ static int s3c64xx_spi_probe(struct platform_device *pdev)
 		sdd->port_id = pdev->id;
 	}
 
+	s3c64xx_spi_set_fifomask(sdd);
+
 	sdd->cur_bpw = 8;
 
 	sdd->tx_dma.direction = DMA_MEM_TO_DEV;
-- 
2.43.0



