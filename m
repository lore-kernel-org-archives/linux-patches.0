Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CBB643F8AE;
	Mon, 17 Aug 2026 14:59:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978755; cv=none; b=gEGPBWY1+ZA21aUnGp2A6X4svx293BZvcZAlEGukiIHLpCfqDH91xWtFiS93EtbEcgPH5Yd3G3R6JYob5OYUbSik6kkqAH0Z9R0KMRYi0sXfMR4FIuLEBc79C9++XfzqO1Dg3VWivvrbrLCqXiMTn3K/P2vxGhUvAJHE+xICKKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978755; c=relaxed/simple;
	bh=R6AN8Gi+kJRDisgFi0erQwEHa0htdmtq6K5lIPLcfb8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LxDwJr5VZMXhOxwcjk7bgte9CunMWbUsUBzDJ1RqXOMq7FUlWFTehXcW71fMXhK0/3m1SwErrwLmv6hptDFyC4FF+mgif4ynPNZVem9avJ0u8ZouwNLa4MyuhGxObGbhIRzLiwP8zpF8d4ET/XF2bRDlqqsPYrhS5DQk4hlv5eU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n8RXIOcG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n8RXIOcG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6A101F000E9;
	Mon, 17 Aug 2026 14:59:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786978754;
	bh=P9QXU0Kr7nxw9aiL4y8grMGAT3jo0IUxPy06zSSi/p8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n8RXIOcGnGXVtr3qoTiXKeNAbgoJcNOaWs7qczdi8IannlSO5eHUdbl/2VO9hoppQ
	 z+9HugJFzD88pQQ1bOAB4sid0gZ1eItSEYHya96MWqJXMrtWrf6livn+dq7HDGiMwW
	 32j/VOenO50/rvORYNEYImghf89A/iTKQ/8spDIU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko AI <sashiko-bot@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Matt Fleming <mfleming@cloudflare.com>,
	Suren Baghdasaryan <surenb@google.com>
Subject: [PATCH 6.6 146/156] sched/psi: Shut down rtpoll_timer in psi_cgroup_free()
Date: Mon, 17 Aug 2026 15:34:40 +0200
Message-ID: <20260817132540.442121760@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132534.666299318@linuxfoundation.org>
References: <20260817132534.666299318@linuxfoundation.org>
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

From: Tejun Heo <tj@kernel.org>

commit 5457025fa8ca3c0d2732109513de839e3e797190 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/psi.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/kernel/sched/psi.c
+++ b/kernel/sched/psi.c
@@ -1138,6 +1138,12 @@ void psi_cgroup_free(struct cgroup *cgro
 		return;
 
 	cancel_delayed_work_sync(&cgroup->psi->avgs_work);
+	/*
+	 * A psi_schedule_rtpoll_work() call racing the last trigger's
+	 * destruction may have re-armed the timer after psi_trigger_destroy()
+	 * deleted it. Spurious firing while the group is alive is harmless.
+	 */
+	timer_shutdown_sync(&cgroup->psi->rtpoll_timer);
 	free_percpu(cgroup->psi->pcpu);
 	/* All triggers must be removed by now */
 	WARN_ONCE(cgroup->psi->rtpoll_states, "psi: trigger leak\n");


