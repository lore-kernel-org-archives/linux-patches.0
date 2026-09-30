Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B69B03DA7DB;
	Wed, 30 Sep 2026 19:40:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790797211; cv=none; b=CPqKf2PTwFt/n3bb17+DGdGsr7GT82iYbAICrrtsNJbDup1bDxD3w5pjf6gK6FuBNIRWd2NN68n6SyJFzAZq3wBZg0uNturjD80+dsFbLYjxMxAxDp1Xa6KkQCXwGxKXOb4wAYDeXLSOXxWsNGzEVyBk5YCbzPs6aqTUJThI+K8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790797211; c=relaxed/simple;
	bh=qyjaHbnrl2SS2kWmhFI7HqkdjP+EKkTuYN3XRhDwXwE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BclBnR+vbxqjyxEOx/cSt1+LarlPi/yNv2jMy7XPy4ACiD8n1INdn2a5b4+MD08q34IelMM5gmCV4KvI9T4sR/GgE1hMIa1Cm8U7kdgOJVtJg6KXbzc2R+K0ZAoZ8GAq18FRBTAsTtiFUc3gtNspluDBG0R6FVri6B7stDPODTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ui4YehAJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ui4YehAJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EE251F000FF;
	Wed, 30 Sep 2026 19:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790797210;
	bh=KIP7r6D6CjlsTWLRM/URmCAcRjXwxBw/6BioKXbW6f0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ui4YehAJsGvU+cHDlNYx82UOprkOV0uyR8+iaq9/Ooukg7NiD5rEjxjNHddOW0brN
	 8qscmkx5YwlKFdgdAoa1Yq+JIrJQ7jFCJw/mGP1Eqviv+WFXMeaGxZUds7Ls7h9+x6
	 Qa1ShSzk141BIyJ0eZ58XB1E1JQFdBFarRPHaKP0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Markus Elfring <elfring@users.sourceforge.net>,
	Gonglei <arei.gonglei@huawei.com>,
	Justin Stitt <justinstitt@google.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1184/1193] crypto: virtio - Less function calls in __virtio_crypto_akcipher_do_req() after error detection
Date: Wed, 30 Sep 2026 17:31:08 +0200
Message-ID: <20260930152500.548548069@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Markus Elfring <elfring@users.sourceforge.net>

[ Upstream commit e01966e643c97eb8916bbbbbeceb687afb11f345 ]

The kfree() function was called in up to two cases by the
__virtio_crypto_akcipher_do_req() function during error handling
even if the passed variable contained a null pointer.
This issue was detected by using the Coccinelle software.

* Adjust jump targets.

* Delete two initialisations which became unnecessary
  with this refactoring.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
Reviewed-by: Gonglei <arei.gonglei@huawei.com>
Reviewed-by: Justin Stitt <justinstitt@google.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Stable-dep-of: f77a956f6a19 ("crypto: virtio - bound the akcipher result length")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/virtio/virtio_crypto_akcipher_algs.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/crypto/virtio/virtio_crypto_akcipher_algs.c
+++ b/drivers/crypto/virtio/virtio_crypto_akcipher_algs.c
@@ -225,11 +225,11 @@ static int __virtio_crypto_akcipher_do_r
 	struct virtio_crypto *vcrypto = ctx->vcrypto;
 	struct virtio_crypto_op_data_req *req_data = vc_req->req_data;
 	struct scatterlist *sgs[4], outhdr_sg, inhdr_sg, srcdata_sg, dstdata_sg;
-	void *src_buf = NULL, *dst_buf = NULL;
+	void *src_buf, *dst_buf = NULL;
 	unsigned int num_out = 0, num_in = 0;
 	int node = dev_to_node(&vcrypto->vdev->dev);
 	unsigned long flags;
-	int ret = -ENOMEM;
+	int ret;
 	bool verify = vc_akcipher_req->opcode == VIRTIO_CRYPTO_AKCIPHER_VERIFY;
 	unsigned int src_len = verify ? req->src_len + req->dst_len : req->src_len;
 
@@ -240,7 +240,7 @@ static int __virtio_crypto_akcipher_do_r
 	/* src data */
 	src_buf = kcalloc_node(src_len, 1, GFP_KERNEL, node);
 	if (!src_buf)
-		goto err;
+		return -ENOMEM;
 
 	if (verify) {
 		/* for verify operation, both src and dst data work as OUT direction */
@@ -255,7 +255,7 @@ static int __virtio_crypto_akcipher_do_r
 		/* dst data */
 		dst_buf = kcalloc_node(req->dst_len, 1, GFP_KERNEL, node);
 		if (!dst_buf)
-			goto err;
+			goto free_src;
 
 		sg_init_one(&dstdata_sg, dst_buf, req->dst_len);
 		sgs[num_out + num_in++] = &dstdata_sg;
@@ -278,9 +278,9 @@ static int __virtio_crypto_akcipher_do_r
 	return 0;
 
 err:
-	kfree(src_buf);
 	kfree(dst_buf);
-
+free_src:
+	kfree(src_buf);
 	return -ENOMEM;
 }
 


