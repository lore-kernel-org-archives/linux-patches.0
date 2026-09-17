Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 296B24078D3;
	Thu, 17 Sep 2026 18:45:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789670748; cv=none; b=pRi3SM1XOs7lVEPE85L7U86ao9MsLitst9w54LN/gGXk3KiNJemSTB/jpX+k8U1Z0aWitXbXZizENKhs8ItEbZ68hRhnqWGbMMZnCZ3imkly7jYW5DdZ2vUnF/2kFL8IrYvHHJL/6YeWt8uzquX/vlfdDVUoL1twejcMxvjCoRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789670748; c=relaxed/simple;
	bh=kFfdRCYV4khLP7w8CMh/z87WZnA8yH30LzZJYwLKE8E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bl407gq+0T9IqD7EHq5cTlit5qgkJjkYDNbyHw/z7zZ7g0YHLyswl4MurFKNlRnkPJ0DlTXFHMc1QmcZrAo2+Y7eIZNXYY2YuvEO/2Y7MY1e4ik0D7niehUvRz7xDH1szx0Bu5AqpXRTKOkdVdupaGB4r5CPSWDmDyXClVhHGgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J7K67XqT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J7K67XqT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81F131F000FF;
	Thu, 17 Sep 2026 18:45:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789670747;
	bh=tiBQjeofGT6QpvmFVeIxHnTf0NlGra2y9OOjAkSE/uk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J7K67XqTfMsZrSILP9vQzitO96b3fZCCd1h4EqYKWfu+maX8COeq03MnV4NDNmxrD
	 0vCTem4umheMq19zVdZHsDk4B0HdJBaQbJghZ5cdBddA00trdpyTwL7owDO+hqHanS
	 QWo4bFLUhreUuHPWk3TKhOcaugiqb0q2D0TXETSg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0720/1102] virtio_input: stop callbacks before unregistering input device
Date: Thu, 17 Sep 2026 16:11:03 +0100
Message-ID: <20260917151558.423350217@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit d7808b37da0a619cf1fa541c2384e783fecc2480 ]

virtinput_remove() unregisters the input device before resetting the
virtio device. virtinput_recv_events() drops vi->lock around input_event(),
so clearing vi->ready does not stop a callback that passed the entry check.
It can still use vi->idev, requeue buffers and kick the queue.

Reset first, as virtinput_freeze() already does. With the preceding core
change, reset waits for callbacks before input_unregister_device() can
free vi->idev. Recheck vi->ready after taking the lock again: keep draining
completed events so an input packet is not truncated, but stop requeueing
buffers and kicking the queue.

With evdev attached, input_unregister_handle() currently waits for an RCU
grace period, which also waits out IRQ callbacks. This masks the lifetime
bug on PCI and MMIO, but does not protect sleepable callbacks on other
transports.

Fixes: 271c865161c5 ("Add virtio-input driver.")
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-ID: <20260905152059.89560-3-kmehltretter@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/virtio/virtio_input.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/virtio/virtio_input.c b/drivers/virtio/virtio_input.c
index c5a1959035d50..177894121f3a7 100644
--- a/drivers/virtio/virtio_input.c
+++ b/drivers/virtio/virtio_input.c
@@ -46,9 +46,12 @@ static void virtinput_recv_events(struct virtqueue *vq)
 				    le16_to_cpu(event->code),
 				    le32_to_cpu(event->value));
 			spin_lock_irqsave(&vi->lock, flags);
+			if (!vi->ready)
+				continue;
 			virtinput_queue_evtbuf(vi, event);
 		}
-		virtqueue_kick(vq);
+		if (vi->ready)
+			virtqueue_kick(vq);
 	}
 	spin_unlock_irqrestore(&vi->lock, flags);
 }
@@ -348,8 +351,9 @@ static void virtinput_remove(struct virtio_device *vdev)
 	vi->ready = false;
 	spin_unlock_irqrestore(&vi->lock, flags);
 
-	input_unregister_device(vi->idev);
+	/* Callbacks use vi->idev. */
 	virtio_reset_device(vdev);
+	input_unregister_device(vi->idev);
 	while ((buf = virtqueue_detach_unused_buf(vi->sts)) != NULL)
 		kfree(buf);
 	vdev->config->del_vqs(vdev);
-- 
2.53.0



