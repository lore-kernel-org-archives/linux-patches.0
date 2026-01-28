Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 243EE2EA172;
	Wed, 28 Jan 2026 15:52:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615561; cv=none; b=Ao0D6FZiKOp3ZimeTq4PJ3XpTb7jKMDUT9RgL7iQG9iAx7J0y2nWbjaYxZ2r2sy5PrPbk3gnybo+0FD/nf74ae4NP43/5KiqWlTetrK4/hMASOJNFabzTG3RKernaX2SuBw01OvySEiYfNqyGzm+wngM1KVRVEVV/lBN0X2uC0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615561; c=relaxed/simple;
	bh=yXNuCZSXuFVnJW2Fu3t2JrooBUST4ju9EuHrVyc+YEk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T0hAkesmkJeg+T0nhB+akYRudRZ3dgY+IKXG7UaeGHPn2qx80vXLqjOQOP4FS/TG9K5KBoJz/PfPO5HfEggULn2iBa2X9jDRJ02pKgukvBlRPP98LJw5CoMfM1twzyeSjuD3hqjc6FXtagSyawpUuhWD8b6M8mDCkCsay9xKKdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V94ANwzR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V94ANwzR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64461C4CEF1;
	Wed, 28 Jan 2026 15:52:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615560;
	bh=yXNuCZSXuFVnJW2Fu3t2JrooBUST4ju9EuHrVyc+YEk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V94ANwzR1NNWPG8EHUDmT1zMYmRx0qJ2RilxpiBC6KLhRgmKVIwF7VlWWPbgsYCKp
	 1XJF5GsD6osyxXNV2QPburOZa+HyrV5ZSm5qg9W6pBeHJjB0ngIyoVjAPttwL4JLf8
	 y8wyXI1Ls9SfJKI1Gp0uUpzwFWrWIrqjMLuDLZM8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 046/227] net/sched: qfq: Use cl_is_active to determine whether class is active in qfq_rm_from_ag
Date: Wed, 28 Jan 2026 16:21:31 +0100
Message-ID: <20260128145346.001388169@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.331957407@linuxfoundation.org>
References: <20260128145344.331957407@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 9b16ad431028f..f94c9c9c90424 100644
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



