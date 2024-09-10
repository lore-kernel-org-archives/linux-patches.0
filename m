Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23F651885A6;
	Tue, 10 Sep 2024 09:51:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961900; cv=none; b=LaXf0Ihg08063IeTRUlxFc39XAnjvXNXUDZcihSszPA89+GdSMvPwC0W/oMAkEYu38npIfOH09V3Rcml4czi2fwR1KGBVumX3JcL6hkHvN3WSZ66+EUXCjhqokgPr31r5sKraFbi9sTYpsKQN7AD5VqaN0ggXcKdpBgaN6yHjsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961900; c=relaxed/simple;
	bh=WpzR8rjLNyGpJvUnaf33v0VmBNc98ZB6bkc9BIdGmzc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VbGJ9//fa7/4AmI6TYq94INPqz8AGpllhqzAGkaTgF9iUhCPkG5iBn9uSfafaaBbIw9FKKx3hzsuOd5vp2iEWt6VIFef01AYezUJ/wZBMn1Uuoiu7tFOI+RfILmOW1K15PobfaLFNs3VxEQShNWPCXg3upnlVHlyDucKstfEE1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yYy45+6k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yYy45+6k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D90BC4CEC3;
	Tue, 10 Sep 2024 09:51:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961899;
	bh=WpzR8rjLNyGpJvUnaf33v0VmBNc98ZB6bkc9BIdGmzc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yYy45+6kEGbHZsz4Z8QCSs/oVKEb1FtsjP5rhOeEv64YZDcGln3iS0KJiC/AEedt3
	 gbLZVbi9W8muDsBvn1PHqwXcyDkdx9XoRlTjvtXAi+eqEFWRberybQzliy7WRuIfBB
	 pmif3NRdf5dyGL4zfuba83d2gCTQYg3QHxt0O7cg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 199/375] xen: privcmd: Fix possible access to a freed kirqfd instance
Date: Tue, 10 Sep 2024 11:29:56 +0200
Message-ID: <20240910092629.184563717@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Viresh Kumar <viresh.kumar@linaro.org>

[ Upstream commit 611ff1b1ae989a7bcce3e2a8e132ee30e968c557 ]

Nothing prevents simultaneous ioctl calls to privcmd_irqfd_assign() and
privcmd_irqfd_deassign(). If that happens, it is possible that a kirqfd
created and added to the irqfds_list by privcmd_irqfd_assign() may get
removed by another thread executing privcmd_irqfd_deassign(), while the
former is still using it after dropping the locks.

This can lead to a situation where an already freed kirqfd instance may
be accessed and cause kernel oops.

Use SRCU locking to prevent the same, as is done for the KVM
implementation for irqfds.

Reported-by: Al Viro <viro@zeniv.linux.org.uk>
Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Reviewed-by: Juergen Gross <jgross@suse.com>
Link: https://lore.kernel.org/r/9e884af1f1f842eacbb7afc5672c8feb4dea7f3f.1718703669.git.viresh.kumar@linaro.org
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/xen/privcmd.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/xen/privcmd.c b/drivers/xen/privcmd.c
index c9c620e32fa8..39e726d7280e 100644
--- a/drivers/xen/privcmd.c
+++ b/drivers/xen/privcmd.c
@@ -17,6 +17,7 @@
 #include <linux/poll.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
+#include <linux/srcu.h>
 #include <linux/string.h>
 #include <linux/workqueue.h>
 #include <linux/errno.h>
@@ -846,6 +847,7 @@ static long privcmd_ioctl_mmap_resource(struct file *file,
 /* Irqfd support */
 static struct workqueue_struct *irqfd_cleanup_wq;
 static DEFINE_SPINLOCK(irqfds_lock);
+DEFINE_STATIC_SRCU(irqfds_srcu);
 static LIST_HEAD(irqfds_list);
 
 struct privcmd_kernel_irqfd {
@@ -873,6 +875,9 @@ static void irqfd_shutdown(struct work_struct *work)
 		container_of(work, struct privcmd_kernel_irqfd, shutdown);
 	u64 cnt;
 
+	/* Make sure irqfd has been initialized in assign path */
+	synchronize_srcu(&irqfds_srcu);
+
 	eventfd_ctx_remove_wait_queue(kirqfd->eventfd, &kirqfd->wait, &cnt);
 	eventfd_ctx_put(kirqfd->eventfd);
 	kfree(kirqfd);
@@ -935,7 +940,7 @@ static int privcmd_irqfd_assign(struct privcmd_irqfd *irqfd)
 	__poll_t events;
 	struct fd f;
 	void *dm_op;
-	int ret;
+	int ret, idx;
 
 	kirqfd = kzalloc(sizeof(*kirqfd) + irqfd->size, GFP_KERNEL);
 	if (!kirqfd)
@@ -981,6 +986,7 @@ static int privcmd_irqfd_assign(struct privcmd_irqfd *irqfd)
 		}
 	}
 
+	idx = srcu_read_lock(&irqfds_srcu);
 	list_add_tail(&kirqfd->list, &irqfds_list);
 	spin_unlock_irqrestore(&irqfds_lock, flags);
 
@@ -992,6 +998,8 @@ static int privcmd_irqfd_assign(struct privcmd_irqfd *irqfd)
 	if (events & EPOLLIN)
 		irqfd_inject(kirqfd);
 
+	srcu_read_unlock(&irqfds_srcu, idx);
+
 	/*
 	 * Do not drop the file until the kirqfd is fully initialized, otherwise
 	 * we might race against the EPOLLHUP.
-- 
2.43.0



