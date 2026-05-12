Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 207D23EDE68;
	Tue, 12 May 2026 18:07:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609262; cv=none; b=NgfjZEb27nGD/XzA+DT91z+eKdxAO4mrT3NlqWyNZxr94LHwBaO1j+IiPiwFoY7AnyX7RJ+n7sgoLjnHfr8NLUpIubSfn6pg81+31tJzAzUEKfUbx5b2VyJHPaIWveUotxp1Dj7MdfZMqW8HtQES+2povaRBdJDkIPotTl24Y4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609262; c=relaxed/simple;
	bh=1HFkPyRTFy7sreYA8kYU5FpWuOFor+7p7/bQ4yV1aTs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JRQh1Rn20UAPOa7gKx1g7Eopo0CJjJHlMR7dcVGEqure3n+VxkLAZlQIa4tDRrH9D+YX1UYgxUKmgPoFuXDPO0tTrNYVg6FktGvKI2zpVneqTRitLLduufXO4VameVtqjbEJ4Yfli1sRHB6Y51B+CE5KNNfmVYOfNyYsnfc7i7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=19Zc4yPn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="19Zc4yPn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6605EC2BCB0;
	Tue, 12 May 2026 18:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609261;
	bh=1HFkPyRTFy7sreYA8kYU5FpWuOFor+7p7/bQ4yV1aTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=19Zc4yPn0UMFN6Yf58g2ZYPyZvmCu8/nytTEF9Sgfl/CxWbVzPPt4i5biPGrxCgJx
	 xoDeW6YYq72L5ZglT2/gL6agdQ3c3yQhYSFSqckzOhtc6F2ucasMzkbp6M/EO/L12F
	 tN6Pf1RuVugPV5sGwwV8bWejiusn9tXgRAus+PU4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sanman Pradhan <psanman@juniper.net>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 7.0 128/307] hwmon: (ltc2992) Fix u32 overflow in power read path
Date: Tue, 12 May 2026 19:38:43 +0200
Message-ID: <20260512173942.830235024@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
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

From: Sanman Pradhan <psanman@juniper.net>

commit 2da0c1fd01dbd6b22844e8676585153dfc660cbe upstream.

ltc2992_get_power() computes the divisor for mul_u64_u32_div() as
r_sense_uohm * 1000. This multiplication overflows u32 when
r_sense_uohm exceeds about 4.29 ohms (4294967 micro-ohms), producing
a truncated divisor and an incorrect power reading.

Cancel the factor of 1000 from both the numerator
(VADC_UV_LSB * IADC_NANOV_LSB = 312500000) and the divisor
(r_sense_uohm * 1000), giving (VADC_UV_LSB / 1000) * IADC_NANOV_LSB
= 312500 as the numerator and plain r_sense_uohm as the divisor.
The cancellation is exact because LTC2992_VADC_UV_LSB (25000) is
divisible by 1000.

This is the read-path counterpart of the write-path fix applied in
the preceding patch.

Fixes: b0bd407e94b03 ("hwmon: (ltc2992) Add support")
Cc: stable@vger.kernel.org
Signed-off-by: Sanman Pradhan <psanman@juniper.net>
Link: https://lore.kernel.org/r/20260416215904.101969-3-sanman.pradhan@hpe.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/ltc2992.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/hwmon/ltc2992.c
+++ b/drivers/hwmon/ltc2992.c
@@ -637,8 +637,10 @@ static int ltc2992_get_power(struct ltc2
 	if (reg_val < 0)
 		return reg_val;
 
-	*val = mul_u64_u32_div(reg_val, LTC2992_VADC_UV_LSB * LTC2992_IADC_NANOV_LSB,
-			       st->r_sense_uohm[channel] * 1000);
+	*val = mul_u64_u32_div(reg_val,
+			       LTC2992_VADC_UV_LSB / 1000 *
+			       LTC2992_IADC_NANOV_LSB,
+			       st->r_sense_uohm[channel]);
 
 	return 0;
 }


