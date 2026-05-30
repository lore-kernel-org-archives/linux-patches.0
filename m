Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D5E53546EA;
	Sat, 30 May 2026 17:53:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163630; cv=none; b=FtUZLuHbCSkbIafzYXAMk4VbKnBfd8Q4tWPT7SWFcqbgVEL7Kdj8u/5akHpSeoVwlp4Ha63nfBUvwt0TFkEEb+haNv+gP0bFVJLCpztKQ/3p2VKzfIxE/Dja0dfo9CfJtnRF2jCNncOViB/vCinxYy85oeERbR/S8QBu5xEwOBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163630; c=relaxed/simple;
	bh=zdactaKkGPsVtwQmLkiJ9irclVf45qPOrO06Sx1102I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z536ru7+f12BZ0NosZAA9xH/7riPrbEcC5xsqY7RWUWnKV2INM6qCDJi8PxrGMHr4jqHcz96d1GG7RAtTXQaEbBRaC3hVMk9JqSRh1KTKIMrDEPwkhRUMfVdxifGZV/J8sx3xyzwts31jXPzA4PgB/OpeZHgBEnEWHOysO7qiF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ignmIJ95; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ignmIJ95"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFBCD1F00893;
	Sat, 30 May 2026 17:53:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163629;
	bh=zyHckycZYotkqZYn7qde3nEzIEIIp+/6sshEDTY5vsE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ignmIJ950pyQDR+ZepbDgmxMq6A4iRSkp9cyRH+H3hVzLaZ+KbfnqYCRwh4uvIcHA
	 lsBSJr1ciU5CMozHWgFheEDpGpCfnTbf8JH5ubsRZGu2vY+Jl/ZgeS6G44nqf1TnLt
	 9RI25lj9a/L84Efe1MVYPXfWrgC0Othhk9Ssq880=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sanman Pradhan <psanman@juniper.net>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 5.15 315/776] hwmon: (ltc2992) Fix u32 overflow in power read path
Date: Sat, 30 May 2026 18:00:29 +0200
Message-ID: <20260530160248.711087494@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -628,8 +628,10 @@ static int ltc2992_get_power(struct ltc2
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


