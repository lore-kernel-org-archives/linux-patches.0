Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA6E212A167;
	Tue, 23 Jan 2024 00:51:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971063; cv=none; b=ZrHSCZWmu1FDkvqZuR9kV42f+FPmjNnFeftiWLTMKL+/bXBYpHap2gg+n2Cr//3L9cHI79oq+WV6vqfxabfesJxb34ODdKzVeJln6z/2047AsyvF2ODo6H1ype7UndND5idOJHDhsI+LDliFVkWfjyb/kqFDiH05F6yzlRM+Y5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971063; c=relaxed/simple;
	bh=lffCsH5dr/8Cjnf5bIwt+tLajEU7j/SNZiPrtEGbQng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SEN7ex8BmMW3VMGADDRs1r3sqLv1IE9LotEqlfFkaKeuFGKRdrzew2QbpQdN7D8mDOnvFAHX82zf5rsuveEDTmktWXhIWLMYwwOwfYa4T95RS3WMReQ8YD9y2gCJY8qhqfHTyzNvQp/Fgz79ntRExkbzIMrBixRQa2upvuYETz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l1N3fju/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l1N3fju/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60E97C433F1;
	Tue, 23 Jan 2024 00:51:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971063;
	bh=lffCsH5dr/8Cjnf5bIwt+tLajEU7j/SNZiPrtEGbQng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l1N3fju/2WO8L2dFYUUqfyBU9aWVp3xKt2jHjtK0yFVRMGW/3K3LatWkyVp4ozCb8
	 rLj46qWXe3gnNKEBzFCo0CSz1qbIJFGXrCEVSdmEIIn+UN9OVlKNAHu6EvBkbpy56s
	 nx0GDDAkXRCFAM4hf4pNXRQJnpzuuPx+YGDZqI7g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Gonglei <arei.gonglei@huawei.com>,
	zhenwei pi <pizhenwei@bytedance.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 081/286] virtio-crypto: use private buffer for control request
Date: Mon, 22 Jan 2024 15:56:27 -0800
Message-ID: <20240122235735.155143795@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
References: <20240122235732.009174833@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: zhenwei pi <pizhenwei@bytedance.com>

[ Upstream commit 0756ad15b1fef287d4d8fa11bc36ea77a5c42e4a ]

Originally, all of the control requests share a single buffer(
ctrl & input & ctrl_status fields in struct virtio_crypto), this
allows queue depth 1 only, the performance of control queue gets
limited by this design.

In this patch, each request allocates request buffer dynamically, and
free buffer after request, so the scope protected by ctrl_lock also
get optimized here.
It's possible to optimize control queue depth in the next step.

A necessary comment is already in code, still describe it again:
/*
 * Note: there are padding fields in request, clear them to zero before
 * sending to host to avoid to divulge any information.
 * Ex, virtio_crypto_ctrl_request::ctrl::u::destroy_session::padding[48]
 */
So use kzalloc to allocate buffer of struct virtio_crypto_ctrl_request.

Potentially dereferencing uninitialized variables:
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>

Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Gonglei <arei.gonglei@huawei.com>
Reviewed-by: Gonglei <arei.gonglei@huawei.com>
Signed-off-by: zhenwei pi <pizhenwei@bytedance.com>
Message-Id: <20220506131627.180784-3-pizhenwei@bytedance.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Stable-dep-of: fed93fb62e05 ("crypto: virtio - Handle dataq logic with tasklet")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../virtio/virtio_crypto_akcipher_algs.c      | 57 ++++++++++++-------
 drivers/crypto/virtio/virtio_crypto_algs.c    | 50 ++++++++++------
 drivers/crypto/virtio/virtio_crypto_common.h  | 17 ++++--
 3 files changed, 79 insertions(+), 45 deletions(-)

diff --git a/drivers/crypto/virtio/virtio_crypto_akcipher_algs.c b/drivers/crypto/virtio/virtio_crypto_akcipher_algs.c
index 20901a263fc8..698ea57e2649 100644
--- a/drivers/crypto/virtio/virtio_crypto_akcipher_algs.c
+++ b/drivers/crypto/virtio/virtio_crypto_akcipher_algs.c
@@ -108,16 +108,22 @@ static int virtio_crypto_alg_akcipher_init_session(struct virtio_crypto_akcipher
 	unsigned int num_out = 0, num_in = 0;
 	struct virtio_crypto_op_ctrl_req *ctrl;
 	struct virtio_crypto_session_input *input;
+	struct virtio_crypto_ctrl_request *vc_ctrl_req;
 
 	pkey = kmemdup(key, keylen, GFP_ATOMIC);
 	if (!pkey)
 		return -ENOMEM;
 
-	spin_lock(&vcrypto->ctrl_lock);
-	ctrl = &vcrypto->ctrl;
+	vc_ctrl_req = kzalloc(sizeof(*vc_ctrl_req), GFP_KERNEL);
+	if (!vc_ctrl_req) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	ctrl = &vc_ctrl_req->ctrl;
 	memcpy(&ctrl->header, header, sizeof(ctrl->header));
 	memcpy(&ctrl->u, para, sizeof(ctrl->u));
-	input = &vcrypto->input;
+	input = &vc_ctrl_req->input;
 	input->status = cpu_to_le32(VIRTIO_CRYPTO_ERR);
 
 	sg_init_one(&outhdr_sg, ctrl, sizeof(*ctrl));
@@ -129,16 +135,22 @@ static int virtio_crypto_alg_akcipher_init_session(struct virtio_crypto_akcipher
 	sg_init_one(&inhdr_sg, input, sizeof(*input));
 	sgs[num_out + num_in++] = &inhdr_sg;
 
+	spin_lock(&vcrypto->ctrl_lock);
 	err = virtqueue_add_sgs(vcrypto->ctrl_vq, sgs, num_out, num_in, vcrypto, GFP_ATOMIC);
-	if (err < 0)
+	if (err < 0) {
+		spin_unlock(&vcrypto->ctrl_lock);
 		goto out;
+	}
 
 	virtqueue_kick(vcrypto->ctrl_vq);
 	while (!virtqueue_get_buf(vcrypto->ctrl_vq, &inlen) &&
 	       !virtqueue_is_broken(vcrypto->ctrl_vq))
 		cpu_relax();
+	spin_unlock(&vcrypto->ctrl_lock);
 
 	if (le32_to_cpu(input->status) != VIRTIO_CRYPTO_OK) {
+		pr_err("virtio_crypto: Create session failed status: %u\n",
+			le32_to_cpu(input->status));
 		err = -EINVAL;
 		goto out;
 	}
@@ -148,13 +160,9 @@ static int virtio_crypto_alg_akcipher_init_session(struct virtio_crypto_akcipher
 	err = 0;
 
 out:
-	spin_unlock(&vcrypto->ctrl_lock);
+	kfree(vc_ctrl_req);
 	kfree_sensitive(pkey);
 
-	if (err < 0)
-		pr_err("virtio_crypto: Create session failed status: %u\n",
-			le32_to_cpu(input->status));
-
 	return err;
 }
 
@@ -167,15 +175,18 @@ static int virtio_crypto_alg_akcipher_close_session(struct virtio_crypto_akciphe
 	int err;
 	struct virtio_crypto_op_ctrl_req *ctrl;
 	struct virtio_crypto_inhdr *ctrl_status;
+	struct virtio_crypto_ctrl_request *vc_ctrl_req;
 
-	spin_lock(&vcrypto->ctrl_lock);
-	if (!ctx->session_valid) {
-		err = 0;
-		goto out;
-	}
-	ctrl_status = &vcrypto->ctrl_status;
+	if (!ctx->session_valid)
+		return 0;
+
+	vc_ctrl_req = kzalloc(sizeof(*vc_ctrl_req), GFP_KERNEL);
+	if (!vc_ctrl_req)
+		return -ENOMEM;
+
+	ctrl_status = &vc_ctrl_req->ctrl_status;
 	ctrl_status->status = VIRTIO_CRYPTO_ERR;
-	ctrl = &vcrypto->ctrl;
+	ctrl = &vc_ctrl_req->ctrl;
 	ctrl->header.opcode = cpu_to_le32(VIRTIO_CRYPTO_AKCIPHER_DESTROY_SESSION);
 	ctrl->header.queue_id = 0;
 
@@ -188,16 +199,22 @@ static int virtio_crypto_alg_akcipher_close_session(struct virtio_crypto_akciphe
 	sg_init_one(&inhdr_sg, &ctrl_status->status, sizeof(ctrl_status->status));
 	sgs[num_out + num_in++] = &inhdr_sg;
 
+	spin_lock(&vcrypto->ctrl_lock);
 	err = virtqueue_add_sgs(vcrypto->ctrl_vq, sgs, num_out, num_in, vcrypto, GFP_ATOMIC);
-	if (err < 0)
+	if (err < 0) {
+		spin_unlock(&vcrypto->ctrl_lock);
 		goto out;
+	}
 
 	virtqueue_kick(vcrypto->ctrl_vq);
 	while (!virtqueue_get_buf(vcrypto->ctrl_vq, &inlen) &&
 	       !virtqueue_is_broken(vcrypto->ctrl_vq))
 		cpu_relax();
+	spin_unlock(&vcrypto->ctrl_lock);
 
 	if (ctrl_status->status != VIRTIO_CRYPTO_OK) {
+		pr_err("virtio_crypto: Close session failed status: %u, session_id: 0x%llx\n",
+			ctrl_status->status, destroy_session->session_id);
 		err = -EINVAL;
 		goto out;
 	}
@@ -206,11 +223,7 @@ static int virtio_crypto_alg_akcipher_close_session(struct virtio_crypto_akciphe
 	ctx->session_valid = false;
 
 out:
-	spin_unlock(&vcrypto->ctrl_lock);
-	if (err < 0) {
-		pr_err("virtio_crypto: Close session failed status: %u, session_id: 0x%llx\n",
-			ctrl_status->status, destroy_session->session_id);
-	}
+	kfree(vc_ctrl_req);
 
 	return err;
 }
diff --git a/drivers/crypto/virtio/virtio_crypto_algs.c b/drivers/crypto/virtio/virtio_crypto_algs.c
index 12e2001235a6..50601398f35c 100644
--- a/drivers/crypto/virtio/virtio_crypto_algs.c
+++ b/drivers/crypto/virtio/virtio_crypto_algs.c
@@ -126,6 +126,7 @@ static int virtio_crypto_alg_skcipher_init_session(
 	struct virtio_crypto_op_ctrl_req *ctrl;
 	struct virtio_crypto_session_input *input;
 	struct virtio_crypto_sym_create_session_req *sym_create_session;
+	struct virtio_crypto_ctrl_request *vc_ctrl_req;
 
 	/*
 	 * Avoid to do DMA from the stack, switch to using
@@ -136,15 +137,20 @@ static int virtio_crypto_alg_skcipher_init_session(
 	if (!cipher_key)
 		return -ENOMEM;
 
-	spin_lock(&vcrypto->ctrl_lock);
+	vc_ctrl_req = kzalloc(sizeof(*vc_ctrl_req), GFP_KERNEL);
+	if (!vc_ctrl_req) {
+		err = -ENOMEM;
+		goto out;
+	}
+
 	/* Pad ctrl header */
-	ctrl = &vcrypto->ctrl;
+	ctrl = &vc_ctrl_req->ctrl;
 	ctrl->header.opcode = cpu_to_le32(VIRTIO_CRYPTO_CIPHER_CREATE_SESSION);
 	ctrl->header.algo = cpu_to_le32(alg);
 	/* Set the default dataqueue id to 0 */
 	ctrl->header.queue_id = 0;
 
-	input = &vcrypto->input;
+	input = &vc_ctrl_req->input;
 	input->status = cpu_to_le32(VIRTIO_CRYPTO_ERR);
 	/* Pad cipher's parameters */
 	sym_create_session = &ctrl->u.sym_create_session;
@@ -164,12 +170,12 @@ static int virtio_crypto_alg_skcipher_init_session(
 	sg_init_one(&inhdr, input, sizeof(*input));
 	sgs[num_out + num_in++] = &inhdr;
 
+	spin_lock(&vcrypto->ctrl_lock);
 	err = virtqueue_add_sgs(vcrypto->ctrl_vq, sgs, num_out,
 				num_in, vcrypto, GFP_ATOMIC);
 	if (err < 0) {
 		spin_unlock(&vcrypto->ctrl_lock);
-		kfree_sensitive(cipher_key);
-		return err;
+		goto out;
 	}
 	virtqueue_kick(vcrypto->ctrl_vq);
 
@@ -180,13 +186,13 @@ static int virtio_crypto_alg_skcipher_init_session(
 	while (!virtqueue_get_buf(vcrypto->ctrl_vq, &tmp) &&
 	       !virtqueue_is_broken(vcrypto->ctrl_vq))
 		cpu_relax();
+	spin_unlock(&vcrypto->ctrl_lock);
 
 	if (le32_to_cpu(input->status) != VIRTIO_CRYPTO_OK) {
-		spin_unlock(&vcrypto->ctrl_lock);
 		pr_err("virtio_crypto: Create session failed status: %u\n",
 			le32_to_cpu(input->status));
-		kfree_sensitive(cipher_key);
-		return -EINVAL;
+		err = -EINVAL;
+		goto out;
 	}
 
 	if (encrypt)
@@ -194,10 +200,11 @@ static int virtio_crypto_alg_skcipher_init_session(
 	else
 		ctx->dec_sess_info.session_id = le64_to_cpu(input->session_id);
 
-	spin_unlock(&vcrypto->ctrl_lock);
-
+	err = 0;
+out:
+	kfree(vc_ctrl_req);
 	kfree_sensitive(cipher_key);
-	return 0;
+	return err;
 }
 
 static int virtio_crypto_alg_skcipher_close_session(
@@ -212,12 +219,16 @@ static int virtio_crypto_alg_skcipher_close_session(
 	unsigned int num_out = 0, num_in = 0;
 	struct virtio_crypto_op_ctrl_req *ctrl;
 	struct virtio_crypto_inhdr *ctrl_status;
+	struct virtio_crypto_ctrl_request *vc_ctrl_req;
 
-	spin_lock(&vcrypto->ctrl_lock);
-	ctrl_status = &vcrypto->ctrl_status;
+	vc_ctrl_req = kzalloc(sizeof(*vc_ctrl_req), GFP_KERNEL);
+	if (!vc_ctrl_req)
+		return -ENOMEM;
+
+	ctrl_status = &vc_ctrl_req->ctrl_status;
 	ctrl_status->status = VIRTIO_CRYPTO_ERR;
 	/* Pad ctrl header */
-	ctrl = &vcrypto->ctrl;
+	ctrl = &vc_ctrl_req->ctrl;
 	ctrl->header.opcode = cpu_to_le32(VIRTIO_CRYPTO_CIPHER_DESTROY_SESSION);
 	/* Set the default virtqueue id to 0 */
 	ctrl->header.queue_id = 0;
@@ -236,28 +247,31 @@ static int virtio_crypto_alg_skcipher_close_session(
 	sg_init_one(&status_sg, &ctrl_status->status, sizeof(ctrl_status->status));
 	sgs[num_out + num_in++] = &status_sg;
 
+	spin_lock(&vcrypto->ctrl_lock);
 	err = virtqueue_add_sgs(vcrypto->ctrl_vq, sgs, num_out,
 			num_in, vcrypto, GFP_ATOMIC);
 	if (err < 0) {
 		spin_unlock(&vcrypto->ctrl_lock);
-		return err;
+		goto out;
 	}
 	virtqueue_kick(vcrypto->ctrl_vq);
 
 	while (!virtqueue_get_buf(vcrypto->ctrl_vq, &tmp) &&
 	       !virtqueue_is_broken(vcrypto->ctrl_vq))
 		cpu_relax();
+	spin_unlock(&vcrypto->ctrl_lock);
 
 	if (ctrl_status->status != VIRTIO_CRYPTO_OK) {
-		spin_unlock(&vcrypto->ctrl_lock);
 		pr_err("virtio_crypto: Close session failed status: %u, session_id: 0x%llx\n",
 			ctrl_status->status, destroy_session->session_id);
 
 		return -EINVAL;
 	}
-	spin_unlock(&vcrypto->ctrl_lock);
 
-	return 0;
+	err = 0;
+out:
+	kfree(vc_ctrl_req);
+	return err;
 }
 
 static int virtio_crypto_alg_skcipher_init_sessions(
diff --git a/drivers/crypto/virtio/virtio_crypto_common.h b/drivers/crypto/virtio/virtio_crypto_common.h
index 214f9a6fcf84..e9ecbda6affe 100644
--- a/drivers/crypto/virtio/virtio_crypto_common.h
+++ b/drivers/crypto/virtio/virtio_crypto_common.h
@@ -13,6 +13,7 @@
 #include <crypto/aead.h>
 #include <crypto/aes.h>
 #include <crypto/engine.h>
+#include <uapi/linux/virtio_crypto.h>
 
 
 /* Internal representation of a data virtqueue */
@@ -65,11 +66,6 @@ struct virtio_crypto {
 	/* Maximum size of per request */
 	u64 max_size;
 
-	/* Control VQ buffers: protected by the ctrl_lock */
-	struct virtio_crypto_op_ctrl_req ctrl;
-	struct virtio_crypto_session_input input;
-	struct virtio_crypto_inhdr ctrl_status;
-
 	unsigned long status;
 	atomic_t ref_count;
 	struct list_head list;
@@ -85,6 +81,17 @@ struct virtio_crypto_sym_session_info {
 	__u64 session_id;
 };
 
+/*
+ * Note: there are padding fields in request, clear them to zero before
+ *       sending to host to avoid to divulge any information.
+ * Ex, virtio_crypto_ctrl_request::ctrl::u::destroy_session::padding[48]
+ */
+struct virtio_crypto_ctrl_request {
+	struct virtio_crypto_op_ctrl_req ctrl;
+	struct virtio_crypto_session_input input;
+	struct virtio_crypto_inhdr ctrl_status;
+};
+
 struct virtio_crypto_request;
 typedef void (*virtio_crypto_data_callback)
 		(struct virtio_crypto_request *vc_req, int len);
-- 
2.43.0



