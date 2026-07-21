Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2A5746EC6F;
	Tue, 21 Jul 2026 18:33:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658837; cv=none; b=ajXyD9OurAebB5a2a4Z8WAch4qejsjT3E69dWg6Eu+cQutTa6jKs22oww5DGDK21zGiP5Pl8DB3xrVTkZRF+GT5jD6BO0hHtmfmgzxPez7rQ7pQ7Bf8OP3rHEycPRIbmch9JJdf8RfUDobzlxqmiQeUEJHUgWcwAvVjyv7gs4vY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658837; c=relaxed/simple;
	bh=HP34RGP+E8WmjDwaAY+9JsChHR8M0DTqk1ryC4vkjuI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QQS34lmYumIqI8JIIatB1gm0BL70OTTzgU0o4paytUDl/yjTVPU131fesF9msP4y9sYQFUe3jLLkkStQ8s6g47ovJrGMv9Ta8oTVFjySwHTvd1Cqsk0RloqF8ufWbYI7OXQDi5OzddWRehISaEclmjVhpAugNydd27PqWhmm/Gc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EqnlEABl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EqnlEABl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F65E1F000E9;
	Tue, 21 Jul 2026 18:33:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658835;
	bh=H7G9JBQQ623RVBYzKtOey5LFtZ/RRWzn1Qh+PcAIuoI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EqnlEABl83CjR6CBXcZCrX/Kq0RAdhrZBoYzg1Q1rGYaSUazMa7jsuGiCMme+Vvvn
	 3LijGJ4WZVxfAriFgQCOST9no7640iW1evT07bYzD0zOnbotGcNQgnCCp+1cK+Vovu
	 dUs/y0HWQJ+uPb8fR7hmWmY1pOApOnmoScsSKecA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 6.18 1292/1611] tpm: tpm2-sessions: wait for async KPP completion in tpm_buf_append_salt
Date: Tue, 21 Jul 2026 17:23:28 +0200
Message-ID: <20260721152544.504895377@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Michael Bommarito <michael.bommarito@gmail.com>

commit 73851a7c43dfa52d2ed9415889b33daf85da0ed9 upstream.

tpm_buf_append_salt() in drivers/char/tpm/tpm2-sessions.c calls
crypto_kpp_generate_public_key() and crypto_kpp_compute_shared_secret()
without installing a completion callback, discards both return values,
and immediately frees the kpp_request via kpp_request_free(). When the
resolved ecdh-nist-p256 KPP backend is asynchronous (atmel-ecc, HPRE,
keembay-ocs), either operation returns -EINPROGRESS and the deferred
completion worker dereferences the freed request.

The path fires automatically from the hwrng_fillfn kernel thread via
tpm_get_random -> tpm2_get_random -> tpm2_start_auth_session ->
tpm_buf_append_salt on every entropy poll, without any userland action.

Install crypto_req_done as the completion callback, wrap both KPP
operations in crypto_wait_req(), and propagate errors to the caller.
The wait is a no-op for synchronous backends.

Fixes: 1085b8276bb4 ("tpm: Add the rest of the session HMAC API")
Cc: stable@vger.kernel.org # v6.10+
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Assisted-by: Claude:claude-opus-4-7
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/tpm/tpm2-sessions.c |   45 +++++++++++++++++++++++++++++----------
 1 file changed, 34 insertions(+), 11 deletions(-)

--- a/drivers/char/tpm/tpm2-sessions.c
+++ b/drivers/char/tpm/tpm2-sessions.c
@@ -490,15 +490,17 @@ static void tpm2_KDFe(u8 z[EC_PT_SZ], co
 	sha256_final(&sctx, out);
 }
 
-static void tpm_buf_append_salt(struct tpm_buf *buf, struct tpm_chip *chip,
-				struct tpm2_auth *auth)
+static int tpm_buf_append_salt(struct tpm_buf *buf, struct tpm_chip *chip,
+			       struct tpm2_auth *auth)
 {
 	struct crypto_kpp *kpp;
 	struct kpp_request *req;
+	DECLARE_CRYPTO_WAIT(wait);
 	struct scatterlist s[2], d[1];
 	struct ecdh p = {0};
 	u8 encoded_key[EC_PT_SZ], *x, *y;
 	unsigned int buf_len;
+	int rc;
 
 	/* secret is two sized points */
 	tpm_buf_append_u16(buf, (EC_PT_SZ + 2)*2);
@@ -521,14 +523,15 @@ static void tpm_buf_append_salt(struct t
 	kpp = crypto_alloc_kpp("ecdh-nist-p256", CRYPTO_ALG_INTERNAL, 0);
 	if (IS_ERR(kpp)) {
 		dev_err(&chip->dev, "crypto ecdh allocation failed\n");
-		return;
+		return PTR_ERR(kpp);
 	}
 
 	buf_len = crypto_ecdh_key_len(&p);
 	if (sizeof(encoded_key) < buf_len) {
 		dev_err(&chip->dev, "salt buffer too small needs %d\n",
 			buf_len);
-		goto out;
+		rc = -EINVAL;
+		goto err_free_kpp;
 	}
 	crypto_ecdh_encode_key(encoded_key, buf_len, &p);
 	/* this generates a random private key */
@@ -536,11 +539,17 @@ static void tpm_buf_append_salt(struct t
 
 	/* salt is now the public point of this private key */
 	req = kpp_request_alloc(kpp, GFP_KERNEL);
-	if (!req)
-		goto out;
+	if (!req) {
+		rc = -ENOMEM;
+		goto err_free_kpp;
+	}
+	kpp_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
+				 crypto_req_done, &wait);
 	kpp_request_set_input(req, NULL, 0);
 	kpp_request_set_output(req, s, EC_PT_SZ*2);
-	crypto_kpp_generate_public_key(req);
+	rc = crypto_wait_req(crypto_kpp_generate_public_key(req), &wait);
+	if (rc)
+		goto err_free_req;
 	/*
 	 * we're not done: now we have to compute the shared secret
 	 * which is our private key multiplied by the tpm_key public
@@ -552,8 +561,9 @@ static void tpm_buf_append_salt(struct t
 	kpp_request_set_input(req, s, EC_PT_SZ*2);
 	sg_init_one(d, auth->salt, EC_PT_SZ);
 	kpp_request_set_output(req, d, EC_PT_SZ);
-	crypto_kpp_compute_shared_secret(req);
-	kpp_request_free(req);
+	rc = crypto_wait_req(crypto_kpp_compute_shared_secret(req), &wait);
+	if (rc)
+		goto err_free_req;
 
 	/*
 	 * pass the shared secret through KDFe for salt. Note salt
@@ -563,8 +573,16 @@ static void tpm_buf_append_salt(struct t
 	 */
 	tpm2_KDFe(auth->salt, "SECRET", x, chip->null_ec_key_x, auth->salt);
 
- out:
+	kpp_request_free(req);
 	crypto_free_kpp(kpp);
+	return 0;
+
+err_free_req:
+	kpp_request_free(req);
+
+err_free_kpp:
+	crypto_free_kpp(kpp);
+	return rc;
 }
 
 /**
@@ -1019,7 +1037,12 @@ int tpm2_start_auth_session(struct tpm_c
 	tpm_buf_append(&buf, auth->our_nonce, sizeof(auth->our_nonce));
 
 	/* append encrypted salt and squirrel away unencrypted in auth */
-	tpm_buf_append_salt(&buf, chip, auth);
+	rc = tpm_buf_append_salt(&buf, chip, auth);
+	if (rc) {
+		tpm2_flush_context(chip, null_key);
+		tpm_buf_destroy(&buf);
+		goto out;
+	}
 	/* session type (HMAC, audit or policy) */
 	tpm_buf_append_u8(&buf, TPM2_SE_HMAC);
 


