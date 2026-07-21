Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D30C0470440;
	Tue, 21 Jul 2026 20:24:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665495; cv=none; b=o5eah58jUjEUWk7o9WAeu4XkAsDKXA6mw1zutBxo7fmVXXaPDImRTGCY2xTKwjOfjDsWf9zBbuvVvuj37ei9lrbKrPRUb5lFzpSugrEvzElfjBlPFMeoOHlqHlnqa4KqjPiIrOklrWe54NPwSoj78e+ZdQU8qDBZ9ATECds9EDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665495; c=relaxed/simple;
	bh=og2iVJVUBfob4aqgx6jrzS0CFXwv2enLIvZ2bLaN9tI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GaqEZGZZqno8RNxXBHvOAm1gbEpGBNGnqlbGb/1DRjBZ672tSgc6C0MVwOMozaWjCitQtexSxJbiroRUjHBJpP0nVRs2OnnPfpxWMa0cDcEAR+3obv03NjfmUcDELaF8DkRVb7/Z7kRAfUv7m5TD/F7ZdWgA8WlTyNZWx6uRObU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zPEn21IV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zPEn21IV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 444211F000E9;
	Tue, 21 Jul 2026 20:24:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665493;
	bh=ipY+DSE0thP/Ws3l95orFGUesq3ukhv/iM4ZLoD0TqI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zPEn21IVYuv4brsL4WHwT7fAzSUYOLM0EEAR6VdQ3Dn/oSW2BMm+ai/WhJJz3p2ee
	 6LT4IbD42DBTbod4IlBU3FdySqgrI3NiXjJct3BqO2/WojtThVD+N+5HGUPJFIzSJh
	 aXE/tyotVhlCQATa1x658Ivp1U4R0KcVhFfw9QL4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anastasia Tishchenko <sv3iry@gmail.com>,
	Lukas Wunner <lukas@wunner.de>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.6 0272/1266] crypto: ecc - Fix carry overflow in vli multiplication
Date: Tue, 21 Jul 2026 17:11:49 +0200
Message-ID: <20260721152447.907605066@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

From: Anastasia Tishchenko <sv3iry@gmail.com>

commit 27b536a2ec8e2f85a0380c2d13c9ecbc7aaab406 upstream.

The carry flag calculation fails when r01.m_high is saturated
(0xFFFFFFFFFFFFFFFF) and addition of lower bits overflows.

The condition (r01.m_high < product.m_high) doesn't handle the case
where r01.m_high == product.m_high and an additional carry exists
from lower-bit overflow.

When commit 3c4b23901a0c ("crypto: ecdh - Add ECDH software support")
introduced crypto/ecc.c, it split the muladd() function in the
micro-ecc library into separate mul_64_64() and add_128_128() helpers.
It seems the check got lost in translation.

Add proper handling for this boundary by accounting for the carry
from the lower addition.

Fixes: 3c4b23901a0c ("crypto: ecdh - Add ECDH software support")
Signed-off-by: Anastasia Tishchenko <sv3iry@gmail.com>
Cc: stable@vger.kernel.org # v4.8+
Reviewed-by: Lukas Wunner <lukas@wunner.de>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 crypto/ecc.c |   31 ++++++++++++++++++++-----------
 1 file changed, 20 insertions(+), 11 deletions(-)

--- a/crypto/ecc.c
+++ b/crypto/ecc.c
@@ -400,14 +400,26 @@ static uint128_t mul_64_64(u64 left, u64
 	return result;
 }
 
-static uint128_t add_128_128(uint128_t a, uint128_t b)
+/* Calculate addition with overflow checking. Returns true on wrap-around,
+ * false otherwise.
+ */
+static bool check_add_128_128_overflow(uint128_t *result, uint128_t a,
+				       uint128_t b)
 {
-	uint128_t result;
+	bool carry;
 
-	result.m_low = a.m_low + b.m_low;
-	result.m_high = a.m_high + b.m_high + (result.m_low < a.m_low);
+	result->m_low = a.m_low + b.m_low;
+	carry = (result->m_low < a.m_low);
 
-	return result;
+	result->m_high = a.m_high + b.m_high + carry;
+
+	/* Using constant-time bitwise arithmetic to prevent timing
+	 * side-channels.
+	 */
+	carry = (result->m_high < a.m_high) |
+		((result->m_high == a.m_high) & carry);
+
+	return carry;
 }
 
 static void vli_mult(u64 *result, const u64 *left, const u64 *right,
@@ -432,9 +444,7 @@ static void vli_mult(u64 *result, const
 			uint128_t product;
 
 			product = mul_64_64(left[i], right[k - i]);
-
-			r01 = add_128_128(r01, product);
-			r2 += (r01.m_high < product.m_high);
+			r2 += check_add_128_128_overflow(&r01, r01, product);
 		}
 
 		result[k] = r01.m_low;
@@ -457,7 +467,7 @@ static void vli_umult(u64 *result, const
 		uint128_t product;
 
 		product = mul_64_64(left[k], right);
-		r01 = add_128_128(r01, product);
+		check_add_128_128_overflow(&r01, r01, product);
 		/* no carry */
 		result[k] = r01.m_low;
 		r01.m_low = r01.m_high;
@@ -494,8 +504,7 @@ static void vli_square(u64 *result, cons
 				product.m_low <<= 1;
 			}
 
-			r01 = add_128_128(r01, product);
-			r2 += (r01.m_high < product.m_high);
+			r2 += check_add_128_128_overflow(&r01, r01, product);
 		}
 
 		result[k] = r01.m_low;


