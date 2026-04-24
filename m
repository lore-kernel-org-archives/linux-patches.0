Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5AFB3D5241;
	Fri, 24 Apr 2026 13:41:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777038104; cv=none; b=SnPCMmyribVF1rwzbncCMU9dQMUGxL4oMybriOfXETyo146b6eyjBq3xlXzCaN4LHJJEb2hIJ94yxlP50FABjis3FggRsrM3uHkwOVQfNLC8YZLwtcK2IxBBsRVh3cIWzLaSZoYDX5Vr5KUdh5wOxwg3ksJ94HIY4CKNHK1g2nI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777038104; c=relaxed/simple;
	bh=Lr+OATWeFRSb8My23oPOw/pzPPi14kJAaMDIXygqvKE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rKrUPKtRCaSRMR1E7aWqChSc3mePhf1Z+sLJGV7gdKqwTOwb1ZGINQzZ4m4CtGjL6g4ywrKRHqjOEKAm1fJFquulDaxxQ60yL7fSCzJUG/CcX2AvHvUUjuYs2KK6P4Vg/kdY4lxzjSltjE/sPEjZ59OhFO0fx1KVe6DuFoH7Mf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZtyeWIus; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZtyeWIus"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ACC3C19425;
	Fri, 24 Apr 2026 13:41:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777038104;
	bh=Lr+OATWeFRSb8My23oPOw/pzPPi14kJAaMDIXygqvKE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZtyeWIusvnoDXE++ImcJX+qq6SKbJ47BkZtmgmRlDTGLj9EoUqjVAOuuHfAwl9une
	 mZzesP+OBinxmgDVxTgOePKgdrLlJHaGUwAhdAeeQJr9g0ukrSJjMWwTdGhkxmC2b9
	 JFvZHdV829BfCDfCJQsOf9Nwj1OrwUjU1Osj1a5I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dudu Lu <phx0fer@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.18 06/55] crypto: krb5enc - fix async decrypt skipping hash verification
Date: Fri, 24 Apr 2026 15:30:45 +0200
Message-ID: <20260424132431.360107783@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424132430.006424517@linuxfoundation.org>
References: <20260424132430.006424517@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dudu Lu <phx0fer@gmail.com>

commit 3bfbf5f0a99c991769ec562721285df7ab69240b upstream.

krb5enc_dispatch_decrypt() sets req->base.complete as the skcipher
callback, which is the caller's own completion handler. When the
skcipher completes asynchronously, this signals "done" to the caller
without executing krb5enc_dispatch_decrypt_hash(), completely bypassing
the integrity verification (hash check).

Compare with the encrypt path which correctly uses
krb5enc_encrypt_done as an intermediate callback to chain into the
hash computation on async completion.

Fix by adding krb5enc_decrypt_done as an intermediate callback that
chains into krb5enc_dispatch_decrypt_hash() upon async skcipher
completion, matching the encrypt path's callback pattern.

Also fix EBUSY/EINPROGRESS handling throughout: remove
krb5enc_request_complete() which incorrectly swallowed EINPROGRESS
notifications that must be passed up to callers waiting on backlogged
requests, and add missing EBUSY checks in krb5enc_encrypt_ahash_done
for the dispatch_encrypt return value.

Fixes: d1775a177f7f ("crypto: Add 'krb5enc' hash and cipher AEAD algorithm")
Signed-off-by: Dudu Lu <phx0fer@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Unset MAY_BACKLOG on the async completion path so the user won't
see back-to-back EINPROGRESS notifications.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/krb5enc.c |   52 +++++++++++++++++++++++++++++++---------------------
 1 file changed, 31 insertions(+), 21 deletions(-)

--- a/crypto/krb5enc.c
+++ b/crypto/krb5enc.c
@@ -39,12 +39,6 @@ struct krb5enc_request_ctx {
 	char tail[];
 };
 
-static void krb5enc_request_complete(struct aead_request *req, int err)
-{
-	if (err != -EINPROGRESS)
-		aead_request_complete(req, err);
-}
-
 /**
  * crypto_krb5enc_extractkeys - Extract Ke and Ki keys from the key blob.
  * @keys: Where to put the key sizes and pointers
@@ -127,7 +121,7 @@ static void krb5enc_encrypt_done(void *d
 {
 	struct aead_request *req = data;
 
-	krb5enc_request_complete(req, err);
+	aead_request_complete(req, err);
 }
 
 /*
@@ -188,14 +182,16 @@ static void krb5enc_encrypt_ahash_done(v
 	struct ahash_request *ahreq = (void *)(areq_ctx->tail + ictx->reqoff);
 
 	if (err)
-		return krb5enc_request_complete(req, err);
+		goto out;
 
 	krb5enc_insert_checksum(req, ahreq->result);
 
-	err = krb5enc_dispatch_encrypt(req,
-				       aead_request_flags(req) & ~CRYPTO_TFM_REQ_MAY_SLEEP);
-	if (err != -EINPROGRESS)
-		aead_request_complete(req, err);
+	err = krb5enc_dispatch_encrypt(req, 0);
+	if (err == -EINPROGRESS)
+		return;
+
+out:
+	aead_request_complete(req, err);
 }
 
 /*
@@ -265,17 +261,16 @@ static void krb5enc_decrypt_hash_done(vo
 {
 	struct aead_request *req = data;
 
-	if (err)
-		return krb5enc_request_complete(req, err);
-
-	err = krb5enc_verify_hash(req);
-	krb5enc_request_complete(req, err);
+	if (!err)
+		err = krb5enc_verify_hash(req);
+	aead_request_complete(req, err);
 }
 
 /*
  * Dispatch the hashing of the plaintext after we've done the decryption.
  */
-static int krb5enc_dispatch_decrypt_hash(struct aead_request *req)
+static int krb5enc_dispatch_decrypt_hash(struct aead_request *req,
+					 unsigned int flags)
 {
 	struct crypto_aead *krb5enc = crypto_aead_reqtfm(req);
 	struct aead_instance *inst = aead_alg_instance(krb5enc);
@@ -291,7 +286,7 @@ static int krb5enc_dispatch_decrypt_hash
 	ahash_request_set_tfm(ahreq, auth);
 	ahash_request_set_crypt(ahreq, req->dst, hash,
 				req->assoclen + req->cryptlen - authsize);
-	ahash_request_set_callback(ahreq, aead_request_flags(req),
+	ahash_request_set_callback(ahreq, flags,
 				   krb5enc_decrypt_hash_done, req);
 
 	err = crypto_ahash_digest(ahreq);
@@ -301,6 +296,21 @@ static int krb5enc_dispatch_decrypt_hash
 	return krb5enc_verify_hash(req);
 }
 
+static void krb5enc_decrypt_done(void *data, int err)
+{
+	struct aead_request *req = data;
+
+	if (err)
+		goto out;
+
+	err = krb5enc_dispatch_decrypt_hash(req, 0);
+	if (err == -EINPROGRESS)
+		return;
+
+out:
+	aead_request_complete(req, err);
+}
+
 /*
  * Dispatch the decryption of the ciphertext.
  */
@@ -324,7 +334,7 @@ static int krb5enc_dispatch_decrypt(stru
 
 	skcipher_request_set_tfm(skreq, ctx->enc);
 	skcipher_request_set_callback(skreq, aead_request_flags(req),
-				      req->base.complete, req->base.data);
+				      krb5enc_decrypt_done, req);
 	skcipher_request_set_crypt(skreq, src, dst,
 				   req->cryptlen - authsize, req->iv);
 
@@ -339,7 +349,7 @@ static int krb5enc_decrypt(struct aead_r
 	if (err < 0)
 		return err;
 
-	return krb5enc_dispatch_decrypt_hash(req);
+	return krb5enc_dispatch_decrypt_hash(req, aead_request_flags(req));
 }
 
 static int krb5enc_init_tfm(struct crypto_aead *tfm)


