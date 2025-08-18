Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 654F0343D80;
	Mon, 18 Aug 2025 14:04:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525845; cv=none; b=LE8R1mOH+n+uUGd3yKwnqWcsa30oJjL5sHljSTcUTsMXJu/0ifRqDga+98u1sI1okQiuW24Onf2wbEAh+4HikSwfAgdavTcY4bQoCg1ukHIyKjNLYXWAoAhsLmziMyhM+PBIr8GNsCRj17Fc3sTyStVdAkPsxq8iZPCCggCnzvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525845; c=relaxed/simple;
	bh=RCxzd0Mkk+7sofUPMpVnHFuiS2CGclxspP3bHqyRq1E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fQiXPPjyMGlzgOsoI05UgB2V4ryBIU1ogwmCwrAHxCdqHFqHQmLCiDljrwVF5NTx08wIjrqIc1dnSKYP4tNUv9JhAQISu/3tW3VXo2GUsmznZrbskC5/vIxvmvyyGairI0wa3/3jbGym7noHa6dj/qp1X/wFZCgF32+mBUuFQNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Di7YPU0R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Di7YPU0R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7ADAC4CEF1;
	Mon, 18 Aug 2025 14:04:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525845;
	bh=RCxzd0Mkk+7sofUPMpVnHFuiS2CGclxspP3bHqyRq1E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Di7YPU0R8TdryaagSTjrfkUPUwRPYLe0vQ6neg+YZtNz7AdhOe80jZ3n3XXkAbHsT
	 YenKC0yk+G/v76SURSHhba0m3dau1mmvKTWd5ZWQlBuM7hi+FwOIblDjZ8bAYwn9ir
	 l6n9yfDtmJlmaZCazQbb1EgBNRbH2zaGs/mAuQ+Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephan Mueller <smueller@chronox.de>,
	Markus Theil <theil.markus@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 384/570] crypto: jitter - fix intermediary handling
Date: Mon, 18 Aug 2025 14:46:11 +0200
Message-ID: <20250818124520.640184512@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index c24d4ff2b4a8..1266eb790708 100644
--- a/crypto/jitterentropy-kcapi.c
+++ b/crypto/jitterentropy-kcapi.c
@@ -144,7 +144,7 @@ int jent_hash_time(void *hash_state, __u64 time, u8 *addtl,
 	 * Inject the data from the previous loop into the pool. This data is
 	 * not considered to contain any entropy, but it stirs the pool a bit.
 	 */
-	ret = crypto_shash_update(desc, intermediary, sizeof(intermediary));
+	ret = crypto_shash_update(hash_state_desc, intermediary, sizeof(intermediary));
 	if (ret)
 		goto err;
 
@@ -157,11 +157,12 @@ int jent_hash_time(void *hash_state, __u64 time, u8 *addtl,
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



