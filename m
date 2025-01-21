Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDA081F55E3;
	Tue, 21 Jan 2025 18:11:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737483098; cv=none; b=A0pQnrjMMCFvnrvGpY9ouO+O/RNDmZivcWC9u4rSiV8CjY1DBCltDuOgGJbcW5QvMW8D9ED/I6aPnKQn4NmPObjMB3QdsGPG98WtrgpdAKwzhGAVWKe6aAjdoRSm61gz2XXF1HoTXUvmTTpIv8OtDvRsquj9cWz7zct5mpzZMYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737483098; c=relaxed/simple;
	bh=6YKunzAGXGHj/gVKoJcPiPqgwf5vgawlOvQswidInQg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vb6vy7oR+eTcGaOdhe2IAHRySoUgN14nFPciTX0HNZ2wPIWZjYX5e2Uf2uhgierUXLp0PDihP1n65zIm3rAGo/OMrUKSRBu0cfYFp1vozuvhMkWhoK7X3LUsG01FeLiRHLFQmCPq4CXIc7nx3yeeeNf79WgsFSR8zkZHZ47LbpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eFg9hnVR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eFg9hnVR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B89CC4CEDF;
	Tue, 21 Jan 2025 18:11:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737483098;
	bh=6YKunzAGXGHj/gVKoJcPiPqgwf5vgawlOvQswidInQg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eFg9hnVRGRY7XY63d2daCdBisOFLmFHgAarorqY8dh8fLyxb+ZozHkkBvSK8z5kdt
	 gtkkZ1SEgLQ646i7lL0UB0SDx+59BUSyVBVAmhHciNne22rqLTv5syyiXpnKyF4foJ
	 ajdYI7BW8qS9ZuE88wQW+pq7mAzjgoAuUFLFOxRs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.15 116/127] iio: imu: inv_icm42600: fix spi burst write not supported
Date: Tue, 21 Jan 2025 18:53:08 +0100
Message-ID: <20250121174534.116576090@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174529.674452028@linuxfoundation.org>
References: <20250121174529.674452028@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>

commit c0f866de4ce447bca3191b9cefac60c4b36a7922 upstream.

Burst write with SPI is not working for all icm42600 chips. It was
only used for setting user offsets with regmap_bulk_write.

Add specific SPI regmap config for using only single write with SPI.

Fixes: 9f9ff91b775b ("iio: imu: inv_icm42600: add SPI driver for inv_icm42600 driver")
Cc: stable@vger.kernel.org
Signed-off-by: Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>
Link: https://patch.msgid.link/20241112-inv-icm42600-fix-spi-burst-write-not-supported-v2-1-97690dc03607@tdk.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/imu/inv_icm42600/inv_icm42600.h      |    1 +
 drivers/iio/imu/inv_icm42600/inv_icm42600_core.c |   11 +++++++++++
 drivers/iio/imu/inv_icm42600/inv_icm42600_spi.c  |    3 ++-
 3 files changed, 14 insertions(+), 1 deletion(-)

--- a/drivers/iio/imu/inv_icm42600/inv_icm42600.h
+++ b/drivers/iio/imu/inv_icm42600/inv_icm42600.h
@@ -360,6 +360,7 @@ struct inv_icm42600_state {
 typedef int (*inv_icm42600_bus_setup)(struct inv_icm42600_state *);
 
 extern const struct regmap_config inv_icm42600_regmap_config;
+extern const struct regmap_config inv_icm42600_spi_regmap_config;
 extern const struct dev_pm_ops inv_icm42600_pm_ops;
 
 const struct iio_mount_matrix *
--- a/drivers/iio/imu/inv_icm42600/inv_icm42600_core.c
+++ b/drivers/iio/imu/inv_icm42600/inv_icm42600_core.c
@@ -43,6 +43,17 @@ const struct regmap_config inv_icm42600_
 };
 EXPORT_SYMBOL_GPL(inv_icm42600_regmap_config);
 
+/* define specific regmap for SPI not supporting burst write */
+const struct regmap_config inv_icm42600_spi_regmap_config = {
+	.reg_bits = 8,
+	.val_bits = 8,
+	.max_register = 0x4FFF,
+	.ranges = inv_icm42600_regmap_ranges,
+	.num_ranges = ARRAY_SIZE(inv_icm42600_regmap_ranges),
+	.use_single_write = true,
+};
+EXPORT_SYMBOL_NS_GPL(inv_icm42600_spi_regmap_config, IIO_ICM42600);
+
 struct inv_icm42600_hw {
 	uint8_t whoami;
 	const char *name;
--- a/drivers/iio/imu/inv_icm42600/inv_icm42600_spi.c
+++ b/drivers/iio/imu/inv_icm42600/inv_icm42600_spi.c
@@ -59,7 +59,8 @@ static int inv_icm42600_probe(struct spi
 		return -EINVAL;
 	chip = (enum inv_icm42600_chip)match;
 
-	regmap = devm_regmap_init_spi(spi, &inv_icm42600_regmap_config);
+	/* use SPI specific regmap */
+	regmap = devm_regmap_init_spi(spi, &inv_icm42600_spi_regmap_config);
 	if (IS_ERR(regmap))
 		return PTR_ERR(regmap);
 


