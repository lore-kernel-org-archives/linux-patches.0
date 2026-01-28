Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 077192F0C70;
	Wed, 28 Jan 2026 15:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615204; cv=none; b=S0pqwGmjYzHJBwTavfLuav1c6amP3j6XzIiCJIz+9puT9j0KLu1h9JyPTijmQpKji9KL4FQcG8gAn7/eXEteO8cKFPmfVE6qGuK1k1v/sKpEA4UM3f/1TYhW8YORyvDEx6edzd8lHHtxz7XYVnDwLEK2wbeTGMBRPyC6dTaJRlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615204; c=relaxed/simple;
	bh=uR6WeBy2faHqni3tuCJ6VsPb9K/xcXm4ztrVwRBnjbw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RYKHmu75ZHsnz6fgyK3eWMIL7XaaZCdGLfDs35dKhHnMfjUdIEHotjDDAx3qMJrZCQcBM0HA6U5bSvfqndrhH/eBydHZEeFoslCu/go9dS/qympzpCCGjy0lRMyMdG1jg9ta8kxHJ4+gUYTKQu/VbkQFDhWrBchdjg7jZ8sJXqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t69NmAYE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t69NmAYE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EEFEC4CEF1;
	Wed, 28 Jan 2026 15:46:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615203;
	bh=uR6WeBy2faHqni3tuCJ6VsPb9K/xcXm4ztrVwRBnjbw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t69NmAYEl1xF/V6PZHOZbvNA0UGKZ2O58Vf78S1cwGx5c7s3OEUPmMzz1ksQIvRQi
	 pMIATkJUTLPisssR4AxqLs2dUi9TED6VfHsQOCf1sFUIf5vE+EKMbyxYqLC1yygYFN
	 mpGmtNQuIsyJPjJ5zu/Rc/qLpHDyY8grTB9jV0no=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuel Wu <wusamuel@google.com>,
	Alex Hoh <Alex.Hoh@mediatek.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 082/169] sched/fair: Fix pelt clock sync when entering idle
Date: Wed, 28 Jan 2026 16:22:45 +0100
Message-ID: <20260128145336.956642527@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145334.006287341@linuxfoundation.org>
References: <20260128145334.006287341@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vincent Guittot <vincent.guittot@linaro.org>

[ Upstream commit 98c88dc8a1ace642d9021b103b28cba7b51e3abc ]

Samuel and Alex reported regressions of the util_avg of RT rq with
commit 17e3e88ed0b6 ("sched/fair: Fix pelt lost idle time detection").
It happens that fair is updating and syncing the pelt clock with task one
when pick_next_task_fair() fails to pick a task but before the prev
scheduling class got a chance to update its pelt signals.

Move update_idle_rq_clock_pelt() in set_next_task_idle() which is called
after prev class has been called.

Fixes: 17e3e88ed0b6 ("sched/fair: Fix pelt lost idle time detection")
Closes: https://lore.kernel.org/all/CAG2KctpO6VKS6GN4QWDji0t92_gNBJ7HjjXrE+6H+RwRXt=iLg@mail.gmail.com/
Closes: https://lore.kernel.org/all/8cf19bf0e0054dcfed70e9935029201694f1bb5a.camel@mediatek.com/
Reported-by: Samuel Wu <wusamuel@google.com>
Reported-by: Alex Hoh <Alex.Hoh@mediatek.com>
Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Tested-by: Samuel Wu <wusamuel@google.com>
Tested-by: Alex Hoh <Alex.Hoh@mediatek.com>
Link: https://patch.msgid.link/20260121163317.505635-1-vincent.guittot@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c | 6 ------
 kernel/sched/idle.c | 6 ++++++
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 1436d6bb86ec4..6efb1dfcd943a 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -9033,12 +9033,6 @@ pick_next_task_fair(struct rq *rq, struct task_struct *prev, struct rq_flags *rf
 			goto again;
 	}
 
-	/*
-	 * rq is about to be idle, check if we need to update the
-	 * lost_idle_time of clock_pelt
-	 */
-	update_idle_rq_clock_pelt(rq);
-
 	return NULL;
 }
 
diff --git a/kernel/sched/idle.c b/kernel/sched/idle.c
index 53bb9193c537a..624ef809f6715 100644
--- a/kernel/sched/idle.c
+++ b/kernel/sched/idle.c
@@ -462,6 +462,12 @@ static void set_next_task_idle(struct rq *rq, struct task_struct *next, bool fir
 	scx_update_idle(rq, true, true);
 	schedstat_inc(rq->sched_goidle);
 	next->se.exec_start = rq_clock_task(rq);
+
+	/*
+	 * rq is about to be idle, check if we need to update the
+	 * lost_idle_time of clock_pelt
+	 */
+	update_idle_rq_clock_pelt(rq);
 }
 
 struct task_struct *pick_task_idle(struct rq *rq)
-- 
2.51.0



