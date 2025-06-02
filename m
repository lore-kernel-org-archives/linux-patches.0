Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E521519EEBD;
	Mon,  2 Jun 2025 14:36:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875010; cv=none; b=FWdQWaNMb+4T+QNLz4aZUw4j96nFANQmvEd1JxqGm95KIgnugGUu8kaSqR4z642d1rlVO7ZtkzcunPRNiBmlLt8i3C8QqYffmZfElg+dEc6aiIHkatLFWcf7m3/3I9dQrv+83EWRtNForZEPTRvLYHTWrHAz/CFJL8brHMW0Ioo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875010; c=relaxed/simple;
	bh=ee77+F6RjBX9dTRqgitOIsCYkNr/01SaQpknEb8dvAM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l4RoEEnEcPiLzvVBowO3GHOkRZbmOF/A42ILa8BQ8IsfbKA3tnYSYlamFLgJl83nXuI/gjEhxIxkd2pf8U+n3FTkOLFQHwUuWMNAQXvdZGcUBOVUl5f+s4hg4gEvmFK+yafHiI8viwc0NGmuDHqw4nw2S/umsIcSKra9ilxOG8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KF/AGSEf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KF/AGSEf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A40FC4CEEB;
	Mon,  2 Jun 2025 14:36:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875009;
	bh=ee77+F6RjBX9dTRqgitOIsCYkNr/01SaQpknEb8dvAM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KF/AGSEfWwU62FmCEpJsdyMvFllTO+P+KpcsLnZgT9oGFIprARgwYiF716rvLZZpO
	 3hQONoaVYP+DTfvrwtFFLCw8IHI+mznfxbCpQY36BJv+sCfNzzdDpt8TPX4w+goACW
	 XRfiA6SnqcxtrryiCZ5oHRUpjzJLEwzX1sP0qoHU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mingi Cho <mincho@theori.io>,
	Cong Wang <xiyou.wangcong@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 174/204] sch_hfsc: Fix qlen accounting bug when using peek in hfsc_enqueue()
Date: Mon,  2 Jun 2025 15:48:27 +0200
Message-ID: <20250602134302.487311645@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134255.449974357@linuxfoundation.org>
References: <20250602134255.449974357@linuxfoundation.org>
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

[ Upstream commit 3f981138109f63232a5fb7165938d4c945cc1b9d ]

When enqueuing the first packet to an HFSC class, hfsc_enqueue() calls the
child qdisc's peek() operation before incrementing sch->q.qlen and
sch->qstats.backlog. If the child qdisc uses qdisc_peek_dequeued(), this may
trigger an immediate dequeue and potential packet drop. In such cases,
qdisc_tree_reduce_backlog() is called, but the HFSC qdisc's qlen and backlog
have not yet been updated, leading to inconsistent queue accounting. This
can leave an empty HFSC class in the active list, causing further
consequences like use-after-free.

This patch fixes the bug by moving the increment of sch->q.qlen and
sch->qstats.backlog before the call to the child qdisc's peek() operation.
This ensures that queue length and backlog are always accurate when packet
drops or dequeues are triggered during the peek.

Fixes: 12d0ad3be9c3 ("net/sched/sch_hfsc.c: handle corner cases where head may change invalidating calculated deadline")
Reported-by: Mingi Cho <mincho@theori.io>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250518222038.58538-2-xiyou.wangcong@gmail.com
Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_hfsc.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/sched/sch_hfsc.c b/net/sched/sch_hfsc.c
index 5d73d02b8dce7..66c33d7e243d5 100644
--- a/net/sched/sch_hfsc.c
+++ b/net/sched/sch_hfsc.c
@@ -1573,6 +1573,9 @@ hfsc_enqueue(struct sk_buff *skb, struct Qdisc *sch, struct sk_buff **to_free)
 		return err;
 	}
 
+	sch->qstats.backlog += len;
+	sch->q.qlen++;
+
 	if (first && !cl->cl_nactive) {
 		if (cl->cl_flags & HFSC_RSC)
 			init_ed(cl, len);
@@ -1588,9 +1591,6 @@ hfsc_enqueue(struct sk_buff *skb, struct Qdisc *sch, struct sk_buff **to_free)
 
 	}
 
-	sch->qstats.backlog += len;
-	sch->q.qlen++;
-
 	return NET_XMIT_SUCCESS;
 }
 
-- 
2.39.5



