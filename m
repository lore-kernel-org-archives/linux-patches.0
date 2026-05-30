Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E6C933FE15;
	Sat, 30 May 2026 17:24:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161853; cv=none; b=ZENR6K7sGo8CRRv0Nv7FWTCs2HQ7Ns/wbIUMhTAiUPYmKko93+r/MRANhTo2oBsHISvDHPc6g3VWBEA0nZfHRWtEuW1o+6ZHE6Y6uDovIfzprGrkMJheJ2Md9E9rDjSHWkgH1jT9aKFHZJAf+uq5CSH+6k2uaJTxmuDWpiwXUBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161853; c=relaxed/simple;
	bh=UPUJKRqvebg2LKpSaOruKe5gGCuuSAUnvpnBUxSnaG0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GLrHfNB3WGGt1XQRQw5oHrbYsMdvDFNSkSUwwghYNrBAloRVbFY4khYmn8rq9OhR0DYvlK9ZL9jVahjuYW2zxi3dLG7nvx5nIHQRA6Ltfrr4MjQra6Px+mvjRd2XmFaf9lkvlKh3LcjCXRZOdIGtvxyBNLuqOn23gx6qKXJkJIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=clhMiWJp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="clhMiWJp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 982BD1F00893;
	Sat, 30 May 2026 17:24:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161852;
	bh=GHIni+4cQ3c5BEBqJ19o9kvnOY//h0ALa5WZgbZ/bZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=clhMiWJp9hL1hP+i5vw1yBEozxm6xKwHH542HCEr1jcUwPSifCJVWObEXLDlttT2f
	 NFZ2RzXeFDRnwp5P2kvc+iUEhUJAQ2Gj61WahbHz2+JpMgtCt/q5HiIIduhyA95wnY
	 mD8bufv5k9fgge9ufYfFaLbRLY0lN6fx+MnvE/r8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Hemminger <stephen@networkplumber.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 747/969] net/sched: netem: fix queue limit check to include reordered packets
Date: Sat, 30 May 2026 18:04:31 +0200
Message-ID: <20260530160321.188458183@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index ab7074c357210..288df378321d9 100644
--- a/net/sched/sch_netem.c
+++ b/net/sched/sch_netem.c
@@ -512,7 +512,7 @@ static int netem_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 			1<<prandom_u32_max(8);
 	}
 
-	if (unlikely(q->t_len >= sch->limit)) {
+	if (unlikely(sch->q.qlen >= sch->limit)) {
 		/* re-link segs, so that qdisc_drop_all() frees them all */
 		skb->next = segs;
 		qdisc_drop_all(skb, sch, to_free);
-- 
2.53.0



