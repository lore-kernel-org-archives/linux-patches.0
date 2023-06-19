Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 252A710952
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 10:32:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AA95C433C0;
	Mon, 19 Jun 2023 10:32:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687170758;
	bh=M73FQpmA3uOSySWRcaeDWBSQvLIHC25woMxh3JVMDuQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k4fnEZ2ww+z4+Xl6vV7tBPop3sbGYQUrGt63SoZ8lgNMbf2c23kn4582nVx4XyMC3
	 de7HjhGQO98Xfwt9N3b8VG/yCg51So5vS6fep2T+WoDtPznfEn6Il4lj/cV+xLx+3X
	 zjLXmTVzu2Jrbi7bu2u8aMzKrP8tkR+L/2OpfF/s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+d8941552e21eac774778@syzkaller.appspotmail.com,
	Christoph Hellwig <hch@lst.de>,
	Anand Jain <anand.jain@oracle.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 025/187] btrfs: handle memory allocation failure in btrfs_csum_one_bio
Date: Mon, 19 Jun 2023 12:27:23 +0200
Message-ID: <20230619102158.867927043@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102157.579823843@linuxfoundation.org>
References: <20230619102157.579823843@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Johannes Thumshirn <johannes.thumshirn@wdc.com>

[ Upstream commit 806570c0bb7b4847828c22c4934fcf2dc8fc572f ]

Since f8a53bb58ec7 ("btrfs: handle checksum generation in the storage
layer") the failures of btrfs_csum_one_bio() are handled via
bio_end_io().

This means, we can return BLK_STS_RESOURCE from btrfs_csum_one_bio() in
case the allocation of the ordered sums fails.

This also fixes a syzkaller report, where injecting a failure into the
kvzalloc() call results in a BUG_ON().

Reported-by: syzbot+d8941552e21eac774778@syzkaller.appspotmail.com
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/file-item.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index a4584c629ba35..9e45b416a9c85 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -847,7 +847,9 @@ blk_status_t btrfs_csum_one_bio(struct btrfs_bio *bbio)
 				sums = kvzalloc(btrfs_ordered_sum_size(fs_info,
 						      bytes_left), GFP_KERNEL);
 				memalloc_nofs_restore(nofs_flag);
-				BUG_ON(!sums); /* -ENOMEM */
+				if (!sums)
+					return BLK_STS_RESOURCE;
+
 				sums->len = bytes_left;
 				ordered = btrfs_lookup_ordered_extent(inode,
 								offset);
-- 
2.39.2



