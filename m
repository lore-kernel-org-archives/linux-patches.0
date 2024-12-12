Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5407F2153F4;
	Thu, 12 Dec 2024 15:07:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016039; cv=none; b=jM+DKXaH3cujukw2UiX1p+HPBmCicpvs6PM8WzH+B6LAqHGgaGajI7+70+MpwW3NiMIGQoC5DIdI0NPqJ5bdO8bay/9HX/GQlx4ojqba6veOu1/hW8NXSCk/OBACMKwRAhZIutX8slqMhsTV80xFGDSk80HNfrWra6rrNM3Deu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016039; c=relaxed/simple;
	bh=HMVX/2P71yqzoOGam2NHdkjczzeZZPFm4Mhmw1gE/Lk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IrhCw1YTpVntYSHOHIY/nBSsiF0mmTTg1lYUi26i9cTm2VkNg4avruQDezUAdb0yJW0gQ/UzRVbaK/YJIUs3d2vnwl+HHZ58qVI21kNJActv1MoajwQKg1cvEwcZ9h0Xay+FzEmf/8QQE5qFNhkHWqIyB1qZVbI5TXc56Cum1hE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0NJD7g4W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0NJD7g4W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FB45C4CECE;
	Thu, 12 Dec 2024 15:07:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016038;
	bh=HMVX/2P71yqzoOGam2NHdkjczzeZZPFm4Mhmw1gE/Lk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0NJD7g4WOedHZpS73pQgQx/bscos8mgqB3kO2oibQ8UEYz1shPMtr+ZvaVB0H/cPl
	 vMOY2Dsb9W+8cC5tM+06gmOSURsFxIsdlDWjfFQNtDPjHS856orUKKdFp+jspXOaUn
	 kEhD9/m/INc8GhSwP+TNCZdADRpua3KMxMqTCBrI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakob Hauser <jahau@rocketmail.com>,
	kernel test robot <lkp@intel.com>,
	David Laight <david.laight@aculab.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Lars-Peter Clausen <lars@metafoo.de>,
	Linus Walleij <linus.walleij@linaro.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 114/466] iio: magnetometer: yas530: use signed integer type for clamp limits
Date: Thu, 12 Dec 2024 15:54:43 +0100
Message-ID: <20241212144311.321906615@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakob Hauser <jahau@rocketmail.com>

[ Upstream commit f1ee5483e40881d8ad5a63aa148b753b5c6a839b ]

In the function yas537_measure() there is a clamp_val() with limits of
-BIT(13) and BIT(13) - 1.  The input clamp value h[] is of type s32.  The
BIT() is of type unsigned long integer due to its define in
include/vdso/bits.h.  The lower limit -BIT(13) is recognized as -8192 but
expressed as an unsigned long integer.  The size of an unsigned long
integer differs between 32-bit and 64-bit architectures.  Converting this
to type s32 may lead to undesired behavior.

Additionally, in the calculation lines h[0], h[1] and h[2] the unsigned
long integer divisor BIT(13) causes an unsigned division, shifting the
left-hand side of the equation back and forth, possibly ending up in large
positive values instead of negative values on 32-bit architectures.

To solve those two issues, declare a signed integer with a value of
BIT(13).

There is another omission in the clamp line: clamp_val() returns a value
and it's going nowhere here.  Self-assign it to h[i] to make use of the
clamp macro.

Finally, replace clamp_val() macro by clamp() because after changing the
limits from type unsigned long integer to signed integer it's fine that
way.

Link: https://lkml.kernel.org/r/11609b2243c295d65ab4d47e78c239d61ad6be75.1732914810.git.jahau@rocketmail.com
Fixes: 65f79b501030 ("iio: magnetometer: yas530: Add YAS537 variant")
Signed-off-by: Jakob Hauser <jahau@rocketmail.com>

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202411230458.dhZwh3TT-lkp@intel.com/
Closes: https://lore.kernel.org/oe-kbuild-all/202411282222.oF0B4110-lkp@intel.com/
Reviewed-by: David Laight <david.laight@aculab.com>
Acked-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Lars-Peter Clausen <lars@metafoo.de>
Cc: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/magnetometer/yamaha-yas530.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/iio/magnetometer/yamaha-yas530.c b/drivers/iio/magnetometer/yamaha-yas530.c
index 65011a8598d33..c55a38650c0d4 100644
--- a/drivers/iio/magnetometer/yamaha-yas530.c
+++ b/drivers/iio/magnetometer/yamaha-yas530.c
@@ -372,6 +372,7 @@ static int yas537_measure(struct yas5xx *yas5xx, u16 *t, u16 *x, u16 *y1, u16 *y
 	u8 data[8];
 	u16 xy1y2[3];
 	s32 h[3], s[3];
+	int half_range = BIT(13);
 	int i, ret;
 
 	mutex_lock(&yas5xx->lock);
@@ -406,13 +407,13 @@ static int yas537_measure(struct yas5xx *yas5xx, u16 *t, u16 *x, u16 *y1, u16 *y
 	/* The second version of YAS537 needs to include calibration coefficients */
 	if (yas5xx->version == YAS537_VERSION_1) {
 		for (i = 0; i < 3; i++)
-			s[i] = xy1y2[i] - BIT(13);
-		h[0] = (c->k *   (128 * s[0] + c->a2 * s[1] + c->a3 * s[2])) / BIT(13);
-		h[1] = (c->k * (c->a4 * s[0] + c->a5 * s[1] + c->a6 * s[2])) / BIT(13);
-		h[2] = (c->k * (c->a7 * s[0] + c->a8 * s[1] + c->a9 * s[2])) / BIT(13);
+			s[i] = xy1y2[i] - half_range;
+		h[0] = (c->k *   (128 * s[0] + c->a2 * s[1] + c->a3 * s[2])) / half_range;
+		h[1] = (c->k * (c->a4 * s[0] + c->a5 * s[1] + c->a6 * s[2])) / half_range;
+		h[2] = (c->k * (c->a7 * s[0] + c->a8 * s[1] + c->a9 * s[2])) / half_range;
 		for (i = 0; i < 3; i++) {
-			clamp_val(h[i], -BIT(13), BIT(13) - 1);
-			xy1y2[i] = h[i] + BIT(13);
+			h[i] = clamp(h[i], -half_range, half_range - 1);
+			xy1y2[i] = h[i] + half_range;
 		}
 	}
 
-- 
2.43.0



