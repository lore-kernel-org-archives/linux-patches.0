Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EC3442DA53;
	Tue, 21 Jul 2026 19:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661355; cv=none; b=l/ReAn9UysM+D2VHTt+w5M7N6SD5+uaJm+Tx63fx5my7kigofvRAkHGSwMewKrGTHiDfF+x/pKce0vOyFSIEQdT+zFY0CiYDZvonTaiSpaIC2lfXqswVWiKNuEGF5qwNb4/7ogAGfnU6gbL5TPLkU0MUaERAMFiwNKuBATGqBbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661355; c=relaxed/simple;
	bh=iXxLPTEez78cVq+WW+jmy0hWeV+bHndlqe48gzofxJo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UOjPt/HYxZNRzzAnuB/Hgk+ek/fPzo0WoFMzRWv3y66BVyUM+0HG2Ye48FmR6XQwiBAVeTdAesKP6BT+YHdo9VTzFU9Oz0tGRCT5BvjG/PV/qBjUBAoJz0RF497gg5rGH9XOdBG15WTfsYhJa0qXmvwMD++sdH8U1UOWqZTj0gU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e4HocNbu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e4HocNbu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A64DA1F000E9;
	Tue, 21 Jul 2026 19:15:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661354;
	bh=Nb1MlkBOPyJyTVDRapJzxgXI6tLRMBAfXV8+pnTp0GU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e4HocNbu3Lgls8Trz/lDz3/p/Pm3wfIaVLUVmPAxhQKo+77ZJQxyhW60vOQel8zOm
	 p5j7zYhtZkvR7jRyoVs1cEGZR34XRY0hYKxYX293oBlS8KerPbJQmrM3lLcOUyc2fb
	 21UceoMBxnyI2UetWdWOT1BYn6ZWwwGSJJFqdqcQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xingyu Jin <xingyuj@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Heiko Stuebner <heiko.stuebner@cherry.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0034/1276] af_unix: Drop all SCM attributes for SOCKMAP.
Date: Tue, 21 Jul 2026 17:07:57 +0200
Message-ID: <20260721152446.847839154@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@google.com>

[ Upstream commit 965dc93481d1b80d341bdd16c27b16fe197175ee ]

SOCKMAP can hide inflight fd from AF_UNIX GC.

When a socket in SOCKMAP receives skb with inflight fd,
sk_psock_verdict_data_ready() looks up the mapped socket and
enqueue skb to its psock->ingress_skb.

Since neither the old nor the new GC can inspect the psock
queue, the hidden skb leaks the inflight sockets.  Note that
this cannot be detected via kmemleak because inflight sockets
are linked to a global list.

In addition, SOCKMAP redirect breaks the Tarjan-based GC's
assumption that unix_edge.successor is always alive, which
is no longer true once skb is redirected, resulting in
use-after-free below. [0]

Moreover, SOCKMAP does not call scm_stat_del() properly,
so unix_show_fdinfo() could report an incorrect fd count.

sk_msg_recvmsg() does not support any SCM attributes in the
first place.

Let's drop all SCM attributes before passing skb to the
SOCKMAP layer.

[0]:
BUG: KASAN: slab-use-after-free in unix_del_edges (net/unix/garbage.c:118 net/unix/garbage.c:181 net/unix/garbage.c:251)
Read of size 8 at addr ffff888125362670 by task kworker/56:1/496

CPU: 56 UID: 0 PID: 496 Comm: kworker/56:1 Not tainted 7.0.0-rc7-00263-gb9d8b856689d #3 PREEMPT(lazy)
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.17.0-debian-1.17.0-1 04/01/2014
Workqueue: events sk_psock_backlog
Call Trace:
 <TASK>
 dump_stack_lvl (lib/dump_stack.c:122)
 print_report (mm/kasan/report.c:379)
 kasan_report (mm/kasan/report.c:597)
 unix_del_edges (net/unix/garbage.c:118 net/unix/garbage.c:181 net/unix/garbage.c:251)
 unix_destroy_fpl (net/unix/garbage.c:317)
 unix_destruct_scm (./include/net/scm.h:80 ./include/net/scm.h:86 net/unix/af_unix.c:1976)
 sk_psock_backlog (./include/linux/skbuff.h:?)
 process_scheduled_works (kernel/workqueue.c:?)
 worker_thread (kernel/workqueue.c:?)
 kthread (kernel/kthread.c:438)
 ret_from_fork (arch/x86/kernel/process.c:164)
 ret_from_fork_asm (arch/x86/entry/entry_64.S:258)
 </TASK>

Allocated by task 955:
 kasan_save_track (mm/kasan/common.c:58 mm/kasan/common.c:78)
 __kasan_slab_alloc (mm/kasan/common.c:369)
 kmem_cache_alloc_noprof (mm/slub.c:4539)
 sk_prot_alloc (net/core/sock.c:2240)
 sk_alloc (net/core/sock.c:2301)
 unix_create1 (net/unix/af_unix.c:1099)
 unix_create (net/unix/af_unix.c:1169)
 __sock_create (net/socket.c:1606)
 __sys_socketpair (net/socket.c:1811)
 __x64_sys_socketpair (net/socket.c:1863 net/socket.c:1860 net/socket.c:1860)
 do_syscall_64 (arch/x86/entry/syscall_64.c:?)
 entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:130)

Freed by task 496:
 kasan_save_track (mm/kasan/common.c:58 mm/kasan/common.c:78)
 kasan_save_free_info (mm/kasan/generic.c:587)
 __kasan_slab_free (mm/kasan/common.c:287)
 kmem_cache_free (mm/slub.c:6165)
 __sk_destruct (net/core/sock.c:2282 net/core/sock.c:2384)
 sk_psock_destroy (./include/net/sock.h:?)
 process_scheduled_works (kernel/workqueue.c:?)
 worker_thread (kernel/workqueue.c:?)
 kthread (kernel/kthread.c:438)
 ret_from_fork (arch/x86/kernel/process.c:164)
 ret_from_fork_asm (arch/x86/entry/entry_64.S:258)

Fixes: c63829182c37 ("af_unix: Implement ->psock_update_sk_prot()")
Fixes: 77462de14a43 ("af_unix: Add read_sock for stream socket types")
Reported-by: Xingyu Jin <xingyuj@google.com>
Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20260415184830.3988432-1-kuniyu@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Heiko Stuebner <heiko.stuebner@cherry.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/unix/af_unix.c | 35 +++++++++++++++++++++++++++--------
 1 file changed, 27 insertions(+), 8 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index f1e81843c1b0bc..23d94a08e48157 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -1884,16 +1884,19 @@ static void unix_peek_fds(struct scm_cookie *scm, struct sk_buff *skb)
 
 static void unix_destruct_scm(struct sk_buff *skb)
 {
-	struct scm_cookie scm;
+	struct scm_cookie scm = {};
+
+	swap(scm.pid, UNIXCB(skb).pid);
 
-	memset(&scm, 0, sizeof(scm));
-	scm.pid = UNIXCB(skb).pid;
 	if (UNIXCB(skb).fp)
 		unix_detach_fds(&scm, skb);
 
-	/* Alas, it calls VFS */
-	/* So fscking what? fput() had been SMP-safe since the last Summer */
 	scm_destroy(&scm);
+}
+
+static void unix_wfree(struct sk_buff *skb)
+{
+	unix_destruct_scm(skb);
 	sock_wfree(skb);
 }
 
@@ -1909,7 +1912,7 @@ static int unix_scm_to_skb(struct scm_cookie *scm, struct sk_buff *skb, bool sen
 	if (scm->fp && send_fds)
 		err = unix_attach_fds(scm, skb);
 
-	skb->destructor = unix_destruct_scm;
+	skb->destructor = unix_wfree;
 	return err;
 }
 
@@ -1970,6 +1973,13 @@ static void scm_stat_del(struct sock *sk, struct sk_buff *skb)
 	}
 }
 
+static void unix_orphan_scm(struct sock *sk, struct sk_buff *skb)
+{
+	scm_stat_del(sk, skb);
+	unix_destruct_scm(skb);
+	skb->destructor = sock_wfree;
+}
+
 /*
  *	Send AF_UNIX data.
  */
@@ -2556,10 +2566,16 @@ static int unix_read_skb(struct sock *sk, skb_read_actor_t recv_actor)
 	int err;
 
 	mutex_lock(&u->iolock);
+
 	skb = skb_recv_datagram(sk, MSG_DONTWAIT, &err);
-	mutex_unlock(&u->iolock);
-	if (!skb)
+	if (!skb) {
+		mutex_unlock(&u->iolock);
 		return err;
+	}
+
+	unix_orphan_scm(sk, skb);
+
+	mutex_unlock(&u->iolock);
 
 	return recv_actor(sk, skb);
 }
@@ -2754,6 +2770,9 @@ static int unix_stream_read_skb(struct sock *sk, skb_read_actor_t recv_actor)
 #endif
 
 	spin_unlock(&queue->lock);
+
+	unix_orphan_scm(sk, skb);
+
 	mutex_unlock(&u->iolock);
 
 	return recv_actor(sk, skb);
-- 
2.53.0



