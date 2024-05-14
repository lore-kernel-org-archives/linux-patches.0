Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D83413D280;
	Tue, 14 May 2024 11:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686821; cv=none; b=g4aQvPRAa6u9rpmL8l4UVNugkIol4EoWGk/fJSW0gQyvOd5DRJyESFdkTQ98Lr/b7sTbL45CtdszWGrqdUDBnVhBIKq1PSoU0DOa5WZ683aoHwY8hVPnM26QK4hghjJ9dXJOoGLlQInxjfFPi5PgjMPnybw/T9eS7DERF/s5ppQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686821; c=relaxed/simple;
	bh=2TsGYFaSFUd8Z77u+f2AOGtXttV8K1MFsxvTdlF6yI8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sD/7lzZ7ni53ODLbHhcGtuq9uQaEw5T/Ju8Wj+J4eBhEUzwzh2AiCiZ2LoxxzTAy0W2GaKEdOyWIEjKViwYxTW7Htn9qe4DbfpWtxyWi7aZ90ajRP8D6GUQekwXhXacnwDsx9ZElGEUT18SFC5UGuqr9Fp+zkeqycOlmA5/JQFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C1U328J8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C1U328J8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1BF7C2BD10;
	Tue, 14 May 2024 11:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686821;
	bh=2TsGYFaSFUd8Z77u+f2AOGtXttV8K1MFsxvTdlF6yI8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C1U328J8VYHEPXfDCbEQU9MI1t5i1ijoVFILMHgXBRfXwTQ87MJZsVr0my7X82ZlZ
	 K3Vpfe4kXnqjDVcq35AQkHpOi0/9UAjV9fghJs0KxXPmwlgoXhWa+nnFOYvX4z2cPK
	 gnisu0oTJUy3TO3Xv50PitfIuiJ6QnwSPTVWkFP8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Boris Burkov <boris@bur.io>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 34/63] btrfs: always clear PERTRANS metadata during commit
Date: Tue, 14 May 2024 12:19:55 +0200
Message-ID: <20240514100949.303957715@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514100948.010148088@linuxfoundation.org>
References: <20240514100948.010148088@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Boris Burkov <boris@bur.io>

[ Upstream commit 6e68de0bb0ed59e0554a0c15ede7308c47351e2d ]

It is possible to clear a root's IN_TRANS tag from the radix tree, but
not clear its PERTRANS, if there is some error in between. Eliminate
that possibility by moving the free up to where we clear the tag.

Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Boris Burkov <boris@bur.io>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/transaction.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index a34c0436ebb1d..df9b209bf1b2d 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1271,6 +1271,7 @@ static noinline int commit_fs_roots(struct btrfs_trans_handle *trans)
 			radix_tree_tag_clear(&fs_info->fs_roots_radix,
 					(unsigned long)root->root_key.objectid,
 					BTRFS_ROOT_TRANS_TAG);
+			btrfs_qgroup_free_meta_all_pertrans(root);
 			spin_unlock(&fs_info->fs_roots_radix_lock);
 
 			btrfs_free_log(trans, root);
@@ -1295,7 +1296,6 @@ static noinline int commit_fs_roots(struct btrfs_trans_handle *trans)
 			if (ret2)
 				return ret2;
 			spin_lock(&fs_info->fs_roots_radix_lock);
-			btrfs_qgroup_free_meta_all_pertrans(root);
 		}
 	}
 	spin_unlock(&fs_info->fs_roots_radix_lock);
-- 
2.43.0



