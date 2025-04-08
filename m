Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BB3626461E;
	Tue,  8 Apr 2025 12:35:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115747; cv=none; b=XdgyCt7uOBDJBmLBEd7rhd8qomKi4g4XfZYRjD+by/QKyVI2vHmabsuXhscoiMtuuCH9Y0CHZ8ba7bAT7XFBeKW19PNRcJOG+g30b+h2iaj2uKy3eLjB7z6HGcH5lPZIKlGEpuKfq1NEQbE6tFoA6VWhYyWgpuEMFcUrNM+QZB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115747; c=relaxed/simple;
	bh=r8/JN5bT213eNxj26jSQ12X194yy9UadwXg6MXCr0lk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pj3zAUMdOPnV1p8d5mpT3LL4kdGrUAcleS3jN7XvwQqeX/YD7S/Tr+TEnpWuzcvlJLZnyKvtImQuUITuRIRJ0ykW5o13r72isS1cmBYdqwBoUoKAECzcCXndP8ivbia9SHLcpihvLRZW3C6TAeTumf4NcwcnSoAmcEUuCBIdHc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bvkeNNW0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bvkeNNW0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3A68C4CEE7;
	Tue,  8 Apr 2025 12:35:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115747;
	bh=r8/JN5bT213eNxj26jSQ12X194yy9UadwXg6MXCr0lk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bvkeNNW0pu8PJABc2ZJ3hsl99qAz1qIwD+/g91g5R4QoquzsiP96FfRTh/YPTbALe
	 7R6E5m+og85VLHl0cdKm2T2/8mqq3z0EU8svPq/c/GR50lTnSiA3QeRXrCAdOmnNV1
	 wCZO+KPUrWdDGNUcG1wzX4WgzD5rUQrLbux8thq8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 090/204] iio: accel: mma8452: Ensure error return on failure to matching oversampling ratio
Date: Tue,  8 Apr 2025 12:50:20 +0200
Message-ID: <20250408104822.987291730@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.266892317@linuxfoundation.org>
References: <20250408104820.266892317@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonathan Cameron <Jonathan.Cameron@huawei.com>

[ Upstream commit df330c808182a8beab5d0f84a6cbc9cff76c61fc ]

If a match was not found, then the write_raw() callback would return
the odr index, not an error. Return -EINVAL if this occurs.
To avoid similar issues in future, introduce j, a new indexing variable
rather than using ret for this purpose.

Fixes: 79de2ee469aa ("iio: accel: mma8452: claim direct mode during write raw")
Reviewed-by: David Lechner <dlechner@baylibre.com>
Link: https://patch.msgid.link/20250217140135.896574-2-jic23@kernel.org
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/accel/mma8452.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/iio/accel/mma8452.c b/drivers/iio/accel/mma8452.c
index 3ba28c2ff68a3..ad7b7770d5262 100644
--- a/drivers/iio/accel/mma8452.c
+++ b/drivers/iio/accel/mma8452.c
@@ -711,7 +711,7 @@ static int mma8452_write_raw(struct iio_dev *indio_dev,
 			     int val, int val2, long mask)
 {
 	struct mma8452_data *data = iio_priv(indio_dev);
-	int i, ret;
+	int i, j, ret;
 
 	ret = iio_device_claim_direct_mode(indio_dev);
 	if (ret)
@@ -771,14 +771,18 @@ static int mma8452_write_raw(struct iio_dev *indio_dev,
 		break;
 
 	case IIO_CHAN_INFO_OVERSAMPLING_RATIO:
-		ret = mma8452_get_odr_index(data);
+		j = mma8452_get_odr_index(data);
 
 		for (i = 0; i < ARRAY_SIZE(mma8452_os_ratio); i++) {
-			if (mma8452_os_ratio[i][ret] == val) {
+			if (mma8452_os_ratio[i][j] == val) {
 				ret = mma8452_set_power_mode(data, i);
 				break;
 			}
 		}
+		if (i == ARRAY_SIZE(mma8452_os_ratio)) {
+			ret = -EINVAL;
+			break;
+		}
 		break;
 	default:
 		ret = -EINVAL;
-- 
2.39.5



