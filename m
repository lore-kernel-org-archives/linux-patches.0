Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D92A4379EF3
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:05:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301901; cv=none; b=rDtZ43DWNi8wnlAVfJBEYSHlJJeXAhOoSFGoI1/g7YnBtNmlhn072RgnbC+tjMsRiCP9qkSGufstT7pYGPC/zlD77Jz7rSHH49kdf1h5pZmcm2QVDcaJyT2ApSmlS9s5eWwzHFvN+oycSNujE/b1GAWELpzGQxjhTR79KAaIEms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301901; c=relaxed/simple;
	bh=W/ltTId0LyIZv0PBZhNaApFr1cPGnp6h1WbY1YrGkrk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K+sSTbkDSln5HhhJ6hILhf/uMdKHE32KnrSvIjAcJGlG9Vc5FPqBVODOG4HaLKlnz0MpJcQsTtZ8V5pQ325mVWB99AWJe0HGjOx4poKHhgkXEY9HvrmiuvWI1RBvRWdMEcwPMdHOV6AskN4q4IUhDUhVIJ8PNP17xRv4I9iYvUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GQOfDjaG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GQOfDjaG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EA23C116D0;
	Sat, 28 Feb 2026 18:05:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301901;
	bh=W/ltTId0LyIZv0PBZhNaApFr1cPGnp6h1WbY1YrGkrk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GQOfDjaGfjub1eGGWLbTZcp0UgjcZHPZ1czbNuj5kM2aYDCMx15R/UlamzqfR/Rk/
	 8sA+n2GSAafwJCx/XcsQSLHNCWtiBRiFQujplAV44C1D/EkNDGe/1tfPZz1y1LD890
	 ys4zfCqHN9JLmfViTKKwzxZQbjH8JLtQcTWb8h9DlmodOrt2AMAriX6noG/tbROalm
	 jQtStGa7IDsJ5YNDwsATWnQirL4+hU7rvbllh8uuWx+VS7PjfRjhfn8kKixYcnOcee
	 Z05IICGekHd3ZdvYsPF5iSZQyEuNLCaikBomihUWgb5PWf+VUvdfvSzm3tr/dT+S8l
	 fJPYfaDw5Z/WQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Petre Rodan <petre.rodan@subdimension.ro>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 331/385] iio: pressure: mprls0025pa: fix pressure calculation
Date: Sat, 28 Feb 2026 12:59:13 -0500
Message-ID: <20260228180011.1568201-331-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Petre Rodan <petre.rodan@subdimension.ro>

[ Upstream commit d63403d4e31ae537fefc5c0ee9d90f29b4fc532b ]

A sign change is needed for proper calculation of the pressure.

This is a minor fix since it only affects users that might have custom
silicon from Honeywell that has honeywell,pmin-pascal != 0.

Also due to the fact that raw pressure values can not be lower
than output_min (400k-3.3M) there is no need to calculate a decimal for
the offset.

Fixes: 713337d9143e ("iio: pressure: Honeywell mprls0025pa pressure sensor")
Signed-off-by: Petre Rodan <petre.rodan@subdimension.ro>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/pressure/mprls0025pa.c | 26 +++++++++++---------------
 drivers/iio/pressure/mprls0025pa.h |  2 --
 2 files changed, 11 insertions(+), 17 deletions(-)

diff --git a/drivers/iio/pressure/mprls0025pa.c b/drivers/iio/pressure/mprls0025pa.c
index 367644269fec4..e13e6a7ef8db9 100644
--- a/drivers/iio/pressure/mprls0025pa.c
+++ b/drivers/iio/pressure/mprls0025pa.c
@@ -59,7 +59,7 @@
  *
  * Values given to the userspace in sysfs interface:
  * * raw	- press_cnt
- * * offset	- (-1 * outputmin) - pmin / scale
+ * * offset	- (-1 * outputmin) + pmin / scale
  *                note: With all sensors from the datasheet pmin = 0
  *                which reduces the offset to (-1 * outputmin)
  */
@@ -313,8 +313,7 @@ static int mpr_read_raw(struct iio_dev *indio_dev,
 		return IIO_VAL_INT_PLUS_NANO;
 	case IIO_CHAN_INFO_OFFSET:
 		*val = data->offset;
-		*val2 = data->offset2;
-		return IIO_VAL_INT_PLUS_NANO;
+		return IIO_VAL_INT;
 	default:
 		return -EINVAL;
 	}
@@ -330,8 +329,9 @@ int mpr_common_probe(struct device *dev, const struct mpr_ops *ops, int irq)
 	struct mpr_data *data;
 	struct iio_dev *indio_dev;
 	const char *triplet;
-	s64 scale, offset;
+	s64 odelta, pdelta;
 	u32 func;
+	s32 tmp;
 
 	indio_dev = devm_iio_device_alloc(dev, sizeof(*data));
 	if (!indio_dev)
@@ -405,17 +405,13 @@ int mpr_common_probe(struct device *dev, const struct mpr_ops *ops, int irq)
 	data->outmin = mpr_func_spec[data->function].output_min;
 	data->outmax = mpr_func_spec[data->function].output_max;
 
-	/* use 64 bit calculation for preserving a reasonable precision */
-	scale = div_s64(((s64)(data->pmax - data->pmin)) * NANO,
-			data->outmax - data->outmin);
-	data->scale = div_s64_rem(scale, NANO, &data->scale2);
-	/*
-	 * multiply with NANO before dividing by scale and later divide by NANO
-	 * again.
-	 */
-	offset = ((-1LL) * (s64)data->outmin) * NANO -
-		  div_s64(div_s64((s64)data->pmin * NANO, scale), NANO);
-	data->offset = div_s64_rem(offset, NANO, &data->offset2);
+	odelta = data->outmax - data->outmin;
+	pdelta = data->pmax - data->pmin;
+
+	data->scale = div_s64_rem(div_s64(pdelta * NANO, odelta), NANO, &tmp);
+	data->scale2 = tmp;
+
+	data->offset = div_s64(odelta * data->pmin, pdelta) - data->outmin;
 
 	if (data->irq > 0) {
 		ret = devm_request_irq(dev, data->irq, mpr_eoc_handler, 0,
diff --git a/drivers/iio/pressure/mprls0025pa.h b/drivers/iio/pressure/mprls0025pa.h
index d62a018eaff32..b6944b3051267 100644
--- a/drivers/iio/pressure/mprls0025pa.h
+++ b/drivers/iio/pressure/mprls0025pa.h
@@ -53,7 +53,6 @@ enum mpr_func_id {
  * @scale: pressure scale
  * @scale2: pressure scale, decimal number
  * @offset: pressure offset
- * @offset2: pressure offset, decimal number
  * @gpiod_reset: reset
  * @irq: end of conversion irq. used to distinguish between irq mode and
  *       reading in a loop until data is ready
@@ -75,7 +74,6 @@ struct mpr_data {
 	int			scale;
 	int			scale2;
 	int			offset;
-	int			offset2;
 	struct gpio_desc	*gpiod_reset;
 	int			irq;
 	struct completion	completion;
-- 
2.51.0

