Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27FA94F96D9;
	Thu, 17 Sep 2026 17:59:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667944; cv=none; b=a4Hm3MgmZKPiGJuH5NdAfsVgoy/X7XQ1seR3aCs+cZzpNuVGUTzqxth4t/nhBuO9uzI3tkLNmwsFCS5tDgDSBRY3IRbT78sL5C5fHGW9fqHrGE/sgYOkpJR3TZVif7pBRT5kQ+x+ENZfT7YPzzHKO6/k7xQO8RoQaVvR3kDAxEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667944; c=relaxed/simple;
	bh=n6/GK5Cp6VDVaZy92+QfYhFz2K38VuT/CAi/QeE951U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tcLILPyf/N3Zbse8hL3yXdcplf7hK6wUJkUYRMIKcAY1Pf5koxH9Sp8cRUCTOGpNxl4YFfPb5LWJl8suawi7j2J+XpxEyJvksgHWXv4U5I/L8Cv32cbuNKVuhCIr++Dgd/XdBjIcH9ZC9c5lYJVgrHoho2N29aXxrZfTyTcFKMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ccWzASTE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ccWzASTE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACB251F000FF;
	Thu, 17 Sep 2026 17:59:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667943;
	bh=wBk0FeZb0LTGtoXSqfJ7scfV8h66k8bsuSw1Y8vD2eQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ccWzASTE8DFYEjYjswtVflWHpCe6N438o/RNABgwEkOn+mAw54c3RHwB3Vi568pBR
	 ubgN8bifwO1CxWM4vp8OlCryL0Bs5cpLyCjbOMVlFu5biL9/epPF7AVN+P4+G5oja9
	 g8h0mAhgOTYrCzNFDxLqSUA0nRc/tyoIy9G9WzC4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	KangNing Liao <lkangn.kernel@gmail.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0262/1102] btrfs: protect sb_write_pointer() with invalidate lock
Date: Thu, 17 Sep 2026 16:03:25 +0100
Message-ID: <20260917151546.177092626@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: KangNing Liao <lkangn.kernel@gmail.com>

[ Upstream commit 123b9a545f4d0348e81f558a032bf2a93ee5722f ]

sb_write_pointer() reads the super block from the block device page cache
using read_cache_page_gfp(). This has the same race with BLKBSZSET as the
one fixed by commit 3f29d661e568 ("btrfs: sync read disk super and set
block size").

Take the mapping invalidate lock around read_cache_page_gfp() to
serialize the read against block size changes.

Signed-off-by: KangNing Liao <lkangn.kernel@gmail.com>
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/zoned.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 46a792e113ee4..df7d75ef7ae3e 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -126,8 +126,10 @@ static int sb_write_pointer(struct block_device *bdev, struct blk_zone *zones,
 			u64 bytenr = ALIGN_DOWN(zone_end, BTRFS_SUPER_INFO_SIZE) -
 						BTRFS_SUPER_INFO_SIZE;
 
+			filemap_invalidate_lock(mapping);
 			page[i] = read_cache_page_gfp(mapping,
 					bytenr >> PAGE_SHIFT, GFP_NOFS);
+			filemap_invalidate_unlock(mapping);
 			if (IS_ERR(page[i])) {
 				if (i == 1)
 					btrfs_release_disk_super(super[0]);
-- 
2.53.0



