Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EFE22EE281;
	Thu,  3 Jul 2025 15:05:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555123; cv=none; b=TscxxDsQcbDNTrvf18j/SUNJMOqgHcbA7XhkphBjy9ZmYi35gKZRpV6FY+7zeAl3gZNsYJxM7sQXHhNHkOVdru5wpcbwusiIl/5A0R+NRJM3sHoxZjtGxhqOi3o+AxjwHgdMG/BqX4zaOfH8r6QkKKKKzrUIlAqYvRfz4ju2bK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555123; c=relaxed/simple;
	bh=TpSl7HbIRGGQYgiNmW9zfT5BO5urNEkxeDC8aFikjE0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mnWwSCNuoO/Y9PWMnm6c60lvGQeZzR3LkxOnEmaUiWJE/aK9iIhs6YWQ00awUO/uqVptpz3pF12fzjAKyX5zV33qloEyhHY2AkvWEoUb9CDskA0zMO8/D5z0ME9Ia0FGjc/qMGIqztTapYApDETJ/Nxf3CvQKrmQCSwxafC7Wn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MgVRPltd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MgVRPltd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9AD0C4CEE3;
	Thu,  3 Jul 2025 15:05:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555123;
	bh=TpSl7HbIRGGQYgiNmW9zfT5BO5urNEkxeDC8aFikjE0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MgVRPltdmKHHUOE1UOJH/ESCcd4/aEN+tn4zCK5styuWBsPhmdUT/v1PLuY2QvNdO
	 f/uk20vysqtkGwaZb5bjL0+bsq6XecAtyYVKzxev1h77FIE4jb41PahNeOSDMm5Bw2
	 cdqSLUSLw39Hxmc8QltYH5GfT9pv+F6RTiHfwa3Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.15 182/263] btrfs: fix invalid inode pointer dereferences during log replay
Date: Thu,  3 Jul 2025 16:41:42 +0200
Message-ID: <20250703144011.642467134@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

commit 2dcf838cf5c2f0f4501edaa1680fcad03618d760 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/tree-log.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 97e933113b82..21d2f3dded51 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -668,15 +668,12 @@ static noinline int replay_one_extent(struct btrfs_trans_handle *trans,
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
@@ -961,7 +958,8 @@ static noinline int drop_one_dir_item(struct btrfs_trans_handle *trans,
 	ret = unlink_inode_for_log_replay(trans, dir, inode, &name);
 out:
 	kfree(name.name);
-	iput(&inode->vfs_inode);
+	if (inode)
+		iput(&inode->vfs_inode);
 	return ret;
 }
 
@@ -1176,8 +1174,8 @@ static inline int __add_inode_ref(struct btrfs_trans_handle *trans,
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
2.50.0



