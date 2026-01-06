Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90EB72DF6EA;
	Tue,  6 Jan 2026 17:42:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721330; cv=none; b=i37ZYosFMakbGzkebYdZhs6Y9VKJCbyVBCB2CR/1s2ZRNrnrOklcSS62jZAG2ugXDWQg3pxpQU4YbOE+NodofFEn4GHNTVGcccHwAiBjgi+X+3SutlmuiQ0B1Qe1gnL16K967Cuqyz445CgVRPbDDJav9Q77XoPrLuQWYjhJafs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721330; c=relaxed/simple;
	bh=RTrBs/YfbL4eRATIj4MiiJ8gNIwvQhj2tw+o8QPdZwA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CQQS1dgOglNkykWrsoRpp7r3D8/J1ORqc/DCthORCxxte5HWHFlcJMlZ3Z81KsBXxpnccGxXTohR9mtLh0BgDPbgQMtlTshRPI9ccYSIBytMY4wzOCdnyHg42RW1/C0+gHfvbOgaJNY6iU12t5VZ7fdZL4OOtQuyXBUqFbF4iD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0umlSpVu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0umlSpVu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DD54C116C6;
	Tue,  6 Jan 2026 17:42:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721330;
	bh=RTrBs/YfbL4eRATIj4MiiJ8gNIwvQhj2tw+o8QPdZwA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0umlSpVuVtN6h8zgzbFb1iy945IiV2nzh0sjh2j0io36nKrpwb+QyEI/rDstij5we
	 Lu7Y3QrS7Uw4mJfEJ4SXBdA8hlJ4qG49uUj642aVWxw2qPpgeixIBgbGrL5zObcZSa
	 yyiLh+tgmtARMMoErbuNgvhgTrh4hTIoRyydn0q8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Jonathan McDowell <noodles@meta.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 505/567] tpm2-sessions: Fix tpm2_read_public range checks
Date: Tue,  6 Jan 2026 18:04:47 +0100
Message-ID: <20260106170510.051628389@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jarkko Sakkinen <jarkko@kernel.org>

[ Upstream commit bda1cbf73c6e241267c286427f2ed52b5735d872 ]

tpm2_read_public() has some rudimentary range checks but the function does
not ensure that the response buffer has enough bytes for the full TPMT_HA
payload.

Re-implement the function with necessary checks and validation, and return
name and name size for all handle types back to the caller.

Cc: stable@vger.kernel.org # v6.10+
Fixes: d0a25bb961e6 ("tpm: Add HMAC session name/handle append")
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Reviewed-by: Jonathan McDowell <noodles@meta.com>
[ different semantics around u8 name_size() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/tpm/tpm2-cmd.c      |    3 +
 drivers/char/tpm/tpm2-sessions.c |   85 ++++++++++++++++++++++++---------------
 2 files changed, 56 insertions(+), 32 deletions(-)

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
@@ -156,47 +156,60 @@ static u8 name_size(const u8 *name)
 	return size_map[alg] + 2;
 }
 
-static int tpm2_parse_read_public(char *name, struct tpm_buf *buf)
+static int tpm2_read_public(struct tpm_chip *chip, u32 handle, void *name)
 {
-	struct tpm_header *head = (struct tpm_header *)buf->data;
+	u32 mso = tpm2_handle_mso(handle);
 	off_t offset = TPM_HEADER_SIZE;
-	u32 tot_len = be32_to_cpu(head->length);
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
-	if (val != name_size(&buf->data[offset]))
-		return -EINVAL;
-	memcpy(name, &buf->data[offset], val);
-	/* forget the rest */
-	return 0;
-}
-
-static int tpm2_read_public(struct tpm_chip *chip, u32 handle, char *name)
-{
-	struct tpm_buf buf;
 	int rc;
+	u8 name_size_alg;
+	struct tpm_buf buf;
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
 
-	return rc;
+	/* Skip TPMT_PUBLIC: */
+	offset += tpm_buf_read_u16(&buf, &offset);
+
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
+	tpm_buf_destroy(&buf);
+	return name_size_alg;
 }
 #endif /* CONFIG_TCG_TPM2_HMAC */
 
@@ -229,6 +242,7 @@ void tpm_buf_append_name(struct tpm_chip
 	enum tpm2_mso_type mso = tpm2_handle_mso(handle);
 	struct tpm2_auth *auth;
 	int slot;
+	int ret;
 #endif
 
 	if (!tpm2_chip_auth(chip)) {
@@ -251,8 +265,11 @@ void tpm_buf_append_name(struct tpm_chip
 	if (mso == TPM2_MSO_PERSISTENT ||
 	    mso == TPM2_MSO_VOLATILE ||
 	    mso == TPM2_MSO_NVRAM) {
-		if (!name)
-			tpm2_read_public(chip, handle, auth->name[slot]);
+		if (!name) {
+			ret = tpm2_read_public(chip, handle, auth->name[slot]);
+			if (ret < 0)
+				goto err;
+		}
 	} else {
 		if (name)
 			dev_err(&chip->dev, "TPM: Handle does not require name but one is specified\n");
@@ -261,6 +278,10 @@ void tpm_buf_append_name(struct tpm_chip
 	auth->name_h[slot] = handle;
 	if (name)
 		memcpy(auth->name[slot], name, name_size(name));
+	return;
+
+err:
+	tpm2_end_auth_session(chip);
 #endif
 }
 EXPORT_SYMBOL_GPL(tpm_buf_append_name);


