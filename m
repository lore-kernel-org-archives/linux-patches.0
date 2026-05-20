Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A25C3FE646;
	Wed, 20 May 2026 18:45:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302746; cv=none; b=kVTBjHaU1i85KVDul44JOrzr/+LVNss8C1pw/y/UTYaf5PsHVT2cQSJ2Z1d1GO23UkEI7uDCmowhsJAhRfbTzMtznTm3CqmBqAU6SgY5Dba/qnM95XkghTW8neYUsfiO6kGZRhd2CYUA+Jg6GSITgb121ApKlVnSD/yoNJ2l4Fg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302746; c=relaxed/simple;
	bh=H5NtBQhzRDfJPfRkIAaktzHA5rjOhpjUVpnnFeuwvcU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hM0N0c4RPx5hwu7zcyyXkDPZYtDc4+A+I5VMSoGJWrccoe4gWarSO/fHrXmsj39oRoCWoAtqK0Ol+OL0ec7fw2QAoc2hvYilkj20zEFbokJmfCjVEaYQv8aDSksXJ+QH/GvW1ERpZCp5EijdHPms+1tSyxgWwrP4tW3+rdA7Wzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QGxyfyWN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QGxyfyWN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F23F71F00893;
	Wed, 20 May 2026 18:45:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302743;
	bh=nw9Ak7H3E2S4d2Mxvi5F7+5DHWonVmhwpFtOviWnDp8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QGxyfyWNQLrdyPIkPrk/5mlNLu10tzZ+x7VcfrvQQFPeWvE0iqr/DwpYEDNPxOR5f
	 a/FPm3Mtn6eyIVjQOpphDxKJP0+B6jKvVerCDIK0a46/RKQrtX52O3FXCvoJNvCf3t
	 j2Rku1RICYOObhbUl07TFkjaR8zrdoiTOMoV5BBc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Hemminger <stephen@networkplumber.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 382/508] net/sched: netem: fix queue limit check to include reordered packets
Date: Wed, 20 May 2026 18:23:25 +0200
Message-ID: <20260520162106.898197947@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index a1b2912e2b6c7..b3af6a50b43be 100644
--- a/net/sched/sch_netem.c
+++ b/net/sched/sch_netem.c
@@ -522,7 +522,7 @@ static int netem_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 				1 << get_random_u32_below(8);
 	}
 
-	if (unlikely(q->t_len >= sch->limit)) {
+	if (unlikely(sch->q.qlen >= sch->limit)) {
 		/* re-link segs, so that qdisc_drop_all() frees them all */
 		skb->next = segs;
 		qdisc_drop_all(skb, sch, to_free);
-- 
2.53.0



