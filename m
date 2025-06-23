Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE6B325523C;
	Mon, 23 Jun 2025 13:21:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684909; cv=none; b=ulglYgKb1L6xKoQVoR5StuNRNcGG9VMIoAFbOp7jcaqewrcKJCQx0uQoaeggp3/bDNiNrzBG40RhKOKWivyZ1w9mKgC+ftnWvpgISEWT87oIYOWEVoYTCU3jUxuYmHpNwPFVaWyPo6CWSiF2XzfAwZfFJpWTqpP/oC8v5cPZJb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684909; c=relaxed/simple;
	bh=BlYNDB16azII6tqduIMcIO5X6qn1U4f2HhsSGisPR7o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FA4YYI0MNuXGYVI+/P6Pp+hwoKCID5Br+6At/vWpffwz+qSJ+mZpsqKOrLuJix/vAIWpGcmxSXfXAshg71ZpUioqr1sSv8XEzyJ4QMmJqx6k7YvlB9KmZoBgbQ5mJQCsd/BhCHn9/iV6+8vTiu7aWOzmKU/bRgfiB1hCt2ixQ8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eDSEsyg6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eDSEsyg6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10461C4CEEA;
	Mon, 23 Jun 2025 13:21:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684909;
	bh=BlYNDB16azII6tqduIMcIO5X6qn1U4f2HhsSGisPR7o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eDSEsyg6EJTQGtCjf1UfvvzcUIHbeSWGiaZdWgrjaDafRsKeuD4qcRBs+LKg2Ly0I
	 MeOO5qiTjsJ8Nmj6iMotDrZR9ObPekx2Qq/pvbl5w4UGvXOA8VPHCuwNxJ7qDVP3vf
	 Ie3x8HjGlPLMfKbDq78cPiFfpkHt2avGe18dODh8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marcelo Schmitt <marcelo.schmitt1@gmail.com>,
	Sean Nyekjaer <sean@geanix.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.15 189/592] iio: accel: fxls8962af: Fix temperature calculation
Date: Mon, 23 Jun 2025 15:02:27 +0200
Message-ID: <20250623130704.778459170@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -23,6 +23,7 @@
 #include <linux/regulator/consumer.h>
 #include <linux/regmap.h>
 #include <linux/types.h>
+#include <linux/units.h>
 
 #include <linux/iio/buffer.h>
 #include <linux/iio/events.h>
@@ -439,8 +440,16 @@ static int fxls8962af_read_raw(struct ii
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
@@ -736,6 +745,7 @@ static const struct iio_event_spec fxls8
 	.type = IIO_TEMP, \
 	.address = FXLS8962AF_TEMP_OUT, \
 	.info_mask_separate = BIT(IIO_CHAN_INFO_RAW) | \
+			      BIT(IIO_CHAN_INFO_SCALE) | \
 			      BIT(IIO_CHAN_INFO_OFFSET),\
 	.scan_index = -1, \
 	.scan_type = { \


