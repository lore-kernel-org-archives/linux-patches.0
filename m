Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F9FC369D7E;
	Wed, 20 May 2026 17:50:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299420; cv=none; b=rY0fIGygS2MTf1fDPuNCmCEjor+0VJl5DCjM78Ly66u1T+VQyWhcVj+n3ez40qbrtOyKgNRtfYv2Hnv6Sir4w3yo/2Xn7WMlV7hZcqpvmacuyqM13hVPYjxWLdbAZMIhc2oONnl/GiKhgPwh9LgpeFPatouDsAdj+A1UXck3aAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299420; c=relaxed/simple;
	bh=VEI67o+OQnk2r11q3gRZnI2jo2UqyQWx2/Geg6Uc6Ko=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HdG3r07IoGRTC33w5BXWYPipGhl7pIje2TIdZUEmasU+GQ/7OO2/MtuH2Sa+1ibhgaB6JiDtDqx0uWvwvZo+Jbr5swkJ6kw5pMBTzqvy7cucA2ulhvplnFmxBEQP86ubmkyYe6IeNz9IJquQQ/SG4wdoylIGWybWGO4lt0clHtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n0LjNRD3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n0LjNRD3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7575F1F00896;
	Wed, 20 May 2026 17:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299419;
	bh=BL0z4WUENNGy3y3xm4Ga1s+2l6laeMTmaX67VMAeOds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n0LjNRD3elfaPhKKRh7JPuJiS2sPhBFarA+FXQZbtCEsyvnP7OG/Nr0zr1PSDvImz
	 mvR9rPuXPH9tJPj961cTxScBQ0RImk4b/e0E836kLWSa+b+AgOmELTsrPYaPMqPA8B
	 7fmFSzZAmJqAYyOf6cx0++XaWjScxHeplAismV+0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Hemminger <stephen@networkplumber.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 766/957] net/sched: netem: fix queue limit check to include reordered packets
Date: Wed, 20 May 2026 18:20:49 +0200
Message-ID: <20260520162151.175648313@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 4eb6ed60ee9b6..da8dcc9b61cc7 100644
--- a/net/sched/sch_netem.c
+++ b/net/sched/sch_netem.c
@@ -523,7 +523,7 @@ static int netem_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 				1 << get_random_u32_below(8);
 	}
 
-	if (unlikely(q->t_len >= sch->limit)) {
+	if (unlikely(sch->q.qlen >= sch->limit)) {
 		/* re-link segs, so that qdisc_drop_all() frees them all */
 		skb->next = segs;
 		qdisc_drop_all(skb, sch, to_free);
-- 
2.53.0



