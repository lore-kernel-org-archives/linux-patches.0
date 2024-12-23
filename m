Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7FB3188733;
	Mon, 23 Dec 2024 16:08:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970105; cv=none; b=VvR/G/gBS/2CodQbpZlHkAGGuOsZH6VeeZxyY2J/mGLgBG7+GgAlCiGOls6ZDsCXAQyusYkyWMzltZ/roiqlxibpJwB57x1WyA5iTe7NnWbEZaH6IhaYnqbXX4WkkcuWOo2R/4Xx46hfeE3LtbhsZ6f+OuNXpI/WWEnKB0ELC+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970105; c=relaxed/simple;
	bh=TyFWlriFFh6C197+s0270gZmOe8YkHHt2dXiZD6Or9Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tnu2Z5sqBxaZI0eHgl4ObSAoUlnKOjncPktNscmU+B2poEqqUGIi9EjkLh9Rd5Qip0aeilQPXKsP2J1IKuuFfHY78ioyT4o7zcqAVU8LAn4SEbIjk8hlOhAMDIPL76SLSYEh4NH2E7SCUYEEdJO7KYetMExci52iypKpL51I+XU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yGH7N23R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yGH7N23R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38077C4CED3;
	Mon, 23 Dec 2024 16:08:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970105;
	bh=TyFWlriFFh6C197+s0270gZmOe8YkHHt2dXiZD6Or9Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yGH7N23ReL0rPnYJW2G3fyGHESmfNRVKCWY/jzHu4n04HAaZLRe1c8o2C9ZyXrova
	 XlZ7AAx2FcePh1eX9ByfOFMBXBh7u8eL19ZDf1yUpplS6srqkbg7X9sBqt1MNJJVvm
	 FBRLw7aEKsUp3I2iukEvzAhBrdK9MENpKP+e3gG8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.12 115/160] btrfs: split bios to the fs sector size boundary
Date: Mon, 23 Dec 2024 16:58:46 +0100
Message-ID: <20241223155413.116555820@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155408.598780301@linuxfoundation.org>
References: <20241223155408.598780301@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Christoph Hellwig <hch@lst.de>

commit be691b5e593f2cc8cef67bbc59c1fb91b74a86a9 upstream.

Btrfs like other file systems can't really deal with I/O not aligned to
it's internal block size (which strangely is called sector size in
btrfs, for historical reasons), but the block layer split helper doesn't
even know about that.

Round down the split boundary so that all I/Os are aligned.

Fixes: d5e4377d5051 ("btrfs: split zone append bios in btrfs_submit_bio")
CC: stable@vger.kernel.org # 6.12
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/bio.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/fs/btrfs/bio.c
+++ b/fs/btrfs/bio.c
@@ -649,8 +649,14 @@ static u64 btrfs_append_map_length(struc
 	map_length = min(map_length, bbio->fs_info->max_zone_append_size);
 	sector_offset = bio_split_rw_at(&bbio->bio, &bbio->fs_info->limits,
 					&nr_segs, map_length);
-	if (sector_offset)
-		return sector_offset << SECTOR_SHIFT;
+	if (sector_offset) {
+		/*
+		 * bio_split_rw_at() could split at a size smaller than our
+		 * sectorsize and thus cause unaligned I/Os.  Fix that by
+		 * always rounding down to the nearest boundary.
+		 */
+		return ALIGN_DOWN(sector_offset << SECTOR_SHIFT, bbio->fs_info->sectorsize);
+	}
 	return map_length;
 }
 


