Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22BB52EF664;
	Fri, 10 Oct 2025 13:21:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760102491; cv=none; b=VGIKKRGUmRp0Dc6/O4eUXCz68zV4lrZM908b+sCUk6J3UKqXYQr99ruGU8ePVRn2YiAVP20q76QLmRvoSgTHvLZEKVpbuOq5631JVMP9ZbTKCaFMbdJW+qH/DV+HDUiV0ITDBNa+g5DQu7CUfbHO9L4tCRTgg/QW8dQuKYpMhCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760102491; c=relaxed/simple;
	bh=XmZZZ6MaQFx3KoKMPeBFbyYmv8bye6hnowMLNBct4vI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Prkui8QdPaPPFZ5IEDpFMB7k+7NojX4U95VqFKTGkboWpXviiBMTYHQDfC0lApL8C6u3IjgJqMsMQpEGUu/NBKLlRAF/W14ZejqPI2CrmNUuSsqSHiHSJkVIjK6P/IBJ5dYFUTx+AVeylvdT1hUtcNg798RaT6G8IbYr1vos6tU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t1BayIrh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t1BayIrh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54518C4CEF1;
	Fri, 10 Oct 2025 13:21:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760102490;
	bh=XmZZZ6MaQFx3KoKMPeBFbyYmv8bye6hnowMLNBct4vI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t1BayIrhzFIG4iaeJX0yNhE7RcR04jC2tsHMP3SmDRxcLnn8bu5O+TObwiyuAd9rI
	 +rApuxj2h2g5lO7kRkSwHBWrtrLCgh3fwxW5cKV9cAcH4aFNSyQ9Xt7ut4acAV9rrN
	 lNx6mh4LZtQGnH6s5yVD41dgLnGRrwdZhORAaMPU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yiqi Sun <sunyiqixm@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.12 33/35] crypto: rng - Ensure set_ent is always present
Date: Fri, 10 Oct 2025 15:16:35 +0200
Message-ID: <20251010131332.983104472@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251010131331.785281312@linuxfoundation.org>
References: <20251010131331.785281312@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -167,6 +167,11 @@ out:
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
@@ -178,6 +183,9 @@ int crypto_register_rng(struct rng_alg *
 	base->cra_flags &= ~CRYPTO_ALG_TYPE_MASK;
 	base->cra_flags |= CRYPTO_ALG_TYPE_RNG;
 
+	if (!alg->set_ent)
+		alg->set_ent = rng_default_set_ent;
+
 	return crypto_register_alg(base);
 }
 EXPORT_SYMBOL_GPL(crypto_register_rng);


