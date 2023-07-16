Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E20FE8F5B
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:29:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64336C433C8;
	Sun, 16 Jul 2023 20:29:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689539388;
	bh=wbEZtwdWHqx5xgWeWII5/O5YXKUu1XO/zuxWdnQenUc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WdQoY7IjHUl2Lo2AnUWzA4Pumo2aQHq/yxblzRu24p5j8JN21w7nwKfgErENwHmoS
	 Y2S1QH4wRq2Qv/kW34BG0ndF8C7THxcWR2oD95BETKzL8H9fM/XpjNcEuwvhgo1biV
	 f605Qy7f65+TTMm8SopbtPZLNljh88xmeojUTrfQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.4 761/800] btrfs: move out now unused BG from the reclaim list
Date: Sun, 16 Jul 2023 21:50:14 +0200
Message-ID: <20230716195006.821258858@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
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

commit a9f189716cf15913c453299d72f69c51a9b0f86b upstream.

An unused block group is easy to remove to free up space and should be
reclaimed fast. Such block group can often already be a target of the
reclaim process. As we check list_empty(&bg->bg_list), we keep it in the
reclaim list. That block group is never reclaimed until the file system
is filled e.g. up to 75%.

Instead, we can move unused block group to the unused list and delete it
fast.

Fixes: 18bb8bbf13c1 ("btrfs: zoned: automatically reclaim zones")
CC: stable@vger.kernel.org # 5.15+
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/block-group.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -1640,11 +1640,14 @@ void btrfs_mark_bg_unused(struct btrfs_b
 {
 	struct btrfs_fs_info *fs_info = bg->fs_info;
 
+	trace_btrfs_add_unused_block_group(bg);
 	spin_lock(&fs_info->unused_bgs_lock);
 	if (list_empty(&bg->bg_list)) {
 		btrfs_get_block_group(bg);
-		trace_btrfs_add_unused_block_group(bg);
 		list_add_tail(&bg->bg_list, &fs_info->unused_bgs);
+	} else {
+		/* Pull out the block group from the reclaim_bgs list. */
+		list_move_tail(&bg->bg_list, &fs_info->unused_bgs);
 	}
 	spin_unlock(&fs_info->unused_bgs_lock);
 }


