Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CB0E221F0C;
	Tue, 16 Dec 2025 12:18:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887501; cv=none; b=hgy8VXGDwWqANnNAkKmeudnt5zJ4i5nlqdSkkA08mVN/t8MEbKD8UwuwqbaeAdRX5CFPyGF98pSw91886iVn8BUECTw0L/j93wrWrsZZaVL2ATucllzS+dnia8zPrrHkI2ZIH6XspXpF7PRdqRgSBORIwGJT+6LyQ7EpMvcCoZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887501; c=relaxed/simple;
	bh=h30uHicjTaLGOyybKbc2I0DNAjqAAzr63zcVot8xamM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gU3HnUHGFWdzn3xiG1/h42d9HZlSiwSKSNLW6+/j1KSfXRqkYyRrooRW9bvMfA3LvFl6jhckSjXqogMeyg+OsssaCRaotbCoO0lM+uorI8jDMp9m70Q7fkBR56qaKjkUP2ZnxwBw2sex8+yHZJlK7JQqB4f7AWvVHPEj82jQcyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i6p5B1et; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i6p5B1et"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1F7FC16AAE;
	Tue, 16 Dec 2025 12:18:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887501;
	bh=h30uHicjTaLGOyybKbc2I0DNAjqAAzr63zcVot8xamM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i6p5B1etzIyT2cPBiR0Ih9J4iH6NLrIP2JOKBDOc/ROZc0JHu/+yvAwac0kyOEB8Y
	 BUniRm6unvzQzUgjJq7myzLBS2rlrlTc1rEDr/bFxsor6Boluvklq1ZDDfAZRBToe2
	 y9Q5uQAQ7KQbYPcXjCGc+O0RCZcnc8p1fs1H1j8o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Wei <dw@davidwei.uk>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 250/614] io_uring/zcrx: call netdev_queue_get_dma_dev() under instance lock
Date: Tue, 16 Dec 2025 12:10:17 +0100
Message-ID: <20251216111410.433743299@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Wei <dw@davidwei.uk>

[ Upstream commit b6c5f9454ef34fd2753ba7843ef4d9a295c43eee ]

netdev ops must be called under instance lock or rtnl_lock, but
io_register_zcrx_ifq() isn't doing this for netdev_queue_get_dma_dev().
Fix this by taking the instance lock using netdev_get_by_index_lock().

Extended the instance lock section to include attaching a memory
provider. Could not move io_zcrx_create_area() outside, since the dmabuf
codepath IORING_ZCRX_AREA_DMABUF requires ifq->dev.

Fixes: 59b8b32ac8d4 ("io_uring/zcrx: add support for custom DMA devices")
Signed-off-by: David Wei <dw@davidwei.uk>
Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>
Reviewed-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/zcrx.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index b1b723222cdb8..875ad40cf6591 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -599,29 +599,30 @@ int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
 	if (ret)
 		goto err;
 
-	ifq->netdev = netdev_get_by_index(current->nsproxy->net_ns, reg.if_idx,
-					  &ifq->netdev_tracker, GFP_KERNEL);
+	ifq->netdev = netdev_get_by_index_lock(current->nsproxy->net_ns, reg.if_idx);
 	if (!ifq->netdev) {
 		ret = -ENODEV;
 		goto err;
 	}
+	netdev_hold(ifq->netdev, &ifq->netdev_tracker, GFP_KERNEL);
 
 	ifq->dev = netdev_queue_get_dma_dev(ifq->netdev, reg.if_rxq);
 	if (!ifq->dev) {
 		ret = -EOPNOTSUPP;
-		goto err;
+		goto netdev_put_unlock;
 	}
 	get_device(ifq->dev);
 
 	ret = io_zcrx_create_area(ifq, &area);
 	if (ret)
-		goto err;
+		goto netdev_put_unlock;
 
 	mp_param.mp_ops = &io_uring_pp_zc_ops;
 	mp_param.mp_priv = ifq;
-	ret = net_mp_open_rxq(ifq->netdev, reg.if_rxq, &mp_param);
+	ret = __net_mp_open_rxq(ifq->netdev, reg.if_rxq, &mp_param, NULL);
 	if (ret)
-		goto err;
+		goto netdev_put_unlock;
+	netdev_unlock(ifq->netdev);
 	ifq->if_rxq = reg.if_rxq;
 
 	reg.zcrx_id = id;
@@ -640,6 +641,9 @@ int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
 		goto err;
 	}
 	return 0;
+netdev_put_unlock:
+	netdev_put(ifq->netdev, &ifq->netdev_tracker);
+	netdev_unlock(ifq->netdev);
 err:
 	scoped_guard(mutex, &ctx->mmap_lock)
 		xa_erase(&ctx->zcrx_ctxs, id);
-- 
2.51.0



