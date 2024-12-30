Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 947EA15E8B;
	Mon, 30 Dec 2024 15:48:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735573687; cv=none; b=iE2DqIjZT/MtIBaODfAr2tcn0cAb/+PP9Wzx16XVarWhOGRcHw7p/d7diA2yPOdMNmLxGQuxRCbL8L98rC+eQ7AkuKHpaHQTjTxLox7gZc7kBW/hZX0t8767s5LL7QJH2QT6YSoy5GBz/UMYDjUS0Pn7Qshj9vb8YYjsE/dtgRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735573687; c=relaxed/simple;
	bh=fTcNwy8hpoLBfTaxW1rkTSNPF60QblT0rR5h5h06m14=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P+xjUYwNMgxLlXPDSjXuSIyG/r55EQnfSWkBG0hUQj0aojZRqkRCU7pUplfmgXwTQhsNWbS2hFSK2jx9T7E8o43hHwEeP8K0IKAx170MXmkd7opmE0p0oCUD57bikorTf2GQa43oztnjzb1k8lFELo+rn0KDvXKb3KBFfjWOluM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cvqYI9Ox; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cvqYI9Ox"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12B43C4CED0;
	Mon, 30 Dec 2024 15:48:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735573687;
	bh=fTcNwy8hpoLBfTaxW1rkTSNPF60QblT0rR5h5h06m14=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cvqYI9OxCJJcA+RszRKCY9gHGzw1vA2FRG6CjS9kiNOIshAq6ooVo5xI55qBMsKUW
	 wNWL4nzjJDkaBpV9dtt43neqEjxr/1CgUgb4XcYPBAHfWMng2gfv4VLMck/BMC2SVu
	 EoP06kRV89FAvdQEWxl4ybDbt4L77kqzbdKZVwto=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Erkun <yangerkun@huaweicloud.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.1 58/60] nfsd: cancel nfsd_shrinker_work using sync mode in nfs4_state_shutdown_net
Date: Mon, 30 Dec 2024 16:43:08 +0100
Message-ID: <20241230154209.482686736@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154207.276570972@linuxfoundation.org>
References: <20241230154207.276570972@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Erkun <yangerkun@huaweicloud.com>

commit d5ff2fb2e7167e9483846e34148e60c0c016a1f6 upstream.

In the normal case, when we excute `echo 0 > /proc/fs/nfsd/threads`, the
function `nfs4_state_destroy_net` in `nfs4_state_shutdown_net` will
release all resources related to the hashed `nfs4_client`. If the
`nfsd_client_shrinker` is running concurrently, the `expire_client`
function will first unhash this client and then destroy it. This can
lead to the following warning. Additionally, numerous use-after-free
errors may occur as well.

nfsd_client_shrinker         echo 0 > /proc/fs/nfsd/threads

expire_client                nfsd_shutdown_net
  unhash_client                ...
                               nfs4_state_shutdown_net
                                 /* won't wait shrinker exit */
  /*                             cancel_work(&nn->nfsd_shrinker_work)
   * nfsd_file for this          /* won't destroy unhashed client1 */
   * client1 still alive         nfs4_state_destroy_net
   */

                               nfsd_file_cache_shutdown
                                 /* trigger warning */
                                 kmem_cache_destroy(nfsd_file_slab)
                                 kmem_cache_destroy(nfsd_file_mark_slab)
  /* release nfsd_file and mark */
  __destroy_client

====================================================================
BUG nfsd_file (Not tainted): Objects remaining in nfsd_file on
__kmem_cache_shutdown()
--------------------------------------------------------------------
CPU: 4 UID: 0 PID: 764 Comm: sh Not tainted 6.12.0-rc3+ #1

 dump_stack_lvl+0x53/0x70
 slab_err+0xb0/0xf0
 __kmem_cache_shutdown+0x15c/0x310
 kmem_cache_destroy+0x66/0x160
 nfsd_file_cache_shutdown+0xac/0x210 [nfsd]
 nfsd_destroy_serv+0x251/0x2a0 [nfsd]
 nfsd_svc+0x125/0x1e0 [nfsd]
 write_threads+0x16a/0x2a0 [nfsd]
 nfsctl_transaction_write+0x74/0xa0 [nfsd]
 vfs_write+0x1a5/0x6d0
 ksys_write+0xc1/0x160
 do_syscall_64+0x5f/0x170
 entry_SYSCALL_64_after_hwframe+0x76/0x7e

====================================================================
BUG nfsd_file_mark (Tainted: G    B   W         ): Objects remaining
nfsd_file_mark on __kmem_cache_shutdown()
--------------------------------------------------------------------

 dump_stack_lvl+0x53/0x70
 slab_err+0xb0/0xf0
 __kmem_cache_shutdown+0x15c/0x310
 kmem_cache_destroy+0x66/0x160
 nfsd_file_cache_shutdown+0xc8/0x210 [nfsd]
 nfsd_destroy_serv+0x251/0x2a0 [nfsd]
 nfsd_svc+0x125/0x1e0 [nfsd]
 write_threads+0x16a/0x2a0 [nfsd]
 nfsctl_transaction_write+0x74/0xa0 [nfsd]
 vfs_write+0x1a5/0x6d0
 ksys_write+0xc1/0x160
 do_syscall_64+0x5f/0x170
 entry_SYSCALL_64_after_hwframe+0x76/0x7e

To resolve this issue, cancel `nfsd_shrinker_work` using synchronous
mode in nfs4_state_shutdown_net.

Fixes: 7c24fa225081 ("NFSD: replace delayed_work with work_struct for nfsd_client_shrinker")
Signed-off-by: Yang Erkun <yangerkun@huaweicloud.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4state.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -8208,7 +8208,7 @@ nfs4_state_shutdown_net(struct net *net)
 	struct nfsd_net *nn = net_generic(net, nfsd_net_id);
 
 	unregister_shrinker(&nn->nfsd_client_shrinker);
-	cancel_work(&nn->nfsd_shrinker_work);
+	cancel_work_sync(&nn->nfsd_shrinker_work);
 	cancel_delayed_work_sync(&nn->laundromat_work);
 	locks_end_grace(&nn->nfsd4_manager);
 


