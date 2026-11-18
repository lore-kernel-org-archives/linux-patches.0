Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047043;
	b=e34v8q313fQXpqnksgJXOZwIjE5C4ACmqjC1fr44f35GQzBBUgsSBdJPHuT9ka/o7pWG
	 J5GcIsgwnFB2bHRKGl8Vr1NKl192BBgOs9rxuxXtQ/ixrqseFMAmY+FVFoZZjnoGKPoIz
	 ygT/TVpfC9xnHNZtRcPiU7ApzpvxJ0gCs3dxzqcaT7yshYUpWSI8g0eQ7GFGcPdNcMPEx
	 7Z+N+Ye5IciXtSttVDrgVns02kVRL7uYMJxkpiPEsScibWN3U5/d7rHmNm3Xq2anjpLXs
	 jm9+9DKm7KWttF3sxT7iZWKaAnh7AkP6KvW0cF3PaD0sRcyt6xZePMnNqcHLROX0T1w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047043;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=L1hvzdNAeXXvGLgEuf5OyXF1JuKTabVgk4ob2MaHUB4=;
	b=mhU/O4+OmLOyc/A/AgD8+u3MrelhqCSrUWXHKgJAYtI5Dld6hdbe/1cUq6l1r72P/+vZ
	 3wMSo9SegH4mogdCl57D3YAHcO1oJ/9bAwXL3TzYdk7sASw5UDsa0Zy7FiqoQ0MVrn9km
	 Ld5OhDS5kguXji0zQ1lHiXjjubmCqWptXQfLSnIjfdYw0NgjcUpxGruI4roI33J9OIjxi
	 AbbXuWai9e9CGbXGh0zrhcH4azQyQKGLFWJmPZvX9GKwQXw2N7pkzxKtCw7ErG0rCOh8i
	 6PpDGXdFC/oIddxhF/iuI8vAoTliPRl0BvE3EEngUkgxWxe+NeRyETYWsgZSBedilKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=up7SylON;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DAE1606A33A;
	Thu, 19 Nov 2026 00:10:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=up7SylON
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84D9A1F000C4;
	Thu, 19 Nov 2026 00:10:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047043;
	bh=L1hvzdNAeXXvGLgEuf5OyXF1JuKTabVgk4ob2MaHUB4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=up7SylONVjxUofRgghefyDMA0Oqd2eJEJwtLn5gFVfXkuH8I/sRj4YeMm7bhpd0jI
	 WlyxliAkn0SmFdJzGbq40jdtEsgCPt8w+4PbDADJgfdgU5LRH2m7u931lPPoFpUAVD
	 nS3TiUJhpx1F34sGUs2326cSDFus7naPf8gM2kVA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Daeho Jeong <daehojeong@google.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1496/2857] f2fs: dont use truncate_inode_pages_final() on live inodes
Date: Wed, 18 Nov 2026 15:42:10 +0100
Message-ID: <20261118150255.192854522@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

From: Daeho Jeong <daehojeong@google.com>

[ Upstream commit 74bbd6ada01f91fcad60608e0417bf45a9fa99e6 ]

truncate_inode_pages_final() is meant to be called from ->evict_inode.
It sets AS_EXITING on the mapping, and nothing ever clears it, to tell
the VM that the inode is going away.

f2fs calls it in two places where the inode stays live:

 - F2FS_IOC_START_ATOMIC_REPLACE uses it to drop the page cache of the
   original inode before setting i_size to 0. The atomic write then
   goes on through this inode.

 - f2fs_abort_atomic_write() uses it to drop the uncommitted data. It
   is called on eviction, but also on the last writer's close in
   f2fs_release_file(), from f2fs_file_flush() when the atomic writer
   exits, from F2FS_IOC_ABORT_ATOMIC_WRITE and when
   F2FS_IOC_COMMIT_ATOMIC_WRITE fails.

Other processes may still have the file open or mapped in all of these
cases. The mapping then stays marked as exiting for as long as the
inode is in memory. This stops reclaim from storing workingset shadow
entries for it and breaks any code that assumes an exiting mapping has
no users left.

All we need in both places is to drop the page cache, so use
truncate_inode_pages(mapping, 0) instead. The eviction path is not
affected, because f2fs_pre_evict_inode() still calls
truncate_inode_pages_final() after f2fs_abort_atomic_write().

Cc: stable@kernel.org
Fixes: 3db1de0e582c ("f2fs: change the current atomic write way")
Fixes: 41e8f85a75fc ("f2fs: introduce F2FS_IOC_START_ATOMIC_REPLACE")
Signed-off-by: Daeho Jeong <daehojeong@google.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
[ sashal: Omitted the atomic-replace hunk because atomic-replace support is absent. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/segment.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 6f792ebe6f530..ef1b80827fb0a 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -193,7 +193,7 @@ void f2fs_abort_atomic_write(struct inode *inode, bool clean)
 		return;
 
 	if (clean)
-		truncate_inode_pages_final(inode->i_mapping);
+		truncate_inode_pages(inode->i_mapping, 0);
 
 	release_atomic_write_cnt(inode);
 	clear_inode_flag(inode, FI_ATOMIC_COMMITTED);
-- 
2.53.0



