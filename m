Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D40420F88
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 19:08:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91DC7C433C7;
	Fri, 21 Jul 2023 19:08:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689966499;
	bh=e4oizSaJ7jiN3cP57f4spJYsSWWI6MY52EER6wwRUlA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XYZB/WnXlQBr98YFy4RvwLaZdQ8XJPNVcajrSz2pSV9G752MvVlA8UVdWz0bppytB
	 lOfeDyZ2EK6HFyMARlcZZzdMj0Dx2kMfxg7kaARbfRCwhSn/AMphWOpL1U7X8jzPy3
	 ZF9PPhPgO+uBAVfCvwjgnjUHJohpBmiRxRccuJ3w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 5.15 365/532] btrfs: delete unused BGs while reclaiming BGs
Date: Fri, 21 Jul 2023 18:04:29 +0200
Message-ID: <20230721160634.259580414@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160614.695323302@linuxfoundation.org>
References: <20230721160614.695323302@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Naohiro Aota <naota@elisp.net>

commit 3ed01616bad6c7e3de196676b542ae3df8058592 upstream.

The reclaiming process only starts after the filesystem volumes are
allocated to a certain level (75% by default). Thus, the list of
reclaiming target block groups can build up so huge at the time the
reclaim process kicks in. On a test run, there were over 1000 BGs in the
reclaim list.

As the reclaim involves rewriting the data, it takes really long time to
reclaim the BGs. While the reclaim is running, btrfs_delete_unused_bgs()
won't proceed because the reclaim side is holding
fs_info->reclaim_bgs_lock. As a result, we will have a large number of
unused BGs kept in the unused list. On my test run, I got 1057 unused BGs.

Since deleting a block group is relatively easy and fast work, we can call
btrfs_delete_unused_bgs() while it reclaims BGs, to avoid building up
unused BGs.

Fixes: 18bb8bbf13c1 ("btrfs: zoned: automatically reclaim zones")
CC: stable@vger.kernel.org # 5.15+
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/block-group.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -1574,10 +1574,24 @@ void btrfs_reclaim_bgs_work(struct work_
 
 next:
 		btrfs_put_block_group(bg);
+
+		mutex_unlock(&fs_info->reclaim_bgs_lock);
+		/*
+		 * Reclaiming all the block groups in the list can take really
+		 * long.  Prioritize cleaning up unused block groups.
+		 */
+		btrfs_delete_unused_bgs(fs_info);
+		/*
+		 * If we are interrupted by a balance, we can just bail out. The
+		 * cleaner thread restart again if necessary.
+		 */
+		if (!mutex_trylock(&fs_info->reclaim_bgs_lock))
+			goto end;
 		spin_lock(&fs_info->unused_bgs_lock);
 	}
 	spin_unlock(&fs_info->unused_bgs_lock);
 	mutex_unlock(&fs_info->reclaim_bgs_lock);
+end:
 	btrfs_exclop_finish(fs_info);
 	sb_end_write(fs_info->sb);
 }


