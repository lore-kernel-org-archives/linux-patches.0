Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F8921DDDB;
	Thu, 13 Jun 2024 12:45:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282752; cv=none; b=acPIBf/nm2qPNpnH4qC1UjM6lbpaQIneTX7CoI7+ZTP0p/HLW5WHibyW7NyzBMEmf5PmF87wiUxp1kOkPTNQ9gwQb+h1VJwm3M9QssgVIuvZZRfz4bdWh09R3/NePHQ1QcY85xUhso2AJTLPqsCE9ZVgbElR4aGEqY8Bhgmg2sg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282752; c=relaxed/simple;
	bh=EVICGdvthQ/neTQ8nUvq/YuIxxxgqOgM1bgltMTa3NU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WyMz8EQGs+IRuA3mibKWx8trUWUA2H8BfTOFsuFxTtNUFZeut71/9clTqpIgUc/VlHHWjQIABxgVXxlE5pSqUsbM4JUK59dK8CnNr2kNzEG5crqUUl+2QL1SEIYRRU3QI+IUsBdCmr5MZjxzXm9KEX7fHAziSfF8pENEOxCikas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UjUw57tj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UjUw57tj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B81F8C2BBFC;
	Thu, 13 Jun 2024 12:45:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282752;
	bh=EVICGdvthQ/neTQ8nUvq/YuIxxxgqOgM1bgltMTa3NU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UjUw57tjQkErnVW6dSW6MfMZRqt5EjRAZvzJ7VQy3U5jR1X3uhrBM+Wdbn1zalkvj
	 Evo4FeMYRzTGWmIVCedews/rTt08QUDabxO+tRCVqO7AoGOMOr44hwmzv6xMksuj5P
	 kxKcNRdVc/bKI8DJ1LZqlNWzsaes31+hznBZ2lvw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jon Hunter <jonathanh@nvidia.com>,
	NeilBrown <neilb@suse.de>
Subject: [PATCH 5.15 352/402] sunrpc: exclude from freezer when waiting for requests:
Date: Thu, 13 Jun 2024 13:35:09 +0200
Message-ID: <20240613113315.866006865@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: NeilBrown <neilb@suse.de>

Prior to v6.1, the freezer will only wake a kernel thread from an
uninterruptible sleep.  Since we changed svc_get_next_xprt() to use and
IDLE sleep the freezer cannot wake it.  We need to tell the freezer to
ignore it instead.

To make this work with only upstream commits, 5.15.y would need
commit f5d39b020809 ("freezer,sched: Rewrite core freezer logic")
which allows non-interruptible sleeps to be woken by the freezer.

Fixes: 9b8a8e5e8129 ("nfsd: don't allow nfsd threads to be signalled.")
Tested-by: Jon Hunter <jonathanh@nvidia.com>
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/callback.c     |    2 +-
 fs/nfsd/nfs4proc.c    |    3 ++-
 net/sunrpc/svc_xprt.c |    4 ++--
 3 files changed, 5 insertions(+), 4 deletions(-)

--- a/fs/nfs/callback.c
+++ b/fs/nfs/callback.c
@@ -124,7 +124,7 @@ nfs41_callback_svc(void *vrqstp)
 		} else {
 			spin_unlock_bh(&serv->sv_cb_lock);
 			if (!kthread_should_stop())
-				schedule();
+				freezable_schedule();
 			finish_wait(&serv->sv_cb_waitq, &wq);
 		}
 	}
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -38,6 +38,7 @@
 #include <linux/slab.h>
 #include <linux/kthread.h>
 #include <linux/namei.h>
+#include <linux/freezer.h>
 
 #include <linux/sunrpc/addr.h>
 #include <linux/nfs_ssc.h>
@@ -1322,7 +1323,7 @@ try_again:
 
 			/* allow 20secs for mount/unmount for now - revisit */
 			if (kthread_should_stop() ||
-					(schedule_timeout(20*HZ) == 0)) {
+					(freezable_schedule_timeout(20*HZ) == 0)) {
 				finish_wait(&nn->nfsd_ssc_waitq, &wait);
 				kfree(work);
 				return nfserr_eagain;
--- a/net/sunrpc/svc_xprt.c
+++ b/net/sunrpc/svc_xprt.c
@@ -705,7 +705,7 @@ static int svc_alloc_arg(struct svc_rqst
 			set_current_state(TASK_RUNNING);
 			return -EINTR;
 		}
-		schedule_timeout(msecs_to_jiffies(500));
+		freezable_schedule_timeout(msecs_to_jiffies(500));
 	}
 	rqstp->rq_page_end = &rqstp->rq_pages[pages];
 	rqstp->rq_pages[pages] = NULL; /* this might be seen in nfsd_splice_actor() */
@@ -765,7 +765,7 @@ static struct svc_xprt *svc_get_next_xpr
 	smp_mb__after_atomic();
 
 	if (likely(rqst_should_sleep(rqstp)))
-		time_left = schedule_timeout(timeout);
+		time_left = freezable_schedule_timeout(timeout);
 	else
 		__set_current_state(TASK_RUNNING);
 


