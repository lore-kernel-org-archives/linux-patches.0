Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18FE839B974
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:16:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302598; cv=none; b=DjkLXV0dgEk96sLxCEG16jLYWKqcDQ44QbRssaipS74HfRZn8RFGod/sSKrqEsl7GNcTCI74Bv2asZAecC3uFY7afb0MXWQpHaouY0RfkL1jBzA/uDez4BGOTdNVaMb1FpotH3VI9m4EHg8IEmutR63k66T3+HHXeQj+IneC+iY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302598; c=relaxed/simple;
	bh=ZmW0j4BX5tUxxtXHE16NZgbq3rDIZoOiWaXjhYELD7c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N3R+5qYCT4ggOuILCg9PyfeO+hhCBCNJdRBIFkFwsTl3uSh6zIpvK/46h9PxmhiB/gXJhq7tPcbdcer8/SYnLumFWhV4zQNx2J65/2r9CVVTBPWEkueZ4IncmowHks+tzZqlxkScVeI40NghhzXHDQGHCfHSqQOE/RZmYiaeNbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VKENv3wZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VKENv3wZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62D58C19423;
	Sat, 28 Feb 2026 18:16:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302598;
	bh=ZmW0j4BX5tUxxtXHE16NZgbq3rDIZoOiWaXjhYELD7c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VKENv3wZZ/e38Kv7/i+GYoWUOmgN/QffKfGw3ChN3I7mQhkAgVd6dzhKx/U+/wCb9
	 KuCyOV9tcwnPcl7Znm5FVOcqP72h6zVhh9Mr506QQyw+GeSrTXidm9YPvLlnMu9hms
	 yhcRTaIXMiLdz6b/Jo7i6Hn3CZ5k246c5nIQm3x06k2DY18T2wPGykaZEOpddTVf9b
	 S62ybRcRTX1XOPQQG5/D3DimesVWrhEaJxkvGYxCFs4xpxwqRX9iQHRN/DGm1ifg5q
	 Hs+t0ti4qV86/23/glmeJEV51HR7IA+H3X5fu1PfoB4Ku5pRJDYXfJalBwP8wJDM3a
	 OVqQe/enhCGnQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Jiasheng Jiang <jiashengjiangcool@gmail.com>,
	Zhu Yanjun <yanjun.Zhu@linux.dev>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 110/164] RDMA/rxe: Fix double free in rxe_srq_from_init
Date: Sat, 28 Feb 2026 13:14:09 -0500
Message-ID: <20260228181505.1600663-110-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181505.1600663-1-sashal@kernel.org>
References: <20260228181505.1600663-1-sashal@kernel.org>
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
 drivers/infiniband/sw/rxe/rxe_srq.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/infiniband/sw/rxe/rxe_srq.c b/drivers/infiniband/sw/rxe/rxe_srq.c
index eb1c4c3b3a786..05ae3d183b21d 100644
--- a/drivers/infiniband/sw/rxe/rxe_srq.c
+++ b/drivers/infiniband/sw/rxe/rxe_srq.c
@@ -118,6 +118,9 @@ int rxe_srq_from_init(struct rxe_dev *rxe, struct rxe_srq *srq,
 		}
 	}
 
+	srq->rq.queue = q;
+	init->attr.max_wr = srq->rq.max_wr;
+
 	return 0;
 }
 
-- 
2.51.0

