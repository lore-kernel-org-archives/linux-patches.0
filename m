Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA8441CACD0;
	Tue, 15 Oct 2024 12:11:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728994265; cv=none; b=S1EbJsoAVi9or2fwviKVwbKkx5rAfxuf7B8gwxsXVrTgriWJPtoz0FVhsqNoIYeDJn82TzVachGd6XhYXY4CXLo28KO3Y74lZc9r558FZTy6/oSJsCQAh/WrSH6f32UfV7wFw78q0CptVZRCZLCaiN0TsQd+NqSNUxnkjWzaiCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728994265; c=relaxed/simple;
	bh=Kh/q3iqD0ndthMj52kE60AxRoRQ7LTQBHkWwlAmS99U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MKgRIukeEkyLFEaDAembjuv9SLmQEesEiojwD7JJRasCCPVWDQWeTfmziQBBaJG0l1CIgM9eb05twqMOBCpnBqSRF04cwN0nKXg3WpPrYfkdS/TpXnIBNBDCMCipeY0RZny84d+mS7nHTlxsaMt9A4upsKpYdlmv3PIaR58qUMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2fcUVmHu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2fcUVmHu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FDD8C4CEC6;
	Tue, 15 Oct 2024 12:11:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728994265;
	bh=Kh/q3iqD0ndthMj52kE60AxRoRQ7LTQBHkWwlAmS99U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2fcUVmHurMzwV3bxsex/8E2hL1aoXMUSD1lM75gJGckkl0YVcG0tzgllsUKqf3bfT
	 4PcC14FI3wSb5b0zODOo7jUXlBLKPFZgCnriRTyy61+ooGBORF+gK3veJoKr4wdRLq
	 MsD8SLdDZLbtIYGkP9aI11HSHrZpg7OTGUQvbUTE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bob Pearson <rpearsonhpe@gmail.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sherry Yang <sherry.yang@oracle.com>
Subject: [PATCH 5.15 623/691] RDMA/rxe: Fix seg fault in rxe_comp_queue_pkt
Date: Tue, 15 Oct 2024 13:29:31 +0200
Message-ID: <20241015112505.058838531@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bob Pearson <rpearsonhpe@gmail.com>

commit 2b23b6097303ed0ba5f4bc036a1c07b6027af5c6 upstream.

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
[Sherry: bp to fix CVE-2024-38544. Fix conflict due to missing commit:
dccb23f6c312 ("RDMA/rxe: Split rxe_run_task() into two subroutines")
which is not necessary to backport]
Signed-off-by: Sherry Yang <sherry.yang@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/sw/rxe/rxe_comp.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/infiniband/sw/rxe/rxe_comp.c
+++ b/drivers/infiniband/sw/rxe/rxe_comp.c
@@ -124,12 +124,12 @@ void rxe_comp_queue_pkt(struct rxe_qp *q
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
 	rxe_run_task(&qp->comp.task, must_sched);
 }
 


