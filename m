Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 982C824EA0
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:47:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A240C433D2;
	Wed,  7 Jun 2023 20:47:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686170869;
	bh=kyrc/XHDSZosk9v1+2FHBi4+fWoqY29VSI4ufrww5FM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mrO2bsPMZJ95Wtqczhohtsexoziqj7IJtFLqwbXNUGO4R7uaqKvLWC0spSwNlc7DV
	 tgbOb4bLcI499svssGPghBegLusJ+Kpvd7Q++0oly4kQEcF+Fmt5RIPx3Xha4H7QtP
	 FJxsVFxKzb47MzSlM7ciN2QKECoox5eEjNzpyKXc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pedro Tammela <pctammela@mojatatu.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Vlad Buslov <vladbu@nvidia.com>,
	Peilin Ye <peilin.ye@bytedance.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 022/120] net/sched: sch_clsact: Only create under TC_H_CLSACT
Date: Wed,  7 Jun 2023 22:15:38 +0200
Message-ID: <20230607200901.615160767@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200900.915613242@linuxfoundation.org>
References: <20230607200900.915613242@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Peilin Ye <peilin.ye@bytedance.com>

[ Upstream commit 5eeebfe6c493192b10d516abfd72742900f2a162 ]

clsact Qdiscs are only supposed to be created under TC_H_CLSACT (which
equals TC_H_INGRESS).  Return -EOPNOTSUPP if 'parent' is not
TC_H_CLSACT.

Fixes: 1f211a1b929c ("net, sched: add clsact qdisc")
Tested-by: Pedro Tammela <pctammela@mojatatu.com>
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
Reviewed-by: Vlad Buslov <vladbu@nvidia.com>
Signed-off-by: Peilin Ye <peilin.ye@bytedance.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_ingress.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/sched/sch_ingress.c b/net/sched/sch_ingress.c
index f9ef6deb27709..35963929e1178 100644
--- a/net/sched/sch_ingress.c
+++ b/net/sched/sch_ingress.c
@@ -225,6 +225,9 @@ static int clsact_init(struct Qdisc *sch, struct nlattr *opt,
 	struct net_device *dev = qdisc_dev(sch);
 	int err;
 
+	if (sch->parent != TC_H_CLSACT)
+		return -EOPNOTSUPP;
+
 	net_inc_ingress_queue();
 	net_inc_egress_queue();
 
@@ -254,6 +257,9 @@ static void clsact_destroy(struct Qdisc *sch)
 {
 	struct clsact_sched_data *q = qdisc_priv(sch);
 
+	if (sch->parent != TC_H_CLSACT)
+		return;
+
 	tcf_block_put_ext(q->egress_block, sch, &q->egress_block_info);
 	tcf_block_put_ext(q->ingress_block, sch, &q->ingress_block_info);
 
-- 
2.39.2



