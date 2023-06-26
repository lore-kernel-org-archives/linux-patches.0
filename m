Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAAF7C8E5
	for <patches@lists.linux.dev>; Mon, 26 Jun 2023 18:43:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DBDFC433C9;
	Mon, 26 Jun 2023 18:43:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687805010;
	bh=E3+bFpV8cOwrEAPSTSmSdKkeIkO2ACFyrV2/zrEiPKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BTddLSw2y0neol/jcznCITWHy/yhudwZYVtkVp46YrXdD/MHtkdVEZxyKET/9MCuZ
	 GlEawt1CWXjVBN0BUqKNFyVjIO6kYOlxHwPigm4yxb2gZmDGoUWqijNybhWUIqWlap
	 dpVhsYk/zpNRIrao1b0qR/VCD9mzzLSkDEg8ENDI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pedro Tammela <pctammela@mojatatu.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Vlad Buslov <vladbu@nvidia.com>,
	Peilin Ye <peilin.ye@bytedance.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 02/81] net/sched: Refactor qdisc_graft() for ingress and clsact Qdiscs
Date: Mon, 26 Jun 2023 20:11:44 +0200
Message-ID: <20230626180744.556242511@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230626180744.453069285@linuxfoundation.org>
References: <20230626180744.453069285@linuxfoundation.org>
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

[ Upstream commit 2d5f6a8d7aef7852a9ecc555f88c673a1c91754f ]

Grafting ingress and clsact Qdiscs does not need a for-loop in
qdisc_graft().  Refactor it.  No functional changes intended.

Tested-by: Pedro Tammela <pctammela@mojatatu.com>
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
Reviewed-by: Vlad Buslov <vladbu@nvidia.com>
Signed-off-by: Peilin Ye <peilin.ye@bytedance.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: 84ad0af0bccd ("net/sched: qdisc_destroy() old ingress and clsact Qdiscs before grafting")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_api.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
index 2084724c36ad3..fb50e3f3283f9 100644
--- a/net/sched/sch_api.c
+++ b/net/sched/sch_api.c
@@ -1044,12 +1044,12 @@ static int qdisc_graft(struct net_device *dev, struct Qdisc *parent,
 
 	if (parent == NULL) {
 		unsigned int i, num_q, ingress;
+		struct netdev_queue *dev_queue;
 
 		ingress = 0;
 		num_q = dev->num_tx_queues;
 		if ((q && q->flags & TCQ_F_INGRESS) ||
 		    (new && new->flags & TCQ_F_INGRESS)) {
-			num_q = 1;
 			ingress = 1;
 			if (!dev_ingress_queue(dev)) {
 				NL_SET_ERR_MSG(extack, "Device does not have an ingress queue");
@@ -1065,18 +1065,18 @@ static int qdisc_graft(struct net_device *dev, struct Qdisc *parent,
 		if (new && new->ops->attach)
 			goto skip;
 
-		for (i = 0; i < num_q; i++) {
-			struct netdev_queue *dev_queue = dev_ingress_queue(dev);
-
-			if (!ingress)
+		if (!ingress) {
+			for (i = 0; i < num_q; i++) {
 				dev_queue = netdev_get_tx_queue(dev, i);
+				old = dev_graft_qdisc(dev_queue, new);
 
-			old = dev_graft_qdisc(dev_queue, new);
-			if (new && i > 0)
-				qdisc_refcount_inc(new);
-
-			if (!ingress)
+				if (new && i > 0)
+					qdisc_refcount_inc(new);
 				qdisc_put(old);
+			}
+		} else {
+			dev_queue = dev_ingress_queue(dev);
+			old = dev_graft_qdisc(dev_queue, new);
 		}
 
 skip:
-- 
2.39.2



