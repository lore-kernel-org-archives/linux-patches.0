Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F01C255F4D;
	Mon, 12 May 2025 17:53:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072415; cv=none; b=GGhs1sil0498q3e7KONeHy/CmgBMcQy4zZ4+mxYeMhvoLFa88wmaQcdrUlFZLx9yscbSDOAQ+lYHzABCcpBwAr49Okd4eUaKF1/bf0aSevnhXHppxrQwOYb8zEccOmDRk9d3KFwDN6Y+KKGBiH54hBOYFjykOcVnb1wyh5ANJ6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072415; c=relaxed/simple;
	bh=WKmdLWv/fSInA4eRRlvu2uoKqgJcQG2/UNc6Pru5dZw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jMy+7xsmKHN4B9UzsUg0ExWvMP3F73FAqvSYNc0APHHZzt1f2d05hZQAqvgv9N773U/LEo+WZKmuJlnkQLUU3WCtv0MI2P1tvrnHo55OYHKJ/rAsPL0AAGAK29f0e2TD7Ngyqfa1wSntsCY66pBF+5bafvS9ZXrUSheCOKbRcAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GBbiXwPe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GBbiXwPe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2CB8C4CEE7;
	Mon, 12 May 2025 17:53:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072415;
	bh=WKmdLWv/fSInA4eRRlvu2uoKqgJcQG2/UNc6Pru5dZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GBbiXwPeVapQWJCrOXDlPLyAliPity99A4FIUB6lYjZ/RHV9JS6ZY56HmWl56Aywz
	 a0/284v2GYOMK0r6NoJWegktwUdYFxHNaCTAKD5aO7AkSX0uHENx/ypltSJ9qW928+
	 /8Expn3J72VGWEKSSIwflgYIwkeQVDWbX4PPX/AM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	Angelo Dureghello <adureghello@baylibre.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.1 34/92] iio: adc: ad7606: fix serial register access
Date: Mon, 12 May 2025 19:45:09 +0200
Message-ID: <20250512172024.520697889@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172023.126467649@linuxfoundation.org>
References: <20250512172023.126467649@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


