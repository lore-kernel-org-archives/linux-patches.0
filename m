Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20BB21E51FA;
	Mon, 23 Jun 2025 21:27:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714050; cv=none; b=ERMyKUE2QS24Qw210FrX2mZIhwQkyYu0Ym13/syOQ+9Jpiyt+mBHpJ2ejaUeQKmcoLvEHEYmSbkTIz0e8exZdfcdFSZ5sExIJPlVllRUqYaJ6Vw4fh4mG5Jv7pXjmKnpA865zkcZUvlZJcwUp1u6oaC7l1vuOlgj5Et7oDiEftA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714050; c=relaxed/simple;
	bh=NmcXHfJHKz4CH0mvhJdI/D8IBE5cqimV2TvEOeezJMk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X7gbPJ0duHfaZSOJnTzVNRHbgD1XRjga54adKEQL5yVweWdm8Fqi8ISgOt4VdfINLTloijtPQ0bQ1T0G7cHWAQDwEi9VsGPHF2stkY9xIGlK0r2ZyJkyCOjW/fr4O6u28/pC28wQHW22DngEb/D4AAyrVnE1oBj9o2Zu0/FEU+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gL/uUnpV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gL/uUnpV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB9F3C4CEEA;
	Mon, 23 Jun 2025 21:27:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714050;
	bh=NmcXHfJHKz4CH0mvhJdI/D8IBE5cqimV2TvEOeezJMk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gL/uUnpVLniZK+jDyUzqRPG0X4NxjGeCGQFTILFe8kylPRY5uou/dzVtCBabHAv1N
	 7QLaB5IAFn1U0Ps8UKyXmHVLo1SP8Ont0yOlRc8HAM4GVkw2YHTpbxme6+Mys6JGf1
	 CU6//4+qSNkbBM7Gc58RegjCrvOXXaxnQPabC98s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gerrard Tai <gerrard.tai@starlabs.sg>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 162/411] net_sched: ets: fix a race in ets_qdisc_change()
Date: Mon, 23 Jun 2025 15:05:06 +0200
Message-ID: <20250623130637.731511765@linuxfoundation.org>
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

[ Upstream commit d92adacdd8c2960be856e0b82acc5b7c5395fddb ]

Gerrard Tai reported a race condition in ETS, whenever SFQ perturb timer
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
Link: https://patch.msgid.link/20250611111515.1983366-5-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_ets.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/sch_ets.c b/net/sched/sch_ets.c
index a37979ec78f88..b49e1a9775865 100644
--- a/net/sched/sch_ets.c
+++ b/net/sched/sch_ets.c
@@ -675,7 +675,7 @@ static int ets_qdisc_change(struct Qdisc *sch, struct nlattr *opt,
 	for (i = q->nbands; i < oldbands; i++) {
 		if (i >= q->nstrict && q->classes[i].qdisc->q.qlen)
 			list_del_init(&q->classes[i].alist);
-		qdisc_tree_flush_backlog(q->classes[i].qdisc);
+		qdisc_purge_queue(q->classes[i].qdisc);
 	}
 	q->nstrict = nstrict;
 	memcpy(q->prio2band, priomap, sizeof(priomap));
-- 
2.39.5



