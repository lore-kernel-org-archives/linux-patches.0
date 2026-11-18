Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060097;
	b=0Id3Ppo7d7/9YBO4J58U2vxFSzzyXJiVlBc5GU9564UgZvZ7tR43zBukocy4lQpRREQa
	 NMiKrq3AQdY4+MAdJLkDdNEq84lE/2apM3nty3Fdgs/iAI5wSrRwVJpKDuQ7vWFDM16T8
	 IfoTtOA9g0rx2RXfABzWXurf5GvvtPDJxN/57AJlOrbH3VMKQllEe4nx8LAWHiD1hmvdW
	 5C6vq7eaJYwBx7qFoGTaUFGDjzC5U7UBBwefPTme0I8CPfma0J2upU7UdBx4xQi76G9ds
	 KfjguPJ0e+aYBC99b4yj7ZAK3esKJEhh3koH/ojxW1AVFgwtnDEABGkg/lckOV90iCA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060097;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xrCu1CAI19aN2+RoCmyK006jlPCeeife61FAykB46tc=;
	b=eKDWpQpIigD+H/d0HrUYUX5UvdRi0/DO7lZoH8XeMtqfVFOmZYtlrtioO+KUC9RB/Gr6
	 JcdFCqawOerNaOFVOJTHIhBD4MarZO2hpPe5L0kqARYw65RbLzF4kZfuODbHCIpRbHaF1
	 DT2lRfOZIiVLYOJMY82T5FM1pf5WBQX3jXBdF9X/2Wtzu0Av6ELaQNEGVo6C1KLjrzYr0
	 pE5YwqyVj64MiIIA2cldXPuLK8EG831s0qLc7/22kZ8Xmqgc3ovvIAihwElNg8at3UVKC
	 qOYCMRRKQpAfDyLELv15xkDcdlQ2dhvGDfu478dwfEJuW6i41J4YxUrk7BeKUYWPPrw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Jk0KDp/U";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1C57606A326;
	Thu, 19 Nov 2026 03:48:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Jk0KDp/U
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEEB81F000C4;
	Thu, 19 Nov 2026 03:48:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060097;
	bh=xrCu1CAI19aN2+RoCmyK006jlPCeeife61FAykB46tc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Jk0KDp/U3FW0EJmG/sjQm4LcH41G3VI9rQdFmt5NZ5hedAe5U+GX46gAqRKzIIxNU
	 4bFSf78qFcstLpM1l4EjRhs6Q9I3JxJogY+nhv2ZABGwszdI++BuMPp3gqNOrQPiiT
	 Y9G7vwLzxrNH1jyB/ancS/EKCqo1CjYYUZSE3tGU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Wang <jasowangio@gmail.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Cong Zhang <cong.zhang@oss.qualcomm.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1078/1848] virtio_blk: use synchronous quiesce in virtblk_freeze_priv()
Date: Wed, 18 Nov 2026 15:51:56 +0100
Message-ID: <20261118150003.332106030@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cong Zhang <cong.zhang@oss.qualcomm.com>

[ Upstream commit 6c6dec7883f8eb10b326bc9d109a4990c885d949 ]

blk_mq_run_work_fn() can call blk_mq_sched_dispatch_requests() through
blk_mq_run_dispatch_ops(). The dispatcher checks QUEUE_FLAG_QUIESCED
while the flag is clear. It can then be preempted before it gets a
request. At that time, it has no queue usage reference, so
blk_mq_freeze_queue() does not wait for it.

virtblk_freeze_priv() then calls blk_mq_quiesce_queue_nowait() and
blk_mq_unfreeze_queue(). A new request can enter the queue. The old
dispatcher can run again, use its old flag check, get the new request,
and call virtio_queue_rq(). At the same time, virtblk_freeze_priv() can
reset the device, delete the virtqueues, and free vblk->vqs. The old
dispatcher can then use a deleted virtqueue or a NULL vblk->vqs, and the
kernel can crash.

Fix this by using blk_mq_quiesce_queue(), which waits for dispatch code
that was already running. Keep the existing freeze and unfreeze order.
The queue remains quiesced until virtblk_restore_priv() calls
blk_mq_unquiesce_queue().

Fixes: 7678abee0867 ("virtio-blk: don't keep queue frozen during system suspend")
Cc: stable@vger.kernel.org
Acked-by: Jason Wang <jasowangio@gmail.com>
Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
Signed-off-by: Cong Zhang <cong.zhang@oss.qualcomm.com>
Link: https://lore.kernel.org/20260911-virtblk_sync_quiesce-v1-1-a883f8f31258@oss.qualcomm.com
Link: https://patch.msgid.link/20261103-virtblk_sync_quiesce-v3-1-f40233f9bdd9@oss.qualcomm.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
[ sashal: adjusted context to virtblk_freeze(), which uses queue freeze and unfreeze calls without memflags ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/virtio_blk.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index c87c6a4eb3b33..8a492dd94fa11 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -955,7 +955,7 @@ static int virtblk_freeze(struct virtio_device *vdev)
 
 	/* Ensure no requests in virtqueues before deleting vqs. */
 	blk_mq_freeze_queue(q);
-	blk_mq_quiesce_queue_nowait(q);
+	blk_mq_quiesce_queue(q);
 	blk_mq_unfreeze_queue(q);
 
 	/* Ensure we don't receive any more interrupts */
-- 
2.53.0



