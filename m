Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2C8623EAB7;
	Wed, 28 Jan 2026 15:33:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614432; cv=none; b=UH6S0z8tXM7lB1YSLR5k6swJwpoKEic3jl2YKERZdK/Yowg0wipondDDWld/gURlfAGY+9z1pcKKpyX/tYi2aXvO7eOX3crGN5eOwLEwPceXDFmeKbiKwCfyzq8gxNRt4eZehk80M0+46clNMZkYmyAXaii//+aFGJ2Yd2oirRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614432; c=relaxed/simple;
	bh=t+rFb77J6vfgbTMNj1efjF/EDnCtULKro6cuSAoCdUQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MiZ8GJ/xYFHdN6MhUiznK2Jb8yK0jXI0o+CdKK4RD6fhFYVPNNqUWI9yVuNrq6d0G+J0Tt0lWMxOnknDihTRn2M0hSKAB/P2tyqvLvYJNofhTdchiEtN8rsWtZQLHsf6LGnoIuiTBJa73oI2IKcdGJlwpmNQPCZI2wUotkVH+0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fCL3szmt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fCL3szmt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C743C4CEF1;
	Wed, 28 Jan 2026 15:33:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614432;
	bh=t+rFb77J6vfgbTMNj1efjF/EDnCtULKro6cuSAoCdUQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fCL3szmt7Zu5iwS356OrePmVOnhqaj4n4xSZOBomer7NP4NW51iuBAZz5XE8KzHjS
	 CW6tF/I+qel24f3nA7KyWukn1vLiHhvIzSh9tPLsQoQZSPt3FPvDdk1vklexR46jTZ
	 ZiCu/j7ksXD2IuHWui1Ia+/i708If+VPnfOhKLCc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 133/254] net/sched: qfq: Use cl_is_active to determine whether class is active in qfq_rm_from_ag
Date: Wed, 28 Jan 2026 16:21:49 +0100
Message-ID: <20260128145349.606496043@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.698118637@linuxfoundation.org>
References: <20260128145344.698118637@linuxfoundation.org>
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
index 7c6b5428b8ed4..a17f7c31378e6 100644
--- a/net/sched/sch_qfq.c
+++ b/net/sched/sch_qfq.c
@@ -373,7 +373,7 @@ static void qfq_rm_from_agg(struct qfq_sched *q, struct qfq_class *cl)
 /* Deschedule class and remove it from its parent aggregate. */
 static void qfq_deact_rm_from_agg(struct qfq_sched *q, struct qfq_class *cl)
 {
-	if (cl->qdisc->q.qlen > 0) /* class is active */
+	if (cl_is_active(cl)) /* class is active */
 		qfq_deactivate_class(q, cl);
 
 	qfq_rm_from_agg(q, cl);
-- 
2.51.0



