Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6CD8531629;
	Wed, 23 Sep 2026 14:54:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790175258; cv=none; b=pqxJQNTji/OBDBtwye9dfxJ4EaS4AQu0+zwvf1bNBhgH/5ZxTGr8zhMtcbEgICIjcZlzc7RvrOrmWXzU458bX1d74FUw5VoMDQtIjFUD2KqgJ8YC+JGm2Eyl7hw7mkErkVgZzn0ArgRPy63F0jb8WQOti6dG+Nnlip2+4SUznOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790175258; c=relaxed/simple;
	bh=9u+n+D54IuASfowQu3ugw+HQkymptlPzpi5RgzGnuYY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P6rFkxJ7iNRVb9sXaxIKeHUVe2lM/HDrRnJdLvF3pPU4bc90jw9Jj1d2Pn9amCsPbKWIW5euxqR+8mzHt3zu11Mf9H5qUvsU8dMla+WppsA5CZ6nxsdohC8dD16J3cLwXKw6aOcddTfHGR7zdkbXflYVgXtep4r+2JqHlSQRwd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kjqUf/oa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kjqUf/oa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 386E41F000FF;
	Wed, 23 Sep 2026 14:54:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790175256;
	bh=19ONBblEunK/qAamDYlTDKyxMKKjykgLUVFDZ2wkTx4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kjqUf/oaawXN30tZTdp0Z170U7EYaNMIkG4wsnrZrztJ5fMPU7gjZgzothz9k0EcH
	 rZOiZDmn35VZjAARqY/iLZ6N1kv+1zEi6yBhGSb5jx5vKZh8IBwoe/OJBhqazJB3hT
	 hXPUoJAz/yO0a8ZRSmqJCXFoGsBx26UmcY/DHe74=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Mulqueen <mike@method-b.uk>,
	David Howells <dhowells@redhat.com>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 371/398] 9p: Fix v9fs_issue_write() to update i_size and remote_i_size
Date: Wed, 23 Sep 2026 16:07:25 +0200
Message-ID: <20260923140653.062509691@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

[ Upstream commit c60ae98c5aa64021751b38ab1313b19d620bf640 ]

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
[ replaced unavailable netfs_write_sizes() with i_size_write() and direct remote_i_size assignment. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/9p/vfs_addr.c |   29 ++++++++++++++++++++++++++++-
 1 file changed, 28 insertions(+), 1 deletion(-)

--- a/fs/9p/vfs_addr.c
+++ b/fs/9p/vfs_addr.c
@@ -54,11 +54,38 @@ static void v9fs_begin_writeback(struct
 static void v9fs_issue_write(struct netfs_io_subrequest *subreq)
 {
 	struct p9_fid *fid = subreq->rreq->netfs_priv;
+	struct inode *inode = subreq->rreq->inode;
+	struct netfs_inode *ictx = netfs_inode(inode);
 	int err, len;
 
 	len = p9_client_write(fid, subreq->start, &subreq->io_iter, &err);
-	if (len > 0)
+	if (len > 0) {
+		unsigned long long end = subreq->start + len, i_size, remote;
+		bool set = false;
+
+		spin_lock(&inode->i_lock);
+
+		/* We can read the sizes directly as we hold i_lock. */
+		i_size = inode->i_size;
+		remote = ictx->remote_i_size;
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
+		if (set) {
+			i_size_write(inode, i_size);
+			ictx->remote_i_size = remote;
+		}
+		spin_unlock(&inode->i_lock);
+
 		__set_bit(NETFS_SREQ_MADE_PROGRESS, &subreq->flags);
+	}
 	netfs_write_subrequest_terminated(subreq, len ?: err);
 }
 


