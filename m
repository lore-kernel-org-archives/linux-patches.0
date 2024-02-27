Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE91013AA43;
	Tue, 27 Feb 2024 14:08:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042903; cv=none; b=dlmRh5mWzCcixu9D0kRMNAd6gaHXdE9VeOf/IeRQ6I2q0DREYDBkkZa4Tz06cFDuaRoF2Z2/pDI2xUK5Gy/9r47epMSdAQi83Arj7/1cAjzt/GeXgDzuK+fbeRYELaBp2HdjYhtVitnyfxN53cAZZXUwG1VQ7hXowBH07Wq02js=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042903; c=relaxed/simple;
	bh=cCfvpgzfEDdy3uNYa94L8nabNg0fKir9S9umJFVmMAU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YRuQtwGnxVtCI4eCgseYMG1tPmeCZBtnOOid83bjGR6G2Vw1ma0lu/FpLGh+ViL45e/Z9J/Jw0mqTGUb8m/Y2Vc8LoazqUdfbXYVKRFQs77hPFSd44Xp89gIv/BbSEL+q3SPk+Xo6dyMCjkwXanKn9X53AHybbgfXX4OoRB1FH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TN4lNe78; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TN4lNe78"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BCECC433C7;
	Tue, 27 Feb 2024 14:08:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042903;
	bh=cCfvpgzfEDdy3uNYa94L8nabNg0fKir9S9umJFVmMAU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TN4lNe78BSoXQof0OZAURg4hISjwTZngMPSsSZYbJKQr0i7SnIT/7ollrVVJNUn/X
	 3HNt5JoK6kmrXoVlQ55oB6ORruIARu91jWn08OxdrNznZuG4IY0ePSQo3euU4MfFUU
	 TZ0PtZFHaaqKcqQOFIIPZhqaWzPxyxphEvooaY1Y=
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
Subject: [PATCH 5.15 163/245] net/sched: Refactor qdisc_graft() for ingress and clsact Qdiscs
Date: Tue, 27 Feb 2024 14:25:51 +0100
Message-ID: <20240227131620.511176202@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131615.098467438@linuxfoundation.org>
References: <20240227131615.098467438@linuxfoundation.org>
User-Agent: quilt/0.67
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_api.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
index fa79dbd3601fa..7fdc2c1f87561 100644
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
 		if (new && new->ops->attach && !ingress)
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
2.43.0



