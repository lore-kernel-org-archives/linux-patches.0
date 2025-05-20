Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02A3422D9E3;
	Tue, 20 May 2025 14:21:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750863; cv=none; b=QHb70kfuJymF9T/dm77dgrAMyMfPbHbXOkRLshpDhR36ipMlkfnsoF16x9uoYYzjCeE9INPGOUHj8bqRv7zepj3KV8LA/USZ4F29upavS5KaFI8Jp5b/Q8dwQIOFn8sa8Xk1T8sDlZwmOuNxR10xaIPNk1W+D+qZVfq3oNE0taQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750863; c=relaxed/simple;
	bh=5RtPbhvBVF1XKokD8c5QuHUJ7g3s0fdaBxauY9Y8j8A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=msjgMAObZsADlpmyF307folssElj5XQvfjTHM3QeVt0ujx6iKCHZSbPZgVv0AbhTFLHPp1436FtoN905O2r873Obc3Vtf+9a+E2mzjEvx831KHx3xVYqY95dZ3VWZ5ZrmLOQtJkHWlRW6SWJ0/virtg6HqH1L2XauKD/Z68WYLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eDB/MT1g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eDB/MT1g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8740AC4CEE9;
	Tue, 20 May 2025 14:21:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750862;
	bh=5RtPbhvBVF1XKokD8c5QuHUJ7g3s0fdaBxauY9Y8j8A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eDB/MT1gkku3bQRMF7tme250Q9mWZnn9o7lFhamXBI5ULdn4tnHNWWazp8KNp81nb
	 N4LQzs25QjWk+8FX0XRrBHlAgzHadfeKGQLZdneyKUgbu3ccALmxhgo2x6wKbrnDSQ
	 rCBNClkmjNqQKZqLdJNQjCsraooEEI2K83RTVW8g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 6.14 116/145] tpm: Mask TPM RC in tpm2_start_auth_session()
Date: Tue, 20 May 2025 15:51:26 +0200
Message-ID: <20250520125815.092210567@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.535475500@linuxfoundation.org>
References: <20250520125810.535475500@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jarkko Sakkinen <jarkko@kernel.org>

commit 539fbab37881e32ba6a708a100de6db19e1e7e7d upstream.

tpm2_start_auth_session() does not mask TPM RC correctly from the callers:

[   28.766528] tpm tpm0: A TPM error (2307) occurred start auth session

Process TPM RCs inside tpm2_start_auth_session(), and map them to POSIX
error codes.

Cc: stable@vger.kernel.org # v6.10+
Fixes: 699e3efd6c64 ("tpm: Add HMAC session start and end functions")
Reported-by: Herbert Xu <herbert@gondor.apana.org.au>
Closes: https://lore.kernel.org/linux-integrity/Z_NgdRHuTKP6JK--@gondor.apana.org.au/
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/tpm/tpm2-sessions.c |   20 ++++++--------------
 include/linux/tpm.h              |   19 +++++++++++++++++++
 2 files changed, 25 insertions(+), 14 deletions(-)

--- a/drivers/char/tpm/tpm2-sessions.c
+++ b/drivers/char/tpm/tpm2-sessions.c
@@ -40,11 +40,6 @@
  *
  * These are the usage functions:
  *
- * tpm2_start_auth_session() which allocates the opaque auth structure
- *	and gets a session from the TPM.  This must be called before
- *	any of the following functions.  The session is protected by a
- *	session_key which is derived from a random salt value
- *	encrypted to the NULL seed.
  * tpm2_end_auth_session() kills the session and frees the resources.
  *	Under normal operation this function is done by
  *	tpm_buf_check_hmac_response(), so this is only to be used on
@@ -963,16 +958,13 @@ err:
 }
 
 /**
- * tpm2_start_auth_session() - create a HMAC authentication session with the TPM
- * @chip: the TPM chip structure to create the session with
+ * tpm2_start_auth_session() - Create an a HMAC authentication session
+ * @chip:	A TPM chip
  *
- * This function loads the NULL seed from its saved context and starts
- * an authentication session on the null seed, fills in the
- * @chip->auth structure to contain all the session details necessary
- * for performing the HMAC, encrypt and decrypt operations and
- * returns.  The NULL seed is flushed before this function returns.
+ * Loads the ephemeral key (null seed), and starts an HMAC authenticated
+ * session. The null seed is flushed before the return.
  *
- * Return: zero on success or actual error encountered.
+ * Returns zero on success, or a POSIX error code.
  */
 int tpm2_start_auth_session(struct tpm_chip *chip)
 {
@@ -1024,7 +1016,7 @@ int tpm2_start_auth_session(struct tpm_c
 	/* hash algorithm for session */
 	tpm_buf_append_u16(&buf, TPM_ALG_SHA256);
 
-	rc = tpm_transmit_cmd(chip, &buf, 0, "start auth session");
+	rc = tpm_ret_to_err(tpm_transmit_cmd(chip, &buf, 0, "StartAuthSession"));
 	tpm2_flush_context(chip, null_key);
 
 	if (rc == TPM2_RC_SUCCESS)
--- a/include/linux/tpm.h
+++ b/include/linux/tpm.h
@@ -257,6 +257,7 @@ enum tpm2_return_codes {
 	TPM2_RC_TESTING		= 0x090A, /* RC_WARN */
 	TPM2_RC_REFERENCE_H0	= 0x0910,
 	TPM2_RC_RETRY		= 0x0922,
+	TPM2_RC_SESSION_MEMORY	= 0x0903,
 };
 
 enum tpm2_command_codes {
@@ -437,6 +438,24 @@ static inline u32 tpm2_rc_value(u32 rc)
 	return (rc & BIT(7)) ? rc & 0xbf : rc;
 }
 
+/*
+ * Convert a return value from tpm_transmit_cmd() to POSIX error code.
+ */
+static inline ssize_t tpm_ret_to_err(ssize_t ret)
+{
+	if (ret < 0)
+		return ret;
+
+	switch (tpm2_rc_value(ret)) {
+	case TPM2_RC_SUCCESS:
+		return 0;
+	case TPM2_RC_SESSION_MEMORY:
+		return -ENOMEM;
+	default:
+		return -EFAULT;
+	}
+}
+
 #if defined(CONFIG_TCG_TPM) || defined(CONFIG_TCG_TPM_MODULE)
 
 extern int tpm_is_tpm2(struct tpm_chip *chip);


