Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 737F64D17AC;
	Thu, 17 Sep 2026 17:59:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667992; cv=none; b=aW6rgYo0nXUAsTcBYWrBMRBaj10FGnWX2/dfiGW9BOdvrSmItFdZilVQBvG+wtPjNgb76Yd2WshO7sQ/xQ02yCTxRht1jb/FYtSdrlNy4HpnU1UI/vKOnaRXfDQF4niwIJ8QjPyNObZHkwbQ1oIfntB8RroWSdhFLdQ4za8cNVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667992; c=relaxed/simple;
	bh=EEgHFB3bZxX8uFYiSxuJaTZ4MDFrsViqaNCN8dvQeng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F/uzpRTxtAXrZ7hXo7QqxIiSSSK+2U04vIJKWxla3h77cNsavsROmZuJ73RzAgg6cl2HC8I5rOg2aAudo2gihivaneYxJheiaaG3rIe6nGS1Ms2sxSmtLHHFqsDNHxDKe5JFh/co1loM3cPf5GUTU50AFiKtjIRgm+Dj7jetD6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kv5zZ3PM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kv5zZ3PM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF3261F000FF;
	Thu, 17 Sep 2026 17:59:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667991;
	bh=WTddk+pzHIF68OZzi276BerolOeMKmwJREhJpEzm7WE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Kv5zZ3PMWOlWpjlB37hotUfxB8uZ6zC3S0yGBadgnahUr3gAenbpYeJAX1oOsfxRO
	 uD3Mdur4/FXlmJ0NlCBcnTriUO72UHRe9Aqv+T+E8n5saHaxVxdZys51+LmkS6EeT1
	 oDS+A2yL+acdWIqMSOkZ0TYCXEtbTSk93JoSzqoY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Breno Leitao <leitao@debian.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0250/1102] configfs_depend_prep(): pass configfs_dirent instead of dentry
Date: Thu, 17 Sep 2026 16:03:13 +0100
Message-ID: <20260917151545.871723338@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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
index 248d70b26f3d0..e7475ba0f8f1e 100644
--- a/fs/configfs/dir.c
+++ b/fs/configfs/dir.c
@@ -1070,15 +1070,12 @@ static int configfs_dump(struct configfs_dirent *sd, int level)
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
 
@@ -1086,8 +1083,7 @@ static int configfs_depend_prep(struct dentry *origin,
 		if ((child_sd->s_type & CONFIGFS_DIR) &&
 		    !(child_sd->s_type & CONFIGFS_USET_DROPPING) &&
 		    !(child_sd->s_type & CONFIGFS_USET_CREATING)) {
-			ret = configfs_depend_prep(child_sd->s_dentry,
-						   target);
+			ret = configfs_depend_prep(child_sd, target);
 			if (!ret)
 				goto out;  /* Child path boo-yah */
 		}
@@ -1108,7 +1104,7 @@ static int configfs_do_depend_item(struct dentry *subsys_dentry,
 
 	spin_lock(&configfs_dirent_lock);
 	/* Scan the tree, return 0 if found */
-	ret = configfs_depend_prep(subsys_dentry, target);
+	ret = configfs_depend_prep(subsys_dentry->d_fsdata, target);
 	if (ret)
 		goto out_unlock_dirent_lock;
 
-- 
2.53.0



