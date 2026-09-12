Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49F2D1DE4EF;
	Sat, 12 Sep 2026 14:00:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789221650; cv=none; b=r2woJvrdcqFCSsWqCOXjrH5iTGItGhADdrcF5NnFJobUPRBuN1lFUUY+1BjpaR0tOzoUw4Xpsx2pqJrCzGFNXgPb+cnnm7QDSKI/PJ85WBTXJNrqCeHQKXWyHuMRENh2cEb4H0XLRPhumV/f1lnPd0J1NKarALhddWDKfRBIMuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789221650; c=relaxed/simple;
	bh=WAY27oYWzVBe732uvpObmuC5vtBn/rPY6XQTuG5ZLCA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RCbu3NHNQqb3hbfWScFAAB1SicIyuiStkNgZQ/49tOEEw3HghZ4fBDQ2w52/vLJpkqpL6f6IsH4q+coKKFCnMJ+/xQTFPuEXg96+VfQWS53pv29ImvyKftNE0xrOKo7/XYN0TmPJFV7Q6iyOXItddrKwaHnH6AnAfxEkuYGa6Dk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dE1x6rB/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dE1x6rB/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 143711F000FF;
	Sat, 12 Sep 2026 14:00:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789221649;
	bh=sy9uSdPKqbxnyAYkVVWqewz9o1v02uUJ5x2MOa2ALxw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dE1x6rB/m/OOIVcOzT7mS+IcOyYqTJ+TdQdylfOKZZOOzdIKgj1/586cC2eFHJXGi
	 SJVNKwykb/QciB+RB+TbJDf7WxdtDtKXQAgU9X/2lnKRw5ufRtFQiChh038O8KFg60
	 Jxg2qJCJcisfzsHkyzpc7gCor5d9m9jnSU3hY1xU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikhil Gautam <nikhilgtr@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.6 0425/1424] iio: light: opt4001: Fix incompatible pointer type passed to div_u64_rem()
Date: Sat, 12 Sep 2026 08:47:37 +0200
Message-ID: <20260912065616.802255327@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikhil Gautam <nikhilgtr@gmail.com>

commit afa28741c9a2cf6edb2e41e25ff146a562160bb3 upstream.

div_u64_rem() takes a u32 * for the remainder but is passed val2, which
is an int *. There is no functional impact as int and u32 have the same
size and representation on all supported architectures and the remainder
is always smaller than the divisor, so it fits in the positive range of
int. Fix the type mismatch by using a local u32 for the remainder and
assigning the result to *val2.

Fixes: 9a9608418292 ("iio: light: Add support for TI OPT4001 light sensor")
Signed-off-by: Nikhil Gautam <nikhilgtr@gmail.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/light/opt4001.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/light/opt4001.c b/drivers/iio/light/opt4001.c
index 288e699734af..944923cb8f28 100644
--- a/drivers/iio/light/opt4001.c
+++ b/drivers/iio/light/opt4001.c
@@ -173,6 +173,7 @@ static int opt4001_read_lux_value(struct iio_dev *indio_dev,
 	u8 crc;
 	u8 calc_crc;
 	u64 lux_raw;
+	u32 rem;
 	int ret;
 
 	ret = regmap_read(chip->regmap, OPT4001_LIGHT1_MSB, &light1);
@@ -199,8 +200,8 @@ static int opt4001_read_lux_value(struct iio_dev *indio_dev,
 
 	lux_raw = lux_raw << exp;
 	lux_raw = lux_raw * chip->chip_info->mul;
-	*val = div_u64_rem(lux_raw, chip->chip_info->div, val2);
-	*val2 = *val2 * 100;
+	*val = div_u64_rem(lux_raw, chip->chip_info->div, &rem);
+	*val2 = rem * 100;
 
 	return IIO_VAL_INT_PLUS_NANO;
 }
-- 
2.55.0



