Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDF30154429;
	Wed,  3 Apr 2024 17:57:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712167031; cv=none; b=rEVHWHJRmJ5o1R9VF8mlq7+RirGg1By379QOYM98q8tfVW4ZJX9lLp26W1FVWLz8HWJ0vGyvXJLEOV7GfD3X5byHsHAcAJ+Q3gWRHBx6H1RSjnUWGeuf0nsNsB/OFLxnit2Vj96D0ckHzyTkxmmzToPT7EVdRXci2IH7m4M/7Ls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712167031; c=relaxed/simple;
	bh=0Pl2AWSj8h7GqT1fbc+8PuwfGi5celowpLT7BxPrOoI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RWeAOMeOHGtabQobW+k2MQjIdpwqPQRG9Vc4QDMBrls4BRvNVFboiK21mn5ZNKYfUNLS9nsBIubp2CAd71V5kMTfp+LFBgtPluyFZCMs9rG9Jr5WV3+DoDuN4g8MPaAu5xUzOydW9NQePd+RoWprsHqtZ+nsJowK4/Y8F1stkrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a7MZxcTE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a7MZxcTE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4499AC433C7;
	Wed,  3 Apr 2024 17:57:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712167031;
	bh=0Pl2AWSj8h7GqT1fbc+8PuwfGi5celowpLT7BxPrOoI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a7MZxcTE3MaIkrYlTBCGhncmel2d4ikrcUw5lFpGd5T7SohYFF769Lst03dfwJaB2
	 W2/QE3y2D9dBLfdDR2Nr5sDCx73wDOrXJfG8ZSbq248ZfD4auJ5c5MAZuzQ2MYSyQm
	 xPTfQSPmkZ7itumiq1zIfQjyZJuEb0xvBsd6L1DQ=
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
Subject: [PATCH 6.6 09/11] Revert "workqueue: Factor out pwq_is_empty()"
Date: Wed,  3 Apr 2024 19:55:58 +0200
Message-ID: <20240403175127.141519196@linuxfoundation.org>
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

This reverts commit bad184d26a4f68aa00ad75502f9669950a790f71 which is
commit afa87ce85379e2d93863fce595afdb5771a84004 upstream.

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
 kernel/workqueue.c |   13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1450,11 +1450,6 @@ static void put_pwq_unlocked(struct pool
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
@@ -3324,7 +3319,7 @@ reflush:
 		bool drained;
 
 		raw_spin_lock_irq(&pwq->pool->lock);
-		drained = pwq_is_empty(pwq);
+		drained = !pwq->nr_active && list_empty(&pwq->inactive_works);
 		raw_spin_unlock_irq(&pwq->pool->lock);
 
 		if (drained)
@@ -4784,7 +4779,7 @@ static bool pwq_busy(struct pool_workque
 
 	if ((pwq != pwq->wq->dfl_pwq) && (pwq->refcnt > 1))
 		return true;
-	if (!pwq_is_empty(pwq))
+	if (pwq->nr_active || !list_empty(&pwq->inactive_works))
 		return true;
 
 	return false;
@@ -5222,7 +5217,7 @@ void show_one_workqueue(struct workqueue
 	unsigned long flags;
 
 	for_each_pwq(pwq, wq) {
-		if (!pwq_is_empty(pwq)) {
+		if (pwq->nr_active || !list_empty(&pwq->inactive_works)) {
 			idle = false;
 			break;
 		}
@@ -5234,7 +5229,7 @@ void show_one_workqueue(struct workqueue
 
 	for_each_pwq(pwq, wq) {
 		raw_spin_lock_irqsave(&pwq->pool->lock, flags);
-		if (!pwq_is_empty(pwq)) {
+		if (pwq->nr_active || !list_empty(&pwq->inactive_works)) {
 			/*
 			 * Defer printing to avoid deadlocks in console
 			 * drivers that queue work while holding locks


