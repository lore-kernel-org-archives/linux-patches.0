Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E9335616AC;
	Wed, 30 Sep 2026 17:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790417; cv=none; b=Dt6RYQ/YuH9HNi9pcZTfFd+Kg4jd4dcwbGHkX7i/jF9uFUWQ6l2ocP2L+0MfcmPYxLuqkGt4dy+aYjTVzS6/z/K26DANsiGMb9kd4RczBal7oQHk8zVehelYiiyMMiQKKKDnYo/V4PSwkhbxwEUIihxnO2qRaZ49g6MfOc5Rs2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790417; c=relaxed/simple;
	bh=3AFklLwYwuMGctkRPMW3PUse8U1N6qdKb1fJKZ3fTVo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P0wgLlTKGJ+f3RBh4QBFxF8Qc7o8AVc5qvGtZ6Hn3NCCxd/0Ll+qjvKupO5RMEOQtNvkrc2ILZohmLpRSn0ZSLAOBgUkyW/hLmUtl85VOyKzpyq3/NmkzYJaDIb7ow8c2xw3ix6d0SOzATbkE6XsRe2Sls1WCrVJ4b6xYzj0y+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J8N/9wmA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J8N/9wmA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BF6C1F00898;
	Wed, 30 Sep 2026 17:46:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790414;
	bh=vRMu3mZotXpFGuNv/qJON8ZZjBt0+qb/5Td1kpHnHPk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J8N/9wmAGfwBMun/rKLwd48b3VXbVdHFekXdqqaBjQY2qPmA0G4bZ2Ci8Cmf/qH+2
	 r99Ayg7cJldLgnvyspkdhJmd1ZbUrgVhk20ok6u/hK9kBXyYE4f1/wZ6N44kHgXx3Q
	 tlW4z/8OWwNTwKBzK9ucirdl8BMmgte0YF5FWdW8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Mulqueen <mike@method-b.uk>,
	David Howells <dhowells@redhat.com>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 784/877] 9p: Fix v9fs_issue_write() to update i_size and remote_i_size
Date: Wed, 30 Sep 2026 17:28:15 +0200
Message-ID: <20260930152431.632832608@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
[ replaced unavailable netfs_write_sizes() with i_size_write() and direct remote_i_size updates under inode->i_lock. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/9p/vfs_addr.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/fs/9p/vfs_addr.c
+++ b/fs/9p/vfs_addr.c
@@ -54,9 +54,21 @@ static void v9fs_begin_writeback(struct
 static void v9fs_issue_write(struct netfs_io_subrequest *subreq)
 {
 	struct p9_fid *fid = subreq->rreq->netfs_priv;
+	struct inode *inode = subreq->rreq->inode;
+	struct netfs_inode *ictx = netfs_inode(inode);
 	int err, len;
 
 	len = p9_client_write(fid, subreq->start, &subreq->io_iter, &err);
+	if (len > 0) {
+		unsigned long long end = subreq->start + len;
+
+		spin_lock(&inode->i_lock);
+		if (end > i_size_read(inode))
+			i_size_write(inode, end);
+		if (end > ictx->remote_i_size)
+			ictx->remote_i_size = end;
+		spin_unlock(&inode->i_lock);
+	}
 	netfs_write_subrequest_terminated(subreq, len ?: err, false);
 }
 


