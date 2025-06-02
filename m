Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39777224224;
	Mon,  2 Jun 2025 14:13:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873614; cv=none; b=VTauJQrUs0tZ1GMWuwehNOjgDfM9vYBkvn6IW5IPTLM1mhcMUJJLkRRpyZYYHGKNTZ7DvJea2nIjnCzAt5hPmrtdZV5RMpvadpuvatSvqiCVDC+P6NoSxInwoQt72xXFBbFb1JY4jaTeudc1k97FKCQVZd8aZijePoYy7j0uAig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873614; c=relaxed/simple;
	bh=2gxgZM+QAHTTb9GIz+yLMN07epCnNIqlqS4Yaeh+5fs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=On+oqkI+iKxzem2RIAj+N1fVolA5EIBCpZsPJlEmDaP/qAQBV8/AcI27dd4khWmKuZqS6NhC4ZoO7IitiIBQaWFJWMVqVRPisrPVsUAPyvMPIwQNPADyuz+aDhkKBGd6iiId+cleJ7nCirFlNVIP45x7LNjxNXY+XipU5a0dm/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2aOhyong; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2aOhyong"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A551C4CEEB;
	Mon,  2 Jun 2025 14:13:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873613;
	bh=2gxgZM+QAHTTb9GIz+yLMN07epCnNIqlqS4Yaeh+5fs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2aOhyongMW0/OJHHI2RFM2Nt4pMoJvBa0tFilNYz2sE9Oy4X+zFo05ne4nMFz+97u
	 aMAN+f9kqgawyxZzjT9lpkDKOP0T03pFxkkdng1gGsl4BxVY5v6pGEmMQGmrmOa32Y
	 jv2B4LMZO3Ikuyl1CBR4u+uzw8VufwFJrlY0weFQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 196/444] crypto: ahash - Set default reqsize from ahash_alg
Date: Mon,  2 Jun 2025 15:44:20 +0200
Message-ID: <20250602134348.861372645@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
User-Agent: quilt/0.68
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

[ Upstream commit 9e01aaa1033d6e40f8d7cf4f20931a61ce9e3f04 ]

Add a reqsize field to struct ahash_alg and use it to set the
default reqsize so that algorithms with a static reqsize are
not forced to create an init_tfm function.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/ahash.c        | 4 ++++
 include/crypto/hash.h | 3 +++
 2 files changed, 7 insertions(+)

diff --git a/crypto/ahash.c b/crypto/ahash.c
index 709ef09407991..6168f3532f552 100644
--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -427,6 +427,7 @@ static int crypto_ahash_init_tfm(struct crypto_tfm *tfm)
 	hash->setkey = ahash_nosetkey;
 
 	crypto_ahash_set_statesize(hash, alg->halg.statesize);
+	crypto_ahash_set_reqsize(hash, alg->reqsize);
 
 	if (tfm->__crt_alg->cra_type != &crypto_ahash_type)
 		return crypto_init_shash_ops_async(tfm);
@@ -599,6 +600,9 @@ static int ahash_prepare_alg(struct ahash_alg *alg)
 	if (alg->halg.statesize == 0)
 		return -EINVAL;
 
+	if (alg->reqsize && alg->reqsize < alg->halg.statesize)
+		return -EINVAL;
+
 	err = hash_prepare_alg(&alg->halg);
 	if (err)
 		return err;
diff --git a/include/crypto/hash.h b/include/crypto/hash.h
index f7c2a22cd776d..c0d472fdc82e6 100644
--- a/include/crypto/hash.h
+++ b/include/crypto/hash.h
@@ -153,6 +153,7 @@ struct ahash_request {
  *	      This is a counterpart to @init_tfm, used to remove
  *	      various changes set in @init_tfm.
  * @clone_tfm: Copy transform into new object, may allocate memory.
+ * @reqsize: Size of the request context.
  * @halg: see struct hash_alg_common
  */
 struct ahash_alg {
@@ -169,6 +170,8 @@ struct ahash_alg {
 	void (*exit_tfm)(struct crypto_ahash *tfm);
 	int (*clone_tfm)(struct crypto_ahash *dst, struct crypto_ahash *src);
 
+	unsigned int reqsize;
+
 	struct hash_alg_common halg;
 };
 
-- 
2.39.5



