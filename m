Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 552CA4E56C6;
	Fri,  9 Oct 2026 14:47:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557250; cv=none; b=hcE3xpkn/zSqqWl34Nx29CuQPlHcrZWuqfjFl6QytHd8kBMn/tEFoo+AfW65giJTwkanN2KyunksoXOQDzZnwj6tLU00qUVmmdHH/TDj8iyEI39eDgW6NK8PPXxhr9OMYJsy+oM4CRecSNqKsXJw0CnVjfn5B1TJIlSXQyxQkyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557250; c=relaxed/simple;
	bh=DGcuSSUIAjVgFKGi4qMlA6ADhhf+vAHmIfhEe4c69lY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jglpRabhzD8zv6XCrfUVdA1V3eNl+ZJy97AiTxJ6OS2b01dGBdy38chfEhN+cSBG3rznuIbabnmk4Ca6bFiQhTNAvU463yKekKYCGWCHTXZFPi/fK1LTc315s8iOBDFiSQ4BgkDo/S7AlihH+f23HCIVk8E8buYd6NT015g+L2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t6OoHYPD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t6OoHYPD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8E001F000FF;
	Fri,  9 Oct 2026 14:47:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557249;
	bh=Edrn7wVd2ogf4fAVLXDTRjlbPSNCTV/uNvpColwNxfo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t6OoHYPDvSYQBR8P77xHnJlgADFB4An5z2cMxzaYjrOj0CDsasicJpKzFDFA0dumU
	 +9XW2azzcB5noKfqUwT+6n+TgHnIHNwLj3Qd62ozd4r7jez8RtfI5XEwbS0t0uWeL7
	 LbpqqVu6xPIva9ydy8V6r9NDFvO4rKRHV9TuZjs4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Salah Triki <salah.triki@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 371/403] iio: adc: ad4030: fix invalid oversampling_ratio validation
Date: Fri,  9 Oct 2026 16:12:12 +0200
Message-ID: <20261009141000.984490392@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Salah Triki <salah.triki@gmail.com>

[ Upstream commit d615210564205993e8f0e7ccb57cc2e66b7d5706 ]

In ad4030_set_avg_frame_len(), the logarithm is calculated before input
validation. Passing zero or negative values leads to an undefined result
from ilog2().

Validate that the input is strictly positive prior to computing its
logarithm.

Fixes: 949abd1ca5a4 ("iio: adc: ad4030: add averaging support")
Assisted-by: LLM
Signed-off-by: Salah Triki <salah.triki@gmail.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
[ sashal: Adjusted context for the missing SPI offload code. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/ad4030.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/drivers/iio/adc/ad4030.c
+++ b/drivers/iio/adc/ad4030.c
@@ -514,13 +514,20 @@ static int ad4030_set_chan_calibbias(str
 static int ad4030_set_avg_frame_len(struct iio_dev *dev, int avg_val)
 {
 	struct ad4030_state *st = iio_priv(dev);
-	unsigned int avg_log2 = ilog2(avg_val);
 	unsigned int last_avg_idx = ARRAY_SIZE(ad4030_average_modes) - 1;
+	unsigned int avg_log2;
 	int ret;
 
-	if (avg_val < 0 || avg_val > ad4030_average_modes[last_avg_idx])
+	/* Reject unsupported modes */
+	if (avg_val > ad4030_average_modes[last_avg_idx])
 		return -EINVAL;
 
+	/* Avoid invalid values for logarithm since it's undefined */
+	if (avg_val < 1)
+		return -EINVAL;
+
+	avg_log2 = ilog2(avg_val);
+
 	ret = regmap_write(st->regmap, AD4030_REG_AVG,
 			   AD4030_REG_AVG_MASK_AVG_SYNC |
 			   FIELD_PREP(AD4030_REG_AVG_MASK_AVG_VAL, avg_log2));


