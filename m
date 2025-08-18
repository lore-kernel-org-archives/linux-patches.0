Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99F861E3DCD;
	Mon, 18 Aug 2025 13:12:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522725; cv=none; b=RhYdr9nXtmLX2KFohra6KaxzPxCeP7L7Eel+I7On0LdcIyz+JUo7IKazCOStwFkGe7iDyUtcq62EPV5XiGg1Uu0YpvDisbIz0dhCRyz9obBrzqbteZ/MIKZNJkjDRBMPw1o3woX2m/OtuoU1IQQ6YIpEwgOfBsdvedKVMjhWgY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522725; c=relaxed/simple;
	bh=nSQfhENvk2JHtBLaoiXsan8eqlHeet8c6MBjd11z9yw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OXVXgHiZYMPjFZDE8xvDrf3PYqc1IKk2aKio2DQZ9xhwlXlb0z4Jmvd9HZMGFMmpi3WwSYvGKNOAdbu9S9b6QxhPXGBq1g2j5WdTVOtf8B7eu0g8dBTxiZ7+uY1kW/A+/CljbSrMtYJ2+c25Sa7PEAmkv9QjwCfxmSgo3PjUp4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T9Mx8lz0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T9Mx8lz0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10593C4CEEB;
	Mon, 18 Aug 2025 13:12:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522725;
	bh=nSQfhENvk2JHtBLaoiXsan8eqlHeet8c6MBjd11z9yw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T9Mx8lz0kSlAK3I+KmYas+8Rs9DJhv33p+uY115iw0YORwHW0ZRBcCAQMg00JT9Rf
	 liqmdyjQxyG4WFGj2fOFtRfeE8NgjywMNdttKV1wlP7zoEXwyLv89LgO1hL+D4kShr
	 hiC41mlyenr9gd25ntC87pGxxdbu++fZiQDfa8uY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Burkov <boris@bur.io>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.12 395/444] btrfs: dont ignore inode missing when replaying log tree
Date: Mon, 18 Aug 2025 14:47:01 +0200
Message-ID: <20250818124503.728841447@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

commit 7ebf381a69421a88265d3c49cd0f007ba7336c9d upstream.

During log replay, at add_inode_ref(), we return -ENOENT if our current
inode isn't found on the subvolume tree or if a parent directory isn't
found. The error comes from btrfs_iget_logging() <- btrfs_iget() <-
btrfs_read_locked_inode().

The single caller of add_inode_ref(), replay_one_buffer(), ignores an
-ENOENT error because it expects that error to mean only that a parent
directory wasn't found and that is ok.

Before commit 5f61b961599a ("btrfs: fix inode lookup error handling during
log replay") we were converting any error when getting a parent directory
to -ENOENT and any error when getting the current inode to -EIO, so our
caller would fail log replay in case we can't find the current inode.
After that commit however in case the current inode is not found we return
-ENOENT to the caller and therefore it ignores the critical fact that the
current inode was not found in the subvolume tree.

Fix this by converting -ENOENT to 0 when we don't find a parent directory,
returning -ENOENT when we don't find the current inode and making the
caller, replay_one_buffer(), not ignore -ENOENT anymore.

Fixes: 5f61b961599a ("btrfs: fix inode lookup error handling during log replay")
CC: stable@vger.kernel.org # 6.16
Reviewed-by: Boris Burkov <boris@bur.io>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/tree-log.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -1396,6 +1396,8 @@ static noinline int add_inode_ref(struct
 	dir = btrfs_iget_logging(parent_objectid, root);
 	if (IS_ERR(dir)) {
 		ret = PTR_ERR(dir);
+		if (ret == -ENOENT)
+			ret = 0;
 		dir = NULL;
 		goto out;
 	}
@@ -1420,6 +1422,15 @@ static noinline int add_inode_ref(struct
 				if (IS_ERR(dir)) {
 					ret = PTR_ERR(dir);
 					dir = NULL;
+					/*
+					 * A new parent dir may have not been
+					 * logged and not exist in the subvolume
+					 * tree, see the comment above before
+					 * the loop when getting the first
+					 * parent dir.
+					 */
+					if (ret == -ENOENT)
+						ret = 0;
 					goto out;
 				}
 			}
@@ -2532,9 +2543,8 @@ static int replay_one_buffer(struct btrf
 			   key.type == BTRFS_INODE_EXTREF_KEY) {
 			ret = add_inode_ref(wc->trans, root, log, path,
 					    eb, i, &key);
-			if (ret && ret != -ENOENT)
+			if (ret)
 				break;
-			ret = 0;
 		} else if (key.type == BTRFS_EXTENT_DATA_KEY) {
 			ret = replay_one_extent(wc->trans, root, path,
 						eb, i, &key);


