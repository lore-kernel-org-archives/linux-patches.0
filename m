Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C9543F5BFC;
	Wed, 30 Sep 2026 16:21:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785283; cv=none; b=lQ3+TQCyZawpV0AQqkPxPpLHBqydh68LjE5I40leWg1ELO2JCNVxaUCHtt6kTkAklsRL9ECMWRI+gj6AoMtr8v0bsk4kEPRmgikMaDaX8z8iQyk5pI9Fq9W8z0WPnZTgnfUU0KAPIJoB/Rc5Q2L9vvdNtp7wb3t9g7Et7D85LRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785283; c=relaxed/simple;
	bh=ba69bqPTgMyHLMCAJ3SZn7vlARmBBjxSX1l7Je9gg6Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nizq0yHfBUQKXSL5JyJ5dBmInOoetfjwVWS9Pt7onPeLpWhsCeCHscJf0/ZbjhLDHplZfcOaqF483NDovKmFlJ3vW0JL7Zgwh7QmVjQJSD7hJ1MssIY5dvOnFtTZhg0DScXxnYomcec6bnRnxIDNKbJxAZyvLvWFSYC8l7MPcnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=InJ74BQ0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="InJ74BQ0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43ECD1F00898;
	Wed, 30 Sep 2026 16:21:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785276;
	bh=c35yDA0WWUx0wWkseLB4iFiiXL1glttj1Tu8ZPNcEQY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=InJ74BQ0/BaxkpRei+kqYYT8T4iBI7zKm7r0P+7puwckzFEzV8RkZTSWxZtONgAZ1
	 IODp5EGPGUSinFr/AOMKq9+g8R1JRnVEr/0LcEt5EqDSG0CNqD62nypGEqLYtdWkR/
	 ZGD93gSE19hcAIXUgogMAdQhK2twgJ5P3+v6/GXc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 445/982] virtio_input: stop callbacks before unregistering input device
Date: Wed, 30 Sep 2026 17:19:41 +0200
Message-ID: <20260930152426.353362495@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 54d90006e598f..cf8f179c896b8 100644
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
@@ -347,8 +350,9 @@ static void virtinput_remove(struct virtio_device *vdev)
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



