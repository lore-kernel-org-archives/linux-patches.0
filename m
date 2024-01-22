Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28E7212AADB;
	Tue, 23 Jan 2024 00:51:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971074; cv=none; b=nHixFm9bsLs5cJR4jkJnTxpacp8a0vm7JJ+hg2dRzDmY7bdCBK5G6qJnfdqjwmFZkNtgWXfdRCvRgjXetKyMo9ZkqHtA41RCNYzXXcjiM2IHcECO1ZjadMFIVu2pjFnHPgc1ikxF7YQx4o+AM8G3lF4qrBqJUntM3nFFhQOifVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971074; c=relaxed/simple;
	bh=MlayqDiewZodKyRxpEvTI5gxhITxhaaPM6MNCa5nQj4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FWpgMKDyPP//WE6bBYLLHKj4hJrgqqk4v7UweF4wpJQ6Qw1O0tGj2UxGyN044Dv94bU2vLAf+rT4uH6YMK5w/7HSBZ0uCu/exL3hXJh+SnX0e8QOklv9c4dIhcVIAWXmYdPRN99v8yJwcMa4bJ1EC9GjFADzY/H8tPCr1e2nqQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n8T49bKS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n8T49bKS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8388EC43390;
	Tue, 23 Jan 2024 00:51:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971074;
	bh=MlayqDiewZodKyRxpEvTI5gxhITxhaaPM6MNCa5nQj4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n8T49bKSeTpqTVliXnWqC7fEfCPMX3pJzNxaGjQnwYll4AoPFpB00xN75VeUtscS0
	 Jy1wqprpOvmzS2/Vzu48DlGE6+AUFx8DCj0UbF0XSSe8Qm1W9Zalzpmb3vatyK9U/l
	 WYw5WxmGNT8lMMGVQLo3HnEFO0Ov+pcHc9QWqIXI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Halil Pasic <pasic@linux.ibm.com>,
	wangyangxin <wangyangxin1@huawei.com>,
	Gonglei <arei.gonglei@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 083/286] crypto: virtio - Handle dataq logic with tasklet
Date: Mon, 22 Jan 2024 15:56:29 -0800
Message-ID: <20240122235735.238619092@linuxfoundation.org>
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

From: Gonglei (Arei) <arei.gonglei@huawei.com>

[ Upstream commit fed93fb62e05c38152b0fc1dc9609639e63eed76 ]

Doing ipsec produces a spinlock recursion warning.
This is due to crypto_finalize_request() being called in the upper half.
Move virtual data queue processing of virtio-crypto driver to tasklet.

Fixes: dbaf0624ffa57 ("crypto: add virtio-crypto driver")
Reported-by: Halil Pasic <pasic@linux.ibm.com>
Signed-off-by: wangyangxin <wangyangxin1@huawei.com>
Signed-off-by: Gonglei <arei.gonglei@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/virtio/virtio_crypto_common.h |  2 ++
 drivers/crypto/virtio/virtio_crypto_core.c   | 23 +++++++++++---------
 2 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/drivers/crypto/virtio/virtio_crypto_common.h b/drivers/crypto/virtio/virtio_crypto_common.h
index e0dcb247840a..d61c991d7773 100644
--- a/drivers/crypto/virtio/virtio_crypto_common.h
+++ b/drivers/crypto/virtio/virtio_crypto_common.h
@@ -10,6 +10,7 @@
 #include <linux/virtio.h>
 #include <linux/crypto.h>
 #include <linux/spinlock.h>
+#include <linux/interrupt.h>
 #include <crypto/aead.h>
 #include <crypto/aes.h>
 #include <crypto/engine.h>
@@ -28,6 +29,7 @@ struct data_queue {
 	char name[32];
 
 	struct crypto_engine *engine;
+	struct tasklet_struct done_task;
 };
 
 struct virtio_crypto {
diff --git a/drivers/crypto/virtio/virtio_crypto_core.c b/drivers/crypto/virtio/virtio_crypto_core.c
index 94624f469985..630af33929ef 100644
--- a/drivers/crypto/virtio/virtio_crypto_core.c
+++ b/drivers/crypto/virtio/virtio_crypto_core.c
@@ -72,27 +72,28 @@ int virtio_crypto_ctrl_vq_request(struct virtio_crypto *vcrypto, struct scatterl
 	return 0;
 }
 
-static void virtcrypto_dataq_callback(struct virtqueue *vq)
+static void virtcrypto_done_task(unsigned long data)
 {
-	struct virtio_crypto *vcrypto = vq->vdev->priv;
+	struct data_queue *data_vq = (struct data_queue *)data;
+	struct virtqueue *vq = data_vq->vq;
 	struct virtio_crypto_request *vc_req;
-	unsigned long flags;
 	unsigned int len;
-	unsigned int qid = vq->index;
 
-	spin_lock_irqsave(&vcrypto->data_vq[qid].lock, flags);
 	do {
 		virtqueue_disable_cb(vq);
 		while ((vc_req = virtqueue_get_buf(vq, &len)) != NULL) {
-			spin_unlock_irqrestore(
-				&vcrypto->data_vq[qid].lock, flags);
 			if (vc_req->alg_cb)
 				vc_req->alg_cb(vc_req, len);
-			spin_lock_irqsave(
-				&vcrypto->data_vq[qid].lock, flags);
 		}
 	} while (!virtqueue_enable_cb(vq));
-	spin_unlock_irqrestore(&vcrypto->data_vq[qid].lock, flags);
+}
+
+static void virtcrypto_dataq_callback(struct virtqueue *vq)
+{
+	struct virtio_crypto *vcrypto = vq->vdev->priv;
+	struct data_queue *dq = &vcrypto->data_vq[vq->index];
+
+	tasklet_schedule(&dq->done_task);
 }
 
 static int virtcrypto_find_vqs(struct virtio_crypto *vi)
@@ -149,6 +150,8 @@ static int virtcrypto_find_vqs(struct virtio_crypto *vi)
 			ret = -ENOMEM;
 			goto err_engine;
 		}
+		tasklet_init(&vi->data_vq[i].done_task, virtcrypto_done_task,
+				(unsigned long)&vi->data_vq[i]);
 	}
 
 	kfree(names);
-- 
2.43.0



