Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9438020F8F
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 19:19:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF268C433C7;
	Fri, 21 Jul 2023 19:19:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689967150;
	bh=4YtOT0CP2taM6fcDokuqxma2j4jxgRYmLmvu9vEgk4U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uCh697GGtKcZ/C4pGNjznWG1ikc3EJ6+oGHRIxzfMR/FGxmwQk0MFG0ZbV2h7F/wh
	 Cvbpap2ipSvq9EhXBKLpMCkmtsxUuNNsCC2CtdxrZRyaoZY0GS8p8YUF4KHmHILqWI
	 qxooUOk8a5rQpC5rryRiwuTD2sne4LALcC8xBfLo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Horman <simon.horman@corigine.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Pedro Tammela <pctammela@mojatatu.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 062/223] net/sched: sch_qfq: refactor parsing of netlink parameters
Date: Fri, 21 Jul 2023 18:05:15 +0200
Message-ID: <20230721160523.504387562@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160520.865493356@linuxfoundation.org>
References: <20230721160520.865493356@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Pedro Tammela <pctammela@mojatatu.com>

[ Upstream commit 25369891fcef373540f8b4e0b3bccf77a04490d5 ]

Two parameters can be transformed into netlink policies and
validated while parsing the netlink message.

Reviewed-by: Simon Horman <simon.horman@corigine.com>
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 3e337087c3b5 ("net/sched: sch_qfq: account for stab overhead in qfq_enqueue")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_qfq.c | 25 +++++++++++--------------
 1 file changed, 11 insertions(+), 14 deletions(-)

diff --git a/net/sched/sch_qfq.c b/net/sched/sch_qfq.c
index 02098a02943eb..2f3629c851584 100644
--- a/net/sched/sch_qfq.c
+++ b/net/sched/sch_qfq.c
@@ -113,6 +113,7 @@
 
 #define QFQ_MTU_SHIFT		16	/* to support TSO/GSO */
 #define QFQ_MIN_LMAX		512	/* see qfq_slot_insert */
+#define QFQ_MAX_LMAX		(1UL << QFQ_MTU_SHIFT)
 
 #define QFQ_MAX_AGG_CLASSES	8 /* max num classes per aggregate allowed */
 
@@ -214,9 +215,14 @@ static struct qfq_class *qfq_find_class(struct Qdisc *sch, u32 classid)
 	return container_of(clc, struct qfq_class, common);
 }
 
+static struct netlink_range_validation lmax_range = {
+	.min = QFQ_MIN_LMAX,
+	.max = QFQ_MAX_LMAX,
+};
+
 static const struct nla_policy qfq_policy[TCA_QFQ_MAX + 1] = {
-	[TCA_QFQ_WEIGHT] = { .type = NLA_U32 },
-	[TCA_QFQ_LMAX] = { .type = NLA_U32 },
+	[TCA_QFQ_WEIGHT] = NLA_POLICY_RANGE(NLA_U32, 1, QFQ_MAX_WEIGHT),
+	[TCA_QFQ_LMAX] = NLA_POLICY_FULL_RANGE(NLA_U32, &lmax_range),
 };
 
 /*
@@ -408,17 +414,13 @@ static int qfq_change_class(struct Qdisc *sch, u32 classid, u32 parentid,
 	}
 
 	err = nla_parse_nested_deprecated(tb, TCA_QFQ_MAX, tca[TCA_OPTIONS],
-					  qfq_policy, NULL);
+					  qfq_policy, extack);
 	if (err < 0)
 		return err;
 
-	if (tb[TCA_QFQ_WEIGHT]) {
+	if (tb[TCA_QFQ_WEIGHT])
 		weight = nla_get_u32(tb[TCA_QFQ_WEIGHT]);
-		if (!weight || weight > (1UL << QFQ_MAX_WSHIFT)) {
-			pr_notice("qfq: invalid weight %u\n", weight);
-			return -EINVAL;
-		}
-	} else
+	else
 		weight = 1;
 
 	if (tb[TCA_QFQ_LMAX])
@@ -426,11 +428,6 @@ static int qfq_change_class(struct Qdisc *sch, u32 classid, u32 parentid,
 	else
 		lmax = psched_mtu(qdisc_dev(sch));
 
-	if (lmax < QFQ_MIN_LMAX || lmax > (1UL << QFQ_MTU_SHIFT)) {
-		pr_notice("qfq: invalid max length %u\n", lmax);
-		return -EINVAL;
-	}
-
 	inv_w = ONE_FP / weight;
 	weight = ONE_FP / inv_w;
 
-- 
2.39.2



