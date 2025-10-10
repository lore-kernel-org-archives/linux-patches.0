Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5BC42F25F6;
	Fri, 10 Oct 2025 13:23:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760102596; cv=none; b=EO/L5YcgQvQr0GeEacgNnijnthICrmI9ek4OCzLiI5L8G5o0cz5A0LHWk2jxZFrn8I0hipEQ7617Vx1c8ahd9H5mND9n3us9swkmgDKrZZDwnALJ+hi1Bl7GxHXBPT6lY3B44aMHDK9adLgvW+YLU8kCWpj5I9iooPtOS4X5RqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760102596; c=relaxed/simple;
	bh=cfMUmsU1SPRgp7ggXJ5Nnd0uUwV0Exsc31E+6HtUQ9Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mBPwuS9AwKnOGhX6Dbh4aT5begtpBjq7Ce3sAP10F1i6hUVqUx+VmO8u9stzik0yDbFloUgslusp3F7gxndD2p6NESe7svDjsjUrvdCTc/MGQ7wKMmTtcrPbKV+a5eKqZ0O9EhwqYfFQqUzmwq/FvcD5XaqPUZfzdEzfHYMv0bU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YuWZIuKt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YuWZIuKt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DC44C4CEF1;
	Fri, 10 Oct 2025 13:23:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760102596;
	bh=cfMUmsU1SPRgp7ggXJ5Nnd0uUwV0Exsc31E+6HtUQ9Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YuWZIuKt9iJlM5Uc2I8/pZ7dof4zZf08H+UklxW3SW8BUlgX43ego91ihQTC+t1Th
	 8gG/XRlGHkeaCDlN6PD3+H/qdPRR5Ok39KUZRXSU8IdwCDeyP3uymqDxZkIW/RLCel
	 wyv1/VuqFj+yGjDR6Nk2GQQYtIoreAwzrDkGSww0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yiqi Sun <sunyiqixm@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.6 26/28] crypto: rng - Ensure set_ent is always present
Date: Fri, 10 Oct 2025 15:16:44 +0200
Message-ID: <20251010131331.316945736@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251010131330.355311487@linuxfoundation.org>
References: <20251010131330.355311487@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -197,6 +197,11 @@ out:
 EXPORT_SYMBOL_GPL(crypto_del_default_rng);
 #endif
 
+static void rng_default_set_ent(struct crypto_rng *tfm, const u8 *data,
+				unsigned int len)
+{
+}
+
 int crypto_register_rng(struct rng_alg *alg)
 {
 	struct crypto_istat_rng *istat = rng_get_stat(alg);
@@ -212,6 +217,9 @@ int crypto_register_rng(struct rng_alg *
 	if (IS_ENABLED(CONFIG_CRYPTO_STATS))
 		memset(istat, 0, sizeof(*istat));
 
+	if (!alg->set_ent)
+		alg->set_ent = rng_default_set_ent;
+
 	return crypto_register_alg(base);
 }
 EXPORT_SYMBOL_GPL(crypto_register_rng);


