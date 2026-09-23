Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43B2B5013D4;
	Wed, 23 Sep 2026 14:43:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174596; cv=none; b=ALJXU9perqGelNknHlQB4arZZePALyfis3Nm4s3zzMPbKYdY4pd9enPlzl7bGBdW5LlCjhy1JS9J3eBf37zHiQaRX4UGPI4/4LMaegX9dmThABYrgnVuRnHQjWZgKEAaxdG2A5btR1cQfVN5E5sUaqzqzFCM7Uy2dM8PrfWQgio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174596; c=relaxed/simple;
	bh=L3iN78btqbxNX9/VVp+kNKuXyoLeLSjpnL8tCRiYFlY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rLXDYvXa3ecgaS9rudxjwgtNAHhjgqnFVJvPxwtwB+uLwDK2Ewl3UboQPB9ko36hBfE+Jlx7W09M8FR6ukpQ/xmJ84FC+iiFMIxYNvDn650h64DGHXUVLATyK3GRD4Sa+WAy3W3+h/t11zyv3tVe33uORfO93EGKnhPfJcCXn7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LCD9nHzv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LCD9nHzv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 697C31F00898;
	Wed, 23 Sep 2026 14:43:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174595;
	bh=GUXphJThblt3usEEDJXCrbkk0gB/pTDsAEjEvKNtNq4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LCD9nHzvBAxeOQmx/YLnL/cHifWqQSkGipL8EINNDeRmubYXPHeM8/DLiI2jKi8xC
	 9Jy4QojNEUbYAFc/Jc1mBJoUBbRQfoWbCahiYcIgJ2VQC60eztVMZ1dieYmQWIwLcp
	 1xqXPZG1h76R0JwtWQ2zvVekdT18peSXxtp8UPTs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Daniel Linjama <daniel@dev.linjama.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 165/398] btrfs: handle lack of space when cleaning up verity items
Date: Wed, 23 Sep 2026 16:03:59 +0200
Message-ID: <20260923140647.713315177@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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
index 3023e1b504b96..6ab593b893198 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3789,7 +3789,8 @@ int btrfs_orphan_cleanup(struct btrfs_root *root)
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
index 1c8c782307939..43433577076b7 100644
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



