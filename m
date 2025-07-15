Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF3B82EA726;
	Tue, 15 Jul 2025 13:49:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587374; cv=none; b=clUvxJKceygQ3V+OsnfK++1r7e9h0tAM8rkGodzfOifxLqhmhKYGMLAX7YcdbDsXiqqF4WfQgHGV85CkULkZOxOf6qnyas8Nf2HrAkZob6ph59+neDgeZS24Ww4/G/0BS1aaZT44Ub0uH4cy6g/qsMeVjhYmI/kkXlHF4bodSWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587374; c=relaxed/simple;
	bh=95c7cSpsjnXN2POgL9tV4RpmkHta3PFi9J0CUG76W9c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UP5MnEz4kVEe+9cwmrIZUeifA0yTQRc2MNp/vzbDU+Ylg4GtrPIoI5HZiQyh/9Z6Fo/cH8ClRfBIXq1TI6S4vx5cHC/Ljxm2TFenXG9Oe/9G+pbb+3oLUXnvIsca2mCLbokbm0MBtoAzsd/UpSFJC9u16et4bT0CjdlmPykIh7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ltTAGaKm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ltTAGaKm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E94CC4CEE3;
	Tue, 15 Jul 2025 13:49:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587373;
	bh=95c7cSpsjnXN2POgL9tV4RpmkHta3PFi9J0CUG76W9c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ltTAGaKmKDQTAs0wWwNjFKKj4nqp4XHEhUNJViesGnV2dWJ2eJe0akVuOfOE3mqhX
	 rOBZlTr+q3kiCW8JUBk9OInZ0l9d8Bx2Zqu/yCtsHY86c+uXYCHAkoIeT2LGoW3hqe
	 tCmgU/xe5PgEkkBs4BBktfBUXurowNabTcRhatYw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 45/88] btrfs: propagate last_unlink_trans earlier when doing a rmdir
Date: Tue, 15 Jul 2025 15:14:21 +0200
Message-ID: <20250715130756.343011415@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130754.497128560@linuxfoundation.org>
References: <20250715130754.497128560@linuxfoundation.org>
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

[ Upstream commit c466e33e729a0ee017d10d919cba18f503853c60 ]

In case the removed directory had a snapshot that was deleted, we are
propagating its inode's last_unlink_trans to the parent directory after
we removed the entry from the parent directory. This leaves a small race
window where someone can log the parent directory after we removed the
entry and before we updated last_unlink_trans, and as a result if we ever
try to replay such a log tree, we will fail since we will attempt to
remove a snapshot during log replay, which is currently not possible and
results in the log replay (and mount) to fail. This is the type of failure
described in commit 1ec9a1ae1e30 ("Btrfs: fix unreplayable log after
snapshot delete + parent dir fsync").

So fix this by propagating the last_unlink_trans to the parent directory
before we remove the entry from it.

Fixes: 44f714dae50a ("Btrfs: improve performance on fsync against new inode after rename/unlink")
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/inode.c | 28 +++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 5ecc2f3dc3a99..469a622b440b6 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4881,6 +4881,23 @@ static int btrfs_rmdir(struct inode *dir, struct dentry *dentry)
 		goto out_notrans;
 	}
 
+	/*
+	 * Propagate the last_unlink_trans value of the deleted dir to its
+	 * parent directory. This is to prevent an unrecoverable log tree in the
+	 * case we do something like this:
+	 * 1) create dir foo
+	 * 2) create snapshot under dir foo
+	 * 3) delete the snapshot
+	 * 4) rmdir foo
+	 * 5) mkdir foo
+	 * 6) fsync foo or some file inside foo
+	 *
+	 * This is because we can't unlink other roots when replaying the dir
+	 * deletes for directory foo.
+	 */
+	if (BTRFS_I(inode)->last_unlink_trans >= trans->transid)
+		BTRFS_I(dir)->last_unlink_trans = BTRFS_I(inode)->last_unlink_trans;
+
 	if (unlikely(btrfs_ino(BTRFS_I(inode)) == BTRFS_EMPTY_SUBVOL_DIR_OBJECTID)) {
 		err = btrfs_unlink_subvol(trans, dir, dentry);
 		goto out;
@@ -4895,17 +4912,6 @@ static int btrfs_rmdir(struct inode *dir, struct dentry *dentry)
 				 &fname.disk_name);
 	if (!err) {
 		btrfs_i_size_write(BTRFS_I(inode), 0);
-		/*
-		 * Propagate the last_unlink_trans value of the deleted dir to
-		 * its parent directory. This is to prevent an unrecoverable
-		 * log tree in the case we do something like this:
-		 * 1) create dir foo
-		 * 2) create snapshot under dir foo
-		 * 3) delete the snapshot
-		 * 4) rmdir foo
-		 * 5) mkdir foo
-		 * 6) fsync foo or some file inside foo
-		 */
 		if (BTRFS_I(inode)->last_unlink_trans >= trans->transid)
 			btrfs_record_snapshot_destroy(trans, BTRFS_I(dir));
 	}
-- 
2.39.5



