Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E67733B05A4;
	Fri,  7 Aug 2026 14:59:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114743; cv=none; b=VlnfEWgXnyGpvLL3LQ7GPTrJu8x4IQ/yYSe0vIQkUiS7NRtg908LZyyFIbS/w6Cy6g9LefUxNLg2IfnPnXU4qH27ybEhRGIACxKsj8bprhtYRTV/ol180LUfrKvJNAZXXpPmp/2MO9YSN50TBadGr7Qc3+L/uNl0jUzZl0ZR+rA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114743; c=relaxed/simple;
	bh=tLzYUk9tEU2daswJby98tim4kVK2KlSUseE7W6Ev0ic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ugl69d6ry4eSC5ZGl8DCHidn6JlhqDls4nQtnEu6Re8RJCQa3w7y/gi5/eWr8Tkbk0Wdis6g66ZfjgCRRk6c7foIpxqzle+vyx1OUrujH2qqWPkNfbzDDW3k20J+lYQYsxfhf1w7KO+z9EqIMqCYiQ5slzbOR3itk8jeo6VDNK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OahCKu6E; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OahCKu6E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03FF91F00A3A;
	Fri,  7 Aug 2026 14:59:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114741;
	bh=GqlFFdj+JZoka8KUQZ+4bUgMvO6OK0wtpZpnYYmq6+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OahCKu6EkJmkKCYZEWGTAzLfFB2y+QMGf1p7jx9ALdLQ1yN5q9GtqNprqfhKF7LyZ
	 42vaE/QmiCtgf+xCjU4D5tgBWUWime7GpB4f02hVLQuC4YUtQ1DQUOrdOjNpFTAAvd
	 zcwlfvvlJ9eE7xYhl1HWXBWkUUoO58OGCbpLwQs0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Vacek <neelx@suse.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 031/396] btrfs: raid56: fix an incorrect csum skip during scrub
Date: Fri,  7 Aug 2026 16:33:11 +0200
Message-ID: <20260807143424.943730306@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

[ Upstream commit 330dcc553f282e8dc0b88c9495b4c296465364e1 ]

Commit 7425a2894019 ("btrfs: introduce btrfs_bio_for_each_block_all()
helper") uses the new helper to replace the nested loop inside
verify_bio_data_sectors(), which simplifies the code.

However that also changed the behavior of "continue" when a block has no
data checksum.

Previously the "continue" would skip the old for() loop, which would also
increase @total_sector_nr.

Now the "continue" will skip the new btrfs_bio_for_each_block_all()
loop, which doesn't update @total_sector_nr.

This means if we hit a block that has no data checksum, we will skip all
the remaining blocks no matter if they have data checksum.
As @total_sector_nr will never be updated, and that test_bit() will
always return false.

Fix it by increasing @total_sector_nr before calling "continue".

Fixes: 7425a2894019 ("btrfs: introduce btrfs_bio_for_each_block_all() helper")
Reviewed-by: Daniel Vacek <neelx@suse.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/raid56.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index 0135dceb7baaa..4d4852f2ba7eb 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -1583,8 +1583,10 @@ static void verify_bio_data_sectors(struct btrfs_raid_bio *rbio,
 		int ret;
 
 		/* No csum for this sector, skip to the next sector. */
-		if (!test_bit(total_sector_nr, rbio->csum_bitmap))
+		if (!test_bit(total_sector_nr, rbio->csum_bitmap)) {
+			total_sector_nr++;
 			continue;
+		}
 
 		ret = btrfs_check_block_csum(fs_info, paddr,
 					     csum_buf, expected_csum);
-- 
2.53.0



