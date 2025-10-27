Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79AA1323406;
	Mon, 27 Oct 2025 18:49:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761590974; cv=none; b=j4bqFX9zfieMr49d4FeKJgjYfdCxChPbEUGX0egRSZXZ4YSCCjWePVjetg6C2Mc0nAI7Pj7Re3SZJSox7nUAtQdhfnKYYR1/BIhHDZ2wQQleQaJXT5OzgC2y56Q5Oa7ExLjbU3YnX2djxk3WHNFniLUEgylRxQHJgLs6QXx/p50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761590974; c=relaxed/simple;
	bh=wjccWS/jl69O7aU/DwxylxJJ8rXH0lFIRcSe+oEzTxI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kqsf5PCI7I7KiPPq3uzRlRfYaYyUjJZEGERXeJOBXz44eGVcRvNv9V33OJxltU/SpHhv84nx5M6d48IMNYcQKTvPh1PPmUPl3IZIOQbPt9/5cI+axGeZwaB54FjcnKkqpyi8okx8iHL6CsVCjoMKm97nVane9v6iIwEI3rymsms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V8bCXFfz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V8bCXFfz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B9A0C4CEF1;
	Mon, 27 Oct 2025 18:49:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761590972;
	bh=wjccWS/jl69O7aU/DwxylxJJ8rXH0lFIRcSe+oEzTxI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V8bCXFfzZbAyW1d4QOESStX+whenmhEx7J3gXsLiP6bCHiEhbs2gehOei78ApcG+9
	 YWbb85hzwuN5wgiC85AGAJxENxDzOyXkTNJ6DaT9h5Tjrrm/8PDdKr/70f1dOKIn9/
	 9qJP7oKwO19seUkNKHrjVLOFYqUiZHYdO+8msnmU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yiqi Sun <sunyiqixm@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.10 019/332] crypto: rng - Ensure set_ent is always present
Date: Mon, 27 Oct 2025 19:31:12 +0100
Message-ID: <20251027183525.129742209@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


