Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FB0E32E733;
	Wed,  3 Dec 2025 15:50:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777058; cv=none; b=Z/i+yin8vuhFCJjY4OYjdx1NnfDjrqRlNZ2SkjfqSfJnHA8OHHTK0oEjmxCYuRpm74U1AYdrwNqZNzGxshiEyppmaL/2jmwE3yalZG7e/kv9I+UZc1hrQNeFAgiQyoQnmM5XXAla5Rdwz0eOPixJS3DUWOhPYsh+XwUnrTloEVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777058; c=relaxed/simple;
	bh=lMC84jf8NWiusOuDx0mJjTC7YuRdzXHI7kFoj7RUU4Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DILdEKRY8C0uegvqpLTKhwmOtKx9Bx91+4RzR/WmH8iNw1Ap2RKz0yQ59L8uQpglvb2iLZaB1qWQ0TTC2SSxsibjQ/0+e3dTvS8qKdmZSu/RmKUfxJTNh26lAQ4scwcU3m/4U2WqJ5Vzqe0zWkZIOkKaulPZ/usTZCICLav+Pbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dFIWvhuK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dFIWvhuK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFBF2C4CEF5;
	Wed,  3 Dec 2025 15:50:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777058;
	bh=lMC84jf8NWiusOuDx0mJjTC7YuRdzXHI7kFoj7RUU4Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dFIWvhuKP0i7I0tQQbBRMS18fVz5nSKQ9TgdNJNArXOx5iTQS4cAmvgkO/78cjnjI
	 NwlekLeZftka4XLAZqCFuWwCwuXaVBdmrnzCFiP/33qXNjSRYif5l8X6BvYRejeNBw
	 PE/VYX8/dAs2LruCOlpRQ78qg+lWKvsq8eNrhFNs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.17 068/146] iio: adc: ad7380: fix SPI offload trigger rate
Date: Wed,  3 Dec 2025 16:27:26 +0100
Message-ID: <20251203152348.955655246@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152346.456176474@linuxfoundation.org>
References: <20251203152346.456176474@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Lechner <dlechner@baylibre.com>

commit 632757312d7eb320b66ca60e0cfe098ec53cee08 upstream.

Add a special case to double the SPI offload trigger rate when all
channels of a single-ended chip are enabled in a buffered read.

The single-ended chips in the AD738x family can only do simultaneous
sampling of half their channels and have a multiplexer to allow reading
the other half. To comply with the IIO definition of sampling_frequency,
we need to trigger twice as often when the sequencer is enabled to so
that both banks can be read in a single sample period.

Fixes: bbeaec81a03e ("iio: ad7380: add support for SPI offload")
Signed-off-by: David Lechner <dlechner@baylibre.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/ad7380.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/iio/adc/ad7380.c
+++ b/drivers/iio/adc/ad7380.c
@@ -1227,6 +1227,14 @@ static int ad7380_offload_buffer_postena
 	if (ret)
 		return ret;
 
+	/*
+	 * When the sequencer is required to read all channels, we need to
+	 * trigger twice per sample period in order to read one complete set
+	 * of samples.
+	 */
+	if (st->seq)
+		config.periodic.frequency_hz *= 2;
+
 	ret = spi_offload_trigger_enable(st->offload, st->offload_trigger, &config);
 	if (ret)
 		spi_unoptimize_message(&st->offload_msg);


