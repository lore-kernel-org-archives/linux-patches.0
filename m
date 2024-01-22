Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EAD512A17F;
	Tue, 23 Jan 2024 00:13:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968822; cv=none; b=RK4yEVGtHO/38H7d2v6gK+RHaEBZMc2DXqUBxPICMDyisldNPee0FAxUIT2a5vFJbUSvIpvf9scjAFD1yZGs2/lkglJKFLab+AzBxf18mz1kEjK5flPHLRrkF/l+jMqkjuqAaWbgjaT2IZi3iVNTj87a2PUi4X5907qoYbZYEEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968822; c=relaxed/simple;
	bh=DJwdlOy7XvVz057TZWfYYf1HRX7tQuw73MsZSJKN1R8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R82xhD8EHgEWf0RPKs86PYmO3EfIOLz1SOCxufqNuXUjXWPL+I77el6G5Veg298rLMeSof2lRb+b8TC3wFl3yeo3wZmcnH3eRFkVJf6nI/m7D9k8gaYo4bAz5D5DIZkuX7fBsTW6NgVNmwUatSNbA53SUNuTrpTfEhiLetu8Tq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TcYCQRTN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TcYCQRTN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 857ACC433F1;
	Tue, 23 Jan 2024 00:13:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968822;
	bh=DJwdlOy7XvVz057TZWfYYf1HRX7tQuw73MsZSJKN1R8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TcYCQRTNxL8y0O7HdIpeS/Q//5JKMv8jx8AlmwuixxKfStpNJyhrfVCdMZUUnjbS2
	 1LPLdiB2h0HxKyD3kLXvgeTgcamJFblS2OOiaEeK/yx2T98Y1BrfxCzSxMX/S/2rTF
	 oi1XeXhUfyxPFCZ6Mwb1h0pGmr/VC7rSuXEbG3rQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Halil Pasic <pasic@linux.ibm.com>,
	wangyangxin <wangyangxin1@huawei.com>,
	Gonglei <arei.gonglei@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 060/194] crypto: virtio - Handle dataq logic with tasklet
Date: Mon, 22 Jan 2024 15:56:30 -0800
Message-ID: <20240122235721.777696171@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235719.206965081@linuxfoundation.org>
References: <20240122235719.206965081@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 1c6e00da5a29..947a6e01d93f 100644
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
@@ -27,6 +28,7 @@ struct data_queue {
 	char name[32];
 
 	struct crypto_engine *engine;
+	struct tasklet_struct done_task;
 };
 
 struct virtio_crypto {
diff --git a/drivers/crypto/virtio/virtio_crypto_core.c b/drivers/crypto/virtio/virtio_crypto_core.c
index c8a962c62663..7c64862f1194 100644
--- a/drivers/crypto/virtio/virtio_crypto_core.c
+++ b/drivers/crypto/virtio/virtio_crypto_core.c
@@ -22,27 +22,28 @@ virtcrypto_clear_request(struct virtio_crypto_request *vc_req)
 	}
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
@@ -99,6 +100,8 @@ static int virtcrypto_find_vqs(struct virtio_crypto *vi)
 			ret = -ENOMEM;
 			goto err_engine;
 		}
+		tasklet_init(&vi->data_vq[i].done_task, virtcrypto_done_task,
+				(unsigned long)&vi->data_vq[i]);
 	}
 
 	kfree(names);
-- 
2.43.0



