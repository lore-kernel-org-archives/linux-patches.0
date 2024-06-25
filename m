Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 940B014A09F;
	Tue, 25 Jun 2024 09:55:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309347; cv=none; b=oZq4XTIJHMKndfN+Iq7M6GUXb1XShVu5BMknQl5IYfEkZ19hJQq0kEeE4Q7gNxRaIm7En53AEEUH+C0/P2PDLTbfAxIxI8jyQe832OvdKb19fe2zPV/LOoC88IHWCXd8ROC0oY5pgkCOS1FWa8YaSPu1GtufLpBRYir4tJabNgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309347; c=relaxed/simple;
	bh=jnuNJsM8XzzwgEdwUS9hQLovXZ7HqbPk615ShCt0j5k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pCzVXaPV4RiIUmWSOBBg2Di6vyais/TKI3+rveMUdhVpqoFFHvNnxErgvhdS6Z9Fz+jX9liXw5vomH9pAn25obLi2M/j9bqrZDkfbE9TwyTGNJBulmOXWjlxR/7oVwYleg4ewKsV2NdXZBZ94Te4CrNyeZmyxtswWZpbIFZTLeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CL3K196E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CL3K196E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16EE0C32781;
	Tue, 25 Jun 2024 09:55:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309347;
	bh=jnuNJsM8XzzwgEdwUS9hQLovXZ7HqbPk615ShCt0j5k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CL3K196E88s0Yz86wZAzw4B35NazkRx7y2TxNCFcJhDURH9rBt+NHzB+GZenUnANM
	 ARHLPJvMabD0981CUXoi4WrI7uDCfR+x+C7tfbr4S6Tl4pt8Gk1X8t/cdV5Lyvxi0g
	 N3e4pbyu2yh/3kLVK43oqmCQVTDhY8KKABT71s9o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Josef Bacik <jbacik@fb.com>,
	Yu Kuai <yukuai3@huawei.com>,
	Markus Pargmann <mpa@pengutronix.de>,
	Bart Van Assche <bvanassche@acm.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 177/192] nbd: Fix signal handling
Date: Tue, 25 Jun 2024 11:34:09 +0200
Message-ID: <20240625085543.954193978@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085537.150087723@linuxfoundation.org>
References: <20240625085537.150087723@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit e56d4b633fffea9510db468085bed0799cba4ecd ]

Both nbd_send_cmd() and nbd_handle_cmd() return either a negative error
number or a positive blk_status_t value. nbd_queue_rq() converts these
return values into a blk_status_t value. There is a bug in the conversion
code: if nbd_send_cmd() returns BLK_STS_RESOURCE, nbd_queue_rq() should
return BLK_STS_RESOURCE instead of BLK_STS_OK. Fix this, move the
conversion code into nbd_handle_cmd() and fix the remaining sparse warnings.

This patch fixes the following sparse warnings:

drivers/block/nbd.c:673:32: warning: incorrect type in return expression (different base types)
drivers/block/nbd.c:673:32:    expected int
drivers/block/nbd.c:673:32:    got restricted blk_status_t [usertype]
drivers/block/nbd.c:714:48: warning: incorrect type in return expression (different base types)
drivers/block/nbd.c:714:48:    expected int
drivers/block/nbd.c:714:48:    got restricted blk_status_t [usertype]
drivers/block/nbd.c:1120:21: warning: incorrect type in assignment (different base types)
drivers/block/nbd.c:1120:21:    expected int [assigned] ret
drivers/block/nbd.c:1120:21:    got restricted blk_status_t [usertype]
drivers/block/nbd.c:1125:16: warning: incorrect type in return expression (different base types)
drivers/block/nbd.c:1125:16:    expected restricted blk_status_t
drivers/block/nbd.c:1125:16:    got int [assigned] ret

Cc: Christoph Hellwig <hch@lst.de>
Cc: Josef Bacik <jbacik@fb.com>
Cc: Yu Kuai <yukuai3@huawei.com>
Cc: Markus Pargmann <mpa@pengutronix.de>
Fixes: fc17b6534eb8 ("blk-mq: switch ->queue_rq return value to blk_status_t")
Cc: stable@vger.kernel.org
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Link: https://lore.kernel.org/r/20240510202313.25209-6-bvanassche@acm.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/nbd.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index a906674f71147..1089dc646b808 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -569,6 +569,10 @@ static inline int was_interrupted(int result)
 	return result == -ERESTARTSYS || result == -EINTR;
 }
 
+/*
+ * Returns BLK_STS_RESOURCE if the caller should retry after a delay. Returns
+ * -EAGAIN if the caller should requeue @cmd. Returns -EIO if sending failed.
+ */
 static int nbd_send_cmd(struct nbd_device *nbd, struct nbd_cmd *cmd, int index)
 {
 	struct request *req = blk_mq_rq_from_pdu(cmd);
@@ -652,7 +656,7 @@ static int nbd_send_cmd(struct nbd_device *nbd, struct nbd_cmd *cmd, int index)
 				nsock->sent = sent;
 			}
 			set_bit(NBD_CMD_REQUEUED, &cmd->flags);
-			return BLK_STS_RESOURCE;
+			return (__force int)BLK_STS_RESOURCE;
 		}
 		dev_err_ratelimited(disk_to_dev(nbd->disk),
 			"Send control failed (result %d)\n", result);
@@ -693,7 +697,7 @@ static int nbd_send_cmd(struct nbd_device *nbd, struct nbd_cmd *cmd, int index)
 					nsock->pending = req;
 					nsock->sent = sent;
 					set_bit(NBD_CMD_REQUEUED, &cmd->flags);
-					return BLK_STS_RESOURCE;
+					return (__force int)BLK_STS_RESOURCE;
 				}
 				dev_err(disk_to_dev(nbd->disk),
 					"Send data failed (result %d)\n",
@@ -990,7 +994,7 @@ static int wait_for_reconnect(struct nbd_device *nbd)
 	return !test_bit(NBD_RT_DISCONNECTED, &config->runtime_flags);
 }
 
-static int nbd_handle_cmd(struct nbd_cmd *cmd, int index)
+static blk_status_t nbd_handle_cmd(struct nbd_cmd *cmd, int index)
 {
 	struct request *req = blk_mq_rq_from_pdu(cmd);
 	struct nbd_device *nbd = cmd->nbd;
@@ -1004,14 +1008,14 @@ static int nbd_handle_cmd(struct nbd_cmd *cmd, int index)
 	if (!config) {
 		dev_err_ratelimited(disk_to_dev(nbd->disk),
 				    "Socks array is empty\n");
-		return -EINVAL;
+		return BLK_STS_IOERR;
 	}
 
 	if (index >= config->num_connections) {
 		dev_err_ratelimited(disk_to_dev(nbd->disk),
 				    "Attempted send on invalid socket\n");
 		nbd_config_put(nbd);
-		return -EINVAL;
+		return BLK_STS_IOERR;
 	}
 	cmd->status = BLK_STS_OK;
 again:
@@ -1034,7 +1038,7 @@ static int nbd_handle_cmd(struct nbd_cmd *cmd, int index)
 			 */
 			sock_shutdown(nbd);
 			nbd_config_put(nbd);
-			return -EIO;
+			return BLK_STS_IOERR;
 		}
 		goto again;
 	}
@@ -1047,7 +1051,7 @@ static int nbd_handle_cmd(struct nbd_cmd *cmd, int index)
 	blk_mq_start_request(req);
 	if (unlikely(nsock->pending && nsock->pending != req)) {
 		nbd_requeue_cmd(cmd);
-		ret = 0;
+		ret = BLK_STS_OK;
 		goto out;
 	}
 	/*
@@ -1066,19 +1070,19 @@ static int nbd_handle_cmd(struct nbd_cmd *cmd, int index)
 				    "Request send failed, requeueing\n");
 		nbd_mark_nsock_dead(nbd, nsock, 1);
 		nbd_requeue_cmd(cmd);
-		ret = 0;
+		ret = BLK_STS_OK;
 	}
 out:
 	mutex_unlock(&nsock->tx_lock);
 	nbd_config_put(nbd);
-	return ret;
+	return ret < 0 ? BLK_STS_IOERR : (__force blk_status_t)ret;
 }
 
 static blk_status_t nbd_queue_rq(struct blk_mq_hw_ctx *hctx,
 			const struct blk_mq_queue_data *bd)
 {
 	struct nbd_cmd *cmd = blk_mq_rq_to_pdu(bd->rq);
-	int ret;
+	blk_status_t ret;
 
 	/*
 	 * Since we look at the bio's to send the request over the network we
@@ -1098,10 +1102,6 @@ static blk_status_t nbd_queue_rq(struct blk_mq_hw_ctx *hctx,
 	 * appropriate.
 	 */
 	ret = nbd_handle_cmd(cmd, hctx->queue_num);
-	if (ret < 0)
-		ret = BLK_STS_IOERR;
-	else if (!ret)
-		ret = BLK_STS_OK;
 	mutex_unlock(&cmd->lock);
 
 	return ret;
-- 
2.43.0



