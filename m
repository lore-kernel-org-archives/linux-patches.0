Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31F9230CD95;
	Wed, 30 Sep 2026 17:30:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789407; cv=none; b=O9fe3t7U5eMhLbrD7E5H5jRlGRGqgdDWs7nVMBtz+NZP3bCkeBzAM974SQVM/4MXC2VGyzeyD/db1ryxEZPzAtMVPAtzwKY4FR7C1KZdM97KNUw9SwbObYmAAyXHBxqV1S1WK8qBxDIVVOc3Um/aWdYU1uVG9LLGd+64Hf66HTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789407; c=relaxed/simple;
	bh=NoXZeKIRjZTtbaKf52+hSaYPb6WMxTFoZ7Dhg00VMKE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=daTKoCZChz3gc/pp2KXTQbK7qsfb2f8iQ0HlMr4sCAZ1N8gr0jTsO4n1V5NPBMRV56XHRamNkdzPXXuAsfkesUjWUZvQANxMgXRkw+gGGSu9jO56qVTxMOifwqA3RdixotUetDjCG+Or4mM0tY0w6Kdq5CCWQmBGuYxoQ1NaWyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LFSdc7ba; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LFSdc7ba"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B2E01F00898;
	Wed, 30 Sep 2026 17:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789405;
	bh=IvWoFo5066fUAr10FX7YELFb5VN5bGThzaBQtm13/Vk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LFSdc7baMWmw5Q8NhI9ZOj3nmxTt2V1xFYL0zJd7bP1Hsl04L9SFlICnKE42RCUzg
	 wapVtynqurVExYVZekfOr72sxtER0z4lPe2ZoXgPTD/7Izkoxgsm9N3+1rSnLOTkr1
	 HEsWW1xFwwMStI2J7vvn4DPWfwCHQg227xPj/MOU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	syzbot+2a13ad6914e6fcec716c@syzkaller.appspotmail.com,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 6.12 466/877] fs/ntfs3: use d_instantiate_new() in ntfs_create_inode() and murder syzbots "WARNING in do_new_mount" saga
Date: Wed, 30 Sep 2026 17:22:57 +0200
Message-ID: <20260930152424.732353769@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

From: Christian Brauner <brauner@kernel.org>

commit 1abd643f3783ea8f8e273c18697ff0413aa92dc7 upstream.

ntfs_create_inode() creates a new inode via ntfs_new_inode(). It hashes
it with insert_inode_locked() and so it's marked as I_NEW until
unlock_new_inode().

ntfs 3 calls d_instantiate() in between though... Since the dentry was
already hashed by the lookup before the create any path walk finds it
without touching the parent's i_rwsem and so can lock the inode.

If the inode is a directory unlock_new_inode() calls
lockdep_annotate_inode_mutex_key() and marks i_rwsem with the
i_mutex_dir_key class.

That resets the count and the owner of a lock somebody else may already
hold by now...

syzbot has been spamming us with the same godforsaken bug

  "WARNING in do_new_mount"

since 2023. I can't take it anymore so I went looking. Afaict, syzbot's
executor chdirs into a freshly mounted ntfs3 image, creates a
directory and then mounts some pseudofs on it. Everytime the mkdir()
takes longer than syzbot waits mount() runs concurrently:

  mkdir("./sys")                        mount(NULL, "./sys", "sysfs")
  ntfs_create_inode()
    d_instantiate()
                                        user_path_at() finds the dentry
                                        do_lock_mount()
                                          inode_lock(inode)
                                          namespace_lock()
    unlock_new_inode()
      lockdep_annotate_inode_mutex_key()
        init_rwsem(&inode->i_rwsem)
                                        unlock_mount()
                                          inode_unlock(inode)

The mount side then releases a lock that according to the rwsem nobody
holds:

  DEBUG_RWSEMS_WARN_ON((rwsem_owner(sem) != current) && ...):
  count = 0x0, magic = 0xffff888043a854e8, owner = 0x0,
  curr 0xffff888000244880, list empty
  WARNING: CPU: 0 PID: 5346 at kernel/locking/rwsem.c:1368 __up_write
  Call Trace:
   inode_unlock include/linux/fs.h:877 [inline]
   unlock_mount fs/namespace.c:2892 [inline]
   do_new_mount_fc fs/namespace.c:3828 [inline]
   do_new_mount+0x777/0xa40 fs/namespace.c:3887

On PREEMPT_RT the same thing shows up as

  DEBUG_LOCKS_WARN_ON(rt_mutex_owner(lock) != current)
  WARNING: kernel/locking/rtmutex_common.h:193 at rt_mutex_slowunlock

The up_write() underflows the reset count. A following inode_lock() on
that directory then never returns. A path walk into the new directory
racing with the mkdir() corrupts the lock the same way via
inode_lock_shared() in lookup_slow().

Switch to d_instantiate_new() and drop the trailing unlock_new_inode().
All error paths bail out before that point with I_NEW still set and
keep using discard_new_inode().

May we never see this fscking bug report again.

Link: https://patch.msgid.link/20260909-work-ntfs3-d_instantiate_new-v1-1-2db697162ce8@kernel.org
Fixes: 82cae269cfa9 ("fs/ntfs3: Add initialization of super block")
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: stable@vger.kernel.org # v5.15+
Reported-by: syzbot+2a13ad6914e6fcec716c@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/6a9beced.a5e650b3.26d8a.000b.GAE@google.com
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs3/inode.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/fs/ntfs3/inode.c
+++ b/fs/ntfs3/inode.c
@@ -1677,10 +1677,10 @@ int ntfs_create_inode(struct mnt_idmap *
 		goto out6;
 
 	/*
-	 * Call 'd_instantiate' after inode->i_op is set
+	 * Call 'd_instantiate_new' after inode->i_op is set
 	 * but before finish_open.
 	 */
-	d_instantiate(dentry, inode);
+	d_instantiate_new(dentry, inode);
 
 	/* Set original time. inode times (i_ctime) may be changed in ntfs_init_acl. */
 	inode_set_atime_to_ts(inode, ni->i_crtime);
@@ -1728,9 +1728,6 @@ out1:
 	if (!fnd)
 		ni_unlock(dir_ni);
 
-	if (!err)
-		unlock_new_inode(inode);
-
 	return err;
 }
 


