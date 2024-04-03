Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07197154446;
	Wed,  3 Apr 2024 17:57:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712167029; cv=none; b=R9sBt6H0EzAZQ7+pWfgQA9bIBQ4VWY6oyL55VMIj1XMketRPGdHlpUzb06PvDI/wbVQ0Cy3495onB7BPy0vnDpEgFy8XATec7hDliJuLhbPrOS/Ho7WTEFsNrBdMT+Uu9c+nbdm2C2HsUhs/uTYk7JYXsRIfm98gWMm/4crplvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712167029; c=relaxed/simple;
	bh=GHJe9yZIlF/f7phLnU8UrF+LwCEpjKZfpqse6RVPJtM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oTfzO9CRoIqQv7vwEzsX7BSAMBoSqMYXW66SVIXH3wt5fPFnBi9Ph3155sUJeMTMpn9xm8aTNzWQZhEuy/si++7f0HBYPaadYqJ508GkA2S0DP11lDqEXjrpDiPv5lFnXOD7yheRUwjrslphp1wkFhRU5oU50PCTd6XahC7dqrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f0/aWil+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f0/aWil+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23B33C433F1;
	Wed,  3 Apr 2024 17:57:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712167028;
	bh=GHJe9yZIlF/f7phLnU8UrF+LwCEpjKZfpqse6RVPJtM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f0/aWil+VpCBGMDX8Z+PIcAbyqmud3rGhWXAKy96kMkXMEJGESbu5eNqsjzJRNX00
	 NxXYhd4qyQNPT6bvWREqYfhMtQZ7Ylv6tectDCJ+ucqrZlpoZCRThZimoXcoQUmQ5V
	 xK++b/QPAvZ+XQ3eDklkdtj9ypOuYYTB+iTjT9Hk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Leemhuis <regressions@leemhuis.info>,
	Tejun Heo <tj@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Audra Mitchell <audra@redhat.com>
Subject: [PATCH 6.6 08/11] Revert "workqueue: Replace pwq_activate_inactive_work() with [__]pwq_activate_work()"
Date: Wed,  3 Apr 2024 19:55:57 +0200
Message-ID: <20240403175127.106469745@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240403175126.839589571@linuxfoundation.org>
References: <20240403175126.839589571@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit 6c592f0bb96815117538491e5ba12e0a8a8c4493 which is
commit 4c6380305d21e36581b451f7337a36c93b64e050 upstream.

The workqueue patches backported to 6.6.y caused some reported
regressions, so revert them for now.

Reported-by: Thorsten Leemhuis <regressions@leemhuis.info>
Cc: Tejun Heo <tj@kernel.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Sasha Levin <sashal@kernel.org>
Cc: Audra Mitchell <audra@redhat.com>
Link: https://lore.kernel.org/all/ce4c2f67-c298-48a0-87a3-f933d646c73b@leemhuis.info/
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/workqueue.c |   31 ++++++-------------------------
 1 file changed, 6 insertions(+), 25 deletions(-)

--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1455,36 +1455,16 @@ static bool pwq_is_empty(struct pool_wor
 	return !pwq->nr_active && list_empty(&pwq->inactive_works);
 }
 
-static void __pwq_activate_work(struct pool_workqueue *pwq,
-				struct work_struct *work)
+static void pwq_activate_inactive_work(struct work_struct *work)
 {
+	struct pool_workqueue *pwq = get_work_pwq(work);
+
 	trace_workqueue_activate_work(work);
 	if (list_empty(&pwq->pool->worklist))
 		pwq->pool->watchdog_ts = jiffies;
 	move_linked_works(work, &pwq->pool->worklist, NULL);
 	__clear_bit(WORK_STRUCT_INACTIVE_BIT, work_data_bits(work));
-}
-
-/**
- * pwq_activate_work - Activate a work item if inactive
- * @pwq: pool_workqueue @work belongs to
- * @work: work item to activate
- *
- * Returns %true if activated. %false if already active.
- */
-static bool pwq_activate_work(struct pool_workqueue *pwq,
-			      struct work_struct *work)
-{
-	struct worker_pool *pool = pwq->pool;
-
-	lockdep_assert_held(&pool->lock);
-
-	if (!(*work_data_bits(work) & WORK_STRUCT_INACTIVE))
-		return false;
-
 	pwq->nr_active++;
-	__pwq_activate_work(pwq, work);
-	return true;
 }
 
 static void pwq_activate_first_inactive(struct pool_workqueue *pwq)
@@ -1492,7 +1472,7 @@ static void pwq_activate_first_inactive(
 	struct work_struct *work = list_first_entry(&pwq->inactive_works,
 						    struct work_struct, entry);
 
-	pwq_activate_work(pwq, work);
+	pwq_activate_inactive_work(work);
 }
 
 /**
@@ -1630,7 +1610,8 @@ static int try_to_grab_pending(struct wo
 		 * management later on and cause stall.  Make sure the work
 		 * item is activated before grabbing.
 		 */
-		pwq_activate_work(pwq, work);
+		if (*work_data_bits(work) & WORK_STRUCT_INACTIVE)
+			pwq_activate_inactive_work(work);
 
 		list_del_init(&work->entry);
 		pwq_dec_nr_in_flight(pwq, *work_data_bits(work));


