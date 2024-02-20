Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF8C214F9C8;
	Tue, 20 Feb 2024 21:34:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464887; cv=none; b=BL3WaajQMH/hRoS8TSHFT4n5GG0NGExEbThj7ieq4FhTTqIIVB32795t6XU2G47mK7vP+n/Ryxt7B8OIF4CE0ybpMwfcdt6VnLfGcXq+69KCsM8aAbuTTQODEhiNa1402Y2LhsLzatO67J7NhvIR8fdabKAhb5h9QhLULd9Y7A0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464887; c=relaxed/simple;
	bh=EFRotshZDKi7bsYS/f9c+XNKKdMmCDgnzeZhNxl/E2c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EyjmPjG/ssuDPxSYXJP2OdA16Q9OjpVAcEIZpXz9Aa3+GQrwCzpe80l8L2cEfMkukhp7yVNz2fdSPRufBM4/Lcn4MkVYf7FRpDAfpHCjeSLRye5+hE22MWW+zK8voHxYGUYWhdk0/1D/RJa9y2dX5w52GQOEoZ89H2E3Z4qR8RM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NLr8K29S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NLr8K29S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35520C433F1;
	Tue, 20 Feb 2024 21:34:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464887;
	bh=EFRotshZDKi7bsYS/f9c+XNKKdMmCDgnzeZhNxl/E2c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NLr8K29SZGZUDRASjsuq5BZtJMFKQzzNIxU26R78LsDJCp5SyDDn/ThMZNlx5AJuO
	 VTwV6WHofGjB+b3mjBmLZhIllkXw5uXd3KILgqaJ4O3Fa6tgHHvQ4d5LFk51XXtjCU
	 qpM8hF58uHkI88jZ6217NozM9zNc9cyLBQoOKaIg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhouyi Zhou <zhouzhouyi@gmail.com>,
	"zhili.liu" <zhili.liu@ucas.com.cn>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.7 169/309] iio: magnetometer: rm3100: add boundary check for the value read from RM3100_REG_TMRC
Date: Tue, 20 Feb 2024 21:55:28 +0100
Message-ID: <20240220205638.436084582@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: zhili.liu <zhili.liu@ucas.com.cn>

commit 792595bab4925aa06532a14dd256db523eb4fa5e upstream.

Recently, we encounter kernel crash in function rm3100_common_probe
caused by out of bound access of array rm3100_samp_rates (because of
underlying hardware failures). Add boundary check to prevent out of
bound access.

Fixes: 121354b2eceb ("iio: magnetometer: Add driver support for PNI RM3100")
Suggested-by: Zhouyi Zhou <zhouzhouyi@gmail.com>
Signed-off-by: zhili.liu <zhili.liu@ucas.com.cn>
Link: https://lore.kernel.org/r/1704157631-3814-1-git-send-email-zhouzhouyi@gmail.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/magnetometer/rm3100-core.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/iio/magnetometer/rm3100-core.c
+++ b/drivers/iio/magnetometer/rm3100-core.c
@@ -530,6 +530,7 @@ int rm3100_common_probe(struct device *d
 	struct rm3100_data *data;
 	unsigned int tmp;
 	int ret;
+	int samp_rate_index;
 
 	indio_dev = devm_iio_device_alloc(dev, sizeof(*data));
 	if (!indio_dev)
@@ -586,9 +587,14 @@ int rm3100_common_probe(struct device *d
 	ret = regmap_read(regmap, RM3100_REG_TMRC, &tmp);
 	if (ret < 0)
 		return ret;
+
+	samp_rate_index = tmp - RM3100_TMRC_OFFSET;
+	if (samp_rate_index < 0 || samp_rate_index >=  RM3100_SAMP_NUM) {
+		dev_err(dev, "The value read from RM3100_REG_TMRC is invalid!\n");
+		return -EINVAL;
+	}
 	/* Initializing max wait time, which is double conversion time. */
-	data->conversion_time = rm3100_samp_rates[tmp - RM3100_TMRC_OFFSET][2]
-				* 2;
+	data->conversion_time = rm3100_samp_rates[samp_rate_index][2] * 2;
 
 	/* Cycle count values may not be what we want. */
 	if ((tmp - RM3100_TMRC_OFFSET) == 0)


