Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 469D8207E14;
	Tue,  8 Apr 2025 12:08:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114116; cv=none; b=qEgu3j54bwtJGMzT7w8COsK1xv1SEJxtvNrzqqG7P+jCMRhL28PxMh2nVl6zbd6dNMz+VEqGzl7OTYjPspGAtq1Rw87OmfZ1JfFTcyt1FUrUzEVElhPN8zCS1T9Sp1lmjqgEJqNwsikvVszy+LYc+2YQwLQE3CbeLFHrJuONz/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114116; c=relaxed/simple;
	bh=0y4Xn4xlp+wIvlu6iEMd0lAiR3K11U8rBlDxCBkpAAo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GyldXRRf97lM5g2KxjHo6TEZ7yJ1UHUj8CJqXwN6EnIiVvpEo5T/Mn7Y9C+B5NhcOhGEaUSjFvovtFMhFBqTibudZmdhl7w0o33Zjfz23EW/NgPp6h5pOIvHR2nJfSjk9Yf9iy7KvH3etNiSrGBGZLkq6cAYDpO8J40yMIGDAXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DRhBHkLA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DRhBHkLA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A27AAC4CEE7;
	Tue,  8 Apr 2025 12:08:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114116;
	bh=0y4Xn4xlp+wIvlu6iEMd0lAiR3K11U8rBlDxCBkpAAo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DRhBHkLA9iyrBs1KGGAJL5UYp5TybbhGN+rx0n8gTfVkbULUCcUXGkizNtgH2NyLs
	 3KpNyDQuv+pQsgWe+pKdiy8W5p/g8zF0uIRUG0AvvFK4RYAVWVGNvA98JD5zFMlwl6
	 y3Jts+JRVVxts7nIfdAe72OnGQkKxwXmBANJniqE=
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
Subject: [PATCH 5.4 141/154] net_sched: skbprio: Remove overly strict queue assertions
Date: Tue,  8 Apr 2025 12:51:22 +0200
Message-ID: <20250408104819.834175289@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104815.295196624@linuxfoundation.org>
References: <20250408104815.295196624@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 7a5e4c4547156..7dca66026ca4d 100644
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



