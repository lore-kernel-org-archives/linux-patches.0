Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 716DB54659;
	Mon,  8 Jan 2024 15:42:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EgNChNcy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEDFDC433CB;
	Mon,  8 Jan 2024 15:41:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704728520;
	bh=FuOtKG1rH2dBiIwCe7Tm9l87y5og7SthdpK/xe9E8yA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EgNChNcyvumABUyeXLimfEI5yZd8/NgOK7/xj75fUFDUanAP3fvIkKq/d8NMC3gpO
	 J2kpLmjrohykrV6ZncV4fblWollgKRIv+PPx4awismvzlxwVCX4ilXovnJ8SnYhUQB
	 KGakhkpUSvnMFCqlbYNcTfBenPko1fQM9sg5c61g=
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
Subject: [PATCH 6.1 103/150] filemap: add a per-mapping stable writes flag
Date: Mon,  8 Jan 2024 16:35:54 +0100
Message-ID: <20240108153515.941650670@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240108153511.214254205@linuxfoundation.org>
References: <20240108153511.214254205@linuxfoundation.org>
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
index 73ad1b0d47758..8cfda7a6d5900 100644
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
index fdbb90ae56c70..1be5a1fa6a3a8 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -200,6 +200,8 @@ enum mapping_flags {
 	AS_NO_WRITEBACK_TAGS = 5,
 	AS_LARGE_FOLIO_SUPPORT = 6,
 	AS_RELEASE_ALWAYS,	/* Call ->release_folio(), even if no private data */
+	AS_STABLE_WRITES,	/* must wait for writeback before modifying
+				   folio contents */
 };
 
 /**
@@ -285,6 +287,21 @@ static inline void mapping_clear_release_always(struct address_space *mapping)
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
index 7e9d8d857ecca..de5f69921b946 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -3078,7 +3078,7 @@ EXPORT_SYMBOL_GPL(folio_wait_writeback_killable);
  */
 void folio_wait_stable(struct folio *folio)
 {
-	if (folio_inode(folio)->i_sb->s_iflags & SB_I_STABLE_WRITES)
+	if (mapping_stable_writes(folio_mapping(folio)))
 		folio_wait_writeback(folio);
 }
 EXPORT_SYMBOL_GPL(folio_wait_stable);
-- 
2.43.0



