Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5401424A07B;
	Tue, 29 Apr 2025 17:09:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946559; cv=none; b=lW5TQ6gDDSDbmqscUEJZI/eNGCd2TbHX33LBwdG996ngRPdbKJSKgK+pENp96UXmLyvmNzAY8OA/UbnWjzU3ARoDMKy22DQgjsNGNtBPlEBYXeUXH15C0yxrI/7YhkWnibB1Oi/OpfZdlxqeqAOKleqheWUngI1w/RFkmVkAyHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946559; c=relaxed/simple;
	bh=pCXMWRE9G6MHl/aUkkehws375oPGhbSHQQcfE5dlpnU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=svzIfI7KRQW1QtZkLC/16VGvvnrrO2srNUFZ4KIWr6NbaRBiPmB0R/Ni7LiJ4F5uiTPLgM4LaC6hd3GfUNuwFGm6EPWj0Kz5danrhcvAz+jj+hyNXyYxG54yanL+vPHsgW+D9hULNsQ20KfEksI2mVCv4vDB6g/xDpNLaLmptgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vd2EqqjK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vd2EqqjK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E232C4CEEA;
	Tue, 29 Apr 2025 17:09:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946558;
	bh=pCXMWRE9G6MHl/aUkkehws375oPGhbSHQQcfE5dlpnU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vd2EqqjKLTtooVwZSMrSDNYXeUlZaNi8JaxE+YLaRbHtLdOD46mtun6xQXVdAtyDF
	 5O0lYwkbh9y8TPAC4RCXPxC2ikkkT6Ok2ohbL5PiX11JZGvwx1v7heiy8704FFodHZ
	 fxQ1bN4kBGQ4YpkFEf9waVtyE+/XYBxK31n+dkpI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Uday Shankar <ushankar@purestorage.com>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.14 306/311] ublk: dont fail request for recovery & reissue in case of ubq->canceling
Date: Tue, 29 Apr 2025 18:42:23 +0200
Message-ID: <20250429161133.531439410@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Lei <ming.lei@redhat.com>

commit 18461f2a02be04f8bbbe3b37fecfc702e3fa5bc2 upstream.

ubq->canceling is set with request queue quiesced when io_uring context is
exiting. USER_RECOVERY or !RECOVERY_FAIL_IO requires request to be re-queued
and re-dispatch after device is recovered.

However commit d796cea7b9f3 ("ublk: implement ->queue_rqs()") still may fail
any request in case of ubq->canceling, this way breaks USER_RECOVERY or
!RECOVERY_FAIL_IO.

Fix it by calling __ublk_abort_rq() in case of ubq->canceling.

Reviewed-by: Uday Shankar <ushankar@purestorage.com>
Reported-by: Uday Shankar <ushankar@purestorage.com>
Closes: https://lore.kernel.org/linux-block/Z%2FQkkTRHfRxtN%2FmB@dev-ushankar.dev.purestorage.com/
Fixes: d796cea7b9f3 ("ublk: implement ->queue_rqs()")
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Link: https://lore.kernel.org/r/20250409011444.2142010-3-ming.lei@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/ublk_drv.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -1336,7 +1336,8 @@ static enum blk_eh_timer_return ublk_tim
 	return BLK_EH_RESET_TIMER;
 }
 
-static blk_status_t ublk_prep_req(struct ublk_queue *ubq, struct request *rq)
+static blk_status_t ublk_prep_req(struct ublk_queue *ubq, struct request *rq,
+				  bool check_cancel)
 {
 	blk_status_t res;
 
@@ -1355,7 +1356,7 @@ static blk_status_t ublk_prep_req(struct
 	if (ublk_nosrv_should_queue_io(ubq) && unlikely(ubq->force_abort))
 		return BLK_STS_IOERR;
 
-	if (unlikely(ubq->canceling))
+	if (check_cancel && unlikely(ubq->canceling))
 		return BLK_STS_IOERR;
 
 	/* fill iod to slot in io cmd buffer */
@@ -1374,7 +1375,7 @@ static blk_status_t ublk_queue_rq(struct
 	struct request *rq = bd->rq;
 	blk_status_t res;
 
-	res = ublk_prep_req(ubq, rq);
+	res = ublk_prep_req(ubq, rq, false);
 	if (res != BLK_STS_OK)
 		return res;
 
@@ -1406,7 +1407,7 @@ static void ublk_queue_rqs(struct rq_lis
 			ublk_queue_cmd_list(ubq, &submit_list);
 		ubq = this_q;
 
-		if (ublk_prep_req(ubq, req) == BLK_STS_OK)
+		if (ublk_prep_req(ubq, req, true) == BLK_STS_OK)
 			rq_list_add_tail(&submit_list, req);
 		else
 			rq_list_add_tail(&requeue_list, req);


