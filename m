Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58CD82F6195;
	Fri, 10 Oct 2025 13:19:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760102385; cv=none; b=ZzuVjbdS6KDwcPy0dEVA3eamGg/z3gZTGhGdYFx+NOSLMA478zvU0T8xh1x4axFfv6G0+SpdsVg4JoXnKFM4nBasyj+fZGfAeeE0d42N9mldUZwuFKYYDWjMjLKd8OoWPiCSEB5KdAp3O5f2fTssQGl8n9PaV5lWzIX9RopDu7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760102385; c=relaxed/simple;
	bh=XTwHw2Vj81Jtw2IOFsjk2/ndAQc76Vyv/6JibAC/YPo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rMrhy6G6COF5jawA2/BPRPAiLnaDkRYBHtImPgGE3zwug4nly/OGDzdWbUQDlxKIWud9r6sAuCgMhJKdiV4cl1Zq+VyMf50w1HooNPRqd9gCcftK8aE58rBtbd9rrFxMY9qm+aKs0E00hGEV/IrgJ8kH4Msde7XMxdGJDJq3JOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jukldjWH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jukldjWH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD4B0C4CEF1;
	Fri, 10 Oct 2025 13:19:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760102385;
	bh=XTwHw2Vj81Jtw2IOFsjk2/ndAQc76Vyv/6JibAC/YPo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jukldjWHesy5RZZGpqAH/smTEaN4AK8FBuhrOibOHUW0Yw6Zg9T53Pp8CkknAlt6j
	 T+MpkDBaQxzeFXSO9kqNzGtOFmodnR+imRmVIGlU5Q0Z2kbb2JqrJP22UTqzE6DEUI
	 BoHXUCzLj/oirNbefvZhJ3gNh4TbD7ytP2M4OiIQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yiqi Sun <sunyiqixm@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.16 38/41] crypto: rng - Ensure set_ent is always present
Date: Fri, 10 Oct 2025 15:16:26 +0200
Message-ID: <20251010131334.787013815@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251010131333.420766773@linuxfoundation.org>
References: <20251010131333.420766773@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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


