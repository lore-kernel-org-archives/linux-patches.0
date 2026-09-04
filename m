Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FCB61AA1F4;
	Fri,  4 Sep 2026 05:14:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498878; cv=none; b=HE8qhjpj1KN6BohNHNFcXc+GQ1tu3lkS5aAWQca6MzCZ3vlrriL1iZmTe3/BUaed61/kTY0Wmf4O1njNk9rzXfJc0WRN0OEtYJmmU/rI07S0RqGFHk5SItrV6O4OwqaXxyauWjH3Zi6jtdOO7fPcO4DEuUxvzE1rrOz9QSc5KvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498878; c=relaxed/simple;
	bh=N29dBMuOjrxs7rgnK8uOYTaX9L4WhZpilu869qUbKrU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GZCuDIYoxG2PfxP9BKw4XHINcOdSP0U8MJv3oOxcqVDBpKQlhfGVlF57XpL+XarACykBYLrp59S0s2eGytB5vIlHSaVrJzqtabaMYrMzydzC6p/v6c5NoeIbP/CSO2Oy4YrBXcVA0n4aCiWYR3i9ACmX9MKNnLDqP0rz1LamjcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pVkm38rc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pVkm38rc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8EE51F00A3D;
	Fri,  4 Sep 2026 05:14:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498877;
	bh=eyWD//Z1aDQ9q98jy6Hph6dA4A4r2ujyIAkLEN9/H0M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pVkm38rcKgDR1IoalJjuuBD9ujtxziBeV9sUFeWIn30yZEht1wzkvwPYt4kHya1+a
	 QHui9kzuHCzlsKcsekMuvCzRs59O/mnxTL87HkXGRFGnH3gPeoq+8gx4FUJpqptBuu
	 iAJBTKbMtQJURDuXT9tVSDmCaRUmXVQC2rDnt6aA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neil@brown.name>,
	Chuck Lever <chuck.lever@oracle.com>,
	Jeff Layton <jlayton@kernel.org>,
	Benjamin Coddington <bcodding@hammerspace.com>
Subject: [PATCH 7.2 175/713] nfsd: ensure nfsd_file_do_acquire() does not use a non-opened file
Date: Fri,  4 Sep 2026 06:52:23 +0200
Message-ID: <20260904045807.741080030@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neil@brown.name>

commit 5859cc01fee06a2cd7458905a9593082fbab06e1 upstream.

->atomic_open is permitted to return success without actually opening
the file.  It indicates this by calling finish_no_open().
This means dentry_create() can return a file which hasn't been opened.
This is extremely unlikely as ->atomic_open handlers typically
use finish_no_open() only for already existing files, and dentry_create()
isn't called in that case, and the parent being locked should prevent
races.

However out of an abundance of caution it seems wise to teach nfsd to
only use the file returned by dentry_create() if FMODE_OPENED is set,
indicating that it has in fact been opened.

Fixes: 64a989dbd144 ("VFS/knfsd: Teach dentry_create() to use atomic_open()")
Cc: stable@vger.kernel.org
Signed-off-by: NeilBrown <neil@brown.name>
Link: https://patch.msgid.link/20260526053004.4014491-3-neilb@ownmail.net
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: Benjamin Coddington <bcodding@hammerspace.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/filecache.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -1236,7 +1236,7 @@ open_file:
 		nf->nf_mark = nfsd_file_mark_find_or_create(inode);
 
 	if (type != S_IFREG || nf->nf_mark) {
-		if (file) {
+		if (file && (file->f_mode & FMODE_OPENED)) {
 			get_file(file);
 			nf->nf_file = file;
 			status = nfs_ok;
@@ -1383,12 +1383,12 @@ nfsd_file_acquire_local(struct net *net,
  * @rqstp: the RPC transaction being executed
  * @fhp: the NFS filehandle of the file just created
  * @may_flags: NFSD_MAY_ settings for the file
- * @file: cached, already-open file (may be NULL)
+ * @file: cached, already-open file (may be NULL or not yet opened)
  * @pnf: OUT: new or found "struct nfsd_file" object
  *
  * Acquire a nfsd_file object that is not GC'ed. If one doesn't already exist,
- * and @file is non-NULL, use it to instantiate a new nfsd_file instead of
- * opening a new one.
+ * and @file has FMODE_OPENED set, use it to instantiate a new nfsd_file
+ * instead of opening a new one.
  *
  * Return values:
  *   %nfs_ok - @pnf points to an nfsd_file with its reference


