Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D625BA34;
	Mon, 13 Oct 2025 14:49:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760366966; cv=none; b=N0Biuxnrm2B/PPf8/xfvnfd6FXnzvkIYJCWYAZBJkyp74HXp20QzzdvqPzmUOxnQYuyqbJBDiuSrGKYap1gi3JwarNVjlJEJYkd8C1nzM211EtmqCGXwTE369h1MnKLtSEzW3qRRxok3sSfOxZwcnN5PDa4qRsx/UTgSMgWGJS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760366966; c=relaxed/simple;
	bh=9MP2UFQDCXthLq61ZVuyFXuFPspEypPPm8Z0SciwPpk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hV90k0k8wpAlv7tH6Z5cxGot3otALrwuzwLPYkIJErgnXF1jBfiyCcQ4q9Oy38biKtSPwMdo5FC0mUC8tshkWRH+yIdGlhV3+cputuiGAuoucqYyAEgsHcDxj1NQGJ/aX6axHKwDVCnhONoG954PB1bJ/nWTf5x13rtE0nu1/rs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y5UY/N1b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y5UY/N1b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03AEAC4CEE7;
	Mon, 13 Oct 2025 14:49:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760366966;
	bh=9MP2UFQDCXthLq61ZVuyFXuFPspEypPPm8Z0SciwPpk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y5UY/N1b7KphVlZCwqHD/nsS28oy5EfsCJoXqbBrQ5Du0KO/nC+1aqGCK15b6/a9W
	 nxw7OdSZ3CLDyCvRdsFUXfsCiBqTtRT/7kZCdkvVQiIgG7y6DEiCAUOnrEAA6OspIi
	 pXZ4PrND8fukBt8yk4zjWOAnI7t1pgmmq7Hlab7k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yiqi Sun <sunyiqixm@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.1 044/196] crypto: rng - Ensure set_ent is always present
Date: Mon, 13 Oct 2025 16:43:37 +0200
Message-ID: <20251013144316.179539539@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144314.549284796@linuxfoundation.org>
References: <20251013144314.549284796@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Herbert Xu <herbert@gondor.apana.org.au>

commit c0d36727bf39bb16ef0a67ed608e279535ebf0da upstream.

Ensure that set_ent is always set since only drbg provides it.

Fixes: 77ebdabe8de7 ("crypto: af_alg - add extra parameters for DRBG interface")
Reported-by: Yiqi Sun <sunyiqixm@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 crypto/rng.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/crypto/rng.c
+++ b/crypto/rng.c
@@ -174,6 +174,11 @@ out:
 EXPORT_SYMBOL_GPL(crypto_del_default_rng);
 #endif
 
+static void rng_default_set_ent(struct crypto_rng *tfm, const u8 *data,
+				unsigned int len)
+{
+}
+
 int crypto_register_rng(struct rng_alg *alg)
 {
 	struct crypto_alg *base = &alg->base;
@@ -185,6 +190,9 @@ int crypto_register_rng(struct rng_alg *
 	base->cra_flags &= ~CRYPTO_ALG_TYPE_MASK;
 	base->cra_flags |= CRYPTO_ALG_TYPE_RNG;
 
+	if (!alg->set_ent)
+		alg->set_ent = rng_default_set_ent;
+
 	return crypto_register_alg(base);
 }
 EXPORT_SYMBOL_GPL(crypto_register_rng);


