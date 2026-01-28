Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53597302163;
	Wed, 28 Jan 2026 15:54:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615647; cv=none; b=uQmeE+nTODfSLmjyT3FsyV3562R4MLWEogXPNtQFF/PzX61S5uZLy15PwnvhrkF5E+AkxML/lnTVzku9HI1GY17IEhZsC1L8/Qcb27UD8V6hxsJw6ffc6GKKDKEtfI1iw7z8h1eqULASRTCut+7yXjThaFWm6gSNHehS07VguCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615647; c=relaxed/simple;
	bh=0ZaQCZ/lMyc45zbeCxW29TdNfzjKGWObhbrTdSFwVQw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IpVp7MN9nwwnUKUEkXcmh+uCdwpecLIykmAH0QPrGkTaf5beq/i0+OzSe4sZeEvixf0NqHSpO7iwEZubLUoeGCMveSQQ0GW2ufFjENoqUH1SV9FEIaCupJqkgC4QoL4RIMDwvvZBCuv7gM/lIWi7CY5M0KOWXaHZn5T/piqwjN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vfkDsbkL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vfkDsbkL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C1BEC4CEF1;
	Wed, 28 Jan 2026 15:54:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615647;
	bh=0ZaQCZ/lMyc45zbeCxW29TdNfzjKGWObhbrTdSFwVQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vfkDsbkLCUjV3Dk/M3xWAj3ayKGse/+F/1qaC9s21bd5HzKDtpD+Vy0lkVqVktLBL
	 06IiXncCEH48ebzsU07frNpoQgTzG38Llo6yrmSHC0A0tODwsYRi804+/Lk8wf0jAc
	 yozfoGLk1ULZSER0pncu8l9itXAoeJp4XYOyoNdA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joanne Koong <joannelkoong@gmail.com>,
	Athul Krishna <athul.krishna.kr@protonmail.com>,
	"=?UTF-8?q?J . =20Neusch=C3=A4fer?=" <j.neuschaefer@gmx.net>,
	Bernd Schubert <bschubert@ddn.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Bonaccorso Salvatore <carnil@debian.org>,
	Christian Brauner <brauner@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Jan Kara <jack@suse.cz>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 072/227] fs/writeback: skip AS_NO_DATA_INTEGRITY mappings in wait_sb_inodes()
Date: Wed, 28 Jan 2026 16:21:57 +0100
Message-ID: <20260128145346.933707599@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.331957407@linuxfoundation.org>
References: <20260128145344.331957407@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joanne Koong <joannelkoong@gmail.com>

commit f9a49aa302a05e91ca01f69031cb79a0ea33031f upstream.

Above the while() loop in wait_sb_inodes(), we document that we must wait
for all pages under writeback for data integrity.  Consequently, if a
mapping, like fuse, traditionally does not have data integrity semantics,
there is no need to wait at all; we can simply skip these inodes.

This restores fuse back to prior behavior where syncs are no-ops.  This
fixes a user regression where if a system is running a faulty fuse server
that does not reply to issued write requests, this causes wait_sb_inodes()
to wait forever.

Link: https://lkml.kernel.org/r/20260105211737.4105620-2-joannelkoong@gmail.com
Fixes: 0c58a97f919c ("fuse: remove tmp folio for writebacks and internal rb tree")
Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
Reported-by: Athul Krishna <athul.krishna.kr@protonmail.com>
Reported-by: J. Neuschäfer <j.neuschaefer@gmx.net>
Reviewed-by: Bernd Schubert <bschubert@ddn.com>
Tested-by: J. Neuschäfer <j.neuschaefer@gmx.net>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Bernd Schubert <bschubert@ddn.com>
Cc: Bonaccorso Salvatore <carnil@debian.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fs-writeback.c       |    7 ++++++-
 fs/fuse/file.c          |    4 +++-
 include/linux/pagemap.h |   11 +++++++++++
 3 files changed, 20 insertions(+), 2 deletions(-)

--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -2729,8 +2729,13 @@ static void wait_sb_inodes(struct super_
 		 * The mapping can appear untagged while still on-list since we
 		 * do not have the mapping lock. Skip it here, wb completion
 		 * will remove it.
+		 *
+		 * If the mapping does not have data integrity semantics,
+		 * there's no need to wait for the writeout to complete, as the
+		 * mapping cannot guarantee that data is persistently stored.
 		 */
-		if (!mapping_tagged(mapping, PAGECACHE_TAG_WRITEBACK))
+		if (!mapping_tagged(mapping, PAGECACHE_TAG_WRITEBACK) ||
+		    mapping_no_data_integrity(mapping))
 			continue;
 
 		spin_unlock_irq(&sb->s_inode_wblist_lock);
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -3146,8 +3146,10 @@ void fuse_init_file_inode(struct inode *
 
 	inode->i_fop = &fuse_file_operations;
 	inode->i_data.a_ops = &fuse_file_aops;
-	if (fc->writeback_cache)
+	if (fc->writeback_cache) {
 		mapping_set_writeback_may_deadlock_on_reclaim(&inode->i_data);
+		mapping_set_no_data_integrity(&inode->i_data);
+	}
 
 	INIT_LIST_HEAD(&fi->write_files);
 	INIT_LIST_HEAD(&fi->queued_writes);
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -213,6 +213,7 @@ enum mapping_flags {
 	AS_WRITEBACK_MAY_DEADLOCK_ON_RECLAIM = 9,
 	AS_KERNEL_FILE = 10,	/* mapping for a fake kernel file that shouldn't
 				   account usage to user cgroups */
+	AS_NO_DATA_INTEGRITY = 11, /* no data integrity guarantees */
 	/* Bits 16-25 are used for FOLIO_ORDER */
 	AS_FOLIO_ORDER_BITS = 5,
 	AS_FOLIO_ORDER_MIN = 16,
@@ -348,6 +349,16 @@ static inline bool mapping_writeback_may
 	return test_bit(AS_WRITEBACK_MAY_DEADLOCK_ON_RECLAIM, &mapping->flags);
 }
 
+static inline void mapping_set_no_data_integrity(struct address_space *mapping)
+{
+	set_bit(AS_NO_DATA_INTEGRITY, &mapping->flags);
+}
+
+static inline bool mapping_no_data_integrity(const struct address_space *mapping)
+{
+	return test_bit(AS_NO_DATA_INTEGRITY, &mapping->flags);
+}
+
 static inline gfp_t mapping_gfp_mask(const struct address_space *mapping)
 {
 	return mapping->gfp_mask;


