Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7B254409;
	Mon, 23 Jun 2025 22:00:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716031; cv=none; b=XwUXBbtzBQsfb1CxnuA8KaDZ72rQqn9qqlQKV6E/VvzWX1q7Yer9x7hMtMj/nrWKOK7mfwWJQQ4fsm99nEj9f9JTFE1QrtM3OeiELdBF9N2MTHDb4A9ThTEsYy4bz4BJ9zM7LyVH24/hcNqV4kHK6+NY6jGFqmhSPMMu+QXlSlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716031; c=relaxed/simple;
	bh=aViqm8Bg6phnR6jWEbuP7Ah1z/LJm3YHOp7YuxrSJoM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m8/fXicCEnGf7Pzb86oMJV1il8TuB0F4xfXeGp5GgskAFiHx7LHo9zcacKelu4ymHLTk4FUzlmZaSXPTM7m3G49VnHh4Lqq3Y1T5l7f4Dmfr6oZAa3Nps+kvcFq/nZauFGePuKp0BaL9z0eHJiXgECVt8Q+SNdVN7qWQMC1xZGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W33Sw0aO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W33Sw0aO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F7B5C4CEEA;
	Mon, 23 Jun 2025 22:00:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716031;
	bh=aViqm8Bg6phnR6jWEbuP7Ah1z/LJm3YHOp7YuxrSJoM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W33Sw0aO0YC4NVhiSjW44OtRtIvbmdAffE0LzOr4WzJDG6YXhANYvHbcHER8SGaM2
	 XNO5f+e1+9fqdNeF7ByOsZLKi6I3YFQq8edWy8kdCGeKZfx7ULcKd+qIcuVMkNo6uA
	 uDHE/nj7NwozrYyPtsSxUsgdkyGpbDtazejnr+i4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marcelo Schmitt <marcelo.schmitt1@gmail.com>,
	Sean Nyekjaer <sean@geanix.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.6 236/290] iio: accel: fxls8962af: Fix temperature calculation
Date: Mon, 23 Jun 2025 15:08:17 +0200
Message-ID: <20250623130634.024605994@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.910356556@linuxfoundation.org>
References: <20250623130626.910356556@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Nyekjaer <sean@geanix.com>

commit 16038474e3a0263572f36326ef85057aaf341814 upstream.

According to spec temperature should be returned in milli degrees Celsius.
Add in_temp_scale to calculate from Celsius to milli Celsius.

Fixes: a3e0b51884ee ("iio: accel: add support for FXLS8962AF/FXLS8964AF accelerometers")
Cc: stable@vger.kernel.org
Reviewed-by: Marcelo Schmitt <marcelo.schmitt1@gmail.com>
Signed-off-by: Sean Nyekjaer <sean@geanix.com>
Link: https://patch.msgid.link/20250505-fxls-v4-1-a38652e21738@geanix.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/accel/fxls8962af-core.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/drivers/iio/accel/fxls8962af-core.c
+++ b/drivers/iio/accel/fxls8962af-core.c
@@ -20,6 +20,7 @@
 #include <linux/pm_runtime.h>
 #include <linux/regulator/consumer.h>
 #include <linux/regmap.h>
+#include <linux/units.h>
 
 #include <linux/iio/buffer.h>
 #include <linux/iio/events.h>
@@ -434,8 +435,16 @@ static int fxls8962af_read_raw(struct ii
 		*val = FXLS8962AF_TEMP_CENTER_VAL;
 		return IIO_VAL_INT;
 	case IIO_CHAN_INFO_SCALE:
-		*val = 0;
-		return fxls8962af_read_full_scale(data, val2);
+		switch (chan->type) {
+		case IIO_TEMP:
+			*val = MILLIDEGREE_PER_DEGREE;
+			return IIO_VAL_INT;
+		case IIO_ACCEL:
+			*val = 0;
+			return fxls8962af_read_full_scale(data, val2);
+		default:
+			return -EINVAL;
+		}
 	case IIO_CHAN_INFO_SAMP_FREQ:
 		return fxls8962af_read_samp_freq(data, val, val2);
 	default:
@@ -734,6 +743,7 @@ static const struct iio_event_spec fxls8
 	.type = IIO_TEMP, \
 	.address = FXLS8962AF_TEMP_OUT, \
 	.info_mask_separate = BIT(IIO_CHAN_INFO_RAW) | \
+			      BIT(IIO_CHAN_INFO_SCALE) | \
 			      BIT(IIO_CHAN_INFO_OFFSET),\
 	.scan_index = -1, \
 	.scan_type = { \


