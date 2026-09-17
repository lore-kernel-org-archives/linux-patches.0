Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE0E84B44C4;
	Thu, 17 Sep 2026 15:43:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659796; cv=none; b=nvNylAH4TxB3kxI07JLDTEay5C4YvweqOzheuvdurvDA5aZfvyzZ1j5PIljHZlJik+GWcOb4dCTSqKR0huZytQUyLru8pUOms3FbGLuIfCZANU7j0JnH8vNERFjpRS7koGzQKyRxUSNp1b8aw5NY6ZykphRyw35LC0t7sgMg0ss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659796; c=relaxed/simple;
	bh=Sr6bH8BP32iL3z0ofgmIzvMg4xvJCJVu1iFu3CE/Gyw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ej23m/XDUI5End0SC0BI1hUhtb4ij4Gj8QAJy1WPQI/IvO/+2GX689/ANshU8QREDED89jmbtHc6q+FXCwszTuo3sis8OO+eysY5AtLclobfD6YdMD14vtJisky41NEbpiGGVCdvFqQJJFBkA+nXrOhL1v2Bd10i2PB2DGL+kP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=isUu7zTK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="isUu7zTK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D3D71F00893;
	Thu, 17 Sep 2026 15:43:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659785;
	bh=ULU2rDjuO8YIZm7rcbvHcn1nZtMtm+yvhhz1V8Mwf3A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=isUu7zTKgVM/u5CLgHQ+bQWI88lBaauityeZv5XbULH8C0sEXOVTmYaobLkEyU/wV
	 ynKzh/L4XY2ROPbL5X7+Yh+ct9NBRm+nC0jlynwHmjQ9s51L1zxHra2yiC5/7ezH8I
	 GZgx8k4Kj3bnwcCzSnmrzqaKtvckhuHjtrgBBhVE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Burkov <boris@bur.io>,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 335/733] btrfs: fix unnecessary transaction commit fallback from btrfs_log_all_parents()
Date: Thu, 17 Sep 2026 16:10:43 +0100
Message-ID: <20260917151359.883332314@linuxfoundation.org>
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

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit 36f9aafa46f5b9fecf92d9218c5574f1ef6b4907 ]

When btrfs_log_all_parents() returns without doing any work (because all
parent directories were already logged), it returns 1, which is propagated
up the fsync call chain up to btrfs_log_dentry_safe(), and that causes
btrfs_sync_file() to trigger am unnecessary transaction commit.

This all happens because the call to btrfs_search_slot() in
btrfs_log_all_parents() always returns 1, as there can not be any inode
ref keys with an offset 0 (an invalid inode number), so if the while loop
below it does not do any work because all parent directories were already
logged, the 'ret' variable remains with a value of 1, which is then
returned up the call chain to btrfs_sync_file().

Fix this by setting 'ret' to 0 after the call to btrfs_search_slot().

Fixes: 0f24ea456ae1 ("btrfs: tracepoints: add trace event for btrfs_log_all_parents()")
Reviewed-by: Boris Burkov <boris@bur.io>
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/tree-log.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 875e4ddc68eae..c87f6a7e8d612 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -7307,6 +7307,22 @@ static int btrfs_log_all_parents(struct btrfs_trans_handle *trans,
 	ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
 	if (ret < 0)
 		goto out;
+	/*
+	 * There can't be an inode ref key with offset 0 because inode numbers
+	 * start at BTRFS_FIRST_FREE_OBJECTID.
+	 */
+	if (WARN_ON_ONCE(ret == 0)) {
+		btrfs_err(trans->fs_info,
+		  "found inode ref key with offset 0 for root %llu inode %llu",
+			  btrfs_root_id(root), ino);
+		ret = BTRFS_LOG_FORCE_COMMIT;
+		goto out;
+	}
+	/*
+	 * Set to 0 so that in case we don't do any work below, we won't return
+	 * 1 and trigger an unnecessary transaction commit.
+	 */
+	ret = 0;
 
 	while (true) {
 		struct extent_buffer *leaf = path->nodes[0];
-- 
2.53.0



