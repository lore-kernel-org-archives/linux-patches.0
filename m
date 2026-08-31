Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15BD543FD18;
	Mon, 31 Aug 2026 14:02:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184963; cv=none; b=pGOX66VF0//SV2W1NW7jjk78K6/HCLYLaICAGrUMATSjMZxR5kvUO5bdom4xKQEt75PxYb39dBnC+t3EWbym+5PpOz8N4UB5U5KL13Nkuw8/vDhggs6A3XtFNsocRbyp4fei6doXm3+358XNf/FC6d0Q52aJOT66BrFmJxL7Q6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184963; c=relaxed/simple;
	bh=l3cuw4uSam3lLzJMgth+OpsKPK8xcay77dbku/f1IyY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VJiZOvDVZNoTxE28VhJqxmnUcB+yPm668Ije54dURCsqK+EpqcOPFVcJUV2RZyl2KvjsdNK3ATPY1vd2WlJyKmv/R4EXJsdClsNk6hRa9TM4t8X1o23U7pW8IGq60lG52DEYOlkFdMb6Dv3Fxw/hey9Z/RdHnTDCjAR0YF5OB/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lrvX61kx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lrvX61kx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 670861F00A3D;
	Mon, 31 Aug 2026 14:02:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184961;
	bh=cut0vjFA6hDao/rflm2VCWK3A7MG5yq6WACXyO+aWQE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lrvX61kxfYPxQ//6NoDzzes/TMfsnqW4wuSvN7oO6FovL+Gjl2/UtupI9eXKmOPl3
	 8Xj3wedfJTyFQi5jLLo6FLwlcp862WZA/EkMknkshWgk895EhzDfzprBpHqbc7TCDm
	 xnK9q337tGQbcR8e/MqGAeKdueItFBlTI/8Rv4rg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baokun Li <libaokun@linux.alibaba.com>,
	Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 6.1 68/92] fuse: fix invalidate lock leak on open O_TRUNC DAX failure
Date: Mon, 31 Aug 2026 15:35:06 +0200
Message-ID: <20260831133403.178210246@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.482388899@linuxfoundation.org>
References: <20260831133359.482388899@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -259,7 +259,7 @@ int fuse_open_common(struct inode *inode
 		filemap_invalidate_lock(inode->i_mapping);
 		err = fuse_dax_break_layouts(inode, 0, -1);
 		if (err)
-			goto out_inode_unlock;
+			goto out_unlock;
 	}
 
 	if (is_wb_truncate || dax_truncate)
@@ -279,9 +279,9 @@ int fuse_open_common(struct inode *inode
 		else if (!(ff->open_flags & FOPEN_KEEP_CACHE))
 			invalidate_inode_pages2(inode->i_mapping);
 	}
+out_unlock:
 	if (dax_truncate)
 		filemap_invalidate_unlock(inode->i_mapping);
-out_inode_unlock:
 	if (is_wb_truncate || dax_truncate)
 		inode_unlock(inode);
 


