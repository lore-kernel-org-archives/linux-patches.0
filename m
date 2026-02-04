Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A6DB41B37C;
	Wed,  4 Feb 2026 14:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770216950; cv=none; b=ZW9okyBsgzCwyU4GOrp0qsen5RbHu/rVQnCXcocIO/QvzoFI18Z8NNFHgKxT4SZTnHd6JuuCm1J9OG5DldLX61s7mNos9liPhXzinTcvwcA6WTNAFlTbAUzF8s5CYtTHP7E6ZZb3lxSyRKjQiitiCjegMctCmh7O+SsxEziLjps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770216950; c=relaxed/simple;
	bh=7mliYGCPsuqcxLEe5Eu6QUqcxs4/RPJor7zwYhllef4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nfw9eS/Bs3P3Z1g/6VpNu0AwmWIrUwFvg46c3lAYq5ugfopCLL0hfPinfbWYbE/gbZvVXaeEmToLaI3vaSELtyLGswKZooiTqN/n9LYxw0v/QYBaMmrCZ9TQ0+a0elZ7ACqIhG8/5ACucjr086wYHBqnQe+je/fZICqSFaHc618=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AQURrCzZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AQURrCzZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C74FBC4CEF7;
	Wed,  4 Feb 2026 14:55:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770216950;
	bh=7mliYGCPsuqcxLEe5Eu6QUqcxs4/RPJor7zwYhllef4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AQURrCzZY0FxeobrDaEjIyMJO+OXUZrLEg5FPPRTmeQxXZuaMxixFKg2JfC1gD+PG
	 SJkXGxWmCj+o6xEEvy5CKuNR9M8dhayllXtGsVxr+smG96daQUPAbno9/6IlD5bhZA
	 T0PGKC8kZJLNOhvWpJmp1bJ04q78cDGRrALZDxXk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 080/206] net/sched: qfq: Use cl_is_active to determine whether class is active in qfq_rm_from_ag
Date: Wed,  4 Feb 2026 15:38:31 +0100
Message-ID: <20260204143901.092732359@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143858.193781818@linuxfoundation.org>
References: <20260204143858.193781818@linuxfoundation.org>
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

From: Jamal Hadi Salim <jhs@mojatatu.com>

[ Upstream commit d837fbee92453fbb829f950c8e7cf76207d73f33 ]

This is more of a preventive patch to make the code more consistent and
to prevent possible exploits that employ child qlen manipulations on qfq.
use cl_is_active instead of relying on the child qdisc's qlen to determine
class activation.

Fixes: 462dbc9101acd ("pkt_sched: QFQ Plus: fair-queueing service at DRR cost")
Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
Link: https://patch.msgid.link/20260114160243.913069-3-jhs@mojatatu.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_qfq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/sch_qfq.c b/net/sched/sch_qfq.c
index d201bcb5edc42..8e5b30c447b86 100644
--- a/net/sched/sch_qfq.c
+++ b/net/sched/sch_qfq.c
@@ -375,7 +375,7 @@ static void qfq_rm_from_agg(struct qfq_sched *q, struct qfq_class *cl)
 /* Deschedule class and remove it from its parent aggregate. */
 static void qfq_deact_rm_from_agg(struct qfq_sched *q, struct qfq_class *cl)
 {
-	if (cl->qdisc->q.qlen > 0) /* class is active */
+	if (cl_is_active(cl)) /* class is active */
 		qfq_deactivate_class(q, cl);
 
 	qfq_rm_from_agg(q, cl);
-- 
2.51.0



