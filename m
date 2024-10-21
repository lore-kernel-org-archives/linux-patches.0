Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D2B51EABB6;
	Mon, 21 Oct 2024 10:43:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507394; cv=none; b=aY6n0m4XBibkLSFFeG+1WbEz4/1cWZezgdUeGh02NdyNT5Cf2YVHkunPm0xfgr8JEr8suHWU7Hi3O3TY+0bXhpEzskNFmRO9tghIvy9MZCUyU0z54x5zq2xUTDR8JCRZM2pPMQ8KIW6dhf8QTMe+p0wGmJSgvM/bjEJNkWn5peE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507394; c=relaxed/simple;
	bh=cbCuTr+85qYw5XD883Lmh9cY3JzA9nyWQvK8/feXo6A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MYMJqDdHVnoUbEkRvOZEDmYfxQ9fz+D9m2O9i1Ge3h4J0AjPrnBUoSH1rJZcLgga6KShpx1mm+rke3FG7KIpobOecJ/h5xGClU4hxjMQhUkzciZr8E3ZRmqeOJ4BgIcpc7nA/o1zOTmkPM/3eRD64QZMWkNzf8WBivmGSZDsjJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J4lJVR/y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J4lJVR/y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED777C4CEC3;
	Mon, 21 Oct 2024 10:43:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507394;
	bh=cbCuTr+85qYw5XD883Lmh9cY3JzA9nyWQvK8/feXo6A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J4lJVR/yXwzlxKEInEXK1kaC0VgmrZFWXkZApVWztX6J9cTgF0uF3DD0ety8bE7co
	 Td0+k57eOSCvsKP/6RZUzDon9SUrbPz6I139jQCVNghFGbdZEuHn7gJ5ROyJ8LRoH9
	 ge+CZTz/fp5Vpq3v2x51glLSrIgXFOlBnlqXXZ+A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Subject: [PATCH 6.1 21/91] udf: Convert udf_link() to new directory iteration code
Date: Mon, 21 Oct 2024 12:24:35 +0200
Message-ID: <20241021102250.645223156@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102249.791942892@linuxfoundation.org>
References: <20241021102249.791942892@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

[ Upstream commit dbfb102d16fb780c84f41adbaeb7eac907c415dc ]

Convert udf_link() to use new directory iteration code for adding entry
into the directory.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/udf/namei.c |   22 ++++++++--------------
 1 file changed, 8 insertions(+), 14 deletions(-)

--- a/fs/udf/namei.c
+++ b/fs/udf/namei.c
@@ -1222,27 +1222,21 @@ static int udf_link(struct dentry *old_d
 		    struct dentry *dentry)
 {
 	struct inode *inode = d_inode(old_dentry);
-	struct udf_fileident_bh fibh;
-	struct fileIdentDesc cfi, *fi;
+	struct udf_fileident_iter iter;
 	int err;
 
-	fi = udf_add_entry(dir, dentry, &fibh, &cfi, &err);
-	if (!fi) {
+	err = udf_fiiter_add_entry(dir, dentry, &iter);
+	if (err)
 		return err;
-	}
-	cfi.icb.extLength = cpu_to_le32(inode->i_sb->s_blocksize);
-	cfi.icb.extLocation = cpu_to_lelb(UDF_I(inode)->i_location);
+	iter.fi.icb.extLength = cpu_to_le32(inode->i_sb->s_blocksize);
+	iter.fi.icb.extLocation = cpu_to_lelb(UDF_I(inode)->i_location);
 	if (UDF_SB(inode->i_sb)->s_lvid_bh) {
-		*(__le32 *)((struct allocDescImpUse *)cfi.icb.impUse)->impUse =
+		*(__le32 *)((struct allocDescImpUse *)iter.fi.icb.impUse)->impUse =
 			cpu_to_le32(lvid_get_unique_id(inode->i_sb));
 	}
-	udf_write_fi(dir, &cfi, fi, &fibh, NULL, NULL);
-	if (UDF_I(dir)->i_alloc_type == ICBTAG_FLAG_AD_IN_ICB)
-		mark_inode_dirty(dir);
+	udf_fiiter_write_fi(&iter, NULL);
+	udf_fiiter_release(&iter);
 
-	if (fibh.sbh != fibh.ebh)
-		brelse(fibh.ebh);
-	brelse(fibh.sbh);
 	inc_nlink(inode);
 	inode->i_ctime = current_time(inode);
 	mark_inode_dirty(inode);


