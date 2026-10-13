Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 186024F3937;
	Tue, 13 Oct 2026 12:02:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892977; cv=none; b=pX60EPsmkebB3H63wMEwbtFWz9o2T+podeolJIw1oEmq4sjWln8edt3JuphNSWt1+EZmsqnN6e7aqJXi5+39QADFm7Dv7fFrBdWDGBIW8WptsKvUCHTV3gMFlqd2gJenRmhjX7eE3J7A/rDrtpwXqXg1Yk1n8N7770KvyqbZZxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892977; c=relaxed/simple;
	bh=WxXEtU/o9lu7MHp8TLQJX1uJR9vCnbEQtuNrDIVuHBs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dPuLl986hSCohHdpBYgOVcBIllCU4QopaU2XFLfjhOnjljwVn8LQaUM7km6f4EvRcxQGoJXZqKAxlotdPPA6BX/goVkIaHmFDtI6qSmZm/WcnCZsG9opfYebzvrcM8TSvtyCid6tKhe4acgc51RO1CtgOHtyAbMvhmhx04bhXgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kicoHltn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kicoHltn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 729431F00893;
	Tue, 13 Oct 2026 12:02:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892976;
	bh=gGIquCABGNHp9GTDeFUGA48LIYTBF3nA9z+Si/5c7fs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kicoHltnh3Lw/QcuqeQIX40vB5KD0NbIFOO4Lffo953eFS87f4eYtx7eXtXRE/Pu1
	 pRfpCjXbREb7YNbooLVQoWMfg9N0O64pOZ7TsDM/QXPYWkIrkWP16mCvucWummQC9K
	 dKPgvzpklbm+xSp2sqs6tEIY2aK6j9OA8jLloMqc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	syzbot+bdff1ecf726d2af66afd@syzkaller.appspotmail.com
Subject: [PATCH 6.18 072/621] dm: fix reading free memory in do_resume
Date: Tue, 13 Oct 2026 13:31:07 +0200
Message-ID: <20261013112922.564635986@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit c9417c1c5269e2bd0570fbe53e4ec03a8d31f008 upstream.

When do_resume calls dm_table_get_mode(new_map), the call is done without
holding any locks (it only holds a reference to the md). It may be
possible that another concurrent ioctl on the same device will swap table
after dm_swap_table and before dm_table_get_mode. In this case,
dm_table_get_mode(new_map) reads freed memory.

This race condition was triggered by syzbot.

This commit fixes the race by reading mode of the new table before
dm_swap_table. Note that new_map is also passed to dm_ima_need_measure,
but this function doesn't attempt to dereference it, so this call should
be safe.

Note that this is not a security bug because only root can trigger it and
the commonly used tools such as lvm or cryptsetup do not call the ioctls
concurrently, so that they can't trigger it acceidentally.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Reported-by: syzbot+bdff1ecf726d2af66afd@syzkaller.appspotmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-ioctl.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -1181,6 +1181,7 @@ static int do_resume(struct dm_ioctl *pa
 	/* Do we need to load a new map ? */
 	if (new_map) {
 		sector_t old_size, new_size;
+		blk_mode_t new_map_mode;
 
 		/* Suspend if it isn't already suspended */
 		if (param->flags & DM_SKIP_LOCKFS_FLAG)
@@ -1208,6 +1209,7 @@ static int do_resume(struct dm_ioctl *pa
 			}
 		}
 
+		new_map_mode = dm_table_get_mode(new_map);
 		old_size = dm_get_size(md);
 		old_map = dm_swap_table(md, new_map);
 		if (IS_ERR(old_map)) {
@@ -1220,7 +1222,7 @@ static int do_resume(struct dm_ioctl *pa
 		if (old_size && new_size && old_size != new_size)
 			need_resize_uevent = true;
 
-		if (dm_table_get_mode(new_map) & BLK_OPEN_WRITE)
+		if (new_map_mode & BLK_OPEN_WRITE)
 			set_disk_ro(dm_disk(md), 0);
 		else
 			set_disk_ro(dm_disk(md), 1);


