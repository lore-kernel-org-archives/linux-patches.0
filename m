Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45D4F12B98
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:04:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9F54C433C7;
	Tue, 25 Jul 2023 11:04:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690283072;
	bh=FQYJiP4xc7/v7gSSGSYZZ3EHFQlZc5QvnamO3NppU0k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=csewitu8ap8Pps0tik/Cf3586Zkp3Dlz9aCQ4KrqErYcgXA3mZahAbgt5WNlJE/t4
	 9mHmr9KW9gwBvFjiRt6HfExfdUne1lWcTlasLHINIFI2oGXoi5/xkDV0Sf0Et8JkvJ
	 zr79diWN+eSg74ozBqvpTnIrgPa19ycFqV5kXaOo=
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
Subject: [PATCH 6.1 099/183] btrfs: be a bit more careful when setting mirror_num_ret in btrfs_map_block
Date: Tue, 25 Jul 2023 12:45:27 +0200
Message-ID: <20230725104511.516754140@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104507.756981058@linuxfoundation.org>
References: <20230725104507.756981058@linuxfoundation.org>
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
 fs/btrfs/volumes.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 7433ae929fdcb..2e0832d70406c 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -6595,11 +6595,13 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info,
 		if (patch_the_first_stripe_for_dev_replace) {
 			smap->dev = dev_replace->tgtdev;
 			smap->physical = physical_to_patch_in_first_stripe;
-			*mirror_num_ret = map->num_stripes + 1;
+			if (mirror_num_ret)
+				*mirror_num_ret = map->num_stripes + 1;
 		} else {
 			set_io_stripe(smap, map, stripe_index, stripe_offset,
 				      stripe_nr);
-			*mirror_num_ret = mirror_num;
+			if (mirror_num_ret)
+				*mirror_num_ret = mirror_num;
 		}
 		*bioc_ret = NULL;
 		ret = 0;
-- 
2.39.2



