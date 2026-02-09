Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32A182750E6;
	Mon,  9 Feb 2026 14:56:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770649019; cv=none; b=X6hTCnF/Q3LL8vgWkMt1rQTjqqeU9+dOUArTPuLVZaxfRLWSRhwvOPKjFhTUy4E//mPxJpLrKw1WLsX98yzvEw0uCoFzHGtpMWVV20g9E4vU2VSZP7ZTBgGOKldBRSVgim1OT8vAuWeu/c50xaik7s/9ef46nXf2aYkOi+S4JNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770649019; c=relaxed/simple;
	bh=7pyYBDjYVsdxGkkL8Rjik1290kBOsxrSOvfXcx7rnk0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Sf+lsFnrCpZ9lbbXnIpoLYYh5rGD9aO+16fDl/nNZRuU0oIpCEysemideVJgPmR33UpcblGHy45ye3taZTktvpkNb/BpnRUm1OkXyFjs92RFZ4sTfUnQcHeQ/Wf/BPf4vmJzqEY9heGwSAoz5sBe5WRzPX8SpqllUZ798+RsrLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2HUs1p42; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2HUs1p42"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D12DC116C6;
	Mon,  9 Feb 2026 14:56:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770649019;
	bh=7pyYBDjYVsdxGkkL8Rjik1290kBOsxrSOvfXcx7rnk0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2HUs1p42XRpvodGbaLGUf/rzTvvd6XwOhVyYQ7wE8znbUkJ7XO+/mY6b7nrd4lY7A
	 L0w16rIPE7WrLzEIsNdhfE+hI3mf+p2UzdId4P64cfs+kYkSiSCdz0VCfU3x9WyGCX
	 kRnPNzfasGdb5FK4w7yWWpeD4o2MeSmpT3x4b0Vk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chaitanya Kulkarni <chaitanyak@nvidia.com>,
	Keith Busch <kbusch@kernel.org>,
	Ira Weiny <ira.weiny@intel.com>,
	"Fabio M. De Francesco" <fmdefrancesco@gmail.com>,
	Christoph Hellwig <hch@lst.de>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sagi Grimberg <sagi@grimberg.me>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 58/75] nvmet-tcp: dont map pages which cant come from HIGHMEM
Date: Mon,  9 Feb 2026 15:24:55 +0100
Message-ID: <20260209142303.933882496@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142301.830618238@linuxfoundation.org>
References: <20260209142301.830618238@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fabio M. De Francesco <fmdefrancesco@gmail.com>

[ Upstream commit 5bfaba275ae6486700194cad962574e3eb7ae60d ]

kmap() is being deprecated in favor of kmap_local_page().[1]

There are two main problems with kmap(): (1) It comes with an overhead as
mapping space is restricted and protected by a global lock for
synchronization and (2) it also requires global TLB invalidation when the
kmap’s pool wraps and it might block when the mapping space is fully
utilized until a slot becomes available.

The pages which will be mapped are allocated in nvmet_tcp_map_data(),
using the GFP_KERNEL flag. This assures that they cannot come from
HIGHMEM. This imply that a straight page_address() can replace the kmap()
of sg_page(sg) in nvmet_tcp_map_pdu_iovec(). As a side effect, we might
also delete the field "nr_mapped" from struct "nvmet_tcp_cmd" because,
after removing the kmap() calls, there would be no longer any need of it.

In addition, there is no reason to use a kvec for the command receive
data buffers iovec, use a bio_vec instead and let iov_iter handle the
buffer mapping and data copy.

Test with blktests on a QEMU/KVM x86_32 VM, 6GB RAM, booting a kernel with
HIGHMEM64GB enabled.

[1] "[PATCH] checkpatch: Add kmap and kmap_atomic to the deprecated
list" https://lore.kernel.org/all/20220813220034.806698-1-ira.weiny@intel.com/

Cc: Chaitanya Kulkarni <chaitanyak@nvidia.com>
Cc: Keith Busch <kbusch@kernel.org>
Suggested-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Fabio M. De Francesco <fmdefrancesco@gmail.com>
Suggested-by: Christoph Hellwig <hch@lst.de>
Suggested-by: Al Viro <viro@zeniv.linux.org.uk>
[sagi: added bio_vec plus minor naming changes]
Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Stable-dep-of: 52a0a9854934 ("nvmet-tcp: add bounds checks in nvmet_tcp_build_pdu_iovec")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/tcp.c | 44 ++++++++++++---------------------------
 1 file changed, 13 insertions(+), 31 deletions(-)

diff --git a/drivers/nvme/target/tcp.c b/drivers/nvme/target/tcp.c
index 3b32f1e9c18c6..d0fcce6aec93f 100644
--- a/drivers/nvme/target/tcp.c
+++ b/drivers/nvme/target/tcp.c
@@ -78,9 +78,8 @@ struct nvmet_tcp_cmd {
 	u32				pdu_len;
 	u32				pdu_recv;
 	int				sg_idx;
-	int				nr_mapped;
 	struct msghdr			recv_msg;
-	struct kvec			*iov;
+	struct bio_vec			*iov;
 	u32				flags;
 
 	struct list_head		entry;
@@ -168,7 +167,6 @@ static const struct nvmet_fabrics_ops nvmet_tcp_ops;
 static void nvmet_tcp_free_cmd(struct nvmet_tcp_cmd *c);
 static void nvmet_tcp_finish_cmd(struct nvmet_tcp_cmd *cmd);
 static void nvmet_tcp_free_cmd_buffers(struct nvmet_tcp_cmd *cmd);
-static void nvmet_tcp_unmap_pdu_iovec(struct nvmet_tcp_cmd *cmd);
 
 static inline u16 nvmet_tcp_cmd_tag(struct nvmet_tcp_queue *queue,
 		struct nvmet_tcp_cmd *cmd)
@@ -302,35 +300,21 @@ static int nvmet_tcp_check_ddgst(struct nvmet_tcp_queue *queue, void *pdu)
 
 static void nvmet_tcp_free_cmd_buffers(struct nvmet_tcp_cmd *cmd)
 {
-	WARN_ON(unlikely(cmd->nr_mapped > 0));
-
 	kfree(cmd->iov);
 	sgl_free(cmd->req.sg);
 	cmd->iov = NULL;
 	cmd->req.sg = NULL;
 }
 
-static void nvmet_tcp_unmap_pdu_iovec(struct nvmet_tcp_cmd *cmd)
-{
-	struct scatterlist *sg;
-	int i;
-
-	sg = &cmd->req.sg[cmd->sg_idx];
-
-	for (i = 0; i < cmd->nr_mapped; i++)
-		kunmap(sg_page(&sg[i]));
-
-	cmd->nr_mapped = 0;
-}
-
-static void nvmet_tcp_map_pdu_iovec(struct nvmet_tcp_cmd *cmd)
+static void nvmet_tcp_build_pdu_iovec(struct nvmet_tcp_cmd *cmd)
 {
-	struct kvec *iov = cmd->iov;
+	struct bio_vec *iov = cmd->iov;
 	struct scatterlist *sg;
 	u32 length, offset, sg_offset;
+	int nr_pages;
 
 	length = cmd->pdu_len;
-	cmd->nr_mapped = DIV_ROUND_UP(length, PAGE_SIZE);
+	nr_pages = DIV_ROUND_UP(length, PAGE_SIZE);
 	offset = cmd->rbytes_done;
 	cmd->sg_idx = offset / PAGE_SIZE;
 	sg_offset = offset % PAGE_SIZE;
@@ -339,8 +323,9 @@ static void nvmet_tcp_map_pdu_iovec(struct nvmet_tcp_cmd *cmd)
 	while (length) {
 		u32 iov_len = min_t(u32, length, sg->length - sg_offset);
 
-		iov->iov_base = kmap(sg_page(sg)) + sg->offset + sg_offset;
-		iov->iov_len = iov_len;
+		iov->bv_page = sg_page(sg);
+		iov->bv_len = sg->length;
+		iov->bv_offset = sg->offset + sg_offset;
 
 		length -= iov_len;
 		sg = sg_next(sg);
@@ -348,8 +333,8 @@ static void nvmet_tcp_map_pdu_iovec(struct nvmet_tcp_cmd *cmd)
 		sg_offset = 0;
 	}
 
-	iov_iter_kvec(&cmd->recv_msg.msg_iter, READ, cmd->iov,
-		cmd->nr_mapped, cmd->pdu_len);
+	iov_iter_bvec(&cmd->recv_msg.msg_iter, READ, cmd->iov,
+		      nr_pages, cmd->pdu_len);
 }
 
 static void nvmet_tcp_fatal_error(struct nvmet_tcp_queue *queue)
@@ -925,7 +910,7 @@ static void nvmet_tcp_handle_req_failure(struct nvmet_tcp_queue *queue,
 	}
 
 	queue->rcv_state = NVMET_TCP_RECV_DATA;
-	nvmet_tcp_map_pdu_iovec(cmd);
+	nvmet_tcp_build_pdu_iovec(cmd);
 	cmd->flags |= NVMET_TCP_F_INIT_FAILED;
 }
 
@@ -978,7 +963,7 @@ static int nvmet_tcp_handle_h2c_data_pdu(struct nvmet_tcp_queue *queue)
 		goto err_proto;
 	}
 	cmd->pdu_recv = 0;
-	nvmet_tcp_map_pdu_iovec(cmd);
+	nvmet_tcp_build_pdu_iovec(cmd);
 	queue->cmd = cmd;
 	queue->rcv_state = NVMET_TCP_RECV_DATA;
 
@@ -1052,7 +1037,7 @@ static int nvmet_tcp_done_recv_pdu(struct nvmet_tcp_queue *queue)
 	if (nvmet_tcp_need_data_in(queue->cmd)) {
 		if (nvmet_tcp_has_inline_data(queue->cmd)) {
 			queue->rcv_state = NVMET_TCP_RECV_DATA;
-			nvmet_tcp_map_pdu_iovec(queue->cmd);
+			nvmet_tcp_build_pdu_iovec(queue->cmd);
 			return 0;
 		}
 		/* send back R2T */
@@ -1172,7 +1157,6 @@ static int nvmet_tcp_try_recv_data(struct nvmet_tcp_queue *queue)
 		cmd->rbytes_done += ret;
 	}
 
-	nvmet_tcp_unmap_pdu_iovec(cmd);
 	if (queue->data_digest) {
 		nvmet_tcp_prep_recv_ddgst(cmd);
 		return 0;
@@ -1445,7 +1429,6 @@ static void nvmet_tcp_restore_socket_callbacks(struct nvmet_tcp_queue *queue)
 static void nvmet_tcp_finish_cmd(struct nvmet_tcp_cmd *cmd)
 {
 	nvmet_req_uninit(&cmd->req);
-	nvmet_tcp_unmap_pdu_iovec(cmd);
 	nvmet_tcp_free_cmd_buffers(cmd);
 }
 
@@ -1458,7 +1441,6 @@ static void nvmet_tcp_uninit_data_in_cmds(struct nvmet_tcp_queue *queue)
 		if (nvmet_tcp_need_data_in(cmd))
 			nvmet_req_uninit(&cmd->req);
 
-		nvmet_tcp_unmap_pdu_iovec(cmd);
 		nvmet_tcp_free_cmd_buffers(cmd);
 	}
 
-- 
2.51.0



