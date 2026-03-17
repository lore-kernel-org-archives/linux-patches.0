Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADA8B3EAC6F;
	Tue, 17 Mar 2026 16:51:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773766303; cv=none; b=jmqzJq2bFFvEFtleqdUmmJNDtOkVPv1Y2JuXvk7+kRssOl7BqQqHV7Dym1bVHpjQFh22mbapb5f9/UqZrku1x4FBNqo4RYsD+cpX/DfEMfcb+nGN6UjiBe+HyKmXgOKeXYHvNMyOzPAXg4rj1rpSCc8pkSBtNrgRL3MElHJh9oU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773766303; c=relaxed/simple;
	bh=65hkiwFo17fr3Y0wrCczs03x61FtbAJxvMn56gBhS78=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DGNAfbNFTKLSUqLd3m2qcsjPuXxk0Fj1GZ9UK8NGNawm94yabFTHIunkztAHKQnq0jLcndUzm9BOYwWNvpsF2Aj35Pj7jevcFRT2NkTEaf6sw4isX355KZnAnXx1LfvPp0Q1DQHEz3NFlK4wezxJkbxpf7XRcN9CI/Ic1ket8qQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MpX08jro; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MpX08jro"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21D8FC4CEF7;
	Tue, 17 Mar 2026 16:51:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773766303;
	bh=65hkiwFo17fr3Y0wrCczs03x61FtbAJxvMn56gBhS78=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MpX08jro96Zh5EVi1O2ioUMwZvxhpNOeLR7F5gu8seZng6MQEcFZZSs5vGwLQ+82p
	 LhktO3rKq3E60rqs0FuNwovpZr9PS7LxVTQ9iI2MYqq0m1lGIIlcBxhh0Tu2IwnPMM
	 ahzJD2JXPkm06GBH5tbNjgFni6+X1d1h46xEjH44=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guillaume Tucker <gtucker@gtucker.io>,
	Mark Brown <broonie@kernel.org>,
	David Gow <davidgow@google.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.19 215/378] kthread: consolidate kthread exit paths to prevent use-after-free
Date: Tue, 17 Mar 2026 17:32:52 +0100
Message-ID: <20260317163014.919132911@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

commit 28aaa9c39945b7925a1cc1d513c8f21ed38f5e4f upstream.

Guillaume reported crashes via corrupted RCU callback function pointers
during KUnit testing. The crash was traced back to the pidfs rhashtable
conversion which replaced the 24-byte rb_node with an 8-byte rhash_head
in struct pid, shrinking it from 160 to 144 bytes.

struct kthread (without CONFIG_BLK_CGROUP) is also 144 bytes. With
CONFIG_SLAB_MERGE_DEFAULT and SLAB_HWCACHE_ALIGN both round up to
192 bytes and share the same slab cache. struct pid.rcu.func and
struct kthread.affinity_node both sit at offset 0x78.

When a kthread exits via make_task_dead() it bypasses kthread_exit() and
misses the affinity_node cleanup. free_kthread_struct() frees the memory
while the node is still linked into the global kthread_affinity_list. A
subsequent list_del() by another kthread writes through dangling list
pointers into the freed and reused memory, corrupting the pid's
rcu.func pointer.

Instead of patching free_kthread_struct() to handle the missed cleanup,
consolidate all kthread exit paths. Turn kthread_exit() into a macro
that calls do_exit() and add kthread_do_exit() which is called from
do_exit() for any task with PF_KTHREAD set. This guarantees that
kthread-specific cleanup always happens regardless of the exit path -
make_task_dead(), direct do_exit(), or kthread_exit().

Replace __to_kthread() with a new tsk_is_kthread() accessor in the
public header. Export do_exit() since module code using the
kthread_exit() macro now needs it directly.

Reported-by: Guillaume Tucker <gtucker@gtucker.io>
Tested-by: Guillaume Tucker <gtucker@gtucker.io>
Tested-by: Mark Brown <broonie@kernel.org>
Tested-by: David Gow <davidgow@google.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/all/20260224-mittlerweile-besessen-2738831ae7f6@brauner
Co-developed-by: Linus Torvalds <torvalds@linux-foundation.org>
Fixes: 4d13f4304fa4 ("kthread: Implement preferred affinity")
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/kthread.h |   21 ++++++++++++++++++++-
 kernel/exit.c           |    6 ++++++
 kernel/kthread.c        |   41 +++++------------------------------------
 3 files changed, 31 insertions(+), 37 deletions(-)

--- a/include/linux/kthread.h
+++ b/include/linux/kthread.h
@@ -7,6 +7,24 @@
 
 struct mm_struct;
 
+/* opaque kthread data */
+struct kthread;
+
+/*
+ * When "(p->flags & PF_KTHREAD)" is set the task is a kthread and will
+ * always remain a kthread.  For kthreads p->worker_private always
+ * points to a struct kthread.  For tasks that are not kthreads
+ * p->worker_private is used to point to other things.
+ *
+ * Return NULL for any task that is not a kthread.
+ */
+static inline struct kthread *tsk_is_kthread(struct task_struct *p)
+{
+	if (p->flags & PF_KTHREAD)
+		return p->worker_private;
+	return NULL;
+}
+
 __printf(4, 5)
 struct task_struct *kthread_create_on_node(int (*threadfn)(void *data),
 					   void *data,
@@ -98,8 +116,9 @@ void *kthread_probe_data(struct task_str
 int kthread_park(struct task_struct *k);
 void kthread_unpark(struct task_struct *k);
 void kthread_parkme(void);
-void kthread_exit(long result) __noreturn;
+#define kthread_exit(result) do_exit(result)
 void kthread_complete_and_exit(struct completion *, long) __noreturn;
+void kthread_do_exit(struct kthread *, long);
 
 int kthreadd(void *unused);
 extern struct task_struct *kthreadd_task;
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -896,11 +896,16 @@ static void synchronize_group_exit(struc
 void __noreturn do_exit(long code)
 {
 	struct task_struct *tsk = current;
+	struct kthread *kthread;
 	int group_dead;
 
 	WARN_ON(irqs_disabled());
 	WARN_ON(tsk->plug);
 
+	kthread = tsk_is_kthread(tsk);
+	if (unlikely(kthread))
+		kthread_do_exit(kthread, code);
+
 	kcov_task_exit(tsk);
 	kmsan_task_exit(tsk);
 
@@ -1013,6 +1018,7 @@ void __noreturn do_exit(long code)
 	lockdep_free_task(tsk);
 	do_task_dead();
 }
+EXPORT_SYMBOL(do_exit);
 
 void __noreturn make_task_dead(int signr)
 {
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -85,24 +85,6 @@ static inline struct kthread *to_kthread
 	return k->worker_private;
 }
 
-/*
- * Variant of to_kthread() that doesn't assume @p is a kthread.
- *
- * When "(p->flags & PF_KTHREAD)" is set the task is a kthread and will
- * always remain a kthread.  For kthreads p->worker_private always
- * points to a struct kthread.  For tasks that are not kthreads
- * p->worker_private is used to point to other things.
- *
- * Return NULL for any task that is not a kthread.
- */
-static inline struct kthread *__to_kthread(struct task_struct *p)
-{
-	void *kthread = p->worker_private;
-	if (kthread && !(p->flags & PF_KTHREAD))
-		kthread = NULL;
-	return kthread;
-}
-
 void get_kthread_comm(char *buf, size_t buf_size, struct task_struct *tsk)
 {
 	struct kthread *kthread = to_kthread(tsk);
@@ -193,7 +175,7 @@ EXPORT_SYMBOL_GPL(kthread_should_park);
 
 bool kthread_should_stop_or_park(void)
 {
-	struct kthread *kthread = __to_kthread(current);
+	struct kthread *kthread = tsk_is_kthread(current);
 
 	if (!kthread)
 		return false;
@@ -234,7 +216,7 @@ EXPORT_SYMBOL_GPL(kthread_freezable_shou
  */
 void *kthread_func(struct task_struct *task)
 {
-	struct kthread *kthread = __to_kthread(task);
+	struct kthread *kthread = tsk_is_kthread(task);
 	if (kthread)
 		return kthread->threadfn;
 	return NULL;
@@ -266,7 +248,7 @@ EXPORT_SYMBOL_GPL(kthread_data);
  */
 void *kthread_probe_data(struct task_struct *task)
 {
-	struct kthread *kthread = __to_kthread(task);
+	struct kthread *kthread = tsk_is_kthread(task);
 	void *data = NULL;
 
 	if (kthread)
@@ -309,19 +291,8 @@ void kthread_parkme(void)
 }
 EXPORT_SYMBOL_GPL(kthread_parkme);
 
-/**
- * kthread_exit - Cause the current kthread return @result to kthread_stop().
- * @result: The integer value to return to kthread_stop().
- *
- * While kthread_exit can be called directly, it exists so that
- * functions which do some additional work in non-modular code such as
- * module_put_and_kthread_exit can be implemented.
- *
- * Does not return.
- */
-void __noreturn kthread_exit(long result)
+void kthread_do_exit(struct kthread *kthread, long result)
 {
-	struct kthread *kthread = to_kthread(current);
 	kthread->result = result;
 	if (!list_empty(&kthread->hotplug_node)) {
 		mutex_lock(&kthreads_hotplug_lock);
@@ -333,9 +304,7 @@ void __noreturn kthread_exit(long result
 			kthread->preferred_affinity = NULL;
 		}
 	}
-	do_exit(0);
 }
-EXPORT_SYMBOL(kthread_exit);
 
 /**
  * kthread_complete_and_exit - Exit the current kthread.
@@ -680,7 +649,7 @@ void kthread_set_per_cpu(struct task_str
 
 bool kthread_is_per_cpu(struct task_struct *p)
 {
-	struct kthread *kthread = __to_kthread(p);
+	struct kthread *kthread = tsk_is_kthread(p);
 	if (!kthread)
 		return false;
 


