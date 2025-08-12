Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33ECF22425B;
	Tue, 12 Aug 2025 19:02:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025366; cv=none; b=Q6coS+EcxioWyhc8ESQTky00FBu3I5M4VTOeeY00NAckBE3JjCYSSt5OFnAD5YZppauCHiML4gLT6+Z9iUS6wg40f+ir8/+cMLxXQ+xEB9qnbHme9foUTmosx766Qq4vwYopIcaSA0DUqPa+Hht7fb21krOSlmAJ3szevQjoJ7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025366; c=relaxed/simple;
	bh=sNoy71YK04Pha5O9dwOGOWCuDmj4Nzg7tCqVJHrwZAQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eL0U0NcWmIRVQdbcvp6eHEVhtbo2rVos5OqUECBpUZ0PX6f9DhvAFd//JPzkWXcmhGqxWIUtUlT6oBp7kAcZO48H2yS6bTYqhArdhBREypVjjxWSKiebwYO1rd9KaZ9vanVIkMMC9O1LLa6I+x8wABML47t0EBBCDfefJcCmcBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BECghIiJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BECghIiJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95E7DC4CEF1;
	Tue, 12 Aug 2025 19:02:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025366;
	bh=sNoy71YK04Pha5O9dwOGOWCuDmj4Nzg7tCqVJHrwZAQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BECghIiJSEVUKtaySKo0Rw8qV0cgZFtxkqlp3qaVXKlbTdKXgP3WA/WNFMi3zSsjy
	 S317cmwFXFB/3jAnrTzz8vZV/xZ6aKpYRoVBfAqDDqOcnq0GKst1USiJkyM/DFCEgr
	 FcmWxSF5l6WwR24VRCMvv+s4uJAr5IoA5aRfPmv0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 021/480] block: mtip32xx: Fix usage of dma_map_sg()
Date: Tue, 12 Aug 2025 19:43:49 +0200
Message-ID: <20250812174358.182391367@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Fourier <fourier.thomas@gmail.com>

[ Upstream commit 8e1fab9cccc7b806b0cffdceabb09b310b83b553 ]

The dma_map_sg() can fail and, in case of failure, returns 0.  If it
fails, mtip_hw_submit_io() returns an error.

The dma_unmap_sg() requires the nents parameter to be the same as the
one passed to dma_map_sg(). This patch saves the nents in
command->scatter_ents.

Fixes: 88523a61558a ("block: Add driver for Micron RealSSD pcie flash cards")
Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20250627121123.203731-2-fourier.thomas@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/mtip32xx/mtip32xx.c | 27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff --git a/drivers/block/mtip32xx/mtip32xx.c b/drivers/block/mtip32xx/mtip32xx.c
index 0d619df03fa9..fe3a0b8377db 100644
--- a/drivers/block/mtip32xx/mtip32xx.c
+++ b/drivers/block/mtip32xx/mtip32xx.c
@@ -2040,11 +2040,12 @@ static int mtip_hw_ioctl(struct driver_data *dd, unsigned int cmd,
  * @dir      Direction (read or write)
  *
  * return value
- *	None
+ *	0	The IO completed successfully.
+ *	-ENOMEM	The DMA mapping failed.
  */
-static void mtip_hw_submit_io(struct driver_data *dd, struct request *rq,
-			      struct mtip_cmd *command,
-			      struct blk_mq_hw_ctx *hctx)
+static int mtip_hw_submit_io(struct driver_data *dd, struct request *rq,
+			     struct mtip_cmd *command,
+			     struct blk_mq_hw_ctx *hctx)
 {
 	struct mtip_cmd_hdr *hdr =
 		dd->port->command_list + sizeof(struct mtip_cmd_hdr) * rq->tag;
@@ -2056,12 +2057,14 @@ static void mtip_hw_submit_io(struct driver_data *dd, struct request *rq,
 	unsigned int nents;
 
 	/* Map the scatter list for DMA access */
-	nents = blk_rq_map_sg(rq, command->sg);
-	nents = dma_map_sg(&dd->pdev->dev, command->sg, nents, dma_dir);
+	command->scatter_ents = blk_rq_map_sg(rq, command->sg);
+	nents = dma_map_sg(&dd->pdev->dev, command->sg,
+			   command->scatter_ents, dma_dir);
+	if (!nents)
+		return -ENOMEM;
 
-	prefetch(&port->flags);
 
-	command->scatter_ents = nents;
+	prefetch(&port->flags);
 
 	/*
 	 * The number of retries for this command before it is
@@ -2112,11 +2115,13 @@ static void mtip_hw_submit_io(struct driver_data *dd, struct request *rq,
 	if (unlikely(port->flags & MTIP_PF_PAUSE_IO)) {
 		set_bit(rq->tag, port->cmds_to_issue);
 		set_bit(MTIP_PF_ISSUE_CMDS_BIT, &port->flags);
-		return;
+		return 0;
 	}
 
 	/* Issue the command to the hardware */
 	mtip_issue_ncq_command(port, rq->tag);
+
+	return 0;
 }
 
 /*
@@ -3315,7 +3320,9 @@ static blk_status_t mtip_queue_rq(struct blk_mq_hw_ctx *hctx,
 
 	blk_mq_start_request(rq);
 
-	mtip_hw_submit_io(dd, rq, cmd, hctx);
+	if (mtip_hw_submit_io(dd, rq, cmd, hctx))
+		return BLK_STS_IOERR;
+
 	return BLK_STS_OK;
 }
 
-- 
2.39.5



