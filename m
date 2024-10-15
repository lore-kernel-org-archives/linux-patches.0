Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65A4419B3FF;
	Tue, 15 Oct 2024 11:49:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992984; cv=none; b=gLf5RAtcHPU3o6I/4+dlu5EhGjd665mhb8hv3G63H0TxEEm+Q1qMHvBwH6LXQ+3T+69V2Tv5MLH22PcniyeO+ZRZt5IHhiTaILZ6chlZRLtzOJTNIfq0GebTj9mVJ0EmCz/Eh/EAcbXrvjxf0Bp8RHscjjGgHqQO3/LJRubVeak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992984; c=relaxed/simple;
	bh=gWeErafrvDxhwmrydS9Zg17En+JGNUrWd8qU2IN4eSA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FQWy+F/ZrGsN8L15GrkMR6d0SILqRHVOWLAmNltnggcSFR6XME6RdCs0KISnNqsP7nM6C2X5UxSY/3tI26EEgwmTi8ZyiSZ8afaFmm1TuqBa1Rv4bHp5khznzdrvfILZ65+vsvkrAyyMaBfjWOWZIVkoA4G4wOkcK5kCgSguAyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fcwH50KS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fcwH50KS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8041C4CECF;
	Tue, 15 Oct 2024 11:49:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992984;
	bh=gWeErafrvDxhwmrydS9Zg17En+JGNUrWd8qU2IN4eSA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fcwH50KSVO1QTr7Lxxu3FiD2nYX6NycKpo7HqlTsetmxP/Vv7pZBzMdHAKaO1yKvP
	 m/7XaAcKR81AKSGSVSYbe39/LW4ynMdZ05sviopLj9MwkfFfShquRKlYs4WCRQF/YI
	 pJJhTl1rh7UvSPDuPOw0GvAz7GRkxYpTRB4RnH0k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guillaume Stols <gstols@baylibre.com>,
	Nuno Sa <nuno.sa@analog.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 275/691] iio: adc: ad7606: fix standby gpio state to match the documentation
Date: Tue, 15 Oct 2024 13:23:43 +0200
Message-ID: <20241015112451.260233242@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 0faed0a69d59c..cc5c3d994d348 100644
--- a/drivers/iio/adc/ad7606.c
+++ b/drivers/iio/adc/ad7606.c
@@ -445,7 +445,7 @@ static int ad7606_request_gpios(struct ad7606_state *st)
 		return PTR_ERR(st->gpio_range);
 
 	st->gpio_standby = devm_gpiod_get_optional(dev, "standby",
-						   GPIOD_OUT_HIGH);
+						   GPIOD_OUT_LOW);
 	if (IS_ERR(st->gpio_standby))
 		return PTR_ERR(st->gpio_standby);
 
@@ -704,7 +704,7 @@ static int ad7606_suspend(struct device *dev)
 
 	if (st->gpio_standby) {
 		gpiod_set_value(st->gpio_range, 1);
-		gpiod_set_value(st->gpio_standby, 0);
+		gpiod_set_value(st->gpio_standby, 1);
 	}
 
 	return 0;
-- 
2.43.0



