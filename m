Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B9BA1DB92A;
	Mon,  6 Jan 2025 15:44:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178283; cv=none; b=Z93Lug0CQlNJyw5PcAEMBwFjJHT77+hF3lBrB92gUxgBfKxEU+umwXcLyIwq6d6s332sLOh7Snquotth9jAxUmFBN2agiEhPfAUc4+CTgKUEU9RR2eK+bOfKz/KkdzkITdvJ+uWMttkQEzJMx6lajRvV+UgaTMX3r0fTxQbnjiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178283; c=relaxed/simple;
	bh=5pEu7Acu9NAktVozHjcmnHpkbp8MFtpAsBqMbLGJRiM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kea/ZLaPbKfEYtGGkhOL+caAAumxeY0dkARuGCCzNe8/b5996byTM3HWWOAy5kURxXyh0EGFh9RR2DRfJlA9P78r081fUcl37QNpoticgCysgZZNdWdPE9cDA5VFpi512F+FuCsmoKgqcjm620+qPNbRtDSp4axnHGbkF5dBOVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wrQhk0Dn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wrQhk0Dn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91F72C4CED2;
	Mon,  6 Jan 2025 15:44:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178283;
	bh=5pEu7Acu9NAktVozHjcmnHpkbp8MFtpAsBqMbLGJRiM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wrQhk0DnA2t9dnM8Q0i76BTN0G1Fwzdj3UCCcfcPIxmcspB0PR/97R457v6B9yWNr
	 xHpQuiUfsryCG9b7NJE69CxEfAKDsNCRcEPWMbx+8qIulcZG7wFPkgp7+7YNuHU79f
	 3qL4NH79eJAwLvoW6DzvW4+gWlevyODQfq8lFL1U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yi Sun <yi.sun@unisoc.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	virtualization@lists.linux.dev,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 067/138] virtio-blk: dont keep queue frozen during system suspend
Date: Mon,  6 Jan 2025 16:16:31 +0100
Message-ID: <20250106151135.770816233@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151133.209718681@linuxfoundation.org>
References: <20250106151133.209718681@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit 7678abee0867e6b7fb89aa40f6e9f575f755fb37 ]

Commit 4ce6e2db00de ("virtio-blk: Ensure no requests in virtqueues before
deleting vqs.") replaces queue quiesce with queue freeze in virtio-blk's
PM callbacks. And the motivation is to drain inflight IOs before suspending.

block layer's queue freeze looks very handy, but it is also easy to cause
deadlock, such as, any attempt to call into bio_queue_enter() may run into
deadlock if the queue is frozen in current context. There are all kinds
of ->suspend() called in suspend context, so keeping queue frozen in the
whole suspend context isn't one good idea. And Marek reported lockdep
warning[1] caused by virtio-blk's freeze queue in virtblk_freeze().

[1] https://lore.kernel.org/linux-block/ca16370e-d646-4eee-b9cc-87277c89c43c@samsung.com/

Given the motivation is to drain in-flight IOs, it can be done by calling
freeze & unfreeze, meantime restore to previous behavior by keeping queue
quiesced during suspend.

Cc: Yi Sun <yi.sun@unisoc.com>
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Stefan Hajnoczi <stefanha@redhat.com>
Cc: virtualization@lists.linux.dev
Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Acked-by: Stefan Hajnoczi <stefanha@redhat.com>
Link: https://lore.kernel.org/r/20241112125821.1475793-1-ming.lei@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/virtio_blk.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 7eae3f373233..28ea9b511fd0 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -951,9 +951,12 @@ static void virtblk_remove(struct virtio_device *vdev)
 static int virtblk_freeze(struct virtio_device *vdev)
 {
 	struct virtio_blk *vblk = vdev->priv;
+	struct request_queue *q = vblk->disk->queue;
 
 	/* Ensure no requests in virtqueues before deleting vqs. */
-	blk_mq_freeze_queue(vblk->disk->queue);
+	blk_mq_freeze_queue(q);
+	blk_mq_quiesce_queue_nowait(q);
+	blk_mq_unfreeze_queue(q);
 
 	/* Ensure we don't receive any more interrupts */
 	vdev->config->reset(vdev);
@@ -977,8 +980,8 @@ static int virtblk_restore(struct virtio_device *vdev)
 		return ret;
 
 	virtio_device_ready(vdev);
+	blk_mq_unquiesce_queue(vblk->disk->queue);
 
-	blk_mq_unfreeze_queue(vblk->disk->queue);
 	return 0;
 }
 #endif
-- 
2.39.5



