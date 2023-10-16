Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE37D1C28D
	for <patches@lists.linux.dev>; Mon, 16 Oct 2023 09:00:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dWzCFEH0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C60CC433C9;
	Mon, 16 Oct 2023 09:00:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1697446831;
	bh=YTSYUAzEK+R8WoH0lEPu2h4rsvKVEISP35u8pL2kzs4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dWzCFEH0Jeim+jPs/ppzbBk6yiHTl84p3snTgG5OVcKEm6sNfYQuqvGOx3haThs2r
	 rxDvy7fYqBkQIFYWPdW5cIa3kLyntVQesJ6H+lqIW+MBqwjF4lZmnwPCH2artBtr37
	 Hg7BRg2MHU3n6ji4hmp+TolrLaUWoJ6236zhaw0I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Phil Elwell <phil@raspberrypi.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.1 080/131] iio: pressure: bmp280: Fix NULL pointer exception
Date: Mon, 16 Oct 2023 10:41:03 +0200
Message-ID: <20231016084002.047194509@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231016084000.050926073@linuxfoundation.org>
References: <20231016084000.050926073@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Phil Elwell <phil@raspberrypi.com>

commit 85dfb43bf69281adb1f345dfd9a39faf2e5a718d upstream.

The bmp085 EOC IRQ support is optional, but the driver's common probe
function queries the IRQ properties whether or not it exists, which
can trigger a NULL pointer exception. Avoid any exception by making
the query conditional on the possession of a valid IRQ.

Fixes: aae953949651 ("iio: pressure: bmp280: add support for BMP085 EOC interrupt")
Signed-off-by: Phil Elwell <phil@raspberrypi.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://lore.kernel.org/r/20230811155829.51208-1-phil@raspberrypi.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/pressure/bmp280-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/pressure/bmp280-core.c
+++ b/drivers/iio/pressure/bmp280-core.c
@@ -1786,7 +1786,7 @@ int bmp280_common_probe(struct device *d
 	 * however as it happens, the BMP085 shares the chip ID of BMP180
 	 * so we look for an IRQ if we have that.
 	 */
-	if (irq > 0 || (chip_id  == BMP180_CHIP_ID)) {
+	if (irq > 0 && (chip_id  == BMP180_CHIP_ID)) {
 		ret = bmp085_fetch_eoc_irq(dev, name, irq, data);
 		if (ret)
 			return ret;


