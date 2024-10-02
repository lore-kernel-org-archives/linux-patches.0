Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B05B1D016B;
	Wed,  2 Oct 2024 13:43:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876592; cv=none; b=Zl6DrTaEAkVlO+47rm6qPYLfO3/OTs4ALspAiJ0AWl8E7wyGB0U35Ge6fGXiXtO4LfA2OpyNJ9Bj1JJWcSOux0d3AA1rQJO6u3wCfW+u6mqBUPRL2IwwlDB0wcS59J5C9Di5CnZc9cGwpw22IgWcVidlf/T3CKAUkg57RetM/v4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876592; c=relaxed/simple;
	bh=vMhEhzSEddfBZbF4ZqzQsO6jD3KlTUS0o/SXxk4mLtE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YZ8agDmd1jisYl5yWwShawOtGmpUwESPQPVS6LPmmi4vnf3b/y+exgL9a5w126A91zScN+OH1aUY9fjzjRye66nzh7YHHjXpqyRxlIEZQfLIX/h+8sB7urgz5eo0GwW4OvYsCCtabTF33YMfMzdsKfncW/ou3Ll7y6EUeTpVScg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jFIRWQcI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jFIRWQcI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63D8EC4CEC5;
	Wed,  2 Oct 2024 13:43:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876591;
	bh=vMhEhzSEddfBZbF4ZqzQsO6jD3KlTUS0o/SXxk4mLtE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jFIRWQcIM8aboyFw8fZgwTh5MXjQ3dQvXCSI8pMQ5voQx8YLVV0n5YEDo8L0Kc6mN
	 EJo/U8afmync5ppz5neOzUh8q0ExIV1KkgKW66cY3HM1hU9ce/zl+kuPjZEfDWIP+L
	 zZIgNztdsWDQs0FH7O6xkOtYRY+VvopDbX+0zdpI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guillaume Stols <gstols@baylibre.com>,
	Nuno Sa <nuno.sa@analog.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 455/695] iio: adc: ad7606: fix standby gpio state to match the documentation
Date: Wed,  2 Oct 2024 14:57:33 +0200
Message-ID: <20241002125840.618364878@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index a123a9e35b33f..8f9ee56c8bed2 100644
--- a/drivers/iio/adc/ad7606.c
+++ b/drivers/iio/adc/ad7606.c
@@ -419,7 +419,7 @@ static int ad7606_request_gpios(struct ad7606_state *st)
 		return PTR_ERR(st->gpio_range);
 
 	st->gpio_standby = devm_gpiod_get_optional(dev, "standby",
-						   GPIOD_OUT_HIGH);
+						   GPIOD_OUT_LOW);
 	if (IS_ERR(st->gpio_standby))
 		return PTR_ERR(st->gpio_standby);
 
@@ -662,7 +662,7 @@ static int ad7606_suspend(struct device *dev)
 
 	if (st->gpio_standby) {
 		gpiod_set_value(st->gpio_range, 1);
-		gpiod_set_value(st->gpio_standby, 0);
+		gpiod_set_value(st->gpio_standby, 1);
 	}
 
 	return 0;
-- 
2.43.0



