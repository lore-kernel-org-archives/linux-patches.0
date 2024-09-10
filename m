Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C350F18FDA3;
	Tue, 10 Sep 2024 10:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964305; cv=none; b=VrLaVYPzv05pHtfIQnXd5/XPl+bP37l1O9JTU1QBQe5Xp3toIbRPjxoUPiJQCIa/97186/2tvUiokmCAFcDimAe+yc/Drtj/2eoi3wvVRCTD7c8IRU7LZVjZ5WnHIQVMaKWNrCJbDt/tDjHNi9hCfKi3LHOntS/VU54bGtDySJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964305; c=relaxed/simple;
	bh=wZLB9VZjkL6mdVrGDdsYgtioheY8oSwfEKbzaPFRsBs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uz/9UVtxEc2cQP2O6BUe/MybgFzQUCohKXPzgcu4Dj9fFznCWwWaWFavLWuEMk0bVa0BiFpEBMkkLI3XJweZhxm1On2havsj5OABN5jQTFROdVbOjGln0aIgWONIoqbn3JtU15jetaoZhLH4AE1ZrgYgC+IM+BJBgPvdQnhIoBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JgGN2/OR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JgGN2/OR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A8F8C4CEC3;
	Tue, 10 Sep 2024 10:31:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964305;
	bh=wZLB9VZjkL6mdVrGDdsYgtioheY8oSwfEKbzaPFRsBs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JgGN2/ORM+CoOzltZGzvfQIX84W4NvdZpIgWcwO7uXRgbyKRJvyswG0zHr1ZXNkFD
	 gKhto80OdHK6vpw5kkdo1UcEiqIEDqG9WGSI1yqg33+i5y8fETQ90GmGAlaPnODziv
	 p6+VVG9rNeR2cIv6cSoI6ywsbjkjddB7CfRPyKPU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 137/269] xen: privcmd: Fix possible access to a freed kirqfd instance
Date: Tue, 10 Sep 2024 11:32:04 +0200
Message-ID: <20240910092613.089617462@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 923f064c7e3e..61aaded483e1 100644
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
@@ -842,6 +843,7 @@ static long privcmd_ioctl_mmap_resource(struct file *file,
 /* Irqfd support */
 static struct workqueue_struct *irqfd_cleanup_wq;
 static DEFINE_SPINLOCK(irqfds_lock);
+DEFINE_STATIC_SRCU(irqfds_srcu);
 static LIST_HEAD(irqfds_list);
 
 struct privcmd_kernel_irqfd {
@@ -869,6 +871,9 @@ static void irqfd_shutdown(struct work_struct *work)
 		container_of(work, struct privcmd_kernel_irqfd, shutdown);
 	u64 cnt;
 
+	/* Make sure irqfd has been initialized in assign path */
+	synchronize_srcu(&irqfds_srcu);
+
 	eventfd_ctx_remove_wait_queue(kirqfd->eventfd, &kirqfd->wait, &cnt);
 	eventfd_ctx_put(kirqfd->eventfd);
 	kfree(kirqfd);
@@ -931,7 +936,7 @@ static int privcmd_irqfd_assign(struct privcmd_irqfd *irqfd)
 	__poll_t events;
 	struct fd f;
 	void *dm_op;
-	int ret;
+	int ret, idx;
 
 	kirqfd = kzalloc(sizeof(*kirqfd) + irqfd->size, GFP_KERNEL);
 	if (!kirqfd)
@@ -977,6 +982,7 @@ static int privcmd_irqfd_assign(struct privcmd_irqfd *irqfd)
 		}
 	}
 
+	idx = srcu_read_lock(&irqfds_srcu);
 	list_add_tail(&kirqfd->list, &irqfds_list);
 	spin_unlock_irqrestore(&irqfds_lock, flags);
 
@@ -988,6 +994,8 @@ static int privcmd_irqfd_assign(struct privcmd_irqfd *irqfd)
 	if (events & EPOLLIN)
 		irqfd_inject(kirqfd);
 
+	srcu_read_unlock(&irqfds_srcu, idx);
+
 	/*
 	 * Do not drop the file until the kirqfd is fully initialized, otherwise
 	 * we might race against the EPOLLHUP.
-- 
2.43.0



