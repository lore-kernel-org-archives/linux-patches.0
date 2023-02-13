Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA9E28F57
	for <patches@lists.linux.dev>; Mon, 13 Feb 2023 15:03:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72706C433EF;
	Mon, 13 Feb 2023 15:03:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676300624;
	bh=9vkRVo911xuMNy+PWzxTzzANl7aShG2b2WHpcmtQFwM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P+U+CHEPDmPypV4UoeANvJXwW0fn0VjxQOGZpejCvvzg5y3w/KzSw5Fv5rqPWpeXv
	 oBYeuk4lxNqUBlHBMC9nt6SysVi5DrKYu7nD9o8APKEyZIHoE1VMCcu0rL3aPPXwdo
	 mWcA5jKiUaTBhv+h2cpSsXdw3c4zVUxhEbaPYIcs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carlos Song <carlos.song@nxp.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.10 068/139] iio: imu: fxos8700: fix incorrect ODR mode readback
Date: Mon, 13 Feb 2023 15:50:13 +0100
Message-Id: <20230213144749.383994524@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144745.696901179@linuxfoundation.org>
References: <20230213144745.696901179@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Carlos Song <carlos.song@nxp.com>

commit 78ad6864e9e012cdba7c353d044d21ffcfd5f34b upstream.

The absence of a correct offset leads an incorrect ODR mode
readback after use a hexadecimal number to mark the value from
FXOS8700_CTRL_REG1.

Get ODR mode by field mask and FIELD_GET clearly and conveniently.
And attach other additional fix for keeping the original code logic
and a good readability.

Fixes: 84e5ddd5c46e ("iio: imu: Add support for the FXOS8700 IMU")
Signed-off-by: Carlos Song <carlos.song@nxp.com>
Link: https://lore.kernel.org/r/20230118074227.1665098-2-carlos.song@nxp.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/imu/fxos8700_core.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/iio/imu/fxos8700_core.c
+++ b/drivers/iio/imu/fxos8700_core.c
@@ -10,6 +10,7 @@
 #include <linux/regmap.h>
 #include <linux/acpi.h>
 #include <linux/bitops.h>
+#include <linux/bitfield.h>
 
 #include <linux/iio/iio.h>
 #include <linux/iio/sysfs.h>
@@ -144,9 +145,9 @@
 #define FXOS8700_NVM_DATA_BNK0      0xa7
 
 /* Bit definitions for FXOS8700_CTRL_REG1 */
-#define FXOS8700_CTRL_ODR_MSK       0x38
 #define FXOS8700_CTRL_ODR_MAX       0x00
 #define FXOS8700_CTRL_ODR_MIN       GENMASK(4, 3)
+#define FXOS8700_CTRL_ODR_MSK       GENMASK(5, 3)
 
 /* Bit definitions for FXOS8700_M_CTRL_REG1 */
 #define FXOS8700_HMS_MASK           GENMASK(1, 0)
@@ -508,10 +509,9 @@ static int fxos8700_set_odr(struct fxos8
 	if (i >= odr_num)
 		return -EINVAL;
 
-	return regmap_update_bits(data->regmap,
-				  FXOS8700_CTRL_REG1,
-				  FXOS8700_CTRL_ODR_MSK + FXOS8700_ACTIVE,
-				  fxos8700_odr[i].bits << 3 | active_mode);
+	val &= ~FXOS8700_CTRL_ODR_MSK;
+	val |= FIELD_PREP(FXOS8700_CTRL_ODR_MSK, fxos8700_odr[i].bits) | FXOS8700_ACTIVE;
+	return regmap_write(data->regmap, FXOS8700_CTRL_REG1, val);
 }
 
 static int fxos8700_get_odr(struct fxos8700_data *data, enum fxos8700_sensor t,
@@ -524,7 +524,7 @@ static int fxos8700_get_odr(struct fxos8
 	if (ret)
 		return ret;
 
-	val &= FXOS8700_CTRL_ODR_MSK;
+	val = FIELD_GET(FXOS8700_CTRL_ODR_MSK, val);
 
 	for (i = 0; i < odr_num; i++)
 		if (val == fxos8700_odr[i].bits)


