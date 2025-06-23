Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 682BF2222C2;
	Mon, 23 Jun 2025 21:56:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715761; cv=none; b=Yv21/phlfKSW8q39ddTctg/UsU9dNxY9OFRhGc2Vd2vOkP7pP+8MDa4XcMbtIUue9IBuPZSm3fVGuGdJh4FfFvc4VJL/09yYTK9wC5vhDPq/8QRuUGXMMfND8ElFOlum3syJZ6BUA0Zp96zlwxFC2wPYss1yZq8aZe5Y7XWPuv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715761; c=relaxed/simple;
	bh=pfi5UjFsOm717DFAR5WjZ26k5A9quYCnbj5WBfp2WBM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rGlDwkZ04RUv5fkeZtDruwCnTGkj7jlqMRbZJ+mCTjUMT4MJPXXcAGdjcedB+rId30lnIWVHp2Ij7gNx7jj2wb0RDOwVHN4jSHRBkd1eNyH9z4EIA1wkHznyt+wijYoDri6jBQcnvUQnC2awLlsedVPxKks0kvcIk3I4ZkzvJYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u6jnRv1v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u6jnRv1v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5DE7C4CEEA;
	Mon, 23 Jun 2025 21:56:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715761;
	bh=pfi5UjFsOm717DFAR5WjZ26k5A9quYCnbj5WBfp2WBM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u6jnRv1vtX4c2yUKLUOoCuPt63cM9ayLrQubwGSEDAt7Ww+oCJQv76b84Q4Gl6O4K
	 fWunAfEe1UEizf7TgWqRI/+q3ie27yCZH9JlJ0NpvO/Vaazb0m3SNHpa5PIscyh1P7
	 S6rYJnAQI3k8ycvAd3DhGXIh5Wqo3FC0rl2yfaeA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gerrard Tai <gerrard.tai@starlabs.sg>,
	Eric Dumazet <edumazet@google.com>,
	Zhengchao Shao <shaozhengchao@huawei.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 260/508] net_sched: tbf: fix a race in tbf_change()
Date: Mon, 23 Jun 2025 15:05:05 +0200
Message-ID: <20250623130651.645147055@linuxfoundation.org>
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
index c4c91b55e98b0..ebf67b8a6ee79 100644
--- a/net/sched/sch_tbf.c
+++ b/net/sched/sch_tbf.c
@@ -451,7 +451,7 @@ static int tbf_change(struct Qdisc *sch, struct nlattr *opt,
 
 	sch_tree_lock(sch);
 	if (child) {
-		qdisc_tree_flush_backlog(q->qdisc);
+		qdisc_purge_queue(q->qdisc);
 		old = q->qdisc;
 		q->qdisc = child;
 	}
-- 
2.39.5



