Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7586C881E;
	Tue,  8 Jul 2025 16:31:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992271; cv=none; b=JZiucRKuzvsI1XOdz33PGLv+ihTuTCugMxPXvPH7ijyeSXbAzQPoxB50hw147FdY6JguOUz6V3p/kR6aG2CNSj1E+spmvcUt9jKH0giEIYomM/7WLf1sR8f7zzfsR1yj2gN/k1XRg+mChr7TjceFtJ0ZFUaALuOfKveab7QxmXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992271; c=relaxed/simple;
	bh=/pp1hQQnJLyqaEy7Qy52neRWtlVE7bB0YycvzMnpe9s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OVE7+fDkvgObfd1HitBm6PoqXhqHbMOZd/dSlHGAMhibC6c+/s7sNxGSd3mfk7EHDbvMnhF4vJ5U5pvNprc7PYOPT+VJGAJyj4yAseUxFeNOdxjZJfmaTHkJeUlV1sOkX3TlOQrpFH8M/Lc8dmj1Va126EMxM8YarOiY3Rmvhcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ISEitlNJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ISEitlNJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2C6FC4CEED;
	Tue,  8 Jul 2025 16:31:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992271;
	bh=/pp1hQQnJLyqaEy7Qy52neRWtlVE7bB0YycvzMnpe9s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ISEitlNJFTjJmD70HHj9FzpAb/SEKMeC8+Zqd/AVkcPOUs3CC8c3Qj6ZTnDQP5j0O
	 MGX1QLg7oFHT9Mg96DSMONyPKshDT1DffR86wPMxGL98kjC3D0nCF+x7/AqG5HsFI+
	 ChQaZmoFXP/bAim5O1OlCuusQvdDP5aMbYFzTGt4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 035/132] btrfs: use btrfs_record_snapshot_destroy() during rmdir
Date: Tue,  8 Jul 2025 18:22:26 +0200
Message-ID: <20250708162231.726651878@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162230.765762963@linuxfoundation.org>
References: <20250708162230.765762963@linuxfoundation.org>
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
index cee1a11959c51..e8e57abb032d7 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4657,7 +4657,7 @@ static int btrfs_rmdir(struct inode *dir, struct dentry *dentry)
 	 * deletes for directory foo.
 	 */
 	if (BTRFS_I(inode)->last_unlink_trans >= trans->transid)
-		BTRFS_I(dir)->last_unlink_trans = BTRFS_I(inode)->last_unlink_trans;
+		btrfs_record_snapshot_destroy(trans, BTRFS_I(dir));
 
 	if (unlikely(btrfs_ino(BTRFS_I(inode)) == BTRFS_EMPTY_SUBVOL_DIR_OBJECTID)) {
 		ret = btrfs_unlink_subvol(trans, BTRFS_I(dir), dentry);
-- 
2.39.5



