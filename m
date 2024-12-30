Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EE7A15E8B;
	Mon, 30 Dec 2024 15:50:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735573841; cv=none; b=sSSefrtTxQPGj22jxzcijtz4oD89kkuTVnUtVc2sRYiiIwrBAzptQcZVtapk+NEvB7D2eUkRCtqBKMpO6PDOtUyiBuox/apyRGbN/CBP6WK4gKAw5dyXItu1z/izfHxInS+0CzAodrd4goXlbkLerkKVhhoSG7h53b3THFkU0lE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735573841; c=relaxed/simple;
	bh=BVnUKsU20NhoQin4Fxh0ljKC0RMutULU2bo7fC8c4v0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LSTrIVPgL4yh9yFsukpzJoDVpIijJuP73ZNOQYzSB1wOYU1R1IuP1PRNypFArZTg4DZxHa3Vt7ZiH8xxgUQkGa+QZ6Rme7Shp8ki2PHso2tnwtauf0g+hSrBn0HUQaZhqlvh4n6urmLSzMnptjKvLZxlVGOvzi/aTuVloN/Ldk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ALSRnwQn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ALSRnwQn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E328AC4CED0;
	Mon, 30 Dec 2024 15:50:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735573841;
	bh=BVnUKsU20NhoQin4Fxh0ljKC0RMutULU2bo7fC8c4v0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ALSRnwQnNkb2atQ4aki4+vFhhbxq06GBFiGSXVdroXOTJRdAPlgeLPg6CBCrL8Wv3
	 xD7APxu+wdBNWq2YU63rhDzb2jdIctkVlIWcgkB1HV+t8oH1QepQ420cpU3QBm9nCb
	 kgsgGlNW3xXojNhTmL0ouFUeSIx//SOVD+EPhcSg=
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
Subject: [PATCH 6.6 49/86] virtio-blk: dont keep queue frozen during system suspend
Date: Mon, 30 Dec 2024 16:42:57 +0100
Message-ID: <20241230154213.588811782@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154211.711515682@linuxfoundation.org>
References: <20241230154211.711515682@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 997106fe73e4..65a1f1576e55 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -1624,9 +1624,12 @@ static void virtblk_remove(struct virtio_device *vdev)
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
 	virtio_reset_device(vdev);
@@ -1650,8 +1653,8 @@ static int virtblk_restore(struct virtio_device *vdev)
 		return ret;
 
 	virtio_device_ready(vdev);
+	blk_mq_unquiesce_queue(vblk->disk->queue);
 
-	blk_mq_unfreeze_queue(vblk->disk->queue);
 	return 0;
 }
 #endif
-- 
2.39.5



