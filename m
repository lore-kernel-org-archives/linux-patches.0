Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211613;
	b=4XntWjWx1jNdcITCtGjCk8KKWEw1NQufl/r1cQYfHp9Epw5Xvrntrpjjb3JFWb5XhEIE
	 jv8AC6vB+A2gK6UTMSR3L0/YhkYXpcmiphhybIVdGAr5QKKK2cVpc8b6QxKqpDnwaBTAR
	 /rbuRQFvpdk39HdkC+I6perYikOFqRFDVbV6zw8rgkG0iaNMn2h1MNJXQ5Jb/FDAoyMVe
	 /oBvZeA7Qlygu+TtpEanEy4SjSgDyBYstAgUPlKIkHMyd3hFWYgJOTTTpJ8RJASdYjPO4
	 N1D8ceiGEaz2svhA8gYThpMkdHTaD54k61KZQmf2lflZFxMQ5nBdE1oeNbWb3RhCdPw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211613;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OyY7396BhfFHlbo5OwBXgQDqPba0Gfxvusk2gk1gw8E=;
	b=LwlHdBknQm4oy7p38ByNJhPiThYsiK8brquRIdDj+WosI7H+mP7jTH38sdY7zO0WUw9X
	 NkhgMthVdUP5Oy2q4IcJ8XN810X+T60yu2XfgIEZ1YwuEh9SoQnwBIf+0tLLL+vJLbj7E
	 K2QaQqLsqAVW5mNcohM2zWWskVQQN7hmfV0JOFjwfJJYv6I1IcEUYjeajTrtIkoz+R5w7
	 c0AR7ivRMFYEJc7VDq4zqGHex2RT6jDd9Bh82qQJlwp5FFvV4uFmbEJa06WjSY/UWPInt
	 3mogZYCUb8r4hJ2y9wv3kTYQFUGnDZsM+MKzZfgGlnLzuULPPf/A/5JNgXKP2TjheHw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MEf2tg1F;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0AD8606A31A;
	Wed, 28 Oct 2026 18:20:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MEf2tg1F
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D8531F01825;
	Wed, 28 Oct 2026 18:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211612;
	bh=OyY7396BhfFHlbo5OwBXgQDqPba0Gfxvusk2gk1gw8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MEf2tg1FTHpzR8tLKxNC3ElxpiVCLxVNH+AErPosjOvSzNg9OG4eOKNmfFH8iy+wd
	 rXIbl1I/kPzrj/8X8xOoMkY0PQJUSOGlEQe7Tk2Vnbuxald28MjFTkMp7j3LD08H3V
	 bfMZKNGMkILsbil3N0p9OIkZYv/UQKbx6QCR/faw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	syzbot+bdff1ecf726d2af66afd@syzkaller.appspotmail.com,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 439/571] dm: fix reading free memory in do_resume
Date: Wed, 28 Oct 2026 17:59:46 +0100
Message-ID: <20261028170018.438543329@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 2c1e6eb93b787..816b9527394cd 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -1151,6 +1151,7 @@ static int do_resume(struct dm_ioctl *param)
 	/* Do we need to load a new map ? */
 	if (new_map) {
 		sector_t old_size, new_size;
+		fmode_t new_map_mode;
 
 		/* Suspend if it isn't already suspended */
 		if (param->flags & DM_SKIP_LOCKFS_FLAG)
@@ -1178,6 +1179,7 @@ static int do_resume(struct dm_ioctl *param)
 			}
 		}
 
+		new_map_mode = dm_table_get_mode(new_map);
 		old_size = dm_get_size(md);
 		old_map = dm_swap_table(md, new_map);
 		if (IS_ERR(old_map)) {
@@ -1190,7 +1192,7 @@ static int do_resume(struct dm_ioctl *param)
 		if (old_size && new_size && old_size != new_size)
 			need_resize_uevent = true;
 
-		if (dm_table_get_mode(new_map) & FMODE_WRITE)
+		if (new_map_mode & FMODE_WRITE)
 			set_disk_ro(dm_disk(md), 0);
 		else
 			set_disk_ro(dm_disk(md), 1);
-- 
2.53.0



