Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96A5D29D27A;
	Mon, 13 Apr 2026 16:11:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776096707; cv=none; b=pdw64vsO0dydp9eeLgAIUC8Cn54ETa5HyUof3wAZJ3tr9R4PaDpurdfpaEZh7gN7hAN5gJjj9/RpG9MtfO3/Ji/zbVD4I/zxk+HdSfL24hf+GfHDhMAIsiNwQxDPaMDMVyYPxthLMH/ZwjUNWducRbiIvIDZJFpeg+yAhFdjFSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776096707; c=relaxed/simple;
	bh=u2/xWPP8NjKY8T+JaMdfPo+DP2Fio/EQnUIn7kaAxP8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=X3RKuLFDx5btbnDa3tSFDjqu4xBvE4q5yyHQ4j3PYixsh69SkX/wAdm0NUdHv02yjMKZhNAL3dDGyq/shdBe7sers0EboTT1rtii94bdWbbxNCUOezxJXUsSNZJjl/BF4mJBDAfIlBjh5YO8XU55MFepCI7DAQzOMKB0yj7bvDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wapt5vL5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wapt5vL5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C6A9C2BCB0;
	Mon, 13 Apr 2026 16:11:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776096707;
	bh=u2/xWPP8NjKY8T+JaMdfPo+DP2Fio/EQnUIn7kaAxP8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wapt5vL5nykdj+5V4X/aizLy4a5KKn6skAoR4ZxrkCpk9c8JM4TCBvAwoMTLIy00M
	 q29vi1J12YeDzUwaKcmOU8yuFGvwIkV4Us0xt4S7T7b+5kcWxMruYFV6Pm2Gr5hHkX
	 0/8KetrJieU8adF/+/UCUV1h1FrvzNVsf3LyLHzU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carlos Santa <carlos.santa@intel.com>,
	Ryan Neph <ryanneph@google.com>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Waiman Long <longman@redhat.com>,
	linux-kernel@vger.kernel.org,
	Matthew Brost <matthew.brost@intel.com>,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH 6.12 32/70] workqueue: Add pool_workqueue to pending_pwqs list when unplugging multiple inactive works
Date: Mon, 13 Apr 2026 18:00:27 +0200
Message-ID: <20260413155729.385647125@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155728.181580293@linuxfoundation.org>
References: <20260413155728.181580293@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Matthew Brost <matthew.brost@intel.com>

commit 703ccb63ae9f7444d6ff876d024e17f628103c69 upstream.

In unplug_oldest_pwq(), the first inactive work item on the
pool_workqueue is activated correctly. However, if multiple inactive
works exist on the same pool_workqueue, subsequent works fail to
activate because wq_node_nr_active.pending_pwqs is empty — the list
insertion is skipped when the pool_workqueue is plugged.

Fix this by checking for additional inactive works in
unplug_oldest_pwq() and updating wq_node_nr_active.pending_pwqs
accordingly.

Fixes: 4c065dbce1e8 ("workqueue: Enable unbound cpumask update on ordered workqueues")
Cc: stable@vger.kernel.org
Cc: Carlos Santa <carlos.santa@intel.com>
Cc: Ryan Neph <ryanneph@google.com>
Cc: Lai Jiangshan <jiangshanlai@gmail.com>
Cc: Waiman Long <longman@redhat.com>
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Waiman Long <longman@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/workqueue.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1856,8 +1856,20 @@ static void unplug_oldest_pwq(struct wor
 	raw_spin_lock_irq(&pwq->pool->lock);
 	if (pwq->plugged) {
 		pwq->plugged = false;
-		if (pwq_activate_first_inactive(pwq, true))
+		if (pwq_activate_first_inactive(pwq, true)) {
+			/*
+			 * While plugged, queueing skips activation which
+			 * includes bumping the nr_active count and adding the
+			 * pwq to nna->pending_pwqs if the count can't be
+			 * obtained. We need to restore both for the pwq being
+			 * unplugged. The first call activates the first
+			 * inactive work item and the second, if there are more
+			 * inactive, puts the pwq on pending_pwqs.
+			 */
+			pwq_activate_first_inactive(pwq, false);
+
 			kick_pool(pwq->pool);
+		}
 	}
 	raw_spin_unlock_irq(&pwq->pool->lock);
 }


