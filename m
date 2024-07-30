Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FFE129A2;
	Tue, 30 Jul 2024 15:56:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355004; cv=none; b=uF562KbQRLFS/TGyp9zB9OwmXzgWvubZRF4FTNI/EJaheiEq77EievotUhpbzRYQsDPsUSm+BXR9WMYx2Sed6BnMBjUNuGcsDcnwNbvf4UEKKJ1CyhGJBBxEQ56/1l/XYETLJnDs5x0oJuXeM0GnqzxBYaE7yCTmkG2l9U3Ardc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355004; c=relaxed/simple;
	bh=Zf3s8ZDX+gHmpl/4qgwKtSgpCKW6Yyt6VVHqDS7hmis=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PEoYuSSgBHZs5YX1lL+43Yqb+59LRitvbOKz7NfW17hIrBbpCNi9Q/Ko4sVD+yQmSQuVVYaLb9HNdW6sqRQUVBSWcARpkPMKnXwtIkzu6eQdf5M4FRk/n1FWO/X7dhBr+SNDdtFnThcCAlaa9/dj/Xdq+ThfK80uZ7TVgl75fJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wE9F9Hil; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wE9F9Hil"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17C73C32782;
	Tue, 30 Jul 2024 15:56:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355004;
	bh=Zf3s8ZDX+gHmpl/4qgwKtSgpCKW6Yyt6VVHqDS7hmis=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wE9F9HilcXT4zuFi5dteT8ytJTHBrsLTFLWMawMnebFKHhwqClrHLuqHZ8ADPW5AS
	 nLkfQADDzAHetoipyb87fPKNZtDm6gknDyX9CEewXF/WUzFRDATqbw5wBVCLabmzmi
	 3dM4Pg9y/QWF+8vwsCoicRLF3j15Kn3kKbfelUJ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Zhiguo Niu <zhiguo.niu@unisoc.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 019/568] block: Call .limit_depth() after .hctx has been set
Date: Tue, 30 Jul 2024 17:42:06 +0200
Message-ID: <20240730151640.581782277@linuxfoundation.org>
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

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit 6259151c04d4e0085e00d2dcb471ebdd1778e72e ]

Call .limit_depth() after data->hctx has been set such that data->hctx can
be used in .limit_depth() implementations.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Damien Le Moal <dlemoal@kernel.org>
Cc: Zhiguo Niu <zhiguo.niu@unisoc.com>
Fixes: 07757588e507 ("block/mq-deadline: Reserve 25% of scheduler tags for synchronous requests")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Tested-by: Zhiguo Niu <zhiguo.niu@unisoc.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20240509170149.7639-2-bvanassche@acm.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-mq.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 4c91889affa7c..7cc315527a44c 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -447,6 +447,10 @@ static struct request *__blk_mq_alloc_requests(struct blk_mq_alloc_data *data)
 	if (data->cmd_flags & REQ_NOWAIT)
 		data->flags |= BLK_MQ_REQ_NOWAIT;
 
+retry:
+	data->ctx = blk_mq_get_ctx(q);
+	data->hctx = blk_mq_map_queue(q, data->cmd_flags, data->ctx);
+
 	if (q->elevator) {
 		/*
 		 * All requests use scheduler tags when an I/O scheduler is
@@ -468,13 +472,9 @@ static struct request *__blk_mq_alloc_requests(struct blk_mq_alloc_data *data)
 			if (ops->limit_depth)
 				ops->limit_depth(data->cmd_flags, data);
 		}
-	}
-
-retry:
-	data->ctx = blk_mq_get_ctx(q);
-	data->hctx = blk_mq_map_queue(q, data->cmd_flags, data->ctx);
-	if (!(data->rq_flags & RQF_SCHED_TAGS))
+	} else {
 		blk_mq_tag_busy(data->hctx);
+	}
 
 	if (data->flags & BLK_MQ_REQ_RESERVED)
 		data->rq_flags |= RQF_RESV;
-- 
2.43.0



