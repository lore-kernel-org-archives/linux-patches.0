Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B6B0501F5E;
	Tue, 13 Oct 2026 12:49:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895792; cv=none; b=ueB++3wHEzejk7ZEJGErCJryED5zQdvdy75hduPXwoMZ0eNYP/LmfCpIxweP4PGCpexvhU1XSf/q36XgU31tR1OOKY30IrEJgu5RausTO+/UtxIR2HfFbHPZU+8ZXoBMwrLag6MqCwaXvm0ARA35eh4SSMrvRqXoUMjrd87L0JI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895792; c=relaxed/simple;
	bh=CVDQSWM5b1Vns7Eb1T3T1Y1hHWX4x0ahUFOXMsCs5FA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qJ+59/co5Ps4m82YnYhaYjKmlW5kd/QFyF/KyMhHnSKWl85NsCi5FrhZfNy0xSaBgVsTEY8dFsYvArgk+1Yi2qBx5mFNUpDOl8pgY5Py3o89eGomETUk/oAiQyMU+Cb/jXa66QfpzoDkXy5zAEtXw1/ze6zgu+qgSd4IEmJWh04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dsniTWs7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dsniTWs7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B555B1F00898;
	Tue, 13 Oct 2026 12:49:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895791;
	bh=7CGei2oBttUdPVSZsvCsZblUkCPxSt7U87CdmKYYx5o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dsniTWs7r4fQvFIDxMeamRGixsrmHsMVCD7VXNRWhr+XfhRW7vyZ8rund9G2gPhN7
	 guwhJ6uu7FY3NS1L5PKqYpEmLRZbcPHqCK1pOD0yiScrOu600t1N0dqgna07r7696o
	 w2rVFmDWL6v/Qfz8YmzCr8yyGZnfu4LbGLpRfzDg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	syzbot+bdff1ecf726d2af66afd@syzkaller.appspotmail.com
Subject: [PATCH 6.12 394/497] dm: fix reading free memory in do_resume
Date: Tue, 13 Oct 2026 13:39:21 +0200
Message-ID: <20261013112917.244868483@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


