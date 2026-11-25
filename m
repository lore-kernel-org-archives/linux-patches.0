Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623509;
	b=ty6xsgbEK4RBbMPFj9H779JMXuKPd6xlUYaodKmO14H48BwtYQyFYD/uidKttQbg8832
	 PXrODub3xAu/F9wiob3CgQQNqhRwq3d9FFHb8+O3NQUo5Mx0GcQfXiuAziFxwpuM+mZAJ
	 g7awzmEV/t3ictY+LKnDH++Yt17nwgpcLzEvm5XdTk8FxYn6Oi+1D00JP0IJcehECEYm+
	 0bl9HXaKDwf6mus6s6lbTex1o7YgEFCmkusgS+WqShBjKdvp2/ouG9UddcT2VhoGqDXu5
	 +/vv/z7yWuwG4nKz1N31+vrJ3iIwd1Q8D3IaFFcgsMzTPtNlB+DV6w35YtwkCkm6/5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623509;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xYKITj+INStKbk15oGb3SXffurbmB1h+DHbbWrhahp0=;
	b=F+h18Qso0/k3fy//ufpMw2xzfl4TN2m93Fk/B33W+2Yjxw/Wo4FsrBXF8UU32IfuqPT1
	 YXi4FWrQyKB36kJ8epKtO+DFy50pKl8GR2w6IbrJ7Rrv772JFaed1I6igS028vgyQEuRx
	 sqFopbjuFf2IbOiN50xLP0TjPyIv0NeDzPw3DHPn0sXeuKII042KQJFMw8mC2V+OFC/2z
	 SXG4xKnHVTmuXi7vtxzuccXkpO5368wwd8aym5IStpXwAnfE/wSjwr6E2NghqgcQu5j7T
	 eC9kudzSS3yf4BrB9k/nNVJptxYkViUTjIef3Vm5IEXcfWsDNRJsF8jSrBKDwaNj6WA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="pd5V/HxS";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73641606A31E;
	Wed, 25 Nov 2026 16:18:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pd5V/HxS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74EC11F000C4;
	Wed, 25 Nov 2026 16:18:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623509;
	bh=xYKITj+INStKbk15oGb3SXffurbmB1h+DHbbWrhahp0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pd5V/HxS75XtXzHfBFk3nnTZi2YysvJvJvIdYNe0QuLwRqqRZtrh4PEb05uRPDa1r
	 4sDlUmuD1MjxWd1b1YinpkjlqZ0z7K96Jz7Btd9woVAXIOwgKZs//f/aM55w6Hi37a
	 936+F+AVgYnhrGQUmo7NRQw9wU4/Z2AnJb0Sc1PY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paulo Alcantara <pc@manguebit.org>
Subject: [PATCH 6.18 838/990] smb: client: dont block dying tasks waiting for writeback on close
Date: Wed, 25 Nov 2026 15:36:45 +0100
Message-ID: <20261125143841.660362703@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paulo Alcantara <pc@manguebit.org>

commit 15ea186abbcd04157c62e0901701870b812bb2bd upstream.

cifs_flush() waits uninterruptibly for the writeback it starts.  A task
that gets killed while closing a file on a hard mount with an
unresponsive server is stuck in D state until the server comes back.  It
also consumes any writeback error for a caller that is about to exit,
hiding it from everyone else.

Wait killably instead.  If the closer gets killed, stop waiting and leave
the error bits in the mapping for others to see; writeback already in
flight completes on its own.  Don't wait at all, nor check for errors,
if it is already dying.

This is also needed before letting dying tasks issue their writes from a
worker, which would otherwise make them wait for every one of them.

Fixes: d3f1322af8f8 ("cifs: wait for writeback to complete in cifs_flush")
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/file.c |   33 ++++++++++++++++++++++++++++++---
 1 file changed, 30 insertions(+), 3 deletions(-)

--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -2856,17 +2856,44 @@ fsync_exit:
 	return rc;
 }
 
+static int cifs_wait_writeback_killable(struct address_space *mapping)
+{
+	struct folio_batch fbatch;
+	pgoff_t index = 0;
+	int rc = 0;
+
+	folio_batch_init(&fbatch);
+	while (!rc &&
+	       filemap_get_folios_tag(mapping, &index, (pgoff_t)-1,
+				      PAGECACHE_TAG_WRITEBACK, &fbatch)) {
+		for (unsigned int i = 0;
+		     !rc && i < folio_batch_count(&fbatch); i++)
+			rc = folio_wait_writeback_killable(fbatch.folios[i]);
+		folio_batch_release(&fbatch);
+		cond_resched();
+	}
+	return rc;
+}
+
 /*
  * As file closes, flush all cached write data for this inode checking
  * for write behind errors.
  */
 int cifs_flush(struct file *file, fl_owner_t id)
 {
+	struct address_space *mapping = file->f_mapping;
 	struct inode *inode = file_inode(file);
-	int rc = 0;
+	int rc = 0, rc2;
 
-	if (file->f_mode & FMODE_WRITE)
-		rc = filemap_write_and_wait(inode->i_mapping);
+	if (file->f_mode & FMODE_WRITE) {
+		rc = filemap_fdatawrite(mapping);
+		if (fatal_signal_pending(current) ||
+		    cifs_wait_writeback_killable(mapping))
+			return 0;
+		rc2 = filemap_check_errors(mapping);
+		if (!rc)
+			rc = rc2;
+	}
 
 	cifs_dbg(FYI, "Flush inode %p file %p rc %d\n", inode, file, rc);
 	if (rc) {


