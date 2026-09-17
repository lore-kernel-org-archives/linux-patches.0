Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8858F44CAC6;
	Thu, 17 Sep 2026 19:03:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671833; cv=none; b=CVfX5noYo+4K5DTrcLiGo1I5FeTcvgegfSb9oWSqhPssbMMkdoC+bWgiEnQZzoiEup7OJrmhdCNpBkmaA3aFM6Zc2XIpsdW/SwjDebZBkM8dteh59SlBc0EUfl8tRYRA+9ZqWz68K54zG9+FdOE/m8C43YpaFErsSD7TfztVSuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671833; c=relaxed/simple;
	bh=cV8jjHjqofYbgHvLtrveSTFp/+k+H8zM90GSr5/TXSE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NKPPDWl1V1GL2irKJKd/CQag0NMrjW0h0v4d8uq7gmJ7CGBAIJVqvrXQKNFUCcFkuYWBirrc6PhIoJywmsVKqd1Y5ctBiy50QtzeH5HlsGyNoueQlhKW0e4tHQYB36eIjn9mp1vrOl89sp2D5X0+xvG+UhjTzKZHeM+AR4EtyCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WHvkt3Kb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WHvkt3Kb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 554151F000FF;
	Thu, 17 Sep 2026 19:03:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671832;
	bh=jqtuH9+OLX5TY5b7uPKZrx45Zco6Pzi8Xja7QoiPtA4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WHvkt3KbtU+Tk2bsfZjlO6dAvMM5dSw2hzNA9c8XydfXblvrlJ5B7rcO91ANb0/T9
	 7ZKSlhzk0GCnquO+fJ1cpyhm3it3QwpKXXrQMsZb1JOIPZX85L5BflA2stGzS/u/er
	 iSWrWS1atBN+VLo+v1u6WCr881nH0YWYent2pLwY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1087/1102] rpc_pipe: dont overdo directory locking
Date: Thu, 17 Sep 2026 16:17:10 +0100
Message-ID: <20260917151608.146185305@linuxfoundation.org>
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

[ Upstream commit 41a6b9e52b21544c334830bfe68fb78d6677caa0 ]

Don't try to hold directories locked more than VFS requires;
lock just before getting a child to be made positive (using
simple_start_creating()) and unlock as soon as the child is
created.  There's no benefit in keeping the parent locked
while populating the child - it won't stop dcache lookups anyway.

Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Stable-dep-of: 932a8cf6abb2 ("sunrpc: fix use-after-free in __rpc_clnt_handle_event and __rpc_clnt_remove_pipedir")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sunrpc/rpc_pipe.c |   25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

--- a/net/sunrpc/rpc_pipe.c
+++ b/net/sunrpc/rpc_pipe.c
@@ -698,12 +698,14 @@ static int rpc_populate(struct dentry *p
 	struct dentry *dentry;
 	int i, err;
 
-	inode_lock(dir);
 	for (i = start; i < eof; i++) {
+		inode_lock(dir);
 		dentry = __rpc_lookup_create_exclusive(parent, files[i].name);
 		err = PTR_ERR(dentry);
-		if (IS_ERR(dentry))
+		if (IS_ERR(dentry)) {
+			inode_unlock(dir);
 			goto out_bad;
+		}
 		switch (files[i].mode & S_IFMT) {
 			default:
 				BUG();
@@ -712,20 +714,20 @@ static int rpc_populate(struct dentry *p
 						files[i].mode,
 						files[i].i_fop,
 						private);
+				inode_unlock(dir);
 				break;
 			case S_IFDIR:
 				err = __rpc_mkdir(dir, dentry,
 						files[i].mode,
 						NULL,
 						private);
+				inode_unlock(dir);
 		}
 		if (err != 0)
 			goto out_bad;
 	}
-	inode_unlock(dir);
 	return 0;
 out_bad:
-	inode_unlock(dir);
 	printk(KERN_WARNING "%s: %s failed to populate directory %pd\n",
 			__FILE__, __func__, parent);
 	return err;
@@ -741,25 +743,22 @@ static struct dentry *rpc_mkdir_populate
 
 	inode_lock_nested(dir, I_MUTEX_PARENT);
 	dentry = __rpc_lookup_create_exclusive(parent, name);
-	if (IS_ERR(dentry))
-		goto out;
+	if (IS_ERR(dentry)) {
+		inode_unlock(dir);
+		return dentry;
+	}
 	error = __rpc_mkdir(dir, dentry, mode, NULL, private);
+	inode_unlock(dir);
 	if (error != 0)
-		goto out_err;
+		return ERR_PTR(error);
 	if (populate != NULL) {
 		error = populate(dentry, args_populate);
 		if (error) {
-			inode_unlock(dir);
 			simple_recursive_removal(dentry, NULL);
 			return ERR_PTR(error);
 		}
 	}
-out:
-	inode_unlock(dir);
 	return dentry;
-out_err:
-	dentry = ERR_PTR(error);
-	goto out;
 }
 
 static int rpc_rmdir_depopulate(struct dentry *dentry,


