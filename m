Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC1B02FA623;
	Tue, 17 Jun 2025 16:55:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750179349; cv=none; b=jU6jHNVK02Lo4nffENF+viPk5gWPSz/GlGLnTY1GVlYZUucraaA0p6CspiEKovmcEDraHGgP67se5xe0xJYA+lcN+XAcMtwg2owNn87jY6Wssk2N6Pn0bwFxzvGyHtHiFlZnLO5VoS/jwuejsl02abuTg474ZaeEquuzC7u8xL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750179349; c=relaxed/simple;
	bh=Pxyrp5g3XDVynipJdjHyYsPzsb4tEpn+YP5DXzLttVE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OWgsybvJOARqq1yvPi3oADoVdwJj41Rx7maAsbAcjDRcv/ecH4fZGrtORlpHWl36GHOx3hSfLx53M1BjKpOoUbAlesB7qikobfLjl4kq6Cb5V1NjRCg1bNgL+uNO3+kWqntx7m9vSIMz+KCU++6hGqiKn0F9yZy+Mdd4gHhD3zM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UTV6Ibd5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UTV6Ibd5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AF89C4CEE3;
	Tue, 17 Jun 2025 16:55:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750179348;
	bh=Pxyrp5g3XDVynipJdjHyYsPzsb4tEpn+YP5DXzLttVE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UTV6Ibd5InNKO2a/dWG9rY3X132IoeWTHLu4RVI6FfTql1qX+XDb5W00fXDR1558o
	 WiyXu7T8j6FAtVErx8iiviD64yddjklDm9f1MwqZ6nMn4F0bW6JxSJ7KzA/PIngyjE
	 EsHcJSVtj/PG4yIr2U6SNjBCf2QE6efyjhWg3nQg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gerrard Tai <gerrard.tai@starlabs.sg>,
	Eric Dumazet <edumazet@google.com>,
	Zhengchao Shao <shaozhengchao@huawei.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 719/780] net_sched: tbf: fix a race in tbf_change()
Date: Tue, 17 Jun 2025 17:27:07 +0200
Message-ID: <20250617152520.775092812@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index dc26b22d53c73..4c977f049670a 100644
--- a/net/sched/sch_tbf.c
+++ b/net/sched/sch_tbf.c
@@ -452,7 +452,7 @@ static int tbf_change(struct Qdisc *sch, struct nlattr *opt,
 
 	sch_tree_lock(sch);
 	if (child) {
-		qdisc_tree_flush_backlog(q->qdisc);
+		qdisc_purge_queue(q->qdisc);
 		old = q->qdisc;
 		q->qdisc = child;
 	}
-- 
2.39.5



