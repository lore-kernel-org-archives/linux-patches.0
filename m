Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3613F78B61;
	Tue, 27 Feb 2024 14:15:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043357; cv=none; b=l9/AZkUzLvrQFwrxJZ0fahBQTtJIQ8ih8FDv2P+iSADmEOfxiUhsCfobHy8hiEb7zVOADgdPtaZ/mKqaIaiC/Go42XJJavb6auXNNkEQ5XbtvO6FLpKLffJ3NnaYTzxTF7z6tHC8Wujcur9cOjRycAEen9u6gBBeflw6/RlntfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043357; c=relaxed/simple;
	bh=W2LGrMhF5HhMSyE72BwFOr1eFUDwJe2qvCjlu2tH+QQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dyH7qqwD1eKZyCnVOHimMw4cubolBAncZBrIsNqkANMIBHrBC8wpJfpYJp6x4n2afL3tkjeB8l5vxKylPSYQy2mpO9vBiMsT+MkuOBYrtaEvqItkSpWlJmTbnG+CZyOCoMw0/lbRt/l9nr8TdPEjzd4iu7VEPSzOoTdhexjnoFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P5XfFNSY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P5XfFNSY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6F43C433C7;
	Tue, 27 Feb 2024 14:15:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043357;
	bh=W2LGrMhF5HhMSyE72BwFOr1eFUDwJe2qvCjlu2tH+QQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P5XfFNSYVUpzIpHVmo2hNwr/iEQAm8pza+T6mYZ6h3rq5C68pq6j2dk0rhj//LKGk
	 wIh40H/CQW6Qavp+W35I/TRVgKPBT6kHA6dTXWBthu23YSY+EDadvsiLt4EcRD0c9r
	 TkV0f4Mg4S5Jhp9Z0T6BRJrskHLTFdimBIe/rIjw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yi Sun <yi.sun@unisoc.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 079/195] virtio-blk: Ensure no requests in virtqueues before deleting vqs.
Date: Tue, 27 Feb 2024 14:25:40 +0100
Message-ID: <20240227131613.100569506@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131610.391465389@linuxfoundation.org>
References: <20240227131610.391465389@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 3124837aa406f..505026f0025c7 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -1206,14 +1206,15 @@ static int virtblk_freeze(struct virtio_device *vdev)
 {
 	struct virtio_blk *vblk = vdev->priv;
 
+	/* Ensure no requests in virtqueues before deleting vqs. */
+	blk_mq_freeze_queue(vblk->disk->queue);
+
 	/* Ensure we don't receive any more interrupts */
 	virtio_reset_device(vdev);
 
 	/* Make sure no work handler is accessing the device. */
 	flush_work(&vblk->config_work);
 
-	blk_mq_quiesce_queue(vblk->disk->queue);
-
 	vdev->config->del_vqs(vdev);
 	kfree(vblk->vqs);
 
@@ -1231,7 +1232,7 @@ static int virtblk_restore(struct virtio_device *vdev)
 
 	virtio_device_ready(vdev);
 
-	blk_mq_unquiesce_queue(vblk->disk->queue);
+	blk_mq_unfreeze_queue(vblk->disk->queue);
 	return 0;
 }
 #endif
-- 
2.43.0



