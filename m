Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC46019AD5C;
	Wed,  7 May 2025 18:58:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644306; cv=none; b=f3C4oodqp5taxihiAU0/tCYOtqWSlDQwrQa4LC1+quVLawkeIGOsjR1tl5udbdhj41/MoXAUFzFQ2GrdLKY9SNdAIRPMqNKYVl/CVzFRegku4S6eyLleow06YA6t3rzi7J43V4OfXWAAdxroMZ9zeOt9DjNU8aO0TtuaOuaZdR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644306; c=relaxed/simple;
	bh=3a0O+bzpYRvvEbrny02xHMEenRd6TA7TAZJ7o4XZo/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=giqC4ZQ4fQfMElSVTxY/DuOr26Cy3w5Ra/Oill/LU3EfPGWI1IKphtDx+JYatuSEJaU0ayXrNyyQisIYdiwuO/0G+6F5kj5yEAwI3xFm+8y9Fe0oxCsN0d49ExtNQCmBjCgl8Ait7FRm9oQvgDkm964KIcofIMJdQsVVIdIrsgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b1BCEekN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b1BCEekN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33A2DC4CEE2;
	Wed,  7 May 2025 18:58:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644306;
	bh=3a0O+bzpYRvvEbrny02xHMEenRd6TA7TAZJ7o4XZo/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b1BCEekNV2CGwll/qHLAIxBqSlpR8upcdglJHSTilfirQ71crJbaL0wm6K8f/kll3
	 MFK7aLiq92lZQe4udY/jxyU2x1rGoB5/drIEWy+Ml3XLuGE8wx3FYY1TnB+zf1XHsR
	 C0eirsVRoGw9CfD7F3OeITxyxZzrXTMuIdQy7chg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 177/183] btrfs: expose per-inode stable writes flag
Date: Wed,  7 May 2025 20:40:22 +0200
Message-ID: <20250507183832.028367502@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183824.682671926@linuxfoundation.org>
References: <20250507183824.682671926@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qu Wenruo <wqu@suse.com>

[ Upstream commit ecde48a1a6b3256bd49db8780bf37556b157783c ]

The address space flag AS_STABLE_WRITES determine if FGP_STABLE for will
wait for the folio to finish its writeback.

For btrfs, due to the default data checksum behavior, if we modify the
folio while it's still under writeback, it will cause data checksum
mismatch.  Thus for quite some call sites we manually call
folio_wait_writeback() to prevent such problem from happening.

Currently there is only one call site inside btrfs really utilizing
FGP_STABLE, and in that case we also manually call folio_wait_writeback()
to do the waiting.

But it's better to properly expose the stable writes flag to a per-inode
basis, to allow call sites to fully benefit from FGP_STABLE flag.
E.g. for inodes with NODATASUM allowing beginning dirtying the page
without waiting for writeback.

This involves:

- Update the mapping's stable write flag when setting/clearing NODATASUM
  inode flag using ioctl
  This only works for empty files, so it should be fine.

- Update the mapping's stable write flag when reading an inode from disk

- Remove the explicit folio_wait_writeback() for FGP_BEGINWRITE call
  site

Signed-off-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: 48c1d1bb525b ("btrfs: fix the inode leak in btrfs_iget()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/btrfs_inode.h | 8 ++++++++
 fs/btrfs/file.c        | 1 -
 fs/btrfs/inode.c       | 2 ++
 fs/btrfs/ioctl.c       | 1 +
 4 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index b2fa33911c280..029fba82b81da 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -516,6 +516,14 @@ static inline void btrfs_assert_inode_locked(struct btrfs_inode *inode)
 	lockdep_assert_held(&inode->vfs_inode.i_rwsem);
 }
 
+static inline void btrfs_update_inode_mapping_flags(struct btrfs_inode *inode)
+{
+	if (inode->flags & BTRFS_INODE_NODATASUM)
+		mapping_clear_stable_writes(inode->vfs_inode.i_mapping);
+	else
+		mapping_set_stable_writes(inode->vfs_inode.i_mapping);
+}
+
 /* Array of bytes with variable length, hexadecimal format 0x1234 */
 #define CSUM_FMT				"0x%*phN"
 #define CSUM_FMT_VALUE(size, bytes)		size, bytes
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index a92997a583bd2..cd4e40a719186 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -874,7 +874,6 @@ static noinline int prepare_one_folio(struct inode *inode, struct folio **folio_
 			ret = PTR_ERR(folio);
 		return ret;
 	}
-	folio_wait_writeback(folio);
 	/* Only support page sized folio yet. */
 	ASSERT(folio_order(folio) == 0);
 	ret = set_folio_extent_mapped(folio);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 0db50d19b9a1f..90782fd9f37b8 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3925,6 +3925,7 @@ static int btrfs_read_locked_inode(struct inode *inode, struct btrfs_path *path)
 
 	btrfs_inode_split_flags(btrfs_inode_flags(leaf, inode_item),
 				&BTRFS_I(inode)->flags, &BTRFS_I(inode)->ro_flags);
+	btrfs_update_inode_mapping_flags(BTRFS_I(inode));
 
 cache_index:
 	/*
@@ -6340,6 +6341,7 @@ int btrfs_create_new_inode(struct btrfs_trans_handle *trans,
 		if (btrfs_test_opt(fs_info, NODATACOW))
 			BTRFS_I(inode)->flags |= BTRFS_INODE_NODATACOW |
 				BTRFS_INODE_NODATASUM;
+		btrfs_update_inode_mapping_flags(BTRFS_I(inode));
 	}
 
 	ret = btrfs_insert_inode_locked(inode);
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index e666c141cae0b..10a97f0af8d4b 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -393,6 +393,7 @@ int btrfs_fileattr_set(struct mnt_idmap *idmap,
 
 update_flags:
 	binode->flags = binode_flags;
+	btrfs_update_inode_mapping_flags(binode);
 	btrfs_sync_inode_flags_to_i_flags(inode);
 	inode_inc_iversion(inode);
 	inode_set_ctime_current(inode);
-- 
2.39.5



