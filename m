Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEBF9550DA6;
	Wed,  9 Sep 2026 14:00:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962434; cv=none; b=iJM4UVWf195w6T20gZo1iFu+3QZn2Fwnpod5JMgehbngisJ5e3MlsPftsb0ln4qYl/Q/iaedsAOPTE+/MrJbP9LfZK+oSvMiWSEvJpiOVpWYHAU1AOO3Dqw7qKb5mjGsz2V/CfC3DtIpbjDyr4ceQX0bT1BjGZoXJ5OtVvBqHvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962434; c=relaxed/simple;
	bh=6hQLhWR6REUQ2E+dy4RBBn7zFHKFKrzy4n9vUDtaLdo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N2FTgWnEf4+ks4BQCwBQBqfeQ93Laf6eWLiap6N3StLdbt7cCTO704/ug645CuonEHogpeXsPFQzMZ6xlCkcHgeAPHjncLp4idIxQ8l0lutWYZeu0glqXOsVRrdFGIbMGMamCBZRwoZOZY/O/kp06a+fJgzwPwBSPGHY2jIJ6yY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hxF7ao/7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hxF7ao/7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D724E1F00A3D;
	Wed,  9 Sep 2026 14:00:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962433;
	bh=t0ow/1h6oQ8NnXpjB3ktqgAFvsyaYXCSgDSFOxHSZuM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hxF7ao/76bUEvFuCJKbxoVi6T3DlCxtR2R5G2oWk1kRvNLUw0CDX299kGwtYgXs8S
	 peTPwWMVDbSZGA3lHrSjJtqk53YhIps+9dHHIG6OItx/RlhKHEwi/oYTHPz8hR3iAg
	 kBYm0CLk662rHPBh3fADzC1wwVhZMJVhjz3S3xuc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikhil Gautam <nikhilgtr@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 7.2 288/556] iio: light: opt4001: Fix incompatible pointer type passed to div_u64_rem()
Date: Wed,  9 Sep 2026 15:39:28 +0200
Message-ID: <20260909134240.809645529@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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


