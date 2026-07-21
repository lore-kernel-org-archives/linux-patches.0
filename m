Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B388418A58;
	Tue, 21 Jul 2026 22:03:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671424; cv=none; b=EWDPt8w4+JM5yZFv/dMwITnyY7JfyxVnVWZ2e6DaQsqsS9Q9ThdUjL1oeQdwrQKSSz0yHzHB/JdWoEeio/LleyDa9Dqn2LbjtvmdEspqUu/A3xP2tHhn7b53wYYAKAu7jOEdoYc2qCdpHe97enOeAokwiWLeuZ5s5CJjfpD/oOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671424; c=relaxed/simple;
	bh=lDjI0AGAu3kerzcXorK2jAkhan5jLtzHbS/XR98jhq0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i+NB1YFbX3KyJwPRY+42YkZBK5nJsPPomSnvdULyjmaJZTGnwKV9Cy7C/h/c8WvbyzD+aAK5RCMtVuWJ7ZpNuTbtsUVl5ST75s6Jyw4KX6Z5I2EjTixYjbMwzP6WuXXvGMIMKyltB7JngQxfwIC8OmUvJqyhdT4IP7i0EUgaREA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P8vADGFM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P8vADGFM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEE0D1F000E9;
	Tue, 21 Jul 2026 22:03:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671419;
	bh=Ga2i9Mve9wl7oXI6p/BEraACNzWxtLRR8LHw+ChGd/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P8vADGFMimUosgp73V4O+UEokhbb1bzxTAMjQ6imrcTeVp71dRWyrfpD5RMQGHwRV
	 hGwCH3nbK4pOfmor/ynkyhuzEewX6sgt7zM26ZsMzUMwmpDxWXVWfkVxIdfwSR3djE
	 4VPE6lgnpqghCX1BJJD30C4Zi/ThWaVHoF4nNHZw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 239/843] net/sched: sch_htb: do not change sch->flags in htb_dump()
Date: Tue, 21 Jul 2026 17:17:54 +0200
Message-ID: <20260721152411.391951658@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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
index 6c4de685a8e481..c704b73a655462 100644
--- a/net/sched/sch_htb.c
+++ b/net/sched/sch_htb.c
@@ -1152,6 +1152,7 @@ static int htb_init(struct Qdisc *sch, struct nlattr *opt,
 	 * parts (especially calling ndo_setup_tc) on errors.
 	 */
 	q->offload = true;
+	sch->flags |= TCQ_F_OFFLOADED;
 
 	return 0;
 
@@ -1228,11 +1229,6 @@ static int htb_dump(struct Qdisc *sch, struct sk_buff *skb)
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



