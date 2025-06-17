Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A2EA2F2366;
	Tue, 17 Jun 2025 15:44:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175069; cv=none; b=Q2M0GHgPXM2bYtJ12uMXMFkSyhSIO27ZiVp0F4N4PSTa3EHDqxrgoKi6UT5pPFzaDPPrgT4IuQU8ujboMgXZv4k8XfG+kCnUaNV4UjpqSc/NvdLWmN4LvnR1hNYC1blSxVTVh1RPQRohqBFxkI1TU5fzyfjaru8/Dhn/L/NPmW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175069; c=relaxed/simple;
	bh=IK8f7PO3mIHlZz6k2gvIimUaYK5/M9BZvuZjsB2v7L4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=axEo5PelH4z/o4obaJ1y5r6sp6zNZHyTtVdP/8v1p9MVjTmghH1OtKPBlnAGHhgRhMt+WGnGoLeaeMjhWkxpMq2jZxxg4uDSLsy2BukMM+nCJxHmRPRQzevvRF06j+DeeKl8/Lcq6hMEsF3EvO1SrIOBwG/S32TpZ8dEdtdJgN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B1q7Cc8D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B1q7Cc8D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B02BC4CEE3;
	Tue, 17 Jun 2025 15:44:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175069;
	bh=IK8f7PO3mIHlZz6k2gvIimUaYK5/M9BZvuZjsB2v7L4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B1q7Cc8DnT8jnAJrGGlAhGcLB8Qnfu93yqLS1N6tuRqBggAVOJ3jQf+TNJELQzOpH
	 v/kvAK+D2TzhxzB+u2NJxGiUrpHvgnySBJ1VwmLeYuEBApPxoa0I99o6Q9hJ1cfqK4
	 6VZAY61axQ9xvbj9oUL/4yILWFa04BZRwEFx0D8s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 046/780] crypto: xts - Only add ecb if it is not already there
Date: Tue, 17 Jun 2025 17:15:54 +0200
Message-ID: <20250617152453.372920174@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 31529c9ef08f8..46b7c70ea54bb 100644
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



