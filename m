Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3D2813C9C4;
	Wed,  5 Feb 2025 13:58:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763888; cv=none; b=lVk2sdSM1ymzs7oKYK6aMgX9gnXUvD/Ml15vDwp/YvT5EfpM0V0eBMIzwSGc9iNfel77yUSwdLsMgDgwbQ1UWE3alYXCBGtVhPEnZkb4Ka/CukMPhk9xBWRsiGfy0AL9LKsoWqmF+TxpbpyxvfbIKe0rV8pZoHPWn3NYIPK3P9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763888; c=relaxed/simple;
	bh=rqdpbJxYWii1Iq2vk6y65zZfjpll4JIvSluuUdgRAwk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qDBYNHOMxZ/Tw32EK3shv2zR53V9nHggtyLu4betpKNL5yhkOJXaU+F6bundhk//CVdsFbzefM1UssntApbPIpxEdvwg/RTRqcH2BEUyvJPWomn9l6vmdjxrpDkGFjWHzR9zQuzKzo03Ak0m92+gJAJYb55S1v8Lq+3ZWeZichM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kzpUP3Ml; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kzpUP3Ml"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46657C4CED1;
	Wed,  5 Feb 2025 13:58:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763887;
	bh=rqdpbJxYWii1Iq2vk6y65zZfjpll4JIvSluuUdgRAwk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kzpUP3MlbojMXc7tsvqv3nt1BXdnZJQM0bKQ3KvwKZQNX+pBKNTNGsl6eWBaWK43M
	 1fVIM1ZKN4gU8VE58Y/pnZ0rkLj8RsivwN84LVW6PvOafiTtLuVMQREkYTDlWgSaux
	 btVtGAuVLEABGGe3HRKBXsVoXNxJIbvA8Avgz3Sg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Burkov <boris@bur.io>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 027/623] btrfs: subpage: fix the bitmap dump of the locked flags
Date: Wed,  5 Feb 2025 14:36:09 +0100
Message-ID: <20250205134457.267193812@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qu Wenruo <wqu@suse.com>

[ Upstream commit 396294d1afee65a203d6cabd843d0782e5d7388e ]

We're dumping the locked bitmap into the @checked_bitmap variable,
printing incorrect values during debug.

Thankfully even during my development I haven't hit a case where I need
to dump the locked bitmap.  But for the sake of consistency, fix it by
dupping the locked bitmap into @locked_bitmap variable for output.

Fixes: 75258f20fb70 ("btrfs: subpage: dump extra subpage bitmaps for debug")
Reviewed-by: Boris Burkov <boris@bur.io>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/subpage.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/subpage.c b/fs/btrfs/subpage.c
index 8c68059ac1b0c..03d7bfc042e2a 100644
--- a/fs/btrfs/subpage.c
+++ b/fs/btrfs/subpage.c
@@ -716,6 +716,7 @@ void __cold btrfs_subpage_dump_bitmap(const struct btrfs_fs_info *fs_info,
 	unsigned long writeback_bitmap;
 	unsigned long ordered_bitmap;
 	unsigned long checked_bitmap;
+	unsigned long locked_bitmap;
 	unsigned long flags;
 
 	ASSERT(folio_test_private(folio) && folio_get_private(folio));
@@ -728,15 +729,16 @@ void __cold btrfs_subpage_dump_bitmap(const struct btrfs_fs_info *fs_info,
 	GET_SUBPAGE_BITMAP(subpage, fs_info, writeback, &writeback_bitmap);
 	GET_SUBPAGE_BITMAP(subpage, fs_info, ordered, &ordered_bitmap);
 	GET_SUBPAGE_BITMAP(subpage, fs_info, checked, &checked_bitmap);
-	GET_SUBPAGE_BITMAP(subpage, fs_info, locked, &checked_bitmap);
+	GET_SUBPAGE_BITMAP(subpage, fs_info, locked, &locked_bitmap);
 	spin_unlock_irqrestore(&subpage->lock, flags);
 
 	dump_page(folio_page(folio, 0), "btrfs subpage dump");
 	btrfs_warn(fs_info,
-"start=%llu len=%u page=%llu, bitmaps uptodate=%*pbl dirty=%*pbl writeback=%*pbl ordered=%*pbl checked=%*pbl",
+"start=%llu len=%u page=%llu, bitmaps uptodate=%*pbl dirty=%*pbl locked=%*pbl writeback=%*pbl ordered=%*pbl checked=%*pbl",
 		    start, len, folio_pos(folio),
 		    sectors_per_page, &uptodate_bitmap,
 		    sectors_per_page, &dirty_bitmap,
+		    sectors_per_page, &locked_bitmap,
 		    sectors_per_page, &writeback_bitmap,
 		    sectors_per_page, &ordered_bitmap,
 		    sectors_per_page, &checked_bitmap);
-- 
2.39.5



