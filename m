Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 822B91BA87E;
	Tue, 30 Jul 2024 15:59:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355163; cv=none; b=TR6zALQ+PXheP2oiht7vasX8tATvXTmVPZxG6K0lF6o6t3tXwvldx/pUe5aLz6/tHndChTmnPjG4yPkaXretkzEt4V4WWJCGmKVlvNSAJvuYJPp44rs4GYtQbbrcQr3uTOI6k4o7Gh1aZ8jk/jmzDBcThZkdKLdK0w9cKtVdH+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355163; c=relaxed/simple;
	bh=I8hyjo+IapU3UboB16BLYTRq6bfnx6vV3jAaj8v7/co=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z0SJ8yauNbHo9SqI67zuO8uKIkatzieKdjaWlCoZUOejbGbnydjUAp/p9rVuCZrM87t9FyOozMo8/dyh/bN5hmQld7Ft/91kibRjKqqbKzjcoXUpWvMNGcLHrAqqrdQiiFk17ej1p23m0uiXYVrVfJvkqfsL0FmaTvinyTyBCWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oOJNwnBX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oOJNwnBX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E09BFC32782;
	Tue, 30 Jul 2024 15:59:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355163;
	bh=I8hyjo+IapU3UboB16BLYTRq6bfnx6vV3jAaj8v7/co=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oOJNwnBXKTia/zpmrBuxbKUcHTk+uR2wdWzSi3c37tI33L3eHH2x1orAIECn2JmPo
	 5FNz5x69nMcYG6j7smHU5WwK+28E8y1ofAsk1993g+6oJuRrEa6UXUtBbPCesx/ILl
	 PQfGIiVBKHN0QAhx5TMvpqpy0f+ruPUjC/11e2r0=
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
Subject: [PATCH 6.10 025/809] block: Call .limit_depth() after .hctx has been set
Date: Tue, 30 Jul 2024 17:38:21 +0200
Message-ID: <20240730151725.651838201@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index 3b4df8e5ac9e5..7831af29aadaf 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -448,6 +448,10 @@ static struct request *__blk_mq_alloc_requests(struct blk_mq_alloc_data *data)
 	if (data->cmd_flags & REQ_NOWAIT)
 		data->flags |= BLK_MQ_REQ_NOWAIT;
 
+retry:
+	data->ctx = blk_mq_get_ctx(q);
+	data->hctx = blk_mq_map_queue(q, data->cmd_flags, data->ctx);
+
 	if (q->elevator) {
 		/*
 		 * All requests use scheduler tags when an I/O scheduler is
@@ -469,13 +473,9 @@ static struct request *__blk_mq_alloc_requests(struct blk_mq_alloc_data *data)
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



