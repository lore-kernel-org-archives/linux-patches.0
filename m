Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624546;
	b=Cgk8N0I6B7D93q2Z1GsJ+W/nOoSqkNpGdUCBzs/7mUEhCHXqRu65IvlfbrT3MSOs5IUx
	 mzk4N3APNo6GesMS4Ucq42E1W+iM/nz/JRyrYqskWSvT/pU7jFwSSCAJbaXT919c4bp6K
	 CGbnukA83G950w/9oB/SdyQgyIueszEnApKP0L6eIFxQ1q4TcrhKT6VBf2K1va6ckgbqp
	 VvbZstidEl579olwArPpXV2SuBdQSBreuRNYmuDWC1mgJYaRQSwWuN0hWeZCw4xBmCEVw
	 0obFjVuPFHsLmeBaKY3s+GLcGrznyQoeRhiNYTiO5iG9v64Yz8/YufRGLmF4/ov9Q2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624546;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aFf7XheE7c8a4gRrKxGA+Ncq31nUjHGZzANjZf/f5WM=;
	b=Sgjn49j7q1H4RzGuO5xlMpDaKkMil+Umf8YzOOrYVg/om0/6fsGOXLRrXpVh9EYNs/sA
	 E7C9mRhb2CfXCOLlMb/blEONFtBrydsRfWkhwxRBPdtJ5j1Z3SxMgXUIsuCBopFRSPxx3
	 j0P7x0naOgeA2eTEJ4HLhUkEphlkcxrysUYXwCdVPuO7O9mrBvRe/qjNXiq8LIeYk/Hpi
	 XmnC0p+3tFo9TXbcCK2I9KEg/OkBeApSVU0gAii1GKuWRHM/19HMDPrKKup9uSHe2qnHu
	 xS7fyL9nJkk/WG73TAYgbJTg/q2DVVcGNwzvec6CCrpIlrFy5MNXnlCmgnnNI9t9Tgg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rceGaHer;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FFFD606A338;
	Wed, 25 Nov 2026 16:35:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rceGaHer
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89F8F1F000C4;
	Wed, 25 Nov 2026 16:35:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624546;
	bh=aFf7XheE7c8a4gRrKxGA+Ncq31nUjHGZzANjZf/f5WM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rceGaHerZxwFNkkkIGNFUr8MjLrFsp++rhxk8V+cKWiUwG62zhFO78r7frPfYwi7I
	 K6dAVw0VOAkXPdeT7h+BwOwYdfogMsKwuFTQ3NrHWyVpuVB1SO2Uy1VQPVDugTHZv4
	 wYyYEKvJF/Kywbjxuz9a7rfJvXMc7MrICuq2VNlo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shao Mingyin <shao.mingyin@zte.com.cn>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 183/816] virtio-blk: Fix zone append sector reporting in batched completion
Date: Wed, 25 Nov 2026 15:28:51 +0100
Message-ID: <20261125143853.429709492@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shao Mingyin <shao.mingyin@zte.com.cn>

[ Upstream commit 08a6572441a4e646c96c2b8d8ead9eea0e458332 ]

For zone append, the block layer copies req->__sector back into the
bio in blk_zone_append_update_request_bio(), so the driver must update
req->__sector with the sector reported by the device.
virtblk_request_done() does that, but the batched completion path used
by virtblk_poll() only unmaps and cleans up the requests before calling
blk_mq_end_request_batch().

A zone append completed through polling therefore keeps the sector that
was assigned at submission time, and the file system or application sees
the wrong LBA for the written data.

Move the sector update into a helper and call it from both completion
paths.

Fixes: 95bfec41bd3d ("virtio-blk: add support for zoned block devices")
Signed-off-by: Shao Mingyin <shao.mingyin@zte.com.cn>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://patch.msgid.link/202610261955196384aSLGuy3_0MiTvlYXVdiC@zte.com.cn
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/virtio_blk.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 8b01011599a78..d4322992debef 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -332,18 +332,25 @@ static inline u8 virtblk_vbr_status(struct virtblk_req *vbr)
 	return *((u8 *)&vbr->in_hdr + vbr->in_hdr_len - 1);
 }
 
+static inline void virtblk_update_zone_append_sector(struct request *req,
+						     struct virtblk_req *vbr)
+{
+	struct virtio_blk *vblk = req->mq_hctx->queue->queuedata;
+
+	if (req_op(req) == REQ_OP_ZONE_APPEND)
+		req->__sector = virtio64_to_cpu(vblk->vdev,
+						vbr->in_hdr.zone_append.sector);
+}
+
 static inline void virtblk_request_done(struct request *req)
 {
 	struct virtblk_req *vbr = blk_mq_rq_to_pdu(req);
 	blk_status_t status = virtblk_result(virtblk_vbr_status(vbr));
-	struct virtio_blk *vblk = req->mq_hctx->queue->queuedata;
 
 	virtblk_unmap_data(req, vbr);
 	virtblk_cleanup_cmd(req);
 
-	if (req_op(req) == REQ_OP_ZONE_APPEND)
-		req->__sector = virtio64_to_cpu(vblk->vdev,
-						vbr->in_hdr.zone_append.sector);
+	virtblk_update_zone_append_sector(req, vbr);
 
 	blk_mq_end_request(req, status);
 }
@@ -1213,8 +1220,11 @@ static void virtblk_complete_batch(struct io_comp_batch *iob)
 	struct request *req;
 
 	rq_list_for_each(&iob->req_list, req) {
-		virtblk_unmap_data(req, blk_mq_rq_to_pdu(req));
+		struct virtblk_req *vbr = blk_mq_rq_to_pdu(req);
+
+		virtblk_unmap_data(req, vbr);
 		virtblk_cleanup_cmd(req);
+		virtblk_update_zone_append_sector(req, vbr);
 	}
 	blk_mq_end_request_batch(iob);
 }
-- 
2.53.0



