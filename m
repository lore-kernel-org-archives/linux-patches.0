Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C18414E2F9;
	Wed,  3 Apr 2024 17:56:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712166980; cv=none; b=YZkFgZUsFk8GGyiRUy0lDmIUr8rEqpduoUPfl8ScsNZ6Af9J5+lI0vDFd0mRJ1OTgE+rm9qyw9P11DAe/keb8FbpD+dwIzanVyUa3RBcKBX+205vznDsKscqEIJvV6Y4FAj7FHYVFi5ACukAdZA6kZ//owVZuISCWVB77qdtFD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712166980; c=relaxed/simple;
	bh=Dyzznnld1I+MnSzVr7jrnqb+4Dw6ZLvKZhb2VIGFdx0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FfVaLbNPHZtGqFuz5Gh8izokzmTzW9EFKKwpu6Mn6lBAIMmpznU2kpW/vaKggj4sajlT4fx2xw0eK3F9PHFhd13HdXlXGjkEdZ7JuOE0GEvix05Ni2CDUxMNqn4A8pytwVBA9EwyXZhBl3zQuLsRrepJyhc/zb7QP9Jc3oTETbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iOh9vS+Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iOh9vS+Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C55D9C433F1;
	Wed,  3 Apr 2024 17:56:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712166980;
	bh=Dyzznnld1I+MnSzVr7jrnqb+4Dw6ZLvKZhb2VIGFdx0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iOh9vS+QtNybzEHgdnzO3BRz2sbJa+ANdMXON81O4XpI/b8jKDcMEpww3KFz0i+Pv
	 8UkyxbDLJI3hZ/zArZY4AsLI2HoDcpqhipkw4huvngyeTozAcvQnMBELvjPqd3RENP
	 axut7wH1KCQF6PiCYpRpJa5OXTm+COf8+dTvejAM=
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
Subject: [PATCH 6.8 06/11] Revert "workqueue: Make wq_adjust_max_active() round-robin pwqs while activating"
Date: Wed,  3 Apr 2024 19:55:45 +0200
Message-ID: <20240403175125.980013482@linuxfoundation.org>
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

This reverts commit ddb232dc0f1339f9ed506730fd6bee6f5e3dcb37 which is
commit c5404d4e6df6faba1007544b5f4e62c7c14416dd upstream.

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
 kernel/workqueue.c |   33 +++++++++++++--------------------
 1 file changed, 13 insertions(+), 20 deletions(-)

--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -4703,7 +4703,7 @@ static int init_rescuer(struct workqueue
  */
 static void wq_adjust_max_active(struct workqueue_struct *wq)
 {
-	bool activated;
+	struct pool_workqueue *pwq;
 
 	lockdep_assert_held(&wq->mutex);
 
@@ -4723,26 +4723,19 @@ static void wq_adjust_max_active(struct
 	 */
 	WRITE_ONCE(wq->max_active, wq->saved_max_active);
 
-	/*
-	 * Round-robin through pwq's activating the first inactive work item
-	 * until max_active is filled.
-	 */
-	do {
-		struct pool_workqueue *pwq;
+	for_each_pwq(pwq, wq) {
+		unsigned long flags;
+
+		/* this function can be called during early boot w/ irq disabled */
+		raw_spin_lock_irqsave(&pwq->pool->lock, flags);
 
-		activated = false;
-		for_each_pwq(pwq, wq) {
-			unsigned long flags;
-
-			/* can be called during early boot w/ irq disabled */
-			raw_spin_lock_irqsave(&pwq->pool->lock, flags);
-			if (pwq_activate_first_inactive(pwq)) {
-				activated = true;
-				kick_pool(pwq->pool);
-			}
-			raw_spin_unlock_irqrestore(&pwq->pool->lock, flags);
-		}
-	} while (activated);
+		while (pwq_activate_first_inactive(pwq))
+			;
+
+		kick_pool(pwq->pool);
+
+		raw_spin_unlock_irqrestore(&pwq->pool->lock, flags);
+	}
 }
 
 __printf(1, 4)


