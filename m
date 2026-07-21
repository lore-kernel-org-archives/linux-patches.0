Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7578433BCA;
	Tue, 21 Jul 2026 22:00:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671231; cv=none; b=IUb2iG+x+/4t4lPTl0jYKN5CmkoXkqG+DivcwvCJjH/beHmasJ/fjjBB1Q5iUyBaxtMQEh10u6niBAUMAtXXSzwIT6qGLFvV4BGvJKsn9PA61lCSgv1hvNq0DVhYBGlrvlaRosbd0Y+m8cGUgJnZQyONxsQnyNMKh6cdmlJQn8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671231; c=relaxed/simple;
	bh=cLv7Erv5yszerQ6K57d8q20mLxmiPyhqFfndtBnazb4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sBNOGfO9CWzJnDeizXijpubhQUZGlFMSfNXVFA0NO21iLTIPNPDBpphsgpCc11Q0voIQn6ryVqTohAY7mW6vwRmJr2TS64Rly/eEPujic83zMZat2dj6F+78tFhjFICxGLYvnPVtdviBKwKnn8Vtbwa+zZNKzK5VWujkZwmKdyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KhCQFpcM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KhCQFpcM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4957A1F000E9;
	Tue, 21 Jul 2026 22:00:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671228;
	bh=N7HH8fXV8Z6EhkLy9E4+l5yn4vJuUmSfsCHGTSaSVc4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KhCQFpcMAHj/QhJ2WJ0RMun2jHHIKX9B8s/yeKzLi0jgtIodC6Laqg0B41X5ht5iF
	 aoGexxhfnKPu+TFVqmyFsd7afdr7ePq1+Dvoj9awYeZZcwWoAo7UIQ0iF02cJDzu3W
	 n4UrAhIAz6w3Bnw0LiWnBRperq0Jk2jO0YIfUGc8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anastasia Tishchenko <sv3iry@gmail.com>,
	Lukas Wunner <lukas@wunner.de>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.15 165/843] crypto: ecc - Fix carry overflow in vli multiplication
Date: Tue, 21 Jul 2026 17:16:40 +0200
Message-ID: <20260721152409.728112311@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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
@@ -375,14 +375,26 @@ static uint128_t mul_64_64(u64 left, u64
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
@@ -407,9 +419,7 @@ static void vli_mult(u64 *result, const
 			uint128_t product;
 
 			product = mul_64_64(left[i], right[k - i]);
-
-			r01 = add_128_128(r01, product);
-			r2 += (r01.m_high < product.m_high);
+			r2 += check_add_128_128_overflow(&r01, r01, product);
 		}
 
 		result[k] = r01.m_low;
@@ -432,7 +442,7 @@ static void vli_umult(u64 *result, const
 		uint128_t product;
 
 		product = mul_64_64(left[k], right);
-		r01 = add_128_128(r01, product);
+		check_add_128_128_overflow(&r01, r01, product);
 		/* no carry */
 		result[k] = r01.m_low;
 		r01.m_low = r01.m_high;
@@ -469,8 +479,7 @@ static void vli_square(u64 *result, cons
 				product.m_low <<= 1;
 			}
 
-			r01 = add_128_128(r01, product);
-			r2 += (r01.m_high < product.m_high);
+			r2 += check_add_128_128_overflow(&r01, r01, product);
 		}
 
 		result[k] = r01.m_low;


