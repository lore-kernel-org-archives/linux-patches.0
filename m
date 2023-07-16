Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B6BD8F5B
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:29:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1F18C433C7;
	Sun, 16 Jul 2023 20:29:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689539380;
	bh=VO/YOcRYkB3ACK+LLsZyb4JfULKXa2+W8hqBG38ibjU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O65Nce1WldAHeP5CTaY9RxkXY0sPsnrCIBJTPGRbneu7iSwRlhncz1kE6d+VGe8xz
	 TCvT4ka29qIcGVtIfBfjfkcT5iyJYGptuqktZBog4Upxn0wuOwY60eeoBVRJ9yqb0W
	 cgvZTcgPgd4Lw1qvdtml3kTO7882h7fRabQiYr8Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.4 758/800] btrfs: bail out reclaim process if filesystem is read-only
Date: Sun, 16 Jul 2023 21:50:11 +0200
Message-ID: <20230716195006.749262755@linuxfoundation.org>
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

commit 93463ff7b54626f8276c0bd3d3f968fbf8d5d380 upstream.

When a filesystem is read-only, we cannot reclaim a block group as it
cannot rewrite the data. Just bail out in that case.

Note that it can drop block groups in this case. As we did
sb_start_write(), read-only filesystem means we got a fatal error and
forced read-only. There is no chance to reclaim them again.

Fixes: 18bb8bbf13c1 ("btrfs: zoned: automatically reclaim zones")
CC: stable@vger.kernel.org # 5.15+
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/block-group.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -1798,8 +1798,15 @@ void btrfs_reclaim_bgs_work(struct work_
 		}
 		spin_unlock(&bg->lock);
 
-		/* Get out fast, in case we're unmounting the filesystem */
-		if (btrfs_fs_closing(fs_info)) {
+		/*
+		 * Get out fast, in case we're read-only or unmounting the
+		 * filesystem. It is OK to drop block groups from the list even
+		 * for the read-only case. As we did sb_start_write(),
+		 * "mount -o remount,ro" won't happen and read-only filesystem
+		 * means it is forced read-only due to a fatal error. So, it
+		 * never gets back to read-write to let us reclaim again.
+		 */
+		if (btrfs_need_cleaner_sleep(fs_info)) {
 			up_write(&space_info->groups_sem);
 			goto next;
 		}


