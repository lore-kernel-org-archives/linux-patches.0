Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4EA445A2BC;
	Fri,  9 Oct 2026 14:53:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557630; cv=none; b=THiCOlg2zJwHlCuswYuljVW7CbCrrLVrZEPxwrBvUs2ooU8vO3kkPx471bSFVvKYd3fCI+lvwTMoYUzbe0+Zuyktb24TA4ANi+8xtJvcW68KqNeiKMh7JYJVROZsJtEgx+P/T16Cn8g7UTisYDXYRChmTAqVqWHEBCM8+aklfjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557630; c=relaxed/simple;
	bh=pHwCVa+qlB8QHizPAjLdL3EOwXdgN9msH3CKsrLzutk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kz7dsj8+I1EHtjVR2uEAiTXOVakQdXXo96esz/MzFaNKR63k5OHPssQHingiJMdckKEoMrh9TZkwCmJxUdwrSX1E9rXjRFCyTQYt+FVd3oU1d2cNsv4xMeGF31LwVAALeSTjJ1+KtMv+1/MQw3o2jqPowhmxLa3MP4xgeD1KRdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TXEK600f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TXEK600f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51EB71F000FF;
	Fri,  9 Oct 2026 14:53:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557628;
	bh=Ztm/UNMi2GwmoqK6TanfrGSPMIYek57f8RTMEAY6ZhU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TXEK600fNORZUybJWuS1AlJzwhvC4sTfsHlGySdnOronkm91CRaswVYDIhcirGjxh
	 l6km8Wu6W/gZRdaaQns89ZXQGMVjvt8Z4hGGg5R/d4hcp74+62lm55Iyb+tiEjMWLc
	 k2yIikEDbXaU18kti5VDHjCOtCR4rqOSBZOKfogg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Christian Brauner <brauner@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 425/428] smb: client: only require read lease for size-extending preallocate
Date: Fri,  9 Oct 2026 16:12:42 +0200
Message-ID: <20261009140955.581655355@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

From: Paulo Alcantara <pc@manguebit.org>

[ Upstream commit b5d59e7270d078ab28a9c4b4d11dc3eb24671988 ]

smb3_simple_falloc() refuses any fallocate that clears FALLOC_FL_KEEP_SIZE
with -EOPNOTSUPP whenever the inode is not read caching:

	/* if file not oplocked can't be sure whether asking to extend size */
	if (!CIFS_CACHE_READ(cifsi))
		if (!keep_size) {
			...
			return rc;
		}

As with smb3_zero_range(), the read lease is only needed to trust the
cached size when deciding whether the request extends the file. When it
is not held, the size can instead be fetched from the server, which is
authoritative, rather than refusing the request outright: after
flushing, query the server's end of file and take the larger of it and
the cached size for the interior-vs-extend decision. The larger of the
two is used because the server's end of file reflects another client's
growth while the cached size reflects this client's own writes that may
not have reached the server yet; using the server size alone would
wrongly treat an interior request as extending when a range flush left
an extending write unwritten.

smb3_simple_fallocate_range(), which performs the actual interior
emulation, decided whether the range already lies past EOF from its own
i_size_read(inode) rather than the old_eof computed above. In the
leaseless case, that is exactly the stale, undershooting size this
patch works around: a genuinely interior range can read as past EOF by
that stale count, which skips the FSCTL_QUERY_ALLOCATED_RANGES check
entirely and overwrites already-allocated server data with zeroes
instead of only filling the holes. Pass old_eof into
smb3_simple_fallocate_range() and use it for that comparison instead of
re-deriving a second, inconsistent one.

Rejecting interior requests is observed as generic/363 randomly failing
against Windows Server with

	do_preallocate: fallocate: Operation not supported

fsx issues an interior, non-KEEP_SIZE preallocate while the inode is
transiently not read caching: the server had just downgraded the file's
lease from RWH to RH after breaking the write caching, and the ensuing
handle reopen/revalidation left CIFS_CACHE_READ momentarily clear. The
range sat within the server's end of file, so no extend was needed, yet
it was refused and fsx aborted. This keeps the emulation correct even
when a genuine lease break from another client leaves the inode
without read caching -- the case the -EOPNOTSUPP guard turned into a
hard failure. The extra flush and round trip only happen when both
keep_size is false and no read lease is held; every other case is
unchanged.

Fixes: 9ccf3216238c ("Add support for original fallocate")
Reviewed-by: David Howells <dhowells@redhat.com>
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: Shyam Prasad N <sprasad@microsoft.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Bharath SM <bharathsm@microsoft.com>
Cc: stable@vger.kernel.org
[ sashal: Adapted cifs_resize_file_locked() calls to the two-argument helper. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/smb2ops.c |   36 +++++++++++++++++++++++++++---------
 1 file changed, 27 insertions(+), 9 deletions(-)

--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -3742,7 +3742,8 @@ static int smb3_simple_fallocate_write_r
 static int smb3_simple_fallocate_range(unsigned int xid,
 				       struct cifs_tcon *tcon,
 				       struct cifsFileInfo *cfile,
-				       loff_t off, loff_t len)
+				       loff_t off, loff_t len,
+				       loff_t old_eof)
 {
 	struct file_allocated_range_buffer in_data, *out_data = NULL, *tmp_data;
 	struct inode *inode = d_inode(cfile->dentry);
@@ -3758,7 +3759,7 @@ static int smb3_simple_fallocate_range(u
 		goto out;
 	}
 
-	if (off >= i_size_read(inode)) {
+	if (off >= old_eof) {
 		rc = smb3_simple_fallocate_write_range(xid, tcon, cfile,
 						       off, len, buf);
 		goto out;
@@ -3882,14 +3883,31 @@ static long smb3_simple_falloc(struct fi
 
 	trace_smb3_falloc_enter(xid, cfile->fid.persistent_fid, tcon->tid,
 				tcon->ses->Suid, off, len);
-	/* if file not oplocked can't be sure whether asking to extend size */
-	if (!CIFS_CACHE_READ(cifsi))
-		if (!keep_size) {
+
+	if (!keep_size && !CIFS_CACHE_READ(cifsi)) {
+		unsigned long long server_eof;
+
+		rc = filemap_write_and_wait(inode->i_mapping);
+		if (rc) {
 			trace_smb3_falloc_err(xid, cfile->fid.persistent_fid,
 				tcon->tid, tcon->ses->Suid, off, len, rc);
 			free_xid(xid);
 			return rc;
 		}
+		netfs_wait_for_outstanding_io(inode);
+
+		rc = query_server_eof(xid, tcon, cfile, &server_eof);
+		if (rc) {
+			trace_smb3_falloc_err(xid, cfile->fid.persistent_fid,
+				tcon->tid, tcon->ses->Suid, off, len, rc);
+			free_xid(xid);
+			return rc;
+		}
+		/*
+		 * Only use the larger EOF to decide whether we're extending.
+		 */
+		old_eof = max_t(loff_t, old_eof, server_eof);
+	}
 
 	/*
 	 * Extending the file
@@ -3913,7 +3931,7 @@ static long smb3_simple_falloc(struct fi
 			}
 
 			rc = smb3_simple_fallocate_range(xid, tcon, cfile,
-							 off, len);
+							 off, len, old_eof);
 			if (rc) {
 				spin_lock(&inode->i_lock);
 				cifsi->time = 0;
@@ -4015,7 +4033,7 @@ static long smb3_simple_falloc(struct fi
 		}
 	}
 
-	if ((keep_size == true) || (i_size_read(inode) >= off + len)) {
+	if (keep_size || old_eof >= off + len) {
 		/*
 		 * At this point, we are trying to fallocate an internal
 		 * regions of a sparse file. Since smb2 does not have a
@@ -4032,7 +4050,7 @@ static long smb3_simple_falloc(struct fi
 		 */
 		if (len <= 1024 * 1024) {
 			rc = smb3_simple_fallocate_range(xid, tcon, cfile,
-							 off, len);
+							 off, len, old_eof);
 			goto out;
 		}
 
@@ -4044,7 +4062,7 @@ static long smb3_simple_falloc(struct fi
 		 * ie potentially making a few extra pages at the beginning
 		 * or end of the file non-sparse via set_sparse is harmless.
 		 */
-		if ((off > 8192) || (off + len + 8192 < i_size_read(inode))) {
+		if (off > 8192 || off + len + 8192 < old_eof) {
 			rc = -EOPNOTSUPP;
 			goto out;
 		}


