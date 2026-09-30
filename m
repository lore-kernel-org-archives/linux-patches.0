Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D4CD5111B2;
	Wed, 30 Sep 2026 15:33:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790782426; cv=none; b=KWqeCyq7jtYw4duBCI/pVK31jUE4ErqgUZRyVdRsJFdEGd0RO7vAkj6CpG3KiBI/hWK2lkVpM0bGY6kQNZCy3oHzUbr+JXZ66S0UmZv97Cnt1ZPU4DAs8rLzbt1hwwEs6BhOk4UXDvSztumQjinbcmOTu1Yx+1HHijragiluiXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790782426; c=relaxed/simple;
	bh=yEa/u6mfUDiTFo5gflcDcosGIxmxz0LChQGUgwv+huI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gNPcLgln63Cu1H+V684qVtpFk11ueLEIhlIbt2oQ8sMlRux5qzDTuvJH6EhlO5IjuYvJmGfe2ExRKirGi0u1tlV3NXoufQoRVmHokV34ZLYY8FNsUSWB+RyjnSotdE5LQF6E4Ph0kLejmlASibBgmaORBLfpAvsCeLbl9JRS0WY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=agP83Q5a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="agP83Q5a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 702201F00898;
	Wed, 30 Sep 2026 15:33:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790782417;
	bh=IOiAN442qYzgeLxtLi+v6DFwHP89q/SS5Ui2lYIzaQc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=agP83Q5aPo7QarKrIy3IZ2Ky4mYCBu4WAZCLF6nEZnAWLFDbTV4eu37CxCwtEbO7k
	 15O4s6rjeNTS0ruWYQSmBnguXXzNJHmgVWy/F+BQtcyOtx7Ewc78m0rEh3hLe2MUXY
	 nhUXkHFr+8vFI4iCJJSUL2HsUGmvKIy5GfkQHNLQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 039/595] net/sched: sch_drr: make cl->quantum lockless
Date: Wed, 30 Sep 2026 17:18:52 +0200
Message-ID: <20260930152348.568523275@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit a4d880b85089e12a5f2e8e2fee386310cec5b99a ]

cl->quantum does not need to be protected by RTNL or qdisc spinlock.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20260519094618.2632073-3-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_drr.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/net/sched/sch_drr.c b/net/sched/sch_drr.c
index 5b78ce01b1e7f..50fbf53493a31 100644
--- a/net/sched/sch_drr.c
+++ b/net/sched/sch_drr.c
@@ -99,10 +99,8 @@ static int drr_change_class(struct Qdisc *sch, u32 classid, u32 parentid,
 			}
 		}
 
-		sch_tree_lock(sch);
 		if (tb[TCA_DRR_QUANTUM])
-			cl->quantum = quantum;
-		sch_tree_unlock(sch);
+			WRITE_ONCE(cl->quantum, quantum);
 
 		return 0;
 	}
@@ -251,7 +249,7 @@ static int drr_dump_class(struct Qdisc *sch, unsigned long arg,
 	nest = nla_nest_start_noflag(skb, TCA_OPTIONS);
 	if (nest == NULL)
 		goto nla_put_failure;
-	if (nla_put_u32(skb, TCA_DRR_QUANTUM, cl->quantum))
+	if (nla_put_u32(skb, TCA_DRR_QUANTUM, READ_ONCE(cl->quantum)))
 		goto nla_put_failure;
 	return nla_nest_end(skb, nest);
 
@@ -370,7 +368,7 @@ static int drr_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 
 	if (!cl_is_active(cl)) {
 		list_add_tail(&cl->alist, &q->active);
-		WRITE_ONCE(cl->deficit, cl->quantum);
+		WRITE_ONCE(cl->deficit, READ_ONCE(cl->quantum));
 	}
 
 	sch->qstats.backlog += len;
@@ -411,7 +409,7 @@ static struct sk_buff *drr_dequeue(struct Qdisc *sch)
 			return skb;
 		}
 
-		WRITE_ONCE(cl->deficit, cl->deficit + cl->quantum);
+		WRITE_ONCE(cl->deficit, cl->deficit + READ_ONCE(cl->quantum));
 		list_move_tail(&cl->alist, &q->active);
 	}
 out:
-- 
2.53.0



