Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D49E4154458;
	Wed,  3 Apr 2024 17:57:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712167022; cv=none; b=OBet3v7DsSEHk89Q3pKUpE5ifEwsWNgOx3UG7r8KXl5StGo+xYI9r3Sf5dBXbhg8wA1J7pvwAU6rRHei2LSG6gHz6C97OKvSqimVyOFmg/fDgusGxZcnOtRYWTIeH0QDyiCoE/djA2mjsIQIzUKs3ycGgiNUECssVIydOQldpnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712167022; c=relaxed/simple;
	bh=Zy0Z4HwFkWw/RVYn+fh1FA/mYof9nQY0hhA/SVA0AS8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tjbffXsDCKYLMpmOwwNRD7++u8VB+ZCpbrb2QqoP3LVNYsper0sT/MiXkQXeChz19Rxda68WbhmI6XIGiuebKvuCciMjKxiIfs2sKDCU9OiGas2hkbmmXz9R6Mmb6/2OrA65wN0W/o3OFcDr8ut8QaUDRAXP0ha9T1o1iZZfc+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WUYoVZUl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WUYoVZUl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F38F1C433C7;
	Wed,  3 Apr 2024 17:57:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712167022;
	bh=Zy0Z4HwFkWw/RVYn+fh1FA/mYof9nQY0hhA/SVA0AS8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WUYoVZUl84QRCfPJnoNF0yK+opCTzbYc0JvsKoLQTDsSswVXVAmCvIOBNvKXT3KMN
	 fzefawMxsIN9+g6Br8kzZ95PQ8yky9zzDSUpGwyCutzFgwPXea415dG1KExROFAMS/
	 tgXi2wN3COyVhPtAuDOK0QBiKgG6N4zJa4e0q9zc=
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
Subject: [PATCH 6.6 06/11] Revert "workqueue: Make wq_adjust_max_active() round-robin pwqs while activating"
Date: Wed,  3 Apr 2024 19:55:55 +0200
Message-ID: <20240403175127.046849260@linuxfoundation.org>
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

This reverts commit 5f99fee6f2dea1228980c3e785ab1a2c69b4da3c which is
commit qc5404d4e6df6faba1007544b5f4e62c7c14416dd upstream.

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
 kernel/workqueue.c |   33 +++++++++++++--------------------
 1 file changed, 13 insertions(+), 20 deletions(-)

--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -4710,7 +4710,7 @@ static int init_rescuer(struct workqueue
  */
 static void wq_adjust_max_active(struct workqueue_struct *wq)
 {
-	bool activated;
+	struct pool_workqueue *pwq;
 
 	lockdep_assert_held(&wq->mutex);
 
@@ -4730,26 +4730,19 @@ static void wq_adjust_max_active(struct
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


