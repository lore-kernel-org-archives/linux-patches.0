Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F018A1B3F18;
	Thu,  6 Jun 2024 14:17:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683430; cv=none; b=I84KkjH+iKRkBQLkgFFKY03RH4HuK5OVT/jrYCF88vUcwftyntz/UUzFX+AGFE5vTi2gZmeAaslEhssyixVlWyCsp99aWmtywIMIOcLRciny9EMavB+33dmwFxH10bF+GCF3FdrjjXIpBWDiOHbo2Mst1pYZ5StiarEG4WB/WNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683430; c=relaxed/simple;
	bh=1ywmh6MHD2f6sTfvLphYHUGuAV8U04LmFP8kVoKk4gU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gwTdAYvC44TlzTxIKZG7VkwawjEbSKN9Yx/9BcAvMNV4G19q2Usc5e2zpu50wjAV6qgJRNMDkW3lZHtlcTK+t+Xi4XqnCvGR6YI8GYCecK0fXuxoiMB9QebObbnfPv9/q+g792B+eQn9gukHo/ags457/6pXS3t3Q3HZ4uBDcJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GlRRsFtR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GlRRsFtR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0245C2BD10;
	Thu,  6 Jun 2024 14:17:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683429;
	bh=1ywmh6MHD2f6sTfvLphYHUGuAV8U04LmFP8kVoKk4gU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GlRRsFtRwUELKw5kB9BsyAhLN3L2feAXA9zmwiyL78YDtsn23QzkV7G0TtLpIT8a/
	 T0Gem1Ca3RWyuLJUNFWTk9VOL8l8ycZzVu9GVQr6TYHu5I63BOT0bRNj5ChKvGEoCj
	 ucCGZwIrRV8HJcltL5aXh6MgBXC43mqSrn6wadvg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Haemmerle <thomas.haemmerle@leica-geosystems.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 315/473] iio: pressure: dps310: support negative temperature values
Date: Thu,  6 Jun 2024 16:04:04 +0200
Message-ID: <20240606131710.347903726@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Thomas Haemmerle <thomas.haemmerle@leica-geosystems.com>

[ Upstream commit 9dd6b32e76ff714308964cd9ec91466a343dcb8b ]

The current implementation interprets negative values returned from
`dps310_calculate_temp` as error codes.
This has a side effect that when negative temperature values are
calculated, they are interpreted as error.

Fix this by using the return value only for error handling and passing a
pointer for the value.

Fixes: ba6ec48e76bc ("iio: Add driver for Infineon DPS310")
Signed-off-by: Thomas Haemmerle <thomas.haemmerle@leica-geosystems.com>
Link: https://lore.kernel.org/r/20240415105030.1161770-2-thomas.haemmerle@leica-geosystems.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/pressure/dps310.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/iio/pressure/dps310.c b/drivers/iio/pressure/dps310.c
index db1b1e48225aa..519fcd425b6a3 100644
--- a/drivers/iio/pressure/dps310.c
+++ b/drivers/iio/pressure/dps310.c
@@ -730,7 +730,7 @@ static int dps310_read_pressure(struct dps310_data *data, int *val, int *val2,
 	}
 }
 
-static int dps310_calculate_temp(struct dps310_data *data)
+static int dps310_calculate_temp(struct dps310_data *data, int *val)
 {
 	s64 c0;
 	s64 t;
@@ -746,7 +746,9 @@ static int dps310_calculate_temp(struct dps310_data *data)
 	t = c0 + ((s64)data->temp_raw * (s64)data->c1);
 
 	/* Convert to milliCelsius and scale the temperature */
-	return (int)div_s64(t * 1000LL, kt);
+	*val = (int)div_s64(t * 1000LL, kt);
+
+	return 0;
 }
 
 static int dps310_read_temp(struct dps310_data *data, int *val, int *val2,
@@ -768,11 +770,10 @@ static int dps310_read_temp(struct dps310_data *data, int *val, int *val2,
 		if (rc)
 			return rc;
 
-		rc = dps310_calculate_temp(data);
-		if (rc < 0)
+		rc = dps310_calculate_temp(data, val);
+		if (rc)
 			return rc;
 
-		*val = rc;
 		return IIO_VAL_INT;
 
 	case IIO_CHAN_INFO_OVERSAMPLING_RATIO:
-- 
2.43.0



