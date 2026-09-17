Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61EE53B634E;
	Thu, 17 Sep 2026 18:13:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668813; cv=none; b=U3PPSrYuXwPvZGwW6Zggho2kK7jm/cfbhy0Lx+Ivlur5G+iK+u5SGIE7S/TZ+7ADzJPWXX9mDkB7Z4pxMzg6DLTd8H0jD3bJ3cg89dGLzv0nZMgxmFzHHGgrlHG6hnF4IPEugOQTpQhUJm9kBcxFGr5hzF8k3nFZ1lkhUvSjaZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668813; c=relaxed/simple;
	bh=m8/jpiwPDJ4J+Aw5nGyg06qyrhErG0qWzobGc2fFt1A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qAnzuQJQ0r3lvtXVQ4kjgMrLgn5TkzI/HvY8XOX3pVIOZXeClZzH33TJIySsTkTIGwhbomn2BM2pSIt6GNjhtbqta8lrK1UgQlSBOqV6RyXLOjr9LTiOxjHHK5vmTI2OLWZAs+Z97yok3Vmps0Sh01b+8U1JLQXJBEYOo4eYzok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AxVVvddh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AxVVvddh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE8FE1F000FF;
	Thu, 17 Sep 2026 18:13:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668812;
	bh=GGV+ZB70jQOdJNcPMLuR8cf+ux47fq0eEIAjp9nhVHE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AxVVvddhH9k6kw6GpV0ZJMkDPhFqEoXzpGQ2mM0Ics+Sel9jtsRsOuM44Z56+3cCQ
	 ZCFvF7Ew8QRAi7xaqgUxGurSbP9Fa7k6jvL9VCYMEQrXjBy+IlII9ZjwTs8jXgq3Au
	 de710QZOE38mEBgjug9dGpIT7W/qqLOq48jQX2to=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Marco Crivellari <marco.crivellari@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0548/1102] workqueue: replace use of system_wq with system_percpu_wq
Date: Thu, 17 Sep 2026 16:08:11 +0100
Message-ID: <20260917151553.591428219@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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
index c75327e31e6a0..07ec727d727c0 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -433,10 +433,10 @@ enum wq_consts {
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
@@ -444,13 +444,13 @@ enum wq_consts {
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
  *
  * system_bh[_highpri]_wq are convenience interface to softirq. BH work items
@@ -704,7 +704,7 @@ static inline bool mod_delayed_work(struct workqueue_struct *wq,
  */
 static inline bool schedule_work_on(int cpu, struct work_struct *work)
 {
-	return queue_work_on(cpu, system_wq, work);
+	return queue_work_on(cpu, system_percpu_wq, work);
 }
 
 /**
@@ -723,7 +723,7 @@ static inline bool schedule_work_on(int cpu, struct work_struct *work)
  */
 static inline bool schedule_work(struct work_struct *work)
 {
-	return queue_work(system_wq, work);
+	return queue_work(system_percpu_wq, work);
 }
 
 /**
@@ -766,15 +766,15 @@ extern void __warn_flushing_systemwide_wq(void)
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
@@ -803,7 +803,7 @@ extern void __warn_flushing_systemwide_wq(void)
 static inline bool schedule_delayed_work_on(int cpu, struct delayed_work *dwork,
 					    unsigned long delay)
 {
-	return queue_delayed_work_on(cpu, system_wq, dwork, delay);
+	return queue_delayed_work_on(cpu, system_percpu_wq, dwork, delay);
 }
 
 /**
@@ -817,7 +817,7 @@ static inline bool schedule_delayed_work_on(int cpu, struct delayed_work *dwork,
 static inline bool schedule_delayed_work(struct delayed_work *dwork,
 					 unsigned long delay)
 {
-	return queue_delayed_work(system_wq, dwork, delay);
+	return queue_delayed_work(system_percpu_wq, dwork, delay);
 }
 
 #ifndef CONFIG_SMP
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index a91215dc0db41..16888739ed834 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -7705,7 +7705,7 @@ static int wq_watchdog_param_set_thresh(const char *val,
 	if (ret)
 		return ret;
 
-	if (system_wq)
+	if (system_percpu_wq)
 		wq_watchdog_set_thresh(thresh);
 	else
 		wq_watchdog_thresh = thresh;
-- 
2.53.0



