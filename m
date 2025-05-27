Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D441A154C15;
	Tue, 27 May 2025 17:00:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365226; cv=none; b=Bln+QT1H05xYsBrWNtXaqbrplcDjSrACncLotc8ysKbMyANUmNFUTAusufjUz+7dQOS+CWGCfpfcEoYM6bcFPB3/AXWDOdxfNkkr7gU3wP1eMVVVactYAoBECix2m0umMGpQJEWSC3d73JqToVGdwtcFp/9Vp1ac3KaFFlOvf8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365226; c=relaxed/simple;
	bh=DlkO285FWLfCJbFFXoxXovPgUjSGLco3YgHB2QYvb8c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I1jGoSoCKU7PnHvrsZ+ERM8vlHjuGBA2szUWIk4uAJLHHoH02yT/NkbPLRpMhSrfBptK4OQMnu0w8kx6vPyljPu36saPgE5VUDoKpjmdXY/ta+LmoGYHnvNh6x+vjDu5RhbQmIMmgVM1Rkm9VFEPSc8DfqteAhn8EBCkUnsmv4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nhIdpNq5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nhIdpNq5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AF98C4CEE9;
	Tue, 27 May 2025 17:00:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365226;
	bh=DlkO285FWLfCJbFFXoxXovPgUjSGLco3YgHB2QYvb8c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nhIdpNq5rXOTuc5BjkRRug3Q0E8B1dOVcpXW1KHg4apAfG+OM6FPCZ27Yvmb/1vjY
	 OEdAzqJNAkxuJHy+UT6dzsuzEkPpzUNkok2+hUn6nffSiBZlLLJfA9CBXe876e5p6V
	 5y2JWMDHM+uG1245jwDrZbL6/fTTwURF6mcyTv1U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 306/626] crypto: ahash - Set default reqsize from ahash_alg
Date: Tue, 27 May 2025 18:23:19 +0200
Message-ID: <20250527162457.467926937@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index bcd9de009a91b..fe19bf7f15eb9 100644
--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -473,6 +473,7 @@ static int crypto_ahash_init_tfm(struct crypto_tfm *tfm)
 	struct ahash_alg *alg = crypto_ahash_alg(hash);
 
 	crypto_ahash_set_statesize(hash, alg->halg.statesize);
+	crypto_ahash_set_reqsize(hash, alg->reqsize);
 
 	if (tfm->__crt_alg->cra_type == &crypto_shash_type)
 		return crypto_init_ahash_using_shash(tfm);
@@ -638,6 +639,9 @@ static int ahash_prepare_alg(struct ahash_alg *alg)
 	if (alg->halg.statesize == 0)
 		return -EINVAL;
 
+	if (alg->reqsize && alg->reqsize < alg->halg.statesize)
+		return -EINVAL;
+
 	err = hash_prepare_alg(&alg->halg);
 	if (err)
 		return err;
diff --git a/include/crypto/hash.h b/include/crypto/hash.h
index 2d5ea9f9ff43e..6692253f0b5be 100644
--- a/include/crypto/hash.h
+++ b/include/crypto/hash.h
@@ -132,6 +132,7 @@ struct ahash_request {
  *	      This is a counterpart to @init_tfm, used to remove
  *	      various changes set in @init_tfm.
  * @clone_tfm: Copy transform into new object, may allocate memory.
+ * @reqsize: Size of the request context.
  * @halg: see struct hash_alg_common
  */
 struct ahash_alg {
@@ -148,6 +149,8 @@ struct ahash_alg {
 	void (*exit_tfm)(struct crypto_ahash *tfm);
 	int (*clone_tfm)(struct crypto_ahash *dst, struct crypto_ahash *src);
 
+	unsigned int reqsize;
+
 	struct hash_alg_common halg;
 };
 
-- 
2.39.5



