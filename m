Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF7B514E2F9;
	Wed,  3 Apr 2024 17:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712166991; cv=none; b=l/HblEwI+YhN8MTvssDHqmN0dHp5kDBBC1noatg8hJdv612Vfer5gqQxbpq6QP7/RwAhOIITJy9GPhGuCbGZ2en9z14evqaP1smOx70Ztc7ZIOkQT2vnzjufLXdMLjWe8yr8Da52eRG/YgVtrvZjaC8bvOyfQ5Ulu8kJr/Lfi3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712166991; c=relaxed/simple;
	bh=0Ql6hZqZzwhvjhtw/ZIASXagUlbQ1qKZsF3qTsfEWtk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qf/cc4lPkz/+FhzJcB/PD2SEy9GKU5CmmRTVLo36T9TCFWarucq/1NzjJcBMyL8nyxEI0qtiEWid71IX32996iQBExIdvr+Ww888AKsQZd9YhWjEMcLJ2V1S7/XUIq16Lg2+E9fe8HqTzjrWTU6ii7yUTdrw36rBmDtfetl8N8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R2UzpaCS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R2UzpaCS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CC56C433F1;
	Wed,  3 Apr 2024 17:56:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712166990;
	bh=0Ql6hZqZzwhvjhtw/ZIASXagUlbQ1qKZsF3qTsfEWtk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R2UzpaCSUbddoTjB/ISwQ/3xOgQIjVfHx94T/SGMbGOWP/HN6tPqZe5spqbehfCrl
	 S1am3DXNTAOaLICbOGmQHQADd9Zx0b44QE2lYbWESoxEVdn3OWfOXxOUkHgKaZfQJR
	 Aa5ySlDnG3XJTyP0rUYXZL4GKTL2U4MbeeAWqAVQ=
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
Subject: [PATCH 6.8 09/11] Revert "workqueue: Factor out pwq_is_empty()"
Date: Wed,  3 Apr 2024 19:55:48 +0200
Message-ID: <20240403175126.074576689@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240403175125.754099419@linuxfoundation.org>
References: <20240403175125.754099419@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit 70abdc2f6c906ffea699f6e0e08fcbd9437e6bcc which is commit
afa87ce85379e2d93863fce595afdb5771a84004 upstream.

The workqueue patches backported to 6.8.y caused some reported
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
 kernel/workqueue.c |   13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1456,11 +1456,6 @@ static void put_pwq_unlocked(struct pool
 	}
 }
 
-static bool pwq_is_empty(struct pool_workqueue *pwq)
-{
-	return !pwq->nr_active && list_empty(&pwq->inactive_works);
-}
-
 static void pwq_activate_inactive_work(struct work_struct *work)
 {
 	struct pool_workqueue *pwq = get_work_pwq(work);
@@ -3330,7 +3325,7 @@ reflush:
 		bool drained;
 
 		raw_spin_lock_irq(&pwq->pool->lock);
-		drained = pwq_is_empty(pwq);
+		drained = !pwq->nr_active && list_empty(&pwq->inactive_works);
 		raw_spin_unlock_irq(&pwq->pool->lock);
 
 		if (drained)
@@ -4777,7 +4772,7 @@ static bool pwq_busy(struct pool_workque
 
 	if ((pwq != pwq->wq->dfl_pwq) && (pwq->refcnt > 1))
 		return true;
-	if (!pwq_is_empty(pwq))
+	if (pwq->nr_active || !list_empty(&pwq->inactive_works))
 		return true;
 
 	return false;
@@ -5215,7 +5210,7 @@ void show_one_workqueue(struct workqueue
 	unsigned long flags;
 
 	for_each_pwq(pwq, wq) {
-		if (!pwq_is_empty(pwq)) {
+		if (pwq->nr_active || !list_empty(&pwq->inactive_works)) {
 			idle = false;
 			break;
 		}
@@ -5227,7 +5222,7 @@ void show_one_workqueue(struct workqueue
 
 	for_each_pwq(pwq, wq) {
 		raw_spin_lock_irqsave(&pwq->pool->lock, flags);
-		if (!pwq_is_empty(pwq)) {
+		if (pwq->nr_active || !list_empty(&pwq->inactive_works)) {
 			/*
 			 * Defer printing to avoid deadlocks in console
 			 * drivers that queue work while holding locks


