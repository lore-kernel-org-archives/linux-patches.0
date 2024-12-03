Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C3F01F8921;
	Tue,  3 Dec 2024 15:38:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240304; cv=none; b=f4dmBAC2L14S9UbUwLM/1ImcsZWvZ/5XVWBW/m8rzVN7s+lF+gpYSfW5ElBQOxId1HEuLKxBLkgnFop871eQ0OFxYktpMg9MIKWFnj6wIvNAIbuYmpGv7QvhxauPmXh7h9bn/4u93sGM6VejepFVq0SHqDN3G+iIS1kcHWAnFmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240304; c=relaxed/simple;
	bh=cJ/qim6mt4Nct0arDRf4yFkbyZU+xUS+wcMIf/+Ii7k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oRk0Zy6AjgudslWPwadEA8M3ercSspn6W8WnTpqC497DcDJuN8qrSKpZfOGOGQLf/JpbZM/t9k1qdFrgrgEBZzokp/5GYvaJnGWbmhm+uWKi2yy9Ioibzq1QnWfJIRnJBjXGe4a5ivy4xriL1BhJ/6TPK20hereBEWbUMWQSVNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pek1mLdj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pek1mLdj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4219C4CECF;
	Tue,  3 Dec 2024 15:38:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240304;
	bh=cJ/qim6mt4Nct0arDRf4yFkbyZU+xUS+wcMIf/+Ii7k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pek1mLdjENTbmR5A35z7BaWkBgy4GaGwNJMVZIv5SPvIx07eItnzlDFA7f5jNSBVs
	 /vRrj8ya9TLZtONTuz+PJWwfAmSCJYDiwltx6m/HJRRuO5Z62VNCFVhyB+TR+zwXeq
	 7qq7wfG3WYgt2KHrdantwSscUrF0JV+qdr0H/tUg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 093/826] sched/ext: Remove sched_fork() hack
Date: Tue,  3 Dec 2024 15:37:00 +0100
Message-ID: <20241203144747.359653795@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

[ Upstream commit 0f0d1b8e5010bfe1feeb4d78d137e41946a5370d ]

Instead of solving the underlying problem of the double invocation of
__sched_fork() for idle tasks, sched-ext decided to hack around the issue
by partially clearing out the entity struct to preserve the already
enqueued node. A provided analysis and solution has been ignored for four
months.

Now that someone else has taken care of cleaning it up, remove the
disgusting hack and clear out the full structure. Remove the comment in the
structure declaration as well, as there is no requirement for @node being
the last element anymore.

Fixes: f0e1a0643a59 ("sched_ext: Implement BPF extensible scheduler class")
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Tejun Heo <tj@kernel.org>
Link: https://lore.kernel.org/r/87ldy82wkc.ffs@tglx
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/sched/ext.h | 1 -
 kernel/sched/ext.c        | 7 +------
 2 files changed, 1 insertion(+), 7 deletions(-)

diff --git a/include/linux/sched/ext.h b/include/linux/sched/ext.h
index 1ddbde64a31b4..2799e7284fff7 100644
--- a/include/linux/sched/ext.h
+++ b/include/linux/sched/ext.h
@@ -199,7 +199,6 @@ struct sched_ext_entity {
 #ifdef CONFIG_EXT_GROUP_SCHED
 	struct cgroup		*cgrp_moving_from;
 #endif
-	/* must be the last field, see init_scx_entity() */
 	struct list_head	tasks_node;
 };
 
diff --git a/kernel/sched/ext.c b/kernel/sched/ext.c
index 751d73d500e51..ecb88c5285447 100644
--- a/kernel/sched/ext.c
+++ b/kernel/sched/ext.c
@@ -3567,12 +3567,7 @@ static void scx_ops_exit_task(struct task_struct *p)
 
 void init_scx_entity(struct sched_ext_entity *scx)
 {
-	/*
-	 * init_idle() calls this function again after fork sequence is
-	 * complete. Don't touch ->tasks_node as it's already linked.
-	 */
-	memset(scx, 0, offsetof(struct sched_ext_entity, tasks_node));
-
+	memset(scx, 0, sizeof(*scx));
 	INIT_LIST_HEAD(&scx->dsq_list.node);
 	RB_CLEAR_NODE(&scx->dsq_priq);
 	scx->sticky_cpu = -1;
-- 
2.43.0



