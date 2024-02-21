Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8C047E590;
	Wed, 21 Feb 2024 14:11:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708524704; cv=none; b=edCt7F+y5z/FqWKmwyzCcQVu8R5fztsGsnHycm8UsolLEZ901vyH2FDxgbbGLcd/sMGCjdtTLWmYb7gUA++dK0094yTV3QXVIxXaF9VgRbP3zSywJ4YO4ZskrjPeyl4pDMikfIsTQ4V7vfvP+afOe8WZk5uJGe7eF6iSGMFWE3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708524704; c=relaxed/simple;
	bh=zAY7/b5sxvAbDZMiojz84SEXcodvyww8gfz3PT8PUak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ejcxK7J8RRLZ3alj6y9Lh3XcAutwk0oV9UH69L5oGzIcxfcN2V0mlTVQ7/sy9zKUwdI6Wgcz2wOFU9CM6xlCg+WyrRdwPzwQDcI0RvWafLriMxPwIJ+0rML+mvP6y1Vh1AWSau+RKQr9unGzz/1fKPckECdHJHUEo4Fi0RA+0rI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RSp3gjhP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RSp3gjhP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A750C433F1;
	Wed, 21 Feb 2024 14:11:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708524704;
	bh=zAY7/b5sxvAbDZMiojz84SEXcodvyww8gfz3PT8PUak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RSp3gjhPnX/qsLVL9INFEd6JwmsVJED2b3++aLP3gs1EfnEnXb4e1DsWCb709UHPP
	 TrqTGaQFqiiwKed2dhSq/vhWQmLUR1VTzJ+hXvkFdbhiNSqlNub0x2KpU7z9bGpstb
	 12gbgsDj/zfb6aQHOY3EAWNTl9oqIxmPSs7dNHko=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhouyi Zhou <zhouzhouyi@gmail.com>,
	"zhili.liu" <zhili.liu@ucas.com.cn>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.10 324/379] iio: magnetometer: rm3100: add boundary check for the value read from RM3100_REG_TMRC
Date: Wed, 21 Feb 2024 14:08:23 +0100
Message-ID: <20240221130004.539002982@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -538,6 +538,7 @@ int rm3100_common_probe(struct device *d
 	struct rm3100_data *data;
 	unsigned int tmp;
 	int ret;
+	int samp_rate_index;
 
 	indio_dev = devm_iio_device_alloc(dev, sizeof(*data));
 	if (!indio_dev)
@@ -596,9 +597,14 @@ int rm3100_common_probe(struct device *d
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


