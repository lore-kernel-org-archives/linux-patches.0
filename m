Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EA7F346AC1
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:08:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302096; cv=none; b=n0l4OlI9rTaim+yrYkQ4E6mElKFPZ4y+Yn3imQC5Zp2EmV55ZlovY1GYwgz5/MOzWqsyZnUyJL6cE6XhAjjaecksml9YMdoKrK6r+DfzlN2geRXlSGNy3Lzw42ffnjogWOhEQdywVPz+DcHKJjlkolu8RIQgrP1Y1LaLqyx1YZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302096; c=relaxed/simple;
	bh=s1SovdnODrwXSc2iy75hU7NFJdE8VwLNeJm3eQhLZTg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nQHgCrJQAeUYpAA8+wENtZ+BuaqnWxEv7BCTSLkdq21lCHPq55c2RTvfhRe+byCa0FB04VigJYLfCR/ndhjhaV/w88EMStrfTA8mlDn6Gg97RAIW+pbwCCbyzfsHZxrFWsOpIfqhk8OdqQf7K3AGuFH3B686LU9cJOruEg4V/CU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iPp51I8T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iPp51I8T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0A47C2BC87;
	Sat, 28 Feb 2026 18:08:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302096;
	bh=s1SovdnODrwXSc2iy75hU7NFJdE8VwLNeJm3eQhLZTg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iPp51I8T4r1p+kZ9xiKZJv2YShPK22z/4XJBWKJRQZSypS3atz1fqNEUXKjx0sdRm
	 gsQzsKPO6d0DWnRH+mzSzKbHgT+cpzt16IJ/4FDMZFPwD0/NACsV6NKCFMY/fFr+hX
	 IwOIzYqvXxFgSjq4jZfLJKCAZ4kH+KOACQbXZOrqZnnM8P89fbnTRdBaa56aOAFvJN
	 BCPtn+1PYZNWSYmX4tDxY68FOoGP3a0M6h2iXlUgqr+aCJY7b5zANo0MZu8LnssuQh
	 8I8gRN2wfz0MvjLXjQemmeBVu5YMgMNu9v0ar3GeQvJ3N5yf4hdVtlEK7E/RykNhtU
	 e6YP16abuMNTA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Lai Jiangshan <jiangshan.ljs@antgroup.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 081/283] workqueue: Factor out assign_rescuer_work()
Date: Sat, 28 Feb 2026 13:03:43 -0500
Message-ID: <20260228180709.1583486-81-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
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
index 59b6efb2a11c3..9127d74643fef 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -2808,6 +2808,23 @@ static int worker_thread(void *__worker)
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
@@ -2862,7 +2879,6 @@ static int rescuer_thread(void *__rescuer)
 		struct pool_workqueue *pwq = list_first_entry(&wq->maydays,
 					struct pool_workqueue, mayday_node);
 		struct worker_pool *pool = pwq->pool;
-		struct work_struct *work, *n;
 
 		__set_current_state(TASK_RUNNING);
 		list_del_init(&pwq->mayday_node);
@@ -2873,18 +2889,9 @@ static int rescuer_thread(void *__rescuer)
 
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

