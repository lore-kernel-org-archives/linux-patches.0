Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3155C23747
	for <patches@lists.linux.dev>; Mon,  6 Nov 2023 13:23:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MusVZZX7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A232AC433C7;
	Mon,  6 Nov 2023 13:23:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1699277037;
	bh=vnzC009FMe8h3dv46GyzNFStdoZi33Jm9aiWGJymyQY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MusVZZX7o/Dwl1WQy7VDYOeL2zH2UbquXygkO6Uj0b+iwfQlQCVhh6xGfkNIrdc85
	 kBu3jULBBgSGj0/yHq94ZMWGDuzOmtErUggzIZFMOXPmP7D6CR7f29/llZcpmBopLD
	 8cUNbeE9bgi/+33SRJKMMlcyD7kaEQiJKmkcl/7I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefano Garzarella <sgarzare@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 017/128] vsock/virtio: add support for device suspend/resume
Date: Mon,  6 Nov 2023 14:02:57 +0100
Message-ID: <20231106130309.904862027@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231106130309.112650042@linuxfoundation.org>
References: <20231106130309.112650042@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefano Garzarella <sgarzare@redhat.com>

[ Upstream commit bd50c5dc182b0a52599f87b429f9a5a9cbfc9b1c ]

Implement .freeze and .restore callbacks of struct virtio_driver
to support device suspend/resume.

During suspension all connected sockets are reset and VQs deleted.
During resume the VQs are re-initialized.

Reported by: Vilas R K <vilas.r.k@intel.com>
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 53b08c498515 ("vsock/virtio: initialize the_virtio_vsock before using VQs")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/vmw_vsock/virtio_transport.c | 47 ++++++++++++++++++++++++++++++++
 1 file changed, 47 insertions(+)

diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
index e4773ae6a54d6..f6fa26228e5cf 100644
--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -743,6 +743,49 @@ static void virtio_vsock_remove(struct virtio_device *vdev)
 	kfree(vsock);
 }
 
+#ifdef CONFIG_PM_SLEEP
+static int virtio_vsock_freeze(struct virtio_device *vdev)
+{
+	struct virtio_vsock *vsock = vdev->priv;
+
+	mutex_lock(&the_virtio_vsock_mutex);
+
+	rcu_assign_pointer(the_virtio_vsock, NULL);
+	synchronize_rcu();
+
+	virtio_vsock_vqs_del(vsock);
+
+	mutex_unlock(&the_virtio_vsock_mutex);
+
+	return 0;
+}
+
+static int virtio_vsock_restore(struct virtio_device *vdev)
+{
+	struct virtio_vsock *vsock = vdev->priv;
+	int ret;
+
+	mutex_lock(&the_virtio_vsock_mutex);
+
+	/* Only one virtio-vsock device per guest is supported */
+	if (rcu_dereference_protected(the_virtio_vsock,
+				lockdep_is_held(&the_virtio_vsock_mutex))) {
+		ret = -EBUSY;
+		goto out;
+	}
+
+	ret = virtio_vsock_vqs_init(vsock);
+	if (ret < 0)
+		goto out;
+
+	rcu_assign_pointer(the_virtio_vsock, vsock);
+
+out:
+	mutex_unlock(&the_virtio_vsock_mutex);
+	return ret;
+}
+#endif /* CONFIG_PM_SLEEP */
+
 static struct virtio_device_id id_table[] = {
 	{ VIRTIO_ID_VSOCK, VIRTIO_DEV_ANY_ID },
 	{ 0 },
@@ -760,6 +803,10 @@ static struct virtio_driver virtio_vsock_driver = {
 	.id_table = id_table,
 	.probe = virtio_vsock_probe,
 	.remove = virtio_vsock_remove,
+#ifdef CONFIG_PM_SLEEP
+	.freeze = virtio_vsock_freeze,
+	.restore = virtio_vsock_restore,
+#endif
 };
 
 static int __init virtio_vsock_init(void)
-- 
2.42.0



