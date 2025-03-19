Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDABE1DDA36;
	Wed, 19 Mar 2025 14:34:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742394868; cv=none; b=RCyfviFfVTYBmGvF4Zh4R/wLqeKvBj1rjFouQYQ8Ca/i3Sna6MfW6lemYCBOkucShY4lgHv7BMVgcqGKSDty6bjs4wi+VPjRira7eDBUMNc5FynPJ8ecnC5DK4xwsWu1rWAWS9XASnC+S17BZ2WRk0AAWF4epBoo1D6768wHEc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742394868; c=relaxed/simple;
	bh=zXSdZMmMMBpdsE7bpkIMdDaBvbhhcmDeE4rGhXzu9po=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YxBHCASCta++7yp48B0b+uQiIfcerATudWyaf4rmKoF1MHJSdjvfTDWw2tD36v0Qf5HmJZvkTgvdORwQF044nT+In9wH5Cc6eBUnSqS7EANO+D+MeWA4ZyJ+YnW+a7adVitD6h8//Abj9xSDxgx4oqafXDk7wT1EUqXeexYCoyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p02+ruXM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p02+ruXM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4163C4CEE4;
	Wed, 19 Mar 2025 14:34:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742394867;
	bh=zXSdZMmMMBpdsE7bpkIMdDaBvbhhcmDeE4rGhXzu9po=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p02+ruXMrSjD3NIODkp068ZsJ0iwQZsojV10unT/f9WGy3f9SJSR5OO/voy08qUtu
	 An7uVwe43EpuOel3f8rVAMeLIjnpY0jAz0FjF981xAv5VvAics38pBvGIoOyrLejpB
	 JN/no2ddTxwIJbJGdCyXkHPHxVIkQIffkeeYGk20=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 060/241] btrfs: avoid starting new transaction when cleaning qgroup during subvolume drop
Date: Wed, 19 Mar 2025 07:28:50 -0700
Message-ID: <20250319143029.214402522@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143027.685727358@linuxfoundation.org>
References: <20250319143027.685727358@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index 5ab51781d0e4f..20b025f6ac3cc 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1898,11 +1898,7 @@ int btrfs_qgroup_cleanup_dropped_subvolume(struct btrfs_fs_info *fs_info, u64 su
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



