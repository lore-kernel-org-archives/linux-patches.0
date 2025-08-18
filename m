Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 772EF33EB0C;
	Mon, 18 Aug 2025 14:13:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755526402; cv=none; b=MdbUUENFZage1uWXST43iTwQtnvLmXRSco2q5QIIO7d1dka3uWcBXwWMWJUDH+pXWsF2ux8swnmqaMDeVJWU141qX1P3mG0jyGT7JVio4xH8Y01RGRX8sSH5UxnrToS6fM+a9pM1g2b5GtjLRQFlmOfQE7HZur3hdazQecjVm/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755526402; c=relaxed/simple;
	bh=9E8kn1e6rd8AxmgpPnMcbV8RtIn+h/ttqbYONQNrdpQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jMn9iNTmJb7z6LwQJOCSt5PdqXJkQETEcYwDJQU0/9pzyBprD2RTpMbgEdRfT/Tr5MfQ9XRL+4ElG8sOu2Sng9MZZfS5LN5RFHKWepPBVIEWqUEiobjeqU/BdcXpbzDkFMcoLImpzZFfuY7BrRzjFmi5P5TDoSFsmoEClZZuwbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=deKrh4fJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="deKrh4fJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC65FC113D0;
	Mon, 18 Aug 2025 14:13:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755526402;
	bh=9E8kn1e6rd8AxmgpPnMcbV8RtIn+h/ttqbYONQNrdpQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=deKrh4fJqyNyIqXno2Pl9EMcC6IeCgp/2PoulvJ1zDYIhkZSKNeMha0G1sUtBkpBg
	 0jSp/z9m9RD8rXZuil5yw3Nkjy36kzNuUrKRgYsqfdSAk34OK9Kjrevp+mxBndkPmR
	 n1hjr3oZV7UJhLVI9woIt3eJIXNVPLaK/G/VMy0g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Burkov <boris@bur.io>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.16 518/570] btrfs: dont ignore inode missing when replaying log tree
Date: Mon, 18 Aug 2025 14:48:25 +0200
Message-ID: <20250818124525.821368278@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1383,6 +1383,8 @@ static noinline int add_inode_ref(struct
 	dir = btrfs_iget_logging(parent_objectid, root);
 	if (IS_ERR(dir)) {
 		ret = PTR_ERR(dir);
+		if (ret == -ENOENT)
+			ret = 0;
 		dir = NULL;
 		goto out;
 	}
@@ -1407,6 +1409,15 @@ static noinline int add_inode_ref(struct
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
@@ -2519,9 +2530,8 @@ static int replay_one_buffer(struct btrf
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


