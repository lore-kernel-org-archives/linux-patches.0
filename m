Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793217192;
	b=rWrdoARg7elwYW3kSMpG1FaIsCgaxEVRc32aZ1nxNNTT2UIZYNgBE6qjbS7WuEo1UTE4
	 cHqIOTfQuo+cXtQkUXREMkq0lxXUMSG9+1XbtGQDt7op8AN3LKaK+bCRUaqODeegw58hl
	 0qfKThq4yPpF0GojCe0wCzMde49kXh33STo8KC4a1MQwZ9faA2jz7HNIBbTzZLixWmfej
	 Vz/2enehqijUs1cbyFwQGwIvDlnSJvopsQKBKWUL+M2v4JxNpXP6sHwSr+/sEg1gRxmsG
	 jrcHVlbzNk4s5aUdGINVmaX8UVHJ+lflcd4c48OIZ78mUNP6M8dbk3snMg3sidQ6M+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793217192;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hYTMytszvPfVj3RDwZHtcsEqOkm9KfdHlvAvRRvByxg=;
	b=xwcGqf4WaIURqSBtRd+qs/i96xPFGh7iecBaMexMb4wNi3SXhKN8XqPYpiFnZzqUAHtS
	 1yc8en5ri1YN7HXRsIOpsVHJUucorGMxAponiMjVLUgr1mirnkFROkQflz33dX3OsHmH5
	 81pw7YXy+nfTYQzXkdIYWvV5vbHFg3u7qhhuZEUgksygQ0NeLcqrdWjZDb8gnniuRFwd4
	 9/voDDh4pHvx+mid/m93izihDR9yW8QnR1KCAq8zS9HTY43LYxU+8TU14Zj60y7Z2azbP
	 m9entmPySsT0DW3/ec09Hoyjo1soK6Av4heHL13WhBQ3A3VKh9HKk1ldVMfsRtIaCvA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GHB7Nep0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 314FD606A31A;
	Wed, 28 Oct 2026 19:53:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GHB7Nep0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B87A1F01825;
	Wed, 28 Oct 2026 19:53:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793217192;
	bh=hYTMytszvPfVj3RDwZHtcsEqOkm9KfdHlvAvRRvByxg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GHB7Nep0i4CbJ+ZmWzrkeNd7/dSbwVQsuAOlwBpbX10GnV554X/yuH8HVn/xOypBZ
	 cnRD2/7D0wz+zcRvITXV/kLgowmARfEELugMEjMmXB8roPifo6Q0fnOxPOU//sUsFF
	 icaX1JOuGjMRnwn1gk9KlUIoqZ1IN+I8LZ9mXUus=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleg Nesterov <oleg@redhat.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 6.1 1819/1887] signal: allow taks to temporarily block TIF_NOTIFY_SIGNAL
Date: Wed, 28 Oct 2026 18:05:15 +0100
Message-ID: <20261028170540.835533911@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

commit 22b7f491be8f93ff72de0a3fe02b8ee9e64d3f21 upstream.

TIF_NOTIFY_SIGNAL is used to kick a task in uninterruptible sleep to
return to userspace and run task work and then go back to sleep. This
mechanism works well but breaks e.g., coredumps. dump_interrupted() only
allows fatal signals to interrupt a coredump and the whole regular write
path going to actual filesystems is impervious to TIF_NOTIFY_SIGNAL as
well.

Add PF_NO_NOTIFY_SIGNAL and helpers to raise and restore it. This is the
same approach as memalloc_nofs_save(). signal_pending() will not report
a fake pending signal via TIF_NOTIFY_SIGNAL if inside a
PF_NO_NOTIFY_SIGNAL section.

No functional changes.

Link: https://patch.msgid.link/20260824-work-tif_notify_signal-v2-1-6609e42b3157@kernel.org
Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/sched.h        |    2 +-
 include/linux/sched/signal.h |   27 +++++++++++++++++++++++++--
 2 files changed, 26 insertions(+), 3 deletions(-)

--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1753,7 +1753,7 @@ extern struct pid *cad_pid;
 						 * I am cleaning dirty pages from some other bdi. */
 #define PF_KTHREAD		0x00200000	/* I am a kernel thread */
 #define PF_RANDOMIZE		0x00400000	/* Randomize virtual address space */
-#define PF__HOLE__00800000	0x00800000
+#define PF_NO_NOTIFY_SIGNAL	0x00800000	/* see no_notify_signal_save() */
 #define PF__HOLE__01000000	0x01000000
 #define PF__HOLE__02000000	0x02000000
 #define PF_NO_SETAFFINITY	0x04000000	/* Userland is not allowed to meddle with cpus_mask */
--- a/include/linux/sched/signal.h
+++ b/include/linux/sched/signal.h
@@ -2,6 +2,7 @@
 #ifndef _LINUX_SCHED_SIGNAL_H
 #define _LINUX_SCHED_SIGNAL_H
 
+#include <linux/cleanup.h>
 #include <linux/rculist.h>
 #include <linux/signal.h>
 #include <linux/sched.h>
@@ -389,14 +390,36 @@ static inline int task_sigpending(struct
 	return unlikely(test_tsk_thread_flag(p,TIF_SIGPENDING));
 }
 
+/* Prevent TIF_NOTIFY_SIGNAL from interrupting this task. */
+static inline unsigned int no_notify_signal_save(void)
+{
+	unsigned int flags = current->flags;
+
+	current->flags |= PF_NO_NOTIFY_SIGNAL;
+	return flags;
+}
+
+/* Restore the previous PF_NO_NOTIFY_SIGNAL state. */
+static inline void no_notify_signal_restore(unsigned int flags)
+{
+	current_restore_flags(flags, PF_NO_NOTIFY_SIGNAL);
+}
+
+DEFINE_LOCK_GUARD_0(no_notify_signal,
+		    _T->flags = no_notify_signal_save(),
+		    no_notify_signal_restore(_T->flags),
+		    unsigned int flags)
+
 static inline int signal_pending(struct task_struct *p)
 {
 	/*
 	 * TIF_NOTIFY_SIGNAL isn't really a signal, but it requires the same
 	 * behavior in terms of ensuring that we break out of wait loops
-	 * so that notify signal callbacks can be processed.
+	 * so that notify signal callbacks can be processed. Not for a task
+	 * that asked not to be interrupted by it, see no_notify_signal_save().
 	 */
-	if (unlikely(test_tsk_thread_flag(p, TIF_NOTIFY_SIGNAL)))
+	if (unlikely(test_tsk_thread_flag(p, TIF_NOTIFY_SIGNAL)) &&
+	    likely(!(READ_ONCE(p->flags) & PF_NO_NOTIFY_SIGNAL)))
 		return 1;
 	return task_sigpending(p);
 }


