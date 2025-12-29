Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1A903191A7;
	Mon, 29 Dec 2025 16:28:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025727; cv=none; b=dR2V7Jj/5w11/OuIDg03c5rGQ/wC+uubA661RrEJvrRFuajFM0sbsBDKU0ikZGg2XAkCJeljuKHb2Ca0lqC3ascoiqRbN809K2aAJ9wMxF2vImChJZFNbPKTJjj+iLW7c5N+dZaPwQSxKw0ioMlYAbTximrTRIpIojLZ/wYRzPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025727; c=relaxed/simple;
	bh=2pSSHc99ToS2FjPEm7KnXmgG9nODrka37D/BiwagWE0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aW2k1jhR7xu4Lw7ozrrVxGiZbdIEZo2M+nPX6HXBKxnj2Baz0Nb7L4YXM6RbpafsvoBmZwejENZVU0Gk0gLcuIu+yVZF0GAjTyTG4oGaC8UUOAJX/bZSPdWgFQeUzPKdLRAMkcawV3xy1tAdR8z5msD6c5Noj/ncot3C/p0REMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LKmgDxbY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LKmgDxbY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65D0CC4CEF7;
	Mon, 29 Dec 2025 16:28:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025726;
	bh=2pSSHc99ToS2FjPEm7KnXmgG9nODrka37D/BiwagWE0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LKmgDxbYRFOZVvsJEApFxdD3l8okK+Nv9AJWBrU5uwk4CnuMdhXjI9nXYtDpj61wt
	 9Ij99XuEOR6UdzXQ/XBqJJ4cP8XOx0B5JNax9C4oDVQ6u3SuQTdrS1oVlLNKC6DJP2
	 9ZGrmw8AdBDeqROuLfua7ndIjR8uROClMq6kXmaI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Jonathan McDowell <noodles@meta.com>
Subject: [PATCH 6.18 272/430] tpm2-sessions: Fix tpm2_read_public range checks
Date: Mon, 29 Dec 2025 17:11:14 +0100
Message-ID: <20251229160734.359938988@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

From: Jarkko Sakkinen <jarkko@kernel.org>

commit bda1cbf73c6e241267c286427f2ed52b5735d872 upstream.

tpm2_read_public() has some rudimentary range checks but the function does
not ensure that the response buffer has enough bytes for the full TPMT_HA
payload.

Re-implement the function with necessary checks and validation, and return
name and name size for all handle types back to the caller.

Cc: stable@vger.kernel.org # v6.10+
Fixes: d0a25bb961e6 ("tpm: Add HMAC session name/handle append")
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Reviewed-by: Jonathan McDowell <noodles@meta.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/tpm/tpm2-cmd.c      |    3 +
 drivers/char/tpm/tpm2-sessions.c |   94 ++++++++++++++++++++-------------------
 2 files changed, 53 insertions(+), 44 deletions(-)

--- a/drivers/char/tpm/tpm2-cmd.c
+++ b/drivers/char/tpm/tpm2-cmd.c
@@ -11,8 +11,11 @@
  * used by the kernel internally.
  */
 
+#include "linux/dev_printk.h"
+#include "linux/tpm.h"
 #include "tpm.h"
 #include <crypto/hash_info.h>
+#include <linux/unaligned.h>
 
 static bool disable_pcr_integrity;
 module_param(disable_pcr_integrity, bool, 0444);
--- a/drivers/char/tpm/tpm2-sessions.c
+++ b/drivers/char/tpm/tpm2-sessions.c
@@ -163,53 +163,61 @@ static int name_size(const u8 *name)
 	}
 }
 
-static int tpm2_parse_read_public(char *name, struct tpm_buf *buf)
+static int tpm2_read_public(struct tpm_chip *chip, u32 handle, void *name)
 {
-	struct tpm_header *head = (struct tpm_header *)buf->data;
+	u32 mso = tpm2_handle_mso(handle);
 	off_t offset = TPM_HEADER_SIZE;
-	u32 tot_len = be32_to_cpu(head->length);
-	int ret;
-	u32 val;
-
-	/* we're starting after the header so adjust the length */
-	tot_len -= TPM_HEADER_SIZE;
-
-	/* skip public */
-	val = tpm_buf_read_u16(buf, &offset);
-	if (val > tot_len)
-		return -EINVAL;
-	offset += val;
-	/* name */
-	val = tpm_buf_read_u16(buf, &offset);
-	ret = name_size(&buf->data[offset]);
-	if (ret < 0)
-		return ret;
-
-	if (val != ret)
-		return -EINVAL;
-
-	memcpy(name, &buf->data[offset], val);
-	/* forget the rest */
-	return 0;
-}
-
-static int tpm2_read_public(struct tpm_chip *chip, u32 handle, char *name)
-{
+	int rc, name_size_alg;
 	struct tpm_buf buf;
-	int rc;
+
+	if (mso != TPM2_MSO_PERSISTENT && mso != TPM2_MSO_VOLATILE &&
+	    mso != TPM2_MSO_NVRAM) {
+		memcpy(name, &handle, sizeof(u32));
+		return sizeof(u32);
+	}
 
 	rc = tpm_buf_init(&buf, TPM2_ST_NO_SESSIONS, TPM2_CC_READ_PUBLIC);
 	if (rc)
 		return rc;
 
 	tpm_buf_append_u32(&buf, handle);
-	rc = tpm_transmit_cmd(chip, &buf, 0, "read public");
-	if (rc == TPM2_RC_SUCCESS)
-		rc = tpm2_parse_read_public(name, &buf);
 
-	tpm_buf_destroy(&buf);
+	rc = tpm_transmit_cmd(chip, &buf, 0, "TPM2_ReadPublic");
+	if (rc) {
+		tpm_buf_destroy(&buf);
+		return tpm_ret_to_err(rc);
+	}
+
+	/* Skip TPMT_PUBLIC: */
+	offset += tpm_buf_read_u16(&buf, &offset);
 
-	return rc;
+	/*
+	 * Ensure space for the length field of TPM2B_NAME and hashAlg field of
+	 * TPMT_HA (the extra four bytes).
+	 */
+	if (offset + 4 > tpm_buf_length(&buf)) {
+		tpm_buf_destroy(&buf);
+		return -EIO;
+	}
+
+	rc = tpm_buf_read_u16(&buf, &offset);
+	name_size_alg = name_size(&buf.data[offset]);
+
+	if (name_size_alg < 0)
+		return name_size_alg;
+
+	if (rc != name_size_alg) {
+		tpm_buf_destroy(&buf);
+		return -EIO;
+	}
+
+	if (offset + rc > tpm_buf_length(&buf)) {
+		tpm_buf_destroy(&buf);
+		return -EIO;
+	}
+
+	memcpy(name, &buf.data[offset], rc);
+	return name_size_alg;
 }
 #endif /* CONFIG_TCG_TPM2_HMAC */
 
@@ -243,6 +251,7 @@ int tpm_buf_append_name(struct tpm_chip
 #ifdef CONFIG_TCG_TPM2_HMAC
 	enum tpm2_mso_type mso = tpm2_handle_mso(handle);
 	struct tpm2_auth *auth;
+	u16 name_size_alg;
 	int slot;
 	int ret;
 #endif
@@ -273,8 +282,10 @@ int tpm_buf_append_name(struct tpm_chip
 	    mso == TPM2_MSO_NVRAM) {
 		if (!name) {
 			ret = tpm2_read_public(chip, handle, auth->name[slot]);
-			if (ret)
+			if (ret < 0)
 				goto err;
+
+			name_size_alg = ret;
 		}
 	} else {
 		if (name) {
@@ -286,13 +297,8 @@ int tpm_buf_append_name(struct tpm_chip
 	}
 
 	auth->name_h[slot] = handle;
-	if (name) {
-		ret = name_size(name);
-		if (ret < 0)
-			goto err;
-
-		memcpy(auth->name[slot], name, ret);
-	}
+	if (name)
+		memcpy(auth->name[slot], name, name_size_alg);
 #endif
 	return 0;
 


