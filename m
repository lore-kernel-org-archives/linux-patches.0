Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DE551DD0D4;
	Tue, 26 Aug 2025 12:59:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213143; cv=none; b=hEWuW1pNOsY4qirrNW9eoslr9HDh0Nfr/teBC9GuIxSkv1f40XY6RS0glZogb0mZc1gPvoz8F0Lb26zT9h6KK8To5SNaWZshVldkhWDW9wWd0MGlXV4jyKN3y5mMtKLig6SfTQsU98kdOUIQ0oleYcFgatGfLizIT1wBdL59Wxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213143; c=relaxed/simple;
	bh=HMv+Ws94QyBEsOD2P09uiXLVeSPy9IPuUqbXFmitHLo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VMDq0r6PrwV5I7yfY1Y4laB0VLRAjMUAJWCl6n87W3MdE4kOtvKh4jGoUy2A2nhifcNPrHpOiqk2WITdxa1JZhKaK/rkXWIQg2sLLjI5XwHb3qG4DOy6s8WXmM8+qXl/UZtKzILXLSYCOyREahUHAM2Xh44Ko10QUGDsAnlJfn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bNODunRy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bNODunRy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC58BC4CEF1;
	Tue, 26 Aug 2025 12:59:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213143;
	bh=HMv+Ws94QyBEsOD2P09uiXLVeSPy9IPuUqbXFmitHLo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bNODunRybiii0X9xPwGx7njdQB4Gm1O7jCQCmLAOy+2qwghw6cT0lhpyPa+GX+Qhk
	 9KVwCmEFCQ8hE4yn8vuWMvcSEmNznS7kKf5rvrks3VRHIOHckzr8/sRpBpOgJhtsED
	 ldReIlZC1KyfW9gYWV3HqWMsAmPo0oy9PlKXqKPQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephan Mueller <smueller@chronox.de>,
	Markus Theil <theil.markus@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 238/587] crypto: jitter - fix intermediary handling
Date: Tue, 26 Aug 2025 13:06:27 +0200
Message-ID: <20250826110958.988464867@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Markus Theil <theil.markus@gmail.com>

[ Upstream commit 735b72568c73875269a6b73ab9543a70f6ac8a9f ]

The intermediary value was included in the wrong
hash state. While there, adapt to user-space by
setting the timestamp to 0 if stuck and inserting
the values nevertheless.

Acked-by: Stephan Mueller <smueller@chronox.de>
Signed-off-by: Markus Theil <theil.markus@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/jitterentropy-kcapi.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/crypto/jitterentropy-kcapi.c b/crypto/jitterentropy-kcapi.c
index 7d1463a1562a..dd05faf00571 100644
--- a/crypto/jitterentropy-kcapi.c
+++ b/crypto/jitterentropy-kcapi.c
@@ -134,7 +134,7 @@ int jent_hash_time(void *hash_state, __u64 time, u8 *addtl,
 	 * Inject the data from the previous loop into the pool. This data is
 	 * not considered to contain any entropy, but it stirs the pool a bit.
 	 */
-	ret = crypto_shash_update(desc, intermediary, sizeof(intermediary));
+	ret = crypto_shash_update(hash_state_desc, intermediary, sizeof(intermediary));
 	if (ret)
 		goto err;
 
@@ -147,11 +147,12 @@ int jent_hash_time(void *hash_state, __u64 time, u8 *addtl,
 	 * conditioning operation to have an identical amount of input data
 	 * according to section 3.1.5.
 	 */
-	if (!stuck) {
-		ret = crypto_shash_update(hash_state_desc, (u8 *)&time,
-					  sizeof(__u64));
+	if (stuck) {
+		time = 0;
 	}
 
+	ret = crypto_shash_update(hash_state_desc, (u8 *)&time, sizeof(__u64));
+
 err:
 	shash_desc_zero(desc);
 	memzero_explicit(intermediary, sizeof(intermediary));
-- 
2.39.5



