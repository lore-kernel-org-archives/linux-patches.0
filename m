Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20C5D30E84D;
	Mon, 23 Jun 2025 13:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685670; cv=none; b=SSNR/cAv5lt4JBblkNPhIlkKrIsrLA9SzeIP9BTmvco9rmtSAx7/pI2Mbkb55w0o23DPisfhuGgM5sgY3h7DBm78K/3IY14I7RHVW5LJ9Cle7pI2cwaZHWqojP9AvvfMghJXM2hUhKdYS1x/q667YsIivtI8H+HQtl9GYKbGgUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685670; c=relaxed/simple;
	bh=hCMPgeZ/mr5MUr5T468U4aLJVrZN1+BA0D1Bv9PFd9U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NoQTv2IoWagPUpk5TVcNMts2KaIiUAGeu1aSCIecT/c2etb1BSV9wA+JbYOK4suGqUe5MwCpgMXr3+PUpBfDnvaJlDA7AmfkK7O95dTVtwKFIa7SPh+HG2wlBGLfOYoncCug2jzEY0DK8pu0r7sk3wppWOHJqxVV+/feWYo+s6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Js4FM2A/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Js4FM2A/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 160C5C4CEEA;
	Mon, 23 Jun 2025 13:34:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685669;
	bh=hCMPgeZ/mr5MUr5T468U4aLJVrZN1+BA0D1Bv9PFd9U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Js4FM2A/PyCjWp31YZbn/B7caFBesa043CNdk9k38+Lc4v2zKvs2vh/BuVMrl22ZD
	 KtYmFjpo+VTPQ037u4Q4Ova6m/r0H6Rdkx+Zmf1ryr5b/mfrJM61ODU8Wwgz10p5E2
	 FZczBalCJBPPD6o9UlS3VKijpIHOuhxyPPoqVYY0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 023/508] crypto: xts - Only add ecb if it is not already there
Date: Mon, 23 Jun 2025 15:01:08 +0200
Message-ID: <20250623130645.821702239@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index b05020657cdc8..1972f40333f04 100644
--- a/crypto/xts.c
+++ b/crypto/xts.c
@@ -361,7 +361,7 @@ static int xts_create(struct crypto_template *tmpl, struct rtattr **tb)
 
 	err = crypto_grab_skcipher(&ctx->spawn, skcipher_crypto_instance(inst),
 				   cipher_name, 0, mask);
-	if (err == -ENOENT) {
+	if (err == -ENOENT && memcmp(cipher_name, "ecb(", 4)) {
 		err = -ENAMETOOLONG;
 		if (snprintf(ctx->name, CRYPTO_MAX_ALG_NAME, "ecb(%s)",
 			     cipher_name) >= CRYPTO_MAX_ALG_NAME)
@@ -395,7 +395,7 @@ static int xts_create(struct crypto_template *tmpl, struct rtattr **tb)
 	/* Alas we screwed up the naming so we have to mangle the
 	 * cipher name.
 	 */
-	if (!strncmp(cipher_name, "ecb(", 4)) {
+	if (!memcmp(cipher_name, "ecb(", 4)) {
 		int len;
 
 		len = strscpy(ctx->name, cipher_name + 4, sizeof(ctx->name));
-- 
2.39.5



