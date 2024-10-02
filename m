Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ACDF1D0438;
	Wed,  2 Oct 2024 14:42:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727880129; cv=none; b=Vyq3F+9tedfq9C4zyxVrrjLLYYVMLEfKrR0Yk8/V0F6/DwS9Ue3s0+8B967G6LjPCtWZJFY5A2HUeTeWjDtDbFyx8OKGTpTBa6R4c6vgVFQDWFfwr+bz3n3i5Q6kaKR1r2Z4dRm7un4egL4/OoysWaXJ7G4R2cofwxd2IQC1wsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727880129; c=relaxed/simple;
	bh=GTcDYJvIhFaIcmfTKRhR3nc3g60Q+pL3pRAXj2PO3oI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e7vQf9ezmQLbl4Mk2GL7Hc0fYmw0fo1i+MP1B0Upjwmz/3uJ7ZI5Djq8pdYrF9qVd0p5LljFaiWKPW9vSPkHLoxaDMdde7OgKtU/xehGJzhqEEKYah2Pj5chEBbkya3K+BXM0J0Qr+2qKcszc8yamgzs3rXLUPe0RnyusbJFnLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LpXVSbdR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LpXVSbdR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C831CC4CEC2;
	Wed,  2 Oct 2024 14:42:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727880129;
	bh=GTcDYJvIhFaIcmfTKRhR3nc3g60Q+pL3pRAXj2PO3oI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LpXVSbdRIcwhkCtQhNn+fXr88l4Vh/+Ryba79PMf2UhynYEhgq/6QCyueWo9Qw+3d
	 TOrqEwlsswvkvavTdoYz0EuFaCR4D1UZhVxSV4TkUsKXnaHYeTY9Fnl01KP8VSRvc9
	 jAtnav9ifgLaP8MOmQT7hKC1YdPaNw8HBp/c2YiE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guillaume Stols <gstols@baylibre.com>,
	Nuno Sa <nuno.sa@analog.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 353/538] iio: adc: ad7606: fix oversampling gpio array
Date: Wed,  2 Oct 2024 14:59:52 +0200
Message-ID: <20241002125806.361995507@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

From: Guillaume Stols <gstols@baylibre.com>

[ Upstream commit 8dc4594b54dbaaba40dc8884ad3d42083de39434 ]

gpiod_set_array_value was misused here: the implementation relied on the
assumption that an unsigned long was required for each gpio, while the
function expects a bit array stored in "as much unsigned long as needed
for storing one bit per GPIO", i.e it is using a bit field.

This leaded to incorrect parameter passed to gpiod_set_array_value, that
would set 1 value instead of 3.
It also prevents to select the software mode correctly for the AD7606B.

Fixes: d2a415c86c6b ("iio: adc: ad7606: Add support for AD7606B ADC")
Fixes: 41f71e5e7daf ("staging: iio: adc: ad7606: Use find_closest() macro")
Signed-off-by: Guillaume Stols <gstols@baylibre.com>
Reviewed-by: Nuno Sa <nuno.sa@analog.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/ad7606.c     | 4 ++--
 drivers/iio/adc/ad7606_spi.c | 5 +++--
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/iio/adc/ad7606.c b/drivers/iio/adc/ad7606.c
index 1c08c0921ee71..8c66b1e364014 100644
--- a/drivers/iio/adc/ad7606.c
+++ b/drivers/iio/adc/ad7606.c
@@ -215,9 +215,9 @@ static int ad7606_write_os_hw(struct iio_dev *indio_dev, int val)
 	struct ad7606_state *st = iio_priv(indio_dev);
 	DECLARE_BITMAP(values, 3);
 
-	values[0] = val;
+	values[0] = val & GENMASK(2, 0);
 
-	gpiod_set_array_value(ARRAY_SIZE(values), st->gpio_os->desc,
+	gpiod_set_array_value(st->gpio_os->ndescs, st->gpio_os->desc,
 			      st->gpio_os->info, values);
 
 	/* AD7616 requires a reset to update value */
diff --git a/drivers/iio/adc/ad7606_spi.c b/drivers/iio/adc/ad7606_spi.c
index 263a778bcf253..287a0591533b6 100644
--- a/drivers/iio/adc/ad7606_spi.c
+++ b/drivers/iio/adc/ad7606_spi.c
@@ -249,8 +249,9 @@ static int ad7616_sw_mode_config(struct iio_dev *indio_dev)
 static int ad7606B_sw_mode_config(struct iio_dev *indio_dev)
 {
 	struct ad7606_state *st = iio_priv(indio_dev);
-	unsigned long os[3] = {1};
+	DECLARE_BITMAP(os, 3);
 
+	bitmap_fill(os, 3);
 	/*
 	 * Software mode is enabled when all three oversampling
 	 * pins are set to high. If oversampling gpios are defined
@@ -258,7 +259,7 @@ static int ad7606B_sw_mode_config(struct iio_dev *indio_dev)
 	 * otherwise, they must be hardwired to VDD
 	 */
 	if (st->gpio_os) {
-		gpiod_set_array_value(ARRAY_SIZE(os),
+		gpiod_set_array_value(st->gpio_os->ndescs,
 				      st->gpio_os->desc, st->gpio_os->info, os);
 	}
 	/* OS of 128 and 256 are available only in software mode */
-- 
2.43.0



