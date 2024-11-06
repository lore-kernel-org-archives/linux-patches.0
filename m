Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C569C1DF736;
	Wed,  6 Nov 2024 12:24:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895847; cv=none; b=b4XOverxnDbqkvr/Vc51S4XNKdfz0dncXbSumOl4SSnMUdW64NQPgKYp6+RSyEFWWtk2m42wa0V0ldz3htKettJMYeK7erSgMxJNOYvht8csjYzjGL7Zbpvq39Q0Xb1tgIo/JFXwRcZ4auwfrCFqHC20qZJTXzX2kSCSIH2p0EQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895847; c=relaxed/simple;
	bh=BpYcQR2C0OsxGF6MTnvco8PUo3lwmLRkOyWpCgYLv8s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tfTlfdMrMQ46v7rEHfV32l09L/du6PUuNYZYWEP5Xf/Yogo/Maj20OO+SnQombFaAPuXyXrj3SfFf2PIzrgDbu8STvIjFN+FTz/6iWs3IjYOOJc0AhR4CAm5yGaYYkyh8tPYWxndz3DUlaD4sHvIT4JYvQT80qz1YyUTeTZXoJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IZyw6pHt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IZyw6pHt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49F24C4CECD;
	Wed,  6 Nov 2024 12:24:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895847;
	bh=BpYcQR2C0OsxGF6MTnvco8PUo3lwmLRkOyWpCgYLv8s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IZyw6pHtrzfb6GjktIBXo6RA+feaPJ/HRFfPkRv7/tq5tnhc2r0WNDkP3v48tkizL
	 GniZbUx6BdVzFRgugVvRvpu1D8Ji5kuVeVhayaqDHOtSC8JPARijSry19sROieynHr
	 IjtL9Tv12uZOfqzPAOFXiNAoKGLLrzBFg9MDyTro=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Budimir Markovic <markovicbudimir@gmail.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Victor Nogueira <victor@mojatatu.com>,
	Pedro Tammela <pctammela@mojatatu.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 331/350] net/sched: stop qdisc_tree_reduce_backlog on TC_H_ROOT
Date: Wed,  6 Nov 2024 13:04:19 +0100
Message-ID: <20241106120328.898484990@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pedro Tammela <pctammela@mojatatu.com>

[ Upstream commit 2e95c4384438adeaa772caa560244b1a2efef816 ]

In qdisc_tree_reduce_backlog, Qdiscs with major handle ffff: are assumed
to be either root or ingress. This assumption is bogus since it's valid
to create egress qdiscs with major handle ffff:
Budimir Markovic found that for qdiscs like DRR that maintain an active
class list, it will cause a UAF with a dangling class pointer.

In 066a3b5b2346, the concern was to avoid iterating over the ingress
qdisc since its parent is itself. The proper fix is to stop when parent
TC_H_ROOT is reached because the only way to retrieve ingress is when a
hierarchy which does not contain a ffff: major handle call into
qdisc_lookup with TC_H_MAJ(TC_H_ROOT).

In the scenario where major ffff: is an egress qdisc in any of the tree
levels, the updates will also propagate to TC_H_ROOT, which then the
iteration must stop.

Fixes: 066a3b5b2346 ("[NET_SCHED] sch_api: fix qdisc_tree_decrease_qlen() loop")
Reported-by: Budimir Markovic <markovicbudimir@gmail.com>
Suggested-by: Jamal Hadi Salim <jhs@mojatatu.com>
Tested-by: Victor Nogueira <victor@mojatatu.com>
Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>

 net/sched/sch_api.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
Reviewed-by: Simon Horman <horms@kernel.org>

Link: https://patch.msgid.link/20241024165547.418570-1-jhs@mojatatu.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_api.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
index ab57c0ee9923b..49c4e85257886 100644
--- a/net/sched/sch_api.c
+++ b/net/sched/sch_api.c
@@ -783,7 +783,7 @@ void qdisc_tree_reduce_backlog(struct Qdisc *sch, unsigned int n,
 	drops = max_t(int, n, 0);
 	rcu_read_lock();
 	while ((parentid = sch->parent)) {
-		if (TC_H_MAJ(parentid) == TC_H_MAJ(TC_H_INGRESS))
+		if (parentid == TC_H_ROOT)
 			break;
 
 		if (sch->flags & TCQ_F_NOPARENT)
-- 
2.43.0



