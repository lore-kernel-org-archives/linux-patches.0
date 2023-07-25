Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5787E9440
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 10:54:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C16FCC433CB;
	Tue, 25 Jul 2023 10:54:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690282488;
	bh=91kO4EreMg/x+kX2tpwgLs/gDIdK1ewyrRd48WO7r5I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VY3tKghZrjfQdMyfxnNSS1jAlV/r4k3f9zM4H9yk+fCZLIYu0oQkhrsX25qQ6CFtO
	 tJ21WlI5mubv49yZwg/Sz5xzqpnlol64ol/7Jv7J4xb+Nqcx15XGAMI1aX59mVap1U
	 Ir2He1YfbT815U8NYa7KuNOYdv5+i/fzxDq8LDq4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Qu Wenruo <wqu@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Christoph Hellwig <hch@lst.de>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 147/227] btrfs: be a bit more careful when setting mirror_num_ret in btrfs_map_block
Date: Tue, 25 Jul 2023 12:45:14 +0200
Message-ID: <20230725104520.967153011@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104514.821564989@linuxfoundation.org>
References: <20230725104514.821564989@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 4e7de35eb7d1a1d4f2dda15f39fbedd4798a0b8d ]

The mirror_num_ret is allowed to be NULL, although it has to be set when
smap is set.  Unfortunately that is not a well enough specifiable
invariant for static type checkers, so add a NULL check to make sure they
are fine.

Fixes: 03793cbbc80f ("btrfs: add fast path for single device io in __btrfs_map_block")
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/volumes.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 5ec000813f047..436e15e3759da 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -6399,7 +6399,8 @@ int __btrfs_map_block(struct btrfs_fs_info *fs_info, enum btrfs_map_op op,
 	    (!need_full_stripe(op) || !dev_replace_is_ongoing ||
 	     !dev_replace->tgtdev)) {
 		set_io_stripe(smap, map, stripe_index, stripe_offset, stripe_nr);
-		*mirror_num_ret = mirror_num;
+		if (mirror_num_ret)
+			*mirror_num_ret = mirror_num;
 		*bioc_ret = NULL;
 		ret = 0;
 		goto out;
-- 
2.39.2



