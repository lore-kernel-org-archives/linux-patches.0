Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9869D2F7478;
	Wed, 25 Feb 2026 06:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002779; cv=none; b=HiI4zcZ4VPMVYrQrSOho2izQdnW8SBZFqZWi3wzqZkh8G6nFPy5eySgNgWYIrGR8qlgAJmziKEg4C1UeMpw5E32Af66lDYq3MJ6gGl7mk7vKnft5Tc/bIX2BFeHEM13ox5MZTdsudS++1KCz14Lj1MT+oVc2XkU9gHxWQ4ubn5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002779; c=relaxed/simple;
	bh=IoBG2oAJM9jPvcOOkBeinKcZgm/jwA3YLMtIMWAnwzo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SgFdz8OfDn97tPXsowKefUKxv6KZJJMHnOT7Czq4ytW1QvsJb42Uudm5SxD/CQLZ8euHhDRS4wTmH4yQf0ARAdyO8nFWN+j19yxnnHEhDTyadmnRIDH+nYrttEc+9rpkGpV6wGFOvEFAnfobxcZTj191/SXfHsiYlkOLpcM1xfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WltwbvPG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WltwbvPG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 720CFC116D0;
	Wed, 25 Feb 2026 06:59:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002779;
	bh=IoBG2oAJM9jPvcOOkBeinKcZgm/jwA3YLMtIMWAnwzo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WltwbvPG2nTrf2cskdL5nDzX1uSqAbpycWmLKDDWeu3SADL23FKIBhbcZ+z+7tpnH
	 sw53ePYNji6wRaH6YFgRm2kMfr/O9IHnFEgG4LVQqFlZXL1c2wjgFhrmK+0TC87EHd
	 0lJurXh35v4B1CimFgLqlZ6pBWnMrESC3bXAD490=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yongjian Sun <sunyongjian1@huawei.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	Baokun Li <libaokun1@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	stable@kernel.org
Subject: [PATCH 6.18 618/641] ext4: fix e4b bitmap inconsistency reports
Date: Tue, 24 Feb 2026 17:25:44 -0800
Message-ID: <20260225012403.483285913@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yongjian Sun <sunyongjian1@huawei.com>

commit bdc56a9c46b2a99c12313122b9352b619a2e719e upstream.

A bitmap inconsistency issue was observed during stress tests under
mixed huge-page workloads. Ext4 reported multiple e4b bitmap check
failures like:

ext4_mb_complex_scan_group:2508: group 350, 8179 free clusters as
per group info. But got 8192 blocks

Analysis and experimentation confirmed that the issue is caused by a
race condition between page migration and bitmap modification. Although
this timing window is extremely narrow, it is still hit in practice:

folio_lock                        ext4_mb_load_buddy
__migrate_folio
  check ref count
  folio_mc_copy                     __filemap_get_folio
                                      folio_try_get(folio)
                                  ......
                                  mb_mark_used
                                  ext4_mb_unload_buddy
  __folio_migrate_mapping
    folio_ref_freeze
folio_unlock

The root cause of this issue is that the fast path of load_buddy only
increments the folio's reference count, which is insufficient to prevent
concurrent folio migration. We observed that the folio migration process
acquires the folio lock. Therefore, we can determine whether to take the
fast path in load_buddy by checking the lock status. If the folio is
locked, we opt for the slow path (which acquires the lock) to close this
concurrency window.

Additionally, this change addresses the following issues:

When the DOUBLE_CHECK macro is enabled to inspect bitmap-related
issues, the following error may be triggered:

corruption in group 324 at byte 784(6272): f in copy != ff on
disk/prealloc

Analysis reveals that this is a false positive. There is a specific race
window where the bitmap and the group descriptor become momentarily
inconsistent, leading to this error report:

ext4_mb_load_buddy                   ext4_mb_load_buddy
  __filemap_get_folio(create|lock)
    folio_lock
  ext4_mb_init_cache
    folio_mark_uptodate
                                     __filemap_get_folio(no lock)
                                     ......
                                     mb_mark_used
                                       mb_mark_used_double
  mb_cmp_bitmaps
                                       mb_set_bits(e4b->bd_bitmap)
  folio_unlock

The original logic assumed that since mb_cmp_bitmaps is called when the
bitmap is newly loaded from disk, the folio lock would be sufficient to
prevent concurrent access. However, this overlooks a specific race
condition: if another process attempts to load buddy and finds the folio
is already in an uptodate state, it will immediately begin using it without
holding folio lock.

Signed-off-by: Yongjian Sun <sunyongjian1@huawei.com>
Reviewed-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/20260106090820.836242-1-sunyongjian@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/mballoc.c |   21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -1712,16 +1712,17 @@ ext4_mb_load_buddy_gfp(struct super_bloc
 
 	/* Avoid locking the folio in the fast path ... */
 	folio = __filemap_get_folio(inode->i_mapping, pnum, FGP_ACCESSED, 0);
-	if (IS_ERR(folio) || !folio_test_uptodate(folio)) {
+	if (IS_ERR(folio) || !folio_test_uptodate(folio) || folio_test_locked(folio)) {
+		/*
+		 * folio_test_locked is employed to detect ongoing folio
+		 * migrations, since concurrent migrations can lead to
+		 * bitmap inconsistency. And if we are not uptodate that
+		 * implies somebody just created the folio but is yet to
+		 * initialize it. We can drop the folio reference and
+		 * try to get the folio with lock in both cases to avoid
+		 * concurrency.
+		 */
 		if (!IS_ERR(folio))
-			/*
-			 * drop the folio reference and try
-			 * to get the folio with lock. If we
-			 * are not uptodate that implies
-			 * somebody just created the folio but
-			 * is yet to initialize it. So
-			 * wait for it to initialize.
-			 */
 			folio_put(folio);
 		folio = __filemap_get_folio(inode->i_mapping, pnum,
 				FGP_LOCK | FGP_ACCESSED | FGP_CREAT, gfp);
@@ -1763,7 +1764,7 @@ ext4_mb_load_buddy_gfp(struct super_bloc
 	poff = block % blocks_per_page;
 
 	folio = __filemap_get_folio(inode->i_mapping, pnum, FGP_ACCESSED, 0);
-	if (IS_ERR(folio) || !folio_test_uptodate(folio)) {
+	if (IS_ERR(folio) || !folio_test_uptodate(folio) || folio_test_locked(folio)) {
 		if (!IS_ERR(folio))
 			folio_put(folio);
 		folio = __filemap_get_folio(inode->i_mapping, pnum,


