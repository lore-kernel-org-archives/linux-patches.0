Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEB58253B60;
	Mon, 23 Jun 2025 13:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685314; cv=none; b=EeDn2vK5AX95JXcE3Z9nvhhIcgVl12HG2UYPihp2V7lhY8LAlqnQfspias5w63PziiPbH4s9uAfs0bIEmtBZEfzZY7iKfVUzbUoRcj1Fr/YpZGR40xMkjzFjm56rrZFFl3PZ8aJMbRaQpsBFNrvysswn2fAf8nr2HdN4+0knk9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685314; c=relaxed/simple;
	bh=ug1azJou2Qd8L8Ahmi8cjcAJzxKhZwmxIrrNPh53nfY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fVRJTb3Aa0sh59hqCW77ivkzyonRGEPgM/qBuSvGwAQYSJHib3nEvgcQHUzVILOnT0L45L8Kle15abKLkIYRVu1+mgd/+WgyV/7+gE/txY/bTMJk4RYOH2PzE1ceOcmbcJUdv7XfOkUpeTlXefhahXkFb0QFP3v9X1EaDaIktOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VUDrA/eZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VUDrA/eZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CF74C4CEF1;
	Mon, 23 Jun 2025 13:28:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685313;
	bh=ug1azJou2Qd8L8Ahmi8cjcAJzxKhZwmxIrrNPh53nfY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VUDrA/eZUvprp0z/+AffM6HTt4271gr5G060Kmw7US1QmZYhmXduKie1rzU6A6FWK
	 yJUfY4CKmDSMldzCgeWNuLRD7z+XevE7y3cPMcXRcQjIooVBUybR+Yd6K/qbkKHCaf
	 h+e355uPw9rEinj6WFQttPdRimVZMhb9vqHXoysU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gerrard Tai <gerrard.tai@starlabs.sg>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 084/222] net_sched: red: fix a race in __red_change()
Date: Mon, 23 Jun 2025 15:06:59 +0200
Message-ID: <20250623130614.624359584@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130611.896514667@linuxfoundation.org>
References: <20250623130611.896514667@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 85a3e0ede38450ea3053b8c45d28cf55208409b8 ]

Gerrard Tai reported a race condition in RED, whenever SFQ perturb timer
fires at the wrong time.

The race is as follows:

CPU 0                                 CPU 1
[1]: lock root
[2]: qdisc_tree_flush_backlog()
[3]: unlock root
 |
 |                                    [5]: lock root
 |                                    [6]: rehash
 |                                    [7]: qdisc_tree_reduce_backlog()
 |
[4]: qdisc_put()

This can be abused to underflow a parent's qlen.

Calling qdisc_purge_queue() instead of qdisc_tree_flush_backlog()
should fix the race, because all packets will be purged from the qdisc
before releasing the lock.

Fixes: 0c8d13ac9607 ("net: sched: red: delay destroying child qdisc on replace")
Reported-by: Gerrard Tai <gerrard.tai@starlabs.sg>
Suggested-by: Gerrard Tai <gerrard.tai@starlabs.sg>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20250611111515.1983366-3-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_red.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/sch_red.c b/net/sched/sch_red.c
index 476853ff69894..64532ee591a96 100644
--- a/net/sched/sch_red.c
+++ b/net/sched/sch_red.c
@@ -235,7 +235,7 @@ static int red_change(struct Qdisc *sch, struct nlattr *opt,
 	q->flags = ctl->flags;
 	q->limit = ctl->limit;
 	if (child) {
-		qdisc_tree_flush_backlog(q->qdisc);
+		qdisc_purge_queue(q->qdisc);
 		old_child = q->qdisc;
 		q->qdisc = child;
 	}
-- 
2.39.5



