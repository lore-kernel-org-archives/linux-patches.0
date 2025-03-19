Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC5031E102E;
	Wed, 19 Mar 2025 14:37:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395038; cv=none; b=u7ruxDmzi6pD7PM731eR9lIujMdpaAic5h19VQ9IMfNxy00L2JzCFjLi+fJZ9L/Jp8zzu5SLLMkG6EVY/X0ae1PCsonahYBLLR8s3BCTUHx9iv3uvY0LHB7w06WFdaxUzY+u75hOv+QgYHpPm4Lp2uj1OFVcswYoq4RfdpQCVNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395038; c=relaxed/simple;
	bh=BpMC896kIzzh/IyoAboINL0we4erfmBhW4SoXizPOJI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Oq5c+W0SNCJdNpo0HkJkHiKhC+PlI2Lv2gKgsw7R7adVD9OUsLeh31wFoL6vXtIPxHoixARXvSAZt/I1mxRlMBmkxUVm/ckXRi+fNJa/8BBY7P43GLUmOky+yUrXs5yHo2vO0+9z2NxMFvb4zJabdNHI18ZpvDNww3PwDsQfarg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jZV7toqe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jZV7toqe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1E41C4CEE4;
	Wed, 19 Mar 2025 14:37:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395037;
	bh=BpMC896kIzzh/IyoAboINL0we4erfmBhW4SoXizPOJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jZV7toqeV+5liSofy4HePCrxNrXkise2TrBYtMYS2f5MS8L7UjqLxcD8YOsDkNFSI
	 jy2pZROMO1oM86mYPnWae9mr/zOM8NfFJ4rT2B9Ua7Y3kVrOrYQr849ejpiBV+g/VW
	 C8PaChBXLtO5vYG+6IVSOTXUSMu1LdsDY9Rdh85s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 060/231] btrfs: avoid starting new transaction when cleaning qgroup during subvolume drop
Date: Wed, 19 Mar 2025 07:29:13 -0700
Message-ID: <20250319143028.308486885@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143026.865956961@linuxfoundation.org>
References: <20250319143026.865956961@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit fdef89ce6fada462aef9cb90a140c93c8c209f0f ]

At btrfs_qgroup_cleanup_dropped_subvolume() all we want to commit the
current transaction in order to have all the qgroup rfer/excl numbers up
to date. However we are using btrfs_start_transaction(), which joins the
current transaction if there is one that is not yet committing, but also
starts a new one if there is none or if the current one is already
committing (its state is >= TRANS_STATE_COMMIT_START). This later case
results in unnecessary IO, wasting time and a pointless rotation of the
backup roots in the super block.

So instead of using btrfs_start_transaction() followed by a
btrfs_commit_transaction(), use btrfs_commit_current_transaction() which
achieves our purpose and avoids starting and committing new transactions.

Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/qgroup.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index fa9025c05d4e2..e9f58cdeeb5f3 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1899,11 +1899,7 @@ int btrfs_qgroup_cleanup_dropped_subvolume(struct btrfs_fs_info *fs_info, u64 su
 	 * Commit current transaction to make sure all the rfer/excl numbers
 	 * get updated.
 	 */
-	trans = btrfs_start_transaction(fs_info->quota_root, 0);
-	if (IS_ERR(trans))
-		return PTR_ERR(trans);
-
-	ret = btrfs_commit_transaction(trans);
+	ret = btrfs_commit_current_transaction(fs_info->quota_root);
 	if (ret < 0)
 		return ret;
 
-- 
2.39.5



