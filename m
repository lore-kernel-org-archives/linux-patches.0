Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2D323D9DDB;
	Fri,  9 Oct 2026 14:46:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557207; cv=none; b=Z137DjhnAy7PZ04e0lvW0sgWflqRYTJ99TQVbUy+lrE26URNY4hgaBSGMPaDvXHGBdN38pXCZ0vxQOmutLeriwLRZ7hQN/e5Vst7ABNYkJ3NrUw4EA8lYBE26wuamLf5ZlxPtiXAvyhWkGyLsavewrcQHq7LjjFEhgG1ZK+wDXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557207; c=relaxed/simple;
	bh=/6mycuUMpu5QtlgNaB6EyGQKjjImqSJwVrJTKsqCB6o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Clp5/DDHxPoujh1eryesE65Nv5A7oqtXSIMgwpltAfbrWk5+o+E1We4om2PLBjO87zlz4C9P4GZ76H/sRZv7SUsuuuQCmSEUCpZmZmIegWTNuIp3yrGrfSuIyatUi6iSoJKk6UdJlwHMb0pjI6XMFo40BWUi2368EA3DJpZsOeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M8chMjv6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M8chMjv6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 146EE1F000FF;
	Fri,  9 Oct 2026 14:46:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557206;
	bh=DdJSsBJ6V4lLtwXTmbaCpxZnh1OWHAY/HRHXpRdq8E0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M8chMjv6BaKpJx9DTmKCrzEnjdPi4N8+CxexDZOVMePUd1Vdo1CTp3boi+INKWZo1
	 vFTAMvz9Qoutzx244B1nZNRJY3UTQNiapc01PDNURIoLdaoS7/PmR2hT1wSrYWPG2r
	 ISheEygb2Fvx57Mn75axCw7HKbP8DGburLNKabbM=
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
Subject: [PATCH 6.18 364/403] smb: client: flush dirty data before zeroing a range
Date: Fri,  9 Oct 2026 16:12:05 +0200
Message-ID: <20261009141000.803255476@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

From: Paulo Alcantara <pc@manguebit.org>

[ Upstream commit 8f8d32c1044f70e46e87550e039a15ff20a4b21c ]

smb3_zero_range() emulates FALLOC_FL_ZERO_RANGE by invalidating the
page cache over the target range with truncate_pagecache_range() and
then issuing FSCTL_SET_ZERO_DATA to the server.

Dirty data was only flushed conditionally, when the range reached or
extended EOF.  For a purely interior zero range that does not reach
EOF, no flush happened, so a dirty folio overlapping the range could
be written back to the server after the FSCTL and refill the range
that was just zeroed with stale data.

Fix this by unconditionally flushing and waiting for dirty data in the
range before invalidating the page cache and issuing
FSCTL_SET_ZERO_DATA, exactly as was done for smb3_punch_hole() in
commit d7d2adcd022b ("smb/client: flush dirty data before punching a
hole"); the two paths are structurally identical here.

This is observed as generic/363 randomly reading stale data where a
zeroed range is expected against Windows Server.

Fixes: 91d1dfae4649 ("cifs: Fix FALLOC_FL_ZERO_RANGE to preflush buffered part of target region")
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
[ sashal: Retained i_size_read() instead of netfs_read_sizes(). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/smb2ops.c |   16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -3485,8 +3485,7 @@ static long smb3_zero_range(struct file
 	struct inode *inode = file_inode(file);
 	struct cifsInodeInfo *cifsi = CIFS_I(inode);
 	struct cifsFileInfo *cfile = file->private_data;
-	struct netfs_inode *ictx = netfs_inode(inode);
-	unsigned long long i_size, new_size, remote_size;
+	unsigned long long i_size, new_size;
 	long rc;
 	unsigned int xid;
 
@@ -3505,14 +3504,11 @@ static long smb3_zero_range(struct file
 	filemap_invalidate_lock(inode->i_mapping);
 
 	i_size = i_size_read(inode);
-	remote_size = ictx->remote_i_size;
-	if (offset + len >= remote_size && offset < i_size) {
-		unsigned long long top = umin(offset + len, i_size);
-
-		rc = filemap_write_and_wait_range(inode->i_mapping, offset, top - 1);
-		if (rc < 0)
-			goto zero_range_exit;
-	}
+
+	rc = filemap_write_and_wait_range(inode->i_mapping, offset,
+					  offset + len - 1);
+	if (rc < 0)
+		goto zero_range_exit;
 
 	/*
 	 * We zero the range through ioctl, so we need remove the page caches


