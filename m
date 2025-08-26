Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B19F23D7FA;
	Tue, 26 Aug 2025 11:42:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208532; cv=none; b=nX1W6FESAAxJywsgg660K0xQvEPsWoH9nwiepmVJKtX73rl3PlJTT6yi1QKtEWCpVwfOfTzaRoM63GRj9z6PT3anoZOa6weSri8c3lFO8k+z7Sy9Imy5gMb9GMan4NecWM+Xjb/nnH7Gx5Qck26Jrzy7KVQwu7BPQz/yywPPhSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208532; c=relaxed/simple;
	bh=5nWbwdwCbei9jLdaI9p70cDwK7434CWXFUMt59ZAKmU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KLiqPGBLUyCAOal/XjnjXXLpLfRA1PRk+fOGxMhiyJpJs1gB5YsYT9nHBNaSwgK8nIsXkvNNSWIndgMTbh5v7MJHFH12S4COb34wcQS45IOo/ATt3eeXMzh5YmJ5r/MYdy1v7ru4GMT6GRBb806I6xfJmKRZA6qPHtJ3j3rxXkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gZxBAzMb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gZxBAzMb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCEC6C116B1;
	Tue, 26 Aug 2025 11:42:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208532;
	bh=5nWbwdwCbei9jLdaI9p70cDwK7434CWXFUMt59ZAKmU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gZxBAzMbFmt8634YbmPE+zPu+s03q7xjF9BaPxG7S/I7H8AEN3K9qocahN6kXkYxB
	 8WZm3O8CI7AjFHql/yd1T3WpdQUEI38CKvFtzL/mIyfkuY4WqDoje9lIlL+R3tN/2w
	 ILnElZuXxg6zYI5j0gnhTO3ryFuXGsiIZs3qr3is=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	Boris Burkov <boris@bur.io>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 148/322] btrfs: codify pattern for adding block_group to bg_list
Date: Tue, 26 Aug 2025 13:09:23 +0200
Message-ID: <20250826110919.463655506@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
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

From: Boris Burkov <boris@bur.io>

[ Upstream commit 0497dfba98c00edbc7af12d53c0b1138eb318bf7 ]

Similar to mark_bg_unused() and mark_bg_to_reclaim(), we have a few
places that use bg_list with refcounting, mostly for retrying failures
to reclaim/delete unused.

These have custom logic for handling locking and refcounting the bg_list
properly, but they actually all want to do the same thing, so pull that
logic out into a helper. Unfortunately, mark_bg_unused() does still need
the NEW flag to avoid prematurely marking stuff unused (even if refcount
is fine, we don't want to mess with bg creation), so it cannot use the
new helper.

Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Boris Burkov <boris@bur.io>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: 62be7afcc13b ("btrfs: zoned: requeue to unused block group list if zone finish failed")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/block-group.c |   55 +++++++++++++++++++++++++++----------------------
 1 file changed, 31 insertions(+), 24 deletions(-)

--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -1482,6 +1482,32 @@ out:
 }
 
 /*
+ * Link the block_group to a list via bg_list.
+ *
+ * @bg:       The block_group to link to the list.
+ * @list:     The list to link it to.
+ *
+ * Use this rather than list_add_tail() directly to ensure proper respect
+ * to locking and refcounting.
+ *
+ * Returns: true if the bg was linked with a refcount bump and false otherwise.
+ */
+static bool btrfs_link_bg_list(struct btrfs_block_group *bg, struct list_head *list)
+{
+	struct btrfs_fs_info *fs_info = bg->fs_info;
+	bool added = false;
+
+	spin_lock(&fs_info->unused_bgs_lock);
+	if (list_empty(&bg->bg_list)) {
+		btrfs_get_block_group(bg);
+		list_add_tail(&bg->bg_list, list);
+		added = true;
+	}
+	spin_unlock(&fs_info->unused_bgs_lock);
+	return added;
+}
+
+/*
  * Process the unused_bgs list and remove any that don't have any allocated
  * space inside of them.
  */
@@ -1597,8 +1623,7 @@ void btrfs_delete_unused_bgs(struct btrf
 			 * drop under the "next" label for the
 			 * fs_info->unused_bgs list.
 			 */
-			btrfs_get_block_group(block_group);
-			list_add_tail(&block_group->bg_list, &retry_list);
+			btrfs_link_bg_list(block_group, &retry_list);
 
 			trace_btrfs_skip_unused_block_group(block_group);
 			spin_unlock(&block_group->lock);
@@ -1971,20 +1996,8 @@ void btrfs_reclaim_bgs_work(struct work_
 		spin_unlock(&space_info->lock);
 
 next:
-		if (ret && !READ_ONCE(space_info->periodic_reclaim)) {
-			/* Refcount held by the reclaim_bgs list after splice. */
-			spin_lock(&fs_info->unused_bgs_lock);
-			/*
-			 * This block group might be added to the unused list
-			 * during the above process. Move it back to the
-			 * reclaim list otherwise.
-			 */
-			if (list_empty(&bg->bg_list)) {
-				btrfs_get_block_group(bg);
-				list_add_tail(&bg->bg_list, &retry_list);
-			}
-			spin_unlock(&fs_info->unused_bgs_lock);
-		}
+		if (ret && !READ_ONCE(space_info->periodic_reclaim))
+			btrfs_link_bg_list(bg, &retry_list);
 		btrfs_put_block_group(bg);
 
 		mutex_unlock(&fs_info->reclaim_bgs_lock);
@@ -2024,13 +2037,8 @@ void btrfs_mark_bg_to_reclaim(struct btr
 {
 	struct btrfs_fs_info *fs_info = bg->fs_info;
 
-	spin_lock(&fs_info->unused_bgs_lock);
-	if (list_empty(&bg->bg_list)) {
-		btrfs_get_block_group(bg);
+	if (btrfs_link_bg_list(bg, &fs_info->reclaim_bgs))
 		trace_btrfs_add_reclaim_block_group(bg);
-		list_add_tail(&bg->bg_list, &fs_info->reclaim_bgs);
-	}
-	spin_unlock(&fs_info->unused_bgs_lock);
 }
 
 static int read_bg_from_eb(struct btrfs_fs_info *fs_info, const struct btrfs_key *key,
@@ -2946,8 +2954,7 @@ struct btrfs_block_group *btrfs_make_blo
 	}
 #endif
 
-	btrfs_get_block_group(cache);
-	list_add_tail(&cache->bg_list, &trans->new_bgs);
+	btrfs_link_bg_list(cache, &trans->new_bgs);
 	btrfs_inc_delayed_refs_rsv_bg_inserts(fs_info);
 
 	set_avail_alloc_bits(fs_info, type);


