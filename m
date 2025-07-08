Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5177A1CD1E4;
	Tue,  8 Jul 2025 16:38:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992704; cv=none; b=uRIQFtrpft2SivTnZ0wikA/KmXTRBcKDFiFqkia6pP6/l7nVTSHoueS+5yfnGh8fliIH/uDoQsaTzmEERl2XH43Q9+yHNDRnT5+4bdDbqBY//iruqDFrgQ/vl4gJC/yqlOaargaTz0B772BGxUC0fMYBGr+c1EbONeS6nyBJ8zw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992704; c=relaxed/simple;
	bh=kHIa0lJSgXb2PgqlFneyZQA/IdNm59tIa9N0ZO01IgQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=to2x+MRbTwE76AlWYCmXa0kMoEacRiikWyScpMCbS0qyFBZYD6+NWPE2hyDPdgLkL3MTYdtNwIkuB22khlrEnQZQdjdovZSuvmSVMCV5oxSxCpqqW/fzY2tgPt0nPSEX3t6ieb88PAyHwu11MvXv29lvOMZxegIS+68LuV8Vvsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NZvYZdQr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NZvYZdQr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94872C4CEED;
	Tue,  8 Jul 2025 16:38:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992704;
	bh=kHIa0lJSgXb2PgqlFneyZQA/IdNm59tIa9N0ZO01IgQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NZvYZdQr4WY+JEHeiNjdBWlWhfnKiYyhczftAV6JgMlavY2P2EccZnr709RKCM4tY
	 wqmHKT99bl4D3eDOH7wdqrQNyuu+fyy8n5g9uRDrrmy5X8tdPFQVHGCqQmnA3EXIjo
	 QlF4fsKmpKryC+lSvLyAMdvSk7OKUxxhNK+Zb9xQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 051/232] btrfs: fix invalid inode pointer dereferences during log replay
Date: Tue,  8 Jul 2025 18:20:47 +0200
Message-ID: <20250708162242.799367098@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162241.426806072@linuxfoundation.org>
References: <20250708162241.426806072@linuxfoundation.org>
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

[ Upstream commit 2dcf838cf5c2f0f4501edaa1680fcad03618d760 ]

In a few places where we call read_one_inode(), if we get a NULL pointer
we end up jumping into an error path, or fallthrough in case of
__add_inode_ref(), where we then do something like this:

   iput(&inode->vfs_inode);

which results in an invalid inode pointer that triggers an invalid memory
access, resulting in a crash.

Fix this by making sure we don't do such dereferences.

Fixes: b4c50cbb01a1 ("btrfs: return a btrfs_inode from read_one_inode()")
CC: stable@vger.kernel.org # 6.15+
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: 5f61b961599a ("btrfs: fix inode lookup error handling during log replay")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/tree-log.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 7a1c7070287b2..f4317fce569b7 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -677,15 +677,12 @@ static noinline int replay_one_extent(struct btrfs_trans_handle *trans,
 		extent_end = ALIGN(start + size,
 				   fs_info->sectorsize);
 	} else {
-		ret = 0;
-		goto out;
+		return 0;
 	}
 
 	inode = read_one_inode(root, key->objectid);
-	if (!inode) {
-		ret = -EIO;
-		goto out;
-	}
+	if (!inode)
+		return -EIO;
 
 	/*
 	 * first check to see if we already have this extent in the
@@ -977,7 +974,8 @@ static noinline int drop_one_dir_item(struct btrfs_trans_handle *trans,
 	ret = unlink_inode_for_log_replay(trans, dir, inode, &name);
 out:
 	kfree(name.name);
-	iput(&inode->vfs_inode);
+	if (inode)
+		iput(&inode->vfs_inode);
 	return ret;
 }
 
@@ -1194,8 +1192,8 @@ static inline int __add_inode_ref(struct btrfs_trans_handle *trans,
 					ret = unlink_inode_for_log_replay(trans,
 							victim_parent,
 							inode, &victim_name);
+					iput(&victim_parent->vfs_inode);
 				}
-				iput(&victim_parent->vfs_inode);
 				kfree(victim_name.name);
 				if (ret)
 					return ret;
-- 
2.39.5



