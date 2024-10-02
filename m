Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38C3E1D14F8;
	Wed,  2 Oct 2024 14:42:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727880132; cv=none; b=akDqxLP8KHcvCqBRgW46aJ05pZtLLrBDURqNhl8y1DklqYcIiJoSzNy5G5Xu3FU8cuZ7mChydIsjeUIx50F+EyhIE8T1g6ctIxotcJxhSfq5DJjXspnxGCQNplC2jvYD0r807DkVOUkVFzE0+nGM90ubYYxJuNNyR547mM9Q5KY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727880132; c=relaxed/simple;
	bh=aNUfL5iJ20FvS6+iZohuwFWRq7wWyYLhwq1un2MZfwc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u16BWr2B2IcUpK9PqKtTf9dakNYsNP98TZhnqGVFekWJdvzWO/zulX71UdMlzTEJaw0vd3OQtDn6xmk8MQlK4KSL75dJYkANp1KI2zkSwJmk96pOgV8ejNBhe8VQPTdXEZVIoySwmfYj+oYHf+GAfi8phnMsUu7rlCOK8xSFOco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xqriVk1L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xqriVk1L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B389CC4CEC2;
	Wed,  2 Oct 2024 14:42:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727880132;
	bh=aNUfL5iJ20FvS6+iZohuwFWRq7wWyYLhwq1un2MZfwc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xqriVk1LeOulyS5WG0dtHOcJxTTuQVz3fSSIlYBcRcyPAPWSx91yBUh4tsYJgD2f3
	 Iwu6Kogw73hgMoz7Xp8fJdHK0QdpK/iEuqKlI2DEgcZscTjqp2tea3ZHac+aF1kN3l
	 ooHY9xRwz3nf7M1hPLFNomkUYxjuMC6qFJ348eLA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guillaume Stols <gstols@baylibre.com>,
	Nuno Sa <nuno.sa@analog.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 354/538] iio: adc: ad7606: fix standby gpio state to match the documentation
Date: Wed,  2 Oct 2024 14:59:53 +0200
Message-ID: <20241002125806.400978117@linuxfoundation.org>
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
index 8c66b1e364014..4d755ffc3f414 100644
--- a/drivers/iio/adc/ad7606.c
+++ b/drivers/iio/adc/ad7606.c
@@ -422,7 +422,7 @@ static int ad7606_request_gpios(struct ad7606_state *st)
 		return PTR_ERR(st->gpio_range);
 
 	st->gpio_standby = devm_gpiod_get_optional(dev, "standby",
-						   GPIOD_OUT_HIGH);
+						   GPIOD_OUT_LOW);
 	if (IS_ERR(st->gpio_standby))
 		return PTR_ERR(st->gpio_standby);
 
@@ -665,7 +665,7 @@ static int ad7606_suspend(struct device *dev)
 
 	if (st->gpio_standby) {
 		gpiod_set_value(st->gpio_range, 1);
-		gpiod_set_value(st->gpio_standby, 0);
+		gpiod_set_value(st->gpio_standby, 1);
 	}
 
 	return 0;
-- 
2.43.0



