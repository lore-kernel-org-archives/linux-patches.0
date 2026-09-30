Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 352D15372DE;
	Wed, 30 Sep 2026 17:51:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790706; cv=none; b=NcojUkV4Pp8o5Qxs4XkrEQ3IUSSD3gtoScfuSBQhb70g/VU6vDXcgc/q9WlbcjTlN5dHIQVACBk7tCzEcGdlvEKOeAsk8evsLbSvSsgMTCjLd50k1awz7sqxViqqLcY7uzpGAdBzque9mupI/Dayw115MVy7jfUmnstLINIpNAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790706; c=relaxed/simple;
	bh=ObZms8D8vIA+MABUuyqugwNt+D85YQpsB9F1hpfkBZU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=egim1jpgaDIS3XipS2oc5WAmfGR1cUHK5kuyPMSwCfqGAiSldqtIPjCyfEG4qqW2beLiARObcFukHuEE1qRpm+FRP21yX5I+nACnP/j5pThdz9/IftBAWsfc/+G6OsElueMIYAKDiWE2pnbWj3BlCX4+BJGnSKaJ6J6ZTokC5WM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dJhK66GP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dJhK66GP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E21D1F000FF;
	Wed, 30 Sep 2026 17:51:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790705;
	bh=jOC1NGPSlggdpadHLarFRDCi6mJIFjGgIiYJvgcogjg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dJhK66GPUFoGYujhkorpYKdfVhPsMALLf46LC9rfrCVyF8Qmi2/2yq8CIj+1bR09w
	 txebsV8ufsYvzs/iXG8ttmtVjUierArLXmTPQtS9OmXiy5eLxZaA3Wad6i6UUCH0qk
	 nlTJ+gfG4FW8ZQdxynFjY/FBVGQtwBNI+mkrO+J8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 046/752] net/sched: sch_drr: make cl->quantum lockless
Date: Wed, 30 Sep 2026 17:18:36 +0200
Message-ID: <20260930152359.149653316@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index a2b9802d41c01..01198fe915052 100644
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
@@ -252,7 +250,7 @@ static int drr_dump_class(struct Qdisc *sch, unsigned long arg,
 	nest = nla_nest_start_noflag(skb, TCA_OPTIONS);
 	if (nest == NULL)
 		goto nla_put_failure;
-	if (nla_put_u32(skb, TCA_DRR_QUANTUM, cl->quantum))
+	if (nla_put_u32(skb, TCA_DRR_QUANTUM, READ_ONCE(cl->quantum)))
 		goto nla_put_failure;
 	return nla_nest_end(skb, nest);
 
@@ -371,7 +369,7 @@ static int drr_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 
 	if (!cl_is_active(cl)) {
 		list_add_tail(&cl->alist, &q->active);
-		WRITE_ONCE(cl->deficit, cl->quantum);
+		WRITE_ONCE(cl->deficit, READ_ONCE(cl->quantum));
 	}
 
 	sch->qstats.backlog += len;
@@ -412,7 +410,7 @@ static struct sk_buff *drr_dequeue(struct Qdisc *sch)
 			return skb;
 		}
 
-		WRITE_ONCE(cl->deficit, cl->deficit + cl->quantum);
+		WRITE_ONCE(cl->deficit, cl->deficit + READ_ONCE(cl->quantum));
 		list_move_tail(&cl->alist, &q->active);
 	}
 out:
-- 
2.53.0



