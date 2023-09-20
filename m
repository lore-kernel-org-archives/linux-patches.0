Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EF833C680
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:32:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE9EFC433CA;
	Wed, 20 Sep 2023 12:32:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695213146;
	bh=43dHqUYP1r0ujWB506H6HVIAmA9nl2buwvogBkinecU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KWN6aihOdrkg4EMGJMoxmuw3Q/bW9hYZaL46hn2U+5ysDAE2NOQa6J+W03M3eFpCw
	 mmYE9eoi6h3Jqzy5jisBH+dM4JbonV/m8Ll1aG//YeC4AP+YQtjsfwEq54KIyIfYlo
	 Wi85WGUclw6eSJnnp/oaClV8AOn22l5cKMxJOtRQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Jacopo Mondi <jacopo@jmondi.org>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 177/367] media: i2c: ov5640: Configure HVP lines in s_power callback
Date: Wed, 20 Sep 2023 13:29:14 +0200
Message-ID: <20230920112903.219452099@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112858.471730572@linuxfoundation.org>
References: <20230920112858.471730572@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>

[ Upstream commit 311a6408f8d46d47e35d3bf598dced39af4ce087 ]

Configure HVP lines in s_power callback instead of configuring everytime
in ov5640_set_stream_dvp().

Alongside also disable MIPI in DVP mode.

Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Reviewed-by: Biju Das <biju.das.jz@bp.renesas.com>
Tested-by: Jacopo Mondi <jacopo@jmondi.org>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Stable-dep-of: 98cb72d3b9c5 ("media: ov5640: Enable MIPI interface in ov5640_set_power_mipi()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/ov5640.c | 123 +++++++++++++++++--------------------
 1 file changed, 58 insertions(+), 65 deletions(-)

diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
index 087fb464ffc12..76a9fa6d6d5c0 100644
--- a/drivers/media/i2c/ov5640.c
+++ b/drivers/media/i2c/ov5640.c
@@ -1206,71 +1206,6 @@ static int ov5640_set_autogain(struct ov5640_dev *sensor, bool on)
 
 static int ov5640_set_stream_dvp(struct ov5640_dev *sensor, bool on)
 {
-	int ret;
-	unsigned int flags = sensor->ep.bus.parallel.flags;
-	u8 pclk_pol = 0;
-	u8 hsync_pol = 0;
-	u8 vsync_pol = 0;
-
-	/*
-	 * Note about parallel port configuration.
-	 *
-	 * When configured in parallel mode, the OV5640 will
-	 * output 10 bits data on DVP data lines [9:0].
-	 * If only 8 bits data are wanted, the 8 bits data lines
-	 * of the camera interface must be physically connected
-	 * on the DVP data lines [9:2].
-	 *
-	 * Control lines polarity can be configured through
-	 * devicetree endpoint control lines properties.
-	 * If no endpoint control lines properties are set,
-	 * polarity will be as below:
-	 * - VSYNC:	active high
-	 * - HREF:	active low
-	 * - PCLK:	active low
-	 */
-
-	if (on) {
-		/*
-		 * configure parallel port control lines polarity
-		 *
-		 * POLARITY CTRL0
-		 * - [5]:	PCLK polarity (0: active low, 1: active high)
-		 * - [1]:	HREF polarity (0: active low, 1: active high)
-		 * - [0]:	VSYNC polarity (mismatch here between
-		 *		datasheet and hardware, 0 is active high
-		 *		and 1 is active low...)
-		 */
-		if (flags & V4L2_MBUS_PCLK_SAMPLE_RISING)
-			pclk_pol = 1;
-		if (flags & V4L2_MBUS_HSYNC_ACTIVE_HIGH)
-			hsync_pol = 1;
-		if (flags & V4L2_MBUS_VSYNC_ACTIVE_LOW)
-			vsync_pol = 1;
-
-		ret = ov5640_write_reg(sensor,
-				       OV5640_REG_POLARITY_CTRL00,
-				       (pclk_pol << 5) |
-				       (hsync_pol << 1) |
-				       vsync_pol);
-
-		if (ret)
-			return ret;
-	}
-
-	/*
-	 * powerdown MIPI TX/RX PHY & disable MIPI
-	 *
-	 * MIPI CONTROL 00
-	 * 4:	 PWDN PHY TX
-	 * 3:	 PWDN PHY RX
-	 * 2:	 MIPI enable
-	 */
-	ret = ov5640_write_reg(sensor,
-			       OV5640_REG_IO_MIPI_CTRL00, on ? 0x18 : 0);
-	if (ret)
-		return ret;
-
 	return ov5640_write_reg(sensor, OV5640_REG_SYS_CTRL0, on ?
 				OV5640_REG_SYS_CTRL0_SW_PWUP :
 				OV5640_REG_SYS_CTRL0_SW_PWDN);
@@ -2029,15 +1964,73 @@ static int ov5640_set_power_mipi(struct ov5640_dev *sensor, bool on)
 
 static int ov5640_set_power_dvp(struct ov5640_dev *sensor, bool on)
 {
+	unsigned int flags = sensor->ep.bus.parallel.flags;
+	u8 pclk_pol = 0;
+	u8 hsync_pol = 0;
+	u8 vsync_pol = 0;
 	int ret;
 
 	if (!on) {
 		/* Reset settings to their default values. */
+		ov5640_write_reg(sensor, OV5640_REG_IO_MIPI_CTRL00, 0x58);
+		ov5640_write_reg(sensor, OV5640_REG_POLARITY_CTRL00, 0x20);
 		ov5640_write_reg(sensor, OV5640_REG_PAD_OUTPUT_ENABLE01, 0x00);
 		ov5640_write_reg(sensor, OV5640_REG_PAD_OUTPUT_ENABLE02, 0x00);
 		return 0;
 	}
 
+	/*
+	 * Note about parallel port configuration.
+	 *
+	 * When configured in parallel mode, the OV5640 will
+	 * output 10 bits data on DVP data lines [9:0].
+	 * If only 8 bits data are wanted, the 8 bits data lines
+	 * of the camera interface must be physically connected
+	 * on the DVP data lines [9:2].
+	 *
+	 * Control lines polarity can be configured through
+	 * devicetree endpoint control lines properties.
+	 * If no endpoint control lines properties are set,
+	 * polarity will be as below:
+	 * - VSYNC:	active high
+	 * - HREF:	active low
+	 * - PCLK:	active low
+	 */
+	/*
+	 * configure parallel port control lines polarity
+	 *
+	 * POLARITY CTRL0
+	 * - [5]:	PCLK polarity (0: active low, 1: active high)
+	 * - [1]:	HREF polarity (0: active low, 1: active high)
+	 * - [0]:	VSYNC polarity (mismatch here between
+	 *		datasheet and hardware, 0 is active high
+	 *		and 1 is active low...)
+	 */
+	if (flags & V4L2_MBUS_PCLK_SAMPLE_RISING)
+		pclk_pol = 1;
+	if (flags & V4L2_MBUS_HSYNC_ACTIVE_HIGH)
+		hsync_pol = 1;
+	if (flags & V4L2_MBUS_VSYNC_ACTIVE_LOW)
+		vsync_pol = 1;
+
+	ret = ov5640_write_reg(sensor, OV5640_REG_POLARITY_CTRL00,
+			       (pclk_pol << 5) | (hsync_pol << 1) | vsync_pol);
+
+	if (ret)
+		return ret;
+
+	/*
+	 * powerdown MIPI TX/RX PHY & disable MIPI
+	 *
+	 * MIPI CONTROL 00
+	 * 4:	 PWDN PHY TX
+	 * 3:	 PWDN PHY RX
+	 * 2:	 MIPI enable
+	 */
+	ret = ov5640_write_reg(sensor, OV5640_REG_IO_MIPI_CTRL00, 0x18);
+	if (ret)
+		return ret;
+
 	/*
 	 * enable VSYNC/HREF/PCLK DVP control lines
 	 * & D[9:6] DVP data lines
-- 
2.40.1



