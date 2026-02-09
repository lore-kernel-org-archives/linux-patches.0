Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BEEE37A496;
	Mon,  9 Feb 2026 14:28:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770647319; cv=none; b=Lq24TyiRcEKyxhQREAUSwvWe1qTHSi6Fkkv5PDlYlAagRnw0twrQU1UN+jNQRAKJrWEAKyo6NiKZDRBzu8gweK4q1LJ3Ud/ufvgdfMnZtaEqK1gPUXpbY/H5pgCbcQ1VZACB1fgRu2VTRbV3w4I7I4qV33yjhQuk42sAVn7loXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770647319; c=relaxed/simple;
	bh=8OokoZKhEEDt69wrdUswp54WQnDdHW4YxBRRdRG26w4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HF5IgQ5irORqCP3MTRyDm7hVXqI/IBWRGqj1267jthWX7b06OHWoZv0/OUlpoZ9makg8R95H+sGhL3VBma+xoZH+O7UUJuTG45oC2xG9Dyj55fuRTSjBoPWX1A6Gs+dP7B+RQDd5R6CGk65WcrumAQWzORyqzSap+ACMxrkkBpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e1IaUKir; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e1IaUKir"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7476C116C6;
	Mon,  9 Feb 2026 14:28:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770647319;
	bh=8OokoZKhEEDt69wrdUswp54WQnDdHW4YxBRRdRG26w4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e1IaUKirxTK7lrXmqt2AQwQ6Z9Sx2OV+7sdK5qymqQzo008h13gD7Y21HQSSz0sta
	 KJ0zN7zeG6T4bfgdwjs3PXPO84ZFj/tIaNpPvJZxpF8ineqVzPQOH936Adao2sBWcx
	 f1i4pRTDiVQBXGerBolOowfOjOUUm5lla+DoMXaU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 065/175] btrfs: fix reservation leak in some error paths when inserting inline extent
Date: Mon,  9 Feb 2026 15:22:18 +0100
Message-ID: <20260209142322.796102600@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142320.474120190@linuxfoundation.org>
References: <20260209142320.474120190@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index e72c69f77ce4b..76a66c74249a2 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -614,19 +614,22 @@ static noinline int __cow_file_range_inline(struct btrfs_inode *inode,
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
 
@@ -677,7 +680,8 @@ static noinline int __cow_file_range_inline(struct btrfs_inode *inode,
 	if (ret <= 0)
 		btrfs_qgroup_free_data(inode, NULL, 0, fs_info->sectorsize, NULL);
 	btrfs_free_path(path);
-	btrfs_end_transaction(trans);
+	if (trans)
+		btrfs_end_transaction(trans);
 	return ret;
 }
 
-- 
2.51.0



