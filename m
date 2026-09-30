Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8B634119FA;
	Wed, 30 Sep 2026 19:40:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790797215; cv=none; b=Kq4/XM27GdE+jjf+opQ38tTp+TAKkiDTUJ3YChn7l0E7MVmAuXbtjAHFkYr5SYu5JTyThQrwSphmHEulbvrIspk7is+/7JcQBAE/tQHmpfdSk6R/rv2oc+oqbaBzIgVJ5iw5l02RAvJCwsed6WSESfWonUdAGxm1hhF1t6h8UpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790797215; c=relaxed/simple;
	bh=Q0b8tkt+m38ez+z4QtPAZKDAZ8ZS83uBsXU612TEZP0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cOHkxo+lRrFdIBs0/h2E6CTB/XZVnlzQWjbBwmtq7IqogDtJpNUoytkiTQ75GyLaw5HObP5GxCZV1kEkVu5yNAq4PGqjzs2uj8Z9rKG2rwN8wd939XrI0jlWzQPWS9fAgsgAXKtrhJMr8VgddMoKqq8Z025Vbi/cFwvfpoQOyQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rdxo+Tir; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rdxo+Tir"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF93F1F000FF;
	Wed, 30 Sep 2026 19:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790797213;
	bh=eGU/O6/p2Uk7WZMionLUW5+Qh20PDbvpNQpu/7urRYs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rdxo+TirFHAneMPGnK9OlPcLrGvkum5sOH7r89N69YW7dN+IIIL6PDi2XjJtuBpIZ
	 nDyr9H0DzCYT9iQmzUjjTTJRQ8xZQ7ZDgWY64qmCWhe1OKLvnFMfe9FmDLvm2jrF0X
	 9ES5A2bya8H6sPPVe2osKBQ/1gGrTEie8g/IF46I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukas Wunner <lukas@wunner.de>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1185/1193] crypto: virtio - Drop sign/verify operations
Date: Wed, 30 Sep 2026 17:31:09 +0200
Message-ID: <20260930152500.571187891@linuxfoundation.org>
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

From: Lukas Wunner <lukas@wunner.de>

[ Upstream commit 5b553e06b3215fa97d222ebddc2bc964f1824c5b ]

The virtio crypto driver exposes akcipher sign/verify operations in a
user space ABI.  This blocks removal of sign/verify from akcipher_alg.

Herbert opines:

   "I would say that this is something that we can break.  Breaking it
    is no different to running virtio on a host that does not support
    these algorithms.  After all, a software implementation must always
    be present.

    I deliberately left akcipher out of crypto_user because the API
    is still in flux.  We should not let virtio constrain ourselves."
    https://lore.kernel.org/all/ZtqoNAgcnXnrYhZZ@gondor.apana.org.au/

   "I would remove virtio akcipher support in its entirety.  This API
    was never meant to be exposed outside of the kernel."
    https://lore.kernel.org/all/Ztqql_gqgZiMW8zz@gondor.apana.org.au/

Drop sign/verify support from virtio crypto.  There's no strong reason
to also remove encrypt/decrypt support, so keep it.

A key selling point of virtio crypto is to allow guest access to crypto
accelerators on the host.  So far the only akcipher algorithm supported
by virtio crypto is RSA.  Dropping sign/verify merely means that the
PKCS#1 padding is now always generated or verified inside the guest,
but the actual signature generation/verification (which is an RSA
decrypt/encrypt operation) may still use an accelerator on the host.

Generating or verifying the PKCS#1 padding is cheap, so a hardware
accelerator won't be of much help there.  Which begs the question
whether virtio crypto support for sign/verify makes sense at all.

It would make sense for the sign operation if the host has a security
chip to store asymmetric private keys.  But the kernel doesn't even
have an asymmetric_key_subtype yet for hardware-based private keys.
There's at least one rudimentary driver for such chips (atmel-ecc.c for
ATECC508A), but it doesn't implement the sign operation.  The kernel
would first have to grow support for a hardware asymmetric_key_subtype
and at least one driver implementing the sign operation before exposure
to guests via virtio makes sense.

Signed-off-by: Lukas Wunner <lukas@wunner.de>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Stable-dep-of: f77a956f6a19 ("crypto: virtio - bound the akcipher result length")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/virtio/virtio_crypto_akcipher_algs.c |   67 ++++++--------------
 include/uapi/linux/virtio_crypto.h                  |    1 
 2 files changed, 23 insertions(+), 45 deletions(-)

--- a/drivers/crypto/virtio/virtio_crypto_akcipher_algs.c
+++ b/drivers/crypto/virtio/virtio_crypto_akcipher_algs.c
@@ -83,23 +83,16 @@ static void virtio_crypto_dataq_akcipher
 	case VIRTIO_CRYPTO_BADMSG:
 		error = -EBADMSG;
 		break;
-
-	case VIRTIO_CRYPTO_KEY_REJECTED:
-		error = -EKEYREJECTED;
-		break;
-
 	default:
 		error = -EIO;
 		break;
 	}
 
 	akcipher_req = vc_akcipher_req->akcipher_req;
-	if (vc_akcipher_req->opcode != VIRTIO_CRYPTO_AKCIPHER_VERIFY) {
-		/* actuall length maybe less than dst buffer */
-		akcipher_req->dst_len = len - sizeof(vc_req->status);
-		sg_copy_from_buffer(akcipher_req->dst, sg_nents(akcipher_req->dst),
-				    vc_akcipher_req->dst_buf, akcipher_req->dst_len);
-	}
+	/* actual length maybe less than dst buffer */
+	akcipher_req->dst_len = len - sizeof(vc_req->status);
+	sg_copy_from_buffer(akcipher_req->dst, sg_nents(akcipher_req->dst),
+			    vc_akcipher_req->dst_buf, akcipher_req->dst_len);
 	virtio_crypto_akcipher_finalize_req(vc_akcipher_req, akcipher_req, error);
 }
 
@@ -230,36 +223,27 @@ static int __virtio_crypto_akcipher_do_r
 	int node = dev_to_node(&vcrypto->vdev->dev);
 	unsigned long flags;
 	int ret;
-	bool verify = vc_akcipher_req->opcode == VIRTIO_CRYPTO_AKCIPHER_VERIFY;
-	unsigned int src_len = verify ? req->src_len + req->dst_len : req->src_len;
 
 	/* out header */
 	sg_init_one(&outhdr_sg, req_data, sizeof(*req_data));
 	sgs[num_out++] = &outhdr_sg;
 
 	/* src data */
-	src_buf = kcalloc_node(src_len, 1, GFP_KERNEL, node);
+	src_buf = kcalloc_node(req->src_len, 1, GFP_KERNEL, node);
 	if (!src_buf)
 		return -ENOMEM;
 
-	if (verify) {
-		/* for verify operation, both src and dst data work as OUT direction */
-		sg_copy_to_buffer(req->src, sg_nents(req->src), src_buf, src_len);
-		sg_init_one(&srcdata_sg, src_buf, src_len);
-		sgs[num_out++] = &srcdata_sg;
-	} else {
-		sg_copy_to_buffer(req->src, sg_nents(req->src), src_buf, src_len);
-		sg_init_one(&srcdata_sg, src_buf, src_len);
-		sgs[num_out++] = &srcdata_sg;
-
-		/* dst data */
-		dst_buf = kcalloc_node(req->dst_len, 1, GFP_KERNEL, node);
-		if (!dst_buf)
-			goto free_src;
+	sg_copy_to_buffer(req->src, sg_nents(req->src), src_buf, req->src_len);
+	sg_init_one(&srcdata_sg, src_buf, req->src_len);
+	sgs[num_out++] = &srcdata_sg;
+
+	/* dst data */
+	dst_buf = kcalloc_node(req->dst_len, 1, GFP_KERNEL, node);
+	if (!dst_buf)
+		goto free_src;
 
-		sg_init_one(&dstdata_sg, dst_buf, req->dst_len);
-		sgs[num_out + num_in++] = &dstdata_sg;
-	}
+	sg_init_one(&dstdata_sg, dst_buf, req->dst_len);
+	sgs[num_out + num_in++] = &dstdata_sg;
 
 	vc_akcipher_req->src_buf = src_buf;
 	vc_akcipher_req->dst_buf = dst_buf;
@@ -352,16 +336,6 @@ static int virtio_crypto_rsa_decrypt(str
 	return virtio_crypto_rsa_req(req, VIRTIO_CRYPTO_AKCIPHER_DECRYPT);
 }
 
-static int virtio_crypto_rsa_sign(struct akcipher_request *req)
-{
-	return virtio_crypto_rsa_req(req, VIRTIO_CRYPTO_AKCIPHER_SIGN);
-}
-
-static int virtio_crypto_rsa_verify(struct akcipher_request *req)
-{
-	return virtio_crypto_rsa_req(req, VIRTIO_CRYPTO_AKCIPHER_VERIFY);
-}
-
 static int virtio_crypto_rsa_set_key(struct crypto_akcipher *tfm,
 				     const void *key,
 				     unsigned int keylen,
@@ -524,16 +498,19 @@ static struct virtio_crypto_akcipher_alg
 		.algo.base = {
 			.encrypt = virtio_crypto_rsa_encrypt,
 			.decrypt = virtio_crypto_rsa_decrypt,
-			.sign = virtio_crypto_rsa_sign,
-			.verify = virtio_crypto_rsa_verify,
+			/*
+			 * Must specify an arbitrary hash algorithm upon
+			 * set_{pub,priv}_key (even though it's not used
+			 * by encrypt/decrypt) because qemu checks for it.
+			 */
 			.set_pub_key = virtio_crypto_p1pad_rsa_sha1_set_pub_key,
 			.set_priv_key = virtio_crypto_p1pad_rsa_sha1_set_priv_key,
 			.max_size = virtio_crypto_rsa_max_size,
 			.init = virtio_crypto_rsa_init_tfm,
 			.exit = virtio_crypto_rsa_exit_tfm,
 			.base = {
-				.cra_name = "pkcs1pad(rsa,sha1)",
-				.cra_driver_name = "virtio-pkcs1-rsa-with-sha1",
+				.cra_name = "pkcs1pad(rsa)",
+				.cra_driver_name = "virtio-pkcs1-rsa",
 				.cra_priority = 150,
 				.cra_module = THIS_MODULE,
 				.cra_ctxsize = sizeof(struct virtio_crypto_akcipher_ctx),
--- a/include/uapi/linux/virtio_crypto.h
+++ b/include/uapi/linux/virtio_crypto.h
@@ -329,6 +329,7 @@ struct virtio_crypto_op_header {
 	VIRTIO_CRYPTO_OPCODE(VIRTIO_CRYPTO_SERVICE_AKCIPHER, 0x00)
 #define VIRTIO_CRYPTO_AKCIPHER_DECRYPT \
 	VIRTIO_CRYPTO_OPCODE(VIRTIO_CRYPTO_SERVICE_AKCIPHER, 0x01)
+	/* akcipher sign/verify opcodes are deprecated */
 #define VIRTIO_CRYPTO_AKCIPHER_SIGN \
 	VIRTIO_CRYPTO_OPCODE(VIRTIO_CRYPTO_SERVICE_AKCIPHER, 0x02)
 #define VIRTIO_CRYPTO_AKCIPHER_VERIFY \


