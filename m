Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8383119B5A2;
	Thu,  6 Jun 2024 14:16:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683404; cv=none; b=NmgfjuWfnzFxS/4+ahDWSLv7ORg4M2B2ZBfVM0+Z/ov4pZ69j4QyUempjOJJoar8QM8ErjKJrpQV8E4bD/T+CYjhaVgr9p7Fc8G4WPifzc2sIqLyZtZZj0No/m6B17Xh5qdXFAZ35pNSAeWtiSxcyrVuww2rnFjBjTUqc7laOQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683404; c=relaxed/simple;
	bh=LOJbocu3arC/7K6raiMdN4qO81QQn/qYyw9IdAxdH6Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rxjAJOjFlUKPu/XHBLdOQhEdsht6jSOjS5zvDFYT6UBR6Re64JL5MbJfqCKoxr/Q/i41qfOoU3sdNyid7rKmHwmZ1ytA8wBUdODRjER3sO36lVgnJKBZGGbKiegeswheJK8244uSKWYkhlXdiWh5MpX1ugr28GxJEqyR9tsqBBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mCbh+/5M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mCbh+/5M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64DB0C4AF08;
	Thu,  6 Jun 2024 14:16:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683404;
	bh=LOJbocu3arC/7K6raiMdN4qO81QQn/qYyw9IdAxdH6Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mCbh+/5Ms0I9+45UnAYDoCbwGbrvM57BvA8OjZp6KNA7DkiloGynaC5s8SiNbz8Y+
	 syqDrPvomnLq4LeDuR+eNnAFXGxVGh6F3MM7Y2aNUvMmWJm1+F/f4r3ouWc/JRq4Cp
	 db1ky3hWznBdhBtXlJi9bqvLaTTSjwJ3TPsLHwVA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bob Pearson <rpearsonhpe@gmail.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 348/744] RDMA/rxe: Fix seg fault in rxe_comp_queue_pkt
Date: Thu,  6 Jun 2024 16:00:20 +0200
Message-ID: <20240606131743.625843229@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

From: Bob Pearson <rpearsonhpe@gmail.com>

[ Upstream commit 2b23b6097303ed0ba5f4bc036a1c07b6027af5c6 ]

In rxe_comp_queue_pkt() an incoming response packet skb is enqueued to the
resp_pkts queue and then a decision is made whether to run the completer
task inline or schedule it. Finally the skb is dereferenced to bump a 'hw'
performance counter. This is wrong because if the completer task is
already running in a separate thread it may have already processed the skb
and freed it which can cause a seg fault.  This has been observed
infrequently in testing at high scale.

This patch fixes this by changing the order of enqueuing the packet until
after the counter is accessed.

Link: https://lore.kernel.org/r/20240329145513.35381-4-rpearsonhpe@gmail.com
Signed-off-by: Bob Pearson <rpearsonhpe@gmail.com>
Fixes: 0b1e5b99a48b ("IB/rxe: Add port protocol stats")
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe_comp.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_comp.c b/drivers/infiniband/sw/rxe/rxe_comp.c
index d0bdc2d8adc82..acd2172bf092b 100644
--- a/drivers/infiniband/sw/rxe/rxe_comp.c
+++ b/drivers/infiniband/sw/rxe/rxe_comp.c
@@ -131,12 +131,12 @@ void rxe_comp_queue_pkt(struct rxe_qp *qp, struct sk_buff *skb)
 {
 	int must_sched;
 
-	skb_queue_tail(&qp->resp_pkts, skb);
-
-	must_sched = skb_queue_len(&qp->resp_pkts) > 1;
+	must_sched = skb_queue_len(&qp->resp_pkts) > 0;
 	if (must_sched != 0)
 		rxe_counter_inc(SKB_TO_PKT(skb)->rxe, RXE_CNT_COMPLETER_SCHED);
 
+	skb_queue_tail(&qp->resp_pkts, skb);
+
 	if (must_sched)
 		rxe_sched_task(&qp->comp.task);
 	else
-- 
2.43.0



