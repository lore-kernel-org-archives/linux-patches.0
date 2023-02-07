Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 711882C9C
	for <patches@lists.linux.dev>; Tue,  7 Feb 2023 13:07:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2194C433EF;
	Tue,  7 Feb 2023 13:07:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675775237;
	bh=E/2uAleW193iYSoF3EWEG2aHf0e9jDEeAf7JcQHrP8c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D9QkVThmuS92G2rk+VnvWlfChWVXl1xlj8oK86RycNVEaHjUqycb9kaiuiGXk7IOL
	 T7XpaLPm0ZiOINGxNcUxSXAwHHvhIf1l/VHL8xsknsanh4iplpsj2tPIs4BS9bVi6T
	 1cU5pnalrqjewOTx3JBYgL2GoVNKf+7O0fk8dCGk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carlos Song <carlos.song@nxp.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.1 143/208] iio: imu: fxos8700: fix swapped ACCEL and MAGN channels readback
Date: Tue,  7 Feb 2023 13:56:37 +0100
Message-Id: <20230207125640.904006692@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
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

commit c68b44bc7d9b1469774a1c985ee71d2cbc5ebef5 upstream.

Because ACCEL and MAGN channels data register base address is
swapped the accelerometer and magnetometer channels readback is
swapped.

Fixes: 84e5ddd5c46e ("iio: imu: Add support for the FXOS8700 IMU")
Signed-off-by: Carlos Song <carlos.song@nxp.com>
Link: https://lore.kernel.org/r/20221208071911.2405922-3-carlos.song@nxp.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/imu/fxos8700_core.c |   17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

--- a/drivers/iio/imu/fxos8700_core.c
+++ b/drivers/iio/imu/fxos8700_core.c
@@ -420,9 +420,22 @@ static int fxos8700_get_data(struct fxos
 	u8 base, reg;
 	s16 tmp;
 	int ret;
-	enum fxos8700_sensor type = fxos8700_to_sensor(chan_type);
 
-	base = type ? FXOS8700_OUT_X_MSB : FXOS8700_M_OUT_X_MSB;
+	/*
+	 * Different register base addresses varies with channel types.
+	 * This bug hasn't been noticed before because using an enum is
+	 * really hard to read. Use an a switch statement to take over that.
+	 */
+	switch (chan_type) {
+	case IIO_ACCEL:
+		base = FXOS8700_OUT_X_MSB;
+		break;
+	case IIO_MAGN:
+		base = FXOS8700_M_OUT_X_MSB;
+		break;
+	default:
+		return -EINVAL;
+	}
 
 	/* Block read 6 bytes of device output registers to avoid data loss */
 	ret = regmap_bulk_read(data->regmap, base, data->buf,


