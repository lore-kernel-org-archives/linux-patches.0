Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D09A143899;
	Thu, 13 Jun 2024 11:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279997; cv=none; b=cacoHRZ6Fb+4AzgQuU1UJvl9UyQ06Gi3AjdBQzc8Z9NWmIOg5Un9arFx/tfHmmX7LdazPZN4PQyBKjVZ4HCaHVIlmase/blyMZO2bmIs1ptiOBt0rrT9JjHMej5GHoRDiADJRd+zoSfVrXHZoWIaqTeft3b5/fBulbP3A8hvZDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279997; c=relaxed/simple;
	bh=qlwOLSDs0tlFWQw1RIDz/l+Trqu3jFDNr9lDasfYAEY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uxDgvNJpTo4VUpk27eLwb/wBKDR3frIRvTePbyg+qBT6yl++zteUk7VWHYKveIkf93RMcuO3dBB/ils1UrnahLZ+Ccnz54AuT2M4MbylEbOfjexcHD6afYeWFtJXAU0at82vVKfL5uRZql7q3x3b405+e9X+VNOHIdu0HrsHYFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=laAX5CNt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="laAX5CNt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B19CAC2BBFC;
	Thu, 13 Jun 2024 11:59:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279997;
	bh=qlwOLSDs0tlFWQw1RIDz/l+Trqu3jFDNr9lDasfYAEY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=laAX5CNtlvHp3k3Ym9D8ZjaX0XjYzMnSi96i/Na5Sgx99tIyWhT1+NEEl6I3EUFbM
	 D05UlwIuO+6Y7Vh6ozNiQp+MF3UaaHxIsPNXriCEudfmXqTg30oNkjIJDPwoRBM2yt
	 rSxO2DVyPG3XnWCiVKlgoYHsCqklIF5V0WJjwpwQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Haemmerle <thomas.haemmerle@leica-geosystems.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 107/202] iio: pressure: dps310: support negative temperature values
Date: Thu, 13 Jun 2024 13:33:25 +0200
Message-ID: <20240613113231.893465020@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.759341286@linuxfoundation.org>
References: <20240613113227.759341286@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 2b2203eea3e90..9bb45a354d38a 100644
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



