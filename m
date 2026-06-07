Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3611E2D3A69;
	Sun,  7 Jun 2026 10:32:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780828370; cv=none; b=aKLcmVUCfvZS4HhjCqusYiVlO44sDPV/NA+mPeLgcu3eZgXMhll/nMRGoUIsv8ddVHqdPm2/UbB/lY8vtpJb5CX5vqgJa9JrFXTodeV21pv6wNVQVd00OjqmCxi/jh6Bt6MbTgQvPb/gs5n5nW+fCNQ+w+X5h0rroSmADSNPYxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780828370; c=relaxed/simple;
	bh=FLqooaj9o8FuoaLhN/8voNTwn03SDOhMYMqJ7dkN9do=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hDgRXVlOEK/3XwTDtzW3pvevrl4OF7faJpr6AGr5oayJeooFYmkNNFPQfC4dcSKld28FcrYt6RfTZZRbjLd1B+QGsVn2MQdoEJEwqlGD2Ec1Wm0g6L0uoy4ygypcWSQlWHnanp6X6oO4yv2OoMrscIPP8dTecmFduj8CpBeoJDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uMicAgFz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uMicAgFz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 570F61F00893;
	Sun,  7 Jun 2026 10:32:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780828369;
	bh=Wpyi8dOq5UNCUiUay+9cbhfqdFBfW58ReJHCzDJuIe8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uMicAgFzTM4gag1+dvgj/90Qp7XciU5PI99zTYJxk4NQQhfOLginr8f4//VX33ADH
	 osxrqrfmduxsykdX6aA2UNZKWCx5oWituPdMZ2nWpovub5cDRF/43yzfsUKL3T+oug
	 BVbdEmAXrFqvfcUR+9MBpez/UaoB/mNtvLYfhamA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kim Seer Paller <kimseer.paller@analog.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 7.0 176/332] iio: dac: ad3530r: Fix AD3531/AD3531R powerdown mode strings
Date: Sun,  7 Jun 2026 11:59:05 +0200
Message-ID: <20260607095734.528306289@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kim Seer Paller <kimseer.paller@analog.com>

commit ebd250c2581ec46c64c73fdfa918c9a7f757505e upstream.

The AD3531/AD3531R has different output operating modes from the
AD3530/AD3530R. According to the AD3531/AD3531R datasheet, the
powerdown modes are:
  01: 500 Ohm output impedance
  10: 3.85 kOhm output impedance
  11: 16 kOhm output impedance

The driver currently uses the AD3530R modes (1k, 7.7k, 32k) for all
variants, which is incorrect for AD3531/AD3531R.

Add AD3531R-specific powerdown mode strings and assign them to the
AD3531/AD3531R chip variants.

Fixes: 93583174a3df ("iio: dac: ad3530r: Add driver for AD3530R and AD3531R")
Signed-off-by: Kim Seer Paller <kimseer.paller@analog.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/dac/ad3530r.c |   54 ++++++++++++++++++++++++++++++++++------------
 1 file changed, 40 insertions(+), 14 deletions(-)

--- a/drivers/iio/dac/ad3530r.c
+++ b/drivers/iio/dac/ad3530r.c
@@ -105,6 +105,12 @@ static const char * const ad3530r_powerd
 	"32kohm_to_gnd",
 };
 
+static const char * const ad3531r_powerdown_modes[] = {
+	"500ohm_to_gnd",
+	"3.85kohm_to_gnd",
+	"16kohm_to_gnd",
+};
+
 static int ad3530r_get_powerdown_mode(struct iio_dev *indio_dev,
 				      const struct iio_chan_spec *chan)
 {
@@ -133,6 +139,13 @@ static const struct iio_enum ad3530r_pow
 	.set = ad3530r_set_powerdown_mode,
 };
 
+static const struct iio_enum ad3531r_powerdown_mode_enum = {
+	.items = ad3531r_powerdown_modes,
+	.num_items = ARRAY_SIZE(ad3531r_powerdown_modes),
+	.get = ad3530r_get_powerdown_mode,
+	.set = ad3530r_set_powerdown_mode,
+};
+
 static ssize_t ad3530r_get_dac_powerdown(struct iio_dev *indio_dev,
 					 uintptr_t private,
 					 const struct iio_chan_spec *chan,
@@ -276,7 +289,20 @@ static const struct iio_chan_spec_ext_in
 	{ }
 };
 
-#define AD3530R_CHAN(_chan)					\
+static const struct iio_chan_spec_ext_info ad3531r_ext_info[] = {
+	{
+		.name = "powerdown",
+		.shared = IIO_SEPARATE,
+		.read = ad3530r_get_dac_powerdown,
+		.write = ad3530r_set_dac_powerdown,
+	},
+	IIO_ENUM("powerdown_mode", IIO_SEPARATE, &ad3531r_powerdown_mode_enum),
+	IIO_ENUM_AVAILABLE("powerdown_mode", IIO_SHARED_BY_TYPE,
+			   &ad3531r_powerdown_mode_enum),
+	{ }
+};
+
+#define AD3530R_CHAN(_chan, _ext_info)				\
 {								\
 	.type = IIO_VOLTAGE,					\
 	.indexed = 1,						\
@@ -284,25 +310,25 @@ static const struct iio_chan_spec_ext_in
 	.output = 1,						\
 	.info_mask_separate = BIT(IIO_CHAN_INFO_RAW) |		\
 			      BIT(IIO_CHAN_INFO_SCALE),		\
-	.ext_info = ad3530r_ext_info,				\
+	.ext_info = _ext_info,					\
 }
 
 static const struct iio_chan_spec ad3530r_channels[] = {
-	AD3530R_CHAN(0),
-	AD3530R_CHAN(1),
-	AD3530R_CHAN(2),
-	AD3530R_CHAN(3),
-	AD3530R_CHAN(4),
-	AD3530R_CHAN(5),
-	AD3530R_CHAN(6),
-	AD3530R_CHAN(7),
+	AD3530R_CHAN(0, ad3530r_ext_info),
+	AD3530R_CHAN(1, ad3530r_ext_info),
+	AD3530R_CHAN(2, ad3530r_ext_info),
+	AD3530R_CHAN(3, ad3530r_ext_info),
+	AD3530R_CHAN(4, ad3530r_ext_info),
+	AD3530R_CHAN(5, ad3530r_ext_info),
+	AD3530R_CHAN(6, ad3530r_ext_info),
+	AD3530R_CHAN(7, ad3530r_ext_info),
 };
 
 static const struct iio_chan_spec ad3531r_channels[] = {
-	AD3530R_CHAN(0),
-	AD3530R_CHAN(1),
-	AD3530R_CHAN(2),
-	AD3530R_CHAN(3),
+	AD3530R_CHAN(0, ad3531r_ext_info),
+	AD3530R_CHAN(1, ad3531r_ext_info),
+	AD3530R_CHAN(2, ad3531r_ext_info),
+	AD3530R_CHAN(3, ad3531r_ext_info),
 };
 
 static const struct ad3530r_chip_info ad3530_chip = {


