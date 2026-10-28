Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213555;
	b=gtYIZ5ez1fNqhGcuK6fiE7gpsR9yVbs9tJcybUZPdaUqO+alJiMD/AU/ijo0RO9jRpFU
	 nL0EU0ORd/9yVLtcmlzLAlCnMnfJVu8RXriwW33XNrvlRM4lYlI1Itq7WStGn2JLgQMwU
	 Ps/JOcoiSs1cvIChyBa71JGmOt7HoWiXEKQ5i+sgWR70vW5FruYxDv4uFOPkj6fWaEGG8
	 JsK4oD/staJMgFldTB9hHmAGWvoHJq1/hT84odR22Xqzm1l8EZEG0xoBWDN+19ec0qWYU
	 c16x3AwL9cWrXC0yF4I5sNhZkC+EILJL/7SQmMppCNds769YX63Rp/2+BiL3bZMjDPA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213555;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ekkkkqZQTj5W7/MgqugwREYDIOXLrcpsJOCyNO00/pQ=;
	b=39fxUr3x/pBmJm9+22udQGHf4uugqvlYcinvUVtuQ1ilyHzO0vlgZYQ9oqml/C/IVgEw
	 GZ3y52pUGnHLAWeIyEtaub6lmWK4UaplEPfbJuclZehlDdwenr5OYlKCn/5ZALI8WAvdx
	 424quDYfCCJu9fncuDpTR5p7iH4WmSrAWqeTYQXK8kN5rAjkZfBTp1JGYizQgRdK56krD
	 jDVs6FR2TeE55K1ZtZP5pO9iy9YMKG4j8IDHSjey2tok4DxjxIM8oGWr7d3iTJrlYXcRK
	 uoYlgSmJtrZVe09FE0jWoKpDK3kVr+maNkjcang25MMIn9iTOhhv4TMbm5wLmj0sCtw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RNWYNE9O;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 107A8606A320;
	Wed, 28 Oct 2026 18:52:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RNWYNE9O
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F2191F01828;
	Wed, 28 Oct 2026 18:52:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213554;
	bh=ekkkkqZQTj5W7/MgqugwREYDIOXLrcpsJOCyNO00/pQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RNWYNE9ObgLrK7n5O5yDoR8Wh1A0NSomL3SkQnMzj21G6jbhMn4vCSX6eqZBKcSVS
	 P1nWps3OvXzQdl8QDDRRn4XmF4ETmsNbXorlTD4PMRAqfVEj6JDJsCNOo2Jft0niUQ
	 kxAt9C+9N9BoQb8jJEZIlFub8j8jbdoCxbNvViUg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	syzbot+bdff1ecf726d2af66afd@syzkaller.appspotmail.com,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0530/1887] dm: fix reading free memory in do_resume
Date: Wed, 28 Oct 2026 17:43:46 +0100
Message-ID: <20261028170511.400852675@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

[ Upstream commit c9417c1c5269e2bd0570fbe53e4ec03a8d31f008 ]

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
[ sashal: Replaced blk_mode_t and BLK_OPEN_WRITE with fmode_t and FMODE_WRITE. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-ioctl.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index 4cfdd50e32d70..57d0bc1545b73 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -1166,6 +1166,7 @@ static int do_resume(struct dm_ioctl *param)
 	/* Do we need to load a new map ? */
 	if (new_map) {
 		sector_t old_size, new_size;
+		fmode_t new_map_mode;
 
 		/* Suspend if it isn't already suspended */
 		if (param->flags & DM_SKIP_LOCKFS_FLAG)
@@ -1193,6 +1194,7 @@ static int do_resume(struct dm_ioctl *param)
 			}
 		}
 
+		new_map_mode = dm_table_get_mode(new_map);
 		old_size = dm_get_size(md);
 		old_map = dm_swap_table(md, new_map);
 		if (IS_ERR(old_map)) {
@@ -1205,7 +1207,7 @@ static int do_resume(struct dm_ioctl *param)
 		if (old_size && new_size && old_size != new_size)
 			need_resize_uevent = true;
 
-		if (dm_table_get_mode(new_map) & FMODE_WRITE)
+		if (new_map_mode & FMODE_WRITE)
 			set_disk_ro(dm_disk(md), 0);
 		else
 			set_disk_ro(dm_disk(md), 1);
-- 
2.53.0



