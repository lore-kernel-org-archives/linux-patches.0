Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AFF0524C2;
	Thu, 30 Nov 2023 16:25:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J+UwSCt/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8943C433C7;
	Thu, 30 Nov 2023 16:25:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701361526;
	bh=rTRUCl3hdNQA08gTwPJyXvSw0wgLYaQfYr+v/59c/A0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J+UwSCt/FE1Kjg2mFW9uz6+npK+wXnczPeYWKBTEmmbVLodA0ODJwcX/uLx0B6Mu5
	 rMum0XUxzhoUee8KgplWZfhDTSLFIl33BGwOy+MbQt15WPdGSfEenKwUDgebjMt+ZH
	 Mhk6Pl0Bn1t1NcClFkNWBYKOVEA2tpFrR9aB+wU4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Ilya Dryomov <idryomov@gmail.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 023/112] filemap: add a per-mapping stable writes flag
Date: Thu, 30 Nov 2023 16:21:10 +0000
Message-ID: <20231130162141.059873017@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231130162140.298098091@linuxfoundation.org>
References: <20231130162140.298098091@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 762321dab9a72760bf9aec48362f932717c9424d ]

folio_wait_stable waits for writeback to finish before modifying the
contents of a folio again, e.g. to support check summing of the data
in the block integrity code.

Currently this behavior is controlled by the SB_I_STABLE_WRITES flag
on the super_block, which means it is uniform for the entire file system.
This is wrong for the block device pseudofs which is shared by all
block devices, or file systems that can use multiple devices like XFS
witht the RT subvolume or btrfs (although btrfs currently reimplements
folio_wait_stable anyway).

Add a per-address_space AS_STABLE_WRITES flag to control the behavior
in a more fine grained way.  The existing SB_I_STABLE_WRITES is kept
to initialize AS_STABLE_WRITES to the existing default which covers
most cases.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20231025141020.192413-2-hch@lst.de
Tested-by: Ilya Dryomov <idryomov@gmail.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Stable-dep-of: 1898efcdbed3 ("block: update the stable_writes flag in bdev_add")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/inode.c              |  2 ++
 include/linux/pagemap.h | 17 +++++++++++++++++
 mm/page-writeback.c     |  2 +-
 3 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/fs/inode.c b/fs/inode.c
index 84bc3c76e5ccb..ae1a6410b53d7 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -215,6 +215,8 @@ int inode_init_always(struct super_block *sb, struct inode *inode)
 	lockdep_set_class_and_name(&mapping->invalidate_lock,
 				   &sb->s_type->invalidate_lock_key,
 				   "mapping.invalidate_lock");
+	if (sb->s_iflags & SB_I_STABLE_WRITES)
+		mapping_set_stable_writes(mapping);
 	inode->i_private = NULL;
 	inode->i_mapping = mapping;
 	INIT_HLIST_HEAD(&inode->i_dentry);	/* buggered by rcu freeing */
diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 351c3b7f93a14..8c9608b217b00 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -204,6 +204,8 @@ enum mapping_flags {
 	AS_NO_WRITEBACK_TAGS = 5,
 	AS_LARGE_FOLIO_SUPPORT = 6,
 	AS_RELEASE_ALWAYS,	/* Call ->release_folio(), even if no private data */
+	AS_STABLE_WRITES,	/* must wait for writeback before modifying
+				   folio contents */
 };
 
 /**
@@ -289,6 +291,21 @@ static inline void mapping_clear_release_always(struct address_space *mapping)
 	clear_bit(AS_RELEASE_ALWAYS, &mapping->flags);
 }
 
+static inline bool mapping_stable_writes(const struct address_space *mapping)
+{
+	return test_bit(AS_STABLE_WRITES, &mapping->flags);
+}
+
+static inline void mapping_set_stable_writes(struct address_space *mapping)
+{
+	set_bit(AS_STABLE_WRITES, &mapping->flags);
+}
+
+static inline void mapping_clear_stable_writes(struct address_space *mapping)
+{
+	clear_bit(AS_STABLE_WRITES, &mapping->flags);
+}
+
 static inline gfp_t mapping_gfp_mask(struct address_space * mapping)
 {
 	return mapping->gfp_mask;
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index b8d3d7040a506..4656534b8f5cc 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -3110,7 +3110,7 @@ EXPORT_SYMBOL_GPL(folio_wait_writeback_killable);
  */
 void folio_wait_stable(struct folio *folio)
 {
-	if (folio_inode(folio)->i_sb->s_iflags & SB_I_STABLE_WRITES)
+	if (mapping_stable_writes(folio_mapping(folio)))
 		folio_wait_writeback(folio);
 }
 EXPORT_SYMBOL_GPL(folio_wait_stable);
-- 
2.42.0



