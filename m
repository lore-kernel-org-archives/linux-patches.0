Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAAA81E89C;
	Thu, 25 Jul 2024 14:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721919029; cv=none; b=Cs/D6A3PXqkWNibVaJYzNX09nm35Z4zzWj/65palAQYutzUVKjcrbYzeD6y2HxorFp6nEplki+Zyc+Jx1O9zpblKnHU3ikCgN3E5fJlhlJUev75mxHJS/i9cB1a/sI1wF4V5A7r30jIGkyLcN50dMfi8pbAtY8I8LlwEFVS+9lY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721919029; c=relaxed/simple;
	bh=TVBjDDN5cFTXP/EK0Vr7oertmgNnPwu1IyEybtgECK4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XORWEGxCnQ+fCNMGsjJqKBCrcWtEHdoBDw1L5GUaNhTL59QEBB/cn5bs7lWvA9wNnoOpoGq5th2ap0cxUQbKq4kqA7aXA5x4625eAxL8BSHnHqZPeSayFW3nDcZJrNzveuyCHkm13F7nWMsEoTjtdETOHiPuYQdv/wfAUHRNbCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yDrYjCf+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yDrYjCf+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23681C116B1;
	Thu, 25 Jul 2024 14:50:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721919029;
	bh=TVBjDDN5cFTXP/EK0Vr7oertmgNnPwu1IyEybtgECK4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yDrYjCf+7oQbmHVA+0e4JHQhf557GK9TojFxuAIcQwTy5+F9zm+p6cAh3OTo6QJx9
	 0B5dgvsSGFRK8Ta+/zObt8nGdFzuO0lRncgVpEujB2fNhBzWN6YyShn0j40ssdiPnT
	 42/qc5zCfOJz6M9uPwJ9P3KleNds80aCA1Nsifno=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Burkov <boris@bur.io>,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 30/59] btrfs: qgroup: fix quota root leak after quota disable failure
Date: Thu, 25 Jul 2024 16:37:20 +0200
Message-ID: <20240725142734.399466812@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240725142733.262322603@linuxfoundation.org>
References: <20240725142733.262322603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit a7e4c6a3031c74078dba7fa36239d0f4fe476c53 ]

If during the quota disable we fail when cleaning the quota tree or when
deleting the root from the root tree, we jump to the 'out' label without
ever dropping the reference on the quota root, resulting in a leak of the
root since fs_info->quota_root is no longer pointing to the root (we have
set it to NULL just before those steps).

Fix this by always doing a btrfs_put_root() call under the 'out' label.
This is a problem that exists since qgroups were first added in 2012 by
commit bed92eae26cc ("Btrfs: qgroup implementation and prototypes"), but
back then we missed a kfree on the quota root and free_extent_buffer()
calls on its root and commit root nodes, since back then roots were not
yet reference counted.

Reviewed-by: Boris Burkov <boris@bur.io>
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/qgroup.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 50669ff9346c6..83d17f22335b1 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1197,7 +1197,7 @@ int btrfs_quota_enable(struct btrfs_fs_info *fs_info)
 
 int btrfs_quota_disable(struct btrfs_fs_info *fs_info)
 {
-	struct btrfs_root *quota_root;
+	struct btrfs_root *quota_root = NULL;
 	struct btrfs_trans_handle *trans = NULL;
 	int ret = 0;
 
@@ -1290,9 +1290,9 @@ int btrfs_quota_disable(struct btrfs_fs_info *fs_info)
 	btrfs_tree_unlock(quota_root->node);
 	btrfs_free_tree_block(trans, quota_root, quota_root->node, 0, 1);
 
-	btrfs_put_root(quota_root);
 
 out:
+	btrfs_put_root(quota_root);
 	mutex_unlock(&fs_info->qgroup_ioctl_lock);
 	if (ret && trans)
 		btrfs_end_transaction(trans);
-- 
2.43.0



