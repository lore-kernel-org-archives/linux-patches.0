Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6474E2C0F83;
	Thu, 15 Jan 2026 17:42:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498967; cv=none; b=uHxwk+s3tVMYaEdUtkLNaiCoux+PqCYu/nbQNZlpbhNR5rf7LZ5qbzQqOXD8Q7XOBMUU46f5wlPieuUQv2es59CLnjizjbE61J/sAoDCC2XceubgRgepLIO+oNaGop8n0G1q+MWeWbxi8k+mVIB84luwsnupnYeHmQqzNivESl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498967; c=relaxed/simple;
	bh=7bZGgKrdrRRnu5TGqNiSp6aYaTlPUYfIJ2gQg0AAlhI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jUX0T5pvDkYITGxHNLeltiSo7sx0c2xG02immn90IQoVmHFtoVXKDawB+Xgzv7k++wxZVilgavkLwEWX6USfPeilwKtw6eGFC0OEOk+0UnyduFuFEMzPGXswh4fTvUd1evjtBew6pWuxAlkv99E6p7vajAWjP4eDVrP62O0RrPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nIp6Qcr6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nIp6Qcr6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92D53C116D0;
	Thu, 15 Jan 2026 17:42:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498967;
	bh=7bZGgKrdrRRnu5TGqNiSp6aYaTlPUYfIJ2gQg0AAlhI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nIp6Qcr6Ve9L51qRoh1zeCVbM4UG/DPxjrrDRsyOXnABAH5k/rA0Xtmed10L/I+gU
	 Y2nRovkooDUZqlN6yvHCrAF7NWvJduayiNshoLWL/WXfbtM8IxXZ7OKTYvnMgAZLyp
	 5GujXTBvAfA3foS9VA67qPEeOxdwVZ4/AtU20JoE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Ming Lei <ming.lei@redhat.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 062/451] nbd: partition nbd_read_stat() into nbd_read_reply() and nbd_handle_reply()
Date: Thu, 15 Jan 2026 17:44:23 +0100
Message-ID: <20260115164233.142350086@linuxfoundation.org>
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

[ Upstream commit 3fe1db626a56cdf259c348404f2c5429e2f065a1 ]

Prepare to fix uaf in nbd_read_stat(), no functional changes.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Link: https://lore.kernel.org/r/20210916093350.1410403-7-yukuai3@huawei.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 9517b82d8d42 ("nbd: defer config put in recv_work")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/nbd.c | 74 +++++++++++++++++++++++++++------------------
 1 file changed, 44 insertions(+), 30 deletions(-)

diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index 555e87a6d3a6d..92a94fa568a05 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -673,38 +673,45 @@ static int nbd_send_cmd(struct nbd_device *nbd, struct nbd_cmd *cmd, int index)
 	return 0;
 }
 
-/* NULL returned = something went wrong, inform userspace */
-static struct nbd_cmd *nbd_read_stat(struct nbd_device *nbd, int index)
+static int nbd_read_reply(struct nbd_device *nbd, int index,
+			  struct nbd_reply *reply)
 {
-	struct nbd_config *config = nbd->config;
-	int result;
-	struct nbd_reply reply;
-	struct nbd_cmd *cmd;
-	struct request *req = NULL;
-	u64 handle;
-	u16 hwq;
-	u32 tag;
-	struct kvec iov = {.iov_base = &reply, .iov_len = sizeof(reply)};
+	struct kvec iov = {.iov_base = reply, .iov_len = sizeof(*reply)};
 	struct iov_iter to;
-	int ret = 0;
+	int result;
 
-	reply.magic = 0;
-	iov_iter_kvec(&to, READ, &iov, 1, sizeof(reply));
+	reply->magic = 0;
+	iov_iter_kvec(&to, READ, &iov, 1, sizeof(*reply));
 	result = sock_xmit(nbd, index, 0, &to, MSG_WAITALL, NULL);
 	if (result < 0) {
-		if (!nbd_disconnected(config))
+		if (!nbd_disconnected(nbd->config))
 			dev_err(disk_to_dev(nbd->disk),
 				"Receive control failed (result %d)\n", result);
-		return ERR_PTR(result);
+		return result;
 	}
 
-	if (ntohl(reply.magic) != NBD_REPLY_MAGIC) {
+	if (ntohl(reply->magic) != NBD_REPLY_MAGIC) {
 		dev_err(disk_to_dev(nbd->disk), "Wrong magic (0x%lx)\n",
-				(unsigned long)ntohl(reply.magic));
-		return ERR_PTR(-EPROTO);
+				(unsigned long)ntohl(reply->magic));
+		return -EPROTO;
 	}
 
-	memcpy(&handle, reply.handle, sizeof(handle));
+	return 0;
+}
+
+/* NULL returned = something went wrong, inform userspace */
+static struct nbd_cmd *nbd_handle_reply(struct nbd_device *nbd, int index,
+					struct nbd_reply *reply)
+{
+	int result;
+	struct nbd_cmd *cmd;
+	struct request *req = NULL;
+	u64 handle;
+	u16 hwq;
+	u32 tag;
+	int ret = 0;
+
+	memcpy(&handle, reply->handle, sizeof(handle));
 	tag = nbd_handle_to_tag(handle);
 	hwq = blk_mq_unique_tag_to_hwq(tag);
 	if (hwq < nbd->tag_set.nr_hw_queues)
@@ -737,9 +744,9 @@ static struct nbd_cmd *nbd_read_stat(struct nbd_device *nbd, int index)
 		ret = -ENOENT;
 		goto out;
 	}
-	if (ntohl(reply.error)) {
+	if (ntohl(reply->error)) {
 		dev_err(disk_to_dev(nbd->disk), "Other side returned error (%d)\n",
-			ntohl(reply.error));
+			ntohl(reply->error));
 		cmd->status = BLK_STS_IOERR;
 		goto out;
 	}
@@ -748,6 +755,7 @@ static struct nbd_cmd *nbd_read_stat(struct nbd_device *nbd, int index)
 	if (rq_data_dir(req) != WRITE) {
 		struct req_iterator iter;
 		struct bio_vec bvec;
+		struct iov_iter to;
 
 		rq_for_each_segment(bvec, req, iter) {
 			iov_iter_bvec(&to, READ, &bvec, 1, bvec.bv_len);
@@ -761,7 +769,7 @@ static struct nbd_cmd *nbd_read_stat(struct nbd_device *nbd, int index)
 				 * and let the timeout stuff handle resubmitting
 				 * this request onto another connection.
 				 */
-				if (nbd_disconnected(config)) {
+				if (nbd_disconnected(nbd->config)) {
 					cmd->status = BLK_STS_IOERR;
 					goto out;
 				}
@@ -785,24 +793,30 @@ static void recv_work(struct work_struct *work)
 						     work);
 	struct nbd_device *nbd = args->nbd;
 	struct nbd_config *config = nbd->config;
+	struct nbd_sock *nsock;
 	struct nbd_cmd *cmd;
 	struct request *rq;
 
 	while (1) {
-		cmd = nbd_read_stat(nbd, args->index);
-		if (IS_ERR(cmd)) {
-			struct nbd_sock *nsock = config->socks[args->index];
+		struct nbd_reply reply;
 
-			mutex_lock(&nsock->tx_lock);
-			nbd_mark_nsock_dead(nbd, nsock, 1);
-			mutex_unlock(&nsock->tx_lock);
+		if (nbd_read_reply(nbd, args->index, &reply))
+			break;
+
+		cmd = nbd_handle_reply(nbd, args->index, &reply);
+		if (IS_ERR(cmd))
 			break;
-		}
 
 		rq = blk_mq_rq_from_pdu(cmd);
 		if (likely(!blk_should_fake_timeout(rq->q)))
 			blk_mq_complete_request(rq);
 	}
+
+	nsock = config->socks[args->index];
+	mutex_lock(&nsock->tx_lock);
+	nbd_mark_nsock_dead(nbd, nsock, 1);
+	mutex_unlock(&nsock->tx_lock);
+
 	nbd_config_put(nbd);
 	atomic_dec(&config->recv_threads);
 	wake_up(&config->recv_wq);
-- 
2.51.0



