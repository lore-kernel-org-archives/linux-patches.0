Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9025244C77;
	Mon, 14 Oct 2024 15:03:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918186; cv=none; b=Hvfc84nUJs1Yvqh+Yo+XQrbX7YlI/AC0w2s0p1tVDHOz/kOy5oCJAX0eiMrOa8q6W+Nx93FfwPh/UoZk/ZhTI8N1thX91MMezhHOY8QQTsJHZBhlnoIOabvTJf8HJN6olyMRVw9OSWL5Cw8zQOzwhcZ9i2Uu4Xi9SohCcvJDeuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918186; c=relaxed/simple;
	bh=XsmCcNTFSulYvkDmJ8Z67wWZ9kY638kkhss73Ch2Wqk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Taj5wDbKl53PA4zpZGtOLSwDSfOF6Yn6d1NuCZlg4XcMeupPKyFhLkUkEyn2yr5i2EAywbV4zaZMh5WrZnsl7iVWbZcIrqnsaqq3vlJPHQf3lkb64bdzQ55QVt/FVuLVLtR28S57sdeLT53wsiJgn01jpRp0bQ8Vb0B40m98WI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XuyiHNHG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XuyiHNHG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A770DC4CEC3;
	Mon, 14 Oct 2024 15:03:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918186;
	bh=XsmCcNTFSulYvkDmJ8Z67wWZ9kY638kkhss73Ch2Wqk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XuyiHNHGWfdJf/FjqpjCoGelhR16jHynawKWqLPGlHz4EDbEFvFycBOFIDrP9fZBO
	 UQQ8bGoSknsW1CtlMUOa3J/JPzuXbnLx7vSW/sYU7DjpqDg9Pnw16NIVgxV1WO0ixt
	 l9w/8fU/YClll5kMrTOA9WoW5EgeERqvm9mjIxbo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guillaume Stols <gstols@baylibre.com>,
	Nuno Sa <nuno.sa@analog.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 248/798] iio: adc: ad7606: fix standby gpio state to match the documentation
Date: Mon, 14 Oct 2024 16:13:22 +0200
Message-ID: <20241014141227.678381587@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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
index 5e41df6531581..b1b0ac47e3bc8 100644
--- a/drivers/iio/adc/ad7606.c
+++ b/drivers/iio/adc/ad7606.c
@@ -422,7 +422,7 @@ static int ad7606_request_gpios(struct ad7606_state *st)
 		return PTR_ERR(st->gpio_range);
 
 	st->gpio_standby = devm_gpiod_get_optional(dev, "standby",
-						   GPIOD_OUT_HIGH);
+						   GPIOD_OUT_LOW);
 	if (IS_ERR(st->gpio_standby))
 		return PTR_ERR(st->gpio_standby);
 
@@ -681,7 +681,7 @@ static int ad7606_suspend(struct device *dev)
 
 	if (st->gpio_standby) {
 		gpiod_set_value(st->gpio_range, 1);
-		gpiod_set_value(st->gpio_standby, 0);
+		gpiod_set_value(st->gpio_standby, 1);
 	}
 
 	return 0;
-- 
2.43.0



