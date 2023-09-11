Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EF4A1170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:16:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6B16C433C7;
	Mon, 11 Sep 2023 14:16:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694441791;
	bh=0yLlJ5V2MOK7k63UcFLdDFmBc3SyYi0nMTlhsACnOtQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1Lw4wuRJJcf+rTqQuGoH/FXjmSKrF/PxutRwmT9Zi/YXflRcnjJaIjfJGPJi3+Uoa
	 eSBey53FO+/xNhw8Oh8S35LVfGUVezVWfkReq/M+pRD7BepNa+KKavnQFQ7j7d90ZQ
	 ydC2hwUuYwx7JSR0tTEo1XSb1slHgK0XTmHkAm7I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacopo Mondi <jacopo.mondi@ideasonboard.com>,
	Marek Vasut <marex@denx.de>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Jai Luthra <j-luthra@ti.com>
Subject: [PATCH 6.5 538/739] media: ov5640: Enable MIPI interface in ov5640_set_power_mipi()
Date: Mon, 11 Sep 2023 15:45:37 +0200
Message-ID: <20230911134706.127380675@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Vasut <marex@denx.de>

[ Upstream commit 98cb72d3b9c5e03b10fa993752ecfcbd9c572d8c ]

Set OV5640_REG_IO_MIPI_CTRL00 bit 2 to 1 instead of 0, since 1 means
MIPI CSI2 interface, while 0 means CPI parallel interface.

In the ov5640_set_power_mipi() the interface should obviously be set
to MIPI CSI2 since this functions is used to power up the sensor when
operated in MIPI CSI2 mode. The sensor should not be in CPI mode in
that case.

This fixes a corner case where capturing the first frame on i.MX8MN
with CSI/ISI resulted in corrupted frame.

Fixes: aa4bb8b8838f ("media: ov5640: Re-work MIPI startup sequence")
Reviewed-by: Jacopo Mondi <jacopo.mondi@ideasonboard.com>
Tested-by: Jacopo Mondi <jacopo.mondi@ideasonboard.com> # [Test on imx6q]
Signed-off-by: Marek Vasut <marex@denx.de>
Tested-by: Jai Luthra <j-luthra@ti.com> # [Test on bplay, sk-am62]
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/ov5640.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
index f6c94e9094761..514f794a27883 100644
--- a/drivers/media/i2c/ov5640.c
+++ b/drivers/media/i2c/ov5640.c
@@ -2542,9 +2542,9 @@ static int ov5640_set_power_mipi(struct ov5640_dev *sensor, bool on)
 	 *		  "ov5640_set_stream_mipi()")
 	 * [4] = 0	: Power up MIPI HS Tx
 	 * [3] = 0	: Power up MIPI LS Rx
-	 * [2] = 0	: MIPI interface disabled
+	 * [2] = 1	: MIPI interface enabled
 	 */
-	ret = ov5640_write_reg(sensor, OV5640_REG_IO_MIPI_CTRL00, 0x40);
+	ret = ov5640_write_reg(sensor, OV5640_REG_IO_MIPI_CTRL00, 0x44);
 	if (ret)
 		return ret;
 
-- 
2.40.1



