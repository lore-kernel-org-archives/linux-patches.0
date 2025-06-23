Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 883A32550D7;
	Mon, 23 Jun 2025 13:22:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684970; cv=none; b=scN0BUcrThNQdnihPDMZ0KPKYAz18y21Rd6VMlzHPrJb4j3gdcmH4Wgw9ybbcYF9zbjUiOhMgMEqa84lSpQXKAbAjIRqnrVq9IZKOSJDueXbLxNDBFox9lu+d/45Hyd7GRzEGSy4zzWLjKL6kMPn4qS09flZsCxVdhkKadTUGwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684970; c=relaxed/simple;
	bh=nbG/glR48gYb8HILA7ifc8w/R3eiWdYIR57hD8REHnM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QfbJk44rN7/qrvD8PPuc8fo3Sv0x59S7Up6Is21MvKdCjILLkFybILAinarL36RkyA/W2r5CHkBUlKWUoQB1g3zUcoaT+A+zoaqmVN7ivWgrsTSfdnlJLBIXp0hrm4wRCkALPlkEO6+rUi/ygDBlpvGXhpFNFC8gy8KrqX1tiDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NV0bHUw6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NV0bHUw6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CA56C4CEEA;
	Mon, 23 Jun 2025 13:22:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684970;
	bh=nbG/glR48gYb8HILA7ifc8w/R3eiWdYIR57hD8REHnM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NV0bHUw6sHe0ecsDLi7BaJlGSv2ZapaaTxIRm+f1Cpn6EQ9WWtChH6+5VTRfWPOHO
	 M+Cbwn5lafCFd5M9m0xpY7SIhAmDvVByUI1PKLlIeBBecwbRzMfgQ1iE2ZnqcIa/ly
	 PLDxU0UGkGKNKmQ2TWr5RAwcmG51k5G8AxagQJ8Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 017/355] crypto: xts - Only add ecb if it is not already there
Date: Mon, 23 Jun 2025 15:03:38 +0200
Message-ID: <20250623130627.304594820@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit 270b6f13454cb7f2f7058c50df64df409c5dcf55 ]

Only add ecb to the cipher name if it isn't already ecb.

Also use memcmp instead of strncmp since these strings are all
stored in an array of length CRYPTO_MAX_ALG_NAME.

Fixes: f1c131b45410 ("crypto: xts - Convert to skcipher")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/xts.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/crypto/xts.c b/crypto/xts.c
index 74dc199d54867..a4677e1a1611f 100644
--- a/crypto/xts.c
+++ b/crypto/xts.c
@@ -360,7 +360,7 @@ static int xts_create(struct crypto_template *tmpl, struct rtattr **tb)
 
 	err = crypto_grab_skcipher(&ctx->spawn, skcipher_crypto_instance(inst),
 				   cipher_name, 0, mask);
-	if (err == -ENOENT) {
+	if (err == -ENOENT && memcmp(cipher_name, "ecb(", 4)) {
 		err = -ENAMETOOLONG;
 		if (snprintf(ctx->name, CRYPTO_MAX_ALG_NAME, "ecb(%s)",
 			     cipher_name) >= CRYPTO_MAX_ALG_NAME)
@@ -394,7 +394,7 @@ static int xts_create(struct crypto_template *tmpl, struct rtattr **tb)
 	/* Alas we screwed up the naming so we have to mangle the
 	 * cipher name.
 	 */
-	if (!strncmp(cipher_name, "ecb(", 4)) {
+	if (!memcmp(cipher_name, "ecb(", 4)) {
 		int len;
 
 		len = strscpy(ctx->name, cipher_name + 4, sizeof(ctx->name));
-- 
2.39.5



