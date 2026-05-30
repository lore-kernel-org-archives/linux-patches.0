Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCDAC31F98D;
	Sat, 30 May 2026 18:10:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780164648; cv=none; b=RSoZ5OvT38OkxrBVBUVavl7GhTHGtqRZbevl7e424gxdcgs+fSJLh4qOjCLEXHUr+pf3LHhH7qP8ecN6VatOSAIQEKG4qckjWwcLsKVBOzVrpi8+h4Uz34eykRxX7+kjox0hvCMfQZjBe12aqOoiIOI2iyRtK0K7iGBMyDLVsPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780164648; c=relaxed/simple;
	bh=8cPf7ojOLlORYX1OrQyXJGi45XBdDiZJZU0+A7s1SjQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kQPk3KdRjrWuynSYSYxrC3ZTaLkYa4GVS8karlX5YrRypIjyLN+64wwsB+LXLWAqcK/rlqx6CZ8f/ii/U4O3yNXhQLxiWZ4apuKfMgdSb4XRE0asEE/fnAP7XENAXqEf0sdAAsE3QyxYgvj2oBN3JEZdPPYxt2XJQw7MHvG8n9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t6nPkNOb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t6nPkNOb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BAE31F00893;
	Sat, 30 May 2026 18:10:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780164647;
	bh=JV292duZCBd9QNNDHRwKK2uYXzdKNGft9h2SfE7wIKo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t6nPkNObKoaqNtChEnhIZS2+3YuCLQo0IFdWSBCa7ZtlMt3gfc9T1WE/X42sZt43U
	 SMw5r5ige2ZyOt8nJd6GSnMa+e6lheTNYuG/0nWh/CXcua89rx5Sbl17D6odhjg09O
	 0afOeUUqkOdUMLtg+NqnB4BZHxaUOTAYTxOGeHqY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Hemminger <stephen@networkplumber.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 616/776] net/sched: netem: fix queue limit check to include reordered packets
Date: Sat, 30 May 2026 18:05:30 +0200
Message-ID: <20260530160255.916328544@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



