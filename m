Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29828266583;
	Tue,  8 Apr 2025 11:24:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111491; cv=none; b=gZkC1TD0/EetxbfZEb4n8Z6cfNoYFNTGwTlMZBwjKO3/+EcNJfJAHu/2qOfOUUAXa3lRVE+aIGahtfRiCVgQDB26FJbANZFBxF2tA886tXuHC5LfPMhF+dVJWyVIGpFvzI5JWsj6CuXfXqhrxG9rGXjT2fBWMR9A7h9SycifNGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111491; c=relaxed/simple;
	bh=JuWlbSr+m2WrpyPppfo+E17fPLo5FKt2noomKeP4IvE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gSUKTe78he/F882dMbEDAkw0Mh3Wv1GWms7zck/Vf6ZRTkDuxxao5aWLYYaV4wCY/X9WjrhQyqLLRquoiY5ewVcjNLUcDBpFi1TzMyXOX3rugx7bFyCJEfycj7815xqi9iDZ3sOQqo8Lfqlx1xipy0R72KFqdiuhT9mj/zgDsQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gcK4nJR/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gcK4nJR/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3E5CC4CEE5;
	Tue,  8 Apr 2025 11:24:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111491;
	bh=JuWlbSr+m2WrpyPppfo+E17fPLo5FKt2noomKeP4IvE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gcK4nJR/OP8/8NvB+68cITidHsUTSeLV/38iGytkC/9KgEMNR9YZ6uuA8aH2nVdLq
	 cR5WM94NlXU6AQxzNSAAlfz4nnmIoCVpAMPT6PuzfnajYrRfqOXG0VzvBLbcvn3F6T
	 yQygQuh1AtLlY21rpcSVLfbJ4x4RGZZLxQX6NASM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
	Nuno Sa <nuno.sa@analog.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 450/731] iio: adc: ad7124: Micro-optimize channel disabling
Date: Tue,  8 Apr 2025 12:45:47 +0200
Message-ID: <20250408104924.746482249@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@baylibre.com>

[ Upstream commit cf67879bd4280f6243103e281595f9b523c61481 ]

The key objective in ad7124_disable_one() is clearing the
AD7124_CHANNEL_EN_MSK bit in the channel register. However there is no
advantage to keep the other bits in that register because when the
channel is used next time, all fields are rewritten anyhow. So instead
of using ad7124_spi_write_mask() (which is a register read plus a
register write) use a simple register write clearing the complete
register.

Also do the same in the .disable_all() callback by using the
.disable_one() callback there.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@baylibre.com>
Reviewed-by: Nuno Sa <nuno.sa@analog.com>
Link: https://patch.msgid.link/20250120140708.1093655-2-u.kleine-koenig@baylibre.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Stable-dep-of: e903868b4ce7 ("iio: adc: ad7124: Really disable all channels at probe time")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/ad7124.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/iio/adc/ad7124.c b/drivers/iio/adc/ad7124.c
index 6ae27cdd32503..2fdeb32479522 100644
--- a/drivers/iio/adc/ad7124.c
+++ b/drivers/iio/adc/ad7124.c
@@ -540,6 +540,14 @@ static int ad7124_append_status(struct ad_sigma_delta *sd, bool append)
 	return 0;
 }
 
+static int ad7124_disable_one(struct ad_sigma_delta *sd, unsigned int chan)
+{
+	struct ad7124_state *st = container_of(sd, struct ad7124_state, sd);
+
+	/* The relevant thing here is that AD7124_CHANNEL_EN_MSK is cleared. */
+	return ad_sd_write_reg(&st->sd, AD7124_CHANNEL(chan), 2, 0);
+}
+
 static int ad7124_disable_all(struct ad_sigma_delta *sd)
 {
 	struct ad7124_state *st = container_of(sd, struct ad7124_state, sd);
@@ -547,7 +555,7 @@ static int ad7124_disable_all(struct ad_sigma_delta *sd)
 	int i;
 
 	for (i = 0; i < st->num_channels; i++) {
-		ret = ad7124_spi_write_mask(st, AD7124_CHANNEL(i), AD7124_CHANNEL_EN_MSK, 0, 2);
+		ret = ad7124_disable_one(sd, i);
 		if (ret < 0)
 			return ret;
 	}
@@ -555,13 +563,6 @@ static int ad7124_disable_all(struct ad_sigma_delta *sd)
 	return 0;
 }
 
-static int ad7124_disable_one(struct ad_sigma_delta *sd, unsigned int chan)
-{
-	struct ad7124_state *st = container_of(sd, struct ad7124_state, sd);
-
-	return ad7124_spi_write_mask(st, AD7124_CHANNEL(chan), AD7124_CHANNEL_EN_MSK, 0, 2);
-}
-
 static const struct ad_sigma_delta_info ad7124_sigma_delta_info = {
 	.set_channel = ad7124_set_channel,
 	.append_status = ad7124_append_status,
-- 
2.39.5



