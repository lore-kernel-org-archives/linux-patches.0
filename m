Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4BA82BE03C;
	Tue, 26 Aug 2025 11:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207611; cv=none; b=c0BjBtU96dqMe/MZCUBGaEwgnaIMcsX5J8bC1KdtmHvoyaN1L/ZcNHsiEzzNqLp9DRWQkEuvuJvegvc02mHKn9BNNO97Gzed6woiqtzAUmtwClp889rxtkZKphtsmbTWPbsIjSNKIQgM9yh1ljisNofONCk3Dbzp9KfvsAu2IQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207611; c=relaxed/simple;
	bh=0EwureN04fJtLTN3RbThe8OgYgejt+D3IKlcdJTs1xY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CJIMS38RSgNpiGM/7+iWOcDxrgXxXI4VJvL+3t054JQkdE0Uc4OjEYCx0ZZKVK+1QRed+CIjIraGn60b47thO8x9vvgIbHAXNTg2s4f6J1JDhZf9y6SMTlQKyfn/hN2OwIKNb8e6b0xvOLw+X5t2giutkxpY9g1MFyA9IZw2l7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jmxg5+Us; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jmxg5+Us"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F31EC4CEF1;
	Tue, 26 Aug 2025 11:26:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207611;
	bh=0EwureN04fJtLTN3RbThe8OgYgejt+D3IKlcdJTs1xY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jmxg5+UsTCjLkPJ7JnCc9+WlpEE3D/lXM/33emyeJMPywFxIzvwD/xNl1WdB7bWpb
	 EKiEGCyIymj8wxOvSNK5uK77v2VRgtc1+Mdb2P02KsBsH7A68rdeKCl9V3VsjaUqkt
	 g2ugV0DGULMOOcJYwQBBx49UrAeMZJFkTSiVyn0o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 219/457] btrfs: add comments on the extra btrfs specific subpage bitmaps
Date: Tue, 26 Aug 2025 13:08:23 +0200
Message-ID: <20250826110942.775221169@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qu Wenruo <wqu@suse.com>

[ Upstream commit 1e17738d6b76cdc76d240d64de87fa66ba2365f7 ]

Unlike the iomap_folio_state structure, the btrfs_subpage structure has a
lot of extra sub-bitmaps, namely:

- writeback sub-bitmap
- locked sub-bitmap
  iomap_folio_state uses an atomic for writeback tracking, while it has
  no per-block locked tracking.

  This is because iomap always locks a single folio, and submits dirty
  blocks with that folio locked.

  But btrfs has async delalloc ranges (for compression), which are queued
  with their range locked, until the compression is done, then marks the
  involved range writeback and unlocked.

  This means a range can be unlocked and marked writeback at seemingly
  random timing, thus it needs the extra tracking.

  This needs a huge rework on the lifespan of async delalloc range
  before we can remove/simplify these two sub-bitmaps.

- ordered sub-bitmap
- checked sub-bitmap
  These are for COW-fixup, but as I mentioned in the past, the COW-fixup
  is not really needed anymore and these two flags are already marked
  deprecated, and will be removed in the near future after comprehensive
  tests.

Add related comments to indicate we're actively trying to align the
sub-bitmaps to the iomap ones.

Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: b1511360c8ac ("btrfs: subpage: keep TOWRITE tag until folio is cleaned")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/subpage.h |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/fs/btrfs/subpage.h
+++ b/fs/btrfs/subpage.h
@@ -33,8 +33,22 @@ enum {
 	btrfs_bitmap_nr_uptodate = 0,
 	btrfs_bitmap_nr_dirty,
 	btrfs_bitmap_nr_writeback,
+	/*
+	 * The ordered and checked flags are for COW fixup, already marked
+	 * deprecated, and will be removed eventually.
+	 */
 	btrfs_bitmap_nr_ordered,
 	btrfs_bitmap_nr_checked,
+
+	/*
+	 * The locked bit is for async delalloc range (compression), currently
+	 * async extent is queued with the range locked, until the compression
+	 * is done.
+	 * So an async extent can unlock the range at any random timing.
+	 *
+	 * This will need a rework on the async extent lifespan (mark writeback
+	 * and do compression) before deprecating this flag.
+	 */
 	btrfs_bitmap_nr_locked,
 	btrfs_bitmap_nr_max
 };


