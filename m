Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 070B23537FC;
	Wed,  8 Apr 2026 18:17:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672232; cv=none; b=DKhSr//7+6HKqdDmvXV0Dhb7QQcUnw/lbor9VTWApvJvdHx/KlQZWjenYOnEZpOYRzUGN1K2Emx8ZZXWUa9z3Bj45HTUr3OP6TLQoYK0/CxV/y01DspowRKc9Peau05uPm/R3yv92eptwUT2CsIhh8zqdGYjeddr53e5csN8Co4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672232; c=relaxed/simple;
	bh=KMSpmPuGbwzDW2UuSpJb4E/VfPhSZ9LGjnEvu3qGKf0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dkYXbk82B+/aLzA9JFwtar8iabFEyZo5l2dPOFVsOmcbVelRJCzeggmSraC3mDnwFMgGB68qoLy64K3jO0ax7bklRP6jHUXItInqr7Hblw1QIJdH5yxF1Igt7uFjxlgZjMHeuriCrYezzd8CRmG0dpSN9Vnc9zhvZpwoYD7MLMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ElIK0J5e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ElIK0J5e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93B3BC19421;
	Wed,  8 Apr 2026 18:17:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672231;
	bh=KMSpmPuGbwzDW2UuSpJb4E/VfPhSZ9LGjnEvu3qGKf0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ElIK0J5eYjVhcnYVTpe6zMbbXxyW9kWXqwBBp9Yux+/V4jua32w3854eKkyQk86dx
	 aU3md2LbC3vSQ43oP8BK4WPcl1+dJwaNBrLb1b/WTuXo4cNf9Q86ceO2SZbmoFPteQ
	 6ZvuomS/LZ3Ux0YnSLE8sanvb0h9f8s0KBQsuc50=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 241/312] Revert "ext4: get rid of ppath in ext4_ext_create_new_leaf()"
Date: Wed,  8 Apr 2026 20:02:38 +0200
Message-ID: <20260408175942.751705560@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.715315542@linuxfoundation.org>
References: <20260408175933.715315542@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

This reverts commit 15908fc35056e9a6fd71552eda884a353496e6c7.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/extents.c | 43 +++++++++++++++++++++----------------------
 1 file changed, 21 insertions(+), 22 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index eda6f92a42330..a58f415f882b2 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -1392,12 +1392,13 @@ static int ext4_ext_grow_indepth(handle_t *handle, struct inode *inode,
  * finds empty index and adds new leaf.
  * if no free index is found, then it requests in-depth growing.
  */
-static struct ext4_ext_path *
-ext4_ext_create_new_leaf(handle_t *handle, struct inode *inode,
-			 unsigned int mb_flags, unsigned int gb_flags,
-			 struct ext4_ext_path *path,
-			 struct ext4_extent *newext)
+static int ext4_ext_create_new_leaf(handle_t *handle, struct inode *inode,
+				    unsigned int mb_flags,
+				    unsigned int gb_flags,
+				    struct ext4_ext_path **ppath,
+				    struct ext4_extent *newext)
 {
+	struct ext4_ext_path *path = *ppath;
 	struct ext4_ext_path *curp;
 	int depth, i, err = 0;
 
@@ -1418,25 +1419,28 @@ ext4_ext_create_new_leaf(handle_t *handle, struct inode *inode,
 		 * entry: create all needed subtree and add new leaf */
 		err = ext4_ext_split(handle, inode, mb_flags, path, newext, i);
 		if (err)
-			goto errout;
+			goto out;
 
 		/* refill path */
 		path = ext4_find_extent(inode,
 				    (ext4_lblk_t)le32_to_cpu(newext->ee_block),
 				    path, gb_flags);
-		return path;
+		if (IS_ERR(path))
+			err = PTR_ERR(path);
 	} else {
 		/* tree is full, time to grow in depth */
 		err = ext4_ext_grow_indepth(handle, inode, mb_flags);
 		if (err)
-			goto errout;
+			goto out;
 
 		/* refill path */
 		path = ext4_find_extent(inode,
 				   (ext4_lblk_t)le32_to_cpu(newext->ee_block),
 				    path, gb_flags);
-		if (IS_ERR(path))
-			return path;
+		if (IS_ERR(path)) {
+			err = PTR_ERR(path);
+			goto out;
+		}
 
 		/*
 		 * only first (depth 0 -> 1) produces free space;
@@ -1448,11 +1452,9 @@ ext4_ext_create_new_leaf(handle_t *handle, struct inode *inode,
 			goto repeat;
 		}
 	}
-	return path;
-
-errout:
-	ext4_free_ext_path(path);
-	return ERR_PTR(err);
+out:
+	*ppath = IS_ERR(path) ? NULL : path;
+	return err;
 }
 
 /*
@@ -2095,14 +2097,11 @@ int ext4_ext_insert_extent(handle_t *handle, struct inode *inode,
 	 */
 	if (gb_flags & EXT4_GET_BLOCKS_METADATA_NOFAIL)
 		mb_flags |= EXT4_MB_USE_RESERVED;
-	path = ext4_ext_create_new_leaf(handle, inode, mb_flags, gb_flags,
-					path, newext);
-	if (IS_ERR(path)) {
-		*ppath = NULL;
-		err = PTR_ERR(path);
+	err = ext4_ext_create_new_leaf(handle, inode, mb_flags, gb_flags,
+				       ppath, newext);
+	if (err)
 		goto cleanup;
-	}
-	*ppath = path;
+	path = *ppath;
 	depth = ext_depth(inode);
 	eh = path[depth].p_hdr;
 
-- 
2.53.0



