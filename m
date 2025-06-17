Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 537011ADC97;
	Tue, 17 Jun 2025 16:41:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178519; cv=none; b=i0CaW5O+s+AYdKFWS2Paj7aWMfCYsMfHhV4UpEx3sWpPX8vgyCru8GXI8Qt7yQQF6No3500TY0iQ2V9RUYjCUXFlYbdlmpNNMuVslIQyriio4txQz/2pkaAo2DbROPKDDIvHqF/dadgSnKkQuhRBKYguqV5FtSycfkpynuWGFcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178519; c=relaxed/simple;
	bh=1lRkpVNU1N2v2B8prnOuJ0mdcVHHPwmRbJ8ge825XPM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ges866eE0vYwexOAAGKvRngpT4Rp54kyaF1v3BYR8ewAMMxARnhg+djXDT0SzlzRMOMFlxr3W8wEBVz/t1eFsLK7nDQPRJMzzOY1UPKj66LGbqNz0vL4YaV4kiMQ6dgrdqJNx/gfhusDMcoDoi8gTu5wMknsTD+ysfR4DP048Lw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k+vNbPFU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k+vNbPFU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7A1CC4CEE3;
	Tue, 17 Jun 2025 16:41:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178519;
	bh=1lRkpVNU1N2v2B8prnOuJ0mdcVHHPwmRbJ8ge825XPM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k+vNbPFU5+GM7qv83Y4lYk0ktNnFD2+Rbqzt8F2kDghZu/FdTiZVW1N+PEmW05zVR
	 OY02mvjbpk3yrq5W9NbfR3wKEmm7splmigDr8LL+L9mGObYPzfKFGwJk4rUNpn+pT1
	 ha8VxfsMyH3Iq8qBOW9tt6Ku+5HZ8r7L939im6o4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Mitterle <smitterl@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 471/780] s390/uv: Improve splitting of large folios that cannot be split while dirty
Date: Tue, 17 Jun 2025 17:22:59 +0200
Message-ID: <20250617152510.669375897@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Hildenbrand <david@redhat.com>

[ Upstream commit ab73b29efd36f8916c6cc9954e912c4723c9a1b0 ]

Currently, starting a PV VM on an iomap-based filesystem with large
folio support, such as XFS, will not work. We'll be stuck in
unpack_one()->gmap_make_secure(), because we can't seem to make progress
splitting the large folio.

The problem is that we require a writable PTE but a writable PTE under such
filesystems will imply a dirty folio.

So whenever we have a writable PTE, we'll have a dirty folio, and dirty
iomap folios cannot currently get split, because
split_folio()->split_huge_page_to_list_to_order()->filemap_release_folio()
will fail in iomap_release_folio().

So we will not make any progress splitting such large folios.

Until dirty folios can be split more reliably, let's manually trigger
writeback of the problematic folio using
filemap_write_and_wait_range(), and retry the split immediately
afterwards exactly once, before looking up the folio again.

Should this logic be part of split_folio()? Likely not; most split users
don't have to split so eagerly to make any progress.

For now, this seems to affect xfs, zonefs and erofs, and this patch
makes it work again (tested on xfs only).

While this could be considered a fix for commit 6795801366da ("xfs: Support
large folios"), commit df2f9708ff1f ("zonefs: enable support for large
folios") and commit ce529cc25b18 ("erofs: enable large folios for iomap
mode"), before commit eef88fe45ac9 ("s390/uv: Split large folios in
gmap_make_secure()"), we did not try splitting large folios at all. So it's
all rather part of making SE compatible with file systems that support
large folios. But to have some "Fixes:" tag, let's just use eef88fe45ac9.

Not CCing stable, because there are a lot of dependencies, and it simply
not working is not critical in stable kernels.

Reported-by: Sebastian Mitterle <smitterl@redhat.com>
Closes: https://issues.redhat.com/browse/RHEL-58218
Fixes: eef88fe45ac9 ("s390/uv: Split large folios in gmap_make_secure()")
Signed-off-by: David Hildenbrand <david@redhat.com>
Link: https://lore.kernel.org/r/20250516123946.1648026-4-david@redhat.com
Message-ID: <20250516123946.1648026-4-david@redhat.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/uv.c | 66 +++++++++++++++++++++++++++++++++++++++----
 1 file changed, 60 insertions(+), 6 deletions(-)

diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
index f6ddb2b54032e..d278bf0c09d1b 100644
--- a/arch/s390/kernel/uv.c
+++ b/arch/s390/kernel/uv.c
@@ -15,6 +15,7 @@
 #include <linux/pagemap.h>
 #include <linux/swap.h>
 #include <linux/pagewalk.h>
+#include <linux/backing-dev.h>
 #include <asm/facility.h>
 #include <asm/sections.h>
 #include <asm/uv.h>
@@ -338,22 +339,75 @@ static int make_folio_secure(struct mm_struct *mm, struct folio *folio, struct u
  */
 static int s390_wiggle_split_folio(struct mm_struct *mm, struct folio *folio)
 {
-	int rc;
+	int rc, tried_splits;
 
 	lockdep_assert_not_held(&mm->mmap_lock);
 	folio_wait_writeback(folio);
 	lru_add_drain_all();
 
-	if (folio_test_large(folio)) {
+	if (!folio_test_large(folio))
+		return 0;
+
+	for (tried_splits = 0; tried_splits < 2; tried_splits++) {
+		struct address_space *mapping;
+		loff_t lstart, lend;
+		struct inode *inode;
+
 		folio_lock(folio);
 		rc = split_folio(folio);
+		if (rc != -EBUSY) {
+			folio_unlock(folio);
+			return rc;
+		}
+
+		/*
+		 * Splitting with -EBUSY can fail for various reasons, but we
+		 * have to handle one case explicitly for now: some mappings
+		 * don't allow for splitting dirty folios; writeback will
+		 * mark them clean again, including marking all page table
+		 * entries mapping the folio read-only, to catch future write
+		 * attempts.
+		 *
+		 * While the system should be writing back dirty folios in the
+		 * background, we obtained this folio by looking up a writable
+		 * page table entry. On these problematic mappings, writable
+		 * page table entries imply dirty folios, preventing the
+		 * split in the first place.
+		 *
+		 * To prevent a livelock when trigger writeback manually and
+		 * letting the caller look up the folio again in the page
+		 * table (turning it dirty), immediately try to split again.
+		 *
+		 * This is only a problem for some mappings (e.g., XFS);
+		 * mappings that do not support writeback (e.g., shmem) do not
+		 * apply.
+		 */
+		if (!folio_test_dirty(folio) || folio_test_anon(folio) ||
+		    !folio->mapping || !mapping_can_writeback(folio->mapping)) {
+			folio_unlock(folio);
+			break;
+		}
+
+		/*
+		 * Ideally, we'd only trigger writeback on this exact folio. But
+		 * there is no easy way to do that, so we'll stabilize the
+		 * mapping while we still hold the folio lock, so we can drop
+		 * the folio lock to trigger writeback on the range currently
+		 * covered by the folio instead.
+		 */
+		mapping = folio->mapping;
+		lstart = folio_pos(folio);
+		lend = lstart + folio_size(folio) - 1;
+		inode = igrab(mapping->host);
 		folio_unlock(folio);
 
-		if (rc != -EBUSY)
-			return rc;
-		return -EAGAIN;
+		if (unlikely(!inode))
+			break;
+
+		filemap_write_and_wait_range(mapping, lstart, lend);
+		iput(mapping->host);
 	}
-	return 0;
+	return -EAGAIN;
 }
 
 int make_hva_secure(struct mm_struct *mm, unsigned long hva, struct uv_cb_header *uvcb)
-- 
2.39.5



