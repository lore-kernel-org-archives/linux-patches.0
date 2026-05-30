Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFA76340DB0;
	Sat, 30 May 2026 16:41:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780159269; cv=none; b=b2L/X2ekv/hD/2VNJdpk+Dbtyes+99Do0cwZaE8+gezVfcy7l4sjOOz15vlbslCW/cOT27hExBXnRrFgFcXREE0jCn79xqJr0zUZOYH554yW0mNzpQa/wCXQZvXo5Yq0HwdFdcGBZITKyjO+bfBu8H9gVxslhBv3Ul90NRSEb0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780159269; c=relaxed/simple;
	bh=sLLbqm/FdZtQYJjUBHFHyr/cHeemL+XCzPSkkFKzahk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J1XZ0OozZVxbvcrtxOQxbTlC2tcUu4lUFC5BRoN9kVyYRZLWy2cem0PvTo2njfBy8HZo5+fsncxa8s4REfecuspu8UZkN3X2QQc2KkV0AbKgNL0nLDgxdITqjkJ/ByDhXzN7yrM7LMlWxsAuCw4sbqmTiNiu6vM6WRqKKhS4aTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0sMjcYc6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0sMjcYc6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 237EB1F00893;
	Sat, 30 May 2026 16:41:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780159268;
	bh=RILw2IxMP6h1UUkPbkSd+4tirxUkKVZcmwPbnC2Tptc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0sMjcYc6xVeAKoyxfdc7WdAmAXtR8d69QS3i+NXj107mTXlzHybt7gH9Q1EHIj5OF
	 5TmkeRl8KZI51JAkJddBvUPOaGAy1XI/n4sikxDjoKc35P/ePw/6FXqoGjnsYSGoUO
	 gvmc3doZr2mkJpZqUMomvUjM9zrpMa/GYvl70P48=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Price <anprice@redhat.com>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Ruohan Lan <ruohanlan@aliyun.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 113/969] gfs2: Improve gfs2_consist_inode() usage
Date: Sat, 30 May 2026 17:53:57 +0200
Message-ID: <20260530160303.431995602@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrew Price <anprice@redhat.com>

[ Upstream commit 10398ef57aa189153406c110f5957145030f08fe ]

gfs2_consist_inode() logs an error message with the source file and line
number. When we jump before calling it, the line number becomes less
useful as it no longer relates to the source of the error. To aid
troubleshooting, replace the gotos with the gfs2_consist_inode() calls
so that the error messages are more informative.

Signed-off-by: Andrew Price <anprice@redhat.com>
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Ruohan Lan <ruohanlan@aliyun.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/dir.c   | 31 +++++++++++++++++--------------
 fs/gfs2/glops.c | 34 ++++++++++++++++++++--------------
 fs/gfs2/xattr.c | 28 ++++++++++++++++------------
 3 files changed, 53 insertions(+), 40 deletions(-)

diff --git a/fs/gfs2/dir.c b/fs/gfs2/dir.c
index 54a6d17b8c252..96924af95c8ef 100644
--- a/fs/gfs2/dir.c
+++ b/fs/gfs2/dir.c
@@ -562,15 +562,18 @@ static struct gfs2_dirent *gfs2_dirent_scan(struct inode *inode, void *buf,
 	int ret = 0;
 
 	ret = gfs2_dirent_offset(GFS2_SB(inode), buf);
-	if (ret < 0)
-		goto consist_inode;
-
+	if (ret < 0) {
+		gfs2_consist_inode(GFS2_I(inode));
+		return ERR_PTR(-EIO);
+	}
 	offset = ret;
 	prev = NULL;
 	dent = buf + offset;
 	size = be16_to_cpu(dent->de_rec_len);
-	if (gfs2_check_dirent(GFS2_SB(inode), dent, offset, size, len, 1))
-		goto consist_inode;
+	if (gfs2_check_dirent(GFS2_SB(inode), dent, offset, size, len, 1)) {
+		gfs2_consist_inode(GFS2_I(inode));
+		return ERR_PTR(-EIO);
+	}
 	do {
 		ret = scan(dent, name, opaque);
 		if (ret)
@@ -582,8 +585,10 @@ static struct gfs2_dirent *gfs2_dirent_scan(struct inode *inode, void *buf,
 		dent = buf + offset;
 		size = be16_to_cpu(dent->de_rec_len);
 		if (gfs2_check_dirent(GFS2_SB(inode), dent, offset, size,
-				      len, 0))
-			goto consist_inode;
+				      len, 0)) {
+			gfs2_consist_inode(GFS2_I(inode));
+			return ERR_PTR(-EIO);
+		}
 	} while(1);
 
 	switch(ret) {
@@ -597,10 +602,6 @@ static struct gfs2_dirent *gfs2_dirent_scan(struct inode *inode, void *buf,
 		BUG_ON(ret > 0);
 		return ERR_PTR(ret);
 	}
-
-consist_inode:
-	gfs2_consist_inode(GFS2_I(inode));
-	return ERR_PTR(-EIO);
 }
 
 static int dirent_check_reclen(struct gfs2_inode *dip,
@@ -609,14 +610,16 @@ static int dirent_check_reclen(struct gfs2_inode *dip,
 	const void *ptr = d;
 	u16 rec_len = be16_to_cpu(d->de_rec_len);
 
-	if (unlikely(rec_len < sizeof(struct gfs2_dirent)))
-		goto broken;
+	if (unlikely(rec_len < sizeof(struct gfs2_dirent))) {
+		gfs2_consist_inode(dip);
+		return -EIO;
+	}
 	ptr += rec_len;
 	if (ptr < end_p)
 		return rec_len;
 	if (ptr == end_p)
 		return -ENOENT;
-broken:
+
 	gfs2_consist_inode(dip);
 	return -EIO;
 }
diff --git a/fs/gfs2/glops.c b/fs/gfs2/glops.c
index bb5bc32a5eea5..f4bd487a9b3b0 100644
--- a/fs/gfs2/glops.c
+++ b/fs/gfs2/glops.c
@@ -404,10 +404,14 @@ static int gfs2_dinode_in(struct gfs2_inode *ip, const void *buf)
 	struct inode *inode = &ip->i_inode;
 	bool is_new = inode->i_state & I_NEW;
 
-	if (unlikely(ip->i_no_addr != be64_to_cpu(str->di_num.no_addr)))
-		goto corrupt;
-	if (unlikely(!is_new && inode_wrong_type(inode, mode)))
-		goto corrupt;
+	if (unlikely(ip->i_no_addr != be64_to_cpu(str->di_num.no_addr))) {
+		gfs2_consist_inode(ip);
+		return -EIO;
+	}
+	if (unlikely(!is_new && inode_wrong_type(inode, mode))) {
+		gfs2_consist_inode(ip);
+		return -EIO;
+	}
 	ip->i_no_formal_ino = be64_to_cpu(str->di_num.no_formal_ino);
 	inode->i_mode = mode;
 	if (is_new) {
@@ -443,26 +447,28 @@ static int gfs2_dinode_in(struct gfs2_inode *ip, const void *buf)
 	/* i_diskflags and i_eattr must be set before gfs2_set_inode_flags() */
 	gfs2_set_inode_flags(inode);
 	height = be16_to_cpu(str->di_height);
-	if (unlikely(height > sdp->sd_max_height))
-		goto corrupt;
+	if (unlikely(height > sdp->sd_max_height)) {
+		gfs2_consist_inode(ip);
+		return -EIO;
+	}
 	ip->i_height = (u8)height;
 
 	depth = be16_to_cpu(str->di_depth);
-	if (unlikely(depth > GFS2_DIR_MAX_DEPTH))
-		goto corrupt;
+	if (unlikely(depth > GFS2_DIR_MAX_DEPTH)) {
+		gfs2_consist_inode(ip);
+		return -EIO;
+	}
 	ip->i_depth = (u8)depth;
 	ip->i_entries = be32_to_cpu(str->di_entries);
 
-	if (gfs2_is_stuffed(ip) && inode->i_size > gfs2_max_stuffed_size(ip))
-		goto corrupt;
-
+	if (gfs2_is_stuffed(ip) && inode->i_size > gfs2_max_stuffed_size(ip)) {
+		gfs2_consist_inode(ip);
+		return -EIO;
+	}
 	if (S_ISREG(inode->i_mode))
 		gfs2_set_aops(inode);
 
 	return 0;
-corrupt:
-	gfs2_consist_inode(ip);
-	return -EIO;
 }
 
 /**
diff --git a/fs/gfs2/xattr.c b/fs/gfs2/xattr.c
index f6a66050380e9..6590aad6720b4 100644
--- a/fs/gfs2/xattr.c
+++ b/fs/gfs2/xattr.c
@@ -96,30 +96,34 @@ static int ea_foreach_i(struct gfs2_inode *ip, struct buffer_head *bh,
 		return -EIO;
 
 	for (ea = GFS2_EA_BH2FIRST(bh);; prev = ea, ea = GFS2_EA2NEXT(ea)) {
-		if (!GFS2_EA_REC_LEN(ea))
-			goto fail;
+		if (!GFS2_EA_REC_LEN(ea)) {
+			gfs2_consist_inode(ip);
+			return -EIO;
+		}
 		if (!(bh->b_data <= (char *)ea && (char *)GFS2_EA2NEXT(ea) <=
-						  bh->b_data + bh->b_size))
-			goto fail;
-		if (!gfs2_eatype_valid(sdp, ea->ea_type))
-			goto fail;
+						  bh->b_data + bh->b_size)) {
+			gfs2_consist_inode(ip);
+			return -EIO;
+		}
+		if (!gfs2_eatype_valid(sdp, ea->ea_type)) {
+			gfs2_consist_inode(ip);
+			return -EIO;
+		}
 		error = ea_call(ip, bh, ea, prev, data);
 		if (error)
 			return error;
 
 		if (GFS2_EA_IS_LAST(ea)) {
 			if ((char *)GFS2_EA2NEXT(ea) !=
-			    bh->b_data + bh->b_size)
-				goto fail;
+			    bh->b_data + bh->b_size) {
+				gfs2_consist_inode(ip);
+				return -EIO;
+			}
 			break;
 		}
 	}
 
 	return error;
-
-fail:
-	gfs2_consist_inode(ip);
-	return -EIO;
 }
 
 static int ea_foreach(struct gfs2_inode *ip, ea_call_t ea_call, void *data)
-- 
2.53.0



