Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 478DA1DDE9;
	Thu, 30 Jan 2025 14:18:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738246694; cv=none; b=TR4SKe/UypRl/4mwR3/DbyKJ8U+EkBEd00RLXAseM6l4tljdRULY668rhlioOa1J34YJUCaHFrnQHKQeSldq2acZciIkfirlti1FzUG5kXPNjQsA6vOgm+J3/nSCgNbFh3sdbbPz8pEuZ0IOfIDU71qR8GgxoUPSHZqsrImP7Cs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738246694; c=relaxed/simple;
	bh=Tj+/OS6scBFUpajOe8gp97ZpSjpcR9RsjC+vGe9p19U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cqngqDMUJomW1WpXs8D2OC9lU7D4KaGYMW/sSAww1GC1+AIq+7Oz4+tRTAKe4i9UyI65jR9i3VLGfwex5XNT3gGOx+657M35Gl3vXTfDm+F9Ad6nyFAE5UN988Pph9X0ePo8DtM9GTjNET3HYKfP59GANiPtU6wGhTzlRtVh3GE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mJodVtxw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mJodVtxw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C474CC4CED2;
	Thu, 30 Jan 2025 14:18:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738246694;
	bh=Tj+/OS6scBFUpajOe8gp97ZpSjpcR9RsjC+vGe9p19U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mJodVtxwqQbgiYXxb/JrmUwKciXFbFQ4ZNkumy9oY+Y1lvIcRkynDJCZyC/0mQP6t
	 UrL/AnHx08GttUc2y5jBLLguh7As5nE0OtHJYBo929aDId/mJeuhvuLlYvSq8ZSWKH
	 rJivErxO55AD+yNknl5/PKFwWERVjKpPmyVivC4M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Fabio Estevam <festevam@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.4 35/91] iio: adc: ti-ads124s08: Use gpiod_set_value_cansleep()
Date: Thu, 30 Jan 2025 15:00:54 +0100
Message-ID: <20250130140135.073637259@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140133.662535583@linuxfoundation.org>
References: <20250130140133.662535583@linuxfoundation.org>
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

From: Fabio Estevam <festevam@gmail.com>

commit 2a8e34096ec70d73ebb6d9920688ea312700cbd9 upstream.

Using gpiod_set_value() to control the reset GPIO causes some verbose
warnings during boot when the reset GPIO is controlled by an I2C IO
expander.

As the caller can sleep, use the gpiod_set_value_cansleep() variant to
fix the issue.

Tested on a custom i.MX93 board with a ADS124S08 ADC.

Cc: stable@kernel.org
Fixes: e717f8c6dfec ("iio: adc: Add the TI ads124s08 ADC code")
Signed-off-by: Fabio Estevam <festevam@gmail.com>
Link: https://patch.msgid.link/20241122164308.390340-1-festevam@gmail.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/ti-ads124s08.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/iio/adc/ti-ads124s08.c
+++ b/drivers/iio/adc/ti-ads124s08.c
@@ -182,9 +182,9 @@ static int ads124s_reset(struct iio_dev
 	struct ads124s_private *priv = iio_priv(indio_dev);
 
 	if (priv->reset_gpio) {
-		gpiod_set_value(priv->reset_gpio, 0);
+		gpiod_set_value_cansleep(priv->reset_gpio, 0);
 		udelay(200);
-		gpiod_set_value(priv->reset_gpio, 1);
+		gpiod_set_value_cansleep(priv->reset_gpio, 1);
 	} else {
 		return ads124s_write_cmd(indio_dev, ADS124S08_CMD_RESET);
 	}


