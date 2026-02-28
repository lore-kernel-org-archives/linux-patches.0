Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E546C35AC06
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:18:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302732; cv=none; b=McdmDTMTrUu/kTFlz+QABSJ/vTrkOhmAwn4IaqhFy46ffAlZrKl7WGhmz/uMLkvJxW1NoeedYZB/YXJhWPWIapZtp1/ASSY+TfXaI1Z5iBTwAmT+WG84AgHRRC3djlFWzxKH2X9WZiUhVYIeDm7gL9btdMYf2d4wP+tl6sVsR+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302732; c=relaxed/simple;
	bh=0a9X/510wy6OCmElR0iA0ZWqE2OW1i0qdc+LSXdpWwo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QNxwIfhEnBomcv1JXUp8voEG9rpm6/bXuR35z3owfc4woMdHELBEYwRuIEEMt43B7RrSuA7v0yP/7lZjsQPpFeaCOGjO26+9N2VI64WBY25soAScyIbX7nta9ipNJte2fkI36ZvsWRitiJYWMzzm98xKRtmtEt3yu2VGu2l+0UY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XIbSAAl0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XIbSAAl0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41714C19425;
	Sat, 28 Feb 2026 18:18:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302731;
	bh=0a9X/510wy6OCmElR0iA0ZWqE2OW1i0qdc+LSXdpWwo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XIbSAAl0eMHpl9Zo/6ofbDTIDF0tNAsCKtF0nT4szEMxkl6aoTwFR28WsQzMopSXA
	 rT3oGQB7bM/6yXKR4CVWKHepbJu/ASfzVFd4ul+sYgUfFDkViVVW7nyAjB1LAJZ2sE
	 IjliFapaH7N+OefbLNLri/pu98zmIVtdrjpntqB5P8U2qWROi36hc/X+ORkmky1PXt
	 wyPSepVg4JZicElNJhbbLqjQ+KHSQjRuO+Z8HB5VAXxaL6zDBntW2yizu2BBjb1LJT
	 X8iiY6oac6I+zA2GqsT2dd2pHhbwGHSeJBOqVyDhliwvK68Idbg9qZaRafSIgafT/m
	 rsqAvczkRtf8A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Jiasheng Jiang <jiashengjiangcool@gmail.com>,
	Zhu Yanjun <yanjun.Zhu@linux.dev>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 094/147] RDMA/rxe: Fix double free in rxe_srq_from_init
Date: Sat, 28 Feb 2026 13:16:42 -0500
Message-ID: <20260228181736.1605592-94-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181736.1605592-1-sashal@kernel.org>
References: <20260228181736.1605592-1-sashal@kernel.org>
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
index 41b0d1e11bafd..9d9baca269499 100644
--- a/drivers/infiniband/sw/rxe/rxe_srq.c
+++ b/drivers/infiniband/sw/rxe/rxe_srq.c
@@ -116,6 +116,9 @@ int rxe_srq_from_init(struct rxe_dev *rxe, struct rxe_srq *srq,
 		}
 	}
 
+	srq->rq.queue = q;
+	init->attr.max_wr = srq->rq.max_wr;
+
 	return 0;
 }
 
-- 
2.51.0

