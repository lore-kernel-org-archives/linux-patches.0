Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A4BF4766B4;
	Mon, 31 Aug 2026 13:53:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184415; cv=none; b=qZHhLkjPeQonGzmexVpN4jrS/z/gyn2i9JXERPkZPsH6/4/HiGly7JAOzhGF0FC+GeQoeOrLkWssAW669ETOY9vBWD0ZJSrg4VSJgydNqHxzGvpXgvCfrPZ0uvOeGlLxH7RYISPG9cLx6Ozyp1Ehj0PEDcuZBW8KGAWKRGwmGTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184415; c=relaxed/simple;
	bh=hYz84zrmSkxTbJe0FbhUIzZ93Pxagtf48fe1sjF0EzQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HR+1Xc7C4Z26y+v8DcG4XM5hU1Rk3GrZPlOgUpumS/2uZcbeREzNXAl7+akAgrqLOVtTbOau2xmk4aXPOH3UmkvPjld/yKQswMIiLnwErKToeuoqYvxgloIjRUD8l1Rm68tVXRTk+5vwbYKhuMordAAqTC+vSfskJjMH9Qvh5vg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MCy7P/D9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MCy7P/D9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACD771F00A3D;
	Mon, 31 Aug 2026 13:53:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184414;
	bh=9oBbxUHHtTWN279PjUz2TbvygZZPvgjdEoAgUmY3Zfo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MCy7P/D9N99pd5t/Ij85cbN+/0KzUlInaeBTTQo7kIyTkplRU/bjRjwCC24dNREle
	 yva6rcpfSCtHp0jizfs48qfPbheSGuH/dr7f0ULuU6WRj9bJvjGeKgRlR3Is8LbIfu
	 Vw+nI9Wme6ShOqSeULZqNTvRZQXX8ZbPEMci0MOs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baokun Li <libaokun@linux.alibaba.com>,
	Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 6.12 62/99] fuse: fix invalidate lock leak on open O_TRUNC DAX failure
Date: Mon, 31 Aug 2026 15:34:31 +0200
Message-ID: <20260831133403.114472320@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.740409777@linuxfoundation.org>
References: <20260831133359.740409777@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baokun Li <libaokun@linux.alibaba.com>

commit a927f1867e61b78f39f9da0bbba3c98c2ca151fe upstream.

fuse_open() takes filemap_invalidate_lock() for a DAX truncate
(dax_truncate = true) and releases it before the out_inode_unlock
label.  But when fuse_dax_break_layouts() fails, the goto
out_inode_unlock skips the unlock and leaks the rwsem, so any later
fault or truncate on the file stalls on the stale lock.

fuse_dax_break_layouts() can fail with -ERESTARTSYS when a signal
interrupts the wait for busy DAX pages to drain:

  open("file", O_RDWR | O_TRUNC)
  └─ fuse_open()
     ├─ filemap_invalidate_lock()        # dax_truncate
     └─ fuse_dax_break_layouts()
        └─ dax_break_layout()
           └─ wait_page_idle()           # TASK_INTERRUPTIBLE
              └─ fuse_wait_dax_page()    # unlock, schedule, re-lock
                 └─ signal → -ERESTARTSYS
     goto out_inode_unlock               # <- lock leaked

Fix this by moving filemap_invalidate_unlock() below the label so
that all error paths release the lock, and rename the label to
out_unlock as it now covers more than just the inode lock.

Fixes: 2fdbb8dd0155 ("fuse: fix deadlock between atomic O_TRUNC and page invalidation")
Cc: stable@vger.kernel.org # v6.0+
Signed-off-by: Baokun Li <libaokun@linux.alibaba.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fuse/file.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -267,7 +267,7 @@ static int fuse_open(struct inode *inode
 		filemap_invalidate_lock(inode->i_mapping);
 		err = fuse_dax_break_layouts(inode, 0, -1);
 		if (err)
-			goto out_inode_unlock;
+			goto out_unlock;
 	}
 
 	if (is_wb_truncate || dax_truncate)
@@ -291,9 +291,9 @@ static int fuse_open(struct inode *inode
 		else if (!(ff->open_flags & FOPEN_KEEP_CACHE))
 			invalidate_inode_pages2(inode->i_mapping);
 	}
+out_unlock:
 	if (dax_truncate)
 		filemap_invalidate_unlock(inode->i_mapping);
-out_inode_unlock:
 	if (is_wb_truncate || dax_truncate)
 		inode_unlock(inode);
 


