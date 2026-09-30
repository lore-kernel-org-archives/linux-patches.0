Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33D9C36998C;
	Wed, 30 Sep 2026 18:53:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794434; cv=none; b=oZ2ApR7oyACLMtKYiuhTwGw91kywHEAq01rRSFOQx2GegWGRxhSw7OuXlRYql4OWT9VrQj2KNkERMEcJMuDjB+78ycGOFERMaNw+N5TppoZrrhH5zo8/lUWoyBVCn4Y3GUdcUSYZJI5C8m9s8rnfDFdLrDHhkPd6cG1CGsEdbh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794434; c=relaxed/simple;
	bh=F6wM4HqRJepyNZY1jaexQAPImV97dIw0NB4Ifrv+Uic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JYa4rTcJZ1XFSD0fMMfRPJkFmAzXnbajb3rkPfpZ0o+nn6JdfQODb+Xq+8Tm4MdTZPcG6AfeCYRg1Jhm8bRB/NXUXybrmn1wtXxHCd0JIBTpF1s8J48qssilDBONls++d73LzfH6zaQvUA9TaPRTpwxMqP09G5v2QB3F9hEwqE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jGBojbHJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jGBojbHJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BE781F000FF;
	Wed, 30 Sep 2026 18:53:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794432;
	bh=61CL0km9o8yayCOCCYgVTXzccQBFrQTu5+SLL6kh2IE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jGBojbHJepAIV4aE5W41sA5H5EtwwbSv9zdeF2M/NO+e1muRfK5YqFK0YdAy4TY7D
	 bLrW8Z3E2RqbhMhVd6gkreeLo4FMt5Wx1LwYJl8EpJOcS0/Xngr8PjD+i9I/Us2rHA
	 dN8k2YluM1y2/rELAhSh3bLMwp1Cq710rOCh86DA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Breno Leitao <leitao@debian.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0192/1193] configfs_depend_prep(): pass configfs_dirent instead of dentry
Date: Wed, 30 Sep 2026 17:14:36 +0200
Message-ID: <20260930152438.464552240@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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
index 972fb89ad2214..46540846d815c 100644
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



