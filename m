Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4C53524AF;
	Mon,  8 Apr 2024 13:50:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584256; cv=none; b=LvBD55AM37eOfU2Sfmf4FTtmG4BTzVFLU63HzcOURPs47z/Rbe1PYhZcghCD1ujUF5DbplvaRjAvpFPgKaQTPaNfe8LiW5jEbap/GX48nVzvUJgmHryL/cRVyHtHqxzG0DKWMxdOcC8rrt3Z6ljJivHhZm/HZrPdEIomOSMtRyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584256; c=relaxed/simple;
	bh=oyNraB7dygprWEGH+mNMtimg8K1ZKHk8EOtHyUqZJ6o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FwxlRzouNmBhQvBP/mwzwOuTsWJbVull8S7N3ljXTj5Nc/fS6+OLPMVi3XEE4Qd5xutRbZGB9C5cbzd1IC0u+A2O2Tm+EOPABoUpiiODoHOMKX5PYyPpmHJsE8CHN1EnXIYvRgs4VO4fC/EFEerxARoyM2ALGQawGR56rwtKTGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0kKoXtjH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0kKoXtjH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CD5CC43390;
	Mon,  8 Apr 2024 13:50:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584256;
	bh=oyNraB7dygprWEGH+mNMtimg8K1ZKHk8EOtHyUqZJ6o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0kKoXtjHsK65bFfMXI34LY8JmJD/KxRLfPHmYyU/bHZitWlYIBUAE/lGKlBnkOSPU
	 n/sBr3rDzv7tJA+1j1T/Mx4tiLvNHjODepjSh1BDLy2KTtYZeNpIPeAtKFRuWwjXSY
	 i0+6EZ+2qATdZz/xD8KoczjfVLQrzQ/Xe4DFm/Zk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 375/690] NFSD: Ensure nf_inode is never dereferenced
Date: Mon,  8 Apr 2024 14:54:01 +0200
Message-ID: <20240408125413.141867901@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 427f5f83a3191cbf024c5aea6e5b601cdf88d895 ]

The documenting comment for struct nf_file states:

/*
 * A representation of a file that has been opened by knfsd. These are hashed
 * in the hashtable by inode pointer value. Note that this object doesn't
 * hold a reference to the inode by itself, so the nf_inode pointer should
 * never be dereferenced, only used for comparison.
 */

Replace the two existing dereferences to make the comment always
true.

Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/filecache.c | 5 ++---
 fs/nfsd/filecache.h | 2 +-
 fs/nfsd/nfs4state.c | 2 +-
 3 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index 7ad27655db699..55478d411e5a0 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -227,12 +227,11 @@ nfsd_file_mark_put(struct nfsd_file_mark *nfm)
 }
 
 static struct nfsd_file_mark *
-nfsd_file_mark_find_or_create(struct nfsd_file *nf)
+nfsd_file_mark_find_or_create(struct nfsd_file *nf, struct inode *inode)
 {
 	int			err;
 	struct fsnotify_mark	*mark;
 	struct nfsd_file_mark	*nfm = NULL, *new;
-	struct inode *inode = nf->nf_inode;
 
 	do {
 		fsnotify_group_lock(nfsd_file_fsnotify_group);
@@ -1143,7 +1142,7 @@ nfsd_file_do_acquire(struct svc_rqst *rqstp, struct svc_fh *fhp,
 
 open_file:
 	trace_nfsd_file_alloc(nf);
-	nf->nf_mark = nfsd_file_mark_find_or_create(nf);
+	nf->nf_mark = nfsd_file_mark_find_or_create(nf, key.inode);
 	if (nf->nf_mark) {
 		if (open) {
 			status = nfsd_open_verified(rqstp, fhp, may_flags,
diff --git a/fs/nfsd/filecache.h b/fs/nfsd/filecache.h
index 28145f1628923..8e8c0c47d67df 100644
--- a/fs/nfsd/filecache.h
+++ b/fs/nfsd/filecache.h
@@ -39,7 +39,7 @@ struct nfsd_file {
 #define NFSD_FILE_PENDING	(1)
 #define NFSD_FILE_REFERENCED	(2)
 	unsigned long		nf_flags;
-	struct inode		*nf_inode;
+	struct inode		*nf_inode;	/* don't deref */
 	refcount_t		nf_ref;
 	unsigned char		nf_may;
 	struct nfsd_file_mark	*nf_mark;
diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 923eec2716d75..9d344164f814f 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -2577,7 +2577,7 @@ static void nfs4_show_fname(struct seq_file *s, struct nfsd_file *f)
 
 static void nfs4_show_superblock(struct seq_file *s, struct nfsd_file *f)
 {
-	struct inode *inode = f->nf_inode;
+	struct inode *inode = file_inode(f->nf_file);
 
 	seq_printf(s, "superblock: \"%02x:%02x:%ld\"",
 					MAJOR(inode->i_sb->s_dev),
-- 
2.43.0



