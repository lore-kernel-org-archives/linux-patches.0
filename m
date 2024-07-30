Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5022229A2;
	Tue, 30 Jul 2024 15:54:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722354895; cv=none; b=Un+wTuSB4mCjfRZQPPFFrepg2Ya/1So/3apZmi6m6cO+DRfq9gd5o4e9Wzfcg8yjbiU5A6uwM7TaVnmRJ7eUiTyDsMphRh+0hTAQaOsSNH8lvNtXWDcxoC+p+ZCIHQnZwKd3rUsMAi/kGsEPNRyShm5b1TIVVEfUSeBbFrFtews=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722354895; c=relaxed/simple;
	bh=u1a1AlCIhJpcfOrVaFetlHhPL2MmfhgZ0DKL8cHk0eE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dNr0aF1OacFR2Y0n/Pmo6ct0lDZRmQQs2Tbf79r9zApd6tCHHcr+f8SjkjQh3fNBX7QTR75sX+cnNFc31KeoIq4n4yfvHrjN506fd5c2gZhatw5UZVdMZPK0VBYPf1zikkRbvaPOOArdi8hX4mLo9L8D8ROSX1qggdZc3Ta/5QQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KM+0VQrI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KM+0VQrI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC65EC32782;
	Tue, 30 Jul 2024 15:54:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722354895;
	bh=u1a1AlCIhJpcfOrVaFetlHhPL2MmfhgZ0DKL8cHk0eE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KM+0VQrI7tgLs0KHiTqaCIOIQfEkIKDqjLsaIjDuWIb0zE+7k9WdHBkEdR49gL4O4
	 UmWjxJd0u0Aq/oQJyMuVQ81A0Rx0/LpCEIKQyGlMEUKWTccFj2dZafy38rEhTMHR+9
	 s/4/C5LlFrEH43UsxLFTt0gxvzd3+zdr65LvbIQw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 007/568] ubd: refactor the interrupt handler
Date: Tue, 30 Jul 2024 17:41:54 +0200
Message-ID: <20240730151640.104248783@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 5db755fbb1a0de4a4cfd5d5edfaa19853b9c56e6 ]

Instead of a separate handler function that leaves no work in the
interrupt hanler itself, split out a per-request end I/O helper and
clean up the coding style and variable naming while we're at it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Acked-By: Anton Ivanov <anton.ivanov@cambridgegreys.com>
Link: https://lore.kernel.org/r/20240531074837.1648501-2-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 31ade7d4fdcf ("ubd: untagle discard vs write zeroes not support handling")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/um/drivers/ubd_kern.c | 49 ++++++++++++++------------------------
 1 file changed, 18 insertions(+), 31 deletions(-)

diff --git a/arch/um/drivers/ubd_kern.c b/arch/um/drivers/ubd_kern.c
index 81405aeab8bf1..73354782f5871 100644
--- a/arch/um/drivers/ubd_kern.c
+++ b/arch/um/drivers/ubd_kern.c
@@ -456,43 +456,30 @@ static int bulk_req_safe_read(
 	return n;
 }
 
-/* Called without dev->lock held, and only in interrupt context. */
-static void ubd_handler(void)
+static void ubd_end_request(struct io_thread_req *io_req)
 {
-	int n;
-	int count;
-
-	while(1){
-		n = bulk_req_safe_read(
-			thread_fd,
-			irq_req_buffer,
-			&irq_remainder,
-			&irq_remainder_size,
-			UBD_REQ_BUFFER_SIZE
-		);
-		if (n < 0) {
-			if(n == -EAGAIN)
-				break;
-			printk(KERN_ERR "spurious interrupt in ubd_handler, "
-			       "err = %d\n", -n);
-			return;
-		}
-		for (count = 0; count < n/sizeof(struct io_thread_req *); count++) {
-			struct io_thread_req *io_req = (*irq_req_buffer)[count];
-
-			if ((io_req->error == BLK_STS_NOTSUPP) && (req_op(io_req->req) == REQ_OP_DISCARD)) {
-				blk_queue_max_discard_sectors(io_req->req->q, 0);
-				blk_queue_max_write_zeroes_sectors(io_req->req->q, 0);
-			}
-			blk_mq_end_request(io_req->req, io_req->error);
-			kfree(io_req);
-		}
+	if (io_req->error == BLK_STS_NOTSUPP &&
+	    req_op(io_req->req) == REQ_OP_DISCARD) {
+		blk_queue_max_discard_sectors(io_req->req->q, 0);
+		blk_queue_max_write_zeroes_sectors(io_req->req->q, 0);
 	}
+	blk_mq_end_request(io_req->req, io_req->error);
+	kfree(io_req);
 }
 
 static irqreturn_t ubd_intr(int irq, void *dev)
 {
-	ubd_handler();
+	int len, i;
+
+	while ((len = bulk_req_safe_read(thread_fd, irq_req_buffer,
+			&irq_remainder, &irq_remainder_size,
+			UBD_REQ_BUFFER_SIZE)) >= 0) {
+		for (i = 0; i < len / sizeof(struct io_thread_req *); i++)
+			ubd_end_request((*irq_req_buffer)[i]);
+	}
+
+	if (len < 0 && len != -EAGAIN)
+		pr_err("spurious interrupt in %s, err = %d\n", __func__, len);
 	return IRQ_HANDLED;
 }
 
-- 
2.43.0



