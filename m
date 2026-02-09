Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F6533783C9;
	Mon,  9 Feb 2026 14:52:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770648745; cv=none; b=HAkmqBh1C5aEdVNPEvhhPtDHtJMu1zwbCIvImiOv5mSAtH91V4xjdFL+J5spPSzgSqzskvKghXFgsX4MCjTXeuchLcp38NsVHuB47pGrt4vZeJeIXrorZxx8Ms51nVkGXtDSIeXmAeUxd1MKvRCw09i3vHOoRjQ0eJ4HKAL/hdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770648745; c=relaxed/simple;
	bh=ocjstGQSstHHkYQgj5NMBPCv+TJHP1IbfeuETyfRw9Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ipmguuOgwfkMkbDgkFgCqHQmFkHydgJFJeQ7r7KEPRkRhWBsQf0Sn8vEB5fxgUijZTipA6pjgr/pGNYT17QQ46slJyLo4O5uOHstZjrp1hNkv1+2U1C5Y9W4z5qjgKHwd1NnWbu/lubttidEWX3rCfQ1nrGwAbAfWsXnx94RZM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WT/q+/PG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WT/q+/PG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F22CFC116C6;
	Mon,  9 Feb 2026 14:52:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770648745;
	bh=ocjstGQSstHHkYQgj5NMBPCv+TJHP1IbfeuETyfRw9Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WT/q+/PG9C7fWeJ2JdCq/W9EaNXMRFomyRoR4caHyZpjPDJHLqjNyoZJo7T51ggef
	 xYh0EztqZLeyB+qxW4xhGiyeI2Oiiv1j0SwvMdGc00YgAkGhTtnjaZUqvlCw47Y9kt
	 GfQIct0b+7wtWlz3a6Y7HJ5flV3w8ykgORwvU1rw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maurizio Lombardi <mlombard@redhat.com>,
	Keith Busch <kbusch@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>,
	John Meneghini <jmeneghi@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 31/41] nvmet-tcp: add an helper to free the cmd buffers
Date: Mon,  9 Feb 2026 15:24:52 +0100
Message-ID: <20260209142257.936718725@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142256.797267956@linuxfoundation.org>
References: <20260209142256.797267956@linuxfoundation.org>
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

From: Maurizio Lombardi <mlombard@redhat.com>

[ Upstream commit 69b85e1f1d1d1e49601ec3e85d2031188657cca2 ]

Makes the code easier to read and to debug.

Sets the freed pointers to NULL, it will be useful
when destroying the queues to understand if the commands'
buffers have been released already or not.

Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
Reviewed-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: John Meneghini <jmeneghi@redhat.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Stable-dep-of: 52a0a9854934 ("nvmet-tcp: add bounds checks in nvmet_tcp_build_pdu_iovec")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/tcp.c | 28 +++++++++++++++++++---------
 1 file changed, 19 insertions(+), 9 deletions(-)

diff --git a/drivers/nvme/target/tcp.c b/drivers/nvme/target/tcp.c
index 94ed4b5b725c7..3c0769d40edd3 100644
--- a/drivers/nvme/target/tcp.c
+++ b/drivers/nvme/target/tcp.c
@@ -155,6 +155,8 @@ static struct workqueue_struct *nvmet_tcp_wq;
 static const struct nvmet_fabrics_ops nvmet_tcp_ops;
 static void nvmet_tcp_free_cmd(struct nvmet_tcp_cmd *c);
 static void nvmet_tcp_finish_cmd(struct nvmet_tcp_cmd *cmd);
+static void nvmet_tcp_free_cmd_buffers(struct nvmet_tcp_cmd *cmd);
+static void nvmet_tcp_unmap_pdu_iovec(struct nvmet_tcp_cmd *cmd);
 
 static inline u16 nvmet_tcp_cmd_tag(struct nvmet_tcp_queue *queue,
 		struct nvmet_tcp_cmd *cmd)
@@ -286,6 +288,16 @@ static int nvmet_tcp_check_ddgst(struct nvmet_tcp_queue *queue, void *pdu)
 	return 0;
 }
 
+static void nvmet_tcp_free_cmd_buffers(struct nvmet_tcp_cmd *cmd)
+{
+	WARN_ON(unlikely(cmd->nr_mapped > 0));
+
+	kfree(cmd->iov);
+	sgl_free(cmd->req.sg);
+	cmd->iov = NULL;
+	cmd->req.sg = NULL;
+}
+
 static void nvmet_tcp_unmap_pdu_iovec(struct nvmet_tcp_cmd *cmd)
 {
 	struct scatterlist *sg;
@@ -295,6 +307,8 @@ static void nvmet_tcp_unmap_pdu_iovec(struct nvmet_tcp_cmd *cmd)
 
 	for (i = 0; i < cmd->nr_mapped; i++)
 		kunmap(sg_page(&sg[i]));
+
+	cmd->nr_mapped = 0;
 }
 
 static void nvmet_tcp_map_pdu_iovec(struct nvmet_tcp_cmd *cmd)
@@ -377,7 +391,7 @@ static int nvmet_tcp_map_data(struct nvmet_tcp_cmd *cmd)
 
 	return 0;
 err:
-	sgl_free(cmd->req.sg);
+	nvmet_tcp_free_cmd_buffers(cmd);
 	return NVME_SC_INTERNAL;
 }
 
@@ -628,10 +642,8 @@ static int nvmet_try_send_data(struct nvmet_tcp_cmd *cmd, bool last_in_batch)
 		}
 	}
 
-	if (queue->nvme_sq.sqhd_disabled) {
-		kfree(cmd->iov);
-		sgl_free(cmd->req.sg);
-	}
+	if (queue->nvme_sq.sqhd_disabled)
+		nvmet_tcp_free_cmd_buffers(cmd);
 
 	return 1;
 
@@ -660,8 +672,7 @@ static int nvmet_try_send_response(struct nvmet_tcp_cmd *cmd,
 	if (left)
 		return -EAGAIN;
 
-	kfree(cmd->iov);
-	sgl_free(cmd->req.sg);
+	nvmet_tcp_free_cmd_buffers(cmd);
 	cmd->queue->snd_cmd = NULL;
 	nvmet_tcp_put_cmd(cmd);
 	return 1;
@@ -1422,8 +1433,7 @@ static void nvmet_tcp_finish_cmd(struct nvmet_tcp_cmd *cmd)
 {
 	nvmet_req_uninit(&cmd->req);
 	nvmet_tcp_unmap_pdu_iovec(cmd);
-	kfree(cmd->iov);
-	sgl_free(cmd->req.sg);
+	nvmet_tcp_free_cmd_buffers(cmd);
 }
 
 static void nvmet_tcp_uninit_data_in_cmds(struct nvmet_tcp_queue *queue)
-- 
2.51.0



