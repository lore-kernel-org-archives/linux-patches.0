Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99E9D268690;
	Tue,  8 Apr 2025 11:03:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110185; cv=none; b=q8cY833qFz5ljqoj6SQmRJb9a/abvFACCvEYFQZ5jHOJV9JMTNd2/ZE2dQloG2o9RGsrylYRO61186lr2aHSjSP/4IpFlR50bTN0KGMh4IvPi5mKdLzvHlBn715aeGN9Buag6w6laWr+7XiNssZlWwrxehfVSbCKWiUh6/okV7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110185; c=relaxed/simple;
	bh=hZ2FCuzFt0tVUl27ltdsyBffhz46PNva3s2xrSZPqIA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a9EHYdJ41Kq3p6TMku0CcTW+jaH/W3RDD0kFqzkjymYaWcA020vC+kQsHRl8KQy4R4KZeGobvnb5eNt5u9ofv9t1L6yCM8jHR5iAtpvu35u80npnLUn6DwzMn7+ExYX1Yt69DsFsixykWnFWLm131SwtIhVoBDz5NP/nt9daF/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pMLZNPbb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pMLZNPbb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 032FFC4CEE5;
	Tue,  8 Apr 2025 11:03:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110185;
	bh=hZ2FCuzFt0tVUl27ltdsyBffhz46PNva3s2xrSZPqIA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pMLZNPbbsnZHd5M+b0qswrDeXkkbvJKzCKH1JXLgEAsMRXjubeaYfvXgHXk9D2Rvy
	 +T6vTMM/0icWR5XnEURgK2Lk26gy/mhdtz+tX8J3bCsztXHxzvBsKC7n5o6zcnDXPr
	 HF5FWWwTxc1OFua3MlN5Fgk8tOxFBKG6dQX/Xupk=
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
Subject: [PATCH 5.10 198/227] net_sched: skbprio: Remove overly strict queue assertions
Date: Tue,  8 Apr 2025 12:49:36 +0200
Message-ID: <20250408104826.240028684@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.353768086@linuxfoundation.org>
References: <20250408104820.353768086@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index df72fb83d9c7d..c9e422e466159 100644
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



