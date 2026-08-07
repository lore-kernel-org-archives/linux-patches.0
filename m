Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B703F377A8A;
	Fri,  7 Aug 2026 15:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116613; cv=none; b=VqApNzQ1Gg8BDyGGReOe2HwUtHPMt5hiGWnEcWPn9uxsvZC+DSmGKDUbCvKWBxMtERJh1Dyg7knv2mSW0EFtjp9dBXYBChTwog3Q2TcaQO+UETgjLu3jb2OfjMfmSM1a5zcp0K0ptOC9avBIQxq+XV3jW4ug2qtkoDyQBmZeH8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116613; c=relaxed/simple;
	bh=kda5oAhC6/Q889HJ1aKGB00pDE9uZW6oZXIoDCcbHh4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k5aql/o4k69Ju0DRqaJoCQXhakYspO8+XshFRnpCDH+p5Wnb3g3S4zICh1WyrZowq4PYt0lmqwA1xwTY4JGKtPgUlHgRIrTjRuwXli9HLvQO6HSQtQToHgu0GOKVWD+Dh4a6mhzW/2Smjthrry/ajiOj/kTEtO0+iNa6ecNiNFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rHdRkfPh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rHdRkfPh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F59D1F000E9;
	Fri,  7 Aug 2026 15:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116611;
	bh=QYcfymb2ppXg7oVGkzlBkCQz6y5FnnNuVceAFpdtX8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rHdRkfPhg481P0k2HSNcLh1X+Q+yLMJEo5mnPBdjAJ021W7Pa8+qWQ/pIpP/q+8OL
	 FQy36T8DoZmKBpN4tzNS/1nqFg6rI4fZIuQ92/lU0BwyFiploBdrNlh0wfvbwrVrvA
	 sq7DxUy+u9rBNYU5vyz9U6CihczcEt/fY+V/MCKI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Vacek <neelx@suse.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 030/438] btrfs: raid56: fix an incorrect csum skip during scrub
Date: Fri,  7 Aug 2026 16:33:46 +0200
Message-ID: <20260807143428.650380207@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 08ee8f316d96d..515ffa4b02114 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -1679,8 +1679,10 @@ static void verify_bio_data_sectors(struct btrfs_raid_bio *rbio,
 			continue;
 
 		/* No csum for this sector, skip to the next sector. */
-		if (!test_bit(total_sector_nr, rbio->csum_bitmap))
+		if (!test_bit(total_sector_nr, rbio->csum_bitmap)) {
+			total_sector_nr++;
 			continue;
+		}
 
 		expected_csum = rbio->csum_buf + total_sector_nr * fs_info->csum_size;
 		btrfs_calculate_block_csum_pages(fs_info, paddrs, csum_buf);
-- 
2.53.0



