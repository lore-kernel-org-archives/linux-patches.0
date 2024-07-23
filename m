Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3403B155351;
	Tue, 23 Jul 2024 18:28:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759303; cv=none; b=iAyVUT9o5heFdMxPJz7g+1bmofDQNIrrFyajIKYCP3t2Fl0Opg6VfYyL+jB3XV3GIHu+ALTeIxLiT8obzJZpVC2lIprhmRhCBB9LXUAbGm0HsIMiYvM2ioA+aX4UofbqjSsq8SWdmgCyx6y6AP3qyxGw6IPBsw6PUPlYwh3LMNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759303; c=relaxed/simple;
	bh=iWt3vCesViiahLxPypjaO0nblPpb2ft1LVAXtSZoK7w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i42Vne80JyEKiwBXcvx3NDuUYw6KTCkdUkAVGLj7Xdd/b44elW7A2jvJstBriBGmANZYgU/gt7njKnXT+wYCoF37zh2klzSE5mixq4s6zZQN4FOxweA5BSN93yte43ycGz16UfGOg8RZ7E3YVQsN/Is/yOExksBC1FalJIg5jko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fj9NN614; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fj9NN614"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE4F9C4AF09;
	Tue, 23 Jul 2024 18:28:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759303;
	bh=iWt3vCesViiahLxPypjaO0nblPpb2ft1LVAXtSZoK7w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fj9NN614c/kbtn/mLF6EVlwd9S7kCfR+2kUaIlFss26aCDEvysq1zbEjyGLFi6wsX
	 2JbszRs0yJRabTqIOaoogaZX+HcJkxByloCKr1gWfJetZCjSKgzCyXoBHZi7Q8IB7Z
	 VHPRolMfAa+IUmJrdSG0nWhn7+GLbl+m8vbICVh4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Burkov <boris@bur.io>,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 071/105] btrfs: qgroup: fix quota root leak after quota disable failure
Date: Tue, 23 Jul 2024 20:23:48 +0200
Message-ID: <20240723180405.982257088@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180402.490567226@linuxfoundation.org>
References: <20240723180402.490567226@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 80ca7b435b0d1..e482889667ec9 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1222,7 +1222,7 @@ int btrfs_quota_enable(struct btrfs_fs_info *fs_info)
 
 int btrfs_quota_disable(struct btrfs_fs_info *fs_info)
 {
-	struct btrfs_root *quota_root;
+	struct btrfs_root *quota_root = NULL;
 	struct btrfs_trans_handle *trans = NULL;
 	int ret = 0;
 
@@ -1317,9 +1317,9 @@ int btrfs_quota_disable(struct btrfs_fs_info *fs_info)
 	btrfs_free_tree_block(trans, btrfs_root_id(quota_root),
 			      quota_root->node, 0, 1);
 
-	btrfs_put_root(quota_root);
 
 out:
+	btrfs_put_root(quota_root);
 	mutex_unlock(&fs_info->qgroup_ioctl_lock);
 	if (ret && trans)
 		btrfs_end_transaction(trans);
-- 
2.43.0



