Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAFB33101CE;
	Mon, 13 Oct 2025 15:06:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368016; cv=none; b=FeM/ANyTzieyrUjAsJYDYRBMoqbFMMCAVTMcs+yjQx+8YG+CKLC/Dc69lozTk4mU/YpFauRXPZN9B6wVBlnHv2dmjSZdu1WaY9Z2qvVAaZN5v2fw3Y5bR9Co1BxftRX8761GYDShTVKum1NeqRhjfgFGsUi0FM+iZB668rkeg2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368016; c=relaxed/simple;
	bh=7pcTRgnkv16c390QwZVIHbvtzFtm/SlLb/tnr2slnUU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JyDj2k9LGKy57abt4Mf40WJz0vFldTnvr7zNaYRyrhnk8pmJ6F/QnuOIr+S7huTIKFAFhxH9fBRxj9fwpGD5jhhnR2DrbPRxNEwkq1uCehm/nMeZGAyZcYSRI5U3SUGWpXL61Wf4vjo6ti+yKNUIltkSjM3Kl5DT8vNvx4zuO38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rv+Cc1Gj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rv+Cc1Gj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EB7BC4CEE7;
	Mon, 13 Oct 2025 15:06:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368015;
	bh=7pcTRgnkv16c390QwZVIHbvtzFtm/SlLb/tnr2slnUU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rv+Cc1Gjmqqk2PhHXdAj62W9rC3/mYgu6leu7SNheQdbaAkERxeqLM9v7dHm4N1Gk
	 qBwhiZohZ+ek+5sMu/FfsXJi4/UtrIDVN6sxV4PMvxsVTxl6hIVRRKYGRKGF8V6nud
	 c2A+1zZYYJCDA77Eqx5gnzRAHuXOPHix9ujgpuSo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Vacek <neelx@suse.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 015/262] btrfs: return any hit error from extent_writepage_io()
Date: Mon, 13 Oct 2025 16:42:37 +0200
Message-ID: <20251013144326.676862567@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qu Wenruo <wqu@suse.com>

[ Upstream commit 2d83ed6c6c4607b42ee7927e92a9d2fa31d6f30b ]

Since the support of bs < ps support, extent_writepage_io() will submit
multiple blocks inside the folio.

But if we hit error submitting one sector, but the next sector can still
be submitted successfully, the function extent_writepage_io() will still
return 0.

This will make btrfs to silently ignore the error without setting error
flag for the filemap.

Fix it by recording the first error hit, and always return that value.

Fixes: 8bf334beb349 ("btrfs: fix double accounting race when extent_writepage_io() failed")
Reviewed-by: Daniel Vacek <neelx@suse.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/extent_io.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index afebc91882bef..60fe155b1ce05 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1479,7 +1479,7 @@ static noinline_for_stack int extent_writepage_io(struct btrfs_inode *inode,
 	struct btrfs_fs_info *fs_info = inode->root->fs_info;
 	unsigned long range_bitmap = 0;
 	bool submitted_io = false;
-	bool error = false;
+	int found_error = 0;
 	const u64 folio_start = folio_pos(folio);
 	u64 cur;
 	int bit;
@@ -1536,7 +1536,8 @@ static noinline_for_stack int extent_writepage_io(struct btrfs_inode *inode,
 			 */
 			btrfs_mark_ordered_io_finished(inode, folio, cur,
 						       fs_info->sectorsize, false);
-			error = true;
+			if (!found_error)
+				found_error = ret;
 			continue;
 		}
 		submitted_io = true;
@@ -1553,11 +1554,11 @@ static noinline_for_stack int extent_writepage_io(struct btrfs_inode *inode,
 	 * If we hit any error, the corresponding sector will still be dirty
 	 * thus no need to clear PAGECACHE_TAG_DIRTY.
 	 */
-	if (!submitted_io && !error) {
+	if (!submitted_io && !found_error) {
 		btrfs_folio_set_writeback(fs_info, folio, start, len);
 		btrfs_folio_clear_writeback(fs_info, folio, start, len);
 	}
-	return ret;
+	return found_error;
 }
 
 /*
-- 
2.51.0



