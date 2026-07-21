Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 526FB415F14;
	Tue, 21 Jul 2026 19:19:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661575; cv=none; b=m4y6blXImWb5v+p9jMU3GDY/mjwpiOMky/EiiOxofqjmYoXt/W6EzvmwkMb9t+xo13Tag7KUGvYzN3rfCYqCBOOF9L/KvOKOujDIZwyEGSQ4HmxNwnDoABP9n00MdQbWlyYbKVZxowF6cAv6a0bcNg4FDjzaFNUNFzeBzcqHml0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661575; c=relaxed/simple;
	bh=SESkLwbqISPjs9TygAarJmDIybqfMwQWly/YX6LI0Zk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q+O8YDJ2SOQ1dNW9EcqWf5rEP62yAUtaJxNKxivK0eEpi3OR5o7cq9vOkD/orntb9eMvFmCS8HD1WaMH/ma23wi4ZJTGL6ChDfqAOf3k1L1VaMdFWTXTf2ftMXGwnYPfXWgdMwQelWlmgMAARnn9063XxX3vbnp6Gf5vKF4jJp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j9X7xE2k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j9X7xE2k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B70931F000E9;
	Tue, 21 Jul 2026 19:19:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661574;
	bh=9afEwTXaU5HS7umYh+cagQ2GK1GVguyGjdVVnXpAP4E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j9X7xE2k8F6RfywVePZrY97Zp4ZDM9ljxVUT4UJb1lPZpbpxaQIwHI5C5P1k1G7OQ
	 JfjBREKj4t3RbqzMGIB59r5u9uOrDDyZezB5SqL+IJULDWpEuGQBrpm4MkR0NgH+MH
	 oc5W8zx5boXwWKe22lBCuBZGQo1ny9/wCubeCBUs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0118/1276] net/sched: sch_htb: do not change sch->flags in htb_dump()
Date: Tue, 21 Jul 2026 17:09:21 +0200
Message-ID: <20260721152448.742403342@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 9b949fa69129e4b694ed11ee3be6d6edd4a9b8f4 ]

htb_dump() runs without holding qdisc spinlock.

It is illegal to touch sch->flags with non locked RMW,
as concurrent readers might see intermediate wrong values.

Set TCQ_F_OFFLOADED in control path (htb_init()) instead.

Fixes: d03b195b5aa0 ("sch_htb: Hierarchical QoS hardware offload")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20260514095935.3926276-2-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_htb.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/net/sched/sch_htb.c b/net/sched/sch_htb.c
index 2c13de8bf16f40..f43f6ae8469235 100644
--- a/net/sched/sch_htb.c
+++ b/net/sched/sch_htb.c
@@ -1148,6 +1148,7 @@ static int htb_init(struct Qdisc *sch, struct nlattr *opt,
 	 * parts (especially calling ndo_setup_tc) on errors.
 	 */
 	q->offload = true;
+	sch->flags |= TCQ_F_OFFLOADED;
 
 	return 0;
 }
@@ -1208,11 +1209,6 @@ static int htb_dump(struct Qdisc *sch, struct sk_buff *skb)
 	struct nlattr *nest;
 	struct tc_htb_glob gopt;
 
-	if (q->offload)
-		sch->flags |= TCQ_F_OFFLOADED;
-	else
-		sch->flags &= ~TCQ_F_OFFLOADED;
-
 	sch->qstats.overlimits = q->overlimits;
 	/* Its safe to not acquire qdisc lock. As we hold RTNL,
 	 * no change can happen on the qdisc parameters.
-- 
2.53.0



