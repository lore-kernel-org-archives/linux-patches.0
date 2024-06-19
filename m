Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89BB2147C60;
	Wed, 19 Jun 2024 13:28:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803716; cv=none; b=COMj+9MRBVExc4w+/4SMSaTeTA0IZYc/R5Be2IyCTgbdfiJ5RCbfZTh7/cdguZk9O9kRNpvLehJhRVFJpWLBTEaygJk5RwKbBKYod6ofKa9sja/ywGLCvtOQvO/2AKIeBpR5RLrdRe2q4uSYaTzMkSMFXqfbSFW7ljAXnMnJ+bo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803716; c=relaxed/simple;
	bh=SarL7kLBG2E8JVkMXpNuoQsOPT9vyUbZ3pzXN57Upr0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WBEpHR/XnPup+zGJghRnHybN1rLa8jLtdyquZBD7oXI/KNsLyF144SD4Lhs+HoEfAnN1vU5M8NlzVCnpGEU/PnZ36xeZQxj+pLmt8ymui4zVPtYdzwf610hXoDVMF4yDUkc8qzTUx3Wv1zG+cvqXnnVtxTcBrLsAKcs4nkghcI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CyZKQjpU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CyZKQjpU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC39FC2BBFC;
	Wed, 19 Jun 2024 13:28:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803716;
	bh=SarL7kLBG2E8JVkMXpNuoQsOPT9vyUbZ3pzXN57Upr0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CyZKQjpUvFcNnR7pwNeonolAQAOyGQxEo5wu3etJBJ+VzCwiZoKdT3bcMx6VRRjby
	 8IvW4VF8a685dvZsXWn1XN9pk4ryl4tHCOHqYx6MkjSZqbQXOnV4FBbRGnNXkUj2xi
	 +18rXBF2nXydC6wyu/nqCEDmQwLJSLdkROhfxXb0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 080/217] btrfs: make btrfs_destroy_delayed_refs() return void
Date: Wed, 19 Jun 2024 14:55:23 +0200
Message-ID: <20240619125559.773252706@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125556.491243678@linuxfoundation.org>
References: <20240619125556.491243678@linuxfoundation.org>
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

[ Upstream commit 99f09ce309b8307ce8dca209f936e99a7c332214 ]

btrfs_destroy_delayed_refs() always returns 0 and its single caller does
not check its return value, as it also returns void, and so does the
callers' caller and so on. This is because we are in the transaction abort
path, where we have no way to deal with errors (we are in a critical
situation) and all cleanup of resources works in a best effort fashion.
So make btrfs_destroy_delayed_refs() return void.

Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: fb33eb2ef0d8 ("btrfs: fix leak of qgroup extent records after transaction abort")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/disk-io.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 0111eda33aa9c..5eac900f5d168 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -4939,13 +4939,12 @@ static void btrfs_destroy_all_ordered_extents(struct btrfs_fs_info *fs_info)
 	btrfs_wait_ordered_roots(fs_info, U64_MAX, 0, (u64)-1);
 }
 
-static int btrfs_destroy_delayed_refs(struct btrfs_transaction *trans,
-				      struct btrfs_fs_info *fs_info)
+static void btrfs_destroy_delayed_refs(struct btrfs_transaction *trans,
+				       struct btrfs_fs_info *fs_info)
 {
 	struct rb_node *node;
 	struct btrfs_delayed_ref_root *delayed_refs;
 	struct btrfs_delayed_ref_node *ref;
-	int ret = 0;
 
 	delayed_refs = &trans->delayed_refs;
 
@@ -4953,7 +4952,7 @@ static int btrfs_destroy_delayed_refs(struct btrfs_transaction *trans,
 	if (atomic_read(&delayed_refs->num_entries) == 0) {
 		spin_unlock(&delayed_refs->lock);
 		btrfs_debug(fs_info, "delayed_refs has NO entry");
-		return ret;
+		return;
 	}
 
 	while ((node = rb_first_cached(&delayed_refs->href_root)) != NULL) {
@@ -5015,8 +5014,6 @@ static int btrfs_destroy_delayed_refs(struct btrfs_transaction *trans,
 	btrfs_qgroup_destroy_extent_records(trans);
 
 	spin_unlock(&delayed_refs->lock);
-
-	return ret;
 }
 
 static void btrfs_destroy_delalloc_inodes(struct btrfs_root *root)
-- 
2.43.0



