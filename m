Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CF5324C060;
	Mon, 23 Jun 2025 13:27:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685239; cv=none; b=RNO/sHNO+VBH24I1BYyXAgt0YG3RxCKYt9TQCG9ecIiizOXOhKWPyrC3zTnbKaNqwK4imCdRutGtvhsYjngPPYHIO/Z60Bzb3Wl9577R1+z41bc3FxILxymuO2I1djymeiYFoCvotUlPoLe7cECV8BHd8ILb1DKOnCk2Sk8A3fk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685239; c=relaxed/simple;
	bh=rj0GAkXWr99NSUfViMLe+Qc3VP8oVwK2nYpox0dT+eM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fXgzQnz1uWmYRoDlkiPU86tyarTroKfiOS4Wzw7R8sbnBfgXqurSZbUP2aWzVfsi9WbNW0I3XUh5kT3fx6sUMr7rTmeh7Oonevpej0Jl0AN6XHBdgLzqdN/rLVIvFMWDJtVYBs9Oc6whQuCcfT9WKNM/axBXjftGdgQyhytwvM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d74S0xv2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d74S0xv2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FD1AC4CEEA;
	Mon, 23 Jun 2025 13:27:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685239;
	bh=rj0GAkXWr99NSUfViMLe+Qc3VP8oVwK2nYpox0dT+eM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d74S0xv25w6plxgtqlAATeGuQ9XI/RRKjL/kROoXYlLOW8+d56I2qMExW232edGkp
	 hm4LENba9utDU4dXXMQpW5hjzd+s/6KmjyWXRad/LA4LXJ/yiOW4fk/pr3nRWWNgJK
	 npjX6hVxC8JV1L9fih/QPefet4QtvkFCfMiYxtyI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 019/411] crypto: xts - Only add ecb if it is not already there
Date: Mon, 23 Jun 2025 15:02:43 +0200
Message-ID: <20250623130633.578958933@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



