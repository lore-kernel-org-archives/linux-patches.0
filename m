Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF4FA4E0214;
	Thu, 17 Sep 2026 15:49:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660155; cv=none; b=CfPasegmlngfhdzpvqtQsfrOwXWeOZkhW4tYroZOu41PrhIcclo7hHz927LNtXrLDhVl9I4g57LfZYFhOjiP9m2YfCha7BpqrVCq0r3ZEIOf6lKwg7oUhe6clg4ZjgIEN/kyMAi78dwWbjnL/z0UAdG/3w8T6CV16irMhJLiw6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660155; c=relaxed/simple;
	bh=06nNhiGLjalvomWFDiNCb3dZP8jO+jnOStq+hEHts9Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GauywdoqnQfOOpbHkuIhEikGam1I0OhBCUIVWSAwq6MXrF4WMgQ6HkEPCOM5Sq/F5a3NkoagAfjOndsMoTWEFsbecsIipIaCWfZ2d0BuuxBKxjmO1h89JKGwH6ULxbS3VT+KLIVYBxdTLnohHhipWYEoeB8sn+IMTUkOzIy3vBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qvcf5JgW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qvcf5JgW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A3F21F00898;
	Thu, 17 Sep 2026 15:49:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660142;
	bh=sIY3QJ947oGrn+1aNmNdCTRap+h7vXgA8QlZ/u/C8po=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qvcf5JgWqQtCA1DbU7wDJNHVppRI2y1fKup1Lv7ERCKdKVKTaPKMnSxhz9srtpfzT
	 FE/ohFqoeQDeuE8iQCmETPywI3IKGX4VI77HKujJK90etVyU9Ss8OPFdvUQN9Nwqj9
	 OeYzLRyWomgDRQGCLWCSXNFOn7OHbbwXzdvy5mUE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ali Ahmet Memis <ali@iusegentoo.com>,
	Jan Kara <jack@suse.cz>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 7.2 491/733] ufs: create the root dentry after loading cylinder metadata
Date: Thu, 17 Sep 2026 16:13:19 +0100
Message-ID: <20260917151404.294391423@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

From: Ali Ahmet Memis <ali@iusegentoo.com>

commit 55a4c98abb9694b067c6a031d11501f06b6b523c upstream.

ufs_fill_super() installed sb->s_root before it loaded the cylinder
group structures for a writable mount:

	sb->s_root = d_make_root(inode);
	...
	if (!sb_rdonly(sb))
		if (!ufs_read_cylinder_structures(sb))
			goto failed;

When ufs_read_cylinder_structures() failed, the error path freed the
in-core superblock information and set sb->s_fs_info to NULL while
sb->s_root stayed installed. get_tree_bdev() then reached
deactivate_locked_super(), and because s_root was present,
generic_shutdown_super() called sync_filesystem() and the put_super
operation. Both dereference UFS_SB(sb), which is now NULL, so a mount
that fails only while reading the cylinder groups oopses during
teardown. A crafted image whose first cylinder group cannot be read
reaches this path.

Load the cylinder group metadata first and create the root dentry last,
so the superblock is published to the VFS only once it is fully set up.
ufs_setup_cstotal() and ufs_read_cylinder_structures() take only the
super_block and do not use the root inode, so the reordering is safe.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Ali Ahmet Memis <ali@iusegentoo.com>
Link: https://patch.msgid.link/20260801071306.59484-2-ali@iusegentoo.com
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ufs/super.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

--- a/fs/ufs/super.c
+++ b/fs/ufs/super.c
@@ -1199,6 +1199,15 @@ magic_found:
 	sb->s_maxbytes = ufs_max_bytes(sb);
 	sb->s_max_links = UFS_LINK_MAX;
 
+	ufs_setup_cstotal(sb);
+	/*
+	 * Read cylinder group structures
+	 */
+	if (!sb_rdonly(sb))
+		if (!ufs_read_cylinder_structures(sb))
+			goto failed;
+
+	/* create the root dentry last, once UFS_SB(sb) is fully set up */
 	inode = ufs_iget(sb, UFS_ROOTINO);
 	if (IS_ERR(inode)) {
 		ret = PTR_ERR(inode);
@@ -1210,14 +1219,6 @@ magic_found:
 		goto failed;
 	}
 
-	ufs_setup_cstotal(sb);
-	/*
-	 * Read cylinder group structures
-	 */
-	if (!sb_rdonly(sb))
-		if (!ufs_read_cylinder_structures(sb))
-			goto failed;
-
 	UFSD("EXIT\n");
 	return 0;
 


