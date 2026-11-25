Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620184;
	b=ne/NPK/8m8bl9mlk1Z4vw4qpfXFKyGqviO/0Lk4+mCX13u5QoGkuWv3Z5zasQiCcV997
	 hRSznRIUDb1V/0atbJqZacxq2NNL3EJZRXLKXoG/dTNG1/tvQMaDPjoCneut02x2gT0QX
	 QZ/HTEY60YQcGOIYvEk3xsijCmLVjwhjamWfIt/byZGOuCa7AoLufh5BeGQ/KNQRWtNlk
	 9ssrUg9rcYDjC+TsJasm4plklxR7QGeGa7wio297ivxpI1QLxeGidcPQSMLw3JC3QeDmU
	 kDB74RsVY755l6sX/iO9Lt/ww/ni5W5bCvU3gZSEY1tpWL3Yi02G5yuoQzRbx0cw3tg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620184;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rhkzmKOiwbliMpmqInI+etKHFnbfXrBOKB7lwvyXHB8=;
	b=i/VDBv/6ZibxJRaflvRf6E0lnT7UWaaBHe90exVZUXxipt6+hWFwWsmFemUxzWGCiu4a
	 thdlCdyAF+L7RZWTj1HDoIlKAKugL9oG1OWKqOKJ3YD4OgOm0NXkzpmM3uiYpM8CI8Kb0
	 6HK0Cz+9nXSUxV24YwYlu+N5jIrsBnPUkH2rMIcC7+wQMYkAGHpOnTr4J4ZXPl/iAPuVi
	 LNfaS4fukhTQvvfT6Oq3q+Xj8YiqpJT3PEUHXAJRRXy7DNHHXBOEPqyHVge2TRvIgmrEC
	 /5auce/8MB01PGl7S0X/DnF6vw6+Aae9Cn72B9k3Npqz7W19GuefoQPOv1wgtRZTSvg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xTl1sz2v;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74303606A321;
	Wed, 25 Nov 2026 15:23:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xTl1sz2v
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85F9C1F000C0;
	Wed, 25 Nov 2026 15:23:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620184;
	bh=rhkzmKOiwbliMpmqInI+etKHFnbfXrBOKB7lwvyXHB8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xTl1sz2vsH7fsr32q784goPrFnstrwmHJvcYQIGgcRh4qOIqTUiyv5f4uCSdbSwUM
	 3TVEnZ/7PzB0JjtIFCm9PZXel0H754f6/92ZV+83HXFDhsp8CH/AOH4tXrqztGIVwN
	 9y58BRB9OZwaaJAFtt3/h3S7acGzk4UA3AhYm3kY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paulo Alcantara <pc@manguebit.org>
Subject: [PATCH 7.3 0834/1005] smb: client: dont block dying tasks waiting for writeback on close
Date: Wed, 25 Nov 2026 15:36:12 +0100
Message-ID: <20261125143841.258077495@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2955,17 +2955,44 @@ fsync_exit:
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


