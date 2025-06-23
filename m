Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBBCB6136;
	Mon, 23 Jun 2025 22:00:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716012; cv=none; b=bOYc8w1hZbxoCQpEO523ri7nmazFeK67iY4mfGE/RQOzVUxX9Dir0zHEb2rBD3WkUnloMNNNCoBct/jyUz7L84e97MW3D7ZLcJrHciQ6pe2/eU6Txr9hGq2M4xiz1UaPMRCG20CpHcJ50JxgSoPQwQwDvpZaJfsE7V0jgq9lBSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716012; c=relaxed/simple;
	bh=NZZB60gwxp3hFxpv5Ud9Nt3nefDRGv2zDLjUt3X17Cg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VfiwcrOBjrkmEcaA2USO+plJchCed47QrMXilpWTfUGN+ck9hOtixr1itHpwo3DZ8bIXTqPbrSjkM8IZ9bzBPDUEMlzYwY/UeRh4FBSgzJ/sasECPP7Nfp85oCxeRhsSMKm+KRnYBIEszJIIeIqBm1tqyN6fGVG/FysrZfdkG5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YujigLZu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YujigLZu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA38BC4CEEA;
	Mon, 23 Jun 2025 22:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716012;
	bh=NZZB60gwxp3hFxpv5Ud9Nt3nefDRGv2zDLjUt3X17Cg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YujigLZu4xDSSPkSxz3R6JcdlHdAnQ/wE9JtJ90Q/LcDV00hqsTjPaja6mksAq1IB
	 RWPJJ3zshhqQPpO4YiwXprFbvykDlqAKIE0T9/0FuGOC/7Nz2eeaNd+9/rDz+inQrH
	 AIqZDUHJi3f5tl1Ku0ZauFX7wd8O4/hQ7orkg8Pg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+b974bd41515f770c608b@syzkaller.appspotmail.com,
	Aditya Dutt <duttaditya18@gmail.com>,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 288/411] jfs: fix array-index-out-of-bounds read in add_missing_indices
Date: Mon, 23 Jun 2025 15:07:12 +0200
Message-ID: <20250623130640.896647940@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 417d1c2fc2911..27ca98614b0bb 100644
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



