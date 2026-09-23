Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 617384A2058;
	Wed, 23 Sep 2026 14:21:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173273; cv=none; b=Bz+x7tPXzdVjTqXrY1cKKmDpwcsfbiMf/SQk2YuLOWf41vuaE1/21I4AOU8HMM7oVmKoKALLQp/wM4bDsrTCUpm8eR2E1ksXEWMdY1Coyz2k9HyE11kYpWtqcBE4m+TzOmcfMEvWcZbyzqY+EQ9ztIyKMT6qc/AY0frfS3jeG0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173273; c=relaxed/simple;
	bh=x93kTaAfyQ9VxVRTFziDQGPKbzd5b5AA80tgSDNDLRY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qhvGyilkvT79ox3XdDNEkUFy4E11ktdBnh2ObCF3/G63wKFg2JeKGCM93J77MF5U8/XCW4ixYsF4bzEYKYfkS0OKVDRhiH//IIEDYHmyV0aoMcHYK/R7wLuah1sQCX5ze6/syo7yI7L5maanbfY2WH/dj5w43qF1wdK8ZAIbkaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GHcEupR+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GHcEupR+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A21A1F000FF;
	Wed, 23 Sep 2026 14:21:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173271;
	bh=xSLc7SJc/nOYq6ViKhJhZbYG7bUmig4IGLj+zu6dtJo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GHcEupR+QoA5vlMxEcQbClhLWckveXthqK6nmfCz+g2wiQKc1SUK0TWOqkjQkqmRt
	 oraHWRorSBbSHKuIAvsa50hZb8iNZmSFgCvHhglE0RhWSKs2M8QkiyiWDM9VbTu7sC
	 cKZQVE4w30FRLuDIcPK075ThLvj4S2er+jsqDwf0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Daniel Linjama <daniel@dev.linjama.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 196/438] btrfs: handle lack of space when cleaning up verity items
Date: Wed, 23 Sep 2026 16:03:37 +0200
Message-ID: <20260923140649.839430965@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Linjama <daniel@dev.linjama.com>

[ Upstream commit 76bf149cd0298544631e756670b89c399c7acbca ]

When enable_verity() hits the qgroup limit, rollback_verity() needs its
own metadata reservation. When the qgroup limit or lack of space refuses
the rollback, the whole filesystem is forced read-only even though the
qgroup limit was for one subvolume only. Also orphan cleanup at the next
mount fails the same way, so the leftover items are never removed: with
-EDQUOT the subvolume stays unreachable, and with -ENOSPC on a full
filesystem the next read-write mount fails.

Start transactions with btrfs_start_transaction_fallback_global_rsv() in
btrfs_orphan_cleanup(), drop_verity_items() and rollback_verity(). Those
calls only delete items and free the space in the end, so they may use
the global reserve and skip the qgroup limit, which avoids -ENOSPC and
-EDQUOT.

Fixes: 146054090b08 ("btrfs: initial fsverity support")
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Daniel Linjama <daniel@dev.linjama.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/inode.c  |  3 ++-
 fs/btrfs/verity.c | 18 ++++++++++++++++--
 2 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 188b4ac9889fc..67f39347acc05 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3876,7 +3876,8 @@ int btrfs_orphan_cleanup(struct btrfs_root *root)
 				if (ret)
 					goto out;
 			}
-			trans = btrfs_start_transaction(root, 1);
+			/* Only deletes the orphan. */
+			trans = btrfs_start_transaction_fallback_global_rsv(root, 1);
 			if (IS_ERR(trans)) {
 				ret = PTR_ERR(trans);
 				goto out;
diff --git a/fs/btrfs/verity.c b/fs/btrfs/verity.c
index 1133a56c0568b..1f05525386c93 100644
--- a/fs/btrfs/verity.c
+++ b/fs/btrfs/verity.c
@@ -93,6 +93,20 @@ static loff_t merkle_file_pos(const struct inode *inode)
 	return rounded;
 }
 
+/*
+ * Start a transaction for removing verity items or the verity orphan.
+ *
+ * Like unlink, this only deletes items and frees space in the end, so the
+ * reservation may come from the global reserve when the filesystem is full
+ * (-ENOSPC) and is not subject to the qgroup limit (-EDQUOT). Otherwise a
+ * failed enable could never be cleaned up in either situation.
+ */
+static struct btrfs_trans_handle *start_verity_cleanup_trans(struct btrfs_root *root,
+							     unsigned int num_items)
+{
+	return btrfs_start_transaction_fallback_global_rsv(root, num_items);
+}
+
 /*
  * Drop all the items for this inode with this key_type.
  *
@@ -120,7 +134,7 @@ static int drop_verity_items(struct btrfs_inode *inode, u8 key_type)
 
 	while (1) {
 		/* 1 for the item being dropped */
-		trans = btrfs_start_transaction(root, 1);
+		trans = start_verity_cleanup_trans(root, 1);
 		if (IS_ERR(trans))
 			return PTR_ERR(trans);
 
@@ -466,7 +480,7 @@ static int rollback_verity(struct btrfs_inode *inode)
 	 * 1 for updating the inode flag
 	 * 1 for deleting the orphan
 	 */
-	trans = btrfs_start_transaction(root, 2);
+	trans = start_verity_cleanup_trans(root, 2);
 	if (IS_ERR(trans)) {
 		ret = PTR_ERR(trans);
 		trans = NULL;
-- 
2.53.0



