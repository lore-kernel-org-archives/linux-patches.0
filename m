Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ACC020297C;
	Fri, 15 May 2026 16:06:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861172; cv=none; b=Bmk7oJQnMuU/zlUrOdWOTEd7gAkwaJWFEGd0upB5X061AQuEJuGRn1fPtIhle4IQBa97o9mTSp+NS2xc4T/bS0m73aLgtH6/Csx0Rt8VPxZ72PrDKk6CudPATcBn7RZQZ9/HMiePusTNFrm2F8ukA09Gd18rISWDjY6PNb/7aKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861172; c=relaxed/simple;
	bh=vaALc1RlqcpfthlzwGmRVT83k3JjUA1NVec5kKzYZMY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eytxdVtXLm8oTR2cwY5xcy5rPaVr51DwAAqFaoWbEhrl3Hi9jhTGMNQ1YqNIkeTwYlp3u+QVhpXKzEgXmqn/s1++Gl7IssP1g2tQ8QDM2ZypdIRAu48nsOuIoO7L6UY4IsvdlZF/Hemk41Dm2XHrqbghh4zXFEYO0TOxG+7NqU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bnIQwC2Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bnIQwC2Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4BAFC2BCB3;
	Fri, 15 May 2026 16:06:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861172;
	bh=vaALc1RlqcpfthlzwGmRVT83k3JjUA1NVec5kKzYZMY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bnIQwC2QIXdOhl0t7SmNf8bzrshjDL3NOc60xPgRDr1BPZ5e60zxxGBBObfNmfWtK
	 IvRYinsow0aSjmyfm9WeQq6R7butOB3CLWjvYX/SvcjQ869UtMMXQLvErkkewwg0D/
	 hzvE2lkCEAq3GVD6jC+uA5FBPj6jlajwvOYRRlpI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sanman Pradhan <psanman@juniper.net>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.6 226/474] hwmon: (ltc2992) Fix u32 overflow in power read path
Date: Fri, 15 May 2026 17:45:35 +0200
Message-ID: <20260515154719.897519159@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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
@@ -627,8 +627,10 @@ static int ltc2992_get_power(struct ltc2
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


