Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D16F2E9753;
	Tue, 17 Jun 2025 15:37:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174630; cv=none; b=Kqu6Oq7bkWE9qfr2CruCJq0HJWwT9PvJfffXsKHnT57meQIdoZH0r5ZhQSX2K88oUL57z70NUsys1icrqOxoGBK/AlaMfPrTf3tbOblYYsXApfW7xCnqnoOjaDMgBLBaJz5saprMEaCdG0933vnBUsmSBCHyF1T2DgTccXH+jIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174630; c=relaxed/simple;
	bh=OpXgOliqP0uUfe0/oveYOzD4beZbdOwN8vQklGWXs0c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GOExq4KTbKXIUURr31datfdGoSirNIYEHXhGf8mGmm3qnU9Tevb7CvTQHjuXxJxIUK4bASKjF0VNrw4l4xDxzRXFUB3sCTAyaKy4NIZ15a0PCqM7KOl+Z0o3j4T5hX2dhFQJNZGPd40X2JgOvidUiLlBc3mSA6XB2Pj/3fygE6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mda+QeQI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mda+QeQI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 052C2C4CEE3;
	Tue, 17 Jun 2025 15:37:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174630;
	bh=OpXgOliqP0uUfe0/oveYOzD4beZbdOwN8vQklGWXs0c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mda+QeQIZ/H1EngCi7UmP4gZ3qgqQebWKpJnSxJskiMCptDH6o3Zv8HHMO5KVdpC1
	 xrEUBtCeKkBgkC4Nd4f8/b8hxLDvPpDYKpCTqVgTzOcIg4Jrcj0aA0/7887VyK86gI
	 nkN869b1sebTfTMp0ZiCO3pRheN4RYzBUkNGn59Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 032/512] crypto: xts - Only add ecb if it is not already there
Date: Tue, 17 Jun 2025 17:19:58 +0200
Message-ID: <20250617152420.859309135@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 672e1a3f0b0c9..91e391a6ba270 100644
--- a/crypto/xts.c
+++ b/crypto/xts.c
@@ -363,7 +363,7 @@ static int xts_create(struct crypto_template *tmpl, struct rtattr **tb)
 
 	err = crypto_grab_skcipher(&ctx->spawn, skcipher_crypto_instance(inst),
 				   cipher_name, 0, mask);
-	if (err == -ENOENT) {
+	if (err == -ENOENT && memcmp(cipher_name, "ecb(", 4)) {
 		err = -ENAMETOOLONG;
 		if (snprintf(name, CRYPTO_MAX_ALG_NAME, "ecb(%s)",
 			     cipher_name) >= CRYPTO_MAX_ALG_NAME)
@@ -397,7 +397,7 @@ static int xts_create(struct crypto_template *tmpl, struct rtattr **tb)
 	/* Alas we screwed up the naming so we have to mangle the
 	 * cipher name.
 	 */
-	if (!strncmp(cipher_name, "ecb(", 4)) {
+	if (!memcmp(cipher_name, "ecb(", 4)) {
 		int len;
 
 		len = strscpy(name, cipher_name + 4, sizeof(name));
-- 
2.39.5



