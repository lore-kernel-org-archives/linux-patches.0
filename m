Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D2E33BE633;
	Wed, 30 Sep 2026 19:03:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795018; cv=none; b=fEKINCDLiE9tk7uvT6YEc2u+PSYj6ry+MV+YWsoKABIRw4jzkFEvYc5YNK/4nZX5PqZbvNMwtQ0V5PThATiaTdVygcoMGWgTYuSkYrNPKqYiTKzgSMqVB4+y29xLjKWKlj02uLQlIKVW0tpzFQzxUsaW6lu8hzK5+b10zK7PeF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795018; c=relaxed/simple;
	bh=IFkfTq+Rkv0DXBvgBspKEU4mll5aZ7wX3rsFzwt5uo4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SFnPX1l8nAB2xbFt5IY3MvlbSpwWZ3QMCSaT6M8FARv5h/Uxtns4PHLx8/z8jflFSBln2VdrfKBHchw8zmuvFtMXmsBSZac7LvvUKxzwoxGM/Kf15/wLK03VarkpBvL2YThElV98mLc2Lp4neYXl0mBuLsIpD9DRoKkEOJMoaLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yVei8pI9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yVei8pI9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E98061F000FF;
	Wed, 30 Sep 2026 19:03:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795017;
	bh=tcUA0lId3DOAszvjV7JIUJjhuFwCQSIz+qUDaJUAVpw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yVei8pI9m0dci/CTuHKSmT753dogIxB3nIQTfBqq1KCfA8SC54fdp77n/sQGcWj1F
	 c1Xq5Lwjlf5GQ2g+YSmr63eXF4zPlQcIPM/6xk7zQgRvPRn1y7BfYonZmdO/XUgSxa
	 Yh2RgOjB7abLddmCQh/l4ULHBL+sRvz0EMgDZptE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Marco Crivellari <marco.crivellari@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0412/1193] workqueue: replace use of system_wq with system_percpu_wq
Date: Wed, 30 Sep 2026 17:18:16 +0200
Message-ID: <20260930152443.353812635@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marco Crivellari <marco.crivellari@suse.com>

[ Upstream commit a2be943b46b4a7478ea8ddf9bb8e5251c59fceb7 ]

Currently if a user enqueue a work item using schedule_delayed_work() the
used wq is "system_wq" (per-cpu wq) while queue_delayed_work() use
WORK_CPU_UNBOUND (used when a cpu is not specified). The same applies to
schedule_work() that is using system_wq and queue_work(), that makes use
again of WORK_CPU_UNBOUND.

This lack of consistentcy cannot be addressed without refactoring the API.

system_wq is a per-CPU worqueue, yet nothing in its name tells about that
CPU affinity constraint, which is very often not required by users. Make
it clear by adding a system_percpu_wq.

queue_work() / queue_delayed_work() mod_delayed_work() will now use the
new per-cpu wq: whether the user still stick on the old name a warn will
be printed along a wq redirect to the new one.

This patch add the new system_percpu_wq except for mm, fs and net
subsystem, whom are handled in separated patches.

The old wq will be kept for a few release cylces.

Suggested-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Marco Crivellari <marco.crivellari@suse.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Stable-dep-of: 068c35b5d054 ("workqueue: reject watchdog thresholds that overflow jiffies")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/workqueue.h | 22 +++++++++++-----------
 kernel/workqueue.c        |  2 +-
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index c4df93bee09c7..0abbc3b67d29b 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -415,10 +415,10 @@ enum {
  * short queue flush time.  Don't queue works which can run for too
  * long.
  *
- * system_highpri_wq is similar to system_wq but for work items which
+ * system_highpri_wq is similar to system_percpu_wq but for work items which
  * require WQ_HIGHPRI.
  *
- * system_long_wq is similar to system_wq but may host long running
+ * system_long_wq is similar to system_percpu_wq but may host long running
  * works.  Queue flushing might take relatively long.
  *
  * system_dfl_wq is unbound workqueue.  Workers are not bound to
@@ -426,13 +426,13 @@ enum {
  * executed immediately as long as max_active limit is not reached and
  * resources are available.
  *
- * system_freezable_wq is equivalent to system_wq except that it's
+ * system_freezable_wq is equivalent to system_percpu_wq except that it's
  * freezable.
  *
  * *_power_efficient_wq are inclined towards saving power and converted
  * into WQ_UNBOUND variants if 'wq_power_efficient' is enabled; otherwise,
  * they are same as their non-power-efficient counterparts - e.g.
- * system_power_efficient_wq is identical to system_wq if
+ * system_power_efficient_wq is identical to system_percpu_wq if
  * 'wq_power_efficient' is disabled.  See WQ_POWER_EFFICIENT for more info.
  */
 extern struct workqueue_struct *system_wq; /* use system_percpu_wq, this will be removed */
@@ -603,7 +603,7 @@ static inline bool mod_delayed_work(struct workqueue_struct *wq,
  */
 static inline bool schedule_work_on(int cpu, struct work_struct *work)
 {
-	return queue_work_on(cpu, system_wq, work);
+	return queue_work_on(cpu, system_percpu_wq, work);
 }
 
 /**
@@ -622,7 +622,7 @@ static inline bool schedule_work_on(int cpu, struct work_struct *work)
  */
 static inline bool schedule_work(struct work_struct *work)
 {
-	return queue_work(system_wq, work);
+	return queue_work(system_percpu_wq, work);
 }
 
 /*
@@ -639,15 +639,15 @@ extern void __warn_flushing_systemwide_wq(void)
 #define flush_scheduled_work()						\
 ({									\
 	__warn_flushing_systemwide_wq();				\
-	__flush_workqueue(system_wq);					\
+	__flush_workqueue(system_percpu_wq);					\
 })
 
 #define flush_workqueue(wq)						\
 ({									\
 	struct workqueue_struct *_wq = (wq);				\
 									\
-	if ((__builtin_constant_p(_wq == system_wq) &&			\
-	     _wq == system_wq) ||					\
+	if ((__builtin_constant_p(_wq == system_percpu_wq) &&			\
+	     _wq == system_percpu_wq) ||					\
 	    (__builtin_constant_p(_wq == system_highpri_wq) &&		\
 	     _wq == system_highpri_wq) ||				\
 	    (__builtin_constant_p(_wq == system_long_wq) &&		\
@@ -676,7 +676,7 @@ extern void __warn_flushing_systemwide_wq(void)
 static inline bool schedule_delayed_work_on(int cpu, struct delayed_work *dwork,
 					    unsigned long delay)
 {
-	return queue_delayed_work_on(cpu, system_wq, dwork, delay);
+	return queue_delayed_work_on(cpu, system_percpu_wq, dwork, delay);
 }
 
 /**
@@ -690,7 +690,7 @@ static inline bool schedule_delayed_work_on(int cpu, struct delayed_work *dwork,
 static inline bool schedule_delayed_work(struct delayed_work *dwork,
 					 unsigned long delay)
 {
-	return queue_delayed_work(system_wq, dwork, delay);
+	return queue_delayed_work(system_percpu_wq, dwork, delay);
 }
 
 #ifndef CONFIG_SMP
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index fd215673ddf8a..bb12f74fa190a 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -6574,7 +6574,7 @@ static int wq_watchdog_param_set_thresh(const char *val,
 	if (ret)
 		return ret;
 
-	if (system_wq)
+	if (system_percpu_wq)
 		wq_watchdog_set_thresh(thresh);
 	else
 		wq_watchdog_thresh = thresh;
-- 
2.53.0



