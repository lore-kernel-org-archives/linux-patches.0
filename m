Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A40C18FDBD;
	Sat, 30 May 2026 18:47:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780166858; cv=none; b=eQj0qHzmQYEW8DigzwKEtPkcUXgPWhLW8LpMyIqyUYByKBlukVYKaThqFwcK/E379sb9+UcCMTVKT++1N00fOcy9/4OaeEplNURXXsNWkmzlMZ/fz0VWLn2DGPeBqnNt/0pDXbdf+8LfrOwPD/qlNXXW3nigkfnu0aSqBn6BcMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780166858; c=relaxed/simple;
	bh=GdKChLMAMkurcmBwe7r76uky1LPqqDJnhSkBdH90zAM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WDezz97zdFIFfFYro+tvjNFFFjHhefpZh+3N1ZqmaxuJkOtjMbpj7HMCIzTmFBlelh3bkRBjBkY+tIb+cmIe2wFLPlSSIrHFhn3aLUtyjJFk6Z9M+7MCWblaQg51OUhYd4ZDzToR6ZSNJIM6ZDUmUu+ahG2QO9xcyU71pHsh1+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RCqNltSE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RCqNltSE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71AD71F00893;
	Sat, 30 May 2026 18:47:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780166857;
	bh=YTdF4UcOUGXThAp9pwrj+QeB8bm2ODNsqIZkRJLzG2Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RCqNltSEH5m1C45HcHE4mFW5wiuWkv1yQGPF6UVZGToozZp8UPIotnYUp2HrTy9sS
	 VOTVNSr3TVmORfMVfCUd02zOF9ODyHOGHQg0DrYwkt8iqOCLmbYi7GcSpipnILASR5
	 8wt6fqyRMdR0NRcFZ1tzRUeQZqgVA1KAcyr0jFME=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Hemminger <stephen@networkplumber.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 475/589] net/sched: netem: fix queue limit check to include reordered packets
Date: Sat, 30 May 2026 18:05:56 +0200
Message-ID: <20260530160237.129691635@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephen Hemminger <stephen@networkplumber.org>

[ Upstream commit 4185701fcce6b426b6c3630b25330dddd9c47b0d ]

The queue limit check in netem_enqueue() uses q->t_len which only
counts packets in the internal tfifo. Packets placed in sch->q by
the reorder path (__qdisc_enqueue_head) are not counted, allowing
the total queue occupancy to exceed sch->limit under reordering.

Include sch->q.qlen in the limit check.

Fixes: f8d4bc455047 ("net/sched: netem: account for backlog updates from child qdisc")
Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260418032027.900913-3-stephen@networkplumber.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_netem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/sch_netem.c b/net/sched/sch_netem.c
index 1f47711cb1667..64542c9c15340 100644
--- a/net/sched/sch_netem.c
+++ b/net/sched/sch_netem.c
@@ -512,7 +512,7 @@ static int netem_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 			1<<(prandom_u32() % 8);
 	}
 
-	if (unlikely(q->t_len >= sch->limit)) {
+	if (unlikely(sch->q.qlen >= sch->limit)) {
 		/* re-link segs, so that qdisc_drop_all() frees them all */
 		skb->next = segs;
 		qdisc_drop_all(skb, sch, to_free);
-- 
2.53.0



