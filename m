Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD432344D9A
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:02:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301734; cv=none; b=iKZSwUml6dvc0A/6Jc9HuXUwKIgUKKfUZZwf4ot6+wtm3r5lCS85To5ucMZB3jqjmvX7ChgAi2oB4cx8o7qRXtfgcXy9voU4Dv3y3PZUbtCN2q8OGTSLq45TPqL5G51KkH8FHYhQEeAIs8N5I7CVfMYhMlGLX+QZh74kYeOpNaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301734; c=relaxed/simple;
	bh=zYIzl0tjR4joTmSE/21WblCYHDXnig/KEGy6hs2/Epk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WEYF82mSDc1kw/JXLe4A4zenk7CWQ5F2bFEUi8T1yvmbzb2z8fBS2PQW6EN0GCdjiT2tck0qcOTS+xHkHLHCFwlnBgAtchZT+JEUkBvV3sCVGuzaKLGSw66n6e3Onza0u2BBUGic95q3vbp9QayIZ4HCp3aeJ5zj11l33xy7xbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SVJp70/7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SVJp70/7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A160C19423;
	Sat, 28 Feb 2026 18:02:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301734;
	bh=zYIzl0tjR4joTmSE/21WblCYHDXnig/KEGy6hs2/Epk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SVJp70/7oS2uzuSw3ZsUMIuL+GZ/dgWO3NsVooXBcG/o5VsbPU7dtCgOopcpjt6xA
	 +xMZg82gMnE97DInJoEfNgXARhoupNPKtUVt54TIPNrNyBUuewPI5MXL0iFsUWCV31
	 bKzzti4dbP7p1OS53TLzvNoJ16T2Vkr3v3TJqEvyvudJyMwGezHOEKsqHUIuhdRsVq
	 Afm0XYiD4Q6CexrsGORi9Kw+AiEzXg1n5BnegfzaBgnDclHey4PVN2ktHd6dVauTRt
	 nwxagwcbrNH4ZRW49LmGb4BQMrtjRf3CtQvR7krOf2/cYHln9kx5OChKWNUGLSjRhK
	 VYR8tscfa8Olg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Lai Jiangshan <jiangshan.ljs@antgroup.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 134/385] workqueue: Factor out assign_rescuer_work()
Date: Sat, 28 Feb 2026 12:55:56 -0500
Message-ID: <20260228180011.1568201-134-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Lai Jiangshan <jiangshan.ljs@antgroup.com>

[ Upstream commit 99ed6f62a46e91dc796b785618d646eeded1b230 ]

Move the code to assign work to rescuer and assign_rescuer_work().

Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Stable-dep-of: e5a30c303b07 ("workqueue: Process rescuer work items one-by-one using a cursor")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/workqueue.c | 29 ++++++++++++++++++-----------
 1 file changed, 18 insertions(+), 11 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 3c87eb98609c0..256d91aff181d 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -3407,6 +3407,23 @@ static int worker_thread(void *__worker)
 	goto woke_up;
 }
 
+static bool assign_rescuer_work(struct pool_workqueue *pwq, struct worker *rescuer)
+{
+	struct worker_pool *pool = pwq->pool;
+	struct work_struct *work, *n;
+
+	/*
+	 * Slurp in all works issued via this workqueue and
+	 * process'em.
+	 */
+	list_for_each_entry_safe(work, n, &pool->worklist, entry) {
+		if (get_work_pwq(work) == pwq && assign_work(work, rescuer, &n))
+			pwq->stats[PWQ_STAT_RESCUED]++;
+	}
+
+	return !list_empty(&rescuer->scheduled);
+}
+
 /**
  * rescuer_thread - the rescuer thread function
  * @__rescuer: self
@@ -3461,7 +3478,6 @@ static int rescuer_thread(void *__rescuer)
 		struct pool_workqueue *pwq = list_first_entry(&wq->maydays,
 					struct pool_workqueue, mayday_node);
 		struct worker_pool *pool = pwq->pool;
-		struct work_struct *work, *n;
 
 		__set_current_state(TASK_RUNNING);
 		list_del_init(&pwq->mayday_node);
@@ -3472,18 +3488,9 @@ static int rescuer_thread(void *__rescuer)
 
 		raw_spin_lock_irq(&pool->lock);
 
-		/*
-		 * Slurp in all works issued via this workqueue and
-		 * process'em.
-		 */
 		WARN_ON_ONCE(!list_empty(&rescuer->scheduled));
-		list_for_each_entry_safe(work, n, &pool->worklist, entry) {
-			if (get_work_pwq(work) == pwq &&
-			    assign_work(work, rescuer, &n))
-				pwq->stats[PWQ_STAT_RESCUED]++;
-		}
 
-		if (!list_empty(&rescuer->scheduled)) {
+		if (assign_rescuer_work(pwq, rescuer)) {
 			process_scheduled_works(rescuer);
 
 			/*
-- 
2.51.0

