Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061104;
	b=MkvhzZYws4UiijX0g+eC/8gL5vqD905t8qCSe6K2ncSUFF9GCxszVUfTHNV7vTFbH1k/
	 8DDnE3TIzJicjDVj69keyE4ua2yCCvzgBsJEbDHVPabS/JyUWmTEgwuFiOm2jVgPV18VH
	 34jKmKCHIPirFuN6gNH9qwtk0kA18zrGMPrzt4mtgf4hdIxO0ahYJhaoQ324cqvUWt7n8
	 P7BjScRmQu/RRIJcZnq7H/T+ldJjXfDYR535gLxxyXZYmu/MYPS1YJdx2rFX282TY0o8N
	 F+pJIrPYw5JU6ms5F8MmXJg+7t+W8kalxZasrweNmHWmCMYG0aNa0U9aWOaHKGwALGw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061104;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TKqOcdCPpuuzZxQYZpZs9OT3gfgvkBPAdpdmo/ahm5g=;
	b=yL/SQaTy1ITMkHTplTgGtEFmxNVGG/1uTpI1r95JR2XmH0ovVKzSCZFFFNz/frufToU6
	 f7JYYOFqkU8eOtUT7zWfHlIFN0Yhnu1AKTwtOn6z5BAHGN1OGGchtVjDI059IKKOK3MWb
	 jtFXekMb/0Xnk0R/betp3pC/JeJfaHq+Nx+OzaqNuUHhgi8FYDXE0ir9EhC/H/A5pCbfv
	 6XhIwT1QUTkpkefwczhWpTYHcMQjiXQoambruEdIDpXoV+ZC8z0WbN1YgZYZCa+pq/rGQ
	 3/fmVOwVRB/6oEktKhzPgt/ndcZW1ZM039m6+AjEAFBdhI62Vdy6IzGPqEj0JMmP/QQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vCRpAPct;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56508606A325;
	Thu, 19 Nov 2026 04:05:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vCRpAPct
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EC3F1F000C4;
	Thu, 19 Nov 2026 04:05:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061104;
	bh=TKqOcdCPpuuzZxQYZpZs9OT3gfgvkBPAdpdmo/ahm5g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vCRpAPctCj51OIAHBFdH0MrrRN8T2SAYe6O6I2WbWt4yLVZhxuEFk1TpamjYKnB8w
	 szAAgbp1Lt64On50EBz6vFzho8O8UDlPab26ovEBI3gPo0r27fVWgeWk7dKSwBXJJC
	 OuCdvVjJwKPEnSxESPIREP61Q4XBYI3wavzqI2W4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	T Pratham <t-pratham@ti.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1435/1848] crypto: tcrypt - Avoid reading req->base after submission
Date: Wed, 18 Nov 2026 15:57:53 +0100
Message-ID: <20261118150019.577103944@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit 3a31a4baad6726bf974bcc58a6398f6a36d10aa0 ]

Once a request has been submitted to the Crypto API, the value
of req->base.data must not be read by the caller as it may change
while the request is processed.

Avoid reading it in tcrypt by combining the crypto_wait struct
with the request object into a tcrypt request object and pass that
around instead of the request object.

Reported-by: T Pratham <t-pratham@ti.com>
Fixes: beb63da739f7 ("crypto: tcrypt - Add speed tests for async hashing")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/tcrypt.c | 182 +++++++++++++++++++++++++++---------------------
 1 file changed, 101 insertions(+), 81 deletions(-)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 3e06b02ff4d78..00de1891392c8 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -53,6 +53,21 @@
  */
 #define get_driver_name(tfm_type, tfm) crypto_tfm_alg_driver_name(tfm_type ## _tfm(tfm))
 
+struct tcrypt_aead_request {
+	struct aead_request *req;
+	struct crypto_wait wait;
+};
+
+struct tcrypt_ahash_request {
+	struct ahash_request *req;
+	struct crypto_wait wait;
+};
+
+struct tcrypt_skcipher_request {
+	struct skcipher_request *req;
+	struct crypto_wait wait;
+};
+
 /*
  * Used by test_cipher_speed()
  */
@@ -137,18 +152,15 @@ static void sg_init_aead(struct scatterlist *sg, char *xbuf[XBUFSIZE],
 		sg_set_buf(&sg[k + 1], xbuf[k], rem);
 }
 
-static inline int do_one_aead_op(struct aead_request *req, int ret)
+static inline int do_one_aead_op(struct tcrypt_aead_request *req, int ret)
 {
-	struct crypto_wait *wait = req->base.data;
-
-	return crypto_wait_req(ret, wait);
+	return crypto_wait_req(ret, &req->wait);
 }
 
 struct test_mb_aead_data {
 	struct scatterlist sg[XBUFSIZE];
 	struct scatterlist sgout[XBUFSIZE];
-	struct aead_request *req;
-	struct crypto_wait wait;
+	struct tcrypt_aead_request req;
 	char *xbuf[XBUFSIZE];
 	char *xoutbuf[XBUFSIZE];
 	char *axbuf[XBUFSIZE];
@@ -162,14 +174,14 @@ static int do_mult_aead_op(struct test_mb_aead_data *data, int enc,
 	/* Fire up a bunch of concurrent requests */
 	for (i = 0; i < num_mb; i++) {
 		if (enc == ENCRYPT)
-			rc[i] = crypto_aead_encrypt(data[i].req);
+			rc[i] = crypto_aead_encrypt(data[i].req.req);
 		else
-			rc[i] = crypto_aead_decrypt(data[i].req);
+			rc[i] = crypto_aead_decrypt(data[i].req.req);
 	}
 
 	/* Wait for all requests to finish */
 	for (i = 0; i < num_mb; i++) {
-		rc[i] = crypto_wait_req(rc[i], &data[i].wait);
+		rc[i] = crypto_wait_req(rc[i], &data[i].req.wait);
 
 		if (rc[i]) {
 			pr_info("concurrent request %d error %d\n", i, rc[i]);
@@ -318,21 +330,21 @@ static void test_mb_aead_speed(const char *algo, int enc, int secs,
 		}
 
 	for (i = 0; i < num_mb; ++i) {
-		data[i].req = aead_request_alloc(tfm, GFP_KERNEL);
-		if (!data[i].req) {
+		data[i].req.req = aead_request_alloc(tfm, GFP_KERNEL);
+		if (!data[i].req.req) {
 			pr_err("alg: aead: Failed to allocate request for %s\n",
 			       algo);
 			while (i--)
-				aead_request_free(data[i].req);
+				aead_request_free(data[i].req.req);
 			goto out_free_xoutbuf;
 		}
 	}
 
 	for (i = 0; i < num_mb; ++i) {
-		crypto_init_wait(&data[i].wait);
-		aead_request_set_callback(data[i].req,
+		crypto_init_wait(&data[i].req.wait);
+		aead_request_set_callback(data[i].req.req,
 					  CRYPTO_TFM_REQ_MAY_BACKLOG,
-					  crypto_req_done, &data[i].wait);
+					  crypto_req_done, &data[i].req.wait);
 	}
 
 	pr_info("testing speed of multibuffer %s (%s) %s\n", algo,
@@ -394,16 +406,16 @@ static void test_mb_aead_speed(const char *algo, int enc, int secs,
 					     bs + (enc ? authsize : 0),
 					     assoc, aad_size);
 
-				aead_request_set_ad(cur->req, aad_size);
+				aead_request_set_ad(cur->req.req, aad_size);
 
 				if (!enc) {
 
-					aead_request_set_crypt(cur->req,
+					aead_request_set_crypt(cur->req.req,
 							       cur->sgout,
 							       cur->sg,
 							       bs, iv);
-					ret = crypto_aead_encrypt(cur->req);
-					ret = do_one_aead_op(cur->req, ret);
+					ret = crypto_aead_encrypt(cur->req.req);
+					ret = do_one_aead_op(&cur->req, ret);
 
 					if (ret) {
 						pr_err("calculating auth failed (%d)\n",
@@ -412,7 +424,7 @@ static void test_mb_aead_speed(const char *algo, int enc, int secs,
 					}
 				}
 
-				aead_request_set_crypt(cur->req, cur->sg,
+				aead_request_set_crypt(cur->req.req, cur->sg,
 						       cur->sgout, bs +
 						       (enc ? 0 : authsize),
 						       iv);
@@ -440,7 +452,7 @@ static void test_mb_aead_speed(const char *algo, int enc, int secs,
 
 out:
 	for (i = 0; i < num_mb; ++i)
-		aead_request_free(data[i].req);
+		aead_request_free(data[i].req.req);
 out_free_xoutbuf:
 	for (i = 0; i < num_mb; ++i)
 		testmgr_free_buf(data[i].xoutbuf);
@@ -458,9 +470,10 @@ static void test_mb_aead_speed(const char *algo, int enc, int secs,
 	kfree(iv);
 }
 
-static int test_aead_jiffies(struct aead_request *req, int enc,
+static int test_aead_jiffies(struct tcrypt_aead_request *treq, int enc,
 				int blen, int secs)
 {
+	struct aead_request *req = treq->req;
 	unsigned long start, end;
 	int bcount;
 	int ret;
@@ -468,9 +481,9 @@ static int test_aead_jiffies(struct aead_request *req, int enc,
 	for (start = jiffies, end = start + secs * HZ, bcount = 0;
 	     time_before(jiffies, end); bcount++) {
 		if (enc)
-			ret = do_one_aead_op(req, crypto_aead_encrypt(req));
+			ret = do_one_aead_op(treq, crypto_aead_encrypt(req));
 		else
-			ret = do_one_aead_op(req, crypto_aead_decrypt(req));
+			ret = do_one_aead_op(treq, crypto_aead_decrypt(req));
 
 		if (ret)
 			return ret;
@@ -481,8 +494,9 @@ static int test_aead_jiffies(struct aead_request *req, int enc,
 	return 0;
 }
 
-static int test_aead_cycles(struct aead_request *req, int enc, int blen)
+static int test_aead_cycles(struct tcrypt_aead_request *treq, int enc, int blen)
 {
+	struct aead_request *req = treq->req;
 	unsigned long cycles = 0;
 	int ret = 0;
 	int i;
@@ -490,9 +504,9 @@ static int test_aead_cycles(struct aead_request *req, int enc, int blen)
 	/* Warm-up run. */
 	for (i = 0; i < 4; i++) {
 		if (enc)
-			ret = do_one_aead_op(req, crypto_aead_encrypt(req));
+			ret = do_one_aead_op(treq, crypto_aead_encrypt(req));
 		else
-			ret = do_one_aead_op(req, crypto_aead_decrypt(req));
+			ret = do_one_aead_op(treq, crypto_aead_decrypt(req));
 
 		if (ret)
 			goto out;
@@ -504,9 +518,9 @@ static int test_aead_cycles(struct aead_request *req, int enc, int blen)
 
 		start = get_cycles();
 		if (enc)
-			ret = do_one_aead_op(req, crypto_aead_encrypt(req));
+			ret = do_one_aead_op(treq, crypto_aead_encrypt(req));
 		else
-			ret = do_one_aead_op(req, crypto_aead_decrypt(req));
+			ret = do_one_aead_op(treq, crypto_aead_decrypt(req));
 		end = get_cycles();
 
 		if (ret)
@@ -528,6 +542,7 @@ static void test_aead_speed(const char *algo, int enc, unsigned int secs,
 			    unsigned int tcount, u8 authsize,
 			    unsigned int aad_size, u8 *keysize)
 {
+	struct tcrypt_aead_request treq;
 	unsigned int i, j;
 	struct crypto_aead *tfm;
 	int ret = -ENOMEM;
@@ -543,7 +558,6 @@ static void test_aead_speed(const char *algo, int enc, unsigned int secs,
 	char *axbuf[XBUFSIZE];
 	const int *b_size;
 	unsigned int iv_len;
-	struct crypto_wait wait;
 
 	iv = kzalloc(MAX_IVLEN, GFP_KERNEL);
 	if (!iv)
@@ -585,7 +599,7 @@ static void test_aead_speed(const char *algo, int enc, unsigned int secs,
 		goto out_noreq;
 	}
 
-	crypto_init_wait(&wait);
+	crypto_init_wait(&treq.wait);
 	pr_info("testing speed of %s (%s) %s\n", algo,
 		get_driver_name(crypto_aead, tfm), e);
 
@@ -595,9 +609,10 @@ static void test_aead_speed(const char *algo, int enc, unsigned int secs,
 		       algo);
 		goto out_noreq;
 	}
+	treq.req = req;
 
 	aead_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
-				  crypto_req_done, &wait);
+				  crypto_req_done, &treq.wait);
 
 	i = 0;
 	do {
@@ -658,7 +673,7 @@ static void test_aead_speed(const char *algo, int enc, unsigned int secs,
 				 */
 				aead_request_set_crypt(req, sgout, sg,
 						       bs, iv);
-				ret = do_one_aead_op(req,
+				ret = do_one_aead_op(&treq,
 						     crypto_aead_encrypt(req));
 
 				if (ret) {
@@ -673,11 +688,11 @@ static void test_aead_speed(const char *algo, int enc, unsigned int secs,
 					       iv);
 
 			if (secs) {
-				ret = test_aead_jiffies(req, enc, bs,
+				ret = test_aead_jiffies(&treq, enc, bs,
 							secs);
 				cond_resched();
 			} else {
-				ret = test_aead_cycles(req, enc, bs);
+				ret = test_aead_cycles(&treq, enc, bs);
 			}
 
 			if (ret) {
@@ -717,23 +732,22 @@ static void test_hash_sg_init(struct scatterlist *sg)
 	}
 }
 
-static inline int do_one_ahash_op(struct ahash_request *req, int ret)
+static inline int do_one_ahash_op(struct tcrypt_ahash_request *treq, int ret)
 {
-	struct crypto_wait *wait = req->base.data;
-
-	return crypto_wait_req(ret, wait);
+	return crypto_wait_req(ret, &treq->wait);
 }
 
-static int test_ahash_jiffies_digest(struct ahash_request *req, int blen,
-				     char *out, int secs)
+static int test_ahash_jiffies_digest(struct tcrypt_ahash_request *treq,
+				     int blen, char *out, int secs)
 {
+	struct ahash_request *req = treq->req;
 	unsigned long start, end;
 	int bcount;
 	int ret;
 
 	for (start = jiffies, end = start + secs * HZ, bcount = 0;
 	     time_before(jiffies, end); bcount++) {
-		ret = do_one_ahash_op(req, crypto_ahash_digest(req));
+		ret = do_one_ahash_op(treq, crypto_ahash_digest(req));
 		if (ret)
 			return ret;
 	}
@@ -744,28 +758,29 @@ static int test_ahash_jiffies_digest(struct ahash_request *req, int blen,
 	return 0;
 }
 
-static int test_ahash_jiffies(struct ahash_request *req, int blen,
+static int test_ahash_jiffies(struct tcrypt_ahash_request *treq, int blen,
 			      int plen, char *out, int secs)
 {
+	struct ahash_request *req = treq->req;
 	unsigned long start, end;
 	int bcount, pcount;
 	int ret;
 
 	if (plen == blen)
-		return test_ahash_jiffies_digest(req, blen, out, secs);
+		return test_ahash_jiffies_digest(treq, blen, out, secs);
 
 	for (start = jiffies, end = start + secs * HZ, bcount = 0;
 	     time_before(jiffies, end); bcount++) {
-		ret = do_one_ahash_op(req, crypto_ahash_init(req));
+		ret = do_one_ahash_op(treq, crypto_ahash_init(req));
 		if (ret)
 			return ret;
 		for (pcount = 0; pcount < blen; pcount += plen) {
-			ret = do_one_ahash_op(req, crypto_ahash_update(req));
+			ret = do_one_ahash_op(treq, crypto_ahash_update(req));
 			if (ret)
 				return ret;
 		}
 		/* we assume there is enough space in 'out' for the result */
-		ret = do_one_ahash_op(req, crypto_ahash_final(req));
+		ret = do_one_ahash_op(treq, crypto_ahash_final(req));
 		if (ret)
 			return ret;
 	}
@@ -776,15 +791,16 @@ static int test_ahash_jiffies(struct ahash_request *req, int blen,
 	return 0;
 }
 
-static int test_ahash_cycles_digest(struct ahash_request *req, int blen,
-				    char *out)
+static int test_ahash_cycles_digest(struct tcrypt_ahash_request *treq,
+				    int blen, char *out)
 {
+	struct ahash_request *req = treq->req;
 	unsigned long cycles = 0;
 	int ret, i;
 
 	/* Warm-up run. */
 	for (i = 0; i < 4; i++) {
-		ret = do_one_ahash_op(req, crypto_ahash_digest(req));
+		ret = do_one_ahash_op(treq, crypto_ahash_digest(req));
 		if (ret)
 			goto out;
 	}
@@ -795,7 +811,7 @@ static int test_ahash_cycles_digest(struct ahash_request *req, int blen,
 
 		start = get_cycles();
 
-		ret = do_one_ahash_op(req, crypto_ahash_digest(req));
+		ret = do_one_ahash_op(treq, crypto_ahash_digest(req));
 		if (ret)
 			goto out;
 
@@ -814,26 +830,27 @@ static int test_ahash_cycles_digest(struct ahash_request *req, int blen,
 	return 0;
 }
 
-static int test_ahash_cycles(struct ahash_request *req, int blen,
+static int test_ahash_cycles(struct tcrypt_ahash_request *treq, int blen,
 			     int plen, char *out)
 {
+	struct ahash_request *req = treq->req;
 	unsigned long cycles = 0;
 	int i, pcount, ret;
 
 	if (plen == blen)
-		return test_ahash_cycles_digest(req, blen, out);
+		return test_ahash_cycles_digest(treq, blen, out);
 
 	/* Warm-up run. */
 	for (i = 0; i < 4; i++) {
-		ret = do_one_ahash_op(req, crypto_ahash_init(req));
+		ret = do_one_ahash_op(treq, crypto_ahash_init(req));
 		if (ret)
 			goto out;
 		for (pcount = 0; pcount < blen; pcount += plen) {
-			ret = do_one_ahash_op(req, crypto_ahash_update(req));
+			ret = do_one_ahash_op(treq, crypto_ahash_update(req));
 			if (ret)
 				goto out;
 		}
-		ret = do_one_ahash_op(req, crypto_ahash_final(req));
+		ret = do_one_ahash_op(treq, crypto_ahash_final(req));
 		if (ret)
 			goto out;
 	}
@@ -844,15 +861,15 @@ static int test_ahash_cycles(struct ahash_request *req, int blen,
 
 		start = get_cycles();
 
-		ret = do_one_ahash_op(req, crypto_ahash_init(req));
+		ret = do_one_ahash_op(treq, crypto_ahash_init(req));
 		if (ret)
 			goto out;
 		for (pcount = 0; pcount < blen; pcount += plen) {
-			ret = do_one_ahash_op(req, crypto_ahash_update(req));
+			ret = do_one_ahash_op(treq, crypto_ahash_update(req));
 			if (ret)
 				goto out;
 		}
-		ret = do_one_ahash_op(req, crypto_ahash_final(req));
+		ret = do_one_ahash_op(treq, crypto_ahash_final(req));
 		if (ret)
 			goto out;
 
@@ -875,7 +892,7 @@ static void test_ahash_speed_common(const char *algo, unsigned int secs,
 				    struct hash_speed *speed, unsigned mask)
 {
 	struct scatterlist sg[TVMEMSIZE];
-	struct crypto_wait wait;
+	struct tcrypt_ahash_request treq;
 	struct ahash_request *req;
 	struct crypto_ahash *tfm;
 	char *output;
@@ -904,9 +921,10 @@ static void test_ahash_speed_common(const char *algo, unsigned int secs,
 		goto out;
 	}
 
-	crypto_init_wait(&wait);
+	treq.req = req;
+	crypto_init_wait(&treq.wait);
 	ahash_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
-				   crypto_req_done, &wait);
+				   crypto_req_done, &treq.wait);
 
 	output = kmalloc(MAX_DIGEST_SIZE, GFP_KERNEL);
 	if (!output)
@@ -929,11 +947,11 @@ static void test_ahash_speed_common(const char *algo, unsigned int secs,
 		ahash_request_set_crypt(req, sg, output, speed[i].plen);
 
 		if (secs) {
-			ret = test_ahash_jiffies(req, speed[i].blen,
+			ret = test_ahash_jiffies(&treq, speed[i].blen,
 						 speed[i].plen, output, secs);
 			cond_resched();
 		} else {
-			ret = test_ahash_cycles(req, speed[i].blen,
+			ret = test_ahash_cycles(&treq, speed[i].blen,
 						speed[i].plen, output);
 		}
 
@@ -1220,16 +1238,16 @@ static void test_mb_skcipher_speed(const char *algo, int enc, int secs,
 	kfree(data);
 }
 
-static inline int do_one_acipher_op(struct skcipher_request *req, int ret)
+static inline int do_one_acipher_op(struct tcrypt_skcipher_request *req,
+				    int ret)
 {
-	struct crypto_wait *wait = req->base.data;
-
-	return crypto_wait_req(ret, wait);
+	return crypto_wait_req(ret, &req->wait);
 }
 
-static int test_acipher_jiffies(struct skcipher_request *req, int enc,
+static int test_acipher_jiffies(struct tcrypt_skcipher_request *treq, int enc,
 				int blen, int secs)
 {
+	struct skcipher_request *req = treq->req;
 	unsigned long start, end;
 	int bcount;
 	int ret;
@@ -1237,10 +1255,10 @@ static int test_acipher_jiffies(struct skcipher_request *req, int enc,
 	for (start = jiffies, end = start + secs * HZ, bcount = 0;
 	     time_before(jiffies, end); bcount++) {
 		if (enc)
-			ret = do_one_acipher_op(req,
+			ret = do_one_acipher_op(treq,
 						crypto_skcipher_encrypt(req));
 		else
-			ret = do_one_acipher_op(req,
+			ret = do_one_acipher_op(treq,
 						crypto_skcipher_decrypt(req));
 
 		if (ret)
@@ -1252,9 +1270,10 @@ static int test_acipher_jiffies(struct skcipher_request *req, int enc,
 	return 0;
 }
 
-static int test_acipher_cycles(struct skcipher_request *req, int enc,
+static int test_acipher_cycles(struct tcrypt_skcipher_request *treq, int enc,
 			       int blen)
 {
+	struct skcipher_request *req = treq->req;
 	unsigned long cycles = 0;
 	int ret = 0;
 	int i;
@@ -1262,10 +1281,10 @@ static int test_acipher_cycles(struct skcipher_request *req, int enc,
 	/* Warm-up run. */
 	for (i = 0; i < 4; i++) {
 		if (enc)
-			ret = do_one_acipher_op(req,
+			ret = do_one_acipher_op(treq,
 						crypto_skcipher_encrypt(req));
 		else
-			ret = do_one_acipher_op(req,
+			ret = do_one_acipher_op(treq,
 						crypto_skcipher_decrypt(req));
 
 		if (ret)
@@ -1278,10 +1297,10 @@ static int test_acipher_cycles(struct skcipher_request *req, int enc,
 
 		start = get_cycles();
 		if (enc)
-			ret = do_one_acipher_op(req,
+			ret = do_one_acipher_op(treq,
 						crypto_skcipher_encrypt(req));
 		else
-			ret = do_one_acipher_op(req,
+			ret = do_one_acipher_op(treq,
 						crypto_skcipher_decrypt(req));
 		end = get_cycles();
 
@@ -1303,8 +1322,8 @@ static void test_skcipher_speed(const char *algo, int enc, unsigned int secs,
 				struct cipher_speed_template *template,
 				unsigned int tcount, u8 *keysize, bool async)
 {
+	struct tcrypt_skcipher_request treq;
 	unsigned int ret, i, j, k, iv_len;
-	struct crypto_wait wait;
 	const char *key;
 	char iv[128];
 	struct skcipher_request *req;
@@ -1317,7 +1336,7 @@ static void test_skcipher_speed(const char *algo, int enc, unsigned int secs,
 	else
 		e = "decryption";
 
-	crypto_init_wait(&wait);
+	crypto_init_wait(&treq.wait);
 
 	tfm = crypto_alloc_skcipher(algo, 0, async ? 0 : CRYPTO_ALG_ASYNC);
 
@@ -1337,8 +1356,9 @@ static void test_skcipher_speed(const char *algo, int enc, unsigned int secs,
 		goto out;
 	}
 
+	treq.req = req;
 	skcipher_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
-				      crypto_req_done, &wait);
+				      crypto_req_done, &treq.wait);
 
 	i = 0;
 	do {
@@ -1405,11 +1425,11 @@ static void test_skcipher_speed(const char *algo, int enc, unsigned int secs,
 			skcipher_request_set_crypt(req, sg, sg, bs, iv);
 
 			if (secs) {
-				ret = test_acipher_jiffies(req, enc,
+				ret = test_acipher_jiffies(&treq, enc,
 							   bs, secs);
 				cond_resched();
 			} else {
-				ret = test_acipher_cycles(req, enc,
+				ret = test_acipher_cycles(&treq, enc,
 							  bs);
 			}
 
-- 
2.53.0



