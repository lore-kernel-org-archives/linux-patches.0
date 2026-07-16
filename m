Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 524933D891B;
	Thu, 16 Jul 2026 13:51:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209908; cv=none; b=olWBkbh011VmX/28ooEvNLGHmh+7ntfH/lnuFnayXcGif+JnkUp+I7JOGcMRwkUiqfU9O7WUCbCyTALRzIwDeu0vMivtu9qN3XA7j7mcSn1L4RYZSddgTtl2q4OVjZKz5GFP6yGqEHNBtEIWSp4pzM5F1N4P9LvRalaDUpPzvaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209908; c=relaxed/simple;
	bh=ybhFcGgllXyPDRsooVO4zJRxrtnW2umK1UhoaioxQVU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WX7SiMBlazy3SmNoSRh0wycCuyXUFkrMdAvdN6dx3VYV6a9K40hSN3VGaUG0cbvftelR4kvC5Z/h5bcoFwbC3KCbf/09oV+6/4PpkG4x9TlQGhZsB492qEcWh5fheNwDBw12m7J8uFJmbJhTrvH+E0ohfWrPZfFUFI0DYbuPvWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vu8G94Gr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vu8G94Gr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B72BC1F000E9;
	Thu, 16 Jul 2026 13:51:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209907;
	bh=+yWspRW325zlwDUWR6lOGktbJrUAnn5RPH6JE9UCb4U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vu8G94Grlj9AoWpO2szbXISq/AkwAfNIKpcpszmBq5AROT3MiTuj+svtrKGML9HVM
	 Lv8+MMf4Br4zEdaqVBOk2q6lfURo/yPlcLlvDMztaT+pHwTNnLZEcEXwSLLffy/lz5
	 KPutq6dBeKZ2E5/A7+qaBDkI3mhL8IVMP+zZYcEI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anastasia Tishchenko <sv3iry@gmail.com>,
	Lukas Wunner <lukas@wunner.de>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 7.1 365/518] crypto: ecc - Fix carry overflow in vli multiplication
Date: Thu, 16 Jul 2026 15:30:33 +0200
Message-ID: <20260716133055.816631610@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -393,14 +393,26 @@ static uint128_t mul_64_64(u64 left, u64
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
@@ -425,9 +437,7 @@ static void vli_mult(u64 *result, const
 			uint128_t product;
 
 			product = mul_64_64(left[i], right[k - i]);
-
-			r01 = add_128_128(r01, product);
-			r2 += (r01.m_high < product.m_high);
+			r2 += check_add_128_128_overflow(&r01, r01, product);
 		}
 
 		result[k] = r01.m_low;
@@ -450,7 +460,7 @@ static void vli_umult(u64 *result, const
 		uint128_t product;
 
 		product = mul_64_64(left[k], right);
-		r01 = add_128_128(r01, product);
+		check_add_128_128_overflow(&r01, r01, product);
 		/* no carry */
 		result[k] = r01.m_low;
 		r01.m_low = r01.m_high;
@@ -487,8 +497,7 @@ static void vli_square(u64 *result, cons
 				product.m_low <<= 1;
 			}
 
-			r01 = add_128_128(r01, product);
-			r2 += (r01.m_high < product.m_high);
+			r2 += check_add_128_128_overflow(&r01, r01, product);
 		}
 
 		result[k] = r01.m_low;


