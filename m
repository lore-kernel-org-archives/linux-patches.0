Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 960B546EF71;
	Tue, 21 Jul 2026 18:46:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659609; cv=none; b=qvmzvPt/LGPMenPwiuSV/K55g/2z5ncMRlksdlvD0RU8aYNJ0ZBqbwhhy8Hji3D+RHi+jXeJDoKFp+0FaOBuqpM6GLwZRlkmrPnV2KpiBafB6UJNOz/0AtwgPDWLM8Kn6SNHiFJvKOe55TC0B3dyfM76MayMUMqbwymVs6SEVpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659609; c=relaxed/simple;
	bh=t2nVou5bJIuat8rR2kqDnZQ+HGbruLyAetm+N5lg6ac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ab/iG/nPanx5LBlZazRygdfkBCFBJJNgpJ86xADYwklHbdam7UO1kHJj7nbOVFjQKmwN5aegVI3M/GfJKWSblPkCSCHqOS8ZGxdSjx38bKXuiiqmlLUPpJR6eSqvydHJbdq4k95eaD1gufNQUf0jn7O1me9R8GN7Gx8bU4sMwqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h983pbgj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h983pbgj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F32511F000E9;
	Tue, 21 Jul 2026 18:46:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659608;
	bh=Kl43uSWMDn5MgQrjmG2J4aYsvc3upzpLpCWPqnA3ylw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h983pbgjZ1BfOR8lYduBNyN+6EDcLPwgYOr4Mt6Hxfi8K/Tg2l1ERpYTB2jh9rzNk
	 6GWdRrrzFHi/wrw7Cd7ak2/SHFFPU2FeQwuhWmsV33mRVoQ0Jjlui8Vns7nsHbTISb
	 O+SmZQKVOb5d0etwmWbB8LomsGFBxHHebW9RMDxE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Burkov <boris@bur.io>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1586/1611] btrfs: concentrate the error handling of submit_one_sector()
Date: Tue, 21 Jul 2026 17:28:22 +0200
Message-ID: <20260721152551.146103269@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Qu Wenruo <wqu@suse.com>

[ Upstream commit 44820d80026e0b509007d41c83d42f1213ee8589 ]

Currently submit_one_sector() has only one failure path from
btrfs_get_extent().

However the error handling is split into two parts, one inside
submit_one_sector(), which clears the dirty flag and finishes the
writeback for the fs block.

The other part is to submit any remaining bio inside bio_ctrl and mark
the ordered extent finished for the fs block.

There is no special reason that we must split the error handling, let's
just concentrate all the error handling into submit_one_sector().

Reviewed-by: Boris Burkov <boris@bur.io>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: 66ff4d366e7e ("btrfs: fix false IO failure after falling back to buffered write")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/extent_io.c |   29 +++++++++++++++--------------
 1 file changed, 15 insertions(+), 14 deletions(-)

--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1599,7 +1599,7 @@ out:
 
 /*
  * Return 0 if we have submitted or queued the sector for submission.
- * Return <0 for critical errors, and the sector will have its dirty flag cleared.
+ * Return <0 for critical errors, and the involved sector will be cleaned up.
  *
  * Caller should make sure filepos < i_size and handle filepos >= i_size case.
  */
@@ -1624,6 +1624,13 @@ static int submit_one_sector(struct btrf
 	em = btrfs_get_extent(inode, NULL, filepos, sectorsize);
 	if (IS_ERR(em)) {
 		/*
+		 * bio_ctrl may contain a bio crossing several folios.
+		 * Submit it immediately so that the bio has a chance
+		 * to finish normally, other than marked as error.
+		 */
+		submit_one_bio(bio_ctrl);
+
+		/*
 		 * When submission failed, we should still clear the folio dirty.
 		 * Or the folio will be written back again but without any
 		 * ordered extent.
@@ -1631,6 +1638,13 @@ static int submit_one_sector(struct btrf
 		btrfs_folio_clear_dirty(fs_info, folio, filepos, sectorsize);
 		btrfs_folio_set_writeback(fs_info, folio, filepos, sectorsize);
 		btrfs_folio_clear_writeback(fs_info, folio, filepos, sectorsize);
+
+		/*
+		 * Since there is no bio submitted to finish the ordered
+		 * extent, we have to manually finish this sector.
+		 */
+		btrfs_mark_ordered_io_finished(inode, folio, filepos,
+					       fs_info->sectorsize, false);
 		return PTR_ERR(em);
 	}
 
@@ -1756,19 +1770,6 @@ static noinline_for_stack int extent_wri
 		}
 		ret = submit_one_sector(inode, folio, cur, bio_ctrl, i_size);
 		if (unlikely(ret < 0)) {
-			/*
-			 * bio_ctrl may contain a bio crossing several folios.
-			 * Submit it immediately so that the bio has a chance
-			 * to finish normally, other than marked as error.
-			 */
-			submit_one_bio(bio_ctrl);
-			/*
-			 * Failed to grab the extent map which should be very rare.
-			 * Since there is no bio submitted to finish the ordered
-			 * extent, we have to manually finish this sector.
-			 */
-			btrfs_mark_ordered_io_finished(inode, folio, cur,
-						       fs_info->sectorsize, false);
 			if (!found_error)
 				found_error = ret;
 			continue;


