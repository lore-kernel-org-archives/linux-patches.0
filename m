Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 610C7418368;
	Wed, 23 Sep 2026 14:23:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173405; cv=none; b=d9bumcwqKpFBwLbPaZhnYoj7WPirn8FRzbb3wagSW1U8aclXXLaBNVana4AFYHwuUZeba6PIECtuURHvCSjPY1qINH0IeJeJMtNrbO7FfqdS/lVo6YyrAoxhUz/Qt5dj0guANGPe5l6CgdEFAOsWKdeziOM8UjBeLsnnlO/RXmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173405; c=relaxed/simple;
	bh=12tA3XnDvv/xmsbEQ2TzjW/eNi0TP4e9Y+sw3POLAOw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lBFPC3qfC1jbjmHaqXl/vIpcD2I7LPN8MpMkhStV9JLi7nwuo7KbIVUDTDTAcG1+Z21zU5xX8wUnbpxWqh6XCJKL1Rj7NnAvdzdxdbDrAlzHxeLhAlUKmCgUqAY1grnVTGEezNZg48wLluTROgnfstfKynOhjkL+pzGM2/gpfSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q0qjmxlk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q0qjmxlk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 367C11F000FF;
	Wed, 23 Sep 2026 14:23:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173402;
	bh=Tvi9IuZfOmIPrkZ8IhgOGxqDXG8suWFxbpTtTLxy7Cw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q0qjmxlkiwUPz+crd6W5dHyzl+bEfnVjGT5SRoRH0Tns3+a88VZmZHwoNCkJtotcU
	 0/+ziiiWINya5TofZ90rzvjnkJPlRe1SLTE0O0ryEeAi6O31N4ULltodjs9KTJSMAk
	 FS+WGQtpeGNikyfd3lA3zPvBt2LI/4agzUvJL0a8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Mulqueen <mike@method-b.uk>,
	David Howells <dhowells@redhat.com>,
	Dominique Martinet <asmadeus@codewreck.org>
Subject: [PATCH 7.2 236/438] 9p: Fix v9fs_issue_write() to update i_size and remote_i_size
Date: Wed, 23 Sep 2026 16:04:17 +0200
Message-ID: <20260923140650.889977952@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

From: David Howells <dhowells@redhat.com>

commit c60ae98c5aa64021751b38ab1313b19d620bf640 upstream.

Fix v9fs_issue_write() to update i_size and remote_i_size to the new size
of the server file if we made it larger, using the start fpos and the count
returned by p9_client_write() to calculate the new minimum file size.

This assumes that if the 9P server makes a short write (say it hits
ENOSPC), a reduced count is returned.

Fixes: 5fb70e7275a6 ("netfs, 9p: Implement helpers for new write code")
Reported-by: Michael Mulqueen <mike@method-b.uk>
Closes: https://lore.kernel.org/r/fbb9e395-1e07-4212-8f70-23f3cd498074@method-b.uk/
Cc: stable@vger.kernel.org
Signed-off-by: David Howells <dhowells@redhat.com>
Message-ID: <2226525.1789118704@warthog.procyon.org.uk>
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/9p/vfs_addr.c |   28 +++++++++++++++++++++++++++-
 1 file changed, 27 insertions(+), 1 deletion(-)

--- a/fs/9p/vfs_addr.c
+++ b/fs/9p/vfs_addr.c
@@ -54,11 +54,37 @@ static void v9fs_begin_writeback(struct
 static void v9fs_issue_write(struct netfs_io_subrequest *subreq)
 {
 	struct p9_fid *fid = subreq->rreq->netfs_priv;
+	struct inode *inode = subreq->rreq->inode;
+	struct netfs_inode *ictx = netfs_inode(inode);
 	int err, len;
 
 	len = p9_client_write(fid, subreq->start, &subreq->io_iter, &err);
-	if (len > 0)
+	if (len > 0) {
+		uoff_t end = subreq->start + len, i_size, remote, zp;
+		bool set = false;
+
+		spin_lock(&inode->i_lock);
+
+		/* We can read the sizes directly as we hold i_lock. */
+		i_size = inode->i_size;
+		remote = ictx->_remote_i_size;
+		zp = ictx->_zero_point;
+
+		if (end > i_size) {
+			i_size = end;
+			set = true;
+		}
+		if (end > remote) {
+			remote = end;
+			set = true;
+		}
+
+		if (set)
+			netfs_write_sizes(inode, i_size, remote, zp);
+		spin_unlock(&inode->i_lock);
+
 		__set_bit(NETFS_SREQ_MADE_PROGRESS, &subreq->flags);
+	}
 	netfs_write_subrequest_terminated(subreq, len ?: err);
 }
 


