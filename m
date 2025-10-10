Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 943EF2F3C04;
	Fri, 10 Oct 2025 13:18:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760102293; cv=none; b=fayvIURt24XsiVSB3QE651MwwecwALb3qTfFz2EIsip7oeivzxsc5wiUZ+4qs/8hpAkngMUpNNaqYeCZD62cn0xwGjFRqdvEhZObFSNhpUFKk3Ph8bIpSdjIhJufDYRAxZXUuaPzOv3WK6Ku1fpehC0fZyPxJcNepIfBfKeFTiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760102293; c=relaxed/simple;
	bh=WlZV3hOjuoFtyFcDhu6LeejVQzLj8+8S29wtpS0hnCE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hmuKB4GCFFNnbpDqmWIEWgyoiosYO9Y9qk4xskQRqu9zyzMhZ1uCbnlGmHbkax4lIuyyI9Pj/Hxs6KeD+/IVDBJMHZ+c0jVO+67gssC1BbuWRbkVRW/55KDFkx05xDgyd5m2V1wHwty7tzeBNhX10TE/bZuK9Wt3KBI7x//BEc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ogFAKDW5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ogFAKDW5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CE86C4CEF1;
	Fri, 10 Oct 2025 13:18:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760102293;
	bh=WlZV3hOjuoFtyFcDhu6LeejVQzLj8+8S29wtpS0hnCE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ogFAKDW52Oo+nQEsqvpdrWYCi68gKzXOyGyw5kEPREJxGLk/qIax/nV/ysSDR9D06
	 sYTluoarmHwkmzAM1goUfLWKuds40pUAGQdJPcSMGifAhr1zqlSqXgx78OjuFJdWLN
	 iFqVuYr7grroXHTB3KHuBlmNbbCJH/25oG19ksE0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yiqi Sun <sunyiqixm@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.17 22/26] crypto: rng - Ensure set_ent is always present
Date: Fri, 10 Oct 2025 15:16:17 +0200
Message-ID: <20251010131332.013571812@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251010131331.204964167@linuxfoundation.org>
References: <20251010131331.204964167@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
@@ -168,6 +168,11 @@ out:
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
@@ -179,6 +184,9 @@ int crypto_register_rng(struct rng_alg *
 	base->cra_flags &= ~CRYPTO_ALG_TYPE_MASK;
 	base->cra_flags |= CRYPTO_ALG_TYPE_RNG;
 
+	if (!alg->set_ent)
+		alg->set_ent = rng_default_set_ent;
+
 	return crypto_register_alg(base);
 }
 EXPORT_SYMBOL_GPL(crypto_register_rng);


