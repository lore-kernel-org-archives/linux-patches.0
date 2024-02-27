Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FAAD16423;
	Tue, 27 Feb 2024 14:04:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042652; cv=none; b=c9L6E2VzuEhGgXy3WR29Cu8de3gpdjSbrUpmDWixCSKom8INgF3aeahGmGg4uy2RfvIcM2FHAohXelLLlyC9NmjSG7P2Jz3EHtii8cmuYFwA26/0Xk4OpIJ0mb+YP6jRaBYwkinvKSy6M7LrdGJUbK02ICwu/hzCXRO2Q78uw9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042652; c=relaxed/simple;
	bh=SQXOzHjjQgoELWylwPaTeWYZ2033gWm+svWIgE3cJF4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Awxbqm+CgelB54aflWMgXcEdEQvqmI65Wqc5pGSmGlx4qiKbThu6wPtbPt19yoTpRaDFZ52oqeFSttSz51JOb1ZXqBKksLiWWANP5kakRRgwq2VYafyk3R+EAql4ZJ5fObDfYVRSOtRffkIxXusH79uS2E7r/qmHgLxjkSM7NB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0bHKi+NB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0bHKi+NB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A16EDC433F1;
	Tue, 27 Feb 2024 14:04:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042652;
	bh=SQXOzHjjQgoELWylwPaTeWYZ2033gWm+svWIgE3cJF4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0bHKi+NBFITGNsI5KZ3Ld6csQWQIoOd4fkALWVlwr2iumd/Ktr1lxH6KWSxzdPLPw
	 e6gFefBzVpuOnjePFHaoz3huCC36IhVORzi7GmOBmJlJ3yyLKNcvVxm4XGTi9BlufK
	 9CNwO/9WqvIHA9C/wEJ0gvEzUxnnuNHUVLDW5Tj4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yi Sun <yi.sun@unisoc.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 072/245] virtio-blk: Ensure no requests in virtqueues before deleting vqs.
Date: Tue, 27 Feb 2024 14:24:20 +0100
Message-ID: <20240227131617.580754593@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131615.098467438@linuxfoundation.org>
References: <20240227131615.098467438@linuxfoundation.org>
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

From: Yi Sun <yi.sun@unisoc.com>

[ Upstream commit 4ce6e2db00de8103a0687fb0f65fd17124a51aaa ]

Ensure no remaining requests in virtqueues before resetting vdev and
deleting virtqueues. Otherwise these requests will never be completed.
It may cause the system to become unresponsive.

Function blk_mq_quiesce_queue() can ensure that requests have become
in_flight status, but it cannot guarantee that requests have been
processed by the device. Virtqueues should never be deleted before
all requests become complete status.

Function blk_mq_freeze_queue() ensure that all requests in virtqueues
become complete status. And no requests can enter in virtqueues.

Signed-off-by: Yi Sun <yi.sun@unisoc.com>
Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
Link: https://lore.kernel.org/r/20240129085250.1550594-1-yi.sun@unisoc.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/virtio_blk.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index affeca0dbc7ea..7f73e7447ecb5 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -989,14 +989,15 @@ static int virtblk_freeze(struct virtio_device *vdev)
 {
 	struct virtio_blk *vblk = vdev->priv;
 
+	/* Ensure no requests in virtqueues before deleting vqs. */
+	blk_mq_freeze_queue(vblk->disk->queue);
+
 	/* Ensure we don't receive any more interrupts */
 	vdev->config->reset(vdev);
 
 	/* Make sure no work handler is accessing the device. */
 	flush_work(&vblk->config_work);
 
-	blk_mq_quiesce_queue(vblk->disk->queue);
-
 	vdev->config->del_vqs(vdev);
 	kfree(vblk->vqs);
 
@@ -1014,7 +1015,7 @@ static int virtblk_restore(struct virtio_device *vdev)
 
 	virtio_device_ready(vdev);
 
-	blk_mq_unquiesce_queue(vblk->disk->queue);
+	blk_mq_unfreeze_queue(vblk->disk->queue);
 	return 0;
 }
 #endif
-- 
2.43.0



