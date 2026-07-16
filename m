Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B9E1306754;
	Thu, 16 Jul 2026 14:13:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211231; cv=none; b=TkFUpnbC/2UOwRQvTd/CG9zY3HUDgKqituMlU5YZ4SuRQaTJfz2glDF7RfgR/9DQRdytsHmJ4Cx3VHxNFXwVP3V4ZDw5Sn+UkM2lSWGD4F2FIFOUiepe2MyCykF61QO+IQu2eneNqPrWw04RLFvD/ALta62vkYittAo42/4Xras=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211231; c=relaxed/simple;
	bh=2TRI90alg4uDN/gqZEZNglkANokwtHa+YpGf05uzq2Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YJDJdsT/7XndQYdoJqgml6c4i9eTi+NEVVIiqVUzRxUV+0QmMXkY+4xM6feFrEgbv0gNQJwmMKYzMg5WN2+zvRiAnMXHLFYWrd+WupoyqVyweIfvBuxtlYOFH+nCKE+43nTjShNvYzVH2RKvBJnX9iIHbThdJMxXkfJJJxXjkjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BgW8ZnLR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BgW8ZnLR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D852E1F000E9;
	Thu, 16 Jul 2026 14:13:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211230;
	bh=q6hsgc65Keli8kDu0QWKG40m1qTSNWCeHe65ta6eiSk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BgW8ZnLRm0P/UiSPC8aktvdd5AYXQq39d/k5yq6cv4EI3dM/GB8O74+M2ktGARpi5
	 ybci+j8Jyw+PNBiSsimkd/dVTC6aeVLw/KdKfAv3apts6hBi/cfEgPi0QigleGENuu
	 dSn6z1YRe3ponzk+nP/+jnLfE51Fs4YBTiYEbyXU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Yuan Tan <yuantan098@gmail.com>,
	Zhengchuan Liang <zcliangcn@gmail.com>,
	Xin Liu <bird@lzu.edu.cn>,
	Luxing Yin <tr0jan@lzu.edu.cn>,
	Xiaonan Zhao <ngochuongbui67@gmail.com>,
	Ren Wei <n05ec@lzu.edu.cn>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.18 349/480] crypto: chacha20poly1305 - validate poly1305 template argument
Date: Thu, 16 Jul 2026 15:31:36 +0200
Message-ID: <20260716133052.357269365@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

From: Xiaonan Zhao <ngochuongbui67@gmail.com>

commit 265b861bece38318b8e0fc8fac0643d4ef906d31 upstream.

chachapoly_create() still accepts the compatibility poly1305 parameter
in the template name, but it assumes the second template argument is
always present and immediately passes it to strcmp().

When the argument is missing, crypto_attr_alg_name() returns an error
pointer. Check for that before comparing the name so malformed template
instantiations fail with an error instead of dereferencing the error
pointer in strcmp().

This matches the surrounding Crypto API template pattern where
crypto_attr_alg_name() results are validated before string-specific use.

Fixes: a298765e28ad ("crypto: chacha20poly1305 - Use lib/crypto poly1305")
Cc: stable@kernel.org
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Zhengchuan Liang <zcliangcn@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Co-developed-by: Luxing Yin <tr0jan@lzu.edu.cn>
Signed-off-by: Luxing Yin <tr0jan@lzu.edu.cn>
Signed-off-by: Xiaonan Zhao <ngochuongbui67@gmail.com>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 crypto/chacha20poly1305.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/crypto/chacha20poly1305.c b/crypto/chacha20poly1305.c
index b4b5a7198d84..27df9e1eb058 100644
--- a/crypto/chacha20poly1305.c
+++ b/crypto/chacha20poly1305.c
@@ -375,6 +375,7 @@ static int chachapoly_create(struct crypto_template *tmpl, struct rtattr **tb,
 	struct aead_instance *inst;
 	struct chachapoly_instance_ctx *ctx;
 	struct skcipher_alg_common *chacha;
+	const char *poly_name;
 	int err;
 
 	if (ivsize > CHACHAPOLY_IV_SIZE)
@@ -396,9 +397,15 @@ static int chachapoly_create(struct crypto_template *tmpl, struct rtattr **tb,
 		goto err_free_inst;
 	chacha = crypto_spawn_skcipher_alg_common(&ctx->chacha);
 
+	poly_name = crypto_attr_alg_name(tb[2]);
+	if (IS_ERR(poly_name)) {
+		err = PTR_ERR(poly_name);
+		goto err_free_inst;
+	}
+
 	err = -EINVAL;
-	if (strcmp(crypto_attr_alg_name(tb[2]), "poly1305") &&
-	    strcmp(crypto_attr_alg_name(tb[2]), "poly1305-generic"))
+	if (strcmp(poly_name, "poly1305") &&
+	    strcmp(poly_name, "poly1305-generic"))
 		goto err_free_inst;
 	/* Need 16-byte IV size, including Initial Block Counter value */
 	if (chacha->ivsize != CHACHA_IV_SIZE)
-- 
2.55.0



