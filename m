Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 172F9424D5C;
	Thu, 16 Jul 2026 13:51:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209903; cv=none; b=RA0KJV3fiq81WlP/3O25DvZigXfdCkON5sAtdqIkBYoATyVv3Q2mTse8QFsr4bd68KI9Pq2rIVmHkkpRaXQfWnSU1rKszjMqM/kVb8IlGAvjYFTp2Sgv6elqzLtFPrqx1Wx6qRh/FKu8Q0HO05zK9S7l5AUee/+B6XZ+A3QLk+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209903; c=relaxed/simple;
	bh=fH6aw6uLu4lHSR/csZkBMCxgYz0Dc5Je8FblBxAEbQc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z2jwk6rz494MflfKTWrVDj6G1l74k+zCfXo9aKrBYUqKIG0b6T5pQ3/W7cPNiourwmn2dlW9dVkUKU4JOetcYw9023+jQLL7wC4SCjhOe3aHeKXpJ/Th4uMd07etTShRgG6DwSDpQuuf7rQUThXLqIlO8IivbzW5nhBt9dYuKuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IU5DEoQI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IU5DEoQI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82B351F000E9;
	Thu, 16 Jul 2026 13:51:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209902;
	bh=xKqV/Q9r/ag9amgBMDKCeKzOqNkMgztRjmj/uH0bynE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IU5DEoQIU9YkqZu8PXiAQdAtscF4SHXu+WkrGQrdrhFSNAuzQ6jxgh3hcPgXBIr14
	 Hi83z1OUxtxPhwXtTdDas27bnDG9rP+mhCt0K8/upktI7mN2t+vyoAemY5NGdSz2ED
	 1XTbdMtS98m9xIzdwAeIzRaBeVtYRtTsjtwC9Ojk=
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
Subject: [PATCH 7.1 363/518] crypto: chacha20poly1305 - validate poly1305 template argument
Date: Thu, 16 Jul 2026 15:30:31 +0200
Message-ID: <20260716133055.773350569@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
 crypto/chacha20poly1305.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/crypto/chacha20poly1305.c
+++ b/crypto/chacha20poly1305.c
@@ -375,6 +375,7 @@ static int chachapoly_create(struct cryp
 	struct aead_instance *inst;
 	struct chachapoly_instance_ctx *ctx;
 	struct skcipher_alg_common *chacha;
+	const char *poly_name;
 	int err;
 
 	if (ivsize > CHACHAPOLY_IV_SIZE)
@@ -396,9 +397,15 @@ static int chachapoly_create(struct cryp
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


