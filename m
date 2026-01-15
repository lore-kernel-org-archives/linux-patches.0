Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF9112C11CA;
	Thu, 15 Jan 2026 17:17:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497438; cv=none; b=UyPVsH3UPjUgWBixbntTxPNT87lffItwW9Mg/gfZ8elVjt+CjabnxI8EvBrdVg1Zcgc6k/rZl+5F0TVl9Wb0GMbhHQRRwsloL3x9dEGWejWddUNP8pcJQAaESsDHt7qPnoF/hZCPeVIcMktHlv46Li8qZwuS0JL5R5yBZnZlc3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497438; c=relaxed/simple;
	bh=d/fmsrk38rJGWR1XcoA6qthNS38amSHHcIuoiHCHiLM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DX6judJI8bPiUgVsMCYEGM+38tAfIki344NV11yja7vMBapMTCxGimEGe+EdtfW5kvoUZINEIJ0Fd6zjUUKBtPRdFbsa2SfEnmBU007kovbAY0qM6038i3qELv5OxkZQf7kTbfUyLlh8bDJaSJUMG+A/ZmmZ6yShkwH7bQ3X+H4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MFxY4Dz2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MFxY4Dz2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B9E9C116D0;
	Thu, 15 Jan 2026 17:17:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497438;
	bh=d/fmsrk38rJGWR1XcoA6qthNS38amSHHcIuoiHCHiLM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MFxY4Dz2Y14k2QmyDoH3tOfK2RnjTToqZ1M+5MEHV3oAjYn4YyXblpS13t0+f//pI
	 qa0TExjnsrrUqBJJ6sq0j7+hzT10r0IiJflPtCd/6ysWBelN9OFoFwEdgul55MLdQE
	 WT867Hx3x4uKN4wszQXV9G5iJaGo9fOgxvKo9ifE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Ming Lei <ming.lei@redhat.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 081/554] nbd: clean up return value checking of sock_xmit()
Date: Thu, 15 Jan 2026 17:42:27 +0100
Message-ID: <20260115164249.171887059@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index eca713f87614f..3f5c5e122bf78 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -487,7 +487,8 @@ static enum blk_eh_timer_return nbd_xmit_timeout(struct request *req,
 }
 
 /*
- *  Send or receive packet.
+ *  Send or receive packet. Return a positive value on success and
+ *  negtive value on failue, and never return 0.
  */
 static int sock_xmit(struct nbd_device *nbd, int index, int send,
 		     struct iov_iter *iter, int msg_flags, int *sent)
@@ -613,7 +614,7 @@ static int nbd_send_cmd(struct nbd_device *nbd, struct nbd_cmd *cmd, int index)
 	result = sock_xmit(nbd, index, 1, &from,
 			(type == NBD_CMD_WRITE) ? MSG_MORE : 0, &sent);
 	trace_nbd_header_sent(req, handle);
-	if (result <= 0) {
+	if (result < 0) {
 		if (was_interrupted(result)) {
 			/* If we havne't sent anything we can just return BUSY,
 			 * however if we have sent something we need to make
@@ -657,7 +658,7 @@ static int nbd_send_cmd(struct nbd_device *nbd, struct nbd_cmd *cmd, int index)
 				skip = 0;
 			}
 			result = sock_xmit(nbd, index, 1, &from, flags, &sent);
-			if (result <= 0) {
+			if (result < 0) {
 				if (was_interrupted(result)) {
 					/* We've already sent the header, we
 					 * have no choice but to set pending and
@@ -709,7 +710,7 @@ static struct nbd_cmd *nbd_read_stat(struct nbd_device *nbd, int index)
 	reply.magic = 0;
 	iov_iter_kvec(&to, READ, &iov, 1, sizeof(reply));
 	result = sock_xmit(nbd, index, 0, &to, MSG_WAITALL, NULL);
-	if (result <= 0) {
+	if (result < 0) {
 		if (!nbd_disconnected(config))
 			dev_err(disk_to_dev(nbd->disk),
 				"Receive control failed (result %d)\n", result);
@@ -770,7 +771,7 @@ static struct nbd_cmd *nbd_read_stat(struct nbd_device *nbd, int index)
 		rq_for_each_segment(bvec, req, iter) {
 			iov_iter_bvec(&to, READ, &bvec, 1, bvec.bv_len);
 			result = sock_xmit(nbd, index, 0, &to, MSG_WAITALL, NULL);
-			if (result <= 0) {
+			if (result < 0) {
 				dev_err(disk_to_dev(nbd->disk), "Receive data failed (result %d)\n",
 					result);
 				/*
@@ -1216,7 +1217,7 @@ static void send_disconnects(struct nbd_device *nbd)
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



