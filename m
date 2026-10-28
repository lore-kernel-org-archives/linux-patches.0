Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208092;
	b=29QX3CGn2Ei34Oj9w5Q8a+300w485d8zya00QEAr93RjtOGyeFPuwil4j5/pHZMxgbAf
	 /zcQsoOOuEK5R9dfmnZ+MAiOyu1EewHNApwHOyRNQkAFjLRgb6JdcjmhrVfh1pY7WaA3/
	 UbIuVbmKrp810ivcZv0gS/1WuTcY6JnaT5d2M8ViSi8/CV+AE6ScHXPXCLUoKdw5j8fod
	 uwC1A2ISVp+bCKDLeSiRBoSYRF4zET3tPwP81JjsDBOXu4OjEhp7P3Ah+sY0OjLxsi/8Z
	 SP4NHa6Z2QKjDrLYRhYEK80MgIobdUfq1Sd5vSyU7BZwfcSs/j7cztZuQ0XryukPXiA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208092;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Dpl/CtPdLT03XmuZ9EeuYSntFI9qJKAOdrXyhfPjSd4=;
	b=i7TO6goFxkep3l+WrKvflIo+ih8G7F1cz2PZazkZEzvFM/V+tvKd3KkzEYrlDakk5zWR
	 VW/Yd8hZyc93lwgmJIUacEqVj96KMAxTQ3cnWfJjrUr+AkKQA6lIIDPbTBk47XiBeQrez
	 DVXRlzfvPQyVD7dkRtfyeeaeiQLBqYWfPw09aHI7zkAuAFkcX8Va75IdIU359MZc9osag
	 Ikrhfhik6r4UGs7biYNlxsCRfVj76TPIri86MNFoXqXyqOZsofLBeHJBrF8tkycdveCuf
	 +OC6EVe459yo01qkIxUJfWRF6WIrgdVswfhY0mq9qG35I9o/LAcxc3iqovs59tIZH1g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=H7ho2gFK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CE06606A31D;
	Wed, 28 Oct 2026 17:21:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=H7ho2gFK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F7F81F01828;
	Wed, 28 Oct 2026 17:21:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208092;
	bh=Dpl/CtPdLT03XmuZ9EeuYSntFI9qJKAOdrXyhfPjSd4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H7ho2gFKbwRNVGbgG6NEtv/c/KUlymKqWaes3+nYB7VOhlE/6s9iwOJWzJQ0fGWX2
	 pwrbF4e50KvpNXW5LyZF8kWgiGMxKaKVH4GOEu6fQOq5dsIMyXhHyWrQUTew7tMGP2
	 0klLt3FdqUSO1Gg8L1vtPC2q8dtOViO11epD3qs4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleg Nesterov <oleg@redhat.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 6.12 246/247] signal: allow taks to temporarily block TIF_NOTIFY_SIGNAL
Date: Wed, 28 Oct 2026 18:00:49 +0100
Message-ID: <20261028165953.248466978@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
References: <20261028165947.349197979@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1712,7 +1712,7 @@ extern struct pid __rcu *cad_pid;
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
@@ -380,14 +381,36 @@ static inline int task_sigpending(struct
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


