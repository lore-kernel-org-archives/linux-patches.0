Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69CD46FA1
	for <patches@lists.linux.dev>; Mon,  3 Apr 2023 14:37:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E83B7C433EF;
	Mon,  3 Apr 2023 14:37:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680532649;
	bh=dKK7me93NdmO3kdN+HDcxBkLdlf2m4+RfRS8oXYOyvg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GGBzAHxyG9SwWvrEKNLjDL6lmPQX7PtXikkx5Xv7Tsgq7l7TXcoLec3RcDCgg8hGs
	 abmEKnb5jSs9x3opmpd5ewdRkMOYxbI7tsbhzlyM4ul0F6tDKX0RqOPmNbLPVQ4NYX
	 yGQKg/GoFChFnm13HkUVyjjfb3M2Nj2Y1321ZOgY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Josef Bacik <josef@toxicpanda.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 064/181] btrfs: fix uninitialized variable warning in btrfs_update_block_group
Date: Mon,  3 Apr 2023 16:08:19 +0200
Message-Id: <20230403140417.220943590@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140415.090615502@linuxfoundation.org>
References: <20230403140415.090615502@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit efbf35a102b20246cfe4409c6ae92e72ecb67ab8 ]

reclaim isn't set in the alloc case, however we only care about
reclaim in the !alloc case.  This isn't an actual problem, however
-Wmaybe-uninitialized will complain, so initialize reclaim to quiet the
compiler.

Reviewed-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: df384da5a49c ("btrfs: use temporary variable for space_info in btrfs_update_block_group")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/block-group.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index 4b69945755e4f..380cb10f0d37b 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -3259,7 +3259,7 @@ int btrfs_update_block_group(struct btrfs_trans_handle *trans,
 	spin_unlock(&info->delalloc_root_lock);
 
 	while (total) {
-		bool reclaim;
+		bool reclaim = false;
 
 		cache = btrfs_lookup_block_group(info, bytenr);
 		if (!cache) {
-- 
2.39.2



