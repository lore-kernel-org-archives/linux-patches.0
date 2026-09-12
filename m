Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E22F7299920;
	Sat, 12 Sep 2026 11:16:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789211785; cv=none; b=VCsWGCn9/NI4sWrLdZJXtbmP9sr/A5TFxhakz5CuCFIrLoyRWV41F2od41TAAKYbI491bVTn7ali91r3B2lWwA5TARjDSjtxC6ydxRvERCQh7j/eLglm+Gp9H3nyzYV1TezFwQTfI3wkhamYkdi+CE1B8FUAFeq/He8xST35WyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789211785; c=relaxed/simple;
	bh=LfWyKpzHAYzGJvwz+K7U852hhNUTE3TCcoFE5YM8Nxs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jQ+84GIXRL6/dk55JAqeZodkDHvs4v4RAmEuB8By6yDQb04T2zjk0yeGe3PBNw4LQ3nwddVc0AXX0K2SXdr1k7WkHQ7BPQbAwUSMehWcIeBJuto9HIiH4sTqFK1yhqQNde2OOQl9PLawms8AJVN5iZ5N2XcwJMrfZqu4B93NyRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wyXu3JR6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wyXu3JR6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEE471F000FF;
	Sat, 12 Sep 2026 11:16:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789211783;
	bh=i2o0Pj+5XHOEqsojJ0hxpUw7RU8DMcMPn+zNe4jagzw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wyXu3JR6Ibi9WR10xUMNh7YbqjcsD7r0TVRUMrf2+g7tWGMWY5eOvhicUE/mIt/KP
	 ruag6CQTwvDmx9LuVuHxn3jRnAOkrh6dy39SoTjagymRmYog9wbEgx8zsagHFE8dNa
	 3UnZy7uEgU21EPU4XKHwM1YRy1o27A2lRrQUeZ0o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Sorenson <sorenson@redhat.com>,
	Huiwen He <hehuiwen@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1303/1518] cifs: remove dead size-update blocks in cifs_setattr_unix/nounix
Date: Sat, 12 Sep 2026 08:57:52 +0200
Message-ID: <20260912065652.997823255@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Frank Sorenson <sorenson@redhat.com>

[ Upstream commit 60be95527bc8d1b33dca25d2a849268cca11d139 ]

Commit 110fee6b9bb5 ("smb: client: fix missing timestamp updates with
O_TRUNC") introduced cifs_file_set_size(), which calls netfs_resize_file()
and cifs_setsize() on success.  cifs_setsize() calls i_size_write(),
updating i_size to the new value.  The subsequent blocks in both
cifs_setattr_unix() and cifs_setattr_nounix():

    if ((attrs->ia_valid & ATTR_SIZE) &&
        attrs->ia_size != i_size_read(inode)) {
        truncate_setsize(inode, attrs->ia_size);
        netfs_resize_file(&cifsInode->netfs, attrs->ia_size, true);
        fscache_resize_cookie(cifs_inode_cookie(inode), attrs->ia_size);
    }

are therefore unreachable on the success path: attrs->ia_size ==
i_size_read(inode) always holds after cifs_file_set_size() succeeds.
On the failure path, execution jumps to out/cifs_setattr_exit before
reaching these blocks.

truncate_setsize() and netfs_resize_file() are redundant with what
cifs_file_set_size() already did; fscache_resize_cookie() was moved there
by commit fa724e235cfd ("cifs: add fscache_resize_cookie() to
cifs_setsize()").  Remove both dead blocks.

Fixes: 110fee6b9bb5 ("smb: client: fix missing timestamp updates with O_TRUNC")
Signed-off-by: Frank Sorenson <sorenson@redhat.com>
Reviewed-by: Huiwen He <hehuiwen@kylinos.cn>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/inode.c | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index 72d2052a22d42..f23c36d6ae6b3 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -3278,13 +3278,6 @@ cifs_setattr_unix(struct dentry *direntry, struct iattr *attrs)
 	if (rc)
 		goto out;
 
-	if ((attrs->ia_valid & ATTR_SIZE) &&
-	    attrs->ia_size != i_size_read(inode)) {
-		truncate_setsize(inode, attrs->ia_size);
-		netfs_resize_file(&cifsInode->netfs, attrs->ia_size, true);
-		fscache_resize_cookie(cifs_inode_cookie(inode), attrs->ia_size);
-	}
-
 	setattr_copy(&nop_mnt_idmap, inode, attrs);
 	mark_inode_dirty(inode);
 
@@ -3496,13 +3489,6 @@ cifs_setattr_nounix(struct dentry *direntry, struct iattr *attrs)
 	if (rc)
 		goto cifs_setattr_exit;
 
-	if ((attrs->ia_valid & ATTR_SIZE) &&
-	    attrs->ia_size != i_size_read(inode)) {
-		truncate_setsize(inode, attrs->ia_size);
-		netfs_resize_file(&cifsInode->netfs, attrs->ia_size, true);
-		fscache_resize_cookie(cifs_inode_cookie(inode), attrs->ia_size);
-	}
-
 	setattr_copy(&nop_mnt_idmap, inode, attrs);
 	mark_inode_dirty(inode);
 
-- 
2.53.0



