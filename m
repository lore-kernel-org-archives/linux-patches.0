Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208215;
	b=i5dLgbzP6dPd55/soqU9LKqwR2tYz/KiYiDm3+ikFZQLqG4HjRyIzk576h+WkSU9Naj6
	 y90vxsQR32n0FaNnF9u3wxIGP9TOwlDfK5gB7GdJixZz7I/Z4lHgHXwFlaiGIzk1iWEGs
	 udMT5smjPItslzGmktKzdfpRv2EoQhaUHJZh25F7HAncEsjk88ACaPaS2hnn5z5Z9xwYW
	 8FVZocrrYDv3d+f7pACp2QjLcor2h/oT+omikUlnz+Kgq6DZ7TKBQSmkO+LEpHkbO9X0I
	 ZS8EVB9X4s1LgJmzrQ96fDtJX3gvjph8cE66wQ8Tg7C/h0HNnW+wEf8oCrQeF3FJTIg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208215;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=Ij1gTW7n1vMZPyG4LnqXkRNm3FJeTjstGzmxZxYnX1E=;
	b=OvBzTUXrpmqnlDcPqcR62B8guVf5vbHx24hXEkjiJyTYXdqrpV1mK4PiMa/0ByNDhe1X
	 KZuJ66KiP2wDx9k2VoXqQLczB5O6Rv5BOMTLtFlUZJD+kCIhOLn74nHUuwj0OigVI0faH
	 WZJhQIHH3wlzsYwoV9QcKkskFKYtyYu0ex9M7cj+FJ/IMMSjtfjMd+gz/jCIN3COjgXLW
	 XZTgmC4XFC2F6NDBdIGOnd+1UCO3Rt2gtz5sQFC75u3gfKFv26SY1cPgosRv9B/aFttRH
	 vZy7q05SFJpYXFdWcITw03wDq4G2qm0MK1P4Pgdi3QJXE39t8BC49CSKjLfbh2RQYGw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hXnXPmBq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5862606A31E;
	Wed, 28 Oct 2026 17:23:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hXnXPmBq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4124F1F01829;
	Wed, 28 Oct 2026 17:23:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208214;
	bh=Ij1gTW7n1vMZPyG4LnqXkRNm3FJeTjstGzmxZxYnX1E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hXnXPmBqWu7SEOIWuO/WbhAsjNoByhFxviVY2aE/XJzfNvvFvYGf+tqmRzP6vr1xD
	 cHUO4DnouMCj+voU6UFBtHWxMMHLhWebbjhB2jHqPcXwaq+u1doOoK+Jj8scZ8FBFb
	 NqPruDDVaC21WgcIrHKcryMl/xR6iYnjc3WkA8Hs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baokun Li <libaokun@linux.alibaba.com>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 040/516] fuse: fix invalidate lock leak on open O_TRUNC DAX failure
Date: Wed, 28 Oct 2026 17:53:12 +0100
Message-ID: <20261028170004.480656053@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baokun Li <libaokun@linux.alibaba.com>

[ Upstream commit a927f1867e61b78f39f9da0bbba3c98c2ca151fe ]

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
[ changed goto target from out_inode_unlock to out_unlock and relocated the out_unlock label before up_write() on i_mmap_sem, adapting the fix from filemap_invalidate_lock/unlock and fuse_open() to 5.10's i_mmap_sem/down_write/up_write and fuse_open_common() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fuse/file.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 956c01a42d31a..9b40d5f067abb 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -239,7 +239,7 @@ int fuse_open_common(struct inode *inode, struct file *file, bool isdir)
 		down_write(&get_fuse_inode(inode)->i_mmap_sem);
 		err = fuse_dax_break_layouts(inode, 0, 0);
 		if (err)
-			goto out_inode_unlock;
+			goto out_unlock;
 	}
 
 	if (is_wb_truncate || dax_truncate)
@@ -259,10 +259,9 @@ int fuse_open_common(struct inode *inode, struct file *file, bool isdir)
 		else if (!(ff->open_flags & FOPEN_KEEP_CACHE))
 			invalidate_inode_pages2(inode->i_mapping);
 	}
+out_unlock:
 	if (dax_truncate)
 		up_write(&get_fuse_inode(inode)->i_mmap_sem);
-
-out_inode_unlock:
 	if (is_wb_truncate || dax_truncate)
 		inode_unlock(inode);
 
-- 
2.53.0



