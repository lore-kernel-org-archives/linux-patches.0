Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AADC11DE4C9;
	Wed, 19 Mar 2025 14:39:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395156; cv=none; b=ONLfLJs+xgBw7yyWCawJUYZ+ecOkdBKstVWRpSlXyHl8a3dxRTUzez+/rR55oZJNE2AFmIt/CsEIFf/h4bMBLhDACLCUY+7BDsQAnMtzf2rIIJOo//ANpIust54RnSvi+ebeQRocvTcssaT73J+geD4X05+p8mjXGiiuuFNPiQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395156; c=relaxed/simple;
	bh=ghpgAG/qC9vOcP5lnDG0IuzHc+o3Wr4P6uv2t21MBAo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sTHUHfQXvJxp+NeLA5DhuJ0/BDV39C9lW/29xEfT8KO9NwxB3q/uK2yOsBNrfyzhZLJm3VzxnDlxmU4PV6oWCCqZmIma5mioZpMDmVZnxM2ELZusxc7OujXFHgCk69HKtrYFSaygBcCrzQDTSYP/YApuiQxZh3cN+qXer7Jg364=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GEA4lHXd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GEA4lHXd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 778FBC4CEE4;
	Wed, 19 Mar 2025 14:39:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395156;
	bh=ghpgAG/qC9vOcP5lnDG0IuzHc+o3Wr4P6uv2t21MBAo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GEA4lHXdeRUqK7lLfrYQTPPn9RG9ybhR9cD8A/FwZ2xfoymmZiBoxqN0iIG3pIG6q
	 0PFfD7z+M57HIwRvP6G+20Wpm7FrwWhMMXXS5u9mx4Hhu84lZEAGS1WCHhWiKvtSM6
	 mdSy3h8VMVPIiMBvu/X1STFPe6YJ3XFpB5tRHXXI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 214/231] block: change blk_mq_add_to_batch() third argument type to bool
Date: Wed, 19 Mar 2025 07:31:47 -0700
Message-ID: <20250319143032.135881493@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143026.865956961@linuxfoundation.org>
References: <20250319143026.865956961@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>

[ Upstream commit 9bce6b5f8987678b9c6c1fe433af6b5fe41feadc ]

Commit 1f47ed294a2b ("block: cleanup and fix batch completion adding
conditions") modified the evaluation criteria for the third argument,
'ioerror', in the blk_mq_add_to_batch() function. Initially, the
function had checked if 'ioerror' equals zero. Following the commit, it
started checking for negative error values, with the presumption that
such values, for instance -EIO, would be passed in.

However, blk_mq_add_to_batch() callers do not pass negative error
values. Instead, they pass status codes defined in various ways:

- NVMe PCI and Apple drivers pass NVMe status code
- virtio_blk driver passes the virtblk request header status byte
- null_blk driver passes blk_status_t

These codes are either zero or positive, therefore the revised check
fails to function as intended. Specifically, with the NVMe PCI driver,
this modification led to the failure of the blktests test case nvme/039.
In this test scenario, errors are artificially injected to the NVMe
driver, resulting in positive NVMe status codes passed to
blk_mq_add_to_batch(), which unexpectedly processes the failed I/O in a
batch. Hence the failure.

To correct the ioerror check within blk_mq_add_to_batch(), make all
callers to uniformly pass the argument as boolean. Modify the callers to
check their specific status codes and pass the boolean value 'is_error'.
Also describe the arguments of blK_mq_add_to_batch as kerneldoc.

Fixes: 1f47ed294a2b ("block: cleanup and fix batch completion adding conditions")
Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Link: https://lore.kernel.org/r/20250311104359.1767728-3-shinichiro.kawasaki@wdc.com
[axboe: fold in documentation update]
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/null_blk/main.c |  4 ++--
 drivers/block/virtio_blk.c    |  5 +++--
 drivers/nvme/host/apple.c     |  3 ++-
 drivers/nvme/host/pci.c       |  5 +++--
 include/linux/blk-mq.h        | 16 ++++++++++++----
 5 files changed, 22 insertions(+), 11 deletions(-)

diff --git a/drivers/block/null_blk/main.c b/drivers/block/null_blk/main.c
index 2f0431e42c494..c479348ce8ff6 100644
--- a/drivers/block/null_blk/main.c
+++ b/drivers/block/null_blk/main.c
@@ -1541,8 +1541,8 @@ static int null_poll(struct blk_mq_hw_ctx *hctx, struct io_comp_batch *iob)
 		cmd = blk_mq_rq_to_pdu(req);
 		cmd->error = null_process_cmd(cmd, req_op(req), blk_rq_pos(req),
 						blk_rq_sectors(req));
-		if (!blk_mq_add_to_batch(req, iob, (__force int) cmd->error,
-					blk_mq_end_request_batch))
+		if (!blk_mq_add_to_batch(req, iob, cmd->error != BLK_STS_OK,
+					 blk_mq_end_request_batch))
 			blk_mq_end_request(req, cmd->error);
 		nr++;
 	}
diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 0e50b65e1dbf5..44a6937a4b65c 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -1210,11 +1210,12 @@ static int virtblk_poll(struct blk_mq_hw_ctx *hctx, struct io_comp_batch *iob)
 
 	while ((vbr = virtqueue_get_buf(vq->vq, &len)) != NULL) {
 		struct request *req = blk_mq_rq_from_pdu(vbr);
+		u8 status = virtblk_vbr_status(vbr);
 
 		found++;
 		if (!blk_mq_complete_request_remote(req) &&
-		    !blk_mq_add_to_batch(req, iob, virtblk_vbr_status(vbr),
-						virtblk_complete_batch))
+		    !blk_mq_add_to_batch(req, iob, status != VIRTIO_BLK_S_OK,
+					 virtblk_complete_batch))
 			virtblk_request_done(req);
 	}
 
diff --git a/drivers/nvme/host/apple.c b/drivers/nvme/host/apple.c
index df054cd38c3e3..e79a0adf13950 100644
--- a/drivers/nvme/host/apple.c
+++ b/drivers/nvme/host/apple.c
@@ -599,7 +599,8 @@ static inline void apple_nvme_handle_cqe(struct apple_nvme_queue *q,
 	}
 
 	if (!nvme_try_complete_req(req, cqe->status, cqe->result) &&
-	    !blk_mq_add_to_batch(req, iob, nvme_req(req)->status,
+	    !blk_mq_add_to_batch(req, iob,
+				 nvme_req(req)->status != NVME_SC_SUCCESS,
 				 apple_nvme_complete_batch))
 		apple_nvme_complete_rq(req);
 }
diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 1fbb5f7a9f239..1d3205f08af84 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -1131,8 +1131,9 @@ static inline void nvme_handle_cqe(struct nvme_queue *nvmeq,
 
 	trace_nvme_sq(req, cqe->sq_head, nvmeq->sq_tail);
 	if (!nvme_try_complete_req(req, cqe->status, cqe->result) &&
-	    !blk_mq_add_to_batch(req, iob, nvme_req(req)->status,
-					nvme_pci_complete_batch))
+	    !blk_mq_add_to_batch(req, iob,
+				 nvme_req(req)->status != NVME_SC_SUCCESS,
+				 nvme_pci_complete_batch))
 		nvme_pci_complete_rq(req);
 }
 
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index a53cbe2569104..7b5e5388c3801 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -871,12 +871,20 @@ static inline bool blk_mq_is_reserved_rq(struct request *rq)
 	return rq->rq_flags & RQF_RESV;
 }
 
-/*
+/**
+ * blk_mq_add_to_batch() - add a request to the completion batch
+ * @req: The request to add to batch
+ * @iob: The batch to add the request
+ * @is_error: Specify true if the request failed with an error
+ * @complete: The completaion handler for the request
+ *
  * Batched completions only work when there is no I/O error and no special
  * ->end_io handler.
+ *
+ * Return: true when the request was added to the batch, otherwise false
  */
 static inline bool blk_mq_add_to_batch(struct request *req,
-				       struct io_comp_batch *iob, int ioerror,
+				       struct io_comp_batch *iob, bool is_error,
 				       void (*complete)(struct io_comp_batch *))
 {
 	/*
@@ -884,7 +892,7 @@ static inline bool blk_mq_add_to_batch(struct request *req,
 	 * 1) No batch container
 	 * 2) Has scheduler data attached
 	 * 3) Not a passthrough request and end_io set
-	 * 4) Not a passthrough request and an ioerror
+	 * 4) Not a passthrough request and failed with an error
 	 */
 	if (!iob)
 		return false;
@@ -893,7 +901,7 @@ static inline bool blk_mq_add_to_batch(struct request *req,
 	if (!blk_rq_is_passthrough(req)) {
 		if (req->end_io)
 			return false;
-		if (ioerror < 0)
+		if (is_error)
 			return false;
 	}
 
-- 
2.39.5



