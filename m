Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046373;
	b=VYpHHLfSAr51HLTZ5xZN2gfglotyw9eKDsnFd4NqgJuLBzx+cvZFUtq8+DsrdB/07WnZ
	 7Z60TbpfYUdudUOm+3RV3oaF7CQ/4/e+DiIHLdjW3qTj+Nm/haiNHw3HYXeDO9Xl1FoGA
	 TPehPQ5ZUxwIDs+ZQflaiNMZOJHeLNBDmHwJ+KyfwkNJQonbZEgcWLh9Ky5KYHXNLv0IW
	 UczwaHDd2KPB/hCLMXsgYoyDKP8d4PdMu/oK955SRWIaqQofur8JjggYVK69pxyuzn+Y/
	 frB7+bWdiwiVsMFMKrZL7Wynz3H4AKllVYiZ0vCMh/0hFY4G+95VXhy7erq1GWKeUeA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046373;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7jCzhcWie682ZMSwK+m8ncB+YkZD7JxJmtCQrQ2xyFw=;
	b=qp7kkuC2KCkEcZ3xvqiAVuiauvNQAwe4QvJT17YHbq7NPcKtxtJfgUSSVyVj9MKLUVJQ
	 KTZDFbyeuXZwC+d5NsRDOamZ9/9o4NXM3FTuVpBcP1m4R8Kh9hDpfPL6EV0lyDnSsRhGE
	 zNqe7yx47Z30TA0IwTyVIw8cRGOP4Uin1KawJ2svvpcZF4lmXgV2FOq5Xj7weIKXYZ5lE
	 I+EqnfwJnIEjD/p51pixHXS0JSJEib60O0M/nKSPqWSBEE5mVAJKrgVlyqaiWA3ZKcKq5
	 kwyGHH3PAX0WBwQjCTJfF1T+29PEkn1aQmHc1PVfI5xevoQEEutG+fSwh6vQfeUBFyQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UezzS1en;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67859606A320;
	Wed, 18 Nov 2026 23:59:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UezzS1en
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE06D1F000C5;
	Wed, 18 Nov 2026 23:59:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046373;
	bh=7jCzhcWie682ZMSwK+m8ncB+YkZD7JxJmtCQrQ2xyFw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UezzS1en2wED7YuwNUPrEJaFI4U+sAJsep6syzN3AxTgjSWV8D3wRf9Inb2z631nS
	 qsEag/ZhRRlJWh7smofU6pXpunZg1r3ng14RhxPKwE3sHcqty+s0PGEn6cMQaFVRRb
	 t5IZoh5s9c5g9tSgqxTuXXc9v9W4RQiz9vqGgeDw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cen Zhang <zzzccc427@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Heming Zhao <heming.zhao@suse.com>,
	Jia-Ju Bai <baijiaju1990@gmail.com>,
	jjzuming@gmail.com,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1259/2857] ocfs2/dlm: serialize migration MLE cleanup on failure
Date: Wed, 18 Nov 2026 15:38:13 +0100
Message-ID: <20261118150246.868765312@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

From: Cen Zhang <zzzccc427@gmail.com>

[ Upstream commit 61469249aab03799b0d3294b7a0cd25dd303017a ]

A migration MLE has a base reference for the mastering answer and an
in-use reference held by dlm_migrate_lockres(). The finishing assertion
consumes the base reference, but migration failure drops it again
without checking whether the assertion already consumed it.

The target queues its migration worker before it acknowledges the
ALL_DONE packet, so its finishing assertion can be handled while the
sender still waits for the status. If the connection fails before the
status arrives, dlm_send_one_lockres() returns an error for a migration
that the target has already completed:

  Old-master sender                  Finishing assertion
  -----------------                  -------------------
  publish MLE; take in-use reference
  send ALL_DONE; wait for status
                                     take lookup reference
                                     unlink MLE
                                     put lookup and base references
  send returns a connection error
  put base reference again; free MLE
  put in-use reference; access freed MLE

dlm_assert_master_handler() holds dlm->spinlock from the MLE lookup to
the final puts, and it takes dlm->master_lock around the unlink and the
puts. Decide under the same locks: if the MLE is already unhashed, the
assertion consumed the base reference, so drop only the sender's in-use
reference. Otherwise unlink it before consuming the base reference so a
later assertion no longer finds it.

An assertion that got there first has also made the target the owner
and cleared DLM_LOCK_RES_MIGRATING. Treating the attempt as failed at
that point would leave the lockres owned by the target while this node
still holds the other nodes' locks and refmap bits, so it could neither
be purged nor migrated again. Finish our side as a completed migration
does instead: drop those locks under res->spinlock if the target still
owns the lockres, and recalculate its usage.

Use the same cleanup for the pre-send failure, the send failure and the
target-death failure paths. The sender's in-use reference keeps the MLE
alive until its final put outside the nested locks. Successful
migration retains its existing in-use-only put.

A target that has died cannot assert after the sender has seen its
death. The o2net node-down callback runs before the DLM one; it
disconnects the node and flushes the workqueue that runs the message
handlers, so an assertion already received has been handled by the time
the DLM removes the node from the domain map. A node that leaves the
domain cleanly sends its exit message only after its assertions have
been answered.

Two windows of the hand-over itself are left as they are: the handler
switches the owner and the sender drops the other nodes' locks moments
later, and an assertion from a live target that arrives after the
sender has given up still meets the owner check in the handler. Waiting
for the target before giving up would only stretch the first window
into the time in which recovery of the target can observe it.

KASAN report, only the relevant frames are kept:

BUG: KASAN: slab-use-after-free in dlm_put_mle_inuse+0xce/0xe0
Read of size 8 at addr ffff8881190e3c20 by task umount/593

Call Trace:
 <TASK>
 dlm_put_mle_inuse+0xce/0xe0
 dlm_migrate_lockres+0x16af/0x20d0
 dlm_empty_lockres+0x60a/0xbd0
 dlm_unregister_domain+0x53b/0x11d0
 o2cb_cluster_disconnect+0xa5/0x110
 ocfs2_cluster_disconnect+0x73/0xc0
 ocfs2_dlm_shutdown+0x311/0x440
 ocfs2_dismount_volume+0x696/0x940
 generic_shutdown_super+0x15f/0x490
 kill_block_super+0x40/0xa0
 deactivate_locked_super+0xae/0x120
 deactivate_super+0xa2/0xc0
 cleanup_mnt+0x217/0x450
 task_work_run+0x144/0x230
 </TASK>

Allocated by task 593:
 kmem_cache_alloc_noprof+0x20b/0x5c0
 dlm_migrate_lockres+0x20e/0x20d0
 dlm_empty_lockres+0x60a/0xbd0
 dlm_unregister_domain+0x53b/0x11d0
 o2cb_cluster_disconnect+0xa5/0x110
 ocfs2_cluster_disconnect+0x73/0xc0
 ocfs2_dlm_shutdown+0x311/0x440
 ocfs2_dismount_volume+0x696/0x940

Freed by task 593:
 kmem_cache_free+0x242/0x580
 __dlm_put_mle+0x4b2/0x660
 dlm_migrate_lockres+0x1690/0x20d0
 dlm_empty_lockres+0x60a/0xbd0
 dlm_unregister_domain+0x53b/0x11d0
 o2cb_cluster_disconnect+0xa5/0x110
 ocfs2_cluster_disconnect+0x73/0xc0
 ocfs2_dlm_shutdown+0x311/0x440

The buggy address belongs to the object at ffff8881190e3c00
 which belongs to the cache o2dlm_mle of size 480
The buggy address is located 32 bytes inside of
 freed 480-byte region [ffff8881190e3c00, ffff8881190e3de0)

Link: https://lore.kernel.org/pm-ocfs2-objects-candidate-0038-v9-659f247ea980d5f3fbeb@gmail.com
Fixes: 6714d8e86bf4 ("[PATCH] OCFS2: The Second Oracle Cluster Filesystem")
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Assisted-by: LLM
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: Jia-Ju Bai <baijiaju1990@gmail.com>
Cc: <jjzuming@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ocfs2/dlm/dlmmaster.c | 70 ++++++++++++++++++++++++++++++++++------
 1 file changed, 61 insertions(+), 9 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
index efa6493f485fb..09a17a457324e 100644
--- a/fs/ocfs2/dlm/dlmmaster.c
+++ b/fs/ocfs2/dlm/dlmmaster.c
@@ -2537,6 +2537,52 @@ static int dlm_is_lockres_migratable(struct dlm_ctxt *dlm,
  */
 
 
+/*
+ * Drop the sender's references on a migration MLE after the attempt has
+ * failed. The finishing assert from the target may already have unlinked
+ * the MLE and consumed its base reference; decide under the locks the
+ * assert handler holds, and only drop the base reference while the MLE is
+ * still hashed. Returns true when the assert got there first: the target
+ * has become the master, so the caller must complete the migration.
+ */
+static bool dlm_put_migration_mle(struct dlm_ctxt *dlm,
+				  struct dlm_master_list_entry *mle)
+{
+	bool asserted;
+
+	spin_lock(&dlm->spinlock);
+	spin_lock(&dlm->master_lock);
+	__dlm_mle_detach_hb_events(dlm, mle);
+	asserted = hlist_unhashed(&mle->master_hash_node);
+	if (!asserted) {
+		__dlm_unlink_mle(dlm, mle);
+		__dlm_put_mle(mle);
+	}
+	spin_unlock(&dlm->master_lock);
+	spin_unlock(&dlm->spinlock);
+
+	dlm_put_mle_inuse(mle);
+	return asserted;
+}
+
+/*
+ * The finishing assert got there first: it switched the owner to the
+ * target and cleared DLM_LOCK_RES_MIGRATING. Drop the other nodes' locks
+ * as a completed migration does, unless recovery has taken the lockres
+ * over since, and let the usage be recalculated.
+ */
+static void dlm_migrate_lockres_asserted(struct dlm_ctxt *dlm,
+					 struct dlm_lock_resource *res,
+					 u8 target)
+{
+	spin_lock(&res->spinlock);
+	if (res->owner == target)
+		dlm_remove_nonlocal_locks(dlm, res);
+	spin_unlock(&res->spinlock);
+
+	dlm_lockres_calc_usage(dlm, res);
+}
+
 static int dlm_migrate_lockres(struct dlm_ctxt *dlm,
 			       struct dlm_lock_resource *res, u8 target)
 {
@@ -2621,9 +2667,10 @@ static int dlm_migrate_lockres(struct dlm_ctxt *dlm,
 
 	if (ret < 0) {
 		if (mle_added) {
-			dlm_mle_detach_hb_events(dlm, mle);
-			dlm_put_mle(mle);
-			dlm_put_mle_inuse(mle);
+			if (dlm_put_migration_mle(dlm, mle)) {
+				dlm_migrate_lockres_asserted(dlm, res, target);
+				ret = 0;
+			}
 		} else if (mle) {
 			kmem_cache_free(dlm_mle_cache, mle);
 			mle = NULL;
@@ -2652,9 +2699,11 @@ static int dlm_migrate_lockres(struct dlm_ctxt *dlm,
 		mlog(0, "migration to node %u failed with %d\n",
 		     target, ret);
 		/* migration failed, detach and clean up mle */
-		dlm_mle_detach_hb_events(dlm, mle);
-		dlm_put_mle(mle);
-		dlm_put_mle_inuse(mle);
+		if (dlm_put_migration_mle(dlm, mle)) {
+			dlm_migrate_lockres_asserted(dlm, res, target);
+			ret = 0;
+			goto leave;
+		}
 		spin_lock(&res->spinlock);
 		res->state &= ~DLM_LOCK_RES_MIGRATING;
 		wake = 1;
@@ -2698,9 +2747,12 @@ static int dlm_migrate_lockres(struct dlm_ctxt *dlm,
 				     res->lockname.name, target);
 				ret = -EINVAL;
 				/* migration failed, detach and clean up mle */
-				dlm_mle_detach_hb_events(dlm, mle);
-				dlm_put_mle(mle);
-				dlm_put_mle_inuse(mle);
+				if (dlm_put_migration_mle(dlm, mle)) {
+					dlm_migrate_lockres_asserted(dlm, res,
+								     target);
+					ret = 0;
+					goto leave;
+				}
 				spin_lock(&res->spinlock);
 				res->state &= ~DLM_LOCK_RES_MIGRATING;
 				wake = 1;
-- 
2.53.0



