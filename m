Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B03A23747
	for <patches@lists.linux.dev>; Mon,  6 Nov 2023 13:24:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UO8IEUPM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ADC3C433C9;
	Mon,  6 Nov 2023 13:23:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1699277039;
	bh=dOJ6oXmzZnnJqFPxAFjNIalyeo0Dq5mw77Bt3SFpdfE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UO8IEUPMiSf7fGj2YlSnPmSBhDrolXNEnSuNSE4WHmthOR4R36MviC8sIfPMW78x0
	 /4wO+PT7n1gDvkeTcJ6M0/xJEFZEpCF/vKsU41wIgMJwcDYmacuKbWotwf0uOvQkZW
	 heo67nS/DIr0M52+5NohSYRq43PjV3hihoUVrBR8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandru Matei <alexandru.matei@uipath.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 018/128] vsock/virtio: initialize the_virtio_vsock before using VQs
Date: Mon,  6 Nov 2023 14:02:58 +0100
Message-ID: <20231106130309.953109207@linuxfoundation.org>
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

From: Alexandru Matei <alexandru.matei@uipath.com>

[ Upstream commit 53b08c4985158430fd6d035fb49443bada535210 ]

Once VQs are filled with empty buffers and we kick the host, it can send
connection requests. If the_virtio_vsock is not initialized before,
replies are silently dropped and do not reach the host.

virtio_transport_send_pkt() can queue packets once the_virtio_vsock is
set, but they won't be processed until vsock->tx_run is set to true. We
queue vsock->send_pkt_work when initialization finishes to send those
packets queued earlier.

Fixes: 0deab087b16a ("vsock/virtio: use RCU to avoid use-after-free on the_virtio_vsock")
Signed-off-by: Alexandru Matei <alexandru.matei@uipath.com>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Link: https://lore.kernel.org/r/20231024191742.14259-1-alexandru.matei@uipath.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/vmw_vsock/virtio_transport.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
index f6fa26228e5cf..0b41028ed544a 100644
--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -590,6 +590,11 @@ static int virtio_vsock_vqs_init(struct virtio_vsock *vsock)
 
 	virtio_device_ready(vdev);
 
+	return 0;
+}
+
+static void virtio_vsock_vqs_start(struct virtio_vsock *vsock)
+{
 	mutex_lock(&vsock->tx_lock);
 	vsock->tx_run = true;
 	mutex_unlock(&vsock->tx_lock);
@@ -604,7 +609,16 @@ static int virtio_vsock_vqs_init(struct virtio_vsock *vsock)
 	vsock->event_run = true;
 	mutex_unlock(&vsock->event_lock);
 
-	return 0;
+	/* virtio_transport_send_pkt() can queue packets once
+	 * the_virtio_vsock is set, but they won't be processed until
+	 * vsock->tx_run is set to true. We queue vsock->send_pkt_work
+	 * when initialization finishes to send those packets queued
+	 * earlier.
+	 * We don't need to queue the other workers (rx, event) because
+	 * as long as we don't fill the queues with empty buffers, the
+	 * host can't send us any notification.
+	 */
+	queue_work(virtio_vsock_workqueue, &vsock->send_pkt_work);
 }
 
 static void virtio_vsock_vqs_del(struct virtio_vsock *vsock)
@@ -707,6 +721,7 @@ static int virtio_vsock_probe(struct virtio_device *vdev)
 		goto out;
 
 	rcu_assign_pointer(the_virtio_vsock, vsock);
+	virtio_vsock_vqs_start(vsock);
 
 	mutex_unlock(&the_virtio_vsock_mutex);
 
@@ -779,6 +794,7 @@ static int virtio_vsock_restore(struct virtio_device *vdev)
 		goto out;
 
 	rcu_assign_pointer(the_virtio_vsock, vsock);
+	virtio_vsock_vqs_start(vsock);
 
 out:
 	mutex_unlock(&the_virtio_vsock_mutex);
-- 
2.42.0



