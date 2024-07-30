Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE7041A6160;
	Tue, 30 Jul 2024 16:28:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356912; cv=none; b=iL+5De9uh72qOR1Xtn8mv75IIzZQlHjkZUgZTqw6D5P3kTh8vIAkzK1JPNshm0fTM4e0oFw3dPBT5fyMooKqlRLE43EIV2pUF/8pEUwCA3fgFfuS+Uc4YlTg0Nv4BGsOyC6FmqqqC4OQ6Dcs55WCxCy6p5Jkfo5Ceb11NfgFefA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356912; c=relaxed/simple;
	bh=OifE3YPDdfAZu8Uosxv8slmeO8REvSRVe4SQ0rltgSM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cKO6ocYSatv6fd2Sm1JP8EsRJPxLpKdfy2ow6H/jgqJqKEv5bpC9x57q/yyXe3pTRHHdvQ9ygB+an8QBjfieVIpwe5ml4Vj6eR0XKPK1xSQdOzDdhwlp2vHNOI5o351bVD6l9XxXHbQc/luYxaIU3662ZrvZ+ODsGgoGFny4Xgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LfOClUzl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LfOClUzl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AC92C32782;
	Tue, 30 Jul 2024 16:28:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356912;
	bh=OifE3YPDdfAZu8Uosxv8slmeO8REvSRVe4SQ0rltgSM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LfOClUzl6CnerK+iDsmZ/FDsEImlHDbJkJw2U2ptmMD2KkDoA0OHLIVKjmfOA2Lz8
	 vGEq6lod7IOxl0yhYMKQZk8ldGGODTcLtePLJj1Ai2JmU+UVlUwmOvLVTHuNgGp9/h
	 Qv6HY80MDgz3Jy34Xf1MnaE7e8ONoLxAwPwChZsU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+0333a6f4b88bcd68a62f@syzkaller.appspotmail.com,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 181/809] udf: Fix lock ordering in udf_evict_inode()
Date: Tue, 30 Jul 2024 17:40:57 +0200
Message-ID: <20240730151731.760010586@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

[ Upstream commit 8832fc1e502687869606bb0a7b79848ed3bf036f ]

udf_evict_inode() calls udf_setsize() to truncate deleted inode.
However inode deletion through udf_evict_inode() can happen from inode
reclaim context and udf_setsize() grabs mapping->invalidate_lock which
isn't generally safe to acquire from fs reclaim context since we
allocate pages under mapping->invalidate_lock for example in a page
fault path.  This is however not a real deadlock possibility as by the
time udf_evict_inode() is called, nobody can be accessing the inode,
even less work with its page cache. So this is just a lockdep triggering
false positive. Fix the problem by moving mapping->invalidate_lock
locking outsize of udf_setsize() into udf_setattr() as grabbing
mapping->invalidate_lock from udf_evict_inode() is pointless.

Reported-by: syzbot+0333a6f4b88bcd68a62f@syzkaller.appspotmail.com
Fixes: b9a861fd527a ("udf: Protect truncate and file type conversion with invalidate_lock")
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/udf/file.c  |  2 ++
 fs/udf/inode.c | 11 ++++-------
 2 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/fs/udf/file.c b/fs/udf/file.c
index 97c59585208ca..3a4179de316b4 100644
--- a/fs/udf/file.c
+++ b/fs/udf/file.c
@@ -232,7 +232,9 @@ static int udf_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
 
 	if ((attr->ia_valid & ATTR_SIZE) &&
 	    attr->ia_size != i_size_read(inode)) {
+		filemap_invalidate_lock(inode->i_mapping);
 		error = udf_setsize(inode, attr->ia_size);
+		filemap_invalidate_unlock(inode->i_mapping);
 		if (error)
 			return error;
 	}
diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index 2fb21c5ffccfe..08767bd21eb7f 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -1250,7 +1250,6 @@ int udf_setsize(struct inode *inode, loff_t newsize)
 	if (IS_APPEND(inode) || IS_IMMUTABLE(inode))
 		return -EPERM;
 
-	filemap_invalidate_lock(inode->i_mapping);
 	iinfo = UDF_I(inode);
 	if (newsize > inode->i_size) {
 		if (iinfo->i_alloc_type == ICBTAG_FLAG_AD_IN_ICB) {
@@ -1263,11 +1262,11 @@ int udf_setsize(struct inode *inode, loff_t newsize)
 			}
 			err = udf_expand_file_adinicb(inode);
 			if (err)
-				goto out_unlock;
+				return err;
 		}
 		err = udf_extend_file(inode, newsize);
 		if (err)
-			goto out_unlock;
+			return err;
 set_size:
 		truncate_setsize(inode, newsize);
 	} else {
@@ -1285,14 +1284,14 @@ int udf_setsize(struct inode *inode, loff_t newsize)
 		err = block_truncate_page(inode->i_mapping, newsize,
 					  udf_get_block);
 		if (err)
-			goto out_unlock;
+			return err;
 		truncate_setsize(inode, newsize);
 		down_write(&iinfo->i_data_sem);
 		udf_clear_extent_cache(inode);
 		err = udf_truncate_extents(inode);
 		up_write(&iinfo->i_data_sem);
 		if (err)
-			goto out_unlock;
+			return err;
 	}
 update_time:
 	inode_set_mtime_to_ts(inode, inode_set_ctime_current(inode));
@@ -1300,8 +1299,6 @@ int udf_setsize(struct inode *inode, loff_t newsize)
 		udf_sync_inode(inode);
 	else
 		mark_inode_dirty(inode);
-out_unlock:
-	filemap_invalidate_unlock(inode->i_mapping);
 	return err;
 }
 
-- 
2.43.0



