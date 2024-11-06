Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5FA31DE3B8;
	Wed,  6 Nov 2024 12:32:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896343; cv=none; b=RUpKtda4rwimfVhY277M9rEgqNObbf9vT2YzTxaTXqK8P5qHal+29lGwjP2xq12c5I7thj25r39wDeVYY23E21CEEL68ZDevIEw9h7gasIbMKfb9uWvcL3AeyL3qeoK/e7O7cy+iInMTG7xxmO3TdCrpQKOb9QMPLYgBji8e5wY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896343; c=relaxed/simple;
	bh=xu9fo1SuUWtEpCVb7u61SLhcdmk5htD7kpgbn5RNcZ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V9tyyMNYrtFV6HYGCds9KhPxwWubrWjAZ/yYkK38KPjSF4kxwgnpTxpn09FFo8j9euZHdW38NSwL+2wmqcGS/Ccdt4EVopZ5R+yuT4je83GGrG29ceU++ar7Muow31juZAUSGNCXbHd1jTy9uN5GcFG1EFr+Nm6RCjJOQoJMof4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V+JFreC1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V+JFreC1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38AF0C4CECD;
	Wed,  6 Nov 2024 12:32:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896343;
	bh=xu9fo1SuUWtEpCVb7u61SLhcdmk5htD7kpgbn5RNcZ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V+JFreC1cnCOuz10+Ef7XlfY5D9Zhpx9Czr+U/QSxU0IhFTnAyx1YAfW53PoKKLZ7
	 a49meBBczVuSwdR1WCeOuaZ4LQr7TMiwB7sl02xYvvKZIV0pP32NE5KTzFD0itwcmT
	 q2jG3MgxnqGUPAOq6vvJSTxylqT7oFbE68tPI+t8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengyu Ma <mapengyu@gmail.com>,
	Stefan Berger <stefanb@linux.ibm.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 171/245] tpm: Lazily flush the auth session
Date: Wed,  6 Nov 2024 13:03:44 +0100
Message-ID: <20241106120323.449467601@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jarkko Sakkinen <jarkko@kernel.org>

[ Upstream commit df745e25098dcb2f706399c0d06dd8d1bab6b6ec ]

Move the allocation of chip->auth to tpm2_start_auth_session() so that this
field can be used as flag to tell whether auth session is active or not.

Instead of flushing and reloading the auth session for every transaction
separately, keep the session open unless /dev/tpm0 is used.

Reported-by: Pengyu Ma <mapengyu@gmail.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=219229
Cc: stable@vger.kernel.org # v6.10+
Fixes: 7ca110f2679b ("tpm: Address !chip->auth in tpm_buf_append_hmac_session*()")
Tested-by: Pengyu Ma <mapengyu@gmail.com>
Tested-by: Stefan Berger <stefanb@linux.ibm.com>
Reviewed-by: Stefan Berger <stefanb@linux.ibm.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/tpm/tpm-chip.c       | 10 +++++++
 drivers/char/tpm/tpm-dev-common.c |  3 +++
 drivers/char/tpm/tpm-interface.c  |  6 +++--
 drivers/char/tpm/tpm2-sessions.c  | 45 ++++++++++++++++++-------------
 4 files changed, 44 insertions(+), 20 deletions(-)

diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
index 854546000c92b..1ff99a7091bbb 100644
--- a/drivers/char/tpm/tpm-chip.c
+++ b/drivers/char/tpm/tpm-chip.c
@@ -674,6 +674,16 @@ EXPORT_SYMBOL_GPL(tpm_chip_register);
  */
 void tpm_chip_unregister(struct tpm_chip *chip)
 {
+#ifdef CONFIG_TCG_TPM2_HMAC
+	int rc;
+
+	rc = tpm_try_get_ops(chip);
+	if (!rc) {
+		tpm2_end_auth_session(chip);
+		tpm_put_ops(chip);
+	}
+#endif
+
 	tpm_del_legacy_sysfs(chip);
 	if (tpm_is_hwrng_enabled(chip))
 		hwrng_unregister(&chip->hwrng);
diff --git a/drivers/char/tpm/tpm-dev-common.c b/drivers/char/tpm/tpm-dev-common.c
index c3fbbf4d3db79..48ff87444f851 100644
--- a/drivers/char/tpm/tpm-dev-common.c
+++ b/drivers/char/tpm/tpm-dev-common.c
@@ -27,6 +27,9 @@ static ssize_t tpm_dev_transmit(struct tpm_chip *chip, struct tpm_space *space,
 	struct tpm_header *header = (void *)buf;
 	ssize_t ret, len;
 
+	if (chip->flags & TPM_CHIP_FLAG_TPM2)
+		tpm2_end_auth_session(chip);
+
 	ret = tpm2_prepare_space(chip, space, buf, bufsiz);
 	/* If the command is not implemented by the TPM, synthesize a
 	 * response with a TPM2_RC_COMMAND_CODE return for user-space.
diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index 5da134f12c9a4..8134f002b121f 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -379,10 +379,12 @@ int tpm_pm_suspend(struct device *dev)
 
 	rc = tpm_try_get_ops(chip);
 	if (!rc) {
-		if (chip->flags & TPM_CHIP_FLAG_TPM2)
+		if (chip->flags & TPM_CHIP_FLAG_TPM2) {
+			tpm2_end_auth_session(chip);
 			tpm2_shutdown(chip, TPM2_SU_STATE);
-		else
+		} else {
 			rc = tpm1_pm_suspend(chip, tpm_suspend_pcr);
+		}
 
 		tpm_put_ops(chip);
 	}
diff --git a/drivers/char/tpm/tpm2-sessions.c b/drivers/char/tpm/tpm2-sessions.c
index a194535619929..c8fdfe901dfb7 100644
--- a/drivers/char/tpm/tpm2-sessions.c
+++ b/drivers/char/tpm/tpm2-sessions.c
@@ -333,6 +333,9 @@ void tpm_buf_append_hmac_session(struct tpm_chip *chip, struct tpm_buf *buf,
 	}
 
 #ifdef CONFIG_TCG_TPM2_HMAC
+	/* The first write to /dev/tpm{rm0} will flush the session. */
+	attributes |= TPM2_SA_CONTINUE_SESSION;
+
 	/*
 	 * The Architecture Guide requires us to strip trailing zeros
 	 * before computing the HMAC
@@ -484,7 +487,8 @@ static void tpm2_KDFe(u8 z[EC_PT_SZ], const char *str, u8 *pt_u, u8 *pt_v,
 	sha256_final(&sctx, out);
 }
 
-static void tpm_buf_append_salt(struct tpm_buf *buf, struct tpm_chip *chip)
+static void tpm_buf_append_salt(struct tpm_buf *buf, struct tpm_chip *chip,
+				struct tpm2_auth *auth)
 {
 	struct crypto_kpp *kpp;
 	struct kpp_request *req;
@@ -543,7 +547,7 @@ static void tpm_buf_append_salt(struct tpm_buf *buf, struct tpm_chip *chip)
 	sg_set_buf(&s[0], chip->null_ec_key_x, EC_PT_SZ);
 	sg_set_buf(&s[1], chip->null_ec_key_y, EC_PT_SZ);
 	kpp_request_set_input(req, s, EC_PT_SZ*2);
-	sg_init_one(d, chip->auth->salt, EC_PT_SZ);
+	sg_init_one(d, auth->salt, EC_PT_SZ);
 	kpp_request_set_output(req, d, EC_PT_SZ);
 	crypto_kpp_compute_shared_secret(req);
 	kpp_request_free(req);
@@ -554,8 +558,7 @@ static void tpm_buf_append_salt(struct tpm_buf *buf, struct tpm_chip *chip)
 	 * This works because KDFe fully consumes the secret before it
 	 * writes the salt
 	 */
-	tpm2_KDFe(chip->auth->salt, "SECRET", x, chip->null_ec_key_x,
-		  chip->auth->salt);
+	tpm2_KDFe(auth->salt, "SECRET", x, chip->null_ec_key_x, auth->salt);
 
  out:
 	crypto_free_kpp(kpp);
@@ -853,7 +856,9 @@ int tpm_buf_check_hmac_response(struct tpm_chip *chip, struct tpm_buf *buf,
 		if (rc)
 			/* manually close the session if it wasn't consumed */
 			tpm2_flush_context(chip, auth->handle);
-		memzero_explicit(auth, sizeof(*auth));
+
+		kfree_sensitive(auth);
+		chip->auth = NULL;
 	} else {
 		/* reset for next use  */
 		auth->session = TPM_HEADER_SIZE;
@@ -881,7 +886,8 @@ void tpm2_end_auth_session(struct tpm_chip *chip)
 		return;
 
 	tpm2_flush_context(chip, auth->handle);
-	memzero_explicit(auth, sizeof(*auth));
+	kfree_sensitive(auth);
+	chip->auth = NULL;
 }
 EXPORT_SYMBOL(tpm2_end_auth_session);
 
@@ -962,16 +968,20 @@ static int tpm2_load_null(struct tpm_chip *chip, u32 *null_key)
  */
 int tpm2_start_auth_session(struct tpm_chip *chip)
 {
+	struct tpm2_auth *auth;
 	struct tpm_buf buf;
-	struct tpm2_auth *auth = chip->auth;
-	int rc;
 	u32 null_key;
+	int rc;
 
-	if (!auth) {
-		dev_warn_once(&chip->dev, "auth session is not active\n");
+	if (chip->auth) {
+		dev_warn_once(&chip->dev, "auth session is active\n");
 		return 0;
 	}
 
+	auth = kzalloc(sizeof(*auth), GFP_KERNEL);
+	if (!auth)
+		return -ENOMEM;
+
 	rc = tpm2_load_null(chip, &null_key);
 	if (rc)
 		goto out;
@@ -992,7 +1002,7 @@ int tpm2_start_auth_session(struct tpm_chip *chip)
 	tpm_buf_append(&buf, auth->our_nonce, sizeof(auth->our_nonce));
 
 	/* append encrypted salt and squirrel away unencrypted in auth */
-	tpm_buf_append_salt(&buf, chip);
+	tpm_buf_append_salt(&buf, chip, auth);
 	/* session type (HMAC, audit or policy) */
 	tpm_buf_append_u8(&buf, TPM2_SE_HMAC);
 
@@ -1014,10 +1024,13 @@ int tpm2_start_auth_session(struct tpm_chip *chip)
 
 	tpm_buf_destroy(&buf);
 
-	if (rc)
-		goto out;
+	if (rc == TPM2_RC_SUCCESS) {
+		chip->auth = auth;
+		return 0;
+	}
 
- out:
+out:
+	kfree_sensitive(auth);
 	return rc;
 }
 EXPORT_SYMBOL(tpm2_start_auth_session);
@@ -1367,10 +1380,6 @@ int tpm2_sessions_init(struct tpm_chip *chip)
 		return rc;
 	}
 
-	chip->auth = kmalloc(sizeof(*chip->auth), GFP_KERNEL);
-	if (!chip->auth)
-		return -ENOMEM;
-
 	return rc;
 }
 EXPORT_SYMBOL(tpm2_sessions_init);
-- 
2.43.0



