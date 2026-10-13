Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6015F4F3914;
	Tue, 13 Oct 2026 12:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895383; cv=none; b=TIdjSE94beZdz7Kb3X8kFD/MMf5ZE9W4RJsRy23a/CT2Z/mNY9Av4Mmibom4cqrT0Y+P7EtHPta8uX6e0fmaU3rULC0PT0id8M+y1p2I9ba6JmDZtFC8bZGHDdL3q1cN8qycng0gyWH+19coDpgwuiXl9yqyTq4JBFFSp1yj+xM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895383; c=relaxed/simple;
	bh=xLq4mNoNIaISug99U0fKai0lqTDTEfblaRTAn3xrqlY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cwHtc506PnMZ/GPrgopO2+5ikd8xWnkqhYkBrl3fBUGmYjfV84THjvtHewuMS6slRhAwStRdtS9f3i2unKXEC9jZJI9tusdEccFqjcANivlrXz8bXXstFDgoXCbSA/6joOabPJY4vGkZtlVTv2+NwLdxLAOxb7nMEs2ZyicHBvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1byey/U5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1byey/U5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4F591F000FF;
	Tue, 13 Oct 2026 12:43:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895382;
	bh=sqScqdt6HYLYOFx6NdIVchFUoS6z8l3eQ4+IN/Lm6nE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1byey/U5h2eo34C5bJaxilxlD30YVuwIHzUqTUc74L4xYAZihuHX57ThOrn+iVmP8
	 TIHH/sjaTq3wWKUbcI8qPhGPlcKPtqihj6OJJdC8vjXAeiHOAr+puvl2aYN4WL6Kk2
	 XphKDSR4jZUiKiSHtf+w358mW0AtqszNxDZBP03c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+b974bd41515f770c608b@syzkaller.appspotmail.com,
	Aditya Dutt <duttaditya18@gmail.com>,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 255/497] jfs: fix array-index-out-of-bounds read in add_missing_indices
Date: Tue, 13 Oct 2026 13:37:02 +0200
Message-ID: <20261013112913.945064286@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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
index 93db6eec44655..ab11849cf9cc3 100644
--- a/fs/jfs/jfs_dtree.c
+++ b/fs/jfs/jfs_dtree.c
@@ -2613,7 +2613,7 @@ void dtInitRoot(tid_t tid, struct inode *ip, u32 idotdot)
  *	     fsck.jfs should really fix this, but it currently does not.
  *	     Called from jfs_readdir when bad index is detected.
  */
-static void add_missing_indices(struct inode *inode, s64 bn)
+static int add_missing_indices(struct inode *inode, s64 bn)
 {
 	struct ldtentry *d;
 	struct dt_lock *dtlck;
@@ -2622,7 +2622,7 @@ static void add_missing_indices(struct inode *inode, s64 bn)
 	struct lv *lv;
 	struct metapage *mp;
 	dtpage_t *p;
-	int rc;
+	int rc = 0;
 	s8 *stbl;
 	tid_t tid;
 	struct tlock *tlck;
@@ -2647,6 +2647,16 @@ static void add_missing_indices(struct inode *inode, s64 bn)
 
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
@@ -2664,6 +2674,7 @@ static void add_missing_indices(struct inode *inode, s64 bn)
 	(void) txCommit(tid, 1, &inode, 0);
 end:
 	txEnd(tid);
+	return rc;
 }
 
 /*
@@ -3017,7 +3028,8 @@ int jfs_readdir(struct file *file, struct dir_context *ctx)
 		}
 
 		if (fix_page) {
-			add_missing_indices(ip, bn);
+			if ((rc = add_missing_indices(ip, bn)))
+				goto out;
 			page_fixed = 1;
 		}
 
-- 
2.53.0



