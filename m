Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF4F73E0759;
	Tue, 12 May 2026 17:55:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608517; cv=none; b=oUI/VbTB7V+Zy7O+nf0WqMQywjtPZ3kk7JdLv2uoma0uHBkAkEuIELeinJDnMFfy2+Sz/TPdtkxLsAoLj4f6LwEuAl3n4SnPj55P1d2X58QAcq6+5JxUi2CBA9Ql4mPn9+HkK2lf6plteev9iS9K+zZFjt7UtwdGq4xsKjTbl0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608517; c=relaxed/simple;
	bh=l3JsFnsT/3JaqC366vYvB2ZFVYCnHryeNImEs5A354w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ChjSVgS6emoued1q89OZQ4EQBZkxA9jOZ9e7OCPXLuFgwmmHVPzpsWqr2vgFVkyufCtzfDHcpR0D17T6cCK4FLPx5gVmMSBeFwJVEvkzsaId45GDNoAB+vX/6J3zH8CcVvEMkAOQuYqO5BbU+xJpSF/T+pZRS01bLphVYu9cKcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sghnCB54; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sghnCB54"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 759C8C2BCB0;
	Tue, 12 May 2026 17:55:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608517;
	bh=l3JsFnsT/3JaqC366vYvB2ZFVYCnHryeNImEs5A354w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sghnCB54jcgHqcs2vY38P096vOTbM2mraxGNGPS7oKYgwlql9VFIWAWJesRa0/qYt
	 Bc9T3TR4desk4EhQpgH+tNiL4ae9NtndiJkh1bosJwPBA23CRZcbMBi4OZVQW8SghR
	 qxKRUPrJkk2ceIKA2yH3k2xlmetXHdCOy5DdYevY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sanman Pradhan <psanman@juniper.net>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.18 109/270] hwmon: (ltc2992) Fix u32 overflow in power read path
Date: Tue, 12 May 2026 19:38:30 +0200
Message-ID: <20260512173940.753493563@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173938.452574370@linuxfoundation.org>
References: <20260512173938.452574370@linuxfoundation.org>
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


