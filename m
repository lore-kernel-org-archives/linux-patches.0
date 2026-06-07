Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2B672D3A69;
	Sun,  7 Jun 2026 10:38:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780828720; cv=none; b=Bn7mzGCFpGGhzgnx68B7sOPj3ldTwFr0l/xpFztpAkQ0uJ4w10Ej/1JKbm692TB10AM43a8THiRBN8oXVMeE0WdhEmoKCIUFgWDJ49wjS4BORbWJf+6X267UkHsMUqeGOMExv3xiXbOMJjSQ/osL+RrB++jGVB2KzuAo17Lr+E8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780828720; c=relaxed/simple;
	bh=+rEs2CPjIVdFBy/fjiFBqRxy/O8A5lqRkerZaAun0Dc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tEfHj1VdD2TnYWt4lS2biV9gsHDTCyXfrxkJ0quRUAoe9PBrp+wpAFan/Ec2oCgThMAt5R7DJErzTgFNqGfmpPSJ2DMBwcKyQcUWjSotr2LIHvlZSDjASd20yvg9j/YixKeekW1g0AFWtv86o+u22KyHt1wNzZNqJ8vU+7OQtzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gbZnYJGH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gbZnYJGH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44B2D1F00893;
	Sun,  7 Jun 2026 10:38:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780828719;
	bh=xJi/thO8sFrfG4hedfP28zeXRlCIBQsnajSTwQwmssY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gbZnYJGHQiXV4ZNH1D+7Iv+N/aIscw/nthci2zL7Jzi4gFJi9qpYhpinIiHlm68vV
	 8aaX0LdVqujcyasXgXn8C2y/MC0EjSnJtpVBvx8PM7yWdeDF4h4Fx4csDoTFd+gZrt
	 Jh4Ncjz4T6M+3lhoQZqMgOv1WToACajDHdhqQt+A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antoniu Miclaus <antoniu.miclaus@analog.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 7.0 185/332] iio: adc: nxp-sar-adc: fix division by zero in write_raw
Date: Sun,  7 Jun 2026 11:59:14 +0200
Message-ID: <20260607095734.862092427@linuxfoundation.org>
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

From: Antoniu Miclaus <antoniu.miclaus@analog.com>

commit a9aba21a539c668a66b58eeb08ad3909e5a54c2a upstream.

Add a validation check for the sampling frequency value before using it
as a divisor. A user writing zero or a negative value to the
sampling_frequency sysfs attribute triggers a division by zero in the
kernel.

Also prevent unsigned integer underflow when the computed cycle count is
smaller than NXP_SAR_ADC_CONV_TIME, which would wrap the u32 inpsamp to
a huge value.

Fixes: 4434072a893e ("iio: adc: Add the NXP SAR ADC support for the s32g2/3 platforms")
Signed-off-by: Antoniu Miclaus <antoniu.miclaus@analog.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/nxp-sar-adc.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/iio/adc/nxp-sar-adc.c
+++ b/drivers/iio/adc/nxp-sar-adc.c
@@ -559,6 +559,9 @@ static int nxp_sar_adc_write_raw(struct
 
 	switch (mask) {
 	case IIO_CHAN_INFO_SAMP_FREQ:
+		if (val <= 0)
+			return -EINVAL;
+
 		/*
 		 * Configures the sample period duration in terms of the SAR
 		 * controller clock. The minimum acceptable value is 8.
@@ -567,7 +570,11 @@ static int nxp_sar_adc_write_raw(struct
 		 * sampling timing which gives us the number of cycles expected.
 		 * The value is 8-bit wide, consequently the max value is 0xFF.
 		 */
-		inpsamp = clk_get_rate(info->clk) / val - NXP_SAR_ADC_CONV_TIME;
+		inpsamp = clk_get_rate(info->clk) / val;
+		if (inpsamp < NXP_SAR_ADC_CONV_TIME)
+			return -EINVAL;
+
+		inpsamp -= NXP_SAR_ADC_CONV_TIME;
 		nxp_sar_adc_conversion_timing_set(info, inpsamp);
 		return 0;
 


