Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9563933439A;
	Thu, 28 May 2026 20:42:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000974; cv=none; b=GI9K6SYxJueCUeoselZhkkqairNKzrh5jQhZpes5fVsyIS+bHk/qW2uA+zyFDCcZkcmOW9q8ukVCPwTKht3gN8E04w2XPRLb16bvGNksHpxVUeSrMK4Y9gpOnKhYQVrfzuUi8wwOfQp/yMHXgGF3AQpBfLbSMCjf1EyqRAHGXTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000974; c=relaxed/simple;
	bh=2n8kgH1HAtfePt2kr+LIPpOITafVBU+9iCraKW2yIag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c10gfUUwOSox97q13irimwALQTgYZQr6ysxuvQiTM8WIbLPoWEulqyhFHeFHfkxo/y1UC+cGLTGL1FyE87z4boivqQg5czXewKpRkA4n0ZyoEhL5+wlDxjGvoIi732R667FQz/IyuZeZFumzjAWS0qHyrBLS19at81JSNmhxHIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gl2j0co+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gl2j0co+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0D6D1F000E9;
	Thu, 28 May 2026 20:42:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000973;
	bh=pnfE0bym41IZoqnsXbA4jreDYRjlIzUlUaq348jAKfk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gl2j0co+iNJaFsHFlbYe+IaDsF3tbvEMCA3uh5O0G480ryVgDoziAjGu80UXj+KEx
	 VHNb/lnX9mkl25pl+9SpLLDrqj1Ev/y4bKoOrxGQafWRuw947ucykMMOpf7whPrVb5
	 VXzulAxfqCI/BDA/STPftVcqZTUzuaRh1KL8L0RM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Boris Burkov <boris@bur.io>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 234/272] btrfs: fix squota accounting during enable generation
Date: Thu, 28 May 2026 21:50:08 +0200
Message-ID: <20260528194635.715473032@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194629.379955525@linuxfoundation.org>
References: <20260528194629.379955525@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 93ff1db75af48..c49ffaeee769a 100644
--- a/fs/btrfs/fs.h
+++ b/fs/btrfs/fs.h
@@ -114,6 +114,7 @@ enum {
 	BTRFS_FS_LOG_RECOVERING,
 	BTRFS_FS_OPEN,
 	BTRFS_FS_QUOTA_ENABLED,
+	BTRFS_FS_SQUOTA_ENABLING,
 	BTRFS_FS_UPDATE_UUID_TREE_GEN,
 	BTRFS_FS_CREATING_FREE_SPACE_TREE,
 	BTRFS_FS_BTREE_ERR,
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 71ccba22752cb..5b158eb25d181 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1130,7 +1130,13 @@ int btrfs_quota_enable(struct btrfs_fs_info *fs_info,
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
@@ -1240,7 +1246,15 @@ int btrfs_quota_enable(struct btrfs_fs_info *fs_info,
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
@@ -1254,9 +1268,15 @@ int btrfs_quota_enable(struct btrfs_fs_info *fs_info,
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
@@ -1266,6 +1286,8 @@ int btrfs_quota_enable(struct btrfs_fs_info *fs_info,
 	spin_lock(&fs_info->qgroup_lock);
 	fs_info->quota_root = quota_root;
 	set_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags);
+	if (simple)
+		clear_bit(BTRFS_FS_SQUOTA_ENABLING, &fs_info->flags);
 	spin_unlock(&fs_info->qgroup_lock);
 
 	/* Skip rescan for simple qgroups. */
@@ -4966,7 +4988,8 @@ int btrfs_record_squota_delta(struct btrfs_fs_info *fs_info,
 	u64 num_bytes = delta->num_bytes;
 	const int sign = (delta->is_inc ? 1 : -1);
 
-	if (btrfs_qgroup_mode(fs_info) != BTRFS_QGROUP_MODE_SIMPLE)
+	if (btrfs_qgroup_mode(fs_info) != BTRFS_QGROUP_MODE_SIMPLE &&
+	    !test_bit(BTRFS_FS_SQUOTA_ENABLING, &fs_info->flags))
 		return 0;
 
 	if (!is_fstree(root))
-- 
2.53.0



