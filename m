Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9556223183A;
	Mon,  2 Jun 2025 14:29:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874578; cv=none; b=CIGl8DCHFE1TdWAv4rlQrLxweDbC68Y9iq4CDlhRclPPGJNPy08y7GaqIrsuyhlOWm9skNkzm5fSq7eo78QA9Q7LYfCkPX/nYHnA7ipRjWplOfUbseGUhJcCVJ5/MI6FJPulIv086p0F0Gfd7HAsJfd0sFfJS+7/MHIFaDOe7Hg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874578; c=relaxed/simple;
	bh=FMTmsmKrUeiJGS1cnOy79AZya4X28iJGkLrOeum80s0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UowREeRNzGExAQVBIASBEjKvpj9T471svcKv6TdVQYA6f6dRsZZlHAMnFQ+WXqUP4TH8UWZJUpGtvnu0crKKVZHPbT01B5X74rQleJG51SHZpHhPCU45jPVlRFpwR//ALIC++0mLbIIcl4S5I+RGmrG40oZP53+F3dhbvhumZew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nPSRX0qz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nPSRX0qz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06C41C4CEEE;
	Mon,  2 Jun 2025 14:29:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874578;
	bh=FMTmsmKrUeiJGS1cnOy79AZya4X28iJGkLrOeum80s0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nPSRX0qzZOUKH55EJrIFv0O1tlIf4XDfYXwEufmQKpkZAYwCliZ/leFbnUVfFA4mJ
	 x8Zlp3JQ6HOO27rHtyRx93833jWTEpSQC0MeAp8BhFYRwUt6/8zpmvkT/vp8z3XNOn
	 MPexrFrWtFSTDytkmYJXdXnACEKnC4QQbjRBZYzs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	Angelo Dureghello <adureghello@baylibre.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.4 041/204] iio: adc: ad7606: fix serial register access
Date: Mon,  2 Jun 2025 15:46:14 +0200
Message-ID: <20250602134257.292829288@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134255.449974357@linuxfoundation.org>
References: <20250602134255.449974357@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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


