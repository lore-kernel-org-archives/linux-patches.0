Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06EDF42046;
	Mon,  8 Apr 2024 13:33:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583227; cv=none; b=bSZiWsk277SuLXAvN+c36a0do6pgXnFhsWguqS6BWlal6nGaS+P/1972ph/9yTWpaeYtfGLEeBV7KNvtFzn8U9kqzWurOgYSUUZpKCvCKw368mioixXogLH/EGg/KA18QYeGD5HrSmfKiGC+cCR7UWT6TlzH6Ik9Y9wzCWW/YIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583227; c=relaxed/simple;
	bh=fhvioDovrbj9r5ai6f3ZZCoxCGAcT0FMd1OWYnvsOdY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lnwn4e6xJ8Hp1naYnnaz+ItlGl3lzpAFaIinLOlnz2zCD0ihxpuQH/CdWJEa3kF/Zntgesz2H2z/LqkOH++pjGbpUa7Qx+16Df3vG/54dBiUBH/f4txv/17ka4u1QPFYVTSc4wCSbWOENAA6Xzmz2Z3Ui55DVsQLXoZq3QD8cVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=umf6aOc7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="umf6aOc7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B1FCC43390;
	Mon,  8 Apr 2024 13:33:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583226;
	bh=fhvioDovrbj9r5ai6f3ZZCoxCGAcT0FMd1OWYnvsOdY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=umf6aOc7Z1c/GIMwU7OMQCExR2HRQH06ktX/3SCvaf0I6mAQLuIMAkpWloYNnI58G
	 30et/JDCdXj+wsXG7ycR3Cm3LUhyZXhPlfe+gGxg3dVfWCgtc4mI4baVxEMZrDZiCJ
	 YPiOv3aY149VaheW46abNfHhV8Jc3SG72KikA+Do=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 224/690] exit: Implement kthread_exit
Date: Mon,  8 Apr 2024 14:51:30 +0200
Message-ID: <20240408125407.661249231@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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
---
 include/linux/kthread.h |  1 +
 kernel/kthread.c        | 23 +++++++++++++++++++----
 tools/objtool/check.c   |  1 +
 3 files changed, 21 insertions(+), 4 deletions(-)

diff --git a/include/linux/kthread.h b/include/linux/kthread.h
index db47aae7c481b..8e21bd13c36dd 100644
--- a/include/linux/kthread.h
+++ b/include/linux/kthread.h
@@ -95,6 +95,7 @@ void *kthread_probe_data(struct task_struct *k);
 int kthread_park(struct task_struct *k);
 void kthread_unpark(struct task_struct *k);
 void kthread_parkme(void);
+void kthread_exit(long result) __noreturn;
 
 int kthreadd(void *unused);
 extern struct task_struct *kthreadd_task;
diff --git a/kernel/kthread.c b/kernel/kthread.c
index e319a1b62586e..4cc6897b7ca40 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -268,6 +268,21 @@ void kthread_parkme(void)
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
@@ -285,13 +300,13 @@ static int kthread(void *_create)
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
@@ -318,7 +333,7 @@ static int kthread(void *_create)
 		__kthread_parkme(self);
 		ret = threadfn(data);
 	}
-	do_exit(ret);
+	kthread_exit(ret);
 }
 
 /* called from kernel_clone() to get node information for about to be created task */
@@ -628,7 +643,7 @@ EXPORT_SYMBOL_GPL(kthread_park);
  * instead of calling wake_up_process(): the thread will exit without
  * calling threadfn().
  *
- * If threadfn() may call do_exit() itself, the caller must ensure
+ * If threadfn() may call kthread_exit() itself, the caller must ensure
  * task_struct can't go away.
  *
  * Returns the result of threadfn(), or %-EINTR if wake_up_process()
diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index c3bb96e5bfa64..f066837d8e1aa 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -169,6 +169,7 @@ static bool __dead_end_function(struct objtool_file *file, struct symbol *func,
 		"panic",
 		"do_exit",
 		"do_task_dead",
+		"kthread_exit",
 		"make_task_dead",
 		"__module_put_and_exit",
 		"complete_and_exit",
-- 
2.43.0



