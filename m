Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E32B4BCAD5;
	Sat, 28 Feb 2026 17:56:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301370; cv=none; b=JT847p+QiPJFPR7AsX2GUYL4jHS7LH0paQamTop73cWeSClT8Apy+bTFPVnHhq8XS+pMzZEjt06tW7Jb4uQwIaRApaG6hUNQZ+gYGjo5GMRCE8/BUkDWJotGsZWxex3BdIu73TSmKvP9h5A3Tkwy/Th3Zb2SqogXgNPiifobCHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301370; c=relaxed/simple;
	bh=uyuwHoRo/ZWZHG1r0TNz72203WGOTdwB80ya0qW2DuQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OkNJxp/k1k9aT6km3Iu4BWgv97fFn6j8QQC/NWD0wV7s1q8E53GDXRI37HLqwDRAIN7Ptb0OdVYeNidMrsE1cz9ztXCaal6Ee9yTdkst0iAkjfbkP3IgNk1u/c70XO//gCxDUGF8fhYNQr3C3joWgAZy+4nku3DHhSFW5Krm0M8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QE8sxjnC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QE8sxjnC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD964C116D0;
	Sat, 28 Feb 2026 17:56:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301370;
	bh=uyuwHoRo/ZWZHG1r0TNz72203WGOTdwB80ya0qW2DuQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QE8sxjnC0I1tJX5IdgW92lWE0uyTfpBfGHAmJUYQJi0sH5MmErjZ9DpwceTtxvR9T
	 GOSEez9egt4Z7DYIW46ErJVnqj4wIzfqs1YvGnU+UhngASo3KGRZ7X+y7EQOo6mgJl
	 KsB45mzayf2xLTXSPiu+myyC8g2QxPw7YokAjojKlScHEMscra/Ldzgdtidpygbobc
	 6iyMvc7aVOU3URu7KAdIVVqhFVTbExM5rmpQY86XzVuBrc6stPwfL2tV1EqXXz7Z9D
	 f05M4brtyH0n4dp938roZ60nutom2sLip4B2hDcSVJapI9icfhLjE8FJlkzgZ7jh71
	 HpmsalT4XZdWQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Mikulas Patocka <mpatocka@redhat.com>,
	Ondrej Kozina <okozina@redhat.com>,
	stable@vger.kernel.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 559/752] dm-integrity: fix recalculation in bitmap mode
Date: Sat, 28 Feb 2026 12:44:30 -0500
Message-ID: <20260228174750.1542406-559-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Mikulas Patocka <mpatocka@redhat.com>

[ Upstream commit 118ba36e446c01e3cd34b3eedabf1d9436525e1d ]

There's a logic quirk in the handling of suspend in the bitmap mode:

This is the sequence of calls if we are reloading a dm-integrity table:
* dm_integrity_ctr reads a superblock with the flag SB_FLAG_DIRTY_BITMAP
  set.
* dm_integrity_postsuspend initializes a journal and clears the flag
  SB_FLAG_DIRTY_BITMAP.
* dm_integrity_resume sees the superblock with SB_FLAG_DIRTY_BITMAP set -
  thus it interprets the journal as if it were a bitmap.

This quirk causes recalculation problem if the user increases the size of
the device in the bitmap mode.

Fix this by reading a fresh copy on the superblock in
dm_integrity_resume. This commit also fixes another logic quirk - the
branch that sets bitmap bits if the device was extended should only be
executed if the flag SB_FLAG_DIRTY_BITMAP is set.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Tested-by: Ondrej Kozina <okozina@redhat.com>
Fixes: 468dfca38b1a ("dm integrity: add a bitmap mode")
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-integrity.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index 79d60495454a5..ba52631052503 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -3788,14 +3788,27 @@ static void dm_integrity_resume(struct dm_target *ti)
 	struct dm_integrity_c *ic = ti->private;
 	__u64 old_provided_data_sectors = le64_to_cpu(ic->sb->provided_data_sectors);
 	int r;
+	__le32 flags;
 
 	DEBUG_print("resume\n");
 
 	ic->wrote_to_journal = false;
 
+	flags = ic->sb->flags & cpu_to_le32(SB_FLAG_RECALCULATING);
+	r = sync_rw_sb(ic, REQ_OP_READ);
+	if (r)
+		dm_integrity_io_error(ic, "reading superblock", r);
+	if ((ic->sb->flags & flags) != flags) {
+		ic->sb->flags |= flags;
+		r = sync_rw_sb(ic, REQ_OP_WRITE | REQ_FUA);
+		if (unlikely(r))
+			dm_integrity_io_error(ic, "writing superblock", r);
+	}
+
 	if (ic->provided_data_sectors != old_provided_data_sectors) {
 		if (ic->provided_data_sectors > old_provided_data_sectors &&
 		    ic->mode == 'B' &&
+		    ic->sb->flags & cpu_to_le32(SB_FLAG_DIRTY_BITMAP) &&
 		    ic->sb->log2_blocks_per_bitmap_bit == ic->log2_blocks_per_bitmap_bit) {
 			rw_journal_sectors(ic, REQ_OP_READ, 0,
 					   ic->n_bitmap_blocks * (BITMAP_BLOCK_SIZE >> SECTOR_SHIFT), NULL);
-- 
2.51.0

