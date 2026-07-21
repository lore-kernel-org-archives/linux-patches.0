Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A69645DF57;
	Tue, 21 Jul 2026 22:23:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672630; cv=none; b=YfpyLg+y5cFzoL9Ps5++VwG80JDdbUrOOOToyIg/i90bioNX6ryN6jcKSgSXu3+6MZJIw/LM5Ey9siny0f0TCUJFSrqRENf+8NkA7pq/bUOKkPKIts8pIzrzwIfFEv037K3fRMXLCqqoy2hUFKhqDHViT8NjB/H4jhvwZjI8Iv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672630; c=relaxed/simple;
	bh=Qk6GjnNM7yqCrpdBe/OlLmGiz2hsq5olhpO924hVQvQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W5tRb6BiQ8fyZU4xyisDasml7Vxz1BDhuvKa3ftoIuGkgDNIIJ1G4nbEG+2DQ98b+sSSyonG6a5NQGo4tFHExZYF7UepW5QGoN1MAZ3cJmhBdgLYAMjU9BPdBlPO5Rm0Uil1Z8A6a8Afx34Rmih81FXYH/f5keGbYM4xpey87Zo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WTzoBIv/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WTzoBIv/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8E151F000E9;
	Tue, 21 Jul 2026 22:23:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672629;
	bh=I3Gyc5FZXFv6espyNcLMyyJ5dDGv3gyNUsg4FSSO52U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WTzoBIv/ds5oSPbiWgpW3EBZIMvcSi4vFaIc1Gg7SRJ9QhKlC9mO2a/mHM/QX/aJU
	 mC7LSZCn5agj1UNsSW2kFsF8tW+DdNwXRjEEE2QQSwucWYBBBFM5Ft0RFEqfltQvkZ
	 Xim8e6L2eMfEgYLne2Xf18Yb4WqdK+wyPgD8wGmc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Victor Nogueira <victor@mojatatu.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 697/843] net/sched: sch_multiq: Replace direct dequeue call with peek and qdisc_dequeue_peeked
Date: Tue, 21 Jul 2026 17:25:32 +0200
Message-ID: <20260721152421.731649971@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Bryam Vargas <hexlabsecurity@proton.me>

commit 54f6b0c843e228d499eb4b6bbb89df68cad9ad5d upstream.

multiq_dequeue() takes a packet from a band's child with a direct
->dequeue() call after multiq_peek() peeked it. When the child is
non-work-conserving the peek stashes the skb in the child's gso_skb, so
the direct dequeue returns a different skb and orphans the stash,
desyncing the child's qlen/backlog. With a qfq child reached through a
peeking parent (e.g. tbf) this re-enters the child on an emptied list and
dereferences NULL, panicking the kernel from softirq on ordinary egress.

Take the packet through qdisc_dequeue_peeked(), as sch_prio already does
and as sch_red and sch_sfb were just fixed to do. The helper is a no-op
when the child has no stash, so a work-conserving child is unaffected.

Fixes: 77be155cba4e ("pkt_sched: Add peek emulation for non-work-conserving qdiscs.")
Cc: stable@vger.kernel.org
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
Reviewed-by: Victor Nogueira <victor@mojatatu.com>
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Link: https://patch.msgid.link/20260625-b4-disp-31bcb279-v1-2-85c40b83c529@proton.me
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/sch_multiq.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/sched/sch_multiq.c
+++ b/net/sched/sch_multiq.c
@@ -103,7 +103,7 @@ static struct sk_buff *multiq_dequeue(st
 		if (!netif_xmit_stopped(
 		    netdev_get_tx_queue(qdisc_dev(sch), q->curband))) {
 			qdisc = q->queues[q->curband];
-			skb = qdisc->dequeue(qdisc);
+			skb = qdisc_dequeue_peeked(qdisc);
 			if (skb) {
 				qdisc_bstats_update(sch, skb);
 				sch->q.qlen--;


