Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625952;
	b=M+d8XrbS2c3cK+hXbAyGAujFGq2nMy/5wIRQ7cckAAgjfbRkODch6cVAiTVEPrvcHV31
	 ogHn751senY3bUL6hH9nR2MdEavqCjbF4+auny2EgXvDisNihyyaeppRIZ6jqgQx0Z2K/
	 QDaJ2ylqVC9Tjgg/OTrHmamm5xybfQP0nmVWm1BU7Gkz7SKqIq+KtZCWDOSzLaeTpe1D9
	 86KJs02aG0XH/Fb2sMuhJcdiUFqt36YSm5xBC/8IltG2XANjfnGskI9ZleG0EwXH8c7rV
	 n2fxOO6Qprg1xaYfUPtPrdWV6wwoAk+uf8GbHEmXqJO9PEm/OzrrQoYVr55lGenbJIw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625952;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Z8DKk5hSkfMTqOpzArGU17GrilfHza4XbA0/IRFMsl8=;
	b=y0uRhVLDWWaAfk1BZzGEptoJMDmg2D/MiIh68/sHMG3mklRfJd1bXWtJLGNLmPHpF/eU
	 S39jesYc5L1OSWidUa9yyJ342OFbeOD7rfMajTrEVkfvghuAXs3vEBsLknQ9jdMQbTQjw
	 dqbwyf7LorqJrSjvspEwUuSSaVR5clDJVY+RoOQGe6J3IaXFxcLuFmnwSEKh7/fXPfLHl
	 p/TE4AgaNYM3/BhOVH2CKRHJ5jrVoGytd57xhGR7L/mssVxgvmJzicrF/cJxYErxplx2G
	 Mim5WNbhqAHPpwrriDs9p+OgMXTyt5+ZqJHR2d3/S27S9yxF/0rnL4fq2Sm1PPFGE4g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fXR4bcfW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A363606A329;
	Wed, 25 Nov 2026 16:59:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fXR4bcfW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD0CC1F000E6;
	Wed, 25 Nov 2026 16:59:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625952;
	bh=Z8DKk5hSkfMTqOpzArGU17GrilfHza4XbA0/IRFMsl8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fXR4bcfWGjcv91K8/bLZNlUj7HjxSo9/OI6wpcTgB6AyT+QayIcNGHDEo5rMQhVxb
	 +YSwnvwssM2mkSjI4bLSpSwp0vrr/kyWQaUxLl7ba/4x37If2BLehMR8VAcF3RSgFZ
	 DWxgbb9/ZPON3flG+OWj/F3VC0WuJxwQvl+yCiS8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paulo Alcantara <pc@manguebit.org>
Subject: [PATCH 6.12 683/816] smb: client: dont block dying tasks waiting for writeback on close
Date: Wed, 25 Nov 2026 15:37:11 +0100
Message-ID: <20261125143904.991200985@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2760,17 +2760,44 @@ fsync_exit:
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


