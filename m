Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53B5014A088;
	Tue,  3 Dec 2024 16:03:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241833; cv=none; b=XQo34G5RmDXwREQF+VMNUILHzm/JJP4BJ3Gb5V4SaIn04DIExU0M4CKT+sphbCWfrEFZ/tUW/3lF63hI0FWnkXO0AzAvWKsE6bC3R0hWGFB4Y/PUBvoDerDEW7s/imlNv1VrkoA8zN0S1Vg2o8xaAPES9Ny51BLQctM25T0cOXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241833; c=relaxed/simple;
	bh=AW+yEfk+Dkp3cGpqJs/9OXCTmTOK8SseymNoFe5SPO0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i6eWR0UAkog8+3NOw4/9aIRdijoykoD5wI2Op7Q99J8zrKfa0Ga+r6UFr64R3M0589fWUcP9wCCr5S97Lb8lRHwJgVTPGd2xLpV0yfpz1rs2Ytdty9HCVoov1IlqXF4YqeXISrmN8cwe6s8RiyueXJ3QvwY1vC2Jqyn1oeHoZkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M8DcWP10; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M8DcWP10"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2815C4CECF;
	Tue,  3 Dec 2024 16:03:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241833;
	bh=AW+yEfk+Dkp3cGpqJs/9OXCTmTOK8SseymNoFe5SPO0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M8DcWP10qf1mB0OnUmwQtbUmSow9EYqH+BZ5A772FFXkzkGCELqIJUk3xN8BbXFcM
	 waK9SUNrr/vw1ErGZUIiWe/2QxI6ZVrznUjn9ir2c1lf7o45N1b7HFvbI3pjrYqp5U
	 spS7FSGeo05tJ0JAn8Enrjs9j2Huopzy1SVm1ICw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Snitzer <snitzer@kernel.org>,
	NeilBrown <neilb@suse.de>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 530/826] nfs_common: must not hold RCU while calling nfsd_file_put_local
Date: Tue,  3 Dec 2024 15:44:17 +0100
Message-ID: <20241203144804.429923001@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Snitzer <snitzer@kernel.org>

[ Upstream commit c840b8e1f039e90f97ca55525667eb961422f86c ]

Move holding the RCU from nfs_to_nfsd_file_put_local to
nfs_to_nfsd_net_put.  It is the call to nfs_to->nfsd_serv_put that
requires the RCU anyway (the puts for nfsd_file and netns were
combined to avoid an extra indirect reference but that
micro-optimization isn't possible now).

This fixes xfstests generic/013 and it triggering:

"Voluntary context switch within RCU read-side critical section!"

[  143.545738] Call Trace:
[  143.546206]  <TASK>
[  143.546625]  ? show_regs+0x6d/0x80
[  143.547267]  ? __warn+0x91/0x140
[  143.547951]  ? rcu_note_context_switch+0x496/0x5d0
[  143.548856]  ? report_bug+0x193/0x1a0
[  143.549557]  ? handle_bug+0x63/0xa0
[  143.550214]  ? exc_invalid_op+0x1d/0x80
[  143.550938]  ? asm_exc_invalid_op+0x1f/0x30
[  143.551736]  ? rcu_note_context_switch+0x496/0x5d0
[  143.552634]  ? wakeup_preempt+0x62/0x70
[  143.553358]  __schedule+0xaa/0x1380
[  143.554025]  ? _raw_spin_unlock_irqrestore+0x12/0x40
[  143.554958]  ? try_to_wake_up+0x1fe/0x6b0
[  143.555715]  ? wake_up_process+0x19/0x20
[  143.556452]  schedule+0x2e/0x120
[  143.557066]  schedule_preempt_disabled+0x19/0x30
[  143.557933]  rwsem_down_read_slowpath+0x24d/0x4a0
[  143.558818]  ? xfs_efi_item_format+0x50/0xc0 [xfs]
[  143.559894]  down_read+0x4e/0xb0
[  143.560519]  xlog_cil_commit+0x1b2/0xbc0 [xfs]
[  143.561460]  ? _raw_spin_unlock+0x12/0x30
[  143.562212]  ? xfs_inode_item_precommit+0xc7/0x220 [xfs]
[  143.563309]  ? xfs_trans_run_precommits+0x69/0xd0 [xfs]
[  143.564394]  __xfs_trans_commit+0xb5/0x330 [xfs]
[  143.565367]  xfs_trans_roll+0x48/0xc0 [xfs]
[  143.566262]  xfs_defer_trans_roll+0x57/0x100 [xfs]
[  143.567278]  xfs_defer_finish_noroll+0x27a/0x490 [xfs]
[  143.568342]  xfs_defer_finish+0x1a/0x80 [xfs]
[  143.569267]  xfs_bunmapi_range+0x4d/0xb0 [xfs]
[  143.570208]  xfs_itruncate_extents_flags+0x13d/0x230 [xfs]
[  143.571353]  xfs_free_eofblocks+0x12e/0x190 [xfs]
[  143.572359]  xfs_file_release+0x12d/0x140 [xfs]
[  143.573324]  __fput+0xe8/0x2d0
[  143.573922]  __fput_sync+0x1d/0x30
[  143.574574]  nfsd_filp_close+0x33/0x60 [nfsd]
[  143.575430]  nfsd_file_free+0x96/0x150 [nfsd]
[  143.576274]  nfsd_file_put+0xf7/0x1a0 [nfsd]
[  143.577104]  nfsd_file_put_local+0x18/0x30 [nfsd]
[  143.578070]  nfs_close_local_fh+0x101/0x110 [nfs_localio]
[  143.579079]  __put_nfs_open_context+0xc9/0x180 [nfs]
[  143.580031]  nfs_file_clear_open_context+0x4a/0x60 [nfs]
[  143.581038]  nfs_file_release+0x3e/0x60 [nfs]
[  143.581879]  __fput+0xe8/0x2d0
[  143.582464]  __fput_sync+0x1d/0x30
[  143.583108]  __x64_sys_close+0x41/0x80
[  143.583823]  x64_sys_call+0x189a/0x20d0
[  143.584552]  do_syscall_64+0x64/0x170
[  143.585240]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[  143.586185] RIP: 0033:0x7f3c5153efd7

Fixes: 65f2a5c36635 ("nfs_common: fix race in NFS calls to nfsd_file_put_local() and nfsd_serv_put()")
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Reviewed-by: NeilBrown <neilb@suse.de>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs_common/nfslocalio.c |  8 +++-----
 fs/nfsd/filecache.c        | 14 +++++++-------
 fs/nfsd/filecache.h        |  2 +-
 include/linux/nfslocalio.h | 18 +++++++++++++++---
 4 files changed, 26 insertions(+), 16 deletions(-)

diff --git a/fs/nfs_common/nfslocalio.c b/fs/nfs_common/nfslocalio.c
index 09404d142d1ae..a74ec08f6c96d 100644
--- a/fs/nfs_common/nfslocalio.c
+++ b/fs/nfs_common/nfslocalio.c
@@ -155,11 +155,9 @@ struct nfsd_file *nfs_open_local_fh(nfs_uuid_t *uuid,
 	/* We have an implied reference to net thanks to nfsd_serv_try_get */
 	localio = nfs_to->nfsd_open_local_fh(net, uuid->dom, rpc_clnt,
 					     cred, nfs_fh, fmode);
-	if (IS_ERR(localio)) {
-		rcu_read_lock();
-		nfs_to->nfsd_serv_put(net);
-		rcu_read_unlock();
-	}
+	if (IS_ERR(localio))
+		nfs_to_nfsd_net_put(net);
+
 	return localio;
 }
 EXPORT_SYMBOL_GPL(nfs_open_local_fh);
diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index 2e6783f637124..146a9463c3c23 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -391,19 +391,19 @@ nfsd_file_put(struct nfsd_file *nf)
 }
 
 /**
- * nfsd_file_put_local - put the reference to nfsd_file and local nfsd_serv
- * @nf: nfsd_file of which to put the references
+ * nfsd_file_put_local - put nfsd_file reference and arm nfsd_serv_put in caller
+ * @nf: nfsd_file of which to put the reference
  *
- * First put the reference of the nfsd_file and then put the
- * reference to the associated nn->nfsd_serv.
+ * First save the associated net to return to caller, then put
+ * the reference of the nfsd_file.
  */
-void
-nfsd_file_put_local(struct nfsd_file *nf) __must_hold(rcu)
+struct net *
+nfsd_file_put_local(struct nfsd_file *nf)
 {
 	struct net *net = nf->nf_net;
 
 	nfsd_file_put(nf);
-	nfsd_serv_put(net);
+	return net;
 }
 
 /**
diff --git a/fs/nfsd/filecache.h b/fs/nfsd/filecache.h
index cadf3c2689c44..d5db6b34ba302 100644
--- a/fs/nfsd/filecache.h
+++ b/fs/nfsd/filecache.h
@@ -55,7 +55,7 @@ void nfsd_file_cache_shutdown(void);
 int nfsd_file_cache_start_net(struct net *net);
 void nfsd_file_cache_shutdown_net(struct net *net);
 void nfsd_file_put(struct nfsd_file *nf);
-void nfsd_file_put_local(struct nfsd_file *nf);
+struct net *nfsd_file_put_local(struct nfsd_file *nf);
 struct nfsd_file *nfsd_file_get(struct nfsd_file *nf);
 struct file *nfsd_file_file(struct nfsd_file *nf);
 void nfsd_file_close_inode_sync(struct inode *inode);
diff --git a/include/linux/nfslocalio.h b/include/linux/nfslocalio.h
index 3982fea799195..9202f4b24343d 100644
--- a/include/linux/nfslocalio.h
+++ b/include/linux/nfslocalio.h
@@ -55,7 +55,7 @@ struct nfsd_localio_operations {
 						const struct cred *,
 						const struct nfs_fh *,
 						const fmode_t);
-	void (*nfsd_file_put_local)(struct nfsd_file *);
+	struct net *(*nfsd_file_put_local)(struct nfsd_file *);
 	struct file *(*nfsd_file_file)(struct nfsd_file *);
 } ____cacheline_aligned;
 
@@ -66,7 +66,7 @@ struct nfsd_file *nfs_open_local_fh(nfs_uuid_t *,
 		   struct rpc_clnt *, const struct cred *,
 		   const struct nfs_fh *, const fmode_t);
 
-static inline void nfs_to_nfsd_file_put_local(struct nfsd_file *localio)
+static inline void nfs_to_nfsd_net_put(struct net *net)
 {
 	/*
 	 * Once reference to nfsd_serv is dropped, NFSD could be
@@ -74,10 +74,22 @@ static inline void nfs_to_nfsd_file_put_local(struct nfsd_file *localio)
 	 * by always taking RCU.
 	 */
 	rcu_read_lock();
-	nfs_to->nfsd_file_put_local(localio);
+	nfs_to->nfsd_serv_put(net);
 	rcu_read_unlock();
 }
 
+static inline void nfs_to_nfsd_file_put_local(struct nfsd_file *localio)
+{
+	/*
+	 * Must not hold RCU otherwise nfsd_file_put() can easily trigger:
+	 * "Voluntary context switch within RCU read-side critical section!"
+	 * by scheduling deep in underlying filesystem (e.g. XFS).
+	 */
+	struct net *net = nfs_to->nfsd_file_put_local(localio);
+
+	nfs_to_nfsd_net_put(net);
+}
+
 #else   /* CONFIG_NFS_LOCALIO */
 static inline void nfsd_localio_ops_init(void)
 {
-- 
2.43.0



