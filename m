Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B670938AC99;
	Sat, 17 Oct 2026 16:20:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254028; cv=none; b=HSk90eew8ut1gt5yu386Sk6RwGxwl0L+u3NEdOIvhZzWHiOa2FX6vdQihpQF+GJM8LfQxkqVTKkazK77aXFC1a8Lu1pMSqYp2BqIfR03Vqzj/kwS1jnP7wl8vGH9OW+lPq50Mb/jXXojVI5NKP7DflP0IzKQ2DC6f+iw8gknlPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254028; c=relaxed/simple;
	bh=gAbHcoEVKbnsurPTfYBNKHBTfcc0OuammNq4TXlSyio=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M/R6C7P50wIfnhbnz6Q3v6x9psqmFb4BYcDd+3F6YdmC15rcskpxlONHCH6wR3/Dkj29llqc1d1jpJtLAgcEnPgx64UfFa8OjbLn8vqJu6KncLqNgsLniX59i50QRV2x5fWOkMUl+XTbUXFCZgRjKX2Z6khfw9O7vh2fQ4Eq26I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o0Ay5mYS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o0Ay5mYS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 199761F000C4;
	Sat, 17 Oct 2026 16:20:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254027;
	bh=hNeZPhdA5W6CBVT1NGlNz89lJ35uV5eteUhs9e3AuuY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o0Ay5mYSNx4Ykr8FXjsXf3AmMUQEirgZnfvFA9htpb4RpLpc/JNQBpnZJpkLbLU3E
	 U+2Nn3uE9Fuu+YqApdIo/PaNI/38qhGa3MzRhvyyy2ksebZ7RZZS4NY2b5sUcLbIs5
	 OrAWAME9W2HGWAQ8uZQIOmPdeU+SeYlBMWZYWL/w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yongpeng Yang <yangyongpeng@xiaomi.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 312/869] f2fs: fix data loss caused by incorrect use of nat_entry flag
Date: Sat, 17 Oct 2026 17:52:33 +0200
Message-ID: <20261017160045.075459119@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

From: Yongpeng Yang <yangyongpeng@xiaomi.com>

[ Upstream commit 238e14eb7226f883b72caccd2d37bf5707df066b ]

Data loss can occur when fsync is performed on a newly created file
(before any checkpoint has been written) concurrently with a checkpoint
operation. The scenario is as follows:

create & write & fsync 'file A'                 write checkpoint
- f2fs_do_sync_file // inline inode
 - f2fs_write_inode // inode folio is dirty
                                                - f2fs_write_checkpoint
                                                 - f2fs_flush_merged_writes
                                                 - f2fs_sync_node_pages
                                                 - f2fs_flush_nat_entries
 - f2fs_fsync_node_pages // no dirty node
 - f2fs_need_inode_block_update // return false
 SPO and lost 'file A'

f2fs_flush_nat_entries() sets the IS_CHECKPOINTED and HAS_LAST_FSYNC
flags for the nat_entry, but this does not mean that the checkpoint has
actually completed successfully. However, f2fs_need_inode_block_update()
checks these flags and incorrectly assumes that the checkpoint has
finished.

The root cause is that the semantics of IS_CHECKPOINTED and
HAS_LAST_FSYNC are only guaranteed after the checkpoint write fully
completes.

This patch modifies f2fs_need_inode_block_update() to acquire the
sbi->node_write lock before reading the nat_entry flags, ensuring that
once IS_CHECKPOINTED and HAS_LAST_FSYNC are observed to be set, the
checkpoint operation has already completed.

Fixes: e05df3b115e7 ("f2fs: add node operations")
Signed-off-by: Yongpeng Yang <yangyongpeng@xiaomi.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/node.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 9709a212e6a03..56d5fb77569d7 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -419,6 +419,7 @@ bool f2fs_need_inode_block_update(struct f2fs_sb_info *sbi, nid_t ino)
 	struct nat_entry *e;
 	bool need_update = true;
 
+	f2fs_down_read(&sbi->node_write);
 	f2fs_down_read(&nm_i->nat_tree_lock);
 	e = __lookup_nat_cache(nm_i, ino);
 	if (e && get_nat_flag(e, HAS_LAST_FSYNC) &&
@@ -426,6 +427,7 @@ bool f2fs_need_inode_block_update(struct f2fs_sb_info *sbi, nid_t ino)
 			 get_nat_flag(e, HAS_FSYNCED_INODE)))
 		need_update = false;
 	f2fs_up_read(&nm_i->nat_tree_lock);
+	f2fs_up_read(&sbi->node_write);
 	return need_update;
 }
 
-- 
2.53.0



