Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F010D305687;
	Wed, 23 Sep 2026 14:48:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174918; cv=none; b=jOSfXqmpnBfDIDUzH6Lzoda+NLAeMvoL9/gC54hWFAClyDIymfDDD8Jmyt8pzjkSha1+cDy//CgYpdiAUmWB+2zefjPXbpKf1oCzlkW0tmhac3mjHXVY79feK8G62XjUjDVpoT1YDAWpVObpxrgVuGsHw73jOSoVT0PtYfYEbxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174918; c=relaxed/simple;
	bh=VP/ukSwlqR+O9SgwMZiv50Oxqf5PtD1ig9uyo1PR460=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UrMC6t76WzAKTxGDo0BhfJT9Y/FQAwKfzF/x4BxvdcxcaB9PTOYaroZBJNNUL74Ub0t1qFsA26vKUgjflLWq9f0dbJujBPln3WX7Znie65Tp392uoIUSwUQFeiGwpFLAxuRNbhD4+EOWt5XD/dALB7CcXvOQw2xt3Z2qng3EK38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uAlfUmeU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uAlfUmeU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FF541F000FF;
	Wed, 23 Sep 2026 14:48:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174916;
	bh=IMIqglo4Yej/PQQ+7UnS4Xl+IprwWrysqG+n6jp1SLY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uAlfUmeUMm81N3nV70pGF56+h89/uhkiwZ/I53jBb1nqFg/K/B7fDPKU64DRUVTud
	 4uLYQO/WtKpNCitb9vq0PB5gAJWblw2iDH2PTNMg2g6xpdH3S2g3y2OzUEvupm/VBn
	 t8jRvSxPYSuvw5MCn0Ql/BmspqMhyb3xO5HTEdGg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	co+6a581c4284f721d4@bugs.sh,
	Stefano Garzarella <sgarzare@redhat.com>,
	Srish Srinivasan <ssrish@linux.ibm.com>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 6.18 265/398] KEYS: trusted: Fix tpm2_load_cmd() boundary check
Date: Wed, 23 Sep 2026 16:05:39 +0200
Message-ID: <20260923140650.280196505@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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
@@ -108,7 +108,7 @@ struct tpm2_key_context {
 
 static int tpm2_key_decode(struct trusted_key_payload *payload,
 			   struct trusted_key_options *options,
-			   u8 **buf)
+			   u8 **buf, unsigned int *blob_len)
 {
 	int ret;
 	struct tpm2_key_context ctx;
@@ -129,6 +129,7 @@ static int tpm2_key_decode(struct truste
 		return -ENOMEM;
 
 	*buf = blob;
+	*blob_len = ctx.priv_len + ctx.pub_len;
 	options->keyhandle = ctx.parent;
 
 	memcpy(blob, ctx.priv, ctx.priv_len);
@@ -402,10 +403,11 @@ static int tpm2_load_cmd(struct tpm_chip
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
@@ -417,17 +419,17 @@ static int tpm2_load_cmd(struct tpm_chip
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


