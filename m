Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A69E368D40;
	Tue, 21 Jul 2026 19:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662154; cv=none; b=FEW44XIFzPovfuSpSlfI6aLKHrGZ6afxuMgY/yJixKDNX3EQqvFRrbSmu2G8ee4F0UKfmfF9gwUn0FniValZaBy4GIDsrRidYloBhVLvHHC+o+9aLtST941GGqQ6uZH5uTdjnzvxKWWFC8Lm/wk3b508cJo87nl7GQMI21YDHSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662154; c=relaxed/simple;
	bh=hGbu9V0Yv3r5S+hhUDoFS/f3WzsJ4pf0ylPgsqWVas8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PhnFJ2xhJumA5/xqG82IlqNNoYR213wmvG2wpWD7aKQS9sGB+zuTJcVGP/ykTxjbtRbC2Hax72dyTDgCHfHfGDm86JoENtE2RkRnVwoEzzcNZABwM0WMf/6kQRkkl24xVVjjmon55iY3JZuAzhEPSCfP1oayL2/vhqf0ZeCNN1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WXViwe67; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WXViwe67"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFA0D1F000E9;
	Tue, 21 Jul 2026 19:29:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662153;
	bh=H4p5qpQFUlVfMB9tQRsAABNRzxSbG/014zV8eBMaslI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WXViwe67THb6O/LLNgGj1hr8TkX49WRTxAcwxKiINXqJ73tXMarLOPx2r9Bt7O9y6
	 v6en5xK4A0MbvjnNZ2k1nY3qjUwyi+QkTPqR/EHYOFuqIEvGaBqH9iSnESsFSdeM3C
	 wepvqINlIEDIZvML/HS5feHSC5GN4t26wZtEdq1w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anirudh Gupta <anirudhrudr@gmail.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Victor Nogueira <victor@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0338/1276] net/sched: sch_hfsc: Dont make class passive twice
Date: Tue, 21 Jul 2026 17:13:01 +0200
Message-ID: <20260721152453.666875524@linuxfoundation.org>
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

From: Victor Nogueira <victor@mojatatu.com>

[ Upstream commit 90b662ea25f5e83bb3b8ccec5b93ced810b92fb8 ]

update_vf() is called from two places for the same class during a single
dequeue when the class's child qdisc (e.g. codel/fq_codel) drops its last
packets while dequeuing:

1. The child calls qdisc_tree_reduce_backlog(), which, now that the child
   is empty, invokes hfsc_qlen_notify() -> update_vf(cl, 0, 0) and turns
   the class passive (cl_nactive is decremented up the hierarchy).

2. hfsc_dequeue() then calls update_vf(cl, qdisc_pkt_len(skb), cur_time)
   to charge the dequeued bytes.

On the second call the class is already passive, but its child qdisc is
still empty, so update_vf() arms go_passive again:

      if (cl->qdisc->q.qlen == 0 && cl->cl_flags & HFSC_FSC)
              go_passive = 1;

The leaf is then skipped by the cl_nactive == 0 check inside the loop,
which does not clear go_passive, so the stale go_passive propagates to the
parent and decrements its cl_nactive a second time. A parent that still
has other active children is driven to cl_nactive == 0 and removed from
the vttree, even though those siblings are still backlogged. They are
never dequeued again and the qdisc stalls.

Fix this by only arming go_passive when the class is actually active, so an
already-passive class no longer triggers a second passive transition. The
byte accounting (cl->cl_total += len) still runs for every ancestor, so
dequeued bytes continue to be counted exactly once.

Fixes: 51eb3b65544c ("sch_hfsc: make hfsc_qlen_notify() idempotent")
Reported-by: Anirudh Gupta <anirudhrudr@gmail.com>
Closes: https://lore.kernel.org/netdev/CAN2cbVe79oj0O9==m4+4x3v+O+qzRagA=2=wkrp9i9=CqYvyZA@mail.gmail.com/
Tested-by: Anirudh Gupta <anirudhrudr@gmail.com>
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Victor Nogueira <victor@mojatatu.com>
Link: https://patch.msgid.link/20260610132824.3027549-1-victor@mojatatu.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_hfsc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/sch_hfsc.c b/net/sched/sch_hfsc.c
index 9c6e6d2b47f8e3..601f99dd989aeb 100644
--- a/net/sched/sch_hfsc.c
+++ b/net/sched/sch_hfsc.c
@@ -753,7 +753,7 @@ update_vf(struct hfsc_class *cl, unsigned int len, u64 cur_time)
 	u64 f; /* , myf_bound, delta; */
 	int go_passive = 0;
 
-	if (cl->qdisc->q.qlen == 0 && cl->cl_flags & HFSC_FSC)
+	if (cl->qdisc->q.qlen == 0 && cl->cl_flags & HFSC_FSC && cl->cl_nactive)
 		go_passive = 1;
 
 	for (; cl->cl_parent != NULL; cl = cl->cl_parent) {
-- 
2.53.0



