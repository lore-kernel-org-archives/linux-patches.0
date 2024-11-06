Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4733D1DED58;
	Wed,  6 Nov 2024 12:25:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895948; cv=none; b=pCQZ7Rb8idtIA6/Az0fztnn0YA8dmOVpoNI/qWAdrbFllLbNLIEMZXndDqPv9tYgjv/+AdXGny9Fs4eLy7YitlD6iWj4pBO56ZvrMIhavB9XQ3SB4PKiK95crQZNTt6GtMgV8o8mPgjuT1zO84kUnMqdNIYS2xMzD9P/WkIoYPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895948; c=relaxed/simple;
	bh=rL3B65hMjXoNjIxWBeVW9blK99hqBJ7hVHKGHCbAfLA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cjn6WI4aVMG+dyGWOBT8waJNJAbmqldkVMAPP8IPWMJ6ynDoyJhPV2lfkpRVEADKlMvDXVtUwUu143tBYcF4Rc9qE5cxPT2sevlvw3bP1eKs2mjGv4f9PS7Ntc4d17tsfHAuUxGgkyKwsaDNT/iBQi7tLyh7B8Khs122ypiLd0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F/7ukWxq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F/7ukWxq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84675C4CECD;
	Wed,  6 Nov 2024 12:25:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895947;
	bh=rL3B65hMjXoNjIxWBeVW9blK99hqBJ7hVHKGHCbAfLA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F/7ukWxqdNSvK6GwqXMCfxJ7AoRxymua5wSYDztGbqNnJboaUkt3abJtL6cH4pvzw
	 4AwR05zH9YL3Ug1lpHDIZk/EGfSPkzjtP/7BM08vKV5h5pTY1IlaTdKRWw9o1A/lVV
	 V6zeeprOlkFEy1siTc8sD75Hwkf4Jg84RKp0zdsg=
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
Subject: [PATCH 6.11 037/245] net/sched: stop qdisc_tree_reduce_backlog on TC_H_ROOT
Date: Wed,  6 Nov 2024 13:01:30 +0100
Message-ID: <20241106120320.137447516@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 2eefa47838799..a1d27bc039a36 100644
--- a/net/sched/sch_api.c
+++ b/net/sched/sch_api.c
@@ -791,7 +791,7 @@ void qdisc_tree_reduce_backlog(struct Qdisc *sch, int n, int len)
 	drops = max_t(int, n, 0);
 	rcu_read_lock();
 	while ((parentid = sch->parent)) {
-		if (TC_H_MAJ(parentid) == TC_H_MAJ(TC_H_INGRESS))
+		if (parentid == TC_H_ROOT)
 			break;
 
 		if (sch->flags & TCQ_F_NOPARENT)
-- 
2.43.0



