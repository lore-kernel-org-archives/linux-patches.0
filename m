Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C48B8168C5
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:43:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 362BBC433D2;
	Mon,  8 May 2023 10:43:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683542634;
	bh=Bu8HIkeBAP1y0xNYvXvXkiL3VISZosrzS2gNSAYHDeM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AQmcfNia0Qu2DkGHQaklcpaLE1fBmgfboW9h+YBfNIiDJNV/3d8qk9PWpBUKLQnb7
	 AejRI5NEdj1tpxekInN2YcdcCfOJVntdMzcAV7+o0RCMifCwsJf9Xkt2ZU7EYoCzn8
	 pp0hAOGa8T+0qHyptDqrulQ71NEFaztdzqV2yGdE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Albert Huang <huangjie.albert@bytedance.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 499/663] virtio_ring: dont update event idx on get_buf
Date: Mon,  8 May 2023 11:45:25 +0200
Message-Id: <20230508094444.711789573@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094428.384831245@linuxfoundation.org>
References: <20230508094428.384831245@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Albert Huang <huangjie.albert@bytedance.com>

[ Upstream commit 6c0b057cec5eade4c3afec3908821176931a9997 ]

In virtio_net, if we disable napi_tx, when we trigger a tx interrupt,
the vq->event_triggered will be set to true. It is then never reset
until we explicitly call virtqueue_enable_cb_delayed or
virtqueue_enable_cb_prepare.

If we disable the napi_tx, virtqueue_enable_cb* will only be called when
the tx ring is getting relatively empty.

Since event_triggered is true, VRING_AVAIL_F_NO_INTERRUPT or
VRING_PACKED_EVENT_FLAG_DISABLE will not be set. As a result we update
vring_used_event(&vq->split.vring) or vq->packed.vring.driver->off_wrap
every time we call virtqueue_get_buf_ctx. This causes more interrupts.

To summarize:
1) event_triggered was set to true in vring_interrupt()
2) after this nothing will happen in virtqueue_disable_cb() so
   VRING_AVAIL_F_NO_INTERRUPT is not set in avail_flags_shadow
3) virtqueue_get_buf_ctx_split() will still think the cb is enabled
   and then it will publish a new event index

To fix:
update VRING_AVAIL_F_NO_INTERRUPT or VRING_PACKED_EVENT_FLAG_DISABLE in
the vq when we call virtqueue_disable_cb even when event_triggered is
true.

Tested with iperf:
iperf3 tcp stream:
vm1 -----------------> vm2
vm2 just receives tcp data stream from vm1, and sends acks to vm1,
there are many tx interrupts in vm2.
with the patch applied there are just a few tx interrupts.

v2->v3:
-update the interrupt disable flag even with the event_triggered is set,
-instead of checking whether event_triggered is set in
-virtqueue_get_buf_ctx_{packed/split}, will cause the drivers  which have
-not called virtqueue_{enable/disable}_cb to miss notifications.

v3->v4:
-remove change for
-"if (vq->packed.event_flags_shadow != VRING_PACKED_EVENT_FLAG_DISABLE)"
-in virtqueue_disable_cb_packed

Fixes: 8d622d21d248 ("virtio: fix up virtio_disable_cb")
Signed-off-by: Albert Huang <huangjie.albert@bytedance.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Jason Wang <jasowang@redhat.com>
Message-Id: <20230329102300.61000-1-huangjie.albert@bytedance.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/virtio/virtio_ring.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index 723c4e29e1d3b..5bee2ab62111b 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -848,6 +848,14 @@ static void virtqueue_disable_cb_split(struct virtqueue *_vq)
 
 	if (!(vq->split.avail_flags_shadow & VRING_AVAIL_F_NO_INTERRUPT)) {
 		vq->split.avail_flags_shadow |= VRING_AVAIL_F_NO_INTERRUPT;
+
+		/*
+		 * If device triggered an event already it won't trigger one again:
+		 * no need to disable.
+		 */
+		if (vq->event_triggered)
+			return;
+
 		if (vq->event)
 			/* TODO: this is a hack. Figure out a cleaner value to write. */
 			vring_used_event(&vq->split.vring) = 0x0;
@@ -1687,6 +1695,14 @@ static void virtqueue_disable_cb_packed(struct virtqueue *_vq)
 
 	if (vq->packed.event_flags_shadow != VRING_PACKED_EVENT_FLAG_DISABLE) {
 		vq->packed.event_flags_shadow = VRING_PACKED_EVENT_FLAG_DISABLE;
+
+		/*
+		 * If device triggered an event already it won't trigger one again:
+		 * no need to disable.
+		 */
+		if (vq->event_triggered)
+			return;
+
 		vq->packed.vring.driver->flags =
 			cpu_to_le16(vq->packed.event_flags_shadow);
 	}
@@ -2309,12 +2325,6 @@ void virtqueue_disable_cb(struct virtqueue *_vq)
 {
 	struct vring_virtqueue *vq = to_vvq(_vq);
 
-	/* If device triggered an event already it won't trigger one again:
-	 * no need to disable.
-	 */
-	if (vq->event_triggered)
-		return;
-
 	if (vq->packed_ring)
 		virtqueue_disable_cb_packed(_vq);
 	else
-- 
2.39.2



