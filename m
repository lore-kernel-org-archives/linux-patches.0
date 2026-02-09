Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F70C3783A1;
	Mon,  9 Feb 2026 14:37:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770647833; cv=none; b=XeTwvcOFx/KIGTALLcl1jso9XJxQ//XgpRmo/+t8EsQ8c2p0/J5HV1XYOCNFOsIPBZoKkdDDTaCtTSMrFkI6XzQiO3LhNetv/b9aKosS+855KzxRI7GVYJOqSK682G4Yp35sZSTUZVoQvLT50/ZkKOlYRoqj5oGQYJKc06FfoBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770647833; c=relaxed/simple;
	bh=YjNI4mgGZ3LSlSW85rJkyY4kMA7NswwSUzjshT0l5g4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AXvn+M5IfwQupL3APyRzIYG2qoljF+BUtn6EAXvUPRkKAfb0NbCxYSLduXso7xkQIUTw2S3Oa3kfvdOfVt9o3ws9XGTINy1mqXxkl9vEX//X1lp10zV1rIqoXuvGx1aK6CrDMRDOYZVvV/m6mUuuBlvN4Vre2X4/nA1K+8geOA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=klzARrjH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="klzARrjH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAC23C116C6;
	Mon,  9 Feb 2026 14:37:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770647833;
	bh=YjNI4mgGZ3LSlSW85rJkyY4kMA7NswwSUzjshT0l5g4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=klzARrjHyrbDenfj7FD9tV0NlFnZXGbm1gqfaLEH08MP4Z99CG0yJSMWZJKZrWrgu
	 kFQ3vS5m91HClvqB0uh9qJEPiiqB/f0+yqwUSNBOIGpoyPDHeqkElmhsYSaOv3MV27
	 9XmLmjo83dZ8uhVW5+9KgDUe8o9TSn0st593m/9E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 042/113] btrfs: fix reservation leak in some error paths when inserting inline extent
Date: Mon,  9 Feb 2026 15:23:11 +0100
Message-ID: <20260209142311.717774611@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142310.204833231@linuxfoundation.org>
References: <20260209142310.204833231@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit c1c050f92d8f6aac4e17f7f2230160794fceef0c ]

If we fail to allocate a path or join a transaction, we return from
__cow_file_range_inline() without freeing the reserved qgroup data,
resulting in a leak. Fix this by ensuring we call btrfs_qgroup_free_data()
in such cases.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/inode.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index b1d450459f736..b1d9595762ef6 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -658,19 +658,22 @@ static noinline int __cow_file_range_inline(struct btrfs_inode *inode, u64 offse
 	struct btrfs_drop_extents_args drop_args = { 0 };
 	struct btrfs_root *root = inode->root;
 	struct btrfs_fs_info *fs_info = root->fs_info;
-	struct btrfs_trans_handle *trans;
+	struct btrfs_trans_handle *trans = NULL;
 	u64 data_len = (compressed_size ?: size);
 	int ret;
 	struct btrfs_path *path;
 
 	path = btrfs_alloc_path();
-	if (!path)
-		return -ENOMEM;
+	if (!path) {
+		ret = -ENOMEM;
+		goto out;
+	}
 
 	trans = btrfs_join_transaction(root);
 	if (IS_ERR(trans)) {
-		btrfs_free_path(path);
-		return PTR_ERR(trans);
+		ret = PTR_ERR(trans);
+		trans = NULL;
+		goto out;
 	}
 	trans->block_rsv = &inode->block_rsv;
 
@@ -717,7 +720,8 @@ static noinline int __cow_file_range_inline(struct btrfs_inode *inode, u64 offse
 	 */
 	btrfs_qgroup_free_data(inode, NULL, 0, PAGE_SIZE, NULL);
 	btrfs_free_path(path);
-	btrfs_end_transaction(trans);
+	if (trans)
+		btrfs_end_transaction(trans);
 	return ret;
 }
 
-- 
2.51.0



