Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DE031C5D77;
	Wed,  4 Feb 2026 14:46:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770216412; cv=none; b=Y6QLuGKgNdAhyU2MOVmPXS4KT0rqEzLG9InjinhBPao3NASsmjxLPRmVKj9hJ/Axm/1JfhEWJ4xXIQTo9Xj3fjEpYV8wmwxpSI/exltGieOQ+uafufTwlT/Hp1ePrwRs9sSNLAVory5VrLYQsQGqEdzbNAasXk4Vdu1R4wSDci4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770216412; c=relaxed/simple;
	bh=vX45OSevRSoqDKCfB9t0VBzaXclRWsBLSVU3OnUddlY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SKRqmUW08tnH4bxb56QsCVA1pydvlTtAwx1Zc147NYlxIOFMPcD9M+JYbFkDgqp/lXJuxW+H3vYZBOkxjxxeQkKWU7mQLUVt4nw76ya0RDP3jDtfIWJdmG2q5ClTlQ7c9fCLzb7bgxsDTEMc1F2MCWt+7qML+WG4aQsaL16nORU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zp/PGK1a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zp/PGK1a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E73D8C4CEF7;
	Wed,  4 Feb 2026 14:46:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770216412;
	bh=vX45OSevRSoqDKCfB9t0VBzaXclRWsBLSVU3OnUddlY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zp/PGK1aYQ8Qee98Vv9rOP+K4vh/qgiFuzzHQwtAWqhzH0f2jzgDeI8GvKuqBEsPz
	 4k9Gcd28TFI8legMApnOidEQIjrdcqUZXrtaGO7uTEooQhXpKvB5KHZKCwlC8W+KgW
	 hdzFgv3FubSwYcKhWCUN7ccF7FsP8IVEO/6+dSJ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 063/161] net/sched: qfq: Use cl_is_active to determine whether class is active in qfq_rm_from_ag
Date: Wed,  4 Feb 2026 15:38:46 +0100
Message-ID: <20260204143854.026168435@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143851.755002596@linuxfoundation.org>
References: <20260204143851.755002596@linuxfoundation.org>
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
index 9751de2d95e78..1c38447b456a7 100644
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



