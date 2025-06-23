Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F07DD222576;
	Mon, 23 Jun 2025 21:55:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715744; cv=none; b=qoKZysWYJn4JPdhzFKNG9MZDLtrlPrvepQ/zWJ2IZSk/pVM3/CYb5C4qj6yrgZKX/nj9tP82pE4yyEVdSNwgU2T6iamweIwpuZT8peS9zBWGJgn7RxyE2cp71W3xPWBKxZ9jn2RGHZxNkTQWloiSmWKBpbPCroz1lK+mGivYyc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715744; c=relaxed/simple;
	bh=xE/Yu6ZOrUSBD/0v+68ff11Pk0iR5a91hEsnv8J3hGw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NXI4ZKQicjdPEZtVrcl3CgmPIPtTvFPSEkWGKgiWL8IrH42weYq7vz7dFkRjNnXWqD5/cA6Ta34SMQWWRqf7JtqoMAi63F+W5RXkdWOw+/1hHkHoQYeSBHoLCMIcWSAqoqruHdrF4rGX7nWrjBCFekv9T0zpBZwotprXYC1JpQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Et6THAsf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Et6THAsf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87905C4CEEA;
	Mon, 23 Jun 2025 21:55:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715743;
	bh=xE/Yu6ZOrUSBD/0v+68ff11Pk0iR5a91hEsnv8J3hGw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Et6THAsfZH38dAzqd/e8DGhVfXVkX6AxkyjbHObflAHry8AegcpJapt2EsYCFPF1x
	 /3No6g1flNZ8CLO51FL0z7KWtdfNU0m+F/7imto/KdYsmNZFZi47me6TS0qLjJGGg9
	 DMV/WtMIFd/KGtt+VlHNk01FN/ELXTwkN2rOJdN4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gerrard Tai <gerrard.tai@starlabs.sg>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 259/508] net_sched: red: fix a race in __red_change()
Date: Mon, 23 Jun 2025 15:05:04 +0200
Message-ID: <20250623130651.622415620@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 16277b6a0238d..3c6b4460cf2c0 100644
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



