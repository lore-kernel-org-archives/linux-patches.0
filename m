Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF2D528EE
	for <patches@lists.linux.dev>; Mon,  2 Jan 2023 11:27:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F18BC433EF;
	Mon,  2 Jan 2023 11:27:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672658841;
	bh=OZpJqhQAttmZZ/KRw6qYQwysnKhALi1konYZ7deLMIg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q1TSFrb5avNaIswQACcX9umCHNAY1waNG+PjBNFcxz2qjUAARa2MpClz0SRJvRgoE
	 pl8tlclYVI49Njc1f5W0VuLZlkyN1s8SaIHqnx345/3DmIDvGTWH/lzoM2qF86cPCu
	 QmO5RxnvSAOATO2LRyHiU83pCGN04oyZnjorUK8E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Andreas Herrmann <aherrmann@suse.de>,
	Tejun Heo <tj@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 02/74] blk-cgroup: fix error unwinding in blkcg_init_queue
Date: Mon,  2 Jan 2023 12:21:35 +0100
Message-Id: <20230102110552.167118885@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230102110552.061937047@linuxfoundation.org>
References: <20230102110552.061937047@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 33dc62796cb657a633050138a86253fb2a553713 ]

When blk_throtl_init fails, we need to call blk_ioprio_exit.  Switch to
proper goto based unwinding to fix this.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Andreas Herrmann <aherrmann@suse.de>
Acked-by: Tejun Heo <tj@kernel.org>
Link: https://lore.kernel.org/r/20220921180501.1539876-2-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 813e693023ba ("blk-iolatency: Fix memory leak on add_disk() failures")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-cgroup.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index c8f0c865bf4e..bcd3873ac5ff 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -1297,17 +1297,18 @@ int blkcg_init_queue(struct request_queue *q)
 
 	ret = blk_throtl_init(q);
 	if (ret)
-		goto err_destroy_all;
+		goto err_ioprio_exit;
 
 	ret = blk_iolatency_init(q);
-	if (ret) {
-		blk_throtl_exit(q);
-		blk_ioprio_exit(q);
-		goto err_destroy_all;
-	}
+	if (ret)
+		goto err_throtl_exit;
 
 	return 0;
 
+err_throtl_exit:
+	blk_throtl_exit(q);
+err_ioprio_exit:
+	blk_ioprio_exit(q);
 err_destroy_all:
 	blkg_destroy_all(q);
 	return ret;
-- 
2.35.1



