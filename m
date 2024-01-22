Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5957E2B9B7;
	Tue, 23 Jan 2024 01:41:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974115; cv=none; b=h7zq2JvU5IFMrq18bUUBKq7mtSQv2Kx/pCf37JHiUz8zGBzNU4ytUDENBZ3k/gbpc2JYbZgHynFJHZQ9/0zLv7Wo5t1v2seMq0tnblUShiBvzvspe2J04yBKnjUnOLxOsqoz1mp9PLFx88Ovk5oCX8RR3G4re9yXgtfq3kP9QyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974115; c=relaxed/simple;
	bh=WWSGNH92+pzffta9sezzGIRhgquT/rtI/4JHx6duEnw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b6qsf9fVCj+OhtLNoDLyAH5gPncqun40DM3uA1L4xLyzJ5mGdHOv68tcktAQj31jx8jP6WCelaWOw2/eUVM+taPuwT9BGQ0pMWKp5z4wNzlay1NpOmfXRERTxczb1OJYSKfcnrXV3zvqHszhSdjdE/W9hjidMQdnqDmpiwzJ20Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1VmW+H0i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1VmW+H0i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A12EEC433A6;
	Tue, 23 Jan 2024 01:41:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974114;
	bh=WWSGNH92+pzffta9sezzGIRhgquT/rtI/4JHx6duEnw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1VmW+H0iN/r+Cc0g480tXthQZWQG2ntuQLC3lCcr9YzRETlMVrrTMaMXeZELvIhLL
	 yZLw4BeJK1pWXjMei2iGhQYe+NIbEwM09x6IBGX5buA08TmFbcadB092/ZZssLh3SG
	 QD2X4KohcNCQlRQv/XcUPiO2ktm6yAPLdQsdDaOo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Halil Pasic <pasic@linux.ibm.com>,
	wangyangxin <wangyangxin1@huawei.com>,
	Gonglei <arei.gonglei@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 044/583] crypto: virtio - Handle dataq logic with tasklet
Date: Mon, 22 Jan 2024 15:51:35 -0800
Message-ID: <20240122235813.489668985@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 154590e1f764..7059bbe5a2eb 100644
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
index 43a0838d31ff..428d76562447 100644
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
@@ -150,6 +151,8 @@ static int virtcrypto_find_vqs(struct virtio_crypto *vi)
 			ret = -ENOMEM;
 			goto err_engine;
 		}
+		tasklet_init(&vi->data_vq[i].done_task, virtcrypto_done_task,
+				(unsigned long)&vi->data_vq[i]);
 	}
 
 	kfree(names);
-- 
2.43.0



