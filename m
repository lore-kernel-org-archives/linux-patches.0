Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAECE511E90;
	Wed, 30 Sep 2026 17:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790995; cv=none; b=honyyUhJhjjX2mcEEqH73dXD1IZSpL+BSOuO8SCe3JPhFGQ/OYlL9i+1fGbDOkj48gSMLnMM8XB3/UINz6V/IboUSgb3ndjiJagqCZF4Co2C3KfeAxgyNaLHMTp45DzuwmpWQU7Dc8FBm5njETxu5DWtzu+2eGURU7qhcExoXV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790995; c=relaxed/simple;
	bh=IHmGieZ7ad4h++vzacwJFowISrZA9oIDz2/B3yKnzzU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PoMtsCA3A5tQfwFsL4GZeGhllseP2adUlKyVh2PdrZH+lwy6Fzu58dLdEaIzHVI3sc7/bOP1jO+aBlZ2ydKkDW1HzRMbSuwYE4zXher8Z64Tty3B02HR4lQroHruwdmd+D/ntTxFeTV+2Xa8A4DneukVEKbKWWfuhQjanHhI1gY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T6wjIreq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T6wjIreq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 227931F000FF;
	Wed, 30 Sep 2026 17:56:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790994;
	bh=7SS842XX2fDZnBn65Z7/ryz0629XZIeTFTUo99mb8UQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T6wjIreqPWCTjo+NDEB4CN8M46BOMSNzlFyllJvSyXyzCHoeEcsu1x7GdStcgyBJ7
	 /67+rkgQv4mRIrjqnztn6zr9EQ9qIvT4FOli7vjN6ipx6DJ0wxAyWRt3GzCf4/SUjT
	 HjAvho82wwifJU6Y8wrNwSYlqyIq4zrL//X5Sqgk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Breno Leitao <leitao@debian.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 130/752] configfs_depend_prep(): pass configfs_dirent instead of dentry
Date: Wed, 30 Sep 2026 17:20:00 +0200
Message-ID: <20260930152400.993242274@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit 764682e0118432260191d194edbdaff208260483 ]

Again, the only thing it uses dentry for is dentry->d_fsdata; for the
recursive call the situation is the same as with configfs_detach_prep()
and the same observation about ->s_dentry->d_fsdata applies.

Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Breno Leitao <leitao@debian.org>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/configfs/dir.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/fs/configfs/dir.c b/fs/configfs/dir.c
index 01c9d54833b30..69762a33dff6b 100644
--- a/fs/configfs/dir.c
+++ b/fs/configfs/dir.c
@@ -1060,15 +1060,12 @@ static int configfs_dump(struct configfs_dirent *sd, int level)
  * much on the stack, though, so folks that need this function - be careful
  * about your stack!  Patches will be accepted to make it iterative.
  */
-static int configfs_depend_prep(struct dentry *origin,
+static int configfs_depend_prep(struct configfs_dirent *sd,
 				struct config_item *target)
 {
-	struct configfs_dirent *child_sd, *sd;
+	struct configfs_dirent *child_sd;
 	int ret = 0;
 
-	BUG_ON(!origin || !origin->d_fsdata);
-	sd = origin->d_fsdata;
-
 	if (sd->s_element == target)  /* Boo-yah */
 		goto out;
 
@@ -1076,8 +1073,7 @@ static int configfs_depend_prep(struct dentry *origin,
 		if ((child_sd->s_type & CONFIGFS_DIR) &&
 		    !(child_sd->s_type & CONFIGFS_USET_DROPPING) &&
 		    !(child_sd->s_type & CONFIGFS_USET_CREATING)) {
-			ret = configfs_depend_prep(child_sd->s_dentry,
-						   target);
+			ret = configfs_depend_prep(child_sd, target);
 			if (!ret)
 				goto out;  /* Child path boo-yah */
 		}
@@ -1098,7 +1094,7 @@ static int configfs_do_depend_item(struct dentry *subsys_dentry,
 
 	spin_lock(&configfs_dirent_lock);
 	/* Scan the tree, return 0 if found */
-	ret = configfs_depend_prep(subsys_dentry, target);
+	ret = configfs_depend_prep(subsys_dentry->d_fsdata, target);
 	if (ret)
 		goto out_unlock_dirent_lock;
 
-- 
2.53.0



