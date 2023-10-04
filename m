Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D66621C291
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:35:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="shTLQrYu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57469C433C9;
	Wed,  4 Oct 2023 18:35:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696444554;
	bh=Znwu/vqcd9l/Y56R0dpQyfqY/smlUU24ySWPOQLwXDI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=shTLQrYuf0gYNQjV+B+srX758rTg0vNqmt4UgX6S979qgKeHaooT+fQLSDGNYgGL0
	 ajER+dQgGzgDiEY10QkUzVUhE+BIN1M5fH4Km69HAlvQvng/MbA6yQelmQ52LOxVU8
	 sKIYvADTdS8lVMl+mGDyIEnagWDg2CBfiCaCJcEk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miklos Szeredi <miklos@szeredi.hu>,
	Christoph Hellwig <hch@lst.de>,
	Bernd Schubert <bschubert@ddn.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.5 291/321] btrfs: file_remove_privs needs an exclusive lock in direct io write
Date: Wed,  4 Oct 2023 19:57:16 +0200
Message-ID: <20231004175242.755083607@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175229.211487444@linuxfoundation.org>
References: <20231004175229.211487444@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bernd Schubert <bschubert@ddn.com>

commit 9af86694fd5d387992699ec99007ed374966ce9a upstream.

This was noticed by Miklos that file_remove_privs might call into
notify_change(), which requires to hold an exclusive lock. The problem
exists in FUSE and btrfs. We can fix it without any additional helpers
from VFS, in case the privileges would need to be dropped, change the
lock type to be exclusive and redo the loop.

Fixes: e9adabb9712e ("btrfs: use shared lock for direct writes within EOF")
CC: Miklos Szeredi <miklos@szeredi.hu>
CC: stable@vger.kernel.org # 5.15+
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Bernd Schubert <bschubert@ddn.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/file.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1466,8 +1466,13 @@ static ssize_t btrfs_direct_write(struct
 	if (iocb->ki_flags & IOCB_NOWAIT)
 		ilock_flags |= BTRFS_ILOCK_TRY;
 
-	/* If the write DIO is within EOF, use a shared lock */
-	if (iocb->ki_pos + iov_iter_count(from) <= i_size_read(inode))
+	/*
+	 * If the write DIO is within EOF, use a shared lock and also only if
+	 * security bits will likely not be dropped by file_remove_privs() called
+	 * from btrfs_write_check(). Either will need to be rechecked after the
+	 * lock was acquired.
+	 */
+	if (iocb->ki_pos + iov_iter_count(from) <= i_size_read(inode) && IS_NOSEC(inode))
 		ilock_flags |= BTRFS_ILOCK_SHARED;
 
 relock:
@@ -1475,6 +1480,13 @@ relock:
 	if (err < 0)
 		return err;
 
+	/* Shared lock cannot be used with security bits set. */
+	if ((ilock_flags & BTRFS_ILOCK_SHARED) && !IS_NOSEC(inode)) {
+		btrfs_inode_unlock(BTRFS_I(inode), ilock_flags);
+		ilock_flags &= ~BTRFS_ILOCK_SHARED;
+		goto relock;
+	}
+
 	err = generic_write_checks(iocb, from);
 	if (err <= 0) {
 		btrfs_inode_unlock(BTRFS_I(inode), ilock_flags);


