Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C29D8333434
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:04:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301844; cv=none; b=bPMifLAKdRD30qZRB4XXweUhJXU6RIQxDMD76HtKkcMXwIZhLtyVGnPJGm1zLeagZDyW/KeHaD3CFGp3pb6nuGrPVyOWc0RAmkfxpYir/zlruzfYPLKQ2kCPAyUWaBW17oY9XtwuMh95dpkGwuSKKZ2Th7lFdDmnK9dDE2AQkcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301844; c=relaxed/simple;
	bh=6CeozlbN+YPI1gA9B/K4u6Rm1RgKcEWzPrFCIM5P9Ss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ASGTvakaXMKAMJUm6G/UpWVLCgaUGFyy2hdfaeRA2c/GevrvV+UtghXskmb6DUQdjdXwzaYclFh6cZ+Hp9c6fXClcluFuFSLoKv8UZdqiQidPmWCp+kJjjM3+6sUM90FIfWg4spZfNovDvplUkYMBP2sRPU1ifvtOdcfinMj1R8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dvq5NF+E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dvq5NF+E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 169D8C19423;
	Sat, 28 Feb 2026 18:04:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301844;
	bh=6CeozlbN+YPI1gA9B/K4u6Rm1RgKcEWzPrFCIM5P9Ss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dvq5NF+EwRCg7uEt8V8xuTUuy56YtJf0krmVYt9f1cc/4f6UjYmz/GN5UcCTdGi0y
	 e5KsnvM15mzqKLTkt73FHn+4PmV3D6vQrGTkH8wmZG1iptmka6Oo6v5AlzOLv2JmRy
	 V/g0tnT4v8gWNJuhY82wyVvpFqALK9TQccDvgWnaWUyTn49ZLuxoiGLcv0PYa6uKh3
	 EdMR4wb2Lflh3/Yyy5HShODU8FfvgQ0agceEfSNbQsjdQHkV/zY2kUx1JqM0fFfIih
	 3Wddx0SAkbfG/A7UWRwVwoYMsBwhK8kHBRqbxr2yigsTozzQ7iWw1Hmdk1rCrNIWjX
	 GoDgN1WgQhuzw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Jiasheng Jiang <jiashengjiangcool@gmail.com>,
	Zhu Yanjun <yanjun.Zhu@linux.dev>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 264/385] RDMA/rxe: Fix double free in rxe_srq_from_init
Date: Sat, 28 Feb 2026 12:58:06 -0500
Message-ID: <20260228180011.1568201-264-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Jiasheng Jiang <jiashengjiangcool@gmail.com>

[ Upstream commit 0beefd0e15d962f497aad750b2d5e9c3570b66d1 ]

In rxe_srq_from_init(), the queue pointer 'q' is assigned to
'srq->rq.queue' before copying the SRQ number to user space.
If copy_to_user() fails, the function calls rxe_queue_cleanup()
to free the queue, but leaves the now-invalid pointer in
'srq->rq.queue'.

The caller of rxe_srq_from_init() (rxe_create_srq) eventually
calls rxe_srq_cleanup() upon receiving the error, which triggers
a second rxe_queue_cleanup() on the same memory, leading to a
double free.

The call trace looks like this:
   kmem_cache_free+0x.../0x...
   rxe_queue_cleanup+0x1a/0x30 [rdma_rxe]
   rxe_srq_cleanup+0x42/0x60 [rdma_rxe]
   rxe_elem_release+0x31/0x70 [rdma_rxe]
   rxe_create_srq+0x12b/0x1a0 [rdma_rxe]
   ib_create_srq_user+0x9a/0x150 [ib_core]

Fix this by moving 'srq->rq.queue = q' after copy_to_user.

Fixes: aae0484e15f0 ("IB/rxe: avoid srq memory leak")
Signed-off-by: Jiasheng Jiang <jiashengjiangcool@gmail.com>
Link: https://patch.msgid.link/20260112015412.29458-1-jiashengjiangcool@gmail.com
Reviewed-by: Zhu Yanjun <yanjun.Zhu@linux.dev>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe_srq.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_srq.c b/drivers/infiniband/sw/rxe/rxe_srq.c
index 2a234f26ac104..c9a7cd38953d3 100644
--- a/drivers/infiniband/sw/rxe/rxe_srq.c
+++ b/drivers/infiniband/sw/rxe/rxe_srq.c
@@ -77,9 +77,6 @@ int rxe_srq_from_init(struct rxe_dev *rxe, struct rxe_srq *srq,
 		goto err_free;
 	}
 
-	srq->rq.queue = q;
-	init->attr.max_wr = srq->rq.max_wr;
-
 	if (uresp) {
 		if (copy_to_user(&uresp->srq_num, &srq->srq_num,
 				 sizeof(uresp->srq_num))) {
@@ -88,6 +85,9 @@ int rxe_srq_from_init(struct rxe_dev *rxe, struct rxe_srq *srq,
 		}
 	}
 
+	srq->rq.queue = q;
+	init->attr.max_wr = srq->rq.max_wr;
+
 	return 0;
 
 err_free:
-- 
2.51.0

