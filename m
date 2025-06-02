Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2D53221F24;
	Mon,  2 Jun 2025 14:25:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874352; cv=none; b=eYnWRIMMMp/b8ZTmD7sZMTMawj8ouOISgtdYvkLTVI2JCiQvmc7IeY0b2z0pFo1rQO/Xx3rtSBH0lFoCLwvUYwWN8TTxtgMpbnD81jnuJHLZyXm+ASDMD6efZN6YBY0Z4jGlb+KEbU2tKR37MKIcJNgCafHCnAHDM3ylGE6qMfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874352; c=relaxed/simple;
	bh=ys4BNa0PObpseH49d4Kt4PIavHURld99P0hUdtc54yg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ic1UV51J1Xs8sUgObiEUgKzdG84SwhiizisKejzI+8F009QoIJk2hC0LnF2rwpGMumPL13lo3ufiz2xGotsfl50ifTynafnrQZwlL2WbO2qYlV0Caot6aiHSC+VDicFFvp7uFilY8NE3ZdWSlDRiSX4Mz1oXaMBnxIpCcVhUTEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NbuJl1l/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NbuJl1l/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 744E9C4CEEB;
	Mon,  2 Jun 2025 14:25:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874351;
	bh=ys4BNa0PObpseH49d4Kt4PIavHURld99P0hUdtc54yg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NbuJl1l/gpR4+Smn6A/f/LA21YF2sZcsyVenxZllMVby/bRGxTdDP38I6X8H8fuzm
	 e8EaWmhwUYXTqMuPU1uxEj3dfimU8IzjmLNTGGpvvqNgiVCHi0xcPtjoDBsHpcqZ1o
	 D7/4MxqyyGYt2ajkCL0rtjXrMrEfQMhdIVlicn5M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jens Axboe <axboe@kernel.dk>,
	Jakub Kicinski <kuba@kernel.org>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 6.6 400/444] af_unix: Remove CONFIG_UNIX_SCM.
Date: Mon,  2 Jun 2025 15:47:44 +0200
Message-ID: <20250602134357.146345714@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@amazon.com>

commit 99a7a5b9943ea2d05fb0dee38e4ae2290477ed83 upstream.

Originally, the code related to garbage collection was all in garbage.c.

Commit f4e65870e5ce ("net: split out functions related to registering
inflight socket files") moved some functions to scm.c for io_uring and
added CONFIG_UNIX_SCM just in case AF_UNIX was built as module.

However, since commit 97154bcf4d1b ("af_unix: Kconfig: make CONFIG_UNIX
bool"), AF_UNIX is no longer built separately.  Also, io_uring does not
support SCM_RIGHTS now.

Let's move the functions back to garbage.c

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Acked-by: Jens Axboe <axboe@kernel.dk>
Link: https://lore.kernel.org/r/20240129190435.57228-4-kuniyu@amazon.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/af_unix.h |    7 +-
 net/Makefile          |    2 
 net/unix/Kconfig      |    5 -
 net/unix/Makefile     |    2 
 net/unix/af_unix.c    |   63 ++++++++++++++++++++-
 net/unix/garbage.c    |   73 +++++++++++++++++++++++-
 net/unix/scm.c        |  150 --------------------------------------------------
 net/unix/scm.h        |   10 ---
 8 files changed, 137 insertions(+), 175 deletions(-)
 delete mode 100644 net/unix/scm.c
 delete mode 100644 net/unix/scm.h

--- a/include/net/af_unix.h
+++ b/include/net/af_unix.h
@@ -17,19 +17,20 @@ static inline struct unix_sock *unix_get
 }
 #endif
 
+extern spinlock_t unix_gc_lock;
+extern unsigned int unix_tot_inflight;
+
 void unix_inflight(struct user_struct *user, struct file *fp);
 void unix_notinflight(struct user_struct *user, struct file *fp);
-void unix_destruct_scm(struct sk_buff *skb);
 void unix_gc(void);
 void wait_for_unix_gc(struct scm_fp_list *fpl);
+
 struct sock *unix_peer_get(struct sock *sk);
 
 #define UNIX_HASH_MOD	(256 - 1)
 #define UNIX_HASH_SIZE	(256 * 2)
 #define UNIX_HASH_BITS	8
 
-extern unsigned int unix_tot_inflight;
-
 struct unix_address {
 	refcount_t	refcnt;
 	int		len;
--- a/net/Makefile
+++ b/net/Makefile
@@ -17,7 +17,7 @@ obj-$(CONFIG_NETFILTER)		+= netfilter/
 obj-$(CONFIG_INET)		+= ipv4/
 obj-$(CONFIG_TLS)		+= tls/
 obj-$(CONFIG_XFRM)		+= xfrm/
-obj-$(CONFIG_UNIX_SCM)		+= unix/
+obj-$(CONFIG_UNIX)		+= unix/
 obj-y				+= ipv6/
 obj-$(CONFIG_BPFILTER)		+= bpfilter/
 obj-$(CONFIG_PACKET)		+= packet/
--- a/net/unix/Kconfig
+++ b/net/unix/Kconfig
@@ -16,11 +16,6 @@ config UNIX
 
 	  Say Y unless you know what you are doing.
 
-config UNIX_SCM
-	bool
-	depends on UNIX
-	default y
-
 config	AF_UNIX_OOB
 	bool
 	depends on UNIX
--- a/net/unix/Makefile
+++ b/net/unix/Makefile
@@ -11,5 +11,3 @@ unix-$(CONFIG_BPF_SYSCALL) += unix_bpf.o
 
 obj-$(CONFIG_UNIX_DIAG)	+= unix_diag.o
 unix_diag-y		:= diag.o
-
-obj-$(CONFIG_UNIX_SCM)	+= scm.o
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -117,8 +117,6 @@
 #include <linux/file.h>
 #include <linux/btf_ids.h>
 
-#include "scm.h"
-
 static atomic_long_t unix_nr_socks;
 static struct hlist_head bsd_socket_buckets[UNIX_HASH_SIZE / 2];
 static spinlock_t bsd_socket_locks[UNIX_HASH_SIZE / 2];
@@ -1752,6 +1750,52 @@ out:
 	return err;
 }
 
+/* The "user->unix_inflight" variable is protected by the garbage
+ * collection lock, and we just read it locklessly here. If you go
+ * over the limit, there might be a tiny race in actually noticing
+ * it across threads. Tough.
+ */
+static inline bool too_many_unix_fds(struct task_struct *p)
+{
+	struct user_struct *user = current_user();
+
+	if (unlikely(READ_ONCE(user->unix_inflight) > task_rlimit(p, RLIMIT_NOFILE)))
+		return !capable(CAP_SYS_RESOURCE) && !capable(CAP_SYS_ADMIN);
+	return false;
+}
+
+static int unix_attach_fds(struct scm_cookie *scm, struct sk_buff *skb)
+{
+	int i;
+
+	if (too_many_unix_fds(current))
+		return -ETOOMANYREFS;
+
+	/* Need to duplicate file references for the sake of garbage
+	 * collection.  Otherwise a socket in the fps might become a
+	 * candidate for GC while the skb is not yet queued.
+	 */
+	UNIXCB(skb).fp = scm_fp_dup(scm->fp);
+	if (!UNIXCB(skb).fp)
+		return -ENOMEM;
+
+	for (i = scm->fp->count - 1; i >= 0; i--)
+		unix_inflight(scm->fp->user, scm->fp->fp[i]);
+
+	return 0;
+}
+
+static void unix_detach_fds(struct scm_cookie *scm, struct sk_buff *skb)
+{
+	int i;
+
+	scm->fp = UNIXCB(skb).fp;
+	UNIXCB(skb).fp = NULL;
+
+	for (i = scm->fp->count - 1; i >= 0; i--)
+		unix_notinflight(scm->fp->user, scm->fp->fp[i]);
+}
+
 static void unix_peek_fds(struct scm_cookie *scm, struct sk_buff *skb)
 {
 	scm->fp = scm_fp_dup(UNIXCB(skb).fp);
@@ -1799,6 +1843,21 @@ static void unix_peek_fds(struct scm_coo
 	spin_unlock(&unix_gc_lock);
 }
 
+static void unix_destruct_scm(struct sk_buff *skb)
+{
+	struct scm_cookie scm;
+
+	memset(&scm, 0, sizeof(scm));
+	scm.pid  = UNIXCB(skb).pid;
+	if (UNIXCB(skb).fp)
+		unix_detach_fds(&scm, skb);
+
+	/* Alas, it calls VFS */
+	/* So fscking what? fput() had been SMP-safe since the last Summer */
+	scm_destroy(&scm);
+	sock_wfree(skb);
+}
+
 static int unix_scm_to_skb(struct scm_cookie *scm, struct sk_buff *skb, bool send_fds)
 {
 	int err = 0;
--- a/net/unix/garbage.c
+++ b/net/unix/garbage.c
@@ -81,11 +81,80 @@
 #include <net/scm.h>
 #include <net/tcp_states.h>
 
-#include "scm.h"
+struct unix_sock *unix_get_socket(struct file *filp)
+{
+	struct inode *inode = file_inode(filp);
 
-/* Internal data structures and random procedures: */
+	/* Socket ? */
+	if (S_ISSOCK(inode->i_mode) && !(filp->f_mode & FMODE_PATH)) {
+		struct socket *sock = SOCKET_I(inode);
+		const struct proto_ops *ops;
+		struct sock *sk = sock->sk;
 
+		ops = READ_ONCE(sock->ops);
+
+		/* PF_UNIX ? */
+		if (sk && ops && ops->family == PF_UNIX)
+			return unix_sk(sk);
+	}
+
+	return NULL;
+}
+
+DEFINE_SPINLOCK(unix_gc_lock);
+unsigned int unix_tot_inflight;
 static LIST_HEAD(gc_candidates);
+static LIST_HEAD(gc_inflight_list);
+
+/* Keep the number of times in flight count for the file
+ * descriptor if it is for an AF_UNIX socket.
+ */
+void unix_inflight(struct user_struct *user, struct file *filp)
+{
+	struct unix_sock *u = unix_get_socket(filp);
+
+	spin_lock(&unix_gc_lock);
+
+	if (u) {
+		if (!u->inflight) {
+			WARN_ON_ONCE(!list_empty(&u->link));
+			list_add_tail(&u->link, &gc_inflight_list);
+		} else {
+			WARN_ON_ONCE(list_empty(&u->link));
+		}
+		u->inflight++;
+
+		/* Paired with READ_ONCE() in wait_for_unix_gc() */
+		WRITE_ONCE(unix_tot_inflight, unix_tot_inflight + 1);
+	}
+
+	WRITE_ONCE(user->unix_inflight, user->unix_inflight + 1);
+
+	spin_unlock(&unix_gc_lock);
+}
+
+void unix_notinflight(struct user_struct *user, struct file *filp)
+{
+	struct unix_sock *u = unix_get_socket(filp);
+
+	spin_lock(&unix_gc_lock);
+
+	if (u) {
+		WARN_ON_ONCE(!u->inflight);
+		WARN_ON_ONCE(list_empty(&u->link));
+
+		u->inflight--;
+		if (!u->inflight)
+			list_del_init(&u->link);
+
+		/* Paired with READ_ONCE() in wait_for_unix_gc() */
+		WRITE_ONCE(unix_tot_inflight, unix_tot_inflight - 1);
+	}
+
+	WRITE_ONCE(user->unix_inflight, user->unix_inflight - 1);
+
+	spin_unlock(&unix_gc_lock);
+}
 
 static void scan_inflight(struct sock *x, void (*func)(struct unix_sock *),
 			  struct sk_buff_head *hitlist)
--- a/net/unix/scm.c
+++ /dev/null
@@ -1,150 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-#include <linux/module.h>
-#include <linux/kernel.h>
-#include <linux/string.h>
-#include <linux/socket.h>
-#include <linux/net.h>
-#include <linux/fs.h>
-#include <net/af_unix.h>
-#include <net/scm.h>
-#include <linux/init.h>
-#include <linux/io_uring.h>
-
-#include "scm.h"
-
-unsigned int unix_tot_inflight;
-EXPORT_SYMBOL(unix_tot_inflight);
-
-LIST_HEAD(gc_inflight_list);
-EXPORT_SYMBOL(gc_inflight_list);
-
-DEFINE_SPINLOCK(unix_gc_lock);
-EXPORT_SYMBOL(unix_gc_lock);
-
-struct unix_sock *unix_get_socket(struct file *filp)
-{
-	struct inode *inode = file_inode(filp);
-
-	/* Socket ? */
-	if (S_ISSOCK(inode->i_mode) && !(filp->f_mode & FMODE_PATH)) {
-		struct socket *sock = SOCKET_I(inode);
-		const struct proto_ops *ops = READ_ONCE(sock->ops);
-		struct sock *s = sock->sk;
-
-		/* PF_UNIX ? */
-		if (s && ops && ops->family == PF_UNIX)
-			return unix_sk(s);
-	}
-
-	return NULL;
-}
-EXPORT_SYMBOL(unix_get_socket);
-
-/* Keep the number of times in flight count for the file
- * descriptor if it is for an AF_UNIX socket.
- */
-void unix_inflight(struct user_struct *user, struct file *fp)
-{
-	struct unix_sock *u = unix_get_socket(fp);
-
-	spin_lock(&unix_gc_lock);
-
-	if (u) {
-		if (!u->inflight) {
-			WARN_ON_ONCE(!list_empty(&u->link));
-			list_add_tail(&u->link, &gc_inflight_list);
-		} else {
-			WARN_ON_ONCE(list_empty(&u->link));
-		}
-		u->inflight++;
-		/* Paired with READ_ONCE() in wait_for_unix_gc() */
-		WRITE_ONCE(unix_tot_inflight, unix_tot_inflight + 1);
-	}
-	WRITE_ONCE(user->unix_inflight, user->unix_inflight + 1);
-	spin_unlock(&unix_gc_lock);
-}
-
-void unix_notinflight(struct user_struct *user, struct file *fp)
-{
-	struct unix_sock *u = unix_get_socket(fp);
-
-	spin_lock(&unix_gc_lock);
-
-	if (u) {
-		WARN_ON_ONCE(!u->inflight);
-		WARN_ON_ONCE(list_empty(&u->link));
-
-		u->inflight--;
-		if (!u->inflight)
-			list_del_init(&u->link);
-		/* Paired with READ_ONCE() in wait_for_unix_gc() */
-		WRITE_ONCE(unix_tot_inflight, unix_tot_inflight - 1);
-	}
-	WRITE_ONCE(user->unix_inflight, user->unix_inflight - 1);
-	spin_unlock(&unix_gc_lock);
-}
-
-/*
- * The "user->unix_inflight" variable is protected by the garbage
- * collection lock, and we just read it locklessly here. If you go
- * over the limit, there might be a tiny race in actually noticing
- * it across threads. Tough.
- */
-static inline bool too_many_unix_fds(struct task_struct *p)
-{
-	struct user_struct *user = current_user();
-
-	if (unlikely(READ_ONCE(user->unix_inflight) > task_rlimit(p, RLIMIT_NOFILE)))
-		return !capable(CAP_SYS_RESOURCE) && !capable(CAP_SYS_ADMIN);
-	return false;
-}
-
-int unix_attach_fds(struct scm_cookie *scm, struct sk_buff *skb)
-{
-	int i;
-
-	if (too_many_unix_fds(current))
-		return -ETOOMANYREFS;
-
-	/*
-	 * Need to duplicate file references for the sake of garbage
-	 * collection.  Otherwise a socket in the fps might become a
-	 * candidate for GC while the skb is not yet queued.
-	 */
-	UNIXCB(skb).fp = scm_fp_dup(scm->fp);
-	if (!UNIXCB(skb).fp)
-		return -ENOMEM;
-
-	for (i = scm->fp->count - 1; i >= 0; i--)
-		unix_inflight(scm->fp->user, scm->fp->fp[i]);
-	return 0;
-}
-EXPORT_SYMBOL(unix_attach_fds);
-
-void unix_detach_fds(struct scm_cookie *scm, struct sk_buff *skb)
-{
-	int i;
-
-	scm->fp = UNIXCB(skb).fp;
-	UNIXCB(skb).fp = NULL;
-
-	for (i = scm->fp->count-1; i >= 0; i--)
-		unix_notinflight(scm->fp->user, scm->fp->fp[i]);
-}
-EXPORT_SYMBOL(unix_detach_fds);
-
-void unix_destruct_scm(struct sk_buff *skb)
-{
-	struct scm_cookie scm;
-
-	memset(&scm, 0, sizeof(scm));
-	scm.pid  = UNIXCB(skb).pid;
-	if (UNIXCB(skb).fp)
-		unix_detach_fds(&scm, skb);
-
-	/* Alas, it calls VFS */
-	/* So fscking what? fput() had been SMP-safe since the last Summer */
-	scm_destroy(&scm);
-	sock_wfree(skb);
-}
-EXPORT_SYMBOL(unix_destruct_scm);
--- a/net/unix/scm.h
+++ /dev/null
@@ -1,10 +0,0 @@
-#ifndef NET_UNIX_SCM_H
-#define NET_UNIX_SCM_H
-
-extern struct list_head gc_inflight_list;
-extern spinlock_t unix_gc_lock;
-
-int unix_attach_fds(struct scm_cookie *scm, struct sk_buff *skb);
-void unix_detach_fds(struct scm_cookie *scm, struct sk_buff *skb);
-
-#endif


