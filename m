Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0BEB1C7013;
	Wed, 19 Feb 2025 08:56:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955378; cv=none; b=rF6ZZTt3zOawL2YJtiai7UprUOr1nX9LbmrFP5Fv0krB0cX8GwyZoA4sYq+m6WsEqmQYIkIrv2AZ4ORgfuWXS1Rr1+Dlk1BTf60McMo/sIjbpTFDCn1TyeL6r8DWW/xU5osibNJ/GgMR2AsP7S4C2avJw/b9DBqIgm1dLQ3qSxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955378; c=relaxed/simple;
	bh=FUQ9m8cgVHc0/VUW7twUcudtRyqb3ITJzPpQiqRGHM0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UOCTXx+nICGyAGQvExi4v+NVROIRRzy8+OdF0aKXEwJ3eYaP4/5fnRG79YvoncunLsF7Mn0lF3bkA7807L4or8bfYh6OGOE4Y8qNgOEh+QeKE29SaNKGbssv3zgsyG2CCZyVO+xMrtx8n6idVfDGBLjrLAFTcFXKfty2Ug7IpOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bO6meWGL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bO6meWGL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5054DC4CED1;
	Wed, 19 Feb 2025 08:56:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955378;
	bh=FUQ9m8cgVHc0/VUW7twUcudtRyqb3ITJzPpQiqRGHM0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bO6meWGLKfVOyXAs8kMd7FpkOfRFt8pVqwHtUwI+ram3y2nfWNzFcjHjc4kn/Qcs9
	 sn0OIxJnUnriNQk9Ua2av3FACHioTbjjZrbiv2saLyOK5uFWGVx8gUWgHzv2zxo7Fp
	 qhBvsR5f0DcLbsrMpJ9Fn5jQIrh2ZkjjKnAPSt/0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Juri Lelli <juri.lelli@redhat.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Phil Auld <pauld@redhat.com>,
	Waiman Long <longman@redhat.com>
Subject: [PATCH 6.12 217/230] sched/deadline: Restore dl_server bandwidth on non-destructive root domain changes
Date: Wed, 19 Feb 2025 09:28:54 +0100
Message-ID: <20250219082610.182002095@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Juri Lelli <juri.lelli@redhat.com>

commit 41d4200b7103152468552ee50998cda914102049 upstream.

When root domain non-destructive changes (e.g., only modifying one of
the existing root domains while the rest is not touched) happen we still
need to clear DEADLINE bandwidth accounting so that it's then properly
restored, taking into account DEADLINE tasks associated to each cpuset
(associated to each root domain). After the introduction of dl_servers,
we fail to restore such servers contribution after non-destructive
changes (as they are only considered on destructive changes when
runqueues are attached to the new domains).

Fix this by making sure we iterate over the dl_servers attached to
domains that have not been destroyed and add their bandwidth
contribution back correctly.

Signed-off-by: Juri Lelli <juri.lelli@redhat.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Phil Auld <pauld@redhat.com>
Tested-by: Waiman Long <longman@redhat.com>
Link: https://lore.kernel.org/r/20241114142810.794657-2-juri.lelli@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/deadline.c |   17 ++++++++++++++---
 kernel/sched/topology.c |    8 +++++---
 2 files changed, 19 insertions(+), 6 deletions(-)

--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -2975,11 +2975,22 @@ void dl_add_task_root_domain(struct task
 
 void dl_clear_root_domain(struct root_domain *rd)
 {
-	unsigned long flags;
+	int i;
 
-	raw_spin_lock_irqsave(&rd->dl_bw.lock, flags);
+	guard(raw_spinlock_irqsave)(&rd->dl_bw.lock);
 	rd->dl_bw.total_bw = 0;
-	raw_spin_unlock_irqrestore(&rd->dl_bw.lock, flags);
+
+	/*
+	 * dl_server bandwidth is only restored when CPUs are attached to root
+	 * domains (after domains are created or CPUs moved back to the
+	 * default root doamin).
+	 */
+	for_each_cpu(i, rd->span) {
+		struct sched_dl_entity *dl_se = &cpu_rq(i)->fair_server;
+
+		if (dl_server(dl_se) && cpu_active(i))
+			rd->dl_bw.total_bw += dl_se->dl_bw;
+	}
 }
 
 #endif /* CONFIG_SMP */
--- a/kernel/sched/topology.c
+++ b/kernel/sched/topology.c
@@ -2721,9 +2721,11 @@ void partition_sched_domains_locked(int
 
 				/*
 				 * This domain won't be destroyed and as such
-				 * its dl_bw->total_bw needs to be cleared.  It
-				 * will be recomputed in function
-				 * update_tasks_root_domain().
+				 * its dl_bw->total_bw needs to be cleared.
+				 * Tasks contribution will be then recomputed
+				 * in function dl_update_tasks_root_domain(),
+				 * dl_servers contribution in function
+				 * dl_restore_server_root_domain().
 				 */
 				rd = cpu_rq(cpumask_any(doms_cur[i]))->rd;
 				dl_clear_root_domain(rd);


