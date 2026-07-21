Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB1CF3C0A02;
	Tue, 21 Jul 2026 21:15:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668527; cv=none; b=fc9jXZCah6pzp2yt+NvWjcppUVYAPxL8nAWwdTpmfC0SjO8SqhYpTvGk559RcJKPmAaAk3pw8yAe7j3UpoRMO9/rVaoJUiCaKb0xLGc5nSKrqB1Mj6aD3PHsXBV3ANQqvEOLrN0RWm0ymNWdn+BJ066sRYdQJd8R2QFokY3wfGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668527; c=relaxed/simple;
	bh=DYq0DglkKN/EZIoXhSb1p6XsBBD3eU3ljGVukhtjEUY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fiqx/t+/LjUdrXCeRGJrdKwi+fBLfNvMh5Gfo8gCZTHgY/0uPZqK25w/Xo9BWB+G6LJLVfurx9GNw1cN3/UtxDKRpggTWlyc2tz8AI+/u+reREBlDalL6FZ3yOl73sIXD+E1tsdk0ucM8rdev8nMvO8+qP3+iW40BSvN5fHSoCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HevLjq3C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HevLjq3C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C6191F000E9;
	Tue, 21 Jul 2026 21:15:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668525;
	bh=lEIEAvqcHS9x1VfW7/2BCqwtnOpJZpzFsWDKAz9Jo40=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HevLjq3C3c1qPw+hIflSVw2vSYhfRO80oc52TkNhMmoF3JdoJi2GZOk8GIudixsEY
	 n658Z7wH8W/UZX89yxJqq5gBWgUATH5g9+FYcR6VOADHpQmeo4Gsx4sDQERKqxHPab
	 s64F+DwdpZk8ak+iwKNE2uYimVrtZswX5l6dEQpE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anastasia Tishchenko <sv3iry@gmail.com>,
	Lukas Wunner <lukas@wunner.de>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.1 0210/1067] crypto: ecc - Fix carry overflow in vli multiplication
Date: Tue, 21 Jul 2026 17:13:31 +0200
Message-ID: <20260721152429.290769057@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -378,14 +378,26 @@ static uint128_t mul_64_64(u64 left, u64
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
@@ -410,9 +422,7 @@ static void vli_mult(u64 *result, const
 			uint128_t product;
 
 			product = mul_64_64(left[i], right[k - i]);
-
-			r01 = add_128_128(r01, product);
-			r2 += (r01.m_high < product.m_high);
+			r2 += check_add_128_128_overflow(&r01, r01, product);
 		}
 
 		result[k] = r01.m_low;
@@ -435,7 +445,7 @@ static void vli_umult(u64 *result, const
 		uint128_t product;
 
 		product = mul_64_64(left[k], right);
-		r01 = add_128_128(r01, product);
+		check_add_128_128_overflow(&r01, r01, product);
 		/* no carry */
 		result[k] = r01.m_low;
 		r01.m_low = r01.m_high;
@@ -472,8 +482,7 @@ static void vli_square(u64 *result, cons
 				product.m_low <<= 1;
 			}
 
-			r01 = add_128_128(r01, product);
-			r2 += (r01.m_high < product.m_high);
+			r2 += check_add_128_128_overflow(&r01, r01, product);
 		}
 
 		result[k] = r01.m_low;


