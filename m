Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3433519A288;
	Fri, 24 Apr 2026 13:40:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777038053; cv=none; b=epRYy7yJECmFGNRavAuqBQpV9+UL1bpPvLBEyTyHld8oXjvetUXBVOFpMM4nzI0lDYzcWgKUF+8VIIPjZ0wQd09P4cpy5PwEC3PuD4K3N0pxntQIvFFANhxFMk9xu7I2jpk2RNNiFylm6gyO0a/aO+Wj6TVrVbZh71oZCab6/w8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777038053; c=relaxed/simple;
	bh=Zm4s1oFs5kM+LBxhOu971tawV6Ow4haRwUQP4Za6vCI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TGl4SyLiOG7uSCHG2Gh1eUAzMjgh1TVU+arZ5N7Gawt8oQf+1S/uuGwd7y/VRVDC/W7y7cZAEHtWZUEBPH+MjZOBDjE5xl3hpXb+W6s/ovKvViPFc5TMWLHmrVDwVvjtPIgy4vu5VIP+j4f5WKZ/V9zesxAJs7qkJdoDipAv/OA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c8dzLj2x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c8dzLj2x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE4C4C19425;
	Fri, 24 Apr 2026 13:40:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777038053;
	bh=Zm4s1oFs5kM+LBxhOu971tawV6Ow4haRwUQP4Za6vCI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c8dzLj2x0IJ3UGfZURAvDxCfZGkV7gfskXzo6RNRsB8flia9qC4nkxosgwkQPkl+6
	 eY4lHQTN+cJYxVfQ4b1MGaUQ/WxesqU5piE3sQxop+klSgzDWlAeIBH+j5/qPiYFYg
	 oZqaTfz4EcOVCXcv8MGu2bYpkbz+KjHZj9CIKpxU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
Subject: [PATCH 6.6 161/166] crypto: testmgr - Hide ENOENT errors better
Date: Fri, 24 Apr 2026 15:31:15 +0200
Message-ID: <20260424132606.737126228@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424132532.812258529@linuxfoundation.org>
References: <20260424132532.812258529@linuxfoundation.org>
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

commit 6318fbe26e67f9c27a1917fe63936b0fc6000373 upstream.

The previous patch removed the ENOENT warning at the point of
allocation, but the overall self-test warning is still there.

Fix all of them by returning zero as the test result.  This is
safe because if the algorithm has gone away, then it cannot be
marked as tested.

Fixes: 4eded6d14f5b ("crypto: testmgr - Hide ENOENT errors")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 crypto/testmgr.c |   23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -1917,7 +1917,7 @@ static int __alg_test_hash(const struct
 	atfm = crypto_alloc_ahash(driver, type, mask);
 	if (IS_ERR(atfm)) {
 		if (PTR_ERR(atfm) == -ENOENT)
-			return -ENOENT;
+			return 0;
 		pr_err("alg: hash: failed to allocate transform for %s: %ld\n",
 		       driver, PTR_ERR(atfm));
 		return PTR_ERR(atfm);
@@ -2683,7 +2683,7 @@ static int alg_test_aead(const struct al
 	tfm = crypto_alloc_aead(driver, type, mask);
 	if (IS_ERR(tfm)) {
 		if (PTR_ERR(tfm) == -ENOENT)
-			return -ENOENT;
+			return 0;
 		pr_err("alg: aead: failed to allocate transform for %s: %ld\n",
 		       driver, PTR_ERR(tfm));
 		return PTR_ERR(tfm);
@@ -3262,7 +3262,7 @@ static int alg_test_skcipher(const struc
 	tfm = crypto_alloc_skcipher(driver, type, mask);
 	if (IS_ERR(tfm)) {
 		if (PTR_ERR(tfm) == -ENOENT)
-			return -ENOENT;
+			return 0;
 		pr_err("alg: skcipher: failed to allocate transform for %s: %ld\n",
 		       driver, PTR_ERR(tfm));
 		return PTR_ERR(tfm);
@@ -3677,7 +3677,7 @@ static int alg_test_cipher(const struct
 	tfm = crypto_alloc_cipher(driver, type, mask);
 	if (IS_ERR(tfm)) {
 		if (PTR_ERR(tfm) == -ENOENT)
-			return -ENOENT;
+			return 0;
 		printk(KERN_ERR "alg: cipher: Failed to load transform for "
 		       "%s: %ld\n", driver, PTR_ERR(tfm));
 		return PTR_ERR(tfm);
@@ -3703,7 +3703,7 @@ static int alg_test_comp(const struct al
 		acomp = crypto_alloc_acomp(driver, type, mask);
 		if (IS_ERR(acomp)) {
 			if (PTR_ERR(acomp) == -ENOENT)
-				return -ENOENT;
+				return 0;
 			pr_err("alg: acomp: Failed to load transform for %s: %ld\n",
 			       driver, PTR_ERR(acomp));
 			return PTR_ERR(acomp);
@@ -3717,7 +3717,7 @@ static int alg_test_comp(const struct al
 		comp = crypto_alloc_comp(driver, type, mask);
 		if (IS_ERR(comp)) {
 			if (PTR_ERR(comp) == -ENOENT)
-				return -ENOENT;
+				return 0;
 			pr_err("alg: comp: Failed to load transform for %s: %ld\n",
 			       driver, PTR_ERR(comp));
 			return PTR_ERR(comp);
@@ -3795,7 +3795,7 @@ static int alg_test_cprng(const struct a
 	rng = crypto_alloc_rng(driver, type, mask);
 	if (IS_ERR(rng)) {
 		if (PTR_ERR(rng) == -ENOENT)
-			return -ENOENT;
+			return 0;
 		printk(KERN_ERR "alg: cprng: Failed to load transform for %s: "
 		       "%ld\n", driver, PTR_ERR(rng));
 		return PTR_ERR(rng);
@@ -3823,12 +3823,11 @@ static int drbg_cavs_test(const struct d
 
 	drng = crypto_alloc_rng(driver, type, mask);
 	if (IS_ERR(drng)) {
+		kfree_sensitive(buf);
 		if (PTR_ERR(drng) == -ENOENT)
-			goto out_no_rng;
+			return 0;
 		printk(KERN_ERR "alg: drbg: could not allocate DRNG handle for "
 		       "%s\n", driver);
-out_no_rng:
-		kfree_sensitive(buf);
 		return PTR_ERR(drng);
 	}
 
@@ -4072,7 +4071,7 @@ static int alg_test_kpp(const struct alg
 	tfm = crypto_alloc_kpp(driver, type, mask);
 	if (IS_ERR(tfm)) {
 		if (PTR_ERR(tfm) == -ENOENT)
-			return -ENOENT;
+			return 0;
 		pr_err("alg: kpp: Failed to load tfm for %s: %ld\n",
 		       driver, PTR_ERR(tfm));
 		return PTR_ERR(tfm);
@@ -4302,7 +4301,7 @@ static int alg_test_akcipher(const struc
 	tfm = crypto_alloc_akcipher(driver, type, mask);
 	if (IS_ERR(tfm)) {
 		if (PTR_ERR(tfm) == -ENOENT)
-			return -ENOENT;
+			return 0;
 		pr_err("alg: akcipher: Failed to load tfm for %s: %ld\n",
 		       driver, PTR_ERR(tfm));
 		return PTR_ERR(tfm);


