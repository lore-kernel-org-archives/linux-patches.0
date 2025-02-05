Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5943013C9C4;
	Wed,  5 Feb 2025 13:51:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763507; cv=none; b=rThHwqTb7gtPZeXLxYU8tU32qn+bBwcpVSad595K7nuWQDBSv0BLJ64NzUKAkbkyncO+uGi6h3QyKb9Br0WPfcDGNMM4ymK07pqoWAdCQOBcflnVVDHcWFAx3mXaASYT0HainrbicejbUbwhNJnGM4yeHxyS0ddNvOQpM1cmX+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763507; c=relaxed/simple;
	bh=ikUO73TSeC4+FWPN+iGBhb0QZjUjKkGrrnlJmYn9Za4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e+9K18JhGnTatmQ94viwW62/46ePC83hunQetpeZyD3BM4+P+UKa0UbZ5pTpO7b6pcgzIP0HCShV73PFStgriq2b/8MS8Y3tSvBvHwEdTtUzggvjSvR2qmEFp/XOUsgjbqYoyCmrGxpVPx4Qi/Wvyc+YoaF+/hZ6p4kBtt1ZjXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XAmwwpkL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XAmwwpkL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD34DC4CED1;
	Wed,  5 Feb 2025 13:51:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763507;
	bh=ikUO73TSeC4+FWPN+iGBhb0QZjUjKkGrrnlJmYn9Za4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XAmwwpkLH/JXirq7vY1EDRVd8whWILTgQpVE4SUPJNuUMUmS54dxXSI+rx97zMSlG
	 h+gE8VzhDg7GDlam01prxClWEY7K0GJEityUeyEcer36f6duW/T6K3h++cR+5jkvsl
	 iGc6DlQgAUa5gtkwTpFOh1JB/4vTG873EzUH6J4Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Burkov <boris@bur.io>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 023/590] btrfs: subpage: fix the bitmap dump of the locked flags
Date: Wed,  5 Feb 2025 14:36:18 +0100
Message-ID: <20250205134456.131567836@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index fe4d719d506bf..ec7328a6bfd75 100644
--- a/fs/btrfs/subpage.c
+++ b/fs/btrfs/subpage.c
@@ -868,6 +868,7 @@ void __cold btrfs_subpage_dump_bitmap(const struct btrfs_fs_info *fs_info,
 	unsigned long writeback_bitmap;
 	unsigned long ordered_bitmap;
 	unsigned long checked_bitmap;
+	unsigned long locked_bitmap;
 	unsigned long flags;
 
 	ASSERT(folio_test_private(folio) && folio_get_private(folio));
@@ -880,15 +881,16 @@ void __cold btrfs_subpage_dump_bitmap(const struct btrfs_fs_info *fs_info,
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



