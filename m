Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3892B197A9F;
	Thu,  6 Jun 2024 14:08:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717682932; cv=none; b=U/zflDbtDhCma0JCr3ZzFhaYSo0ThGMjVKT1U18Qx/Rq4/JIOl1fnbCMC12nxOBPp0dg/7CtseDQadRoch4xcHTSPoRtZ0bhiP1fMZougTLzlkuR23bGg/WRMtjINjG8n6xTlvjru5XcJQfNauH9sexuphlbMeYRQZPHmhRAZ9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717682932; c=relaxed/simple;
	bh=B7rtpqc6BnLeXFmhtbCjEsNx2s5/YxBFxGMSGy0cBjs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l5APsBNa1dol8/2cAMgsf9U+Tnnasf9Z8NGYM6D+uRG3yY0Yf2yCKS+bgeKHtd5x4PiZiCr62ow9qE947saF4LBS17ENf0Hj3sKl/PLT1hYDNOvny0wMs0jxpRkcVecdcAnxwyM51/ZM2uURT255KE/dlZyOBZ6iote3vgSSwTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ad8OBHmJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ad8OBHmJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 156AFC2BD10;
	Thu,  6 Jun 2024 14:08:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717682932;
	bh=B7rtpqc6BnLeXFmhtbCjEsNx2s5/YxBFxGMSGy0cBjs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ad8OBHmJvIac2dFpsSDdSOFooygoWEG/LngFM5Djy5+jeVuT8IN4tuxAKxP8hmgjv
	 1jSziZh5xZyLOlIu4UuXGaS2fz5r3k1Kpj2+GhSjRZZLBkUdWcgTEX9wFhnU4azYpO
	 p7/kgnZ9FsQ4fdsiTmj3Fck5y1fiYuiAD0mvPGrQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Haemmerle <thomas.haemmerle@leica-geosystems.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 053/374] iio: pressure: dps310: support negative temperature values
Date: Thu,  6 Jun 2024 16:00:32 +0200
Message-ID: <20240606131653.612430326@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index 1ff091b2f764d..d0a516d56da47 100644
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



