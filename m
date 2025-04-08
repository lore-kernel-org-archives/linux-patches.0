Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9DDE26981A;
	Tue,  8 Apr 2025 11:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113567; cv=none; b=OGsp4SIi/7jwW0Blq0OkQeaGcfVjh/SN2lGFiVLgyLLZrhTtU70h/zzE0sDWSczuT+UyyidqIwE8p87HcdzQCbb7ZO0S8P87gbEONYyDIhJhbdby8C46+k8GQOGCfS83zlLPOymLOcREFc4BLoSfYwu6wibdbQrXqIKuMzEl4wE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113567; c=relaxed/simple;
	bh=l5i9v8mljcnCzoSrUxaLVHZS9j1AIEsgmPak7jOYItQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pV/bGs2wyRJa98iarh4UX+JV3hXQJaisirtThPGhAu/B/DE4OS33/rCgotP5dCiKCh3wTRfx0LC0mKi9jfz2CQQDet1FwsG9tyoAVizFYFMLF1KaTn3read2M9VjA5U9BOpq1FHiZNHJWVYx/dEBWmBvJrTGEI9kqdJvJUdVP5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IOtDjdPs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IOtDjdPs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77E4FC4CEE5;
	Tue,  8 Apr 2025 11:59:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113566;
	bh=l5i9v8mljcnCzoSrUxaLVHZS9j1AIEsgmPak7jOYItQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IOtDjdPsXOKfYfpn+bCvlCj6nW+US3ezphd5KpafhoKq+UsuoCC1G4ILd4mqg9zVD
	 jk3PuR8rJt/cm6B9OSkbgI2KimwPCz3dE+aFQf1PhF1Fb167bodPv4R4yD0ZRRW08C
	 lEJRWSG9mc3oocfd9jyYEW6uPYwFPIycq9hFO4c0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+a3422a19b05ea96bee18@syzkaller.appspotmail.com,
	Nishanth Devarajan <ndev2021@gmail.com>,
	Cong Wang <xiyou.wangcong@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 208/268] net_sched: skbprio: Remove overly strict queue assertions
Date: Tue,  8 Apr 2025 12:50:19 +0200
Message-ID: <20250408104834.184341134@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104828.499967190@linuxfoundation.org>
References: <20250408104828.499967190@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Cong Wang <xiyou.wangcong@gmail.com>

[ Upstream commit ce8fe975fd99b49c29c42e50f2441ba53112b2e8 ]

In the current implementation, skbprio enqueue/dequeue contains an assertion
that fails under certain conditions when SKBPRIO is used as a child qdisc under
TBF with specific parameters. The failure occurs because TBF sometimes peeks at
packets in the child qdisc without actually dequeuing them when tokens are
unavailable.

This peek operation creates a discrepancy between the parent and child qdisc
queue length counters. When TBF later receives a high-priority packet,
SKBPRIO's queue length may show a different value than what's reflected in its
internal priority queue tracking, triggering the assertion.

The fix removes this overly strict assertions in SKBPRIO, they are not
necessary at all.

Reported-by: syzbot+a3422a19b05ea96bee18@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=a3422a19b05ea96bee18
Fixes: aea5f654e6b7 ("net/sched: add skbprio scheduler")
Cc: Nishanth Devarajan <ndev2021@gmail.com>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
Acked-by: Paolo Abeni <pabeni@redhat.com>
Link: https://patch.msgid.link/20250329222536.696204-2-xiyou.wangcong@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_skbprio.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/net/sched/sch_skbprio.c b/net/sched/sch_skbprio.c
index 5df2dacb7b1ab..05aa363a7fee9 100644
--- a/net/sched/sch_skbprio.c
+++ b/net/sched/sch_skbprio.c
@@ -121,8 +121,6 @@ static int skbprio_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 	/* Check to update highest and lowest priorities. */
 	if (skb_queue_empty(lp_qdisc)) {
 		if (q->lowest_prio == q->highest_prio) {
-			/* The incoming packet is the only packet in queue. */
-			BUG_ON(sch->q.qlen != 1);
 			q->lowest_prio = prio;
 			q->highest_prio = prio;
 		} else {
@@ -154,7 +152,6 @@ static struct sk_buff *skbprio_dequeue(struct Qdisc *sch)
 	/* Update highest priority field. */
 	if (skb_queue_empty(hpq)) {
 		if (q->lowest_prio == q->highest_prio) {
-			BUG_ON(sch->q.qlen);
 			q->highest_prio = 0;
 			q->lowest_prio = SKBPRIO_MAX_PRIORITY - 1;
 		} else {
-- 
2.39.5



