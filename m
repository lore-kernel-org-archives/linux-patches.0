Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03A942248B5;
	Mon, 23 Jun 2025 21:26:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713999; cv=none; b=B5zUNod92XHVsV+yIbTI8sIBakzPCwxRKEedULhcy2EPnP1ciCyS+cpkHjYHej3aTIY14SHS9r1Hzlp9+0aF6WDZgePIsh/gmxmt3mN6UrdKDnoYnbPk0zJdLPNLdlhi8Pe1Fut8O2pcW+IOj5/Sas2b0BkywH4zeIH4ASgPhMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713999; c=relaxed/simple;
	bh=srEeAfRmOEL0kMaFzOggX8jDMuaYhnAGZmp6T5qQ8cE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FZ1nOm/qv2wWbYv70J+PHxOWOdWQC3pLf0bf/fsYeVQQb8O5qeSf/orRTqETD+v3mJS1evF2LW6wjfkX8L37ZMiyx+QbwU9sQ9NlfZ2MWBIM8MBR+h4GgjwXGzxQYPoSGk+NrE+Y9wtcAkFn0enJPxIIkOL5mF3TbjCsXWHLKdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DQgdNi6H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DQgdNi6H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CBB5C4CEEA;
	Mon, 23 Jun 2025 21:26:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713996;
	bh=srEeAfRmOEL0kMaFzOggX8jDMuaYhnAGZmp6T5qQ8cE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DQgdNi6HSa/0E8uZjjuNz/tzslQ34Oyh6URbzy+0NnD7SjSNGSUG1tBXMeDNAs2wo
	 x1xlqs/bxt0bc2cdsstREz8BMa96NeVOE4/yKo9a2SATA2BP/d6SRm0/B9e4ZanA5H
	 Ek90PMaSWIxg6QGEwY6oiXUaoDuQAo86hIN/AlFY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gerrard Tai <gerrard.tai@starlabs.sg>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 159/411] net_sched: red: fix a race in __red_change()
Date: Mon, 23 Jun 2025 15:05:03 +0200
Message-ID: <20250623130637.650051592@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 935d90874b1b7..1b69b7b90d858 100644
--- a/net/sched/sch_red.c
+++ b/net/sched/sch_red.c
@@ -283,7 +283,7 @@ static int __red_change(struct Qdisc *sch, struct nlattr **tb,
 	q->userbits = userbits;
 	q->limit = ctl->limit;
 	if (child) {
-		qdisc_tree_flush_backlog(q->qdisc);
+		qdisc_purge_queue(q->qdisc);
 		old_child = q->qdisc;
 		q->qdisc = child;
 	}
-- 
2.39.5



