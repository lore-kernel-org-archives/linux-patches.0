Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F26913E49F5;
	Tue, 21 Jul 2026 17:06:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653580; cv=none; b=ZSC24G6nBSJbzhsqnA9W0eHoXUqVfRXNd/4lj4QiEyYT29DnLX+5F6C7yjoQgYvfdYzJpwkLhuI3fKooDslXfkCKqJgzeYwwHUTD3JqISM1pG7RULaLPUSc8ggYV7x78YLq0G2WD1++Cq+77piD2T6k7QyFeqVNjksbqQZGuGWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653580; c=relaxed/simple;
	bh=1BTPGhlxplNbwJlvbt4pR4ZXdsEslARDB+xHj1BkvDY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=abM1j/8ZcLwGBNQqrRZvYyjJe7ZByISq+pymyLhoF2smz96iuuprJPeMHEH2jFBg6YcTVqEqab86wSxy7rIdvVGsQZz9Yqp9LA2iDf0F2yaBrWGIMSR60rNAjSMY9V7HVjGkF83RVEqZ5unNpEHjyPHcriS9guryqywK286/vfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iy1N64C1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iy1N64C1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A3651F000E9;
	Tue, 21 Jul 2026 17:06:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653578;
	bh=nbtA5EPDKbs50+oZMiQ5Bbps2v2S9zYT+F3g5ehmssg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iy1N64C1XAjRS5mDkbc+hzB186kTNE2CLVyyr8ca4wge1oClydNf7IUd+t018x4zD
	 nC5cDiX9aiqzzxCPNwrtmL/xjEF0lrpxga7pUP6Rbr2211Y0e7zm9b3LlcXY4UYPca
	 +oWPg9WHPRX3hTj9q82n87fwUwacrh2kdb8dLzE8=
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
Subject: [PATCH 7.1 1378/2077] afs: Fix reinitialisation of the inode, in particular ->lock_work
Date: Tue, 21 Jul 2026 17:17:31 +0200
Message-ID: <20260721152625.319558450@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
 fs/afs/inode.c |    1 +
 fs/afs/super.c |    2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

--- a/fs/afs/inode.c
+++ b/fs/afs/inode.c
@@ -680,6 +680,7 @@ void afs_evict_inode(struct inode *inode
 		inode->i_mapping->a_ops->writepages(inode->i_mapping, &wbc);
 	}
 
+	flush_delayed_work(&vnode->lock_work);
 	netfs_wait_for_outstanding_io(inode);
 	truncate_inode_pages_final(&inode->i_data);
 	netfs_free_folioq_buffer(vnode->directory);
--- a/fs/afs/super.c
+++ b/fs/afs/super.c
@@ -660,7 +660,6 @@ static void afs_i_init_once(void *_vnode
 	INIT_LIST_HEAD(&vnode->wb_keys);
 	INIT_LIST_HEAD(&vnode->pending_locks);
 	INIT_LIST_HEAD(&vnode->granted_locks);
-	INIT_DELAYED_WORK(&vnode->lock_work, afs_lock_work);
 	INIT_LIST_HEAD(&vnode->cb_mmap_link);
 	seqlock_init(&vnode->cb_lock);
 }
@@ -694,6 +693,7 @@ static struct inode *afs_alloc_inode(str
 
 	init_rwsem(&vnode->rmdir_lock);
 	INIT_WORK(&vnode->cb_work, afs_invalidate_mmap_work);
+	INIT_DELAYED_WORK(&vnode->lock_work, afs_lock_work);
 
 	_leave(" = %p", &vnode->netfs.inode);
 	return &vnode->netfs.inode;


