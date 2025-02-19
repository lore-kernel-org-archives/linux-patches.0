Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F4EF1DE2B8;
	Wed, 19 Feb 2025 08:33:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954020; cv=none; b=EdH5z2uYgMOi2/hPAgxqG6Z9HYtz04SNuXQygLYOmpahxP70hVx45LTIoodAYaBN8+9BrVvbV71tyLzD2BUGsWE98rkanBkSPEDRQj0tjcCZ4PBRIpJji6kgHSvfM/LeNMJHzgH6aHObTCPQBz0zPviIY0l2foVx3x2xI7wMHrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954020; c=relaxed/simple;
	bh=vTtRW/kU6hVZBvQouWydAhbiOR+0grMA4cibCMGxPN4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cw7uwRb7az2KdBZEfTPVD53r8dMK1FU1IHJqWaEhl+wGFNvvX7iLU03udKpMTUft8LkV4/6vKYorSsYyvBRL/mjAKNHwXCDSJ64CtB+xrT8yRTyl8bElaffyqJuMc2mwBfFqaenKXyA6lNxxtptgoqhpvJy7OtTW2jL+QOMWehg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vtmmBLJD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vtmmBLJD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A998C4CED1;
	Wed, 19 Feb 2025 08:33:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954019;
	bh=vTtRW/kU6hVZBvQouWydAhbiOR+0grMA4cibCMGxPN4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vtmmBLJDpGSM/10BdZjarrjFsZMfopBZgG+0MhI+xdlVdiHg7VoV6vs3h1AxsdAwu
	 kL2WEa/P9NGUfZP8Je9QYKwDLnKiZI5Z6DeQDjpVwI+dU/pB1Dr/+/SgqUmXPSz2LG
	 nL42uejE5eM2VJ2ytgK4mj9EIJhfKcPDW+cnGrWU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	cheung wall <zzqq0103.hey@gmail.com>,
	Lai Jiangshan <jiangshan.ljs@antgroup.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 038/274] workqueue: Put the pwq after detaching the rescuer from the pool
Date: Wed, 19 Feb 2025 09:24:52 +0100
Message-ID: <20250219082611.017994535@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index 9362484a653c4..218f8c1388086 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -3516,12 +3516,6 @@ static int rescuer_thread(void *__rescuer)
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
@@ -3532,6 +3526,12 @@ static int rescuer_thread(void *__rescuer)
 
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



