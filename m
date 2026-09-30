Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 204CE4FB9AF;
	Wed, 30 Sep 2026 17:18:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788692; cv=none; b=U2NjXk0gSpKMn6SWpFawVzXju6LTLRGNoo/N8GdNX4bJQ9FfDPNgMHnmk3jC8GMxgjfjtxCGGJhuX4jaO325tgdS+Raq4fgrkP3AIJBhAzr7jCsRWXYWTzRBmehPuvLVcMVK1EAEjSVgXhB9nT1DubbuH1k+oetR1rxKBvF1rnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788692; c=relaxed/simple;
	bh=SF28LRXoUTsQLVhVFI9d8+b2AyN47JfTPDVWcjXukKU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bg4RleS3Ht5nrdJxkXY5YppWw5O0A1aWoH8qhkPixz1UWs9excudQZRWlw6rt+nkSOAOnAxQDWq7MranbTsWN0vRhngwL8sfBGD8PagD37snUgyGEVOyc3n8aB3S6qBGI2pSChEGsfLgHR4/yuYDBzrVhLAAMdMX+ZWzEAfIsc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IYdpvURF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IYdpvURF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C2BF1F000FF;
	Wed, 30 Sep 2026 17:18:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788691;
	bh=FE/rexkhHWpKOIYYqIQPYep0W4+aI/7p6+BLKaanqnk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IYdpvURF8UCH9ZLD2Vxg3H7lVDcx8cfYhWk3dSQ+xI/nuj4cdldgOs2TvBvhQHOEJ
	 Hs8zU10wSv1uMxLv5x5JrnZKxscOu+aXs/mfXxwdb7s3tQOC8DMcVLVLmY0JANvOCy
	 JgEZt4eR9Fo7Cwqb4dT+HKz0djX1ZUcFzvl9d/4o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	co+6a581c4284f721d4@bugs.sh,
	Stefano Garzarella <sgarzare@redhat.com>,
	Srish Srinivasan <ssrish@linux.ibm.com>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 6.12 207/877] KEYS: trusted: Fix tpm2_load_cmd() boundary check
Date: Wed, 30 Sep 2026 17:18:38 +0200
Message-ID: <20260930152419.191381180@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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


