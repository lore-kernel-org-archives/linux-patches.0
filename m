Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F36E13777E;
	Tue, 16 Jun 2026 18:41:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781635316; cv=none; b=VF34MWtAgsss+6zh0LHxUYflnZUkoh80zzOXpICpvUsApV/oyNb4SjHAnhv2kFCw61lfLxG27LnmbaSZqPt5uYzg5OCBV5teLW/bWMwG3EUCEsDTK58nAeaZhJcV2mheXS0fuMW9kRNC+eZvkiRCx52JoWjjD6NLmpqNMYOfHoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781635316; c=relaxed/simple;
	bh=yx1HpeLTRxcTfsp5McpnFxQrMPzcTrctVu9RosfqiZk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kaLEwUoNf7F38/Rr8vukHKPPu2njPA6/YgGPx4vARq0iqveV+0b3BWkRybaevGmNTun5B76zvelpD41smD9oNGUsFw8xpCt/B8sbRvRQDf/tc8KD9fq2GNUq2UB/nUZYJw+1yEVrZV4uZVBYABwhiI29OsNIlImbWbOzwxfmt+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZO2Rwgd8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZO2Rwgd8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CC1E1F000E9;
	Tue, 16 Jun 2026 18:41:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781635315;
	bh=nUwWsFoTfoSyg896OypkHQFkKdUtINxwPNho0nu2VDU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZO2Rwgd8aQdrrY9F64bzqwSH3vsF3lHFL+CnqZH5yECX7QFdczAUneGHIv1vsWml0
	 4LOw62J4ffPCp8Xgr/EPjG1k0xBMrQDsPb9QJxuGH2bpGh6gHFUm2LgqZ1j+5AtqLs
	 5dySEg4H2qcBt2YZy1i8nJPITI5B5dU71aRTV9q0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ji-Soo Chung <jschung2@proton.me>,
	Gerlinde <lrGerlinde@mailfence.com>,
	zyc zyc <zyc199902@zohomail.cn>,
	Manas Ghandat <ghandatmanas@gmail.com>,
	Stephen Hemminger <stephen@networkplumber.org>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 026/342] net/sched: Revert "net/sched: Restrict conditions for adding duplicating netems to qdisc tree"
Date: Tue, 16 Jun 2026 20:25:22 +0530
Message-ID: <20260616145049.479421675@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145048.348037099@linuxfoundation.org>
References: <20260616145048.348037099@linuxfoundation.org>
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

[ Upstream commit eda0b7f203bb166c98d1418b204135bd566ac83b ]

This reverts commit ec8e0e3d7adef940cdf9475e2352c0680189d14e.

The original patch rejects any tree containing two netems when
either has duplication set, even when they sit on unrelated classes
of the same classful parent. That broke configurations that have
worked since netem was introduced.

The re-entrancy problem the original commit was trying to solve is
handled by later patch using tc_depth flag.

Doing this revert will (re)expose the original bug with multiple
netem duplication. When this patch is backported make sure
and get the full series.

Fixes: ec8e0e3d7ade ("net/sched: Restrict conditions for adding duplicating netems to qdisc tree")
Reported-by: Ji-Soo Chung <jschung2@proton.me>
Reported-by: Gerlinde <lrGerlinde@mailfence.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=220774
Reported-by: zyc zyc <zyc199902@zohomail.cn>
Closes: https://lore.kernel.org/all/19adda5a1e2.12410b78222774.9191120410578703463@zohomail.cn/
Reported-by: Manas Ghandat <ghandatmanas@gmail.com>
Closes: https://lore.kernel.org/netdev/f69b2c8f-8325-4c2e-a011-6dbc089f30e4@gmail.com/
Reviewed-by: Stephen Hemminger <stephen@networkplumber.org>
Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
Link: https://patch.msgid.link/20260525122556.973584-3-jhs@mojatatu.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_netem.c | 40 ----------------------------------------
 1 file changed, 40 deletions(-)

diff --git a/net/sched/sch_netem.c b/net/sched/sch_netem.c
index 3e3bced82c564d..3dc6411b0a33c7 100644
--- a/net/sched/sch_netem.c
+++ b/net/sched/sch_netem.c
@@ -985,41 +985,6 @@ static int parse_attr(struct nlattr *tb[], int maxtype, struct nlattr *nla,
 	return 0;
 }
 
-static const struct Qdisc_class_ops netem_class_ops;
-
-static int check_netem_in_tree(struct Qdisc *sch, bool duplicates,
-			       struct netlink_ext_ack *extack)
-{
-	struct Qdisc *root, *q;
-	unsigned int i;
-
-	root = qdisc_root_sleeping(sch);
-
-	if (sch != root && root->ops->cl_ops == &netem_class_ops) {
-		if (duplicates ||
-		    ((struct netem_sched_data *)qdisc_priv(root))->duplicate)
-			goto err;
-	}
-
-	if (!qdisc_dev(root))
-		return 0;
-
-	hash_for_each(qdisc_dev(root)->qdisc_hash, i, q, hash) {
-		if (sch != q && q->ops->cl_ops == &netem_class_ops) {
-			if (duplicates ||
-			    ((struct netem_sched_data *)qdisc_priv(q))->duplicate)
-				goto err;
-		}
-	}
-
-	return 0;
-
-err:
-	NL_SET_ERR_MSG(extack,
-		       "netem: cannot mix duplicating netems with other netems in tree");
-	return -EINVAL;
-}
-
 /* Parse netlink message to set options */
 static int netem_change(struct Qdisc *sch, struct nlattr *opt,
 			struct netlink_ext_ack *extack)
@@ -1087,11 +1052,6 @@ static int netem_change(struct Qdisc *sch, struct nlattr *opt,
 	q->gap = qopt->gap;
 	q->counter = 0;
 	q->loss = qopt->loss;
-
-	ret = check_netem_in_tree(sch, qopt->duplicate, extack);
-	if (ret)
-		goto unlock;
-
 	q->duplicate = qopt->duplicate;
 
 	/* for compatibility with earlier versions.
-- 
2.53.0



