Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1AE2272E53;
	Thu, 20 Aug 2026 16:39:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787243967; cv=none; b=QPJD05pGyNxV/FeOKz9w16tA0mjTHh+aQWG0n4eOmOAczXrHe8NwB54Csvl5ilh9TscV2+JkC0WoaoC76vm6vutcOqu3CJ5/AJtZ2gvx5svIrMfi11CtTs2/WDUMmVrwUoDqrDz4fzEHAgxxiR+fav3n0M8Z9WaLvq1bmbQhc28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787243967; c=relaxed/simple;
	bh=iE5gufxgIv7mkn4B/K7rPcWS7nJzC8SJrXyGK5bFupk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PslycT08pbdX3AjEAsRkWidnqGSw5LMVhPco+gdTGKDOW/Jd4wV0Z6pWrvw74F+hvhqsTGp1d1ukgCa3CtBuER2iCExjex43H86hW2PdYfzFZyp5AvOO8r/pi3WgC/6/FtwKa2lkVC1kJtgLWrB27A7Csy6OLbkH0nbafMJNIWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EfI2NlY+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EfI2NlY+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ED621F000E9;
	Thu, 20 Aug 2026 16:39:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787243965;
	bh=Tp/7q0hjIcn1lwxZhth8h45VQkFsC16rXHAnYLXODIE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EfI2NlY+fSUmNM2sSmhviUvQmN5FxoC4Xjj3Wh91lNffLE2+xVdEH2cxBVeLOv82D
	 EWvuQA5VxadjBDMeu7SepBbdzGXi/E8pWKckjoCx2QbMjxLZIO+2Nskfl2zLctAd9S
	 31fsZ0Xf70R9wIINg0MXQGaxUDSKOVS6bNZWedvM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko AI <sashiko-bot@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Matt Fleming <mfleming@cloudflare.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 247/272] sched/psi: Shut down rtpoll_timer in psi_cgroup_free()
Date: Thu, 20 Aug 2026 16:57:11 +0200
Message-ID: <20260820145239.032589107@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145231.229664293@linuxfoundation.org>
References: <20260820145231.229664293@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

[ Upstream commit 5457025fa8ca3c0d2732109513de839e3e797190 ]

psi_schedule_rtpoll_work() is called locklessly from the scheduler hotpath
and can race psi_trigger_destroy() taking down the last rtpoll trigger under
rtpoll_trigger_lock:

  psi_schedule_rtpoll_work()        psi_trigger_destroy()

  rcu_read_lock();
  task = rcu_dereference(rtpoll_task);
                                    rcu_assign_pointer(rtpoll_task, NULL);
                                    timer_delete(&rtpoll_timer);
  mod_timer(&rtpoll_timer, ...);
  rcu_read_unlock();
                                    synchronize_rcu();
                                    kthread_stop(task_to_destroy);

The group can then be freed with the re-armed timer still pending, and
poll_timer_fn() runs on freed memory.

461daba06bdc ("psi: eliminate kthread_worker from psi trigger scheduling
mechanism") deleted the timer synchronously after the synchronize_rcu(),
which prevented this but raced trigger creation instead: the deletion could
cancel the timer that a new trigger set armed during the grace period and,
as creation also reinitialized the timer at the time, corrupt it.
8f91efd870ea ("psi: Fix race between psi_trigger_create/destroy") moved the
initialization into group_init() and the deletion into the locked section,
trading the creation races for the window above.

Neither placement in the destruction path works. A pending timer firing
while the group is alive is harmless though. poll_timer_fn() just wakes the
rtpoll waitqueue and doesn't re-arm itself. Bind the timer to the group's
lifetime instead and shut it down in psi_cgroup_free(). Nothing can arm it
by then. timer_shutdown_sync() because the timer is never armed again.

Fixes: 8f91efd870ea ("psi: Fix race between psi_trigger_create/destroy")
Cc: stable@vger.kernel.org # v5.10+
Reported-by: Sashiko AI <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/all/20260711000434.36C4A1F000E9@smtp.kernel.org/
Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Tested-by: Matt Fleming <mfleming@cloudflare.com>
Acked-by: Suren Baghdasaryan <surenb@google.com>
[ adapted `cgroup->psi->` pointer dereference to embedded `cgroup->psi.` and renamed `rtpoll_*` members back to `poll_*` ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/psi.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/kernel/sched/psi.c
+++ b/kernel/sched/psi.c
@@ -972,6 +972,12 @@ void psi_cgroup_free(struct cgroup *cgro
 		return;
 
 	cancel_delayed_work_sync(&cgroup->psi.avgs_work);
+	/*
+	 * A psi_schedule_poll_work() call racing the last trigger's
+	 * destruction may have re-armed the timer after psi_trigger_destroy()
+	 * deleted it. Spurious firing while the group is alive is harmless.
+	 */
+	timer_shutdown_sync(&cgroup->psi.poll_timer);
 	free_percpu(cgroup->psi.pcpu);
 	/* All triggers must be removed by now */
 	WARN_ONCE(cgroup->psi.poll_states, "psi: trigger leak\n");


