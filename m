Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4125D1E521E;
	Mon, 23 Jun 2025 21:26:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714016; cv=none; b=aMoBegZoFCeUDysFJ/ndbvjS/hucTtiTTWwZTgq50zCz18A5JOlxOs/y+7KyeI1iJtDigpuVyj9KxijIJ9UsmgO8w6lG8nYe9T1tnEDAn9nxtf7iiun7Obw4FKsJqP78pB5HYDTlY1LWTaQXjnbnouelk6vv/h05QcQomd4J/gs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714016; c=relaxed/simple;
	bh=z1jNiBJsW/+4HhD0ck6BvNJ3m9iqgmhybe6DFPUWqIs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uE2sTZHmjvsxbxsO/x1p5Cqualeh0iAhtajsjhSOpRAx3Qn8wWwEDj+/4b7OxX6WLQWDVOFVYfpxTdMPMsmobo5N0vsjISNJQNfNs5Xtl6Ee2ZEp6nJG/MU0bxXqSvPaGUUzdiUg2ZCU5GDfSPhcj04TpUlVbzgKgjRBO1rUnxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DHmC3d1F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DHmC3d1F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 948CDC4CEEA;
	Mon, 23 Jun 2025 21:26:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714015;
	bh=z1jNiBJsW/+4HhD0ck6BvNJ3m9iqgmhybe6DFPUWqIs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DHmC3d1FVtY3m9tkocxosIGT1emB6o+GXhRmM6MH76BSGsERxNVUG+AXTo4prvSKq
	 4GNHIaG5FrN/OMu3ZaIScKScrUxBp2CWO0jOfBbZW4nnv/gP9F0uuFvdcgYN8kR6dx
	 TKQ2lO/k+prXemJDzESStrObgPFoEsMTVMrUyVIs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gerrard Tai <gerrard.tai@starlabs.sg>,
	Eric Dumazet <edumazet@google.com>,
	Zhengchao Shao <shaozhengchao@huawei.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 160/411] net_sched: tbf: fix a race in tbf_change()
Date: Mon, 23 Jun 2025 15:05:04 +0200
Message-ID: <20250623130637.677911402@linuxfoundation.org>
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

[ Upstream commit 43eb466041216d25dedaef1c383ad7bd89929cbc ]

Gerrard Tai reported a race condition in TBF, whenever SFQ perturb timer
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

Fixes: b05972f01e7d ("net: sched: tbf: don't call qdisc_put() while holding tree lock")
Reported-by: Gerrard Tai <gerrard.tai@starlabs.sg>
Suggested-by: Gerrard Tai <gerrard.tai@starlabs.sg>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Zhengchao Shao <shaozhengchao@huawei.com>
Link: https://patch.msgid.link/20250611111515.1983366-4-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_tbf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/sch_tbf.c b/net/sched/sch_tbf.c
index 5f50fdeaafa8d..411970dc07f74 100644
--- a/net/sched/sch_tbf.c
+++ b/net/sched/sch_tbf.c
@@ -437,7 +437,7 @@ static int tbf_change(struct Qdisc *sch, struct nlattr *opt,
 
 	sch_tree_lock(sch);
 	if (child) {
-		qdisc_tree_flush_backlog(q->qdisc);
+		qdisc_purge_queue(q->qdisc);
 		old = q->qdisc;
 		q->qdisc = child;
 	}
-- 
2.39.5



