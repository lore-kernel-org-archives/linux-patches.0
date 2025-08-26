Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F17F523B628;
	Tue, 26 Aug 2025 11:38:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208295; cv=none; b=QnLqkSIRGKXEZOSS94uzf+B8BYDfKPgXVndZ37jv1iKSQLja1wpPZ+nwIAJIUxoIW+Cel4olNZkv2aiC+IN2WV/oS6F0Fc/0npaZ3YGHEojH6UZitgnh1U2/rhxnlAaoKjRICu1UZJqw2qdefSNws3WAGIBWxhIgxaP15MCockY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208295; c=relaxed/simple;
	bh=ygJXn6UXGhShkQYhDRG6rym/9IUmdDPq2W3deg6iFq0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bsoy6sYZAGHcTtY5utGjLHLCU8MYAUPEs45Om636xZLZDBvJpFAUxp8rhlZHPrJKA6G23V1557LQCvTCPFfjq1d0N9e3UilKEHXNFXUQFop0iL9S0k32JoEbtcYZ+9BvCgHG4r0smbAcYyitc9QdN4ntQxApdbTIsi3bex8UPwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eK37tD0B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eK37tD0B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A913C4CEF1;
	Tue, 26 Aug 2025 11:38:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208294;
	bh=ygJXn6UXGhShkQYhDRG6rym/9IUmdDPq2W3deg6iFq0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eK37tD0BultAa7L05hUl7LWvyUm3lFrOfb3v2MF/xm/X9z3cOtSGVIo21V6gqrcRI
	 YDo/9Ft3DLq8fdtseluXRT9x6Jp9CcvTukfTjjykyNv/XSsjAXO6M9VwcsEH2ixKNY
	 P8WGb9j3l5kXQcrXoKb/uFksfy8sOgfIkq/rOJZ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	David Lechner <dlechner@baylibre.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.12 056/322] iio: imu: bno055: fix OOB access of hw_xlate array
Date: Tue, 26 Aug 2025 13:07:51 +0200
Message-ID: <20250826110916.899651277@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


