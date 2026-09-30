Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8651C2C21FD;
	Wed, 30 Sep 2026 18:07:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791645; cv=none; b=d7HAFQCxbcQqsnG3NdhxZx9eDVqlomhzUDIQ16zuP5in8jmIBmQmfEtZNFhAuH33yd5gG3Y/3ZUy+TzJH8qBf744VLI80o3/uoBful50a7arZTaGw8ujMxzw9ceDu29vJN0PzbQ0EVQpd+FWpNiNpi/Kuw0fidJOB4INOjSkjoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791645; c=relaxed/simple;
	bh=dtiwdHm7QKUOyc/IVHqBekdWFuERQM7B/RmuVk/nfSw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mMPZ3EPq1E6VQM/gU7nCkX5aeOi3P8jmanaTORgbUI1l3IU7ZVb0xZOLU8GwqhNRV6G3cRFQHJshZaCH2t1/A5D0sL23tCaOJZhkqHYSF543qV4xKSgPmGi/h8q8SGNbFO/7cKmNfTLdvLrogZC6xnDdbAKvUEKFKyHyozNVNkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sDyynTTb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sDyynTTb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E04C11F000FF;
	Wed, 30 Sep 2026 18:07:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791644;
	bh=8Lko4zR+ZvAEBjNTlukd5awXNr3Ki5DBqcTeXOYgaN8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sDyynTTbzGmNt47danjy2TuXdCV5ss0ogSsu4wQkBjlg/EzvGISfgSoHhOBq60uhR
	 ZCMwxBztqBpPn4R+udvzB5zX4Xm5ClYsK1UVyrJsCugN4vNo2XdpvB6pe9TMFzHrbH
	 752EKUjq+DsvRHpruMRJpxqln7B+iqJoXSqQaZy4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ali Ahmet Memis <ali@iusegentoo.com>,
	Jan Kara <jack@suse.cz>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 5.15 376/752] ufs: create the root dentry after loading cylinder metadata
Date: Wed, 30 Sep 2026 17:24:06 +0200
Message-ID: <20260930152406.414790521@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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
@@ -1268,6 +1268,15 @@ magic_found:
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
@@ -1279,14 +1288,6 @@ magic_found:
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
 


