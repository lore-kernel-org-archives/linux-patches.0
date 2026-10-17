Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 059B836195A;
	Sat, 17 Oct 2026 18:10:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260624; cv=none; b=gmzdtwjsXvyGYjESbE0izcOlZ7/MNyYkBjFILrlFB4Qyj8Rvj8i9cnacQdAEsLK0qG5J9gBUIU5BuUM+DCG1A08qFcvksnjNwe/HgUWS2PzMIcPsmvpN1kNskeSV7ZudDGsp+5bDQgI5BtaRKLpY5kXPXKCNkvz+zEni6Odmflw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260624; c=relaxed/simple;
	bh=nzUJwX9tW9BoQabireRNJ+t7xiOst+IMhQ4lg9Z0nmg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SowBXz2PPWuiS6rAwojHQwS1QJtYqBl7/5AoLUlDJmSi/UTvqorgkFMHlOh8TlJ21WtfqNMAw33V9B2+LUjoNWhIzTSDObg5UevqcydT8991bktx44JY1HgvyKAaFq0Ct4bbcDedOnH42OeJUmYuC+KLyElNPHC+sDt52ZI43kA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jdLqP1jQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jdLqP1jQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 546E71F000C5;
	Sat, 17 Oct 2026 18:10:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260622;
	bh=l76VFmBE4bimihkgC4t6/NRp7kVZKhRUnJNRROK+rrk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jdLqP1jQogxasSXJobKCBUO68e3fuaTMdFE1iBV6q9ENRLuwhyAoqVAOkLbXBwyNG
	 /bMA2xs3naAm7WA5Qjt4bLv9yk1Yv1gVPwBlEgQl3Ezcw/0KhlwoPIBA+0L2CnpHLA
	 muYTUG8inStyxVgtyyeOiDkNCmhUqyGGj0Lph0UE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+6b16e3d085833cbf3e25@syzkaller.appspotmail.com,
	Vasileios Almpanis <vasilisalmpanis@gmail.com>,
	Breno Leitao <leitao@debian.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1606/1674] configfs: unhash the dentry before dropping the item in rmdir
Date: Sat, 17 Oct 2026 18:04:38 +0200
Message-ID: <20261017160512.308706373@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/configfs/dir.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/fs/configfs/dir.c b/fs/configfs/dir.c
index 46540846d815c..e7ca50f119969 100644
--- a/fs/configfs/dir.c
+++ b/fs/configfs/dir.c
@@ -395,8 +395,17 @@ static void remove_dir(struct dentry * d)
 
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
 
-- 
2.53.0



