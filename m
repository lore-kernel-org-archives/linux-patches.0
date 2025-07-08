Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8F772A1BA;
	Tue,  8 Jul 2025 16:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992113; cv=none; b=SZeoS7YsIdN9V037xDHj8SrvCrChytNbj06nKAz6ZFwxMElEvg1Xo1vpjgsY3HIsqhzzcoHobqQlPh5VtyONTEmnNoc7lAveexJzihWQHKhyrfEnLJfviVMPaxczbRvDFdbefKy7OuRFbLbq9/DNAIEWGPqotaTBZ0eHqUS0dho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992113; c=relaxed/simple;
	bh=AZEuTd0oRBMGKEkaW6FBWwU9XAgUhDknp6hFvSwZOUY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uZMuUDV/w73Rf/rHErA3WMGr+csGtCSkvyC1D6+a6pcSbG/h/kLFItObIkHguOq8furcVcQgxf3DZ7eGhxyRdvR6kr1xeibSAkQpBnQTCBzGdJHh+Vow0+RL4Q9lDcFgBqkV72jPhjHrYiTmS1c3z+u1rhVD8NCvkO1M7LkBfbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YHgHfmFe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YHgHfmFe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50CB9C4CEF0;
	Tue,  8 Jul 2025 16:28:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992113;
	bh=AZEuTd0oRBMGKEkaW6FBWwU9XAgUhDknp6hFvSwZOUY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YHgHfmFe/BoxxgZBeIOc4V5rpG49mLA0ZXNLik/37WsCi47ppW9n9AcQ7aqvWo2YZ
	 GmOX1pmtdSlPC/Fpd+wRlR11OAlT2CUAVk5/lD6xlirhZhAfIwUv/WFYrMzcaoHP4U
	 WTAX07jIrvqipU/EWF1LTLXXRe9UmkhDg4ouZnM8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 63/81] btrfs: use btrfs_record_snapshot_destroy() during rmdir
Date: Tue,  8 Jul 2025 18:23:55 +0200
Message-ID: <20250708162226.975118069@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162224.795155912@linuxfoundation.org>
References: <20250708162224.795155912@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit 157501b0469969fc1ba53add5049575aadd79d80 ]

We are setting the parent directory's last_unlink_trans directly which
may result in a concurrent task starting to log the directory not see the
update and therefore can log the directory after we removed a child
directory which had a snapshot within instead of falling back to a
transaction commit. Replaying such a log tree would result in a mount
failure since we can't currently delete snapshots (and subvolumes) during
log replay. This is the type of failure described in commit 1ec9a1ae1e30
("Btrfs: fix unreplayable log after snapshot delete + parent dir fsync").

Fix this by using btrfs_record_snapshot_destroy() which updates the
last_unlink_trans field while holding the inode's log_mutex lock.

Fixes: 44f714dae50a ("Btrfs: improve performance on fsync against new inode after rename/unlink")
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/inode.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index f7f97cd3cdf06..5ecc2f3dc3a99 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4856,7 +4856,6 @@ static int btrfs_rmdir(struct inode *dir, struct dentry *dentry)
 	struct btrfs_fs_info *fs_info = BTRFS_I(inode)->root->fs_info;
 	int err = 0;
 	struct btrfs_trans_handle *trans;
-	u64 last_unlink_trans;
 	struct fscrypt_name fname;
 
 	if (inode->i_size > BTRFS_EMPTY_DIR_SIZE)
@@ -4891,8 +4890,6 @@ static int btrfs_rmdir(struct inode *dir, struct dentry *dentry)
 	if (err)
 		goto out;
 
-	last_unlink_trans = BTRFS_I(inode)->last_unlink_trans;
-
 	/* now the directory is empty */
 	err = btrfs_unlink_inode(trans, BTRFS_I(dir), BTRFS_I(d_inode(dentry)),
 				 &fname.disk_name);
@@ -4909,8 +4906,8 @@ static int btrfs_rmdir(struct inode *dir, struct dentry *dentry)
 		 * 5) mkdir foo
 		 * 6) fsync foo or some file inside foo
 		 */
-		if (last_unlink_trans >= trans->transid)
-			BTRFS_I(dir)->last_unlink_trans = last_unlink_trans;
+		if (BTRFS_I(inode)->last_unlink_trans >= trans->transid)
+			btrfs_record_snapshot_destroy(trans, BTRFS_I(dir));
 	}
 out:
 	btrfs_end_transaction(trans);
-- 
2.39.5



