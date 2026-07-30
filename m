Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D22264302F6;
	Thu, 30 Jul 2026 15:10:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424215; cv=none; b=dRoqUgiiK6fXJSrJgbeI4ffuL7iGFFvHI1UyF2FwFZgCEQelZdTlH77wMtMffGD7b+/Xnbixb+hLXF3qGW0wYWTaYJaSL/OVen3AXtpHA+iDtxjoufIuJ1f7a/5v0sOr/fzUIb1KkCansZM49EAI6vagIGcjbBdGfktuXyxxY/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424215; c=relaxed/simple;
	bh=KMzrLfFHIoq6GOnfEyRA/N+Gd7Cd/gRmCYoymKaLBYk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tOxfNdwoWmUoYEy6+rKvRgnAKcwof5bJvJLyRRFGvTbcjGXd+0eKEx6LjO5vi4YoZvp0+HUqtYcAlrcJe3Ilce3rcjJjGVCDUpKI1c83pcPHSAVHAuHCXuYsTwPRKZRuigwBo4ekX0Q32sjNhFURT8DK0St0q+jQ6eef4sSINXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fGoGJNJr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fGoGJNJr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D43CF1F000E9;
	Thu, 30 Jul 2026 15:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424213;
	bh=bA5sLQv+c538UNlnk0Ro6Xasdz5THep6X6d0TdhGudQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fGoGJNJrNuq18KUGqgQx6eubeOXw9rNEZqa5FhuSd0RTenh/vv52VtQDKrOB5kYhn
	 6rB/xo4kVcdqJbVAH80Fomo5m6tskmxwhfuzeZN2G2t493SJjl46S7RJ+97h0bRg6i
	 L9ejxKDrKM6CI1VkXMxcoBd08aadiD69cvLjWAJM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Goldstein <amir73il@gmail.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 271/675] ovl: port ovl_copyfile() to cred guard
Date: Thu, 30 Jul 2026 16:10:01 +0200
Message-ID: <20260730141450.889575924@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

From: Christian Brauner <brauner@kernel.org>

[ Upstream commit 14d35fda5b1139bacefb47c69f083fe2cfad211b ]

Use the scoped ovl cred guard.

Link: https://patch.msgid.link/20251117-work-ovl-cred-guard-v4-36-b31603935724@kernel.org
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Stable-dep-of: a1e0eb8f55cf ("ovl: check access to copy_file_range source with src mounter creds")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/overlayfs/file.c | 37 ++++++++++++++++++-------------------
 1 file changed, 18 insertions(+), 19 deletions(-)

diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index 3fedfdddfa7584..4374fbad3fc437 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -543,7 +543,6 @@ static loff_t ovl_copyfile(struct file *file_in, loff_t pos_in,
 {
 	struct inode *inode_out = file_inode(file_out);
 	struct file *realfile_in, *realfile_out;
-	const struct cred *old_cred;
 	loff_t ret;
 
 	inode_lock(inode_out);
@@ -565,25 +564,25 @@ static loff_t ovl_copyfile(struct file *file_in, loff_t pos_in,
 	if (IS_ERR(realfile_in))
 		goto out_unlock;
 
-	old_cred = ovl_override_creds(file_inode(file_out)->i_sb);
-	switch (op) {
-	case OVL_COPY:
-		ret = vfs_copy_file_range(realfile_in, pos_in,
-					  realfile_out, pos_out, len, flags);
-		break;
-
-	case OVL_CLONE:
-		ret = vfs_clone_file_range(realfile_in, pos_in,
-					   realfile_out, pos_out, len, flags);
-		break;
-
-	case OVL_DEDUPE:
-		ret = vfs_dedupe_file_range_one(realfile_in, pos_in,
-						realfile_out, pos_out, len,
-						flags);
-		break;
+	with_ovl_creds(file_inode(file_out)->i_sb) {
+		switch (op) {
+		case OVL_COPY:
+			ret = vfs_copy_file_range(realfile_in, pos_in,
+						  realfile_out, pos_out, len, flags);
+			break;
+
+		case OVL_CLONE:
+			ret = vfs_clone_file_range(realfile_in, pos_in,
+						   realfile_out, pos_out, len, flags);
+			break;
+
+		case OVL_DEDUPE:
+			ret = vfs_dedupe_file_range_one(realfile_in, pos_in,
+							realfile_out, pos_out, len,
+							flags);
+			break;
+		}
 	}
-	ovl_revert_creds(old_cred);
 
 	/* Update size */
 	ovl_file_modified(file_out);
-- 
2.53.0



