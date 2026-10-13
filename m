Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 229814EFFC8;
	Tue, 13 Oct 2026 12:10:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893404; cv=none; b=LXfB1tIbPLobmT3hpZ3Zov9mnKDZvpHsPUz3HcPM0G2cD0OoM/qPJxxJd+gylHtyNNfc+dkOvKfgLWrC31kD2u3mrxrWsE3ozgTbXsUhZR3zoMiy1JLJp1yDoJZevgG1SLIeeHFwkk1ZMndXEaFN57LgHgL5I0erKweVkdnn8UQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893404; c=relaxed/simple;
	bh=DUZ3eezX/ughiciQDT59DNjujMyKt74a+mOxrsRkZSM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oc8ry0MEBaTgNyMGnUlK1fZI+OrJqjffXuJagaxPwCVQWN2tapyVNa+yoJmXTAaOUB83k/ggZHhKefNB5CmEe41pUufZOR710Vuir92AKI5T1ny1Cj/IyVhAxCdZ2Cb1DiJrK3fsmOE6UiiQgK3EjPk+xPdZwo9rQOkvNY+/7Uw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZqORy/h1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZqORy/h1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 335F81F000FF;
	Tue, 13 Oct 2026 12:10:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893402;
	bh=CREgkV1J8Y2OSnh6W4uPDObveUjvivSn3kdaQ8q5kW8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZqORy/h17+Y28Un79MzS5+V7bx4cf3YB80Z7tH0PHsWMQyrj7WOVnuF22EJPDQWy7
	 A+dAf7o8MZMejht6C/oZpiQ6lWgLImEngQzGKzM4mHNlZrjtvmu/uubwynIRDeEZX0
	 PlpHBTer7xN/pagizX+F2piG5Fm+jrVUU85khqck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yongpeng Yang <yangyongpeng@xiaomi.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 215/621] f2fs: fix data loss caused by incorrect use of nat_entry flag
Date: Tue, 13 Oct 2026 13:33:30 +0200
Message-ID: <20261013112925.963383507@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 823b78c4aa5b1..60969e5f1201b 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -428,6 +428,7 @@ bool f2fs_need_inode_block_update(struct f2fs_sb_info *sbi, nid_t ino)
 	struct nat_entry *e;
 	bool need_update = true;
 
+	f2fs_down_read(&sbi->node_write);
 	f2fs_down_read(&nm_i->nat_tree_lock);
 	e = __lookup_nat_cache(nm_i, ino, false);
 	if (e && get_nat_flag(e, HAS_LAST_FSYNC) &&
@@ -435,6 +436,7 @@ bool f2fs_need_inode_block_update(struct f2fs_sb_info *sbi, nid_t ino)
 			 get_nat_flag(e, HAS_FSYNCED_INODE)))
 		need_update = false;
 	f2fs_up_read(&nm_i->nat_tree_lock);
+	f2fs_up_read(&sbi->node_write);
 	return need_update;
 }
 
-- 
2.53.0



