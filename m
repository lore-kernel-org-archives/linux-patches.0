Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C75B81E505;
	Mon, 12 May 2025 17:48:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072127; cv=none; b=aPu2A0DJgLlrYgR5dX8A1iYs9An8UAQqr+ETiCuu31dj8P3kospW5zj8ikAKhh6jHUBAfNa9gKM7+dEBQifCkuVmoFFW6dRn7sC8Hhtr3cNQk+To0JKMb3NpCiLUtBwqZvbD4xowBpAKYuKVvshNKZQic7xNjhuEVI5NeuhDy8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072127; c=relaxed/simple;
	bh=XuYNx0jBjymPKzMhN/qrqT6CD6E78OdIw3Rk18gMziE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZnK44RO66lY9pNCHWaPg7tcTjixUbRDTVAo+U53MPDxSiBZZuVkZnxZXyaMVQ2MWzwy/50GkNOpnDGftMrXagch3g4Z+EyulGVKayHW7XWf4EGB33TI0x1EEe2L16CTgB3rOEuLXttwAa1XEn6iZTLawCLYaDi5a81sL7m0vkyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WtWxr3KN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WtWxr3KN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58027C4CEE7;
	Mon, 12 May 2025 17:48:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072127;
	bh=XuYNx0jBjymPKzMhN/qrqT6CD6E78OdIw3Rk18gMziE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WtWxr3KNVWv18C+N3Q2n1bD9nYDegDZUFRKQFVEvNT7MyNz+MQ4KUBjPFxqgmd2fh
	 TAgF1NuJs+UVWPWJiAkqfwfbdzi1sSXC66o5PE3mc16jMe9L2D04PcbT2gczwz4jv+
	 x54KVEtKZJ5twY+487fJtE+OLivcWbhyTgmHvJls=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gustavo Silva <gustavograzs@gmail.com>,
	Alex Lanzano <lanzano.alex@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 149/197] iio: imu: bmi270: fix initial sampling frequency configuration
Date: Mon, 12 May 2025 19:39:59 +0200
Message-ID: <20250512172050.459280116@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172044.326436266@linuxfoundation.org>
References: <20250512172044.326436266@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gustavo Silva <gustavograzs@gmail.com>

[ Upstream commit 6d03811d7a99e08d5928f58120acb45b8ba22b08 ]

In the bmi270_configure_imu() function, the accelerometer and gyroscope
configuration registers are incorrectly written with the mask
BMI270_PWR_CONF_ADV_PWR_SAVE_MSK, which is unrelated to these registers.

As a result, the accelerometer's sampling frequency is set to 200 Hz
instead of the intended 100 Hz.

Remove the mask to ensure the correct bits are set in the configuration
registers.

Fixes: 3ea51548d6b2 ("iio: imu: Add i2c driver for bmi270 imu")
Signed-off-by: Gustavo Silva <gustavograzs@gmail.com>
Reviewed-by: Alex Lanzano <lanzano.alex@gmail.com>
Link: https://patch.msgid.link/20250304-bmi270-odr-fix-v1-1-384dbcd699fb@gmail.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/imu/bmi270/bmi270_core.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/iio/imu/bmi270/bmi270_core.c b/drivers/iio/imu/bmi270/bmi270_core.c
index 7fec52e0b4862..950fcacddd40d 100644
--- a/drivers/iio/imu/bmi270/bmi270_core.c
+++ b/drivers/iio/imu/bmi270/bmi270_core.c
@@ -654,8 +654,7 @@ static int bmi270_configure_imu(struct bmi270_data *bmi270_device)
 			      FIELD_PREP(BMI270_ACC_CONF_ODR_MSK,
 					 BMI270_ACC_CONF_ODR_100HZ) |
 			      FIELD_PREP(BMI270_ACC_CONF_BWP_MSK,
-					 BMI270_ACC_CONF_BWP_NORMAL_MODE) |
-			      BMI270_PWR_CONF_ADV_PWR_SAVE_MSK);
+					 BMI270_ACC_CONF_BWP_NORMAL_MODE));
 	if (ret)
 		return dev_err_probe(dev, ret, "Failed to configure accelerometer");
 
@@ -663,8 +662,7 @@ static int bmi270_configure_imu(struct bmi270_data *bmi270_device)
 			      FIELD_PREP(BMI270_GYR_CONF_ODR_MSK,
 					 BMI270_GYR_CONF_ODR_200HZ) |
 			      FIELD_PREP(BMI270_GYR_CONF_BWP_MSK,
-					 BMI270_GYR_CONF_BWP_NORMAL_MODE) |
-			      BMI270_PWR_CONF_ADV_PWR_SAVE_MSK);
+					 BMI270_GYR_CONF_BWP_NORMAL_MODE));
 	if (ret)
 		return dev_err_probe(dev, ret, "Failed to configure gyroscope");
 
-- 
2.39.5



