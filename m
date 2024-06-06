Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC9D01BC07F;
	Thu,  6 Jun 2024 14:18:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683503; cv=none; b=F+v+6g2LcbwAuwS5s9MgyS4j/8QA6PxGokoHzFswfIO5Etx3cVAki6hxmgIxUnOi7SO/N/EKZZEoYIHiREhne7V+v2QhiVkDapmPi0L4TjEKvnz//vHtuEW69BIKgd3FqvYCi6zu+0YCrJefHHKewE/wpw8U5Intp8luCKU3aMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683503; c=relaxed/simple;
	bh=X1t8fTDIMTZBIlSqTKy9ZNfvNOHMhkYxpMWkfqOc0FM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QZnCYyu2zXXm3+BKdD9Q5Z3+EorTKoeBx/KL+IpOLqVh/ILCZ3j6fThQAK1/btM1VMv2CjbO72QvsRMnaO/DvcYXgkHrG36PKNJz1Ebv9cBeUR71Z01SmmxB4/lznvQyGetZ49md90nPfgnFSHJnZleygi1oX8iWDlIcIJ+g3kU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PbYwExal; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PbYwExal"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D14DC2BD10;
	Thu,  6 Jun 2024 14:18:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683503;
	bh=X1t8fTDIMTZBIlSqTKy9ZNfvNOHMhkYxpMWkfqOc0FM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PbYwExalysE4jLplehyZ4EKkZo81aQpNXhYRBpDltrTV6fOU2SQuvsAtvIg05TPqe
	 hL4pFvtYHibzzM2IgOKfVdA/CL4nRHpB891KEmb/0JfGUdiFFaAhpsNck+avfKvka7
	 O/iO7TMeB6BYBRaDhOcVhmCuB38XjF5Hsms1pRLU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Haemmerle <thomas.haemmerle@leica-geosystems.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 445/744] iio: pressure: dps310: support negative temperature values
Date: Thu,  6 Jun 2024 16:01:57 +0200
Message-ID: <20240606131746.776056607@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



