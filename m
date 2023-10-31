Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56EBB208CF
	for <patches@lists.linux.dev>; Tue, 31 Oct 2023 17:46:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KVNuoIMB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8119C433C8;
	Tue, 31 Oct 2023 17:46:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698774389;
	bh=y32jm0l3zJZGS9+GA7bvRV8RCI0oTp6f/dUcXTOx2y0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KVNuoIMB1mlcTzG69d8gMXK6o7L7A+qQIlKydh6DozUS7Y7sSIGQgq/RPTQxpsADi
	 w7krISilcoB1z6uKlC7r4rPNTS+bVPXyVryn6qyypWz/VFiTMtMmQ8aWMLeBDuaJc5
	 zOmwacX5on0L4dmKmyie5lWU7sEx6ewvpvZ9oUZs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Gonglei (Arei)" <arei.gonglei@huawei.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	zhenwei pi <pizhenwei@bytedance.com>
Subject: [PATCH 6.5 011/112] virtio-crypto: handle config changed by work queue
Date: Tue, 31 Oct 2023 18:00:12 +0100
Message-ID: <20231031165901.647488493@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231031165901.318222981@linuxfoundation.org>
References: <20231031165901.318222981@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: zhenwei pi <pizhenwei@bytedance.com>

commit fa2e6947aa8844f25f5bad0d8cd1a541d9bc83eb upstream.

MST pointed out: config change callback is also handled incorrectly
in this driver, it takes a mutex from interrupt context.

Handle config changed by work queue instead.

Cc: stable@vger.kernel.org
Cc: Gonglei (Arei) <arei.gonglei@huawei.com>
Cc: Halil Pasic <pasic@linux.ibm.com>
Cc: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: zhenwei pi <pizhenwei@bytedance.com>
Message-Id: <20231007064309.844889-1-pizhenwei@bytedance.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/virtio/virtio_crypto_common.h |    3 +++
 drivers/crypto/virtio/virtio_crypto_core.c   |   14 +++++++++++++-
 2 files changed, 16 insertions(+), 1 deletion(-)

--- a/drivers/crypto/virtio/virtio_crypto_common.h
+++ b/drivers/crypto/virtio/virtio_crypto_common.h
@@ -35,6 +35,9 @@ struct virtio_crypto {
 	struct virtqueue *ctrl_vq;
 	struct data_queue *data_vq;
 
+	/* Work struct for config space updates */
+	struct work_struct config_work;
+
 	/* To protect the vq operations for the controlq */
 	spinlock_t ctrl_lock;
 
--- a/drivers/crypto/virtio/virtio_crypto_core.c
+++ b/drivers/crypto/virtio/virtio_crypto_core.c
@@ -335,6 +335,14 @@ static void virtcrypto_del_vqs(struct vi
 	virtcrypto_free_queues(vcrypto);
 }
 
+static void vcrypto_config_changed_work(struct work_struct *work)
+{
+	struct virtio_crypto *vcrypto =
+		container_of(work, struct virtio_crypto, config_work);
+
+	virtcrypto_update_status(vcrypto);
+}
+
 static int virtcrypto_probe(struct virtio_device *vdev)
 {
 	int err = -EFAULT;
@@ -454,6 +462,8 @@ static int virtcrypto_probe(struct virti
 	if (err)
 		goto free_engines;
 
+	INIT_WORK(&vcrypto->config_work, vcrypto_config_changed_work);
+
 	return 0;
 
 free_engines:
@@ -490,6 +500,7 @@ static void virtcrypto_remove(struct vir
 
 	dev_info(&vdev->dev, "Start virtcrypto_remove.\n");
 
+	flush_work(&vcrypto->config_work);
 	if (virtcrypto_dev_started(vcrypto))
 		virtcrypto_dev_stop(vcrypto);
 	virtio_reset_device(vdev);
@@ -504,7 +515,7 @@ static void virtcrypto_config_changed(st
 {
 	struct virtio_crypto *vcrypto = vdev->priv;
 
-	virtcrypto_update_status(vcrypto);
+	schedule_work(&vcrypto->config_work);
 }
 
 #ifdef CONFIG_PM_SLEEP
@@ -512,6 +523,7 @@ static int virtcrypto_freeze(struct virt
 {
 	struct virtio_crypto *vcrypto = vdev->priv;
 
+	flush_work(&vcrypto->config_work);
 	virtio_reset_device(vdev);
 	virtcrypto_free_unused_reqs(vcrypto);
 	if (virtcrypto_dev_started(vcrypto))


