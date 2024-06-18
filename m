Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C924615747D;
	Tue, 18 Jun 2024 13:04:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715849; cv=none; b=IdaZkDYD/+/3yUG16gdFrditiJgXAPiLt/xZaxCjgxU7qKclmCf7uTcyX/Z1RgpKxijMsxd6J1Jj6Lpp5NL6fbFafkdrkMJPqPxhXD8XQcshgxgKfbilD0A87H4Cuw3cLfvckbnZnjTsd4f+ivN+3Q/N21b5hV0FUdWdq+dILGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715849; c=relaxed/simple;
	bh=hP1qZ4VaHGcYWn6a48luB4Ib0dmkE+S9Uz4d3b7hv2o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QOlBBLrVjTqqVQNi2ka+ejQ6Reeu5qTaUpgxu2SGdLAwrp/xpJR8nckd1HJwrTmL/N6yJ8VmJwOKB6yjuAYtAN88dVedn7CtWkqIZZkx2R7yfOIZG4K2603yHX2fE9WJ7Bv11tCspWZOzqjAZyoKj4NfsGRDfLrmZdLWqQI+MnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QGkGyiv6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QGkGyiv6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F21EC3277B;
	Tue, 18 Jun 2024 13:04:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715849;
	bh=hP1qZ4VaHGcYWn6a48luB4Ib0dmkE+S9Uz4d3b7hv2o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QGkGyiv6v48It8akJYXbnhpH1yxXJGUp5TbgGRvhzpaSK/LKO7ejYvzGus9DV8Yud
	 XXx9wOb6vzPOWvsmMpR1scky3Re021p9LzmYcqOVuDcH1CL29gsLdBAAM0t9ldDfUM
	 eTIp6ZarCAnUCPejOTkzYyx2u2QkOmWIxJ+oZVdc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 416/770] exit: Implement kthread_exit
Date: Tue, 18 Jun 2024 14:34:29 +0200
Message-ID: <20240618123423.343619986@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric W. Biederman <ebiederm@xmission.com>

[ Upstream commit bbda86e988d4c124e4cfa816291cbd583ae8bfb1 ]

The way the per task_struct exit_code is used by kernel threads is not
quite compatible how it is used by userspace applications.  The low
byte of the userspace exit_code value encodes the exit signal.  While
kthreads just use the value as an int holding ordinary kernel function
exit status like -EPERM.

Add kthread_exit to clearly separate the two kinds of uses.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Stable-dep-of: ca3574bd653a ("exit: Rename module_put_and_exit to module_put_and_kthread_exit")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/kthread.h |  1 +
 kernel/kthread.c        | 23 +++++++++++++++++++----
 tools/objtool/check.c   |  1 +
 3 files changed, 21 insertions(+), 4 deletions(-)

diff --git a/include/linux/kthread.h b/include/linux/kthread.h
index 2484ed97e72f5..9dae77a97a033 100644
--- a/include/linux/kthread.h
+++ b/include/linux/kthread.h
@@ -68,6 +68,7 @@ void *kthread_probe_data(struct task_struct *k);
 int kthread_park(struct task_struct *k);
 void kthread_unpark(struct task_struct *k);
 void kthread_parkme(void);
+void kthread_exit(long result) __noreturn;
 
 int kthreadd(void *unused);
 extern struct task_struct *kthreadd_task;
diff --git a/kernel/kthread.c b/kernel/kthread.c
index 508fe52782857..9d6cc9c15a55e 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -262,6 +262,21 @@ void kthread_parkme(void)
 }
 EXPORT_SYMBOL_GPL(kthread_parkme);
 
+/**
+ * kthread_exit - Cause the current kthread return @result to kthread_stop().
+ * @result: The integer value to return to kthread_stop().
+ *
+ * While kthread_exit can be called directly, it exists so that
+ * functions which do some additional work in non-modular code such as
+ * module_put_and_kthread_exit can be implemented.
+ *
+ * Does not return.
+ */
+void __noreturn kthread_exit(long result)
+{
+	do_exit(result);
+}
+
 static int kthread(void *_create)
 {
 	/* Copy data: it's on kthread's stack */
@@ -279,13 +294,13 @@ static int kthread(void *_create)
 	done = xchg(&create->done, NULL);
 	if (!done) {
 		kfree(create);
-		do_exit(-EINTR);
+		kthread_exit(-EINTR);
 	}
 
 	if (!self) {
 		create->result = ERR_PTR(-ENOMEM);
 		complete(done);
-		do_exit(-ENOMEM);
+		kthread_exit(-ENOMEM);
 	}
 
 	self->threadfn = threadfn;
@@ -312,7 +327,7 @@ static int kthread(void *_create)
 		__kthread_parkme(self);
 		ret = threadfn(data);
 	}
-	do_exit(ret);
+	kthread_exit(ret);
 }
 
 /* called from do_fork() to get node information for about to be created task */
@@ -621,7 +636,7 @@ EXPORT_SYMBOL_GPL(kthread_park);
  * instead of calling wake_up_process(): the thread will exit without
  * calling threadfn().
  *
- * If threadfn() may call do_exit() itself, the caller must ensure
+ * If threadfn() may call kthread_exit() itself, the caller must ensure
  * task_struct can't go away.
  *
  * Returns the result of threadfn(), or %-EINTR if wake_up_process()
diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index 059b78d08f7af..6afa1f8ca1614 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -168,6 +168,7 @@ static bool __dead_end_function(struct objtool_file *file, struct symbol *func,
 		"panic",
 		"do_exit",
 		"do_task_dead",
+		"kthread_exit",
 		"make_task_dead",
 		"__module_put_and_exit",
 		"complete_and_exit",
-- 
2.43.0



