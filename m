Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96DA22153DD;
	Thu, 12 Dec 2024 17:03:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022996; cv=none; b=thKa4JOHvtNdWC4h7wRjqED77iUl4ajTfI/SxS0bEHM4mEHG6qGrq3sF1wxUnyy8rzefofO6Xxz0+4/ks2qpaDquX3vH5yPnYTrSeoDji2oIWnyZAt1N+ngMdOxaMrn/n03THwcX2Yo1ObcRC8UZFLxK9cDRSVPU15K9tbJOsiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022996; c=relaxed/simple;
	bh=J/ycpQHBRePPONtvCAay/uW/MnmAPlZdBQgdbclyzUc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wj7QVbyBQQQP5LKJgp/NU7aWdqHck3Hvouj8NRWxsLbCwLm3x9l+02ma2aQCFDHvvM/jmCQ1VSpKS+5/0D5JsJzrGYG2rLEmpDwRuBDrxLdtQ50Fr+RHH9TBYH966z3aSuIHYs8ZCvw/FX9h8fsUmThFBXkodJuAHDRgB1eW2yM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qlXmUULG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qlXmUULG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ED11C4CECE;
	Thu, 12 Dec 2024 17:03:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022996;
	bh=J/ycpQHBRePPONtvCAay/uW/MnmAPlZdBQgdbclyzUc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qlXmUULGUpe6kk0YaqMkaJwo1iURUxFknUatt4zHdVGgNv1Bk6zWTlQ5RAdzFBC+B
	 Z/Lw83L5yeNiynke3alvXsh/Phzldxt36v5rkBH96bomdeZWhdiX66tYmK0aJwIdul
	 ij+xC+NOUNJB8Qc8kHJwaQwEv5gzwtigDM3/V4Do=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Yang Erkun <yangerkun@huawei.com>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 392/565] nfsd: fix nfs4_openowner leak when concurrent nfsd4_open occur
Date: Thu, 12 Dec 2024 15:59:47 +0100
Message-ID: <20241212144327.139373280@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

From: Yang Erkun <yangerkun@huawei.com>

commit 98100e88dd8865999dc6379a3356cd799795fe7b upstream.

The action force umount(umount -f) will attempt to kill all rpc_task even
umount operation may ultimately fail if some files remain open.
Consequently, if an action attempts to open a file, it can potentially
send two rpc_task to nfs server.

                   NFS CLIENT
thread1                             thread2
open("file")
...
nfs4_do_open
 _nfs4_do_open
  _nfs4_open_and_get_state
   _nfs4_proc_open
    nfs4_run_open_task
     /* rpc_task1 */
     rpc_run_task
     rpc_wait_for_completion_task

                                    umount -f
                                    nfs_umount_begin
                                     rpc_killall_tasks
                                      rpc_signal_task
     rpc_task1 been wakeup
     and return -512
 _nfs4_do_open // while loop
    ...
    nfs4_run_open_task
     /* rpc_task2 */
     rpc_run_task
     rpc_wait_for_completion_task

While processing an open request, nfsd will first attempt to find or
allocate an nfs4_openowner. If it finds an nfs4_openowner that is not
marked as NFS4_OO_CONFIRMED, this nfs4_openowner will released. Since
two rpc_task can attempt to open the same file simultaneously from the
client to server, and because two instances of nfsd can run
concurrently, this situation can lead to lots of memory leak.
Additionally, when we echo 0 to /proc/fs/nfsd/threads, warning will be
triggered.

                    NFS SERVER
nfsd1                  nfsd2       echo 0 > /proc/fs/nfsd/threads

nfsd4_open
 nfsd4_process_open1
  find_or_alloc_open_stateowner
   // alloc oo1, stateid1
                       nfsd4_open
                        nfsd4_process_open1
                        find_or_alloc_open_stateowner
                        // find oo1, without NFS4_OO_CONFIRMED
                         release_openowner
                          unhash_openowner_locked
                          list_del_init(&oo->oo_perclient)
                          // cannot find this oo
                          // from client, LEAK!!!
                         alloc_stateowner // alloc oo2

 nfsd4_process_open2
  init_open_stateid
  // associate oo1
  // with stateid1, stateid1 LEAK!!!
  nfs4_get_vfs_file
  // alloc nfsd_file1 and nfsd_file_mark1
  // all LEAK!!!

                         nfsd4_process_open2
                         ...

                                    write_threads
                                     ...
                                     nfsd_destroy_serv
                                      nfsd_shutdown_net
                                       nfs4_state_shutdown_net
                                        nfs4_state_destroy_net
                                         destroy_client
                                          __destroy_client
                                          // won't find oo1!!!
                                     nfsd_shutdown_generic
                                      nfsd_file_cache_shutdown
                                       kmem_cache_destroy
                                       for nfsd_file_slab
                                       and nfsd_file_mark_slab
                                       // bark since nfsd_file1
                                       // and nfsd_file_mark1
                                       // still alive

=======================================================================
BUG nfsd_file (Not tainted): Objects remaining in nfsd_file on
__kmem_cache_shutdown()
-----------------------------------------------------------------------

Slab 0xffd4000004438a80 objects=34 used=1 fp=0xff11000110e2ad28
flags=0x17ffffc0000240(workingset|head|node=0|zone=2|lastcpupid=0x1fffff)
CPU: 4 UID: 0 PID: 757 Comm: sh Not tainted 6.12.0-rc6+ #19
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
1.16.1-2.fc37 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0x53/0x70
 slab_err+0xb0/0xf0
 __kmem_cache_shutdown+0x15c/0x310
 kmem_cache_destroy+0x66/0x160
 nfsd_file_cache_shutdown+0xac/0x210 [nfsd]
 nfsd_destroy_serv+0x251/0x2a0 [nfsd]
 nfsd_svc+0x125/0x1e0 [nfsd]
 write_threads+0x16a/0x2a0 [nfsd]
 nfsctl_transaction_write+0x74/0xa0 [nfsd]
 vfs_write+0x1ae/0x6d0
 ksys_write+0xc1/0x160
 do_syscall_64+0x5f/0x170
 entry_SYSCALL_64_after_hwframe+0x76/0x7e

Disabling lock debugging due to kernel taint
Object 0xff11000110e2ac38 @offset=3128
Allocated in nfsd_file_do_acquire+0x20f/0xa30 [nfsd] age=1635 cpu=3
pid=800
 nfsd_file_do_acquire+0x20f/0xa30 [nfsd]
 nfsd_file_acquire_opened+0x5f/0x90 [nfsd]
 nfs4_get_vfs_file+0x4c9/0x570 [nfsd]
 nfsd4_process_open2+0x713/0x1070 [nfsd]
 nfsd4_open+0x74b/0x8b0 [nfsd]
 nfsd4_proc_compound+0x70b/0xc20 [nfsd]
 nfsd_dispatch+0x1b4/0x3a0 [nfsd]
 svc_process_common+0x5b8/0xc50 [sunrpc]
 svc_process+0x2ab/0x3b0 [sunrpc]
 svc_handle_xprt+0x681/0xa20 [sunrpc]
 nfsd+0x183/0x220 [nfsd]
 kthread+0x199/0x1e0
 ret_from_fork+0x31/0x60
 ret_from_fork_asm+0x1a/0x30

Add nfs4_openowner_unhashed to help found unhashed nfs4_openowner, and
break nfsd4_open process to fix this problem.

Cc: stable@vger.kernel.org # v5.4+
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Yang Erkun <yangerkun@huawei.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4state.c |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -1628,6 +1628,14 @@ static void release_open_stateid(struct
 	free_ol_stateid_reaplist(&reaplist);
 }
 
+static bool nfs4_openowner_unhashed(struct nfs4_openowner *oo)
+{
+	lockdep_assert_held(&oo->oo_owner.so_client->cl_lock);
+
+	return list_empty(&oo->oo_owner.so_strhash) &&
+		list_empty(&oo->oo_perclient);
+}
+
 static void unhash_openowner_locked(struct nfs4_openowner *oo)
 {
 	struct nfs4_client *clp = oo->oo_owner.so_client;
@@ -4638,6 +4646,12 @@ retry:
 	spin_lock(&oo->oo_owner.so_client->cl_lock);
 	spin_lock(&fp->fi_lock);
 
+	if (nfs4_openowner_unhashed(oo)) {
+		mutex_unlock(&stp->st_mutex);
+		stp = NULL;
+		goto out_unlock;
+	}
+
 	retstp = nfsd4_find_existing_open(fp, open);
 	if (retstp)
 		goto out_unlock;
@@ -5712,6 +5726,11 @@ nfsd4_process_open2(struct svc_rqst *rqs
 
 	if (!stp) {
 		stp = init_open_stateid(fp, open);
+		if (!stp) {
+			status = nfserr_jukebox;
+			goto out;
+		}
+
 		if (!open->op_stp)
 			new_stp = true;
 	}


