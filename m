Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D39B171AE
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:47:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 861ECC433EF;
	Mon,  8 May 2023 11:47:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683546430;
	bh=gnh51rM4XlGOdfY7oZ5VCvbkBX9kiXdjdcFIvgmajLA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iHKZh79KkXhYrQx9QD+U73nfkJa7caq5ws8wSUmYyD+QeJC51GoBDI+POrzN9K5f1
	 dVZeGz7rVeUDehHHOByh6yUYlb+IGU+lZ1MnyWQdVX1kPoBtuSdx1LnSM14ziQqH5w
	 DTVej4ebgxnx7+USl8W3u+eY5sI8XgmBoVdHHLms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Lingfeng <lilingfeng3@huawei.com>,
	Mike Snitzer <snitzer@kernel.org>
Subject: [PATCH 5.15 366/371] dm: dont lock fs when the map is NULL in process of resume
Date: Mon,  8 May 2023 11:49:27 +0200
Message-Id: <20230508094826.601711292@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094811.912279944@linuxfoundation.org>
References: <20230508094811.912279944@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Li Lingfeng <lilingfeng3@huawei.com>

commit 38d11da522aacaa05898c734a1cec86f1e611129 upstream.

Commit fa247089de99 ("dm: requeue IO if mapping table not yet available")
added a detection of whether the mapping table is available in the IO
submission process. If the mapping table is unavailable, it returns
BLK_STS_RESOURCE and requeues the IO.
This can lead to the following deadlock problem:

dm create                                      mount
ioctl(DM_DEV_CREATE_CMD)
ioctl(DM_TABLE_LOAD_CMD)
                               do_mount
                                vfs_get_tree
                                 ext4_get_tree
                                  get_tree_bdev
                                   sget_fc
                                    alloc_super
                                     // got &s->s_umount
                                     down_write_nested(&s->s_umount, ...);
                                   ext4_fill_super
                                    ext4_load_super
                                     ext4_read_bh
                                      submit_bio
                                      // submit and wait io end
ioctl(DM_DEV_SUSPEND_CMD)
dev_suspend
 do_resume
  dm_suspend
   __dm_suspend
    lock_fs
     freeze_bdev
      get_active_super
       grab_super
        // wait for &s->s_umount
        down_write(&s->s_umount);
  dm_swap_table
   __bind
    // set md->map(can't get here)

IO will be continuously requeued while holding the lock since mapping
table is NULL. At the same time, mapping table won't be set since the
lock is not available.
Like request-based DM, bio-based DM also has the same problem.

It's not proper to just abort IO if the mapping table not available.
So clear DM_SKIP_LOCKFS_FLAG when the mapping table is NULL, this
allows the DM table to be loaded and the IO submitted upon resume.

Fixes: fa247089de99 ("dm: requeue IO if mapping table not yet available")
Cc: stable@vger.kernel.org
Signed-off-by: Li Lingfeng <lilingfeng3@huawei.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-ioctl.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -1145,10 +1145,13 @@ static int do_resume(struct dm_ioctl *pa
 	/* Do we need to load a new map ? */
 	if (new_map) {
 		sector_t old_size, new_size;
+		int srcu_idx;
 
 		/* Suspend if it isn't already suspended */
-		if (param->flags & DM_SKIP_LOCKFS_FLAG)
+		old_map = dm_get_live_table(md, &srcu_idx);
+		if ((param->flags & DM_SKIP_LOCKFS_FLAG) || !old_map)
 			suspend_flags &= ~DM_SUSPEND_LOCKFS_FLAG;
+		dm_put_live_table(md, srcu_idx);
 		if (param->flags & DM_NOFLUSH_FLAG)
 			suspend_flags |= DM_SUSPEND_NOFLUSH_FLAG;
 		if (!dm_suspended_md(md))


