Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BB0F2EA171;
	Tue, 22 Jul 2025 14:10:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193400; cv=none; b=VDsmrls06579M7SKu6ON424ZhKMCbpFJcKSHzDfP7LxCQbyhpbfo5SPqt+MhnYIkmCOYGZL6um7chGlAw9z2HsMPPfSMm03jlTcjjZJPl3OpCVACAXKwLlIZkHOvm34TCk3J33qQp8VDosy5wNAKyqYCOV6JRm1zMz5tDeUw5nM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193400; c=relaxed/simple;
	bh=fbenKMpyitr6O00AWY4QsZyBoO4W9S9AEY/WKqo/LVw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CI+VilyOtV2zNcBYYjMmFAXMX+oPv+zbE4M5fNpNMdE443d0uYMzBbiSUe++nW5T/79RHT/axf5ey+JnOtD7A/GXilyiFVeGKpY/Lj32jy2/UoW3XeBye/y7eZmB3GfOeltopzgNaItycZNRijlOaeN8YE9rm4Cw0NeJmFPSfvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZsSA3nQZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZsSA3nQZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D38AC4CEEB;
	Tue, 22 Jul 2025 14:09:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193399;
	bh=fbenKMpyitr6O00AWY4QsZyBoO4W9S9AEY/WKqo/LVw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZsSA3nQZxsd7aBlxPbiD7/zO7sYX1KSmO0a46ioEa94OjB9gdme/sRaDYte2yKiZt
	 PwDzXYsG+o2CM+prX8M0ovXenOlp4hGxyWJu+oFH4gt75T++N32UkjP3EjuRbDE5zd
	 VAKsV79hJGzHjkYNB7md89ZMP0H0u+i72VeV4ZPk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.15 081/187] iio: adc: adi-axi-adc: fix ad7606_bus_reg_read()
Date: Tue, 22 Jul 2025 15:44:11 +0200
Message-ID: <20250722134348.744013083@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134345.761035548@linuxfoundation.org>
References: <20250722134345.761035548@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Lechner <dlechner@baylibre.com>

commit 6ac609d1fba19d5d40fb3c81201ffadcb6d00fb3 upstream.

Mask the value read before returning it. The value read over the
parallel bus via the AXI ADC IP block contains both the address and
the data, but callers expect val to only contain the data.

axi_adc_raw_write() takes a u32 parameter, so addr was the wrong type.
This wasn't causing any issues but is corrected anyway since we are
touching the same line to add a new variable.

Cc: stable@vger.kernel.org
Fixes: 79c47485e438 ("iio: adc: adi-axi-adc: add support for AD7606 register writing")
Signed-off-by: David Lechner <dlechner@baylibre.com>
Link: https://patch.msgid.link/20250530-iio-adc-adi-axi-adc-fix-ad7606_bus_reg_read-v2-1-ad2dfc0694ce@baylibre.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/adi-axi-adc.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/adc/adi-axi-adc.c b/drivers/iio/adc/adi-axi-adc.c
index 4116c44197b8..2dbaa0b5b3d6 100644
--- a/drivers/iio/adc/adi-axi-adc.c
+++ b/drivers/iio/adc/adi-axi-adc.c
@@ -445,7 +445,7 @@ static int axi_adc_raw_read(struct iio_backend *back, u32 *val)
 static int ad7606_bus_reg_read(struct iio_backend *back, u32 reg, u32 *val)
 {
 	struct adi_axi_adc_state *st = iio_backend_get_priv(back);
-	int addr;
+	u32 addr, reg_val;
 
 	guard(mutex)(&st->lock);
 
@@ -455,7 +455,9 @@ static int ad7606_bus_reg_read(struct iio_backend *back, u32 reg, u32 *val)
 	 */
 	addr = FIELD_PREP(ADI_AXI_REG_ADDRESS_MASK, reg) | ADI_AXI_REG_READ_BIT;
 	axi_adc_raw_write(back, addr);
-	axi_adc_raw_read(back, val);
+	axi_adc_raw_read(back, &reg_val);
+
+	*val = FIELD_GET(ADI_AXI_REG_VALUE_MASK, reg_val);
 
 	/* Write 0x0 on the bus to get back to ADC mode */
 	axi_adc_raw_write(back, 0);
-- 
2.50.1



