Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C86A93EDE51;
	Tue, 12 May 2026 18:13:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609630; cv=none; b=V9alZvB6EgPJRLIB0LPJ77vAal7Lr5qgnjUvCXPJ0z8nVXz7661/m2NyLGmKMbLiyK1OPyZR2bDt5k9OZ3eFwCRf0vi2k3s3thN2LdXCvPG6y8Hg6p7RJxJJ3JllNMWvB29DeFdkn+s7I36MOzqtnHXg0SRMH2S36SgrSBEi9Jk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609630; c=relaxed/simple;
	bh=zOBqTFRkqnAgUpv5jnOmAASx8SpEYTvqkWxBf64j2eQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qd3aEAN7I75ZGjjAo6AXZuQrvQ9X6GgO1JeQhhTHd8Mi8O1BKWHGCkah/AImT2ao971jSzkzZ0k8ic7PcdmfoMh5yZKQEyv1qpWAVNIIexYF+0kt1Tfs0RBo1TSv4+aczX+wzbOuYt8S9YXGZxlY0pneqybOsi0l2P6qiGLAuo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MkslC4TU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MkslC4TU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FE2BC2BCB0;
	Tue, 12 May 2026 18:13:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609630;
	bh=zOBqTFRkqnAgUpv5jnOmAASx8SpEYTvqkWxBf64j2eQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MkslC4TUywwFj8rLH4oHqmeFBNvHOERLjoWXXIMP95Zz8M+3E9y7DbNAOv3ZpXv3y
	 bsEgznuOv5Z+p05BUIi54mYlru55n2S72jKRm9zj86R8MONuxnGXAK8f2rOevZjtcD
	 n6JO88bmvERz8zjsMn+ZzsR+gxRuSihWxBnmJDig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Yongpeng Yang <yangyongpeng@xiaomi.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 7.0 270/307] f2fs: fix fsck inconsistency caused by incorrect nat_entry flag usage
Date: Tue, 12 May 2026 19:41:05 +0200
Message-ID: <20260512173945.825137446@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yongpeng Yang <yangyongpeng@xiaomi.com>

commit 019f9dda7f66e55eb94cd32e1d3fff5835f73fbc upstream.

f2fs_need_dentry_mark() reads nat_entry flags without mutual exclusion
with the checkpoint path, which can result in an incorrect inode block
marking state. The scenario is as follows:

create & write & fsync 'file A'                 write checkpoint
- f2fs_do_sync_file // inline inode
 - f2fs_write_inode // inode folio is dirty
                                                - f2fs_write_checkpoint
                                                 - f2fs_flush_merged_writes
                                                 - f2fs_sync_node_pages
 - f2fs_fsync_node_pages // no dirty node
 - f2fs_need_inode_block_update // return true
 - f2fs_fsync_node_pages // inode dirtied
  - f2fs_need_dentry_mark //return true
                                                 - f2fs_flush_nat_entries
                                                - f2fs_write_checkpoint end
  - __write_node_folio // inode with DENT_BIT_SHIFT set
  SPO, "fsck --dry-run" find inode has already checkpointed but still
  with DENT_BIT_SHIFT set

The state observed by f2fs_need_dentry_mark() can differ from the state
observed in __write_node_folio() after acquiring sbi->node_write. The
root cause is that the semantics of IS_CHECKPOINTED and
HAS_FSYNCED_INODE are only guaranteed after the checkpoint write has
fully completed.

This patch moves set_dentry_mark() into __write_node_folio() and
protects it with the sbi->node_write lock.

Cc: stable@kernel.org
Fixes: 88bd02c9472a ("f2fs: fix conditions to remain recovery information in f2fs_sync_file")
Signed-off-by: Yongpeng Yang <yangyongpeng@xiaomi.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/node.c |   14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -1801,13 +1801,12 @@ static bool __write_node_folio(struct fo
 		goto redirty_out;
 	}
 
-	if (atomic) {
-		if (!test_opt(sbi, NOBARRIER))
-			fio.op_flags |= REQ_PREFLUSH | REQ_FUA;
-		if (IS_INODE(folio))
-			set_dentry_mark(folio,
+	if (atomic && !test_opt(sbi, NOBARRIER))
+		fio.op_flags |= REQ_PREFLUSH | REQ_FUA;
+
+	if (IS_INODE(folio) && (atomic || is_fsync_dnode(folio)))
+		set_dentry_mark(folio,
 				f2fs_need_dentry_mark(sbi, ino_of_node(folio)));
-	}
 
 	/* should add to global list before clearing PAGECACHE status */
 	if (f2fs_in_warm_node_list(sbi, folio)) {
@@ -1948,9 +1947,6 @@ continue_unlock:
 					if (is_inode_flag_set(inode,
 								FI_DIRTY_INODE))
 						f2fs_update_inode(inode, folio);
-					if (!atomic)
-						set_dentry_mark(folio,
-							f2fs_need_dentry_mark(sbi, ino));
 				}
 				/* may be written by other thread */
 				if (!folio_test_dirty(folio))


