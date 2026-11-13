Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585727;
	b=0x/VKYnNeFPj5VF3R5Txm4UFGv1mo/+VMAVv1CX1cRGwSLnMw93DdVhnZebEqCK94LS1
	 xOVLdouptdXKKzXC5vvg1QKOpoPIbJu2x8kJs1mWqZfhuzm5uT+RO80gJ0y7yKLPKWkxf
	 epZW/QgnGz+YBEOHpr4n3y4Ls01knMe4sf37oorQeD2xfEZkNmrsTJnkKuqLzPsLTiIhC
	 yXyBdUpFFJehEl2NxI2ml9dNRGCSQ3HzYX2e38oZpZr5ooIDNGEMF4V4mpzHC26Xgk99S
	 HMJCZwWdr7xOzTTkhA6cpc0YpiX/DwNcAu0r6tu9XGRsuiC+2Hl+6aFCVpMOFVBfD+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585727;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0/yEh4KIWU6+KwI/jzUbVpsWg3i1BG3usoshrG0/yYI=;
	b=chO8eo3jdwh6YTaX4+afUFpL4DDFOs0ucVJIaQKMHEVSA18Ao4uPMfatbZ3wJel/8uwB
	 BjftVUwWKVdJalz/9w0FBEVu4NyCN+O333JaJ8ljENdritcp2Phhu5hsjpYLDexPZ9Hx0
	 uxMA+AwoMle5H3WA1AY2q1r1tfLZFygc1b968jRI48l4RHsK7/pl5JMRHH/Mpzzb0yoCC
	 PE4uJddc/ZrPFafawnBuK8R3V6UjGmj3ya3C8bPWf87iYdU9+RHCtaFD9bSCND6eUa2vE
	 YpRvGMdjO5E1CnQpYAieJcNm/+bovSwbxOj1ZGDs+Nz+diZkK5ydrSxd72M5L/mtc9w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eUdvcTnj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC939606EB88;
	Fri, 13 Nov 2026 16:02:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eUdvcTnj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67D541F000C6;
	Fri, 13 Nov 2026 16:02:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585727;
	bh=0/yEh4KIWU6+KwI/jzUbVpsWg3i1BG3usoshrG0/yYI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eUdvcTnjl9Tam/0w8DhDN0H9Jjvax1YqlQUy9kqxykcjU3v31255TAQC0ZZ6LwCvy
	 /b3HkkGKcSTRy1Z8D2tkoUM6CpGoXWtY2Ur718pKJHq9fvVU43btuMOQjxY48u40Qf
	 S06BdszGAJCi9q1CeqFYUztHfH9DR+2Bwr7Lr07o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Wang <jasowangio@gmail.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Cong Zhang <cong.zhang@oss.qualcomm.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 275/507] virtio_blk: use synchronous quiesce in virtblk_freeze_priv()
Date: Fri, 13 Nov 2026 10:49:39 -0500
Message-ID: <20261113153804.155716572@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index c8bfbf8435ac7..10ba8b0b863b8 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -1596,7 +1596,7 @@ static int virtblk_freeze_priv(struct virtio_device *vdev)
 
 	/* Ensure no requests in virtqueues before deleting vqs. */
 	memflags = blk_mq_freeze_queue(q);
-	blk_mq_quiesce_queue_nowait(q);
+	blk_mq_quiesce_queue(q);
 	blk_mq_unfreeze_queue(q, memflags);
 
 	/* Ensure we don't receive any more interrupts */
-- 
2.53.0



