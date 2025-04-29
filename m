Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5285A2AE96;
	Tue, 29 Apr 2025 17:59:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949570; cv=none; b=vC/egTDi6d7Av2RW1v0xSCWTmfa9eMqmUscpSxWctRNqc5rO/ONbwkX1xJIkPgDx7w4C0o9bzPO2cqhuAhIOsl3ClYwZhs0rnk/pBkHGOUo5s7IEL0UKv5aXH/WSKFjbUalTW2Be/0CBijWn+B1zs0Fa8dRs6FVDnnF8oIOjd/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949570; c=relaxed/simple;
	bh=12YoUSXXcSJJdk6bVEwXkVWtp9KU1ajXAybskaF+dDw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fzkdQbkgtwONBspMDMCPTCGyGZ6PSnEkpAV3Txowron3hZuYqhhr2egfkdiCyY13Co3hjw8q+oy+gswoI4vZPw8MempR9tAFsVXRWOHW52+MCZw0h0xE8S68W2T16jYhZBg+ABCfXzvoSfADmzSuOfdfXIeRLN1KYeHM8Sw5t6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LWxU9w8+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LWxU9w8+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52BCAC4CEE3;
	Tue, 29 Apr 2025 17:59:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949569;
	bh=12YoUSXXcSJJdk6bVEwXkVWtp9KU1ajXAybskaF+dDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LWxU9w8+kGpJX6SaasTvzLfx98/M5Brq225GZ9sX0xJDS6VmfgxLQFkB9FeZMF355
	 Frp33JiPPeK3t37GXviMKKvA7IiIvfc1hnW3/5t2q41Th7Uj/yl9Rdg3j0DPPt8kgt
	 PQDEGvynTQqW6ENTmMqhWGw+LRiRFtzunA6MRU38=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Manas Ghandat <ghandatmanas@gmail.com>,
	syzbot+ccb458b6679845ee0bae@syzkaller.appspotmail.com,
	Aditya Dutt <duttaditya18@gmail.com>
Subject: [PATCH 5.15 361/373] jfs: define xtree root and page independently
Date: Tue, 29 Apr 2025 18:43:58 +0200
Message-ID: <20250429161137.979814374@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
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

From: Dave Kleikamp <dave.kleikamp@oracle.com>

commit a779ed754e52d582b8c0e17959df063108bd0656 upstream.

In order to make array bounds checking sane, provide a separate
definition of the in-inode xtree root and the external xtree page.

Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Tested-by: Manas Ghandat <ghandatmanas@gmail.com>
Closes: https://syzkaller.appspot.com/bug?extid=ccb458b6679845ee0bae
Reported-by: syzbot+ccb458b6679845ee0bae@syzkaller.appspotmail.com
Signed-off-by: Aditya Dutt <duttaditya18@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/jfs/jfs_dinode.h |    2 +-
 fs/jfs/jfs_imap.c   |    6 +++---
 fs/jfs/jfs_incore.h |    2 +-
 fs/jfs/jfs_txnmgr.c |    4 ++--
 fs/jfs/jfs_xtree.c  |    4 ++--
 fs/jfs/jfs_xtree.h  |   37 +++++++++++++++++++++++--------------
 6 files changed, 32 insertions(+), 23 deletions(-)

--- a/fs/jfs/jfs_dinode.h
+++ b/fs/jfs/jfs_dinode.h
@@ -96,7 +96,7 @@ struct dinode {
 #define di_gengen	u._file._u1._imap._gengen
 
 			union {
-				xtpage_t _xtroot;
+				xtroot_t _xtroot;
 				struct {
 					u8 unused[16];	/* 16: */
 					dxd_t _dxd;	/* 16: */
--- a/fs/jfs/jfs_imap.c
+++ b/fs/jfs/jfs_imap.c
@@ -673,7 +673,7 @@ int diWrite(tid_t tid, struct inode *ip)
 		 * This is the special xtree inside the directory for storing
 		 * the directory table
 		 */
-		xtpage_t *p, *xp;
+		xtroot_t *p, *xp;
 		xad_t *xad;
 
 		jfs_ip->xtlid = 0;
@@ -687,7 +687,7 @@ int diWrite(tid_t tid, struct inode *ip)
 		 * copy xtree root from inode to dinode:
 		 */
 		p = &jfs_ip->i_xtroot;
-		xp = (xtpage_t *) &dp->di_dirtable;
+		xp = (xtroot_t *) &dp->di_dirtable;
 		lv = ilinelock->lv;
 		for (n = 0; n < ilinelock->index; n++, lv++) {
 			memcpy(&xp->xad[lv->offset], &p->xad[lv->offset],
@@ -716,7 +716,7 @@ int diWrite(tid_t tid, struct inode *ip)
 	 *	regular file: 16 byte (XAD slot) granularity
 	 */
 	if (type & tlckXTREE) {
-		xtpage_t *p, *xp;
+		xtroot_t *p, *xp;
 		xad_t *xad;
 
 		/*
--- a/fs/jfs/jfs_incore.h
+++ b/fs/jfs/jfs_incore.h
@@ -66,7 +66,7 @@ struct jfs_inode_info {
 	lid_t	xtlid;		/* lid of xtree lock on directory */
 	union {
 		struct {
-			xtpage_t _xtroot;	/* 288: xtree root */
+			xtroot_t _xtroot;	/* 288: xtree root */
 			struct inomap *_imap;	/* 4: inode map header	*/
 		} file;
 		struct {
--- a/fs/jfs/jfs_txnmgr.c
+++ b/fs/jfs/jfs_txnmgr.c
@@ -783,7 +783,7 @@ struct tlock *txLock(tid_t tid, struct i
 			if (mp->xflag & COMMIT_PAGE)
 				p = (xtpage_t *) mp->data;
 			else
-				p = &jfs_ip->i_xtroot;
+				p = (xtpage_t *) &jfs_ip->i_xtroot;
 			xtlck->lwm.offset =
 			    le16_to_cpu(p->header.nextindex);
 		}
@@ -1710,7 +1710,7 @@ static void xtLog(struct jfs_log * log,
 
 	if (tlck->type & tlckBTROOT) {
 		lrd->log.redopage.type |= cpu_to_le16(LOG_BTROOT);
-		p = &JFS_IP(ip)->i_xtroot;
+		p = (xtpage_t *) &JFS_IP(ip)->i_xtroot;
 		if (S_ISDIR(ip->i_mode))
 			lrd->log.redopage.type |=
 			    cpu_to_le16(LOG_DIR_XTREE);
--- a/fs/jfs/jfs_xtree.c
+++ b/fs/jfs/jfs_xtree.c
@@ -1224,7 +1224,7 @@ xtSplitRoot(tid_t tid,
 	struct xtlock *xtlck;
 	int rc;
 
-	sp = &JFS_IP(ip)->i_xtroot;
+	sp = (xtpage_t *) &JFS_IP(ip)->i_xtroot;
 
 	INCREMENT(xtStat.split);
 
@@ -3059,7 +3059,7 @@ static int xtRelink(tid_t tid, struct in
  */
 void xtInitRoot(tid_t tid, struct inode *ip)
 {
-	xtpage_t *p;
+	xtroot_t *p;
 
 	/*
 	 * acquire a transaction lock on the root
--- a/fs/jfs/jfs_xtree.h
+++ b/fs/jfs/jfs_xtree.h
@@ -65,24 +65,33 @@ struct xadlist {
 #define XTPAGEMAXSLOT	256
 #define XTENTRYSTART	2
 
+struct xtheader {
+	__le64 next;	/* 8: */
+	__le64 prev;	/* 8: */
+
+	u8 flag;	/* 1: */
+	u8 rsrvd1;	/* 1: */
+	__le16 nextindex;	/* 2: next index = number of entries */
+	__le16 maxentry;	/* 2: max number of entries */
+	__le16 rsrvd2;	/* 2: */
+
+	pxd_t self;	/* 8: self */
+};
+
 /*
- *	xtree page:
+ *	xtree root (in inode):
  */
 typedef union {
-	struct xtheader {
-		__le64 next;	/* 8: */
-		__le64 prev;	/* 8: */
-
-		u8 flag;	/* 1: */
-		u8 rsrvd1;	/* 1: */
-		__le16 nextindex;	/* 2: next index = number of entries */
-		__le16 maxentry;	/* 2: max number of entries */
-		__le16 rsrvd2;	/* 2: */
-
-		pxd_t self;	/* 8: self */
-	} header;		/* (32) */
-
+	struct xtheader header;
 	xad_t xad[XTROOTMAXSLOT];	/* 16 * maxentry: xad array */
+} xtroot_t;
+
+/*
+ *	xtree page:
+ */
+typedef union {
+	struct xtheader header;
+	xad_t xad[XTPAGEMAXSLOT];	/* 16 * maxentry: xad array */
 } xtpage_t;
 
 /*


