Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590378;
	b=u78K+pKiuZT8nMNv00MBiae5NQx5NQULo7MUU/MqpzSLjYfsGd9fttyplHGWDrmklQTp
	 8oNr2vBmw5CkyeyZSkJmTocsxsX9SyR7ElI8k+seUHmLDiD3fDGOWlQllr3fgaLgPOkBv
	 y2w3Fq2YnOjZ4DecPMAh/gz7nEb0lr/Mrv01ay+J9UBWf+V8bZWnPGHYHei2qc/s2xzAs
	 902N2QH3jZIneQANE44jYtEyNy0Ns90pD1e9ioykSE2Xx6Kr8n7QwhK0V0W6cqYMH1K6W
	 gH5II4rZBTppKdN6MeQ095EZG7NVkRlkb4QpNk+LE8bMYQiLI/rb719IHwvAAQ+hVzA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590378;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OlKRAiEucQJUPMkIpisDR4+oy9f3n0Zr0nK5Y78cry8=;
	b=RZNfS/A+4pC2iwvXtTcTwg2NLqTjqfbG+ACq292gc6AZ3cldwtHl2NjU8pL7qTZ10Whr
	 FJpryZ9ya2qr4dQZykPnIyuYoE8r4s0+EP/Bnd59hx8ZQ2230WCn2P06B22McV0BbYQvl
	 i/SBhqJO7GjgqL1/i1MKLEZPTZqxQhi+F2L3tTxeV4l2GkxQxnKYLQiefo8CBCiaRzOSg
	 ZsCFjhYNLVu++fvo2+Hbl7jBHt5rJhwZYouXynq7cp9ha2eOJyB0IZ21EiZ+gJbMvzCyJ
	 /cy43/rjSHNfoE0ZukjzdjZNVIc3dHmhu/1TXHy6+TRUbyezOtQZ48VFIojQ3GGmKLw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fJ8HuCmt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 740F8606E649;
	Fri, 13 Nov 2026 17:19:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fJ8HuCmt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 015841F000C4;
	Fri, 13 Nov 2026 17:19:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590378;
	bh=OlKRAiEucQJUPMkIpisDR4+oy9f3n0Zr0nK5Y78cry8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fJ8HuCmtvwbeYyeJHHObWlD2QeWowmICgunvfNHEyGrZ7NSE+JYbc30U2VO2JrL8w
	 O7qaBKpgl4FwR209Us4pZ58BBO2W5h7S1gogTGGTLG+bMbz4G3qTDEYRtv3RUXDVHj
	 VxTDkflQmQb8L/7fFuR5jDAHD5YSUL2J5FhnVtnI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Wang <jasowangio@gmail.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Cong Zhang <cong.zhang@oss.qualcomm.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 349/686] virtio_blk: use synchronous quiesce in virtblk_freeze_priv()
Date: Fri, 13 Nov 2026 10:48:02 -0500
Message-ID: <20261113153832.747244792@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/virtio_blk.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index e577b02cf4003..84dc751266e9b 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -1588,7 +1588,7 @@ static int virtblk_freeze_priv(struct virtio_device *vdev)
 
 	/* Ensure no requests in virtqueues before deleting vqs. */
 	memflags = blk_mq_freeze_queue(q);
-	blk_mq_quiesce_queue_nowait(q);
+	blk_mq_quiesce_queue(q);
 	blk_mq_unfreeze_queue(q, memflags);
 
 	/* Ensure we don't receive any more interrupts */
-- 
2.53.0



