Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ED1A3B38AE;
	Fri, 24 Apr 2026 13:40:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777038050; cv=none; b=rJyqrAMo82woE+IKNhriSWj96ra4pRUh7JzAnaiEU8i89hp0rfUrnNxTq/TqFmxeZv7zi3RYO6Wa1uvYM14Mv+6qntIynZXkV/b59sRP1GaViV4FaVzz1iCQ99puyvrLvQAJxm5iguD9KjzmJSepPZOV4Tf1T1MivMkRyA38mQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777038050; c=relaxed/simple;
	bh=sLpiuWJAvF+F5pjrqiFGvJVH+b6UPCbeTWvJ/C8BV8g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CbOaOJ5p6LvlVyhAFnr9vDRJPu4UP5GVrGqhyd6ePXLUg44U3WOcQVYicV5cRGR0C6NqCj6Fn2Uwlv2RFbjnHQ+DN8x9y7+aTjzxzqvfZ82rSqv3M3dnM12IbbQfLb0FIOVF2sDiyfTIy7TB0RjARki3SC+untbYG37BWvAMUl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1d/mMbyE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1d/mMbyE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34230C19425;
	Fri, 24 Apr 2026 13:40:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777038050;
	bh=sLpiuWJAvF+F5pjrqiFGvJVH+b6UPCbeTWvJ/C8BV8g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1d/mMbyEHT2d23KU9V3y5B5dBi99OO0i40uAIPC3yw2hYWP2Ri1PPyccSCLnagc5Y
	 oFR2CFtZD9VlTuURM1walHj4qL+QGhmVy74Qh2dIjiXSc5Tim9vgLHoGxfP4G2haWr
	 mrCd7PBtnbVMEu1MIrp9vPAAE2dsI0nIs09gOYC8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
Subject: [PATCH 6.6 160/166] crypto: testmgr - Hide ENOENT errors
Date: Fri, 24 Apr 2026 15:31:14 +0200
Message-ID: <20260424132606.533695847@linuxfoundation.org>
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

commit 4eded6d14f5b7bb857b68872970a40cf3105c015 upstream.

When a crypto algorithm with a higher priority is registered, it
kills the spawns of all lower-priority algorithms.  Thus it is to
be expected for an algorithm to go away at any time, even during
a self-test.  This is now much more common with asynchronous testing.

Remove the printk when an ENOENT is encountered during a self-test.
This is not really an error since the algorithm being tested is no
longer there (i.e., it didn't fail the test which is what we care
about).

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 crypto/testmgr.c |   23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -1916,6 +1916,8 @@ static int __alg_test_hash(const struct
 
 	atfm = crypto_alloc_ahash(driver, type, mask);
 	if (IS_ERR(atfm)) {
+		if (PTR_ERR(atfm) == -ENOENT)
+			return -ENOENT;
 		pr_err("alg: hash: failed to allocate transform for %s: %ld\n",
 		       driver, PTR_ERR(atfm));
 		return PTR_ERR(atfm);
@@ -2680,6 +2682,8 @@ static int alg_test_aead(const struct al
 
 	tfm = crypto_alloc_aead(driver, type, mask);
 	if (IS_ERR(tfm)) {
+		if (PTR_ERR(tfm) == -ENOENT)
+			return -ENOENT;
 		pr_err("alg: aead: failed to allocate transform for %s: %ld\n",
 		       driver, PTR_ERR(tfm));
 		return PTR_ERR(tfm);
@@ -3257,6 +3261,8 @@ static int alg_test_skcipher(const struc
 
 	tfm = crypto_alloc_skcipher(driver, type, mask);
 	if (IS_ERR(tfm)) {
+		if (PTR_ERR(tfm) == -ENOENT)
+			return -ENOENT;
 		pr_err("alg: skcipher: failed to allocate transform for %s: %ld\n",
 		       driver, PTR_ERR(tfm));
 		return PTR_ERR(tfm);
@@ -3670,6 +3676,8 @@ static int alg_test_cipher(const struct
 
 	tfm = crypto_alloc_cipher(driver, type, mask);
 	if (IS_ERR(tfm)) {
+		if (PTR_ERR(tfm) == -ENOENT)
+			return -ENOENT;
 		printk(KERN_ERR "alg: cipher: Failed to load transform for "
 		       "%s: %ld\n", driver, PTR_ERR(tfm));
 		return PTR_ERR(tfm);
@@ -3694,6 +3702,8 @@ static int alg_test_comp(const struct al
 	if (algo_type == CRYPTO_ALG_TYPE_ACOMPRESS) {
 		acomp = crypto_alloc_acomp(driver, type, mask);
 		if (IS_ERR(acomp)) {
+			if (PTR_ERR(acomp) == -ENOENT)
+				return -ENOENT;
 			pr_err("alg: acomp: Failed to load transform for %s: %ld\n",
 			       driver, PTR_ERR(acomp));
 			return PTR_ERR(acomp);
@@ -3706,6 +3716,8 @@ static int alg_test_comp(const struct al
 	} else {
 		comp = crypto_alloc_comp(driver, type, mask);
 		if (IS_ERR(comp)) {
+			if (PTR_ERR(comp) == -ENOENT)
+				return -ENOENT;
 			pr_err("alg: comp: Failed to load transform for %s: %ld\n",
 			       driver, PTR_ERR(comp));
 			return PTR_ERR(comp);
@@ -3782,6 +3794,8 @@ static int alg_test_cprng(const struct a
 
 	rng = crypto_alloc_rng(driver, type, mask);
 	if (IS_ERR(rng)) {
+		if (PTR_ERR(rng) == -ENOENT)
+			return -ENOENT;
 		printk(KERN_ERR "alg: cprng: Failed to load transform for %s: "
 		       "%ld\n", driver, PTR_ERR(rng));
 		return PTR_ERR(rng);
@@ -3809,10 +3823,13 @@ static int drbg_cavs_test(const struct d
 
 	drng = crypto_alloc_rng(driver, type, mask);
 	if (IS_ERR(drng)) {
+		if (PTR_ERR(drng) == -ENOENT)
+			goto out_no_rng;
 		printk(KERN_ERR "alg: drbg: could not allocate DRNG handle for "
 		       "%s\n", driver);
+out_no_rng:
 		kfree_sensitive(buf);
-		return -ENOMEM;
+		return PTR_ERR(drng);
 	}
 
 	test_data.testentropy = &testentropy;
@@ -4054,6 +4071,8 @@ static int alg_test_kpp(const struct alg
 
 	tfm = crypto_alloc_kpp(driver, type, mask);
 	if (IS_ERR(tfm)) {
+		if (PTR_ERR(tfm) == -ENOENT)
+			return -ENOENT;
 		pr_err("alg: kpp: Failed to load tfm for %s: %ld\n",
 		       driver, PTR_ERR(tfm));
 		return PTR_ERR(tfm);
@@ -4282,6 +4301,8 @@ static int alg_test_akcipher(const struc
 
 	tfm = crypto_alloc_akcipher(driver, type, mask);
 	if (IS_ERR(tfm)) {
+		if (PTR_ERR(tfm) == -ENOENT)
+			return -ENOENT;
 		pr_err("alg: akcipher: Failed to load tfm for %s: %ld\n",
 		       driver, PTR_ERR(tfm));
 		return PTR_ERR(tfm);


