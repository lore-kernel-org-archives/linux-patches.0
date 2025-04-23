Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FB6157C9F;
	Wed, 23 Apr 2025 15:13:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421238; cv=none; b=bEyZ+Yl+dszgoYPSOuCswlzVZyD0W08aXpOMFJBfLEGLaAtnfMaB6kVjOua5IgWV3QJlBeJnlxcfwlVPZPPtdGbKqSHOJpbX3jpgSb4w+QDI1ZR6S4z8wnZCXckWDTrcA/Ywg6uj1pX1XaxhOvXji2qFq5jdLRRsvSgQXqtGyik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421238; c=relaxed/simple;
	bh=WQUpr/QGRNBvrKjZOES7OlMNHWSHRTRkJt4YQo8f40c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Czk3ScLWmtcfGGgT7+xPYcV24INZpr9JfqZxq58k0qSHG/v/nW9xKWa68tNqw9GD5xB/ADwuhalrN4rxXYmnmSAMKuMFe9TK5PQb9W9yjAgN+M3kKZ5MusorJQje6cMtv59fL0gsfofBLvRPsTzbq5qrTh58fYctyG5tkeJURDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vPM6PcHh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vPM6PcHh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20559C4CEE2;
	Wed, 23 Apr 2025 15:13:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421238;
	bh=WQUpr/QGRNBvrKjZOES7OlMNHWSHRTRkJt4YQo8f40c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vPM6PcHh1EbhiQtzio2ZY7YCDolIeRzn2/wXoQcl6ByfpaQ49iy44gioKsNNb7G4o
	 eF+dd5bbjAwGCWkqWxX7Wu25t4TqiKE6rAB1LbTO0FnxI8IkmBsjEeKDolup8WyM8u
	 z/nD3w2xJQvqbI4Ud91y+aSAg4wwy+uytCZZE4Gc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sungjong Seo <sj1557.seo@samsung.com>,
	Sunmin Jeong <s_min.jeong@samsung.com>,
	Yeongjin Gil <youngjin.gil@samsung.com>,
	Daeho Jeong <daehojeong@google.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 6.6 161/393] f2fs: fix to avoid atomicity corruption of atomic file
Date: Wed, 23 Apr 2025 16:40:57 +0200
Message-ID: <20250423142650.024913877@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yeongjin Gil <youngjin.gil@samsung.com>

commit f098aeba04c9328571567dca45159358a250240c upstream.

In the case of the following call stack for an atomic file,
FI_DIRTY_INODE is set, but FI_ATOMIC_DIRTIED is not subsequently set.

f2fs_file_write_iter
  f2fs_map_blocks
    f2fs_reserve_new_blocks
      inc_valid_block_count
        __mark_inode_dirty(dquot)
          f2fs_dirty_inode

If FI_ATOMIC_DIRTIED is not set, atomic file can encounter corruption
due to a mismatch between old file size and new data.

To resolve this issue, I changed to set FI_ATOMIC_DIRTIED when
FI_DIRTY_INODE is set. This ensures that FI_DIRTY_INODE, which was
previously cleared by the Writeback thread during the commit atomic, is
set and i_size is updated.

Cc: <stable@vger.kernel.org>
Fixes: fccaa81de87e ("f2fs: prevent atomic file from being dirtied before commit")
Reviewed-by: Sungjong Seo <sj1557.seo@samsung.com>
Reviewed-by: Sunmin Jeong <s_min.jeong@samsung.com>
Signed-off-by: Yeongjin Gil <youngjin.gil@samsung.com>
Reviewed-by: Daeho Jeong <daehojeong@google.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/inode.c |    4 +---
 fs/f2fs/super.c |    4 ++++
 2 files changed, 5 insertions(+), 3 deletions(-)

--- a/fs/f2fs/inode.c
+++ b/fs/f2fs/inode.c
@@ -35,10 +35,8 @@ void f2fs_mark_inode_dirty_sync(struct i
 	if (f2fs_inode_dirtied(inode, sync))
 		return;
 
-	if (f2fs_is_atomic_file(inode)) {
-		set_inode_flag(inode, FI_ATOMIC_DIRTIED);
+	if (f2fs_is_atomic_file(inode))
 		return;
-	}
 
 	mark_inode_dirty_sync(inode);
 }
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -1499,6 +1499,10 @@ int f2fs_inode_dirtied(struct inode *ino
 		inc_page_count(sbi, F2FS_DIRTY_IMETA);
 	}
 	spin_unlock(&sbi->inode_lock[DIRTY_META]);
+
+	if (!ret && f2fs_is_atomic_file(inode))
+		set_inode_flag(inode, FI_ATOMIC_DIRTIED);
+
 	return ret;
 }
 


