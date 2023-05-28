Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41D8A569D
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:24:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C28FEC433EF;
	Sun, 28 May 2023 19:24:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685301844;
	bh=zz1nvhRiLPDtmIiUqufzvIRc4ykRAAo48v+2hT5jpXI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uwND67k1x10OCJ486RdJ4hAO+kENoqTdHHI3x/LQzXD7RdNsIhqyXB1SIJfE+Zf32
	 yx38MT3GhxzSfDEh6WhWON/jrmBnG/Saz5TuxKB8ngMhGu6i2SAjtb8Rlt+cnh3Bfy
	 gV+fd4XAMCQSv21LF6aQMrAjc/ZTncxvInVuz42g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anand Jain <anand.jain@oracle.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 058/161] btrfs: fix space cache inconsistency after error loading it from disk
Date: Sun, 28 May 2023 20:09:42 +0100
Message-Id: <20230528190839.035451920@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190837.051205996@linuxfoundation.org>
References: <20230528190837.051205996@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit 0004ff15ea26015a0a3a6182dca3b9d1df32e2b7 ]

When loading a free space cache from disk, at __load_free_space_cache(),
if we fail to insert a bitmap entry, we still increment the number of
total bitmaps in the btrfs_free_space_ctl structure, which is incorrect
since we failed to add the bitmap entry. On error we then empty the
cache by calling __btrfs_remove_free_space_cache(), which will result
in getting the total bitmaps counter set to 1.

A failure to load a free space cache is not critical, so if a failure
happens we just rebuild the cache by scanning the extent tree, which
happens at block-group.c:caching_thread(). Yet the failure will result
in having the total bitmaps of the btrfs_free_space_ctl always bigger
by 1 then the number of bitmap entries we have. So fix this by having
the total bitmaps counter be incremented only if we successfully added
the bitmap entry.

Fixes: a67509c30079 ("Btrfs: add a io_ctl struct and helpers for dealing with the space cache")
Reviewed-by: Anand Jain <anand.jain@oracle.com>
CC: stable@vger.kernel.org # 4.4+
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/free-space-cache.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index d2d32fed8f2e9..0cb93f73acb2d 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -784,15 +784,16 @@ static int __load_free_space_cache(struct btrfs_root *root, struct inode *inode,
 			}
 			spin_lock(&ctl->tree_lock);
 			ret = link_free_space(ctl, e);
-			ctl->total_bitmaps++;
-			ctl->op->recalc_thresholds(ctl);
-			spin_unlock(&ctl->tree_lock);
 			if (ret) {
+				spin_unlock(&ctl->tree_lock);
 				btrfs_err(fs_info,
 					"Duplicate entries in free space cache, dumping");
 				kmem_cache_free(btrfs_free_space_cachep, e);
 				goto free_cache;
 			}
+			ctl->total_bitmaps++;
+			ctl->op->recalc_thresholds(ctl);
+			spin_unlock(&ctl->tree_lock);
 			list_add_tail(&e->list, &bitmaps);
 		}
 
-- 
2.39.2



