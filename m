Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D86570838;
	Mon, 23 Jun 2025 21:07:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750712822; cv=none; b=D3G64CT+sO6Ha7+WR+8qkL9nZkHchE4dZ8UtzN88nVdkAlzCsDW4kH4zW3abe4MlCzajHLjadHA11rklUk7X2hkm5QQ88zbLgBXFEZfwf0k6CvO/jyk//LSgbNIe4Q0FE2D57f+g7yxNnoCHmKwXFMnWruD26eolyGZoiHHLCNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750712822; c=relaxed/simple;
	bh=QiOUwO862shY+BfTvzEEVPM0ByHAEmB649+908yJJtI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ue8Vy5QWm9EWOud+ysP1RTLiHXZq/5ZTovyEB10+QTGZOmt5oMg6+TjkW5yIm5hAuXwSL6modzaaiVvtbk5gDqbxC3h3jJzkEJhJR2oe2OewqSuxMpnACvkMURiLiWnnTleyHyuXXriirFZIKU0wHIdQWZJ9VWfNb2SsDDjtM0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iPMWgal7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iPMWgal7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1889BC4CEEA;
	Mon, 23 Jun 2025 21:07:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750712822;
	bh=QiOUwO862shY+BfTvzEEVPM0ByHAEmB649+908yJJtI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iPMWgal7PpH/Se8KMoXwW8Qx9Iper1+0y/YJOQAgJBv/TqAVIcbygRC7R5iwELI4A
	 1WYjj+o5edJVQcpccTwUSCY5a/tx5tV6Kn9TWGNlJx2CKSdCXrB04KqhcXIwYLRx6E
	 xMHMqxI9hcXr9MBthwUHpqYX3+ZP+xzi/eEIcdks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+b974bd41515f770c608b@syzkaller.appspotmail.com,
	Aditya Dutt <duttaditya18@gmail.com>,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 150/222] jfs: fix array-index-out-of-bounds read in add_missing_indices
Date: Mon, 23 Jun 2025 15:08:05 +0200
Message-ID: <20250623130616.599741794@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130611.896514667@linuxfoundation.org>
References: <20250623130611.896514667@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aditya Dutt <duttaditya18@gmail.com>

[ Upstream commit 5dff41a86377563f7a2b968aae00d25b4ceb37c9 ]

stbl is s8 but it must contain offsets into slot which can go from 0 to
127.

Added a bound check for that error and return -EIO if the check fails.
Also make jfs_readdir return with error if add_missing_indices returns
with an error.

Reported-by: syzbot+b974bd41515f770c608b@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com./bug?extid=b974bd41515f770c608b
Signed-off-by: Aditya Dutt <duttaditya18@gmail.com>
Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/jfs/jfs_dtree.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/fs/jfs/jfs_dtree.c b/fs/jfs/jfs_dtree.c
index 4666aee2e1f4b..93df5f3bb3bbb 100644
--- a/fs/jfs/jfs_dtree.c
+++ b/fs/jfs/jfs_dtree.c
@@ -2909,7 +2909,7 @@ void dtInitRoot(tid_t tid, struct inode *ip, u32 idotdot)
  *	     fsck.jfs should really fix this, but it currently does not.
  *	     Called from jfs_readdir when bad index is detected.
  */
-static void add_missing_indices(struct inode *inode, s64 bn)
+static int add_missing_indices(struct inode *inode, s64 bn)
 {
 	struct ldtentry *d;
 	struct dt_lock *dtlck;
@@ -2918,7 +2918,7 @@ static void add_missing_indices(struct inode *inode, s64 bn)
 	struct lv *lv;
 	struct metapage *mp;
 	dtpage_t *p;
-	int rc;
+	int rc = 0;
 	s8 *stbl;
 	tid_t tid;
 	struct tlock *tlck;
@@ -2943,6 +2943,16 @@ static void add_missing_indices(struct inode *inode, s64 bn)
 
 	stbl = DT_GETSTBL(p);
 	for (i = 0; i < p->header.nextindex; i++) {
+		if (stbl[i] < 0) {
+			jfs_err("jfs: add_missing_indices: Invalid stbl[%d] = %d for inode %ld, block = %lld",
+				i, stbl[i], (long)inode->i_ino, (long long)bn);
+			rc = -EIO;
+
+			DT_PUTPAGE(mp);
+			txAbort(tid, 0);
+			goto end;
+		}
+
 		d = (struct ldtentry *) &p->slot[stbl[i]];
 		index = le32_to_cpu(d->index);
 		if ((index < 2) || (index >= JFS_IP(inode)->next_index)) {
@@ -2960,6 +2970,7 @@ static void add_missing_indices(struct inode *inode, s64 bn)
 	(void) txCommit(tid, 1, &inode, 0);
 end:
 	txEnd(tid);
+	return rc;
 }
 
 /*
@@ -3313,7 +3324,8 @@ int jfs_readdir(struct file *file, struct dir_context *ctx)
 		}
 
 		if (fix_page) {
-			add_missing_indices(ip, bn);
+			if ((rc = add_missing_indices(ip, bn)))
+				goto out;
 			page_fixed = 1;
 		}
 
-- 
2.39.5



