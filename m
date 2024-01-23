Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 764E910A32;
	Tue, 23 Jan 2024 02:09:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975795; cv=none; b=eHj2YvZ0aW4tGvpfBdzGv2igVBzirZqwFf9QIVxWD84SKqB1cTpikN4njKYwvlh7ZgM92Oe38Z7Hnjf/iXWCYKk/e3O5BZcnnXC832nI3Q4WoYPGBytkQ1CdyGvRA5hHyshihTFuB+NV72ynf5VWQBuIX6aGk19ltxLDja9LwOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975795; c=relaxed/simple;
	bh=Y8Pfaj5mdW9oLDSrOwVWfPp388kbLOaRYOgSgvqxilw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dyKcZZv2v70L5yORBEzlP/N0BcbNE6H+UHNiXazSW5MMnKuT2alV7yZI4CQLd/TJlktn2t4Ti9ZQWT5rFNqZi6TdSY2V2nYfvhFvbHXzIpPz5AhnYw2Xm3C8CsTTtdWd7WWGR21gUwjOpLlKi/7KgRQs2jnE1Jwdwle8Zjspbvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BH+nqGW7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BH+nqGW7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37D77C433F1;
	Tue, 23 Jan 2024 02:09:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975795;
	bh=Y8Pfaj5mdW9oLDSrOwVWfPp388kbLOaRYOgSgvqxilw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BH+nqGW7UsrW846Fp/TC1uZlVyvwUg7d4n6NvUvui1y6OR5Ao7I2VRKfuOoaUI/BA
	 5cYRFkZ/r7ceRl5PrzoODzi1QzeEgmNRApKf3KnzdBKKfD8QSjyzkS0ByiCAUpWYwm
	 I6loFghjawA2jmgCbWqE6nlfNuf5sdAPvqHYQ0b0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 570/583] io_uring: adjust defer tw counting
Date: Mon, 22 Jan 2024 16:00:21 -0800
Message-ID: <20240122235829.615551913@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit dc12d1799ce710fd90abbe0ced71e7e1ae0894fc ]

The UINT_MAX work item counting bias in io_req_local_work_add() in case
of !IOU_F_TWQ_LAZY_WAKE works in a sense that we will not miss a wake up,
however it's still eerie. In particular, if we add a lazy work item
after a non-lazy one, we'll increment it and get nr_tw==0, and
subsequent adds may try to unnecessarily wake up the task, which is
though not so likely to happen in real workloads.

Half the bias, it's still large enough to be larger than any valid
->cq_wait_nr, which is limited by IORING_MAX_CQ_ENTRIES, but further
have a good enough of space before it overflows.

Fixes: 8751d15426a31 ("io_uring: reduce scheduling due to tw")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/108b971e958deaf7048342930c341ba90f75d806.1705438669.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 1cc4c7b05949..ea772a02c140 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1339,7 +1339,7 @@ static inline void io_req_local_work_add(struct io_kiocb *req, unsigned flags)
 		nr_tw = nr_tw_prev + 1;
 		/* Large enough to fail the nr_wait comparison below */
 		if (!(flags & IOU_F_TWQ_LAZY_WAKE))
-			nr_tw = -1U;
+			nr_tw = INT_MAX;
 
 		req->nr_tw = nr_tw;
 		req->io_task_work.node.next = first;
-- 
2.43.0



