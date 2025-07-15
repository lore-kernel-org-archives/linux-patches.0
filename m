Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A02F226E6F1;
	Tue, 15 Jul 2025 13:30:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586237; cv=none; b=oV2sKiWt0m7CjcsWsGrQUDUrggnT3PvRIjfJa1eDO/w7UOZPn2hzFjFYIsAdA/nVYK4+iWLksWCWy9tYHYiF2DCbOkdV5HyqHxf6a6qgVUDsX42kRM+6FtKa70LTxS5Zj2pz1Pw/4HF5WkYuu9pdu+y0R8ZSjXfF98mZK0ngF9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586237; c=relaxed/simple;
	bh=ORF6ulIg8jRbzwGc0acqEKK/akiuHAA2yXexwt0/uTg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DYXkfLSihA+7JQSslGc2ZDty98yAB+cO3UiZiK5Sut8VwiBFc9M76O3DVvQDmtUS93gmk9v57vCZWhXUqTl06+9n/3zre+h1blXcl9nCejDVNPLVGrGEFRnslf0OsHgVtxIxiewQFqdpENxMSenx7O+VMTcySa/QJIJySUeaxII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oi0qguGu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oi0qguGu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D307FC4CEF6;
	Tue, 15 Jul 2025 13:30:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586237;
	bh=ORF6ulIg8jRbzwGc0acqEKK/akiuHAA2yXexwt0/uTg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oi0qguGuoabO2iDFukdYnoX7IfCJmNZ08JM4E4Vvkw4TpLgXSMJQxsmkZLDQemyI1
	 hgdcqw5de5oXx8Vy9k2UQjRmMUydVDdsSKD36mm1Dn3TETm381hSdIlBvvRMPeo/yd
	 CgodEwO5Aa3j+VPgAEFQBYjBjbi5fizLRoDRyvLs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 36/77] btrfs: use btrfs_record_snapshot_destroy() during rmdir
Date: Tue, 15 Jul 2025 15:13:35 +0200
Message-ID: <20250715130753.158320359@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130751.668489382@linuxfoundation.org>
References: <20250715130751.668489382@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 fs/btrfs/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 60079099e24b9..27aaa5064ff7e 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4680,7 +4680,7 @@ static int btrfs_rmdir(struct inode *dir, struct dentry *dentry)
 	 * deletes for directory foo.
 	 */
 	if (BTRFS_I(inode)->last_unlink_trans >= trans->transid)
-		BTRFS_I(dir)->last_unlink_trans = BTRFS_I(inode)->last_unlink_trans;
+		btrfs_record_snapshot_destroy(trans, BTRFS_I(dir));
 
 	if (unlikely(btrfs_ino(BTRFS_I(inode)) == BTRFS_EMPTY_SUBVOL_DIR_OBJECTID)) {
 		err = btrfs_unlink_subvol(trans, dir, dentry);
-- 
2.39.5



