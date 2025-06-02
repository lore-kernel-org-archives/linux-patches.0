Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2E7F229B2A;
	Mon,  2 Jun 2025 14:40:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875202; cv=none; b=hujr5VF5qiAx7e7mUk/s4SsZXEWHEDeLBlPx+EdzDo/T6KS+xt/el0U3gKbV+i7mmYRw+ZIFkalfOQ5zr19cUjIrb4IrY/QYl9kPBK49cqWnLJb6riMoERxi6++cV80qdxA0D36zoYctDVFOSRhOHOFHa01DgT23FQ+iklc3JaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875202; c=relaxed/simple;
	bh=nxwwf5gbaIsKSis9LXOQ8mtfczdJcD8CfMqeWqLBl+I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NIygVTCsD9JbnuP5WWqUdkpCD6D6O9h209GsN4cqyEFPDmVfXMVug1II43UOcj1x9u1eAs5HkjWDxAj5YycqYGNyvS2Sj27iIsVr/1IcE3zZXPZ/OZMzSjgQDaqpyRUG06WYzw0vXuJrXrVpfPyPd27taNsWNYTm6c95HY2vrO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xkDyivcf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xkDyivcf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41527C4CEEB;
	Mon,  2 Jun 2025 14:40:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875202;
	bh=nxwwf5gbaIsKSis9LXOQ8mtfczdJcD8CfMqeWqLBl+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xkDyivcfRpo3W2PWspu00XLQ6jqCl9GE+W6hxFcVYyxHRaRoGUmr+KFS4HTcb0sy0
	 zLcx0mZNOoWjC/LRz2TOmx4kbaYWgYXXm9FLqbyIbFjHylTerRtcSKgIStbiv4phe3
	 +Ie+EsZc7nlpXUshqBR9Mh+728vK3eMo7+0rfAcM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	Angelo Dureghello <adureghello@baylibre.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.10 059/270] iio: adc: ad7606: fix serial register access
Date: Mon,  2 Jun 2025 15:45:44 +0200
Message-ID: <20250602134309.607188226@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134307.195171844@linuxfoundation.org>
References: <20250602134307.195171844@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Angelo Dureghello <adureghello@baylibre.com>

commit f083f8a21cc785ebe3a33f756a3fa3660611f8db upstream.

Fix register read/write routine as per datasheet.

When reading multiple consecutive registers, only the first one is read
properly. This is due to missing chip select deassert and assert again
between first and second 16bit transfer, as shown in the datasheet
AD7606C-16, rev 0, figure 110.

Fixes: f2a22e1e172f ("iio: adc: ad7606: Add support for software mode for ad7616")
Reviewed-by: David Lechner <dlechner@baylibre.com>
Signed-off-by: Angelo Dureghello <adureghello@baylibre.com>
Link: https://patch.msgid.link/20250418-wip-bl-ad7606-fix-reg-access-v3-1-d5eeb440c738@baylibre.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/ad7606_spi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/adc/ad7606_spi.c
+++ b/drivers/iio/adc/ad7606_spi.c
@@ -127,7 +127,7 @@ static int ad7606_spi_reg_read(struct ad
 		{
 			.tx_buf = &st->d16[0],
 			.len = 2,
-			.cs_change = 0,
+			.cs_change = 1,
 		}, {
 			.rx_buf = &st->d16[1],
 			.len = 2,


