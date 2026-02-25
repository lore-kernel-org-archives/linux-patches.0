Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCDE42652A2;
	Wed, 25 Feb 2026 01:43:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983813; cv=none; b=gi4NZZzVD2T689bPXAufMjhTSSYXoan5m1gPRi7o0GEnyOxH6gQoOOY7Ig3Puiy0b5NEIyYIJe8L3nejEEnURM+GqWRQKManmNoSu7CIoBea5QK0s0Dqg7h37VSqPVXISJz8lWn28Grng51cXwAs9yRpQynYWLb2cwwLMCjgzYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983813; c=relaxed/simple;
	bh=GRR0DLwaLnYDQbCm4wtgVFUmLMMqoaq8QT8l2AumtrI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=USmsw5yDRVzqGyB/vCZzt489Rl2SGTuOcLUPXCWhnWIXneggrPuOa4xfeIeFLaOwyS9YECjMGsuAytGtSfxMO3z2w0HEPG4cIfV2I9c7GcbseX7aW61ciw9y10dvjvE/If1F4yHxJ6WdMLq1bkI0p64Uw0vgdfOq5NQrllewroc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O/83b+Yf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O/83b+Yf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B901C116D0;
	Wed, 25 Feb 2026 01:43:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983813;
	bh=GRR0DLwaLnYDQbCm4wtgVFUmLMMqoaq8QT8l2AumtrI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O/83b+YfWjKKma2RML3+I7Jpn48X3kIwiJwN0USlLbEVHudaitFNtr3RPUbnz9P6M
	 CRnnigUgtIbfX3APuotig6Q53mHNjvFcWJbZ80UqCopAOkkK3XR4/xEHnuYO2xmeoh
	 YDbP7i95NLiOlCTvtN7SbEgFuMVgbB5miv1pD5pg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksander Jan Bajkowski <olek2@wp.pl>,
	Antoine Tenart <atenart@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 098/641] crypto: inside-secure/eip93 - unregister only available algorithm
Date: Tue, 24 Feb 2026 17:17:04 -0800
Message-ID: <20260225012351.482317166@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aleksander Jan Bajkowski <olek2@wp.pl>

[ Upstream commit 0ceeadc7b53a041d89d5843f6bf0ccb7c98b0b4f ]

EIP93 has an options register. This register indicates which crypto
algorithms are implemented in silicon. Supported algorithms are
registered on this basis. Unregister algorithms on the same basis.
Currently, all algorithms are unregistered, even those not supported
by HW. This results in panic on platforms that don't have all options
implemented in silicon.

Fixes: 9739f5f93b78 ("crypto: eip93 - Add Inside Secure SafeXcel EIP-93 crypto engine support")
Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
Acked-by: Antoine Tenart <atenart@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../crypto/inside-secure/eip93/eip93-main.c   | 92 +++++++++++--------
 1 file changed, 53 insertions(+), 39 deletions(-)

diff --git a/drivers/crypto/inside-secure/eip93/eip93-main.c b/drivers/crypto/inside-secure/eip93/eip93-main.c
index 3cdc3308dcac8..b7fd9795062d4 100644
--- a/drivers/crypto/inside-secure/eip93/eip93-main.c
+++ b/drivers/crypto/inside-secure/eip93/eip93-main.c
@@ -77,11 +77,44 @@ inline void eip93_irq_clear(struct eip93_device *eip93, u32 mask)
 	__raw_writel(mask, eip93->base + EIP93_REG_INT_CLR);
 }
 
-static void eip93_unregister_algs(unsigned int i)
+static int eip93_algo_is_supported(u32 alg_flags, u32 supported_algo_flags)
+{
+	if ((IS_DES(alg_flags) || IS_3DES(alg_flags)) &&
+	    !(supported_algo_flags & EIP93_PE_OPTION_TDES))
+		return 0;
+
+	if (IS_AES(alg_flags) &&
+	    !(supported_algo_flags & EIP93_PE_OPTION_AES))
+		return 0;
+
+	if (IS_HASH_MD5(alg_flags) &&
+	    !(supported_algo_flags & EIP93_PE_OPTION_MD5))
+		return 0;
+
+	if (IS_HASH_SHA1(alg_flags) &&
+	    !(supported_algo_flags & EIP93_PE_OPTION_SHA_1))
+		return 0;
+
+	if (IS_HASH_SHA224(alg_flags) &&
+	    !(supported_algo_flags & EIP93_PE_OPTION_SHA_224))
+		return 0;
+
+	if (IS_HASH_SHA256(alg_flags) &&
+	    !(supported_algo_flags & EIP93_PE_OPTION_SHA_256))
+		return 0;
+
+	return 1;
+}
+
+static void eip93_unregister_algs(u32 supported_algo_flags, unsigned int i)
 {
 	unsigned int j;
 
 	for (j = 0; j < i; j++) {
+		if (!eip93_algo_is_supported(eip93_algs[j]->flags,
+					     supported_algo_flags))
+			continue;
+
 		switch (eip93_algs[j]->type) {
 		case EIP93_ALG_TYPE_SKCIPHER:
 			crypto_unregister_skcipher(&eip93_algs[j]->alg.skcipher);
@@ -106,49 +139,27 @@ static int eip93_register_algs(struct eip93_device *eip93, u32 supported_algo_fl
 
 		eip93_algs[i]->eip93 = eip93;
 
-		if ((IS_DES(alg_flags) || IS_3DES(alg_flags)) &&
-		    !(supported_algo_flags & EIP93_PE_OPTION_TDES))
+		if (!eip93_algo_is_supported(alg_flags, supported_algo_flags))
 			continue;
 
-		if (IS_AES(alg_flags)) {
-			if (!(supported_algo_flags & EIP93_PE_OPTION_AES))
-				continue;
+		if (IS_AES(alg_flags) && !IS_HMAC(alg_flags)) {
+			if (supported_algo_flags & EIP93_PE_OPTION_AES_KEY128)
+				eip93_algs[i]->alg.skcipher.max_keysize =
+					AES_KEYSIZE_128;
 
-			if (!IS_HMAC(alg_flags)) {
-				if (supported_algo_flags & EIP93_PE_OPTION_AES_KEY128)
-					eip93_algs[i]->alg.skcipher.max_keysize =
-						AES_KEYSIZE_128;
+			if (supported_algo_flags & EIP93_PE_OPTION_AES_KEY192)
+				eip93_algs[i]->alg.skcipher.max_keysize =
+					AES_KEYSIZE_192;
 
-				if (supported_algo_flags & EIP93_PE_OPTION_AES_KEY192)
-					eip93_algs[i]->alg.skcipher.max_keysize =
-						AES_KEYSIZE_192;
+			if (supported_algo_flags & EIP93_PE_OPTION_AES_KEY256)
+				eip93_algs[i]->alg.skcipher.max_keysize =
+					AES_KEYSIZE_256;
 
-				if (supported_algo_flags & EIP93_PE_OPTION_AES_KEY256)
-					eip93_algs[i]->alg.skcipher.max_keysize =
-						AES_KEYSIZE_256;
-
-				if (IS_RFC3686(alg_flags))
-					eip93_algs[i]->alg.skcipher.max_keysize +=
-						CTR_RFC3686_NONCE_SIZE;
-			}
+			if (IS_RFC3686(alg_flags))
+				eip93_algs[i]->alg.skcipher.max_keysize +=
+					CTR_RFC3686_NONCE_SIZE;
 		}
 
-		if (IS_HASH_MD5(alg_flags) &&
-		    !(supported_algo_flags & EIP93_PE_OPTION_MD5))
-			continue;
-
-		if (IS_HASH_SHA1(alg_flags) &&
-		    !(supported_algo_flags & EIP93_PE_OPTION_SHA_1))
-			continue;
-
-		if (IS_HASH_SHA224(alg_flags) &&
-		    !(supported_algo_flags & EIP93_PE_OPTION_SHA_224))
-			continue;
-
-		if (IS_HASH_SHA256(alg_flags) &&
-		    !(supported_algo_flags & EIP93_PE_OPTION_SHA_256))
-			continue;
-
 		switch (eip93_algs[i]->type) {
 		case EIP93_ALG_TYPE_SKCIPHER:
 			ret = crypto_register_skcipher(&eip93_algs[i]->alg.skcipher);
@@ -167,7 +178,7 @@ static int eip93_register_algs(struct eip93_device *eip93, u32 supported_algo_fl
 	return 0;
 
 fail:
-	eip93_unregister_algs(i);
+	eip93_unregister_algs(supported_algo_flags, i);
 
 	return ret;
 }
@@ -469,8 +480,11 @@ static int eip93_crypto_probe(struct platform_device *pdev)
 static void eip93_crypto_remove(struct platform_device *pdev)
 {
 	struct eip93_device *eip93 = platform_get_drvdata(pdev);
+	u32 algo_flags;
+
+	algo_flags = readl(eip93->base + EIP93_REG_PE_OPTION_1);
 
-	eip93_unregister_algs(ARRAY_SIZE(eip93_algs));
+	eip93_unregister_algs(algo_flags, ARRAY_SIZE(eip93_algs));
 	eip93_cleanup(eip93);
 }
 
-- 
2.51.0



