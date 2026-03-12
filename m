Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64B861F9F70;
	Thu, 12 Mar 2026 20:16:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773346610; cv=none; b=Sow79F4y9QuCNQ8JzBdzSmyNXmxmq+KzfEjh0iY5vgJdzBq9oaEv4GgLZBziNh5zZ3ii4pFO0LhxwH11CwFw/Kw7WB8LqFUUduL0WCKzbC9pEqluHnzkI9JcoCde+xvcFPUOf1GZB+PCLOdAZ4I6BC24poG0hg9x48yKnmrdH5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773346610; c=relaxed/simple;
	bh=AX3pyyaF4D43LSmWH0z7apXNNIXW+yw9+QEY/2CFLI4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H92s1jwGaeYy8lmMqIG6uiKHAvh5G0rIkSovttf71FXhtjCDIdCFBkIPBWcwS9LTqOwHb4A5oVdKVc1S2l54GfeszWyeGI3gzRdA6Xr8ks4oZARdDJX5JhsNz4jDeYbZ1y24NMwZc9S3KccfnMIUz1wayICUYRSd9UUJHtwIskY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zpvFkJQm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zpvFkJQm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFADFC4CEF7;
	Thu, 12 Mar 2026 20:16:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773346610;
	bh=AX3pyyaF4D43LSmWH0z7apXNNIXW+yw9+QEY/2CFLI4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zpvFkJQmjPa1qF7hl2wZS+RwgXuD+Oq2DlHSghO2YE66Ah0puD6opgiWU/5LG/aGM
	 6SGiT3K8mrwlgMBt4Yz936jSs5IFb/s0raBtqtKQ5cfOCH8rey6h72gJL2RrY7GMd9
	 hOq2Vnjg2qjzAiVOi2FVmofGhKSNy5BWIcHty8LM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Marco Crivellari <marco.crivellari@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 081/265] workqueue: Add system_percpu_wq and system_dfl_wq
Date: Thu, 12 Mar 2026 21:07:48 +0100
Message-ID: <20260312201021.146310007@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312201018.128816016@linuxfoundation.org>
References: <20260312201018.128816016@linuxfoundation.org>
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
Stable-dep-of: 870c2e7cd881 ("Input: synaptics_i2c - guard polling restart in resume")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/workqueue.h |  8 +++++---
 kernel/workqueue.c        | 13 +++++++++----
 2 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index 59c2695e12e76..23642bb1a103c 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -427,7 +427,7 @@ enum wq_consts {
 /*
  * System-wide workqueues which are always present.
  *
- * system_wq is the one used by schedule[_delayed]_work[_on]().
+ * system_percpu_wq is the one used by schedule[_delayed]_work[_on]().
  * Multi-CPU multi-threaded.  There are users which expect relatively
  * short queue flush time.  Don't queue works which can run for too
  * long.
@@ -438,7 +438,7 @@ enum wq_consts {
  * system_long_wq is similar to system_wq but may host long running
  * works.  Queue flushing might take relatively long.
  *
- * system_unbound_wq is unbound workqueue.  Workers are not bound to
+ * system_dfl_wq is unbound workqueue.  Workers are not bound to
  * any specific CPU, not concurrency managed, and all queued works are
  * executed immediately as long as max_active limit is not reached and
  * resources are available.
@@ -455,10 +455,12 @@ enum wq_consts {
  * system_bh[_highpri]_wq are convenience interface to softirq. BH work items
  * are executed in the queueing CPU's BH context in the queueing order.
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
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 9f7f7244bdc8e..3840d7ce9cda0 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -508,12 +508,16 @@ static struct kthread_worker *pwq_release_worker __ro_after_init;
 
 struct workqueue_struct *system_wq __ro_after_init;
 EXPORT_SYMBOL(system_wq);
+struct workqueue_struct *system_percpu_wq __ro_after_init;
+EXPORT_SYMBOL(system_percpu_wq);
 struct workqueue_struct *system_highpri_wq __ro_after_init;
 EXPORT_SYMBOL_GPL(system_highpri_wq);
 struct workqueue_struct *system_long_wq __ro_after_init;
 EXPORT_SYMBOL_GPL(system_long_wq);
 struct workqueue_struct *system_unbound_wq __ro_after_init;
 EXPORT_SYMBOL_GPL(system_unbound_wq);
+struct workqueue_struct *system_dfl_wq __ro_after_init;
+EXPORT_SYMBOL_GPL(system_dfl_wq);
 struct workqueue_struct *system_freezable_wq __ro_after_init;
 EXPORT_SYMBOL_GPL(system_freezable_wq);
 struct workqueue_struct *system_power_efficient_wq __ro_after_init;
@@ -7848,10 +7852,11 @@ void __init workqueue_init_early(void)
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
@@ -7862,8 +7867,8 @@ void __init workqueue_init_early(void)
 	system_bh_wq = alloc_workqueue("events_bh", WQ_BH, 0);
 	system_bh_highpri_wq = alloc_workqueue("events_bh_highpri",
 					       WQ_BH | WQ_HIGHPRI, 0);
-	BUG_ON(!system_wq || !system_highpri_wq || !system_long_wq ||
-	       !system_unbound_wq || !system_freezable_wq ||
+	BUG_ON(!system_wq || !system_percpu_wq|| !system_highpri_wq || !system_long_wq ||
+	       !system_unbound_wq || !system_freezable_wq || !system_dfl_wq ||
 	       !system_power_efficient_wq ||
 	       !system_freezable_power_efficient_wq ||
 	       !system_bh_wq || !system_bh_highpri_wq);
-- 
2.51.0



