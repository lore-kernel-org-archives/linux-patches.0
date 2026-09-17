Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC02D4D17B4;
	Thu, 17 Sep 2026 17:44:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667101; cv=none; b=M7lQl3AMCUJ/u71VNLZ5Z/kSBpsbN+MZCmR2VDMtIMdobvyxMCgSgz/KnpuDbGDDwUixTH+eRr+vWGjSHDok9B00kHRiVeyYflPPfe96xxbl8tNDo0ikB6SjZZSunsag+I7q5yBqfJL9lNphF+linZhd91nt+lynzR/VEc0jMdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667101; c=relaxed/simple;
	bh=IrCF7UoxhtAOP5OaS8ieXKsfE74y+ZsU6gor5dPohh0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fc5BVzYye9zXUELa5UNb5TK80U0pT8p+5pv4zBZcMWUvjUn8+ssLUQv5EGi5vzJ9NUK4mLe0m7qWADt+jEgH6VgL7j6OeQWUQXOXzKeRmQushTJ5QBitbkUG/qCVo7hSGKVEgdbkLmlVBokgJOERrWzc6ZkYj9FPHRUfuJ1Whf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HFEO1G5A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HFEO1G5A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 263EA1F000FF;
	Thu, 17 Sep 2026 17:44:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667098;
	bh=v930BBUkfWnKib1Pzag/KoLKK6epMyogXL/X74vbr4U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HFEO1G5AeJmUeasLWYsfyqfg2UzYePbcytHePt4HUJp59bai3v6gCPUBGQdH8FKB0
	 z2ZPujhvqsOZrnMiJ6HPQr68tmRDsmY96pPdpYlko2E6JEks2bt9gNXqyVc5oyAp/U
	 nlRR0VdzG5x2zY/6EmkJ3FZkENLlUqQboMsmfK1A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+6b16e3d085833cbf3e25@syzkaller.appspotmail.com,
	Vasileios Almpanis <vasilisalmpanis@gmail.com>,
	Breno Leitao <leitao@debian.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1191/1250] configfs: unhash the dentry before dropping the item in rmdir
Date: Thu, 17 Sep 2026 16:16:26 +0100
Message-ID: <20260917151624.565288884@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Vasileios Almpanis <vasilisalmpanis@gmail.com>

[ Upstream commit f06c2d26d1999d37e93299db0ecead04ca7d0b9f ]

configfs_get_config_item() treats a hashed dentry as proof that
sd->s_element is a live config_item.  configfs_rmdir() breaks that:
simple_rmdir() leaves the dentry hashed, the last reference to the item is
dropped right after, and the dentry is only unhashed by d_delete() once
->rmdir() has returned.  configfs_symlink() resolves its target holding no
lock on it, so get_target() can land in that window:

  BUG: KASAN: slab-use-after-free in config_item_get+0x26/0x90
   get_target fs/configfs/symlink.c:128 [inline]
   configfs_symlink+0x4ab/0x1030 fs/configfs/symlink.c:185

Unhash in configfs_remove_dir(), while the item is still guaranteed to be
there.  A reference obtained just before that stays harmless, as
create_link() rechecks CONFIGFS_USET_DROPPING, already set by
configfs_detach_prep().  Both configfs_unregister_subsystem() paths
d_drop() after detaching, so this only makes rmdir match them.

Reported-by: syzbot+6b16e3d085833cbf3e25@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=6b16e3d085833cbf3e25
Fixes: 7063fbf22611 ("[PATCH] configfs: User-driven configuration filesystem")
Cc: stable@vger.kernel.org
Signed-off-by: Vasileios Almpanis <vasilisalmpanis@gmail.com>
Tested-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Breno Leitao <leitao@debian.org>
Link: https://patch.msgid.link/20260730093435.195441-3-vasilisalmpanis@gmail.com
Signed-off-by: Breno Leitao <leitao@debian.org>
[ adapted the configfs_remove_dir() change to the older remove_dir() helper. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/configfs/dir.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/fs/configfs/dir.c
+++ b/fs/configfs/dir.c
@@ -401,8 +401,17 @@ static void remove_dir(struct dentry * d
 
 	configfs_remove_dirent(d);
 
-	if (d_really_is_positive(d))
-		simple_rmdir(d_inode(parent),d);
+	if (d_really_is_positive(d)) {
+		if (!simple_rmdir(d_inode(parent), d))
+			/*
+			 * configfs_get_config_item() takes a hashed dentry as
+			 * proof that ->s_element is still alive.  Our caller
+			 * is about to drop the last reference to the item and
+			 * the VFS will not unhash until after we return, so
+			 * unhash it here.
+			 */
+			d_drop(d);
+	}
 
 	pr_debug(" o %pd removing done (%d)\n", d, d_count(d));
 


