Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B71C234A3CB;
	Wed,  3 Dec 2025 16:14:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778441; cv=none; b=UHaRcGK1HUeRh1Rw6G9zFLmpEX235domxLIaNC6EpGmsXAm8E/eNZ0BbJywVfledmPfeAT1ARLf2mOoDuKnISm1i5W0JhhFSJfuLFcBnV2OpVpjw+43hb5db2tagCFgl55o6Cut7aPz0OrCyr9tHE7aRJzAlAc2hOFr8q2GfDGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778441; c=relaxed/simple;
	bh=x/OmtOknhLVSipbcAOzrQ07XVgyf/tjN21Wn8EYkLqg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QRb/spPZnKDaiaNtctrybAxbALZEhNJiiVSTnlA6OV+3Hhy3xkzJhaEuGMRBM1siqrQY03e6QnvU26khrprG3tR22TfjH68epqEHzxenmn/ZqLuLTWER60gFuWHPm39sUd4U3f2OMf1RO7W50ih/aQujY1mTBxYduQ6NWrlw0CA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LkdrEjSo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LkdrEjSo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD1FCC4CEF5;
	Wed,  3 Dec 2025 16:14:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778441;
	bh=x/OmtOknhLVSipbcAOzrQ07XVgyf/tjN21Wn8EYkLqg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LkdrEjSo7FOhrQEuou65MtvugeXdtpnJYPkh9+tWBpkyHnz2ux0t1gNuPf4RZUorg
	 pp6QwpNm5B4YJfuOt+tIeiGCNe/fvhLhOx6FgowYhp8M2loUPUMOrq5/gXMFJjrN1G
	 0ho2DNDK2o7Kci+WYNHBs/L6K4WN+PW0guy0nS4o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Harshvardhan Jha <harshvardhan.j.jha@oracle.com>
Subject: [PATCH 5.15 314/392] btrfs: add helper to truncate inode items when logging inode
Date: Wed,  3 Dec 2025 16:27:44 +0100
Message-ID: <20251203152425.714866906@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

commit 8a2b3da191e5a167bba9776e109b775b21cb4d85 upstream.

Move the call to btrfs_truncate_inode_items(), and the surrounding retry
loop, into a local helper function. This avoids some repetition and avoids
making the next change a bit awkward due to a bit of too much indentation.

This patch is part of a patch set comprised of the following patches:

  btrfs: check if a log tree exists at inode_logged()
  btrfs: remove no longer needed checks for NULL log context
  btrfs: do not log new dentries when logging that a new name exists
  btrfs: always update the logged transaction when logging new names
  btrfs: avoid expensive search when dropping inode items from log
  btrfs: add helper to truncate inode items when logging inode
  btrfs: avoid expensive search when truncating inode items from the log
  btrfs: avoid search for logged i_size when logging inode if possible
  btrfs: avoid attempt to drop extents when logging inode for the first time
  btrfs: do not commit delayed inode when logging a file in full sync mode

This is patch 6/10 and test results are listed in the change log of the
last patch in the set.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Harshvardhan Jha <harshvardhan.j.jha@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/tree-log.c |   32 +++++++++++++++++++-------------
 1 file changed, 19 insertions(+), 13 deletions(-)

--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -3955,6 +3955,21 @@ static int drop_objectid_items(struct bt
 	return ret;
 }
 
+static int truncate_inode_items(struct btrfs_trans_handle *trans,
+				struct btrfs_root *log_root,
+				struct btrfs_inode *inode,
+				u64 new_size, u32 min_type)
+{
+	int ret;
+
+	do {
+		ret = btrfs_truncate_inode_items(trans, log_root, inode,
+						 new_size, min_type, NULL);
+	} while (ret == -EAGAIN);
+
+	return ret;
+}
+
 static void fill_inode_item(struct btrfs_trans_handle *trans,
 			    struct extent_buffer *leaf,
 			    struct btrfs_inode_item *item,
@@ -4548,13 +4563,9 @@ static int btrfs_log_prealloc_extents(st
 			 * Avoid logging extent items logged in past fsync calls
 			 * and leading to duplicate keys in the log tree.
 			 */
-			do {
-				ret = btrfs_truncate_inode_items(trans,
-							 root->log_root,
-							 inode, truncate_offset,
-							 BTRFS_EXTENT_DATA_KEY,
-							 NULL);
-			} while (ret == -EAGAIN);
+			ret = truncate_inode_items(trans, root->log_root, inode,
+						   truncate_offset,
+						   BTRFS_EXTENT_DATA_KEY);
 			if (ret)
 				goto out;
 			dropped_extents = true;
@@ -5531,12 +5542,7 @@ static int btrfs_log_inode(struct btrfs_
 					  &inode->runtime_flags);
 				clear_bit(BTRFS_INODE_COPY_EVERYTHING,
 					  &inode->runtime_flags);
-				while(1) {
-					ret = btrfs_truncate_inode_items(trans,
-						log, inode, 0, 0, NULL);
-					if (ret != -EAGAIN)
-						break;
-				}
+				ret = truncate_inode_items(trans, log, inode, 0, 0);
 			}
 		} else if (test_and_clear_bit(BTRFS_INODE_COPY_EVERYTHING,
 					      &inode->runtime_flags) ||


