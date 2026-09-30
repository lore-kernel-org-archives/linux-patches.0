Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65FDC3CD8B8;
	Wed, 30 Sep 2026 18:47:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794067; cv=none; b=t8iHOVVw2C/Wthtv2vZ64FQExJ8AYp6xCbyJhybpPKlYqXqKfpQ1i4nbyHez6Mb1LkYqC2hYEXYNgffSHGIb16uKh0UWgzx/b/FgiHpsOKFHagN0vSfuUAUzI0GX9JcqZtmZrKbLBNicAoFVITZlgyqvLmWlsO4uV0pzPa8DQ2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794067; c=relaxed/simple;
	bh=tW13U9CUKUoEw78mrkxgYK13+KM4DA05q3sNcIowp3I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G1ymQtN1OvS4XTi71X9Ne1hdDsWOTmKrDOeJO34fp9RqGfaJz/qvK6CsMH1c3gz7UDXkcn4OENZHK8vUVvu1f3NYSL+hNraXbYlV7ycYkNXlh5mSMlqsIRIscxa1kGr919x6rqTmY/VavI3EEssYF8Dz18yUZ4qaFnphN0Ck9Oc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q/HFqWhO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q/HFqWhO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C23FC1F000FF;
	Wed, 30 Sep 2026 18:47:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794066;
	bh=w5aJTw/4bPi/CIJBn2Ae79n6eWyQBx5lYIQbo2HiN/0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q/HFqWhOKBaoKXgXPKyGXCWYpL3p7iaoL8QhFBsohujYGDDml4IngZmZc7xnpvEvr
	 4iTmtEUXsRLzK+QF4zighxjYX4cWKRCqJnTYsDifb2RZwyVABIOKZ/kArqAmYLM45I
	 ghfowu0eDHNTi/XRAzY9GL5UnWIZ6P7wBCYthnAg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0080/1193] net/sched: sch_drr: make cl->quantum lockless
Date: Wed, 30 Sep 2026 17:12:44 +0200
Message-ID: <20260930152436.031106525@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 9a7d9b14bc882..2d468c50137c6 100644
--- a/net/sched/sch_drr.c
+++ b/net/sched/sch_drr.c
@@ -97,10 +97,8 @@ static int drr_change_class(struct Qdisc *sch, u32 classid, u32 parentid,
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
 
@@ -362,7 +360,7 @@ static int drr_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 
 	if (!cl_is_active(cl)) {
 		list_add_tail(&cl->alist, &q->active);
-		WRITE_ONCE(cl->deficit, cl->quantum);
+		WRITE_ONCE(cl->deficit, READ_ONCE(cl->quantum));
 	}
 
 	sch->qstats.backlog += len;
@@ -403,7 +401,7 @@ static struct sk_buff *drr_dequeue(struct Qdisc *sch)
 			return skb;
 		}
 
-		WRITE_ONCE(cl->deficit, cl->deficit + cl->quantum);
+		WRITE_ONCE(cl->deficit, cl->deficit + READ_ONCE(cl->quantum));
 		list_move_tail(&cl->alist, &q->active);
 	}
 out:
-- 
2.53.0



