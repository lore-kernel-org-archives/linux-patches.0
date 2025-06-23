Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8381250BEC;
	Mon, 23 Jun 2025 13:28:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685334; cv=none; b=ZowkpZO17dfmpsrBZG3qj0S17OrZo8iwRub4GOHQ9ZiDaWR0c/Eya1j3kHPCxK48h3Q1YYzQ8yW39NBj1h6bxSyAKCpwChfRX9ISXQ55MPYbf6lS7nh4kI7zGhIFxp3QuZxfzSwkIegxpcRKhvHiwNu6w++qzrlONhfvEgUAmLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685334; c=relaxed/simple;
	bh=1uFZ9p0FNSvAOxAYlURTk7HQ/TF0x5O5fdiT1GvxWS4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q/XiBNCAXKOx5X5Ya8j8t7jTJnTZGiYwHcxRSk+SDKdq2xfP4vnXE3uzE7zOXYiD2Eecy4jFZTDUwst55eDUdDA7gAb7Jt+nstuHL/YKledcGvxltEYN3psL7jIcYsAn7VWKZ2ITvb9yonVFF8C+OTmeGmt08JHT/E+dXvzwNU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RHP3IR6s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RHP3IR6s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CB86C4CEEA;
	Mon, 23 Jun 2025 13:28:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685333;
	bh=1uFZ9p0FNSvAOxAYlURTk7HQ/TF0x5O5fdiT1GvxWS4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RHP3IR6sA1hbPakG3OHWns9CsusZakwH2tYJmZOb5e8WWmU17c+hdYOThjXD6o4B8
	 Yz9akTFWozBZJoP2kde7kCT5XAtIvfxCauMElDynfKzExQw6kgqtv+Htc8ic3GWFbi
	 2uGlZxp9ev6H3+TkM9Xbtcy/LWA0jzVXZ95LykJg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.15 205/592] iio: adc: ad7606: fix raw read for 18-bit chips
Date: Mon, 23 Jun 2025 15:02:43 +0200
Message-ID: <20250623130705.164726490@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

commit 3f5fd1717ae9497215f22aa748fc2c09df88b0e3 upstream.

Fix 18-bit raw read for 18-bit chips by applying a mask to the value
we receive from the SPI controller.

SPI controllers either return 1, 2 or 4 bytes per word depending on the
bits_per_word. For 16-bit chips, there was no problem since they raw
data fit exactly in the 2 bytes received from the SPI controller. But
now that we have 18-bit chips and we are using bits_per_word = 18, we
cannot assume that the extra bits in the 32-bit word are always zero.
In fact, with the AXI SPI Engine controller, these bits are not always
zero which caused the raw values to read 10s of 1000s of volts instead
of the correct value. Therefore, we need to mask the value we receive
from the SPI controller to ensure that only the 18 bits of real data
are used.

Fixes: f3838e934dff ("iio: adc: ad7606: add support for AD7606C-{16,18} parts")
Signed-off-by: David Lechner <dlechner@baylibre.com>
Link: https://patch.msgid.link/20250502-iio-adc-ad7606-fix-raw-read-for-18-bit-chips-v1-1-06caa92d8f11@baylibre.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/ad7606.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/iio/adc/ad7606.c b/drivers/iio/adc/ad7606.c
index 703556eb7257..8ed65a35b486 100644
--- a/drivers/iio/adc/ad7606.c
+++ b/drivers/iio/adc/ad7606.c
@@ -727,17 +727,16 @@ static int ad7606_scan_direct(struct iio_dev *indio_dev, unsigned int ch,
 		goto error_ret;
 
 	chan = &indio_dev->channels[ch + 1];
-	if (chan->scan_type.sign == 'u') {
-		if (realbits > 16)
-			*val = st->data.buf32[ch];
-		else
-			*val = st->data.buf16[ch];
-	} else {
-		if (realbits > 16)
-			*val = sign_extend32(st->data.buf32[ch], realbits - 1);
-		else
-			*val = sign_extend32(st->data.buf16[ch], realbits - 1);
-	}
+
+	if (realbits > 16)
+		*val = st->data.buf32[ch];
+	else
+		*val = st->data.buf16[ch];
+
+	*val &= GENMASK(realbits - 1, 0);
+
+	if (chan->scan_type.sign == 's')
+		*val = sign_extend32(*val, realbits - 1);
 
 error_ret:
 	if (!st->gpio_convst) {
-- 
2.50.0



