Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C132134AC;
	Mon, 12 Aug 2024 16:26:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479976; cv=none; b=BESm1N8jQhu6oZZg+nqmZamNtZtay7F6D7CEZv147p9in1COqHV7WrdWvxjFU11uHHbfQG0zmrZmH5DFv1VIaIENkJJ2WfWDViOQOmbisWJbp84xPb4IeXPu15/KAqDtbNvh/bP4D3jxxZ24woNKQnzYXHHjLnwrZ40iW+nyuss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479976; c=relaxed/simple;
	bh=rM76ByfLif6QdzXVUAS9sxaEvFcmC/tZuEx80g2e0KU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PYGtAXwyM/0MwfGIWj4pDk6/asntjs7/CCXfeUKlUxLk8GyG7jqjrSfIF8j6C3Qn4Ia1KmI6sTOxt34qs1MvbuJll5U39Tg5fIYfUTbRbxbZqC+wIM4IUL3Lax2wJ25kwA6aNU6ob7npiXc9svWj9keHHgCmAqX57uInFPs3jFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ADHr1no1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ADHr1no1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11BF8C32782;
	Mon, 12 Aug 2024 16:26:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479976;
	bh=rM76ByfLif6QdzXVUAS9sxaEvFcmC/tZuEx80g2e0KU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ADHr1no1HC9y2Y0vsly1OhySkzxJE3T+yz1kwmtK6jIMeQ1AwbfnQksLdvUUZUFac
	 A1yuWHSFStMOBTO5KztY5e24YRG+7AoiudN1YcjndyXgGP5zYto7Ps3dOW7sfmKH3C
	 Fw4C47X38yqO+9SxMYqFES0BW5wIOAH1q7eqyUYA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 059/263] xen: privcmd: Switch from mutex to spinlock for irqfds
Date: Mon, 12 Aug 2024 18:01:00 +0200
Message-ID: <20240812160148.803297724@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
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

[ Upstream commit 1c682593096a487fd9aebc079a307ff7a6d054a3 ]

irqfd_wakeup() gets EPOLLHUP, when it is called by
eventfd_release() by way of wake_up_poll(&ctx->wqh, EPOLLHUP), which
gets called under spin_lock_irqsave(). We can't use a mutex here as it
will lead to a deadlock.

Fix it by switching over to a spin lock.

Reported-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Reviewed-by: Juergen Gross <jgross@suse.com>
Link: https://lore.kernel.org/r/a66d7a7a9001424d432f52a9fc3931a1f345464f.1718703669.git.viresh.kumar@linaro.org
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/xen/privcmd.c | 25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

diff --git a/drivers/xen/privcmd.c b/drivers/xen/privcmd.c
index 67dfa47788649..c9c620e32fa8b 100644
--- a/drivers/xen/privcmd.c
+++ b/drivers/xen/privcmd.c
@@ -845,7 +845,7 @@ static long privcmd_ioctl_mmap_resource(struct file *file,
 #ifdef CONFIG_XEN_PRIVCMD_EVENTFD
 /* Irqfd support */
 static struct workqueue_struct *irqfd_cleanup_wq;
-static DEFINE_MUTEX(irqfds_lock);
+static DEFINE_SPINLOCK(irqfds_lock);
 static LIST_HEAD(irqfds_list);
 
 struct privcmd_kernel_irqfd {
@@ -909,9 +909,11 @@ irqfd_wakeup(wait_queue_entry_t *wait, unsigned int mode, int sync, void *key)
 		irqfd_inject(kirqfd);
 
 	if (flags & EPOLLHUP) {
-		mutex_lock(&irqfds_lock);
+		unsigned long flags;
+
+		spin_lock_irqsave(&irqfds_lock, flags);
 		irqfd_deactivate(kirqfd);
-		mutex_unlock(&irqfds_lock);
+		spin_unlock_irqrestore(&irqfds_lock, flags);
 	}
 
 	return 0;
@@ -929,6 +931,7 @@ irqfd_poll_func(struct file *file, wait_queue_head_t *wqh, poll_table *pt)
 static int privcmd_irqfd_assign(struct privcmd_irqfd *irqfd)
 {
 	struct privcmd_kernel_irqfd *kirqfd, *tmp;
+	unsigned long flags;
 	__poll_t events;
 	struct fd f;
 	void *dm_op;
@@ -968,18 +971,18 @@ static int privcmd_irqfd_assign(struct privcmd_irqfd *irqfd)
 	init_waitqueue_func_entry(&kirqfd->wait, irqfd_wakeup);
 	init_poll_funcptr(&kirqfd->pt, irqfd_poll_func);
 
-	mutex_lock(&irqfds_lock);
+	spin_lock_irqsave(&irqfds_lock, flags);
 
 	list_for_each_entry(tmp, &irqfds_list, list) {
 		if (kirqfd->eventfd == tmp->eventfd) {
 			ret = -EBUSY;
-			mutex_unlock(&irqfds_lock);
+			spin_unlock_irqrestore(&irqfds_lock, flags);
 			goto error_eventfd;
 		}
 	}
 
 	list_add_tail(&kirqfd->list, &irqfds_list);
-	mutex_unlock(&irqfds_lock);
+	spin_unlock_irqrestore(&irqfds_lock, flags);
 
 	/*
 	 * Check if there was an event already pending on the eventfd before we
@@ -1011,12 +1014,13 @@ static int privcmd_irqfd_deassign(struct privcmd_irqfd *irqfd)
 {
 	struct privcmd_kernel_irqfd *kirqfd;
 	struct eventfd_ctx *eventfd;
+	unsigned long flags;
 
 	eventfd = eventfd_ctx_fdget(irqfd->fd);
 	if (IS_ERR(eventfd))
 		return PTR_ERR(eventfd);
 
-	mutex_lock(&irqfds_lock);
+	spin_lock_irqsave(&irqfds_lock, flags);
 
 	list_for_each_entry(kirqfd, &irqfds_list, list) {
 		if (kirqfd->eventfd == eventfd) {
@@ -1025,7 +1029,7 @@ static int privcmd_irqfd_deassign(struct privcmd_irqfd *irqfd)
 		}
 	}
 
-	mutex_unlock(&irqfds_lock);
+	spin_unlock_irqrestore(&irqfds_lock, flags);
 
 	eventfd_ctx_put(eventfd);
 
@@ -1073,13 +1077,14 @@ static int privcmd_irqfd_init(void)
 static void privcmd_irqfd_exit(void)
 {
 	struct privcmd_kernel_irqfd *kirqfd, *tmp;
+	unsigned long flags;
 
-	mutex_lock(&irqfds_lock);
+	spin_lock_irqsave(&irqfds_lock, flags);
 
 	list_for_each_entry_safe(kirqfd, tmp, &irqfds_list, list)
 		irqfd_deactivate(kirqfd);
 
-	mutex_unlock(&irqfds_lock);
+	spin_unlock_irqrestore(&irqfds_lock, flags);
 
 	destroy_workqueue(irqfd_cleanup_wq);
 }
-- 
2.43.0



