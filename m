Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6675B223DDF;
	Mon, 23 Jun 2025 21:26:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713979; cv=none; b=u7yAy66ObrYUKbyAq05vTiNb+LcCjGf3Yg1TZiL9VgWpo5D+loviv+a9qsg1K98ofTcF9zL2qAKBGPqxl7F5YQ+GjL3bknSBCI/CYvMfc+LIwAZ7UhQ8kVKnaSSY4uQwlbPrt0iK7Bp/Xf220lljGCItnVKPxfHCV4GB7zm1Fyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713979; c=relaxed/simple;
	bh=1VfBy5Ld9bBSPHmlOUlDYAB8oL0JrvzmiUg89TUoryA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G2ThxHMc+fFQT7Cx8v8KihR9GtlhkSy0nb1ivsjtUgeUsZlGnunDTD+y2pxN8qcD4CX79ucRn0IRNeDsdXf0ROaeLb5pjtp//HkTURe9g+2rTQ2KFQkKR1RHQOA8reKymh1B01ex8lApMO2JAZUm9bcLvVuCE2IUEqaeI6WmNoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NplnlTDh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NplnlTDh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2108C4CEEA;
	Mon, 23 Jun 2025 21:26:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713979;
	bh=1VfBy5Ld9bBSPHmlOUlDYAB8oL0JrvzmiUg89TUoryA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NplnlTDh04uGfC0FYfRPosqFQHtZEbNEM7kopkUnLpGmWBjUoeXLDYXFcke0oww+t
	 eMd84jWFsy4CrfCnWgh4F49OiZhM1fGLhyD5hpRCv9EdHms23ysBZnHmJtuzmo8CR4
	 esxl8JMaCSbbA56bakoRD3RkxSsP8RWV2qozfbEo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gerrard Tai <gerrard.tai@starlabs.sg>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 158/411] net_sched: prio: fix a race in prio_tune()
Date: Mon, 23 Jun 2025 15:05:02 +0200
Message-ID: <20250623130637.624472552@linuxfoundation.org>
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

[ Upstream commit d35acc1be3480505b5931f17e4ea9b7617fea4d3 ]

Gerrard Tai reported a race condition in PRIO, whenever SFQ perturb timer
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

Fixes: 7b8e0b6e6599 ("net: sched: prio: delay destroying child qdiscs on change")
Reported-by: Gerrard Tai <gerrard.tai@starlabs.sg>
Suggested-by: Gerrard Tai <gerrard.tai@starlabs.sg>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20250611111515.1983366-2-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_prio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/sch_prio.c b/net/sched/sch_prio.c
index 2e0b1e7f54668..b3defe09d9f7b 100644
--- a/net/sched/sch_prio.c
+++ b/net/sched/sch_prio.c
@@ -211,7 +211,7 @@ static int prio_tune(struct Qdisc *sch, struct nlattr *opt,
 	memcpy(q->prio2band, qopt->priomap, TC_PRIO_MAX+1);
 
 	for (i = q->bands; i < oldbands; i++)
-		qdisc_tree_flush_backlog(q->queues[i]);
+		qdisc_purge_queue(q->queues[i]);
 
 	for (i = oldbands; i < q->bands; i++) {
 		q->queues[i] = queues[i];
-- 
2.39.5



