Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C0C136DA0F;
	Sat, 28 Feb 2026 17:57:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301469; cv=none; b=l2fkYteE8dBfjqgQf7UFDPJcVVeHrlnA15ssLh9NnB6a5M5OycbKyDwihj9xKrAWuD002aKz7f9XBHAUjaNgqI9fro5GfRlykzd5HIHmnx0t7IkfFn8t2SCYZZD1JkDg/56bGFOxHdgsjMti2GMBe9YMk1hUqhXNCpyRD9akdmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301469; c=relaxed/simple;
	bh=yMS0BgmJmKe5TSW4NOligMEP01OzhOnh2Eem50LILFY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GU3zhg+S1ndhIX4GPmPz0xkivofcBD8Vde6O3EblqAO1qMdWOSDtxbWuh984ylMHSGqEKqiGxcXalnyvnqeMnKfG/O+M+KJ5+vUkiLgAZlhYF8Wc0KK20S3FLhi1+10R9YUbvFW3GQH3a934G4NTt2vchzpbTjr8kAj1/dAztRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kXKohXoq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kXKohXoq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EEEAC19424;
	Sat, 28 Feb 2026 17:57:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301469;
	bh=yMS0BgmJmKe5TSW4NOligMEP01OzhOnh2Eem50LILFY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kXKohXoq3PrQXO87O4fAE5tuIo8cQhWXXA3BdTvfnJ1mf/OtmBG/WOzv8UJtHmRSu
	 naGnL8BZu5v5DySdsGT8tUo6JFlDCS8ySXGE4+mtqZP1gptloWOtQvBhuJe0H2YGfv
	 Uubp8XQPXTQ/oUA58HLoGbo5YHgYlTVDKvwMC/kMpmb3u7hSHHxp6cKnYFpF7suDHm
	 4nIkfEA1EnSGabVEDbLE355kwoZ9nztnjUdu4w28eaPGpf3DbEbTZx6mlv+sCpxO4b
	 XkCGwGMYAgvEl6Ma8lbTUh+7KERAFhDqyKH6DMByLKxwzrDCTaET5dzb9V2gjF5rki
	 loIyTfzpywnAg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Naohiro Aota <naohiro.aota@wdc.com>,
	stable@vger.kernel.org,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 654/752] btrfs: zoned: fixup last alloc pointer after extent removal for DUP
Date: Sat, 28 Feb 2026 12:46:05 -0500
Message-ID: <20260228174750.1542406-654-sashal@kernel.org>
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

From: Naohiro Aota <naohiro.aota@wdc.com>

[ Upstream commit e2d848649e64de39fc1b9c64002629b4daa1105d ]

When a block group is composed of a sequential write zone and a
conventional zone, we recover the (pseudo) write pointer of the
conventional zone using the end of the last allocated position.

However, if the last extent in a block group is removed, the last extent
position will be smaller than the other real write pointer position.
Then, that will cause an error due to mismatch of the write pointers.

We can fixup this case by moving the alloc_offset to the corresponding
write pointer position.

Fixes: c0d90a79e8e6 ("btrfs: zoned: fix alloc_offset calculation for partly conventional block groups")
CC: stable@vger.kernel.org # 6.16+
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/zoned.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 8e6e96660fa66..4cbe1ba7af66d 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -1442,6 +1442,20 @@ static int btrfs_load_block_group_dup(struct btrfs_block_group *bg,
 		return -EIO;
 	}
 
+	/*
+	 * When the last extent is removed, last_alloc can be smaller than the other write
+	 * pointer. In that case, last_alloc should be moved to the corresponding write
+	 * pointer position.
+	 */
+	for (int i = 0; i < map->num_stripes; i++) {
+		if (zone_info[i].alloc_offset == WP_CONVENTIONAL)
+			continue;
+		if (last_alloc <= zone_info[i].alloc_offset) {
+			last_alloc = zone_info[i].alloc_offset;
+			break;
+		}
+	}
+
 	if (zone_info[0].alloc_offset == WP_CONVENTIONAL)
 		zone_info[0].alloc_offset = last_alloc;
 
-- 
2.51.0

