Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96C191D5141;
	Wed, 25 Feb 2026 01:42:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983731; cv=none; b=P/lY74B0dSzpEF9HNsFwZjbhI/y89Ix9NDLK5gyRtfPRcd+vKJh8m4QHdWakEUo6wugIWl1PUPurqUrOydwKJJyetVvKfEjuyMeA4O9Peh2fDtlkYIJFs1D9nuiqSBe1JpqwUiwe06gU2d0KH1klxO0L8jFVovkWo9q0O8sks+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983731; c=relaxed/simple;
	bh=7eoLgUOxjIoISl2KXj0uiQ0vZGphyqR9LgJCRKkuTgE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ctO9U7Qxn3M7IrbNItTpwwqihykG/vU4pUXDcHi6gNsLdI5wlA8xG4Rijy82PbV4UNltl3Bn70fnrtMRwett3lRGWclugObWqwb4HLKCeMp+lALmr2zPjXEm4iURr81pvNPaDHIqdDmX8R1HqfK/pPtIlv9Zi2wuwFvBtEJIlwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2AniadmD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2AniadmD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 275BDC116D0;
	Wed, 25 Feb 2026 01:42:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983731;
	bh=7eoLgUOxjIoISl2KXj0uiQ0vZGphyqR9LgJCRKkuTgE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2AniadmDxCJ4BO8Lgsqwi0xv2WCmc+JtgxYBneVmsGMxvKLBQ+MArQ904bdpoeajL
	 rFp8iKGSqoEu4oBdzBXgJDuWRnvzEbO7/KMPAQzzaV6ghRFRhfAyyJElTXLC4TWJOp
	 NkXGzQsKYZXF1Nt75LvDnC4CINvogg6Ch6nYjjxE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Daniel Vacek <neelx@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 026/641] btrfs: add orig_logical to btrfs_bio for encryption
Date: Tue, 24 Feb 2026 17:15:52 -0800
Message-ID: <20260225012349.617596661@linuxfoundation.org>
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

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit bd45e9e3f6232f76fa9bd0e40c1e3409e4449f5e ]

When checksumming the encrypted bio on writes we need to know which
logical address this checksum is for.  At the point where we get the
encrypted bio the bi_sector is the physical location on the target disk,
so we need to save the original logical offset in the btrfs_bio.  Then
we can use this when checksumming the bio instead of the
bio->iter.bi_sector.

Note: The patch was taken from v5 of fscrypt patchset
(https://lore.kernel.org/linux-btrfs/cover.1706116485.git.josef@toxicpanda.com/)
which was handled over time by various people: Omar Sandoval, Sweet Tea
Dorminy, Josef Bacik.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Daniel Vacek <neelx@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
[ add note ]
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: b39b26e017c7 ("btrfs: zoned: don't zone append to conventional zone")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/bio.c       | 10 ++++++++++
 fs/btrfs/bio.h       |  2 ++
 fs/btrfs/file-item.c |  2 +-
 3 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/bio.c b/fs/btrfs/bio.c
index 1286c1ac19404..c3d860a2bca42 100644
--- a/fs/btrfs/bio.c
+++ b/fs/btrfs/bio.c
@@ -94,6 +94,8 @@ static struct btrfs_bio *btrfs_split_bio(struct btrfs_fs_info *fs_info,
 	if (bbio_has_ordered_extent(bbio)) {
 		refcount_inc(&orig_bbio->ordered->refs);
 		bbio->ordered = orig_bbio->ordered;
+		bbio->orig_logical = orig_bbio->orig_logical;
+		orig_bbio->orig_logical += map_length;
 	}
 	bbio->csum_search_commit_root = orig_bbio->csum_search_commit_root;
 	atomic_inc(&orig_bbio->pending_ios);
@@ -726,6 +728,14 @@ static bool btrfs_submit_chunk(struct btrfs_bio *bbio, int mirror_num)
 		goto end_bbio;
 	}
 
+	/*
+	 * For fscrypt writes we will get the encrypted bio after we've remapped
+	 * our bio to the physical disk location, so we need to save the
+	 * original bytenr so we know what we're checksumming.
+	 */
+	if (bio_op(bio) == REQ_OP_WRITE && is_data_bbio(bbio))
+		bbio->orig_logical = logical;
+
 	map_length = min(map_length, length);
 	if (use_append)
 		map_length = btrfs_append_map_length(bbio, map_length);
diff --git a/fs/btrfs/bio.h b/fs/btrfs/bio.h
index 9a44b86d561b1..488cdbdd9e2f8 100644
--- a/fs/btrfs/bio.h
+++ b/fs/btrfs/bio.h
@@ -59,6 +59,7 @@ struct btrfs_bio {
 		 * - pointer to the checksums for this bio
 		 * - original physical address from the allocator
 		 *   (for zone append only)
+		 * - original logical address, used for checksumming fscrypt bios
 		 */
 		struct {
 			struct btrfs_ordered_extent *ordered;
@@ -67,6 +68,7 @@ struct btrfs_bio {
 			struct completion csum_done;
 			struct bvec_iter csum_saved_iter;
 			u64 orig_physical;
+			u64 orig_logical;
 		};
 
 		/* For metadata reads: parentness verification. */
diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index 4b7c40f05e8f9..48f444bde5fa9 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -815,7 +815,7 @@ int btrfs_csum_one_bio(struct btrfs_bio *bbio, bool async)
 	if (!sums)
 		return -ENOMEM;
 
-	sums->logical = bio->bi_iter.bi_sector << SECTOR_SHIFT;
+	sums->logical = bbio->orig_logical;
 	sums->len = bio->bi_iter.bi_size;
 	INIT_LIST_HEAD(&sums->list);
 	bbio->sums = sums;
-- 
2.51.0



