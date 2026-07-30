Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D34844A72C;
	Thu, 30 Jul 2026 16:17:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785428246; cv=none; b=TG2Cx76uL0mR5fjj8WhyifUTKxMQoIrAsNutJfkBQKmI27JJTPEZK4EK/L/q+XSa2R9ucxM4iG7ksUrTO62clYAM8Zzj7Hteyicoqp7I74pcYmY86qtisaoRmACVWCXTqhG9/zkmecke7b/nXXAoSaMfQqiszARyV7oAYqQoVhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785428246; c=relaxed/simple;
	bh=nnC+cXMPcvxIlD1hHCnkjFNeTyfaXDR+y/oTvc6Hog4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jd1qahMKhvo0TVKGcWFyfe4N5CaYq2an7ljk6wLkCxag5bVGX2FJxywc3P8flhBVBQ/bECpVrty+Yg4ncMOdR7P16WeJXlqNkl1YuDNA/pz6vILzpcn+UGq501w97L/TGLNcKIla/i7ENAs0vgwuDyEUbqVxwx6uPac/DTLa3uY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WclF0JNt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WclF0JNt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45E451F000E9;
	Thu, 30 Jul 2026 16:17:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785428244;
	bh=QxQjfEJAZBauYLftoYUdzYCkILTBTVeH/6Vt5W1d1jc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WclF0JNtRDLl66fX3DWTiu3y9A1qIM2vPHcRwfMy/TNXJU7/zIc/+lUkMaOFRbjQg
	 Xxj7fIuAJWxjzQMji2mfW4IajdOM6eA17gkyLQSnXE56NG6CYpm0xAOb1HYSki1cP1
	 kXv6D6XX7QXblfFem4dky1Wg37fvmKQaruwjXmN8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Marco Crivellari <marco.crivellari@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 453/484] workqueue: Add system_percpu_wq and system_dfl_wq
Date: Thu, 30 Jul 2026 16:15:50 +0200
Message-ID: <20260730141433.322291435@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

[ Upstream commit 128ea9f6ccfb6960293ae4212f4f97165e42222d ]

Currently, if a user enqueue a work item using schedule_delayed_work() the
used wq is "system_wq" (per-cpu wq) while queue_delayed_work() use
WORK_CPU_UNBOUND (used when a cpu is not specified). The same applies to
schedule_work() that is using system_wq and queue_work(), that makes use
again of WORK_CPU_UNBOUND.

This lack of consistentcy cannot be addressed without refactoring the API.

system_wq is a per-CPU worqueue, yet nothing in its name tells about that
CPU affinity constraint, which is very often not required by users. Make it
clear by adding a system_percpu_wq.

system_unbound_wq should be the default workqueue so as not to enforce
locality constraints for random work whenever it's not required.

Adding system_dfl_wq to encourage its use when unbound work should be used.

Suggested-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Marco Crivellari <marco.crivellari@suse.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Stable-dep-of: 50fd6dd755c6 ("tracing/user_events: Fix use-after-free in user_event_mm_dup()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/workqueue.h |    8 +++++---
 kernel/workqueue.c        |   14 ++++++++++----
 2 files changed, 15 insertions(+), 7 deletions(-)

--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -410,7 +410,7 @@ enum {
 /*
  * System-wide workqueues which are always present.
  *
- * system_wq is the one used by schedule[_delayed]_work[_on]().
+ * system_percpu_wq is the one used by schedule[_delayed]_work[_on]().
  * Multi-CPU multi-threaded.  There are users which expect relatively
  * short queue flush time.  Don't queue works which can run for too
  * long.
@@ -421,7 +421,7 @@ enum {
  * system_long_wq is similar to system_wq but may host long running
  * works.  Queue flushing might take relatively long.
  *
- * system_unbound_wq is unbound workqueue.  Workers are not bound to
+ * system_dfl_wq is unbound workqueue.  Workers are not bound to
  * any specific CPU, not concurrency managed, and all queued works are
  * executed immediately as long as max_active limit is not reached and
  * resources are available.
@@ -435,10 +435,12 @@ enum {
  * system_power_efficient_wq is identical to system_wq if
  * 'wq_power_efficient' is disabled.  See WQ_POWER_EFFICIENT for more info.
  */
-extern struct workqueue_struct *system_wq;
+extern struct workqueue_struct *system_wq; /* use system_percpu_wq, this will be removed */
+extern struct workqueue_struct *system_percpu_wq;
 extern struct workqueue_struct *system_highpri_wq;
 extern struct workqueue_struct *system_long_wq;
 extern struct workqueue_struct *system_unbound_wq;
+extern struct workqueue_struct *system_dfl_wq;
 extern struct workqueue_struct *system_freezable_wq;
 extern struct workqueue_struct *system_power_efficient_wq;
 extern struct workqueue_struct *system_freezable_power_efficient_wq;
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -425,12 +425,16 @@ static struct kthread_worker *pwq_releas
 
 struct workqueue_struct *system_wq __read_mostly;
 EXPORT_SYMBOL(system_wq);
+struct workqueue_struct *system_percpu_wq __read_mostly;
+EXPORT_SYMBOL(system_percpu_wq);
 struct workqueue_struct *system_highpri_wq __read_mostly;
 EXPORT_SYMBOL_GPL(system_highpri_wq);
 struct workqueue_struct *system_long_wq __read_mostly;
 EXPORT_SYMBOL_GPL(system_long_wq);
 struct workqueue_struct *system_unbound_wq __read_mostly;
 EXPORT_SYMBOL_GPL(system_unbound_wq);
+struct workqueue_struct *system_dfl_wq __read_mostly;
+EXPORT_SYMBOL_GPL(system_dfl_wq);
 struct workqueue_struct *system_freezable_wq __read_mostly;
 EXPORT_SYMBOL_GPL(system_freezable_wq);
 struct workqueue_struct *system_power_efficient_wq __read_mostly;
@@ -6696,10 +6700,11 @@ void __init workqueue_init_early(void)
 	}
 
 	system_wq = alloc_workqueue("events", 0, 0);
+	system_percpu_wq = alloc_workqueue("events", 0, 0);
 	system_highpri_wq = alloc_workqueue("events_highpri", WQ_HIGHPRI, 0);
 	system_long_wq = alloc_workqueue("events_long", 0, 0);
-	system_unbound_wq = alloc_workqueue("events_unbound", WQ_UNBOUND,
-					    WQ_MAX_ACTIVE);
+	system_unbound_wq = alloc_workqueue("events_unbound", WQ_UNBOUND, WQ_MAX_ACTIVE);
+	system_dfl_wq = alloc_workqueue("events_unbound", WQ_UNBOUND, WQ_MAX_ACTIVE);
 	system_freezable_wq = alloc_workqueue("events_freezable",
 					      WQ_FREEZABLE, 0);
 	system_power_efficient_wq = alloc_workqueue("events_power_efficient",
@@ -6707,8 +6712,9 @@ void __init workqueue_init_early(void)
 	system_freezable_power_efficient_wq = alloc_workqueue("events_freezable_power_efficient",
 					      WQ_FREEZABLE | WQ_POWER_EFFICIENT,
 					      0);
-	BUG_ON(!system_wq || !system_highpri_wq || !system_long_wq ||
-	       !system_unbound_wq || !system_freezable_wq ||
+	BUG_ON(!system_wq || !system_percpu_wq || !system_highpri_wq ||
+	       !system_long_wq || !system_unbound_wq || !system_dfl_wq ||
+	       !system_freezable_wq ||
 	       !system_power_efficient_wq ||
 	       !system_freezable_power_efficient_wq);
 }


