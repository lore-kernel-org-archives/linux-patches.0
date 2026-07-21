Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5F1D3D6CCA;
	Tue, 21 Jul 2026 22:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673422; cv=none; b=RvEgXB9EbQBRZauJl29TWr5GvimnyGuW4aS/Y47i7XX8DCVvw3sZh1s9r8/3gmyoIb4960io+lQZmb+mlVYiXA0a0r3CpvG2+RhJiengPzEKvbGIUzbia19ohxPdIW48Nrddd4UYNMypkF5ueCwEAcXymFhD2FvK3XJoSAJCl/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673422; c=relaxed/simple;
	bh=rLR7G+wOV7fP0Ck4+wIJi8LlwpgKE0XJWyZGR650qDY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GAJdbIYvcqWq8ZKfZumxa392NRipAoNyPyFGR+VCgsTIo9IMlLO5RPOAe6xlJ6Fsqy9MXSQiH4d71pDPYbKjh1OUfX4JSwW2OCPqLEqqocMQqecEbLDSiMZuRY6kQf2dBqmtx0c3dNTZXWf9truzcZFj6dQLad7G8NAXFP2D6l8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B1T69B6O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B1T69B6O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D70F1F000E9;
	Tue, 21 Jul 2026 22:36:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673420;
	bh=hl/LPxZh5C1pQvHAkItOJkugwLo5nEdwlG0vu3QYX+w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B1T69B6OZoz+O5nwXUjf/SWM1rECvx1MpvrIFo6GNCCDP91aPW6chg4iV4/ygzCBR
	 Hl2oesWDqND2u09OjOF+JmewP0pZMjQQd4ETrehmmaDCIQiqCmS3iM0VdpFSo9zhEZ
	 mkY6/9YakMkvYSOBWrkqhHtWAKiNVAD9bV0hocSw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anastasia Tishchenko <sv3iry@gmail.com>,
	Lukas Wunner <lukas@wunner.de>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.10 129/699] crypto: ecc - Fix carry overflow in vli multiplication
Date: Tue, 21 Jul 2026 17:18:08 +0200
Message-ID: <20260721152358.617416421@linuxfoundation.org>
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
@@ -364,14 +364,26 @@ static uint128_t mul_64_64(u64 left, u64
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
@@ -396,9 +408,7 @@ static void vli_mult(u64 *result, const
 			uint128_t product;
 
 			product = mul_64_64(left[i], right[k - i]);
-
-			r01 = add_128_128(r01, product);
-			r2 += (r01.m_high < product.m_high);
+			r2 += check_add_128_128_overflow(&r01, r01, product);
 		}
 
 		result[k] = r01.m_low;
@@ -421,7 +431,7 @@ static void vli_umult(u64 *result, const
 		uint128_t product;
 
 		product = mul_64_64(left[k], right);
-		r01 = add_128_128(r01, product);
+		check_add_128_128_overflow(&r01, r01, product);
 		/* no carry */
 		result[k] = r01.m_low;
 		r01.m_low = r01.m_high;
@@ -458,8 +468,7 @@ static void vli_square(u64 *result, cons
 				product.m_low <<= 1;
 			}
 
-			r01 = add_128_128(r01, product);
-			r2 += (r01.m_high < product.m_high);
+			r2 += check_add_128_128_overflow(&r01, r01, product);
 		}
 
 		result[k] = r01.m_low;


