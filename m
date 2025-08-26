Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DA3F12CDA5;
	Tue, 26 Aug 2025 13:04:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213493; cv=none; b=B7xmrnl4jvMGy/2st6QoweJm8jU4u7Q/R4M+q69nG3GZFDp5fjc2iBO3xaqzovYFdeJyPTGZfuM9lLNG5Yqm4FeY80zXIxhynjCKqNq1jfxJrD1ynDpy8TN9TaOJOVwaiXWT0tnvrL6B/JYT0MMNW1RcfcVl4+jF79O7jzdjh40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213493; c=relaxed/simple;
	bh=WsNdBrqdSgn4O6eI58yBaDHigbFyhVOPABfS4IxYD0k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tDg8lefN/k/UTpS4JmosbD2GAx00s/5vCaHkbdmqg16B2Yv0nCDMhmpu8cx+qgLoNgMrJRCSgYwWgPmg+O2TToSHG/amd+bkLXWU1ni3DokmZQQwewCjx1vpc6j0Zs8dJFmNbGJ8U+ZJeKBcn+JOkfjz/WvTk95YzpR+ABvUC9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sHtqLj1h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sHtqLj1h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCFC3C4CEF1;
	Tue, 26 Aug 2025 13:04:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213493;
	bh=WsNdBrqdSgn4O6eI58yBaDHigbFyhVOPABfS4IxYD0k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sHtqLj1hyNFmE+3pHsPc1cly6ghksKXqp8D/qftRDaNrmbIPzKwxIpAEWVrJIdqUl
	 dlbybj7neWTbP7b8GvsFI+WEkpNP3Nzx09bEQMhyFeg+P8SKPDH0n97ISOejRfP6Iy
	 ggNrdBSvxNUpSpiOXtqbMyIE1K926ghVZJMEKNo4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	David Lechner <dlechner@baylibre.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.6 367/587] iio: imu: bno055: fix OOB access of hw_xlate array
Date: Tue, 26 Aug 2025 13:08:36 +0200
Message-ID: <20250826111002.245763044@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

From: David Lechner <dlechner@baylibre.com>

commit 399b883ec828e436f1a721bf8551b4da8727e65b upstream.

Fix a potential out-of-bounds array access of the hw_xlate array in
bno055.c.

In bno055_get_regmask(), hw_xlate was iterated over the length of the
vals array instead of the length of the hw_xlate array. In the case of
bno055_gyr_scale, the vals array is larger than the hw_xlate array,
so this could result in an out-of-bounds access. In practice, this
shouldn't happen though because a match should always be found which
breaks out of the for loop before it iterates beyond the end of the
hw_xlate array.

By adding a new hw_xlate_len field to the bno055_sysfs_attr, we can be
sure we are iterating over the correct length.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202507100510.rGt1YOOx-lkp@intel.com/
Fixes: 4aefe1c2bd0c ("iio: imu: add Bosch Sensortec BNO055 core driver")
Signed-off-by: David Lechner <dlechner@baylibre.com>
Link: https://patch.msgid.link/20250709-iio-const-data-19-v2-1-fb3fc9191251@baylibre.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/imu/bno055/bno055.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/drivers/iio/imu/bno055/bno055.c
+++ b/drivers/iio/imu/bno055/bno055.c
@@ -118,6 +118,7 @@ struct bno055_sysfs_attr {
 	int len;
 	int *fusion_vals;
 	int *hw_xlate;
+	int hw_xlate_len;
 	int type;
 };
 
@@ -170,20 +171,24 @@ static int bno055_gyr_scale_vals[] = {
 	1000, 1877467, 2000, 1877467,
 };
 
+static int bno055_gyr_scale_hw_xlate[] = {0, 1, 2, 3, 4};
 static struct bno055_sysfs_attr bno055_gyr_scale = {
 	.vals = bno055_gyr_scale_vals,
 	.len = ARRAY_SIZE(bno055_gyr_scale_vals),
 	.fusion_vals = (int[]){1, 900},
-	.hw_xlate = (int[]){4, 3, 2, 1, 0},
+	.hw_xlate = bno055_gyr_scale_hw_xlate,
+	.hw_xlate_len = ARRAY_SIZE(bno055_gyr_scale_hw_xlate),
 	.type = IIO_VAL_FRACTIONAL,
 };
 
 static int bno055_gyr_lpf_vals[] = {12, 23, 32, 47, 64, 116, 230, 523};
+static int bno055_gyr_lpf_hw_xlate[] = {5, 4, 7, 3, 6, 2, 1, 0};
 static struct bno055_sysfs_attr bno055_gyr_lpf = {
 	.vals = bno055_gyr_lpf_vals,
 	.len = ARRAY_SIZE(bno055_gyr_lpf_vals),
 	.fusion_vals = (int[]){32},
-	.hw_xlate = (int[]){5, 4, 7, 3, 6, 2, 1, 0},
+	.hw_xlate = bno055_gyr_lpf_hw_xlate,
+	.hw_xlate_len = ARRAY_SIZE(bno055_gyr_lpf_hw_xlate),
 	.type = IIO_VAL_INT,
 };
 
@@ -561,7 +566,7 @@ static int bno055_get_regmask(struct bno
 
 	idx = (hwval & mask) >> shift;
 	if (attr->hw_xlate)
-		for (i = 0; i < attr->len; i++)
+		for (i = 0; i < attr->hw_xlate_len; i++)
 			if (attr->hw_xlate[i] == idx) {
 				idx = i;
 				break;


