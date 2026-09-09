Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 731E4582B88;
	Wed,  9 Sep 2026 14:25:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963945; cv=none; b=aDhxnKEo4pba8w+WO8ReBOcuQh0Mukwv0Z8cCsYh/kHKX3NdHHL4d98r2V8JXZ1AzMLKOwF/O7PCA9fWlvjOjpmtf2KOLdCBOudMffp5b6KP4MueNZYUocvCuxqMzfU43NWRRIE29PCwxiGeyecxCSsMQTIve21i4ZeVE+E/+2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963945; c=relaxed/simple;
	bh=Qb+qjoLzf9zI3m2BIVsoYCNU5X1p5kCOWOza4Mhu5gM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nEen1dX360+FFqBH8UwKrxDTuQnmN522GbL61d32BzWbdL96qcnkVlP06F6BmYAPWaBYHkmwI4jyI/LJ/3nLdjUpCJ/CYEL1p2FqKuvwgimE/JZI0UDDrROFevHDWGDG9SfH0KEhxv7cd3VBXyrP+tO7awC41K7biGPJLcAPBt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fL3en4+2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fL3en4+2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA6D31F00A3D;
	Wed,  9 Sep 2026 14:25:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963944;
	bh=khTpPno8kJDjn8iCWTNShAjlIE1E2ijlf6AUPdQfUcE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fL3en4+20YaUaRafir+Liyq9aPe3IdylLUhfE6Ikrl3D9V9xG0tQO421GDcdiT3vf
	 opMih00c5Bbr7HB90fse9H6M9LWaKIZBp1aY4R+U17Q1FWgCTBozAnH6PhqtdGWgbg
	 T00RCTNHBpCvY5WIP0LzjXCSU1fxOlFpIcCEmDWY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikhil Gautam <nikhilgtr@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.18 226/583] iio: light: opt4001: Fix incompatible pointer type passed to div_u64_rem()
Date: Wed,  9 Sep 2026 15:38:31 +0200
Message-ID: <20260909134245.992440159@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/iio/light/opt4001.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/iio/light/opt4001.c
+++ b/drivers/iio/light/opt4001.c
@@ -173,6 +173,7 @@ static int opt4001_read_lux_value(struct
 	u8 crc;
 	u8 calc_crc;
 	u64 lux_raw;
+	u32 rem;
 	int ret;
 
 	ret = regmap_read(chip->regmap, OPT4001_LIGHT1_MSB, &light1);
@@ -199,8 +200,8 @@ static int opt4001_read_lux_value(struct
 
 	lux_raw = lux_raw << exp;
 	lux_raw = lux_raw * chip->chip_info->mul;
-	*val = div_u64_rem(lux_raw, chip->chip_info->div, val2);
-	*val2 = *val2 * 100;
+	*val = div_u64_rem(lux_raw, chip->chip_info->div, &rem);
+	*val2 = rem * 100;
 
 	return IIO_VAL_INT_PLUS_NANO;
 }


