Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC4A23ACF1C;
	Wed, 23 Sep 2026 14:28:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173686; cv=none; b=s6nn3/H+96CusBIELNaU16WohuR8SmPi5fji4A7IoOenETr+3pBvW4BTAbxjqteq+UBt4cXLgof7NfyQ03eOI+tYM7rxZ6XgbJXFG32ezrDL7sXh2NlekYm6AIpioarrY+X9eI5KRtNGgCp2ky/S0wot8n1Px88Zk9ZRtCyKbEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173686; c=relaxed/simple;
	bh=t2CnQF5GFO39Sv3aSYt9oHoXh6n18fX74X2RFtPcMjo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t2fd0Xx169STzDjdV9cAfZIxwP3dVJe8HFtIJNjZVC+ve2XzbjsyAD5J9+F0M3RPw7MlsdTZAwSMmlDDNMivvIBqlEDkPHMJhXkTZ+7YlKLbVWd4ogtziMksErXGy6aq+Kbe4Rupr3hm8nW0L3DM0mdW9Mfneq31YxlASvfzg2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fjGPyX/t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fjGPyX/t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBA781F000FF;
	Wed, 23 Sep 2026 14:28:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173685;
	bh=l6KZhEUzxmEINgxq7fL9RenRQFRFyDJGIby1+w8gVps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fjGPyX/toV9KFtEVS/gJCd2CLKJs2PfQOYYRZR9w1Z/Dng+NWlIpBr9s0zDBszbWy
	 gzlksV5+OLF9n9GRZwpfmvNt4v4ppafmL1iqnkytntVoOzNHj+HYPBSXx8vjrxXYLt
	 /Ks0MYlgQiKTKzVUTBbrQdOzWEU+m5spV7Ky1kvE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	co+6a581c4284f721d4@bugs.sh,
	Stefano Garzarella <sgarzare@redhat.com>,
	Srish Srinivasan <ssrish@linux.ibm.com>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 7.2 322/438] KEYS: trusted: Fix tpm2_load_cmd() boundary check
Date: Wed, 23 Sep 2026 16:05:43 +0200
Message-ID: <20260923140653.140862834@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jarkko Sakkinen <jarkko@kernel.org>

commit 114f00d738f15dd8c7318369edcdc53dd6d08763 upstream.

tpm2_load_cmd() does boundary checks against the ASN.1 size i.e.,
payload->blob_len. Address this by passing the decoded blob size to
tpm2_load_cmd(), and use it for the boundary checks.

Cc: stable@vger.kernel.org # v5.13+
Fixes: f2219745250f ("security: keys: trusted: use ASN.1 TPM2 key format for the blobs")
Reported-by: co+6a581c4284f721d4@bugs.sh
Closes: https://bugs.sh/b/6a581c4284f721d4/
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Tested-by: Srish Srinivasan <ssrish@linux.ibm.com>
Link: https://lore.kernel.org/r/20260901205809.2028454-1-jarkko@kernel.org
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/keys/trusted-keys/trusted_tpm2.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/security/keys/trusted-keys/trusted_tpm2.c
+++ b/security/keys/trusted-keys/trusted_tpm2.c
@@ -100,7 +100,7 @@ struct tpm2_key_context {
 
 static int tpm2_key_decode(struct trusted_key_payload *payload,
 			   struct trusted_key_options *options,
-			   u8 **buf)
+			   u8 **buf, unsigned int *blob_len)
 {
 	int ret;
 	struct tpm2_key_context ctx;
@@ -121,6 +121,7 @@ static int tpm2_key_decode(struct truste
 		return -ENOMEM;
 
 	*buf = blob;
+	*blob_len = ctx.priv_len + ctx.pub_len;
 	options->keyhandle = ctx.parent;
 
 	memcpy(blob, ctx.priv, ctx.priv_len);
@@ -381,10 +382,11 @@ static int tpm2_load_cmd(struct tpm_chip
 	int rc;
 	u32 attrs;
 
-	rc = tpm2_key_decode(payload, options, &blob);
+	rc = tpm2_key_decode(payload, options, &blob, &blob_len);
 	if (rc) {
 		/* old form */
 		blob = payload->blob;
+		blob_len = payload->blob_len;
 		payload->old_format = 1;
 	} else {
 		/* Bind for cleanup: */
@@ -396,17 +398,17 @@ static int tpm2_load_cmd(struct tpm_chip
 		return -EINVAL;
 
 	/* must be big enough for at least the two be16 size counts */
-	if (payload->blob_len < 4)
+	if (blob_len < 4)
 		return -EINVAL;
 
 	private_len = get_unaligned_be16(blob);
 
 	/* must be big enough for following public_len */
-	if (private_len + 2 + 2 > (payload->blob_len))
+	if (private_len + 2 + 2 > blob_len)
 		return -E2BIG;
 
 	public_len = get_unaligned_be16(blob + 2 + private_len);
-	if (private_len + 2 + public_len + 2 > payload->blob_len)
+	if (private_len + 2 + public_len + 2 > blob_len)
 		return -E2BIG;
 
 	pub = blob + 2 + private_len + 2;


