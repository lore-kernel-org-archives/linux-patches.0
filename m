Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6533233A6EB;
	Fri,  9 Oct 2026 14:22:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555778; cv=none; b=FnC46FrOHJmWh387SaLmidnSUv8PDfuE93Z27Q3zWY8+70GVs3Hyg0HEBcrrdmBDV2Lh/8R80UC95GtRXcnoqssZP5DhVv1weT5qS2KaJD22DwFud1iN8ItSXiuKux04ouaXvfayMQenDjGOwHwMjr8lTyy9UraJZKmxeK4FGgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555778; c=relaxed/simple;
	bh=G85vz4gnSSp1J1W71zVUJqCiYE/IBhMfDW1ixBjABQ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ubEQ/ay2V1FPaOZCesuGsbmcBd6sWm7M/DMXtBdUhaoGnyhqRgl29z/mzPmpSo0e3ct0ye4eUslwD/nQw0tDkm01ptw9kSkVXVA2wP8t1HSF2duxsQb82T7sGWQAht3jwaoZaw9JOUPjFUGRQhaYmHWillfQ2663Tw+01wd1ycM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dVIGvERi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dVIGvERi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 729EB1F000FF;
	Fri,  9 Oct 2026 14:22:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555777;
	bh=OmVi0vmohT72wc+NsKZNv+6pNDPXVL1u191bwGu1bME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dVIGvERimmHqFAUZGv49TGEIAsXxRRokDhGTFg+dgH3NChwJV5ocfmMyRb6fZEu32
	 mquPHPi0r7KA2tvG5WrhGUvRxP6M81OENV7osN+3UYsEIiPicuqQWTrMfDIXYUQZ4C
	 oVXmLEHh90FKyb27fIgRznUmewhzkp0IjaOo1tss=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matti Vaittinen <mazziesaccount@gmail.com>,
	Mehdi Djait <mehdi.djait@linux.intel.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 068/428] iio: accel: kionix-kx022a: Fix array boundary check
Date: Fri,  9 Oct 2026 16:06:45 +0200
Message-ID: <20261009140947.644666152@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matti Vaittinen <mazziesaccount@gmail.com>

[ Upstream commit 0e65412aee4f651d2c9785f542a13e4b44002a75 ]

The driver performs a sanity check for an array size, when converting a
register value to an array index. The check incorrectly accepts the
sizeof(array) as a last index, when last valid index should be
sizeof(array) - 1.

Fix the check by bailing out when index >= sizeof(array).

Fixes: 7c1d1677b322 ("iio: accel: Support Kionix/ROHM KX022A accelerometer")
Signed-off-by: Matti Vaittinen <mazziesaccount@gmail.com>
Reviewed-by: Mehdi Djait <mehdi.djait@linux.intel.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/accel/kionix-kx022a.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/accel/kionix-kx022a.c b/drivers/iio/accel/kionix-kx022a.c
index 39485572a76b4..8a13f78aeab07 100644
--- a/drivers/iio/accel/kionix-kx022a.c
+++ b/drivers/iio/accel/kionix-kx022a.c
@@ -649,7 +649,7 @@ static int kx022a_read_raw(struct iio_dev *idev,
 		if (ret)
 			return ret;
 
-		if ((regval & KX022A_MASK_ODR) >
+		if ((regval & KX022A_MASK_ODR) >=
 		    ARRAY_SIZE(kx022a_accel_samp_freq_table)) {
 			dev_err(data->dev, "Invalid ODR\n");
 			return -EINVAL;
-- 
2.53.0



