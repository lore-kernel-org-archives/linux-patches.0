Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7206953A7;
	Fri,  6 Dec 2024 15:17:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733498238; cv=none; b=R3iA6iR0G0qeBJXuqzJL14cSqQErJSmbCnr3UQQ7xdmgzJdUCTmLmfWGS9FiZYPokwS/rxklPL3xrsnGDIIRdp1EpmLIL0xpUYM0v3fp2CK+5oVPzVKhT/GaYCJwEh9aJc/HyxbMAb7mUeqX8nNrFpobliWsQrnwvRpQ/n6DIVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733498238; c=relaxed/simple;
	bh=lTD3h9HPVTUKDJm/cruS1zkf/1/0O97YPHV7ALiC+xk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gKZknIpZTFS8cEiKsfjo9/c0tYKsY/kerxyBtRZ1ovnV25XNwn2Ybj5DihWEJHh1B3ssj3ti5JygQOw5gzaueYbmBtzZeAj+SUn8QL2AngdZHuX6hCX/JAmBAqhBJjwMcmJP14DAmaVEkKSaWTCv8+tBR/2zFSSy1oAi9xz79ZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pBJJqTw1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pBJJqTw1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAC56C4CED1;
	Fri,  6 Dec 2024 15:17:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733498238;
	bh=lTD3h9HPVTUKDJm/cruS1zkf/1/0O97YPHV7ALiC+xk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pBJJqTw171goR1qhvHb8ArGecGkCGABO7Imkmhk/KD51BCe2cjlqAqycZIxNfWG+N
	 NNcXqnIi2V3WVjj7v8OcF2oY+84ocK+qxgiRgYGqOyevHqLJi2oFPdbqlJLVJqrFyd
	 /EaWKr0Mw875bz76Lqd1+Yz+aI2DLKePuOZss/Kk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muchun Song <muchun.song@linux.dev>,
	Muchun Song <songmuchun@bytedance.com>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.6 526/676] block: fix missing dispatching request when queue is started or unquiesced
Date: Fri,  6 Dec 2024 15:35:45 +0100
Message-ID: <20241206143713.906340151@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

From: Muchun Song <songmuchun@bytedance.com>

commit 2003ee8a9aa14d766b06088156978d53c2e9be3d upstream.

Supposing the following scenario with a virtio_blk driver.

CPU0                    CPU1                    CPU2

blk_mq_try_issue_directly()
  __blk_mq_issue_directly()
    q->mq_ops->queue_rq()
      virtio_queue_rq()
        blk_mq_stop_hw_queue()
                                                virtblk_done()
                        blk_mq_try_issue_directly()
                          if (blk_mq_hctx_stopped())
  blk_mq_request_bypass_insert()                  blk_mq_run_hw_queue()
  blk_mq_run_hw_queue()     blk_mq_run_hw_queue()
                            blk_mq_insert_request()
                            return

After CPU0 has marked the queue as stopped, CPU1 will see the queue is
stopped. But before CPU1 puts the request on the dispatch list, CPU2
receives the interrupt of completion of request, so it will run the
hardware queue and marks the queue as non-stopped. Meanwhile, CPU1 also
runs the same hardware queue. After both CPU1 and CPU2 complete
blk_mq_run_hw_queue(), CPU1 just puts the request to the same hardware
queue and returns. It misses dispatching a request. Fix it by running
the hardware queue explicitly. And blk_mq_request_issue_directly()
should handle a similar situation. Fix it as well.

Fixes: d964f04a8fde ("blk-mq: fix direct issue")
Cc: stable@vger.kernel.org
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Link: https://lore.kernel.org/r/20241014092934.53630-2-songmuchun@bytedance.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/blk-mq.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2668,6 +2668,7 @@ static void blk_mq_try_issue_directly(st
 
 	if (blk_mq_hctx_stopped(hctx) || blk_queue_quiesced(rq->q)) {
 		blk_mq_insert_request(rq, 0);
+		blk_mq_run_hw_queue(hctx, false);
 		return;
 	}
 
@@ -2698,6 +2699,7 @@ static blk_status_t blk_mq_request_issue
 
 	if (blk_mq_hctx_stopped(hctx) || blk_queue_quiesced(rq->q)) {
 		blk_mq_insert_request(rq, 0);
+		blk_mq_run_hw_queue(hctx, false);
 		return BLK_STS_OK;
 	}
 


