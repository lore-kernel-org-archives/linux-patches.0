Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03478330B11;
	Fri, 17 Oct 2025 15:45:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715948; cv=none; b=LaqlNKtV1nVG70ae/ehnIAl7QtIIWhG7S6y0yH0VPnFVMOVcvmoQFBpz6oxA/H8iwqe/0SRgb4jHVUs9ho3akXcQKCyXi1VF7+3QBZYLqyld51Sf1EKN9pGRCZ2PouMED4MmkmfL48Q73XknCLEv0l4ZJR8sp4HBsavEh8CEKuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715948; c=relaxed/simple;
	bh=XMRetHSpKS/R1jWK1QRQZRzQOufJb4COPQ4mIMbcV/I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k/7EjB5YC3+V2cyBz5PI9Y3TFhMOE/zaOW9qKOELssZBkzSGlTUfoPWl0TSjf6nZFjA+5LhPinJwP59pBhH4OhPXa79FXOv8MnReCVWy/EmI2AMlsC25izrnVJhzJ7HUgu8R52NotKJPUEZ2TW5RbPCbs0T5lfM3cxVaC69mlSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AoF0VEZy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AoF0VEZy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79E50C4CEE7;
	Fri, 17 Oct 2025 15:45:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715947;
	bh=XMRetHSpKS/R1jWK1QRQZRzQOufJb4COPQ4mIMbcV/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AoF0VEZy4fnpMA3fpLmd6bwba1v0YRNamj/SWSp5Ob9APH48ev27GdNca3COY4Mh/
	 w6Q3snq2g/fzvlAgpKGCNeXZ0m2LFPxFNf8L3YXZ9wZXJwE7FdnlEFeVZ0roz+rSIr
	 VNU5Uaq0ykFslNgaJ1fmzqvGcblqI1lpra5rVjVY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yiqi Sun <sunyiqixm@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.15 020/276] crypto: rng - Ensure set_ent is always present
Date: Fri, 17 Oct 2025 16:51:53 +0200
Message-ID: <20251017145143.138615380@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145142.382145055@linuxfoundation.org>
References: <20251017145142.382145055@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


