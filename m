Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B11E22F691F;
	Thu, 28 May 2026 20:08:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998931; cv=none; b=vGuPw/lv8yPKroivTh9Df+FiXfPNK7x3To+77i1gUQGBdns6WThMAyCFjiJ5iSkiq//k5ut0CRA4IjkNuUmsb+I3FMlsrVOr7ENaNl9aPKOmztAjfyJkfhwwsZmSYzg61eX59WpXudRJEWkZc+D2JTcj+JOxap5gxNs7GgyBy5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998931; c=relaxed/simple;
	bh=xiFbTF2/sJPaXG63p7HSjZ6P4sRoJIj2glnWROiz+QI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gQMxYIcb+rE8D1FoswA2hJs76jdyOmfdNuF6JZp0eTHLEbuO3knyXWz93R4wMiqlzpBLMM5ajDMd5271db3tIghS1nmFtu2fuKrc+V7DIsXAPp0uHEO3u0pZw6clUDsOuTAw8j+NUVWPrnOqwwJ3nCEGxNNBNS4PP/3eIsKROQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RtuaqJ74; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RtuaqJ74"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D0571F000E9;
	Thu, 28 May 2026 20:08:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998930;
	bh=xOweU99bMi/urKmQpva2YYP7yfHZexoUDGQK28tAu0M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RtuaqJ74CrRH+6VX0ktswCxZGnpHUSIFETMf9nSITS55ybj0DKiq+XY0y9FZDyhxJ
	 6OFP2C4z4joIPd3pqjzXh/7DDG8bV/kYn+0VLUQ1/VAY/Wrs2oKpYACwIrEEOzJvKy
	 u599C2+TJiaGLmikgrDPVDxJafafenwA2x65pSLs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Boris Burkov <boris@bur.io>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 347/461] btrfs: fix squota accounting during enable generation
Date: Thu, 28 May 2026 21:47:56 +0200
Message-ID: <20260528194657.422227804@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Boris Burkov <boris@bur.io>

[ Upstream commit d7c600554816b8ef70adffe078a0e360c055d82b ]

The first transaction that enables squotas is special and a bit tricky.
We have to set BTRFS_FS_QUOTA_ENABLED after the transaction to avoid a
deadlock, so any delayed refs that run before we set the bit are not
squota accounted. For data this is fine, we don't get an owner_ref, so
there is no real harm, it's as if the extent predated squotas. However
for metadata, the tree block will have gen == enable_gen so when we free
it later, we will decrement the squota accounting, which can result in
an underflow. Before it is freed, btrfs check shows errors, as we have
mismatched usage between the node generations/owners and the squota
values.

There are two angles to this fix:

1. For extents that come in delayed_refs that run during the
   enable_gen transaction, we must actually set enable_gen to the *next*
   transaction. That is the first transaction that we can really
   properly account in any way.
2. For extents that come in between the end of our transaction handle
   and the time we set the BTRFS_FS_QUOTA_ENABLED bit, we need an
   additional bit, BTRFS_FS_SQUOTA_ENABLING which only affects recording
   squota deltas, so we do pick up those extents. Otherwise, we would
   miss them, even for enable_gen + 1.

Fixes: bd7c1ea3a302 ("btrfs: qgroup: check generation when recording simple quota delta")
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Boris Burkov <boris@bur.io>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/fs.h     |  1 +
 fs/btrfs/qgroup.c | 31 +++++++++++++++++++++++++++----
 2 files changed, 28 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/fs.h b/fs/btrfs/fs.h
index 3de3b517810ed..d8c41f194729e 100644
--- a/fs/btrfs/fs.h
+++ b/fs/btrfs/fs.h
@@ -154,6 +154,7 @@ enum {
 	BTRFS_FS_LOG_RECOVERING,
 	BTRFS_FS_OPEN,
 	BTRFS_FS_QUOTA_ENABLED,
+	BTRFS_FS_SQUOTA_ENABLING,
 	BTRFS_FS_UPDATE_UUID_TREE_GEN,
 	BTRFS_FS_CREATING_FREE_SPACE_TREE,
 	BTRFS_FS_BTREE_ERR,
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 5204263088921..0823f5f561d75 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1107,7 +1107,13 @@ int btrfs_quota_enable(struct btrfs_fs_info *fs_info,
 	if (simple) {
 		fs_info->qgroup_flags |= BTRFS_QGROUP_STATUS_FLAG_SIMPLE_MODE;
 		btrfs_set_fs_incompat(fs_info, SIMPLE_QUOTA);
-		btrfs_set_qgroup_status_enable_gen(leaf, ptr, trans->transid);
+		/*
+		 * Set the enable generation to the next transaction, as we cannot
+		 * ensure that extents written during this transaction will see any
+		 * state we have set here. So we should treat all extents of the
+		 * transaction as coming in before squotas was enabled.
+		 */
+		btrfs_set_qgroup_status_enable_gen(leaf, ptr, trans->transid + 1);
 	} else {
 		fs_info->qgroup_flags |= BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT;
 	}
@@ -1210,7 +1216,15 @@ int btrfs_quota_enable(struct btrfs_fs_info *fs_info,
 		goto out_free_path;
 	}
 
-	fs_info->qgroup_enable_gen = trans->transid;
+	/*
+	 * Set fs_info->qgroup_enable_gen and BTRFS_FS_SQUOTA_ENABLING
+	 * under the transaction handle. We want to ensure that all extents in
+	 * the next transaction definitely see them.
+	 */
+	if (simple) {
+		fs_info->qgroup_enable_gen = trans->transid + 1;
+		set_bit(BTRFS_FS_SQUOTA_ENABLING, &fs_info->flags);
+	}
 
 	mutex_unlock(&fs_info->qgroup_ioctl_lock);
 	/*
@@ -1224,9 +1238,15 @@ int btrfs_quota_enable(struct btrfs_fs_info *fs_info,
 	 */
 	ret = btrfs_commit_transaction(trans);
 	trans = NULL;
+
 	mutex_lock(&fs_info->qgroup_ioctl_lock);
-	if (ret)
+	if (ret) {
+		if (simple) {
+			clear_bit(BTRFS_FS_SQUOTA_ENABLING, &fs_info->flags);
+			fs_info->qgroup_enable_gen = 0;
+		}
 		goto out_free_path;
+	}
 
 	/*
 	 * Set quota enabled flag after committing the transaction, to avoid
@@ -1236,6 +1256,8 @@ int btrfs_quota_enable(struct btrfs_fs_info *fs_info,
 	spin_lock(&fs_info->qgroup_lock);
 	fs_info->quota_root = quota_root;
 	set_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags);
+	if (simple)
+		clear_bit(BTRFS_FS_SQUOTA_ENABLING, &fs_info->flags);
 	spin_unlock(&fs_info->qgroup_lock);
 
 	/* Skip rescan for simple qgroups. */
@@ -4924,7 +4946,8 @@ int btrfs_record_squota_delta(struct btrfs_fs_info *fs_info,
 	u64 num_bytes = delta->num_bytes;
 	const int sign = (delta->is_inc ? 1 : -1);
 
-	if (btrfs_qgroup_mode(fs_info) != BTRFS_QGROUP_MODE_SIMPLE)
+	if (btrfs_qgroup_mode(fs_info) != BTRFS_QGROUP_MODE_SIMPLE &&
+	    !test_bit(BTRFS_FS_SQUOTA_ENABLING, &fs_info->flags))
 		return 0;
 
 	if (!btrfs_is_fstree(root))
-- 
2.53.0



