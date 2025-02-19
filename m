Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF2231F55FA;
	Wed, 19 Feb 2025 08:46:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954776; cv=none; b=eBFrzuXNZlzxS7yMwXRt2+nGM/ZhsfsnJJfkzDfhc7/jjXutUG71IvkWdalD8txVRSJKg+YAJuC5TT23hqoNhyxVV04sR25l1nBSU6biMOIAn0djcns80pv9syEbOv/zImy4gd4gjD/vWQxl1AoePX5c5c8wNS68eAzRrjMMBkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954776; c=relaxed/simple;
	bh=b2WhqSQ8kDrqPmc/JzYP4AllaVpWLfbXDcjDXdLW0mk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=i2SYcF3ZOWFWITN3k9aFEwnf788Np/vh5AjemoQJOMur167vz5sVs4RS/LzAwgaNuiwTo4CKHMZch3RQi/8/W4vA50wKKS7LHEJf/rF0JDojsvk64P5p4EMzQISRtA6kKkGBKK5jbbhp2MsC5p8AtCU+TjZmYy4sf9O6LNkO88U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dkvsvcbe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dkvsvcbe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B02AC4CEE6;
	Wed, 19 Feb 2025 08:46:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954776;
	bh=b2WhqSQ8kDrqPmc/JzYP4AllaVpWLfbXDcjDXdLW0mk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DkvsvcbelK1QDYuXCspONoqLggrf7WLZNIDaQGF/FMAqLcAY/3/GilpEq/+8iA9vN
	 4EeOcYsDpgSQl7vgbZv1Wq0ehGCkoVzrv/P9Xx67d1ikctUhSbE7FYAlSAtRi4i3G4
	 M3XrzeWJqZhn3tG7AFY4qRftW15AgKMsJxWnS6IM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	cheung wall <zzqq0103.hey@gmail.com>,
	Lai Jiangshan <jiangshan.ljs@antgroup.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 033/230] workqueue: Put the pwq after detaching the rescuer from the pool
Date: Wed, 19 Feb 2025 09:25:50 +0100
Message-ID: <20250219082603.005437908@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082601.683263930@linuxfoundation.org>
References: <20250219082601.683263930@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lai Jiangshan <jiangshan.ljs@antgroup.com>

[ Upstream commit e76946110137703c16423baf6ee177b751a34b7e ]

The commit 68f83057b913("workqueue: Reap workers via kthread_stop() and
remove detach_completion") adds code to reap the normal workers but
mistakenly does not handle the rescuer and also removes the code waiting
for the rescuer in put_unbound_pool(), which caused a use-after-free bug
reported by Cheung Wall.

To avoid the use-after-free bug, the pool’s reference must be held until
the detachment is complete. Therefore, move the code that puts the pwq
after detaching the rescuer from the pool.

Reported-by: cheung wall <zzqq0103.hey@gmail.com>
Cc: cheung wall <zzqq0103.hey@gmail.com>
Link: https://lore.kernel.org/lkml/CAKHoSAvP3iQW+GwmKzWjEAOoPvzeWeoMO0Gz7Pp3_4kxt-RMoA@mail.gmail.com/
Fixes: 68f83057b913("workqueue: Reap workers via kthread_stop() and remove detach_completion")
Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/workqueue.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index cee65cb431081..a9d64e08dffc7 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -3509,12 +3509,6 @@ static int rescuer_thread(void *__rescuer)
 			}
 		}
 
-		/*
-		 * Put the reference grabbed by send_mayday().  @pool won't
-		 * go away while we're still attached to it.
-		 */
-		put_pwq(pwq);
-
 		/*
 		 * Leave this pool. Notify regular workers; otherwise, we end up
 		 * with 0 concurrency and stalling the execution.
@@ -3525,6 +3519,12 @@ static int rescuer_thread(void *__rescuer)
 
 		worker_detach_from_pool(rescuer);
 
+		/*
+		 * Put the reference grabbed by send_mayday().  @pool might
+		 * go away any time after it.
+		 */
+		put_pwq_unlocked(pwq);
+
 		raw_spin_lock_irq(&wq_mayday_lock);
 	}
 
-- 
2.39.5



