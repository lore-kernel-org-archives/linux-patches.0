Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F18539E6EA;
	Thu, 15 Jan 2026 17:42:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498964; cv=none; b=f1pHkX1AKerJqUQyfYC+PG3QF5fxTD+74tWFlwtusY5PiXOR1AlaPpcJ4QjxQ8xluKzKdcLNgj1qJHVsuOJwHdWwQq65hu8jxyNvHu6qqvBjhZL2HxOD/IeSJ91wtrz7M17qof2Tp4QBOkQ8SXzManaf4mOYByiSJOClF79Kzvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498964; c=relaxed/simple;
	bh=2XAqGssSSRrTUS0vlUoqpT5zWn/WCSDL0X9Ch2010vk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iTpbWdWs72K8AXiXcMDGeoXbjx0oGx2nDE/8/IqiqXKKfFexR+4e6vSYgUfUXwhSkLoiZdnWApq2JMl/gC0WAQJxl4GrPIOUjoqWatD1Fze/S02mqZP9rmE0Pp9wYgQnUVl0SmOdjWDHPAz18G6KfjV3pIYT1T+AY4NhZlhxVLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gUqRTjYE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gUqRTjYE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B16ACC116D0;
	Thu, 15 Jan 2026 17:42:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498964;
	bh=2XAqGssSSRrTUS0vlUoqpT5zWn/WCSDL0X9Ch2010vk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gUqRTjYE/MStyeHTeNtTeNjQy0wrpk6ckOAYeVJD1nUIsM7tbZc9ys/DAf8UaGDxP
	 ZAzVLItTXnVjN8M85wRC3OnCRWcYe4WAFfAOIakOoWcf6fNtawQbNgJSz5k+kUou6+
	 g+V0fQ1dGd9VyEL0pDeW6/FsOayoY/PCx1TjGn5c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Ming Lei <ming.lei@redhat.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 061/451] nbd: clean up return value checking of sock_xmit()
Date: Thu, 15 Jan 2026 17:44:22 +0100
Message-ID: <20260115164233.106262182@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yu Kuai <yukuai3@huawei.com>

[ Upstream commit f52c0e08237e7864a44311fc78bc9bf2e045611b ]

Check if sock_xmit() return 0 is useless because it'll never return
0, comment it and remove such checkings.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Link: https://lore.kernel.org/r/20210916093350.1410403-6-yukuai3@huawei.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 9517b82d8d42 ("nbd: defer config put in recv_work")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/nbd.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index 4776009587190..555e87a6d3a6d 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -468,7 +468,8 @@ static enum blk_eh_timer_return nbd_xmit_timeout(struct request *req,
 }
 
 /*
- *  Send or receive packet.
+ *  Send or receive packet. Return a positive value on success and
+ *  negtive value on failue, and never return 0.
  */
 static int sock_xmit(struct nbd_device *nbd, int index, int send,
 		     struct iov_iter *iter, int msg_flags, int *sent)
@@ -594,7 +595,7 @@ static int nbd_send_cmd(struct nbd_device *nbd, struct nbd_cmd *cmd, int index)
 	result = sock_xmit(nbd, index, 1, &from,
 			(type == NBD_CMD_WRITE) ? MSG_MORE : 0, &sent);
 	trace_nbd_header_sent(req, handle);
-	if (result <= 0) {
+	if (result < 0) {
 		if (was_interrupted(result)) {
 			/* If we havne't sent anything we can just return BUSY,
 			 * however if we have sent something we need to make
@@ -638,7 +639,7 @@ static int nbd_send_cmd(struct nbd_device *nbd, struct nbd_cmd *cmd, int index)
 				skip = 0;
 			}
 			result = sock_xmit(nbd, index, 1, &from, flags, &sent);
-			if (result <= 0) {
+			if (result < 0) {
 				if (was_interrupted(result)) {
 					/* We've already sent the header, we
 					 * have no choice but to set pending and
@@ -690,7 +691,7 @@ static struct nbd_cmd *nbd_read_stat(struct nbd_device *nbd, int index)
 	reply.magic = 0;
 	iov_iter_kvec(&to, READ, &iov, 1, sizeof(reply));
 	result = sock_xmit(nbd, index, 0, &to, MSG_WAITALL, NULL);
-	if (result <= 0) {
+	if (result < 0) {
 		if (!nbd_disconnected(config))
 			dev_err(disk_to_dev(nbd->disk),
 				"Receive control failed (result %d)\n", result);
@@ -751,7 +752,7 @@ static struct nbd_cmd *nbd_read_stat(struct nbd_device *nbd, int index)
 		rq_for_each_segment(bvec, req, iter) {
 			iov_iter_bvec(&to, READ, &bvec, 1, bvec.bv_len);
 			result = sock_xmit(nbd, index, 0, &to, MSG_WAITALL, NULL);
-			if (result <= 0) {
+			if (result < 0) {
 				dev_err(disk_to_dev(nbd->disk), "Receive data failed (result %d)\n",
 					result);
 				/*
@@ -1194,7 +1195,7 @@ static void send_disconnects(struct nbd_device *nbd)
 		iov_iter_kvec(&from, WRITE, &iov, 1, sizeof(request));
 		mutex_lock(&nsock->tx_lock);
 		ret = sock_xmit(nbd, i, 1, &from, 0, NULL);
-		if (ret <= 0)
+		if (ret < 0)
 			dev_err(disk_to_dev(nbd->disk),
 				"Send disconnect failed %d\n", ret);
 		mutex_unlock(&nsock->tx_lock);
-- 
2.51.0



