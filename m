Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 503C5F9D4;
	Tue, 14 May 2024 11:56:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687804; cv=none; b=hxBw74C8Tew3SVao8aEaTZ3qK5l6kXmZIrd7eXRGbO1XfiHGmNvEL9+11zP0su9D/zurUav4DdessMJiP0TjfzyYVQxcxEY6OmXA1M4Ydm+HqACH5bqguDvFR/gi5TIN0jtmr7Xf7/OkGQzBKW+8d1da0Kutidh23EGQmkdvtnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687804; c=relaxed/simple;
	bh=7tpt/HnC0jIWArsHqO+Ap3aPxbPEEcGYQ4pG+qYlZkU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M4PavMdNXigMhw18dJfv8SAJUn2xgHth4pKWDSTJbwqG92mwbZIudEywjVfo/ALL2nsuxbrNjHtF0D6+4bwsDGRqCGWFEebtijqrKDSzG7WoRSrw5DvIyeQCgRzzLrc3XBOzzrNrA2Sx7bQgE6wtBaJHvRICEIYSOM8xIFms7hs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EllsznSF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EllsznSF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBFD5C2BD10;
	Tue, 14 May 2024 11:56:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687804;
	bh=7tpt/HnC0jIWArsHqO+Ap3aPxbPEEcGYQ4pG+qYlZkU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EllsznSFtIvxbzW+mg7cMzV+ZFVWtZ+iZTsIgb99Zzsi7tuxgJQ34Uw4Keqwz80kJ
	 kPyZ0MoehiRL1tqiUMfhf4RltdU78wJrzs8o9Es/2NOQbxYzItb0P/BrJa25Y8AAVP
	 0IQYxajgK2NI2RhSX9Y92x8XtyIo5/k9DsYLoESg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Boris Burkov <boris@bur.io>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 079/168] btrfs: always clear PERTRANS metadata during commit
Date: Tue, 14 May 2024 12:19:37 +0200
Message-ID: <20240514101009.677208469@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101006.678521560@linuxfoundation.org>
References: <20240514101006.678521560@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 99cdd1d6a4bf8..a9b794c47159f 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1424,6 +1424,7 @@ static noinline int commit_fs_roots(struct btrfs_trans_handle *trans)
 			radix_tree_tag_clear(&fs_info->fs_roots_radix,
 					(unsigned long)root->root_key.objectid,
 					BTRFS_ROOT_TRANS_TAG);
+			btrfs_qgroup_free_meta_all_pertrans(root);
 			spin_unlock(&fs_info->fs_roots_radix_lock);
 
 			btrfs_free_log(trans, root);
@@ -1448,7 +1449,6 @@ static noinline int commit_fs_roots(struct btrfs_trans_handle *trans)
 			if (ret2)
 				return ret2;
 			spin_lock(&fs_info->fs_roots_radix_lock);
-			btrfs_qgroup_free_meta_all_pertrans(root);
 		}
 	}
 	spin_unlock(&fs_info->fs_roots_radix_lock);
-- 
2.43.0



