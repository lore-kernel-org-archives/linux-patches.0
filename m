Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C120247DE1;
	Tue, 20 May 2025 14:11:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750316; cv=none; b=REqwYq5WM3lqOeK0eGnjqyvafhj4G5U9kzpZrwxpscTGVT5T6lqfio4fFjlZJQlm3Kz3bAXGK0De9Akcr7/MCJ2Fo95svrCu6KVQZHX0WagQS8ygdzQKOYeE/YJBvqKllS40hrCXvuGzOAIEFF/koZkONS8elgHbWcNjntNKwPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750316; c=relaxed/simple;
	bh=S/aT9khgMToPTr7Q1TNFIbh0iOcMRcnqQhqs09Szrl4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JosdN0BuUokJ4PFjBf1HttjDPnK3LlBNG2pdk34aD1QhuOGoP5u31RyayI19UJj4/rHkYo8lCFwtehpEA860h8q0OiHDgagi0CKtDKxtko9hQNHQmq2D8PEoM/rsxQA1lPaapB9B5lrJC8HQGv+olGqheppoaH6gE4zCM/H5O6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uhGLm+yI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uhGLm+yI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66650C4CEE9;
	Tue, 20 May 2025 14:11:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750315;
	bh=S/aT9khgMToPTr7Q1TNFIbh0iOcMRcnqQhqs09Szrl4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uhGLm+yI+SdBpnI6AnMFBskAEeXuaDBGREq00h8VyUcbjj6t5ESXDTQqfPP42tLST
	 EtS1aBDDI1EyKIpxYHbpKKoaLcVl+9kbH9jbeoCBb9T+/xa5FrsD6KMTcNlATYSaBX
	 Hj9w2Mpa9fKoqCqMbULYp0ElSIAdPi0TJcnn/V2c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 6.12 113/143] tpm: Mask TPM RC in tpm2_start_auth_session()
Date: Tue, 20 May 2025 15:51:08 +0200
Message-ID: <20250520125814.480445922@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.036375422@linuxfoundation.org>
References: <20250520125810.036375422@linuxfoundation.org>
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
 drivers/char/tpm/tpm2-sessions.c | 20 ++++++--------------
 include/linux/tpm.h              | 19 +++++++++++++++++++
 2 files changed, 25 insertions(+), 14 deletions(-)

diff --git a/drivers/char/tpm/tpm2-sessions.c b/drivers/char/tpm/tpm2-sessions.c
index 3f89635ba5e8..7b5049b3d476 100644
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
@@ -963,16 +958,13 @@ static int tpm2_load_null(struct tpm_chip *chip, u32 *null_key)
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
@@ -1024,7 +1016,7 @@ int tpm2_start_auth_session(struct tpm_chip *chip)
 	/* hash algorithm for session */
 	tpm_buf_append_u16(&buf, TPM_ALG_SHA256);
 
-	rc = tpm_transmit_cmd(chip, &buf, 0, "start auth session");
+	rc = tpm_ret_to_err(tpm_transmit_cmd(chip, &buf, 0, "StartAuthSession"));
 	tpm2_flush_context(chip, null_key);
 
 	if (rc == TPM2_RC_SUCCESS)
diff --git a/include/linux/tpm.h b/include/linux/tpm.h
index 6c3125300c00..9ac9768cc8f7 100644
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
-- 
2.49.0



