Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9D72470105;
	Tue, 21 Jul 2026 20:01:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664108; cv=none; b=f7meuzwYDkeeG3m3/kDsTFI1lgsSEyUHfaktM9ZZ1PhBZ3N5OWbiuVVUDAxBAbiKpcTBo+3hS5JHnL9e1SeKeQv+pCdP1pShQvL8olkqqrUKOuKVMYkd2NDMNw0AYEux4GQFLuKIGXGC6ikIYQzbnU9QdueGvmPqY0L+EVGux54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664108; c=relaxed/simple;
	bh=mmXjniyTc4M9k6LyAyx6ipeJs+mZGaRi3rhe6KuDmLk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IiXsVC70oo4k2035RKhntHul6sFreCsxJmQeT8ylEnESB9iXFazyA84xocJ2z/v82qgnSgNma65hw1gkJ114R8ViJuyxVJ4keXohyUyOWH6nUYJRibwOZwdm1/J13vfgO+FqxeRQVBGfmmk+PL37gsCUYRixiQ0LMr5yVdSHH3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kAu+ocAH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kAu+ocAH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D3231F000E9;
	Tue, 21 Jul 2026 20:01:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664106;
	bh=4zFLBQbVA5u6CSqtsI2zZH9tmo0G6tiXT6AHA/CAkYw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kAu+ocAHLwV00QBznsSr2l6dDZLRbXwxHUjzgBk0xbu1+NanMA6geuN+A/nJfjUnJ
	 utuyBUv+fIQK5w/B8wNnCVEstN/LcrGg00G2hJfRCEqsJ0pYvSkWTJiv2/O3kfJxIk
	 kx4RC/umiU6x2Vhi6iB2Xlxpi/NvHZK6WhBezT0o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Victor Nogueira <victor@mojatatu.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 1076/1276] net/sched: sch_multiq: Replace direct dequeue call with peek and qdisc_dequeue_peeked
Date: Tue, 21 Jul 2026 17:25:19 +0200
Message-ID: <20260721152510.066278731@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


