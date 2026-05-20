Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADADA372ECB;
	Wed, 20 May 2026 17:06:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296778; cv=none; b=fsFzinYaBWGOypJ0IfJnCrKmthqr+U4ub2HIPdJfhu613GQ7ycYKDrjB/atm4MrqCAEbfhMpsvVqJdu0Y6AOy0un3TacAKzQenPmqgD2AR21ohhHB1jjoOXhV69PRLB8xMe5izF3xI9LoG+9dJ9PhmZd4FmtrEHj+jNUn0bAGBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296778; c=relaxed/simple;
	bh=s3U3YTCWeWfWveWT7BxH2DUjyEDfWibguVdsg7wPq80=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hngkL+pJi4h27Dvdtuow/BECM3THIxonPgyLRd3Fzxou+DGJOHZtXhRy4b/EwD3S+d1WB1BfieBU5aH52qMMqB3mOCwuy3wGFqbjA6dZavUmJ559qprl6U8BAyc/JPvoJQFW+RJyy6UxS6Atm+UFxLxrjFwuVD8tBm0IrZlqi0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DwZtWW55; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DwZtWW55"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F97E1F000E9;
	Wed, 20 May 2026 17:06:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296777;
	bh=in6J0G7P0L9NoyHAlxrRkavdgZ+lxIiiR4PkUwPez/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DwZtWW55fOIIQ+HoNQKcKfFrO5MVFPiwj5wDG7AWsjHjkaM0jogC/urSzouBgy8hi
	 Kt5J9MTrwJjgqGRHgXwFst/PUutfDiq5vQE3H/ImI7tb8I5zr9yNfXMYRbcsT6lajG
	 S9zL0rrjCoV66sC1iraC1vVjbh+qxgV/0DaMTKZE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Hemminger <stephen@networkplumber.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0929/1146] net/sched: netem: fix queue limit check to include reordered packets
Date: Wed, 20 May 2026 18:19:39 +0200
Message-ID: <20260520162209.260319518@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index 8ee72cac1faf0..d400a730eadd1 100644
--- a/net/sched/sch_netem.c
+++ b/net/sched/sch_netem.c
@@ -524,7 +524,7 @@ static int netem_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 				1 << get_random_u32_below(8);
 	}
 
-	if (unlikely(q->t_len >= sch->limit)) {
+	if (unlikely(sch->q.qlen >= sch->limit)) {
 		/* re-link segs, so that qdisc_drop_all() frees them all */
 		skb->next = segs;
 		qdisc_drop_all(skb, sch, to_free);
-- 
2.53.0



