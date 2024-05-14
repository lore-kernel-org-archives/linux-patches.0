Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FB8918026;
	Tue, 14 May 2024 11:15:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715685310; cv=none; b=f6lB8+351J4LBtrdA8V5ERjJeLluCduF85h3NKWABam0jSzE95iS4uSqXZbKHnFsJ6qOOVjd368J3m+ko+Hz7UHY+gUxt0L78H1WyGDjYEEkjSOK3LrbpWCxx9SUEiZeVRPzvIm60UsTvsJbkp80I+2EjeE95CPHl+2FgpeD59Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715685310; c=relaxed/simple;
	bh=iOV/5lnwZO2zr8zmhe61XnvlwAhpx7Ryow6kqvedYNs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g0suFIg21g0UgCNK+q2uqBVawDs2NaN8gHdyjekIFLetPuofjuGwXSHPuBlkVMNM1QfpPPiTVqwX58QGDn8iO8jry/KXujqvBLUnudNW2n4TbANA+ajrNIVmExb7JFecqORAjRwa0fQWYKMM95dmzG9LZn1AWeTGy0opXVV3VsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VReROB4p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VReROB4p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9449C2BD10;
	Tue, 14 May 2024 11:15:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715685310;
	bh=iOV/5lnwZO2zr8zmhe61XnvlwAhpx7Ryow6kqvedYNs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VReROB4pXs9TGRKSU94KN4e6zb4AKSRVTEXkjM+ESf3WWBmAR8UqWiUvLdYpgQ9x2
	 lItn8rVJnJwlSTO7gkLlmLW2l2bByr/tVH13u++CMq0/YqVp+n6vx+dhCATFqxXGmV
	 IaPhRHnyNNEnRWhga+6OKfB2k3EF5vbU+YA72W+8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Boris Burkov <boris@bur.io>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 135/301] btrfs: always clear PERTRANS metadata during commit
Date: Tue, 14 May 2024 12:16:46 +0200
Message-ID: <20240514101037.352187463@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 457ec7d02a9ac..0548072c642fb 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1449,6 +1449,7 @@ static noinline int commit_fs_roots(struct btrfs_trans_handle *trans)
 			radix_tree_tag_clear(&fs_info->fs_roots_radix,
 					(unsigned long)root->root_key.objectid,
 					BTRFS_ROOT_TRANS_TAG);
+			btrfs_qgroup_free_meta_all_pertrans(root);
 			spin_unlock(&fs_info->fs_roots_radix_lock);
 
 			btrfs_free_log(trans, root);
@@ -1473,7 +1474,6 @@ static noinline int commit_fs_roots(struct btrfs_trans_handle *trans)
 			if (ret2)
 				return ret2;
 			spin_lock(&fs_info->fs_roots_radix_lock);
-			btrfs_qgroup_free_meta_all_pertrans(root);
 		}
 	}
 	spin_unlock(&fs_info->fs_roots_radix_lock);
-- 
2.43.0



