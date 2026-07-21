Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7641135C6AC;
	Tue, 21 Jul 2026 22:32:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673125; cv=none; b=f3fWbvXZuN44v9NKSH1qSmRkyBX7i/4Oe44TcWHp2FzKg7Xlj0rQLJ2he45X9BdoF24UJVQpSrJVmCdlfQOclmPj9x9xPOOUmX3/F+WJP81zkKQAWlZBtdZNljmQJdskdWcGwQuLUfdTAiavXxhORvHkRs9TRPKUZ0WI7nybqv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673125; c=relaxed/simple;
	bh=xlQrVy0gBZ//OTbNBqeu10B4TQZ0DDnOHphdK8biY0g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IHoYXTJo9W42fpB5v4EQI87kNNfl/SsXWh/kKaiHLrgQqLdayq6vUuLoWmKrzuqBfWet9pVAr3DiUNXw06qiOvlH3/ir0AoU1iygOhwhADO3Q1Tj6sonqcFTCwgbRIDfHgnR6CXGtUO+fWVTBdrRBVF5oPxg8U6oev+aG0xI+SA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c6gsWKXu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c6gsWKXu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 846CB1F000E9;
	Tue, 21 Jul 2026 22:32:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673124;
	bh=lxW12hXpGwCYwaw8Imq0P9QP8L3umqZumGJMTWuBHHM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c6gsWKXuYP0vDFTMnRXn3VG/aEnL0pdyrj9Q30cFoSSllY4rPILo0HuyvtoWlx7FQ
	 r63jeNJIQAP4cyUtY0R6craSAN9y75rF786CVmwK6MwxMttdHAIQbG5zsvCgFKEIID
	 g56qyrv6T+Mj1SFDbh3AFMIKEUBCNncEf7tEqPaU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vidhu Sarwal <vidhu.linux@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 5.10 045/699] iio: light: al3010: fix incorrect scale for the highest gain range
Date: Tue, 21 Jul 2026 17:16:44 +0200
Message-ID: <20260721152356.726334786@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vidhu Sarwal <vidhu.linux@gmail.com>

commit aa411adc6ce40ad1a55ebc965f255a4cfc0005f8 upstream.

al3010_scales[] encodes the highest gain range as {0, 1187200}.
For IIO_VAL_INT_PLUS_MICRO, the fractional part must be less than
1000000, so the scale 1.1872 should instead be represented as
{ 1, 187200 }.

Since write_raw() compares the value from userspace against this
table, writing the advertised 1.1872 scale never matches the malformed
entry and returns -EINVAL. As a result, the highest gain range cannot
be selected. Reading the scale in that state also reports the malformed
value.

Fixes: c36b5195ab70 ("iio: light: add Dyna-Image AL3010 driver")
Signed-off-by: Vidhu Sarwal <vidhu.linux@gmail.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/light/al3010.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/light/al3010.c
+++ b/drivers/iio/light/al3010.c
@@ -43,7 +43,7 @@ enum al3xxxx_range {
 };
 
 static const int al3010_scales[][2] = {
-	{0, 1187200}, {0, 296800}, {0, 74200}, {0, 18600}
+	{ 1, 187200 }, { 0, 296800 }, { 0, 74200 }, { 0, 18600 },
 };
 
 struct al3010_data {


