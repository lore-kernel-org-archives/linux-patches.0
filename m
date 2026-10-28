Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215598;
	b=isNutSS5hIyjZ2Mtuw6vb3irRmWYesBW98x3lC0qEENWm4ZQspAKxPOzeRiCb+LmfR4A
	 AfNSh6J8uvnkIUdSk22IrFSNrgDURqZ3ezGk60Mp/f/5oDPcL0XXLE1zZh29I3SqSa4q2
	 M2nRxn+Y3JaF9Gb1bF67tiXmHZGYQWDmJh1O4X3T23rd/Qvw/AUUIfhr7lFweE4DGy8ha
	 P0VADjBj8+lcBYlBwJDnNbS8hZrWt5jdjq7fMx5RaYvzGINqEoYv6FXCrVltRWP+QB/pv
	 aoA7W16vwrfo2YcIma8R5Vx/qPll/hje9F4p7C0zyCfWU0VQvrFp+Ox8jwDfA+4y3CQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215598;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zRxctR7sbrMGsLjhKsUjstWtaSXl9Gn5OZbFwxPij18=;
	b=XewxRKtH5MY+IREx4+zsEU9/6oLdRdTsgehAMRGNvVImYxCm2TnGQjM916k008R+sIHA
	 /KYGMcMPdnzVV8PvFXiP437ZHWkqHNAFYsAMl3q+aEbIYXwDhWKGnyNMQenzhMHaWqGIm
	 j9MsFF7F2SG3xbDLKkwGRcTwJsWf5IBel7vfCdeJqOuMbRdDPULuKPqefMKm3DH/R1uAs
	 F5K1iBGIAVXSf/mYVn5Gp1J+L2ksDxIBTMPNFr/rdvDwEOZ1LO0y/jquQ1EuLmKXKaTe4
	 jax96EUCJXmCQ3PzMRd2KFwgZK1XCYq+j08fRlQL+DJQz2wqG/FrDmanxpqmOiHhqVA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F2ZW7onG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECACC606A31A;
	Wed, 28 Oct 2026 19:26:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F2ZW7onG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A5471F031E2;
	Wed, 28 Oct 2026 19:26:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215597;
	bh=zRxctR7sbrMGsLjhKsUjstWtaSXl9Gn5OZbFwxPij18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F2ZW7onGnhiMqu5pdTR/DwOVg1iC0IQUCA5AatQqwxiRRqZoOA0jWfCQmN85YtYAX
	 tz9Y12Bo8xhtU2S0nZ0C4AHHwToaKzU5ZSJgZIZU9XBQ52jJOthWhApGDFOVOkFYKV
	 vvAxQtJbTPyHovCLod5pt0o7sHboT0bSwBMGOYDE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	Thomas Gleixner <tglx@kernel.org>,
	linux-afs@lists.infradead.org,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1229/1887] afs: Fix reinitialisation of the inode, in particular ->lock_work
Date: Wed, 28 Oct 2026 17:55:25 +0100
Message-ID: <20261028170527.390209021@linuxfoundation.org>
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

From: David Howells <dhowells@redhat.com>

[ Upstream commit 5597fbd1e7c161914f20315a726e54025b0fdadb ]

It seems that initalising afs_vnode::lock_work a single time in the slab's
init function isn't sufficient for work_structs.  This results in the
DEBUG_OBJECTS debugging stuff producing a warning occasionally when running
the generic/131 xfstest:

 ODEBUG: activate not available (active state 0) object: 0000000016d8760f object type: work_struct hint: afs_lock_work+0x0/0x220
 WARNING: lib/debugobjects.c:629 at debug_print_object+0x4b/0x90, CPU#3: locktest/7695
 ...
 CPU: 3 UID: 0 PID: 7695 Comm: locktest Tainted: G S                  7.1.0-build3+ #2771 PREEMPT
 ...
 RIP: 0010:debug_print_object+0x65/0x90
 ...
 Call Trace:
  <TASK>
  ? __pfx_afs_lock_work+0x10/0x10
  debug_object_activate+0x122/0x170
  insert_work+0x25/0x60
  __queue_work+0x2e0/0x340
  queue_delayed_work_on+0x48/0x70
  afs_fl_release_private+0x57/0x70
  locks_release_private+0x5c/0xa0
  locks_free_lock+0xe/0x20
  posix_lock_inode+0x55f/0x5b0
  locks_lock_inode_wait+0x81/0x140
  ? file_write_and_wait_range+0x50/0x70
  afs_lock+0xcd/0x110
  fcntl_setlk+0x10d/0x260
  do_fcntl+0x24e/0x5b0
  __do_sys_fcntl+0x6a/0x90
  do_syscall_64+0x11e/0x310
  entry_SYSCALL_64_after_hwframe+0x71/0x79

Fix this by reinitialising ->lock_work after allocating an inode.

Also, flush ->lock_work when the inode is being evicted to make sure it's
not still running.

Fixes: e8d6c554126b ("AFS: implement file locking")
Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://patch.msgid.link/20260622090856.2746629-13-dhowells@redhat.com
cc: Marc Dionne <marc.dionne@auristor.com>
cc: Thomas Gleixner <tglx@kernel.org>
cc: linux-afs@lists.infradead.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/inode.c | 1 +
 fs/afs/super.c | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/afs/inode.c b/fs/afs/inode.c
index 5921dd3687e39..524e5a106337e 100644
--- a/fs/afs/inode.c
+++ b/fs/afs/inode.c
@@ -809,6 +809,7 @@ void afs_evict_inode(struct inode *inode)
 
 	ASSERTCMP(inode->i_ino, ==, vnode->fid.vnode);
 
+	flush_delayed_work(&vnode->lock_work);
 	truncate_inode_pages_final(&inode->i_data);
 
 	afs_set_cache_aux(vnode, &aux);
diff --git a/fs/afs/super.c b/fs/afs/super.c
index 1dd6c7c9713be..3fa0c38d7a7c0 100644
--- a/fs/afs/super.c
+++ b/fs/afs/super.c
@@ -670,7 +670,6 @@ static void afs_i_init_once(void *_vnode)
 	INIT_LIST_HEAD(&vnode->wb_keys);
 	INIT_LIST_HEAD(&vnode->pending_locks);
 	INIT_LIST_HEAD(&vnode->granted_locks);
-	INIT_DELAYED_WORK(&vnode->lock_work, afs_lock_work);
 	INIT_LIST_HEAD(&vnode->cb_mmap_link);
 	seqlock_init(&vnode->cb_lock);
 }
@@ -702,6 +701,7 @@ static struct inode *afs_alloc_inode(struct super_block *sb)
 
 	init_rwsem(&vnode->rmdir_lock);
 	INIT_WORK(&vnode->cb_work, afs_invalidate_mmap_work);
+	INIT_DELAYED_WORK(&vnode->lock_work, afs_lock_work);
 
 	_leave(" = %p", &vnode->netfs.inode);
 	return &vnode->netfs.inode;
-- 
2.53.0



