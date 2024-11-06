Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B64061EC019;
	Wed,  6 Nov 2024 13:02:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898121; cv=none; b=VeH6BLLwPMgZ0tiVrpIpQNZJGadxcQkR7OhXqY/l8jzCojmJ0gqsZYx8GzMp6DuMWs+pdpJWu+wPizJ9Jr+DZYyFAuc17LU82JboAlEksfa0xF16MtsMI+3Ytm5tIex7zJJCgSaNVUHrXhK5kandBru/TXpEPDpPgtUHREXn+Ec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898121; c=relaxed/simple;
	bh=70Jc+Yd3pHAhXPPrZIjuqlNEY4WNm8ddwtpEPt8u4uo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vEocpnWz8KJXt9JyttNeRr5QYQZOqWAuzAjSSD7pPB0D11jQW29Ec6DfQx8Nf4gvkMWVRkBC4T7ToBPcTVx43zGykEsOXIbqoC+aU2aBfBI2owUzgyOf+pmXXQQsrQzBLZUnhDHC/nbkhNuY90n8AyM6aWflxGSaLP7soSGVQGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jiapfr3R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jiapfr3R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BD3AC4CECD;
	Wed,  6 Nov 2024 13:02:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898121;
	bh=70Jc+Yd3pHAhXPPrZIjuqlNEY4WNm8ddwtpEPt8u4uo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jiapfr3Rp9nx6naL8d/Y4/KuN7kQdt0BY9Yu2oew+/kjc7xXeoovY81kpW6rU53SH
	 FZz2Pp/PqmhMhbFrmg37+wMAKH5dQDH6qHx5kkKBxfSy89ao1WVM8+cQWWRWx5r2nc
	 AapXYCYO4lY9hF8YF+H2+7no32N+ghriajzNLhN8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guillaume Stols <gstols@baylibre.com>,
	Nuno Sa <nuno.sa@analog.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 131/462] iio: adc: ad7606: fix standby gpio state to match the documentation
Date: Wed,  6 Nov 2024 13:00:24 +0100
Message-ID: <20241106120334.745392164@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guillaume Stols <gstols@baylibre.com>

[ Upstream commit 059fe4f8bbdf5cad212e1aeeb3e8968c80b9ff3b ]

The binding's documentation specifies that "As the line is active low, it
should be marked GPIO_ACTIVE_LOW". However, in the driver, it was handled
the opposite way. This commit sets the driver's behaviour in sync with the
documentation

Fixes: 722407a4e8c0 ("staging:iio:ad7606: Use GPIO descriptor API")
Signed-off-by: Guillaume Stols <gstols@baylibre.com>
Reviewed-by: Nuno Sa <nuno.sa@analog.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/ad7606.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/adc/ad7606.c b/drivers/iio/adc/ad7606.c
index acd555b51fb9c..806dd9cdbc649 100644
--- a/drivers/iio/adc/ad7606.c
+++ b/drivers/iio/adc/ad7606.c
@@ -445,7 +445,7 @@ static int ad7606_request_gpios(struct ad7606_state *st)
 		return PTR_ERR(st->gpio_range);
 
 	st->gpio_standby = devm_gpiod_get_optional(dev, "standby",
-						   GPIOD_OUT_HIGH);
+						   GPIOD_OUT_LOW);
 	if (IS_ERR(st->gpio_standby))
 		return PTR_ERR(st->gpio_standby);
 
@@ -706,7 +706,7 @@ static int ad7606_suspend(struct device *dev)
 
 	if (st->gpio_standby) {
 		gpiod_set_value(st->gpio_range, 1);
-		gpiod_set_value(st->gpio_standby, 0);
+		gpiod_set_value(st->gpio_standby, 1);
 	}
 
 	return 0;
-- 
2.43.0



