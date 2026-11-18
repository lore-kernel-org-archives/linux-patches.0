Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039826;
	b=KgKSPSOFzxooZV19oMf3RF5SpKXjQj6MYtqVJpG/1t/SeSLQ6RvI8of0wRZBJmsRB4EZ
	 fm7gIzJ4xSm38Fz/7XtlQA4JEv8OA67XPHXIjgz8UP/rvqwrzt14Ml3BsZweHk/7PJ2wc
	 7lNt4djVd4sO83DLJdJhWHArHTjsdvaenamEv0gU26QeWhk4OMIXFx3KOBJ9qYJC36JYc
	 pAMnxakXq85R5zrwSnAQqtc6qhoVht/qbjtwgG3zAX/pk2Vg++4wzwr83qr8AFSCb6eak
	 AmIhRSEMVT5z/jaMOvF9q+HXprrW06xVQKixYy6YdAmu8rID5lJ4z+pDigm4gvjfGZg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039826;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PYtlHfzfV826aNH56AzcPFwBTPfyK4ShqLWEBYTrUjY=;
	b=tQaVHpZ9hGoJLHfFdYlyC+fq1ZsM9X+qc5FBt3mbyAIUE3G0vwv7P/vejg00Zo5P+4oa
	 ZsgMtXPAprbERgZCNLkqQjeXqqLQc0Tpklx7zTZ1Vl393P4ziOwo2i6mpFJ11UV13d+hD
	 h+9uwvhho7cufzV3tKnOa10GOBJxv+6FcUgcYyasiHf7hboqEvj5+BB0X3Gx7iY4dH+SA
	 7uJqf8g7DIsy4U1BN2o+WBh6ES3rN4fYGE4gc57Oe83hzz7heGP/3Z20/GD2n13nCFZu/
	 s6cTsRFQLOMQDrVm0oLwRMlJa0NVj/b6LA4LZQudsR3BAKa52qdZymcaoeciVFgrm5A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IZrBTGgq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B959606A325;
	Wed, 18 Nov 2026 22:10:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IZrBTGgq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2B7F1F000C4;
	Wed, 18 Nov 2026 22:10:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039826;
	bh=PYtlHfzfV826aNH56AzcPFwBTPfyK4ShqLWEBYTrUjY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IZrBTGgqUUm2SXGyX3N2spVRmWaLByrkuNbUGyZwduzAeDOjp9a5PR/8e2b17L8Vi
	 YaHUChtMcblkDbt+zfjbS+w3WQc6DYnATrR+BTCRFxyJx/tcSJhDxHfrXBWKJTY4A4
	 J35j6RzRsxJPV/hcPRxHZVT/8piJ9TLqjfWuBwj8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdelnasser Hussein <abdelnasserhussein11@gmail.com>,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2240/3318] staging: iio: adc: ad7816: Fix DMA safety issues in SPI transfers
Date: Wed, 18 Nov 2026 15:47:42 +0100
Message-ID: <20261118150429.055508730@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abdelnasser Hussein <abdelnasserhussein11@gmail.com>

[ Upstream commit 69fa76f0af3414cc189c3b0b807cb59e327ecc00 ]

The SPI operations in this driver are not DMA safe:
1. spi_read() uses a stack-allocated buffer.
2. spi_write() in ad7816_spi_read() uses a struct member that shares a
   cacheline with other variables.
3. spi_write() in ad7816_spi_write() passes a stack parameter by
   reference.

Fix these violations by replacing all spi_read() and spi_write() calls
with spi_write_then_read(). This safely handles DMA by internally
allocating a bounce buffer for the transfers, avoiding cacheline
sharing issues without needing dedicated aligned buffers.
This implicitly corrects the size argument in read to sizeof(buf).

Fixes: 7924425db04a ("staging: iio: adc: new driver for AD7816 devices")
Signed-off-by: Abdelnasser Hussein <abdelnasserhussein11@gmail.com>
Reviewed-by: Joshua Crofts <joshua.crofts1@gmail.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/iio/adc/ad7816.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/iio/adc/ad7816.c b/drivers/staging/iio/adc/ad7816.c
index 081b17f498638..a46ca0559b6a2 100644
--- a/drivers/staging/iio/adc/ad7816.c
+++ b/drivers/staging/iio/adc/ad7816.c
@@ -69,7 +69,7 @@ static int ad7816_spi_read(struct ad7816_chip_info *chip, u16 *data)
 
 	gpiod_set_value(chip->rdwr_pin, 1);
 	gpiod_set_value(chip->rdwr_pin, 0);
-	ret = spi_write(spi_dev, &chip->channel_id, sizeof(chip->channel_id));
+	ret = spi_write_then_read(spi_dev, &chip->channel_id, sizeof(chip->channel_id), NULL, 0);
 	if (ret < 0) {
 		dev_err(&spi_dev->dev, "SPI channel setting error\n");
 		return ret;
@@ -91,7 +91,7 @@ static int ad7816_spi_read(struct ad7816_chip_info *chip, u16 *data)
 
 	gpiod_set_value(chip->rdwr_pin, 0);
 	gpiod_set_value(chip->rdwr_pin, 1);
-	ret = spi_read(spi_dev, &buf, sizeof(*data));
+	ret = spi_write_then_read(spi_dev, NULL, 0, &buf, sizeof(buf));
 	if (ret < 0) {
 		dev_err(&spi_dev->dev, "SPI data read error\n");
 		return ret;
@@ -109,7 +109,7 @@ static int ad7816_spi_write(struct ad7816_chip_info *chip, u8 data)
 
 	gpiod_set_value(chip->rdwr_pin, 1);
 	gpiod_set_value(chip->rdwr_pin, 0);
-	ret = spi_write(spi_dev, &data, sizeof(data));
+	ret = spi_write_then_read(spi_dev, &data, sizeof(data), NULL, 0);
 	if (ret < 0)
 		dev_err(&spi_dev->dev, "SPI oti data write error\n");
 
-- 
2.53.0



