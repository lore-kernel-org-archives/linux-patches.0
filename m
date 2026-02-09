Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEB8836828A;
	Mon,  9 Feb 2026 14:42:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770648170; cv=none; b=bUnclrWziycONI9bPmdml3lZq4781Is4shoqfvSM9ofqn8V6vuYt2mmjsFtLLBMqP3k9iBg0oMHZYgfZ5j+Rtk/tQtWmqXbAsUHCmVUM+0t6FL2KbXshmEgTurQz1dtg58GwfpsqbNCwN4CzDiq0yPJIVoA4rMlJk3ijpmoOGdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770648170; c=relaxed/simple;
	bh=9+YYedW9ALtjd8iPBjvNQm4tcky03WEzwt9XA2rXYHU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=khM2NYoawaUOuJfOgGtnhFuH1vTWxB3m8mF4PDsIppZT098xrqWNaCwytQKrnyKj0TxPeiyslI9gu8Ju7NL/NFEue6pSPeb0RIuF+euo1iohUNUdQmyG1WWsCAmX4PKB6b4ouBseNBwO6byf1CtIbnEnwe45gqyf9Cr1g/eVSjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xSM2JGRj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xSM2JGRj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 704F6C116C6;
	Mon,  9 Feb 2026 14:42:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770648169;
	bh=9+YYedW9ALtjd8iPBjvNQm4tcky03WEzwt9XA2rXYHU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xSM2JGRj45GjJIRha7tg3OQAAK6AfTYOBDHHp95EFi3hqvuUS7HEmX7j0pFfDnDU8
	 O18zrF3KCzxlEkb2jAFemJUzVXvW+/V5ZheGGAieLRNDOvwkpMqvmySA19dPtxn/9i
	 m1CgrZjnH8kE+h0FBxVdfjT6DWDagGB5nGSo5Ofw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 27/69] btrfs: fix reservation leak in some error paths when inserting inline extent
Date: Mon,  9 Feb 2026 15:23:55 +0100
Message-ID: <20260209142302.903907512@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142301.913348974@linuxfoundation.org>
References: <20260209142301.913348974@linuxfoundation.org>
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
index 78cd7b8ccfc85..c409fb3e55bf8 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -397,7 +397,7 @@ static noinline int cow_file_range_inline(struct btrfs_inode *inode, u64 size,
 	struct btrfs_drop_extents_args drop_args = { 0 };
 	struct btrfs_root *root = inode->root;
 	struct btrfs_fs_info *fs_info = root->fs_info;
-	struct btrfs_trans_handle *trans;
+	struct btrfs_trans_handle *trans = NULL;
 	u64 data_len = (compressed_size ?: size);
 	int ret;
 	struct btrfs_path *path;
@@ -415,13 +415,16 @@ static noinline int cow_file_range_inline(struct btrfs_inode *inode, u64 size,
 		return 1;
 
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
 
@@ -468,7 +471,8 @@ static noinline int cow_file_range_inline(struct btrfs_inode *inode, u64 size,
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



