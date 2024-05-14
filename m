Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BE9A5CDF0;
	Tue, 14 May 2024 11:50:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687454; cv=none; b=k4FJonxk7HpfHfGBvFqw8kZWwzOscZH6I2sIrONfW1LTyM4ik9uW2VrCLK0ud3mjqi3wYn60UrHQCsf98SBuZyINwSTqLEojpX8dhJQs6Il5ZNUdgJy+SajhlXeMNFsvHoV8bSpHVvjHKm/GnsL5A+Rvrdr2f/5xr4ZeByDJ8ww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687454; c=relaxed/simple;
	bh=XGeXjwiaB+7hHnoAvm+DHgS3m8dv7L8Fcf8rAXMgyew=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nLJOBYAdNECRTnaq6lwxxfWSsTz1P6dnPbLMfuajqeqEvcluJdEypfPskH1ySV29y6IIAwosioijD9LSaSpsP8p8sTdbNPkW0e4lu6XqM5/YX8kvZZCJnjKzp9QUwYQhPRDAUgJfedvSjj1gLSrv4zn7Tyc/L3lEAhQe3FvVvog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mY6vuT30; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mY6vuT30"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87F98C2BD10;
	Tue, 14 May 2024 11:50:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687453;
	bh=XGeXjwiaB+7hHnoAvm+DHgS3m8dv7L8Fcf8rAXMgyew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mY6vuT30iEahqq0UNk6jU10+JhzqDbFESHyw/hp9mbzWxCc4QbI/Yrhr0Q12MMry7
	 C32gLjv4L3u0cFktCEqC/LIDTtlCHiUx8UVVDSDUv4vlxQCNnLQJzO7UgCcYB05q+p
	 DZRdxqmX1V6TdnuRvA4hv+VRSapXHlwcAspPk3zc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.10 102/111] iio: accel: mxc4005: Interrupt handling fixes
Date: Tue, 14 May 2024 12:20:40 +0200
Message-ID: <20240514101001.008522239@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514100957.114746054@linuxfoundation.org>
References: <20240514100957.114746054@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit 57a1592784d622ecee0b71940c65429173996b33 upstream.

There are 2 issues with interrupt handling in the mxc4005 driver:

1. mxc4005_set_trigger_state() writes MXC4005_REG_INT_MASK1_BIT_DRDYE
(0x01) to INT_MASK1 to enable the interrupt, but to disable the interrupt
it writes ~MXC4005_REG_INT_MASK1_BIT_DRDYE which is 0xfe, so it enables
all other interrupt sources in the INT_SRC1 register. On the MXC4005 this
is not an issue because only bit 0 of the register is used. On the MXC6655
OTOH this is a problem since bit7 is used as TC (Temperature Compensation)
disable bit and writing 1 to this disables Temperature Compensation which
should only be done when running self-tests on the chip.

Write 0 instead of ~MXC4005_REG_INT_MASK1_BIT_DRDYE to disable
the interrupts to fix this.

2. The datasheets for the MXC4005 / MXC6655 do not state what the reset
value for the INT_MASK0 and INT_MASK1 registers is and since these are
write only we also cannot learn this from the hw. Presumably the reset
value for both is all 0, which means all interrupts disabled.

Explicitly set both registers to 0 from mxc4005_chip_init() to ensure
both masks are actually set to 0.

Fixes: 79846e33aac1 ("iio: accel: mxc4005: add support for mxc6655")
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20240326113700.56725-2-hdegoede@redhat.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/accel/mxc4005.c |   24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

--- a/drivers/iio/accel/mxc4005.c
+++ b/drivers/iio/accel/mxc4005.c
@@ -27,9 +27,13 @@
 #define MXC4005_REG_ZOUT_UPPER		0x07
 #define MXC4005_REG_ZOUT_LOWER		0x08
 
+#define MXC4005_REG_INT_MASK0		0x0A
+
 #define MXC4005_REG_INT_MASK1		0x0B
 #define MXC4005_REG_INT_MASK1_BIT_DRDYE	0x01
 
+#define MXC4005_REG_INT_CLR0		0x00
+
 #define MXC4005_REG_INT_CLR1		0x01
 #define MXC4005_REG_INT_CLR1_BIT_DRDYC	0x01
 
@@ -113,7 +117,9 @@ static bool mxc4005_is_readable_reg(stru
 static bool mxc4005_is_writeable_reg(struct device *dev, unsigned int reg)
 {
 	switch (reg) {
+	case MXC4005_REG_INT_CLR0:
 	case MXC4005_REG_INT_CLR1:
+	case MXC4005_REG_INT_MASK0:
 	case MXC4005_REG_INT_MASK1:
 	case MXC4005_REG_CONTROL:
 		return true;
@@ -334,17 +340,13 @@ static int mxc4005_set_trigger_state(str
 {
 	struct iio_dev *indio_dev = iio_trigger_get_drvdata(trig);
 	struct mxc4005_data *data = iio_priv(indio_dev);
+	unsigned int val;
 	int ret;
 
 	mutex_lock(&data->mutex);
-	if (state) {
-		ret = regmap_write(data->regmap, MXC4005_REG_INT_MASK1,
-				   MXC4005_REG_INT_MASK1_BIT_DRDYE);
-	} else {
-		ret = regmap_write(data->regmap, MXC4005_REG_INT_MASK1,
-				   ~MXC4005_REG_INT_MASK1_BIT_DRDYE);
-	}
 
+	val = state ? MXC4005_REG_INT_MASK1_BIT_DRDYE : 0;
+	ret = regmap_write(data->regmap, MXC4005_REG_INT_MASK1, val);
 	if (ret < 0) {
 		mutex_unlock(&data->mutex);
 		dev_err(data->dev, "failed to update reg_int_mask1");
@@ -386,6 +388,14 @@ static int mxc4005_chip_init(struct mxc4
 
 	dev_dbg(data->dev, "MXC4005 chip id %02x\n", reg);
 
+	ret = regmap_write(data->regmap, MXC4005_REG_INT_MASK0, 0);
+	if (ret < 0)
+		return dev_err_probe(data->dev, ret, "writing INT_MASK0\n");
+
+	ret = regmap_write(data->regmap, MXC4005_REG_INT_MASK1, 0);
+	if (ret < 0)
+		return dev_err_probe(data->dev, ret, "writing INT_MASK1\n");
+
 	return 0;
 }
 


