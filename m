Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F1FC313527;
	Fri,  7 Aug 2026 15:10:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115409; cv=none; b=r1dS8Q49SSTASJ6UpBlqc+0CX5n8Utb3kzbr+mYwV02ahinLd/YeanpYQiOQYgfiu/cdI38+McFwwJVa/Fg2pKipso30TbxudnnOPAt8+cp61hVFXvy+Z+V6Xm8mYGQ3qq2roAX4rod00FjYExc7W28+NpJXl+T/xhs82oAuIwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115409; c=relaxed/simple;
	bh=UopydtEQplYs0xt0RTGxU1YdOoOU2ji+KQEWkNTR4cI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fU0QP4RfhTfnu0fmcKjq1FNLTO+X2PZO9ZhM7pSWZfxWvrH0VuZ8qAwbKjxF4oLDqDK1iGB75R2gaKe7FmGZeyifU5dOmvWhAXU92pykps3QjUGkXDmstix3Ch98fqIoq0dMQmXIQN/LKcMOfUwgLh/rNrvX3wRIR9Yyo7zOMRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jY7xXOSC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jY7xXOSC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AF9B1F000E9;
	Fri,  7 Aug 2026 15:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115408;
	bh=iA7vOpl0D3U/3bJmleKv9omS4gfHtzLh9+gFz95oT5M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jY7xXOSC3PFbr6ZycAuwl3PF8Pxv71p8GM6AcrkwoXWCCv9TiQyHINbwh/VP8XTxu
	 8N0gOOz9eMUqTQn9bHsDfYsWcxN834hXQy6GT66e85GG6nyv9YjMEi4IFRVcRMKqB7
	 ByG0/H2oizE2xLK/t/dPX/glXGkdNcwSmj9Ttnr4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Huiwen He <hehuiwen@kylinos.cn>,
	Frank Sorenson <sorenson@redhat.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.18 265/396] cifs: add fscache_resize_cookie() to cifs_setsize()
Date: Fri,  7 Aug 2026 16:37:05 +0200
Message-ID: <20260807143429.974085350@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

From: Frank Sorenson <sorenson@redhat.com>

commit fa724e235cfdb0fb0bb427d0f9dfe864ae27403e upstream.

Several code paths update the VFS inode size by calling
netfs_resize_file() and cifs_setsize(), but omit the corresponding
fscache_resize_cookie() call, leaving the fscache cookie out of sync
with the actual file size:

  - cifs_file_set_size() in inode.c: server-side truncation via setattr
  - cifs_do_truncate() in file.c: truncates to zero on O_TRUNC open
  - smb2_duplicate_extents() in smb2ops.c: file clone extending EOF
  - smb3_simple_falloc() in smb2ops.c: two branches that extend EOF
    via write-range and SMB2_set_eof respectively

Since every caller of cifs_setsize() must resize the fscache cookie,
add the call to cifs_setsize() itself, consistent with how
truncate_pagecache() is already consolidated there.

Fixes: 70431bfd825d ("cifs: Support fscache indexing rewrite")
Fixes: 93a43155127f ("cifs: Fix missing set of remote_i_size")
Fixes: 110fee6b9bb5 ("smb: client: fix missing timestamp updates with O_TRUNC")
Fixes: 7a06d3b816d7 ("smb/client: emulate small EOF-extending mode 0 fallocate ranges")
Cc: stable@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>
Cc: Paulo Alcantara <pc@manguebit.org>
Cc: Huiwen He <hehuiwen@kylinos.cn>
Signed-off-by: Frank Sorenson <sorenson@redhat.com>
Reviewed-by: Paulo Alcantara <pc@manguebit.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/inode.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -3039,6 +3039,7 @@ void cifs_setsize(struct inode *inode, l
 	inode_set_mtime_to_ts(inode, inode_set_ctime_current(inode));
 	truncate_pagecache(inode, offset);
 	netfs_wait_for_outstanding_io(inode);
+	fscache_resize_cookie(cifs_inode_cookie(inode), offset);
 }
 
 int cifs_file_set_size(const unsigned int xid, struct dentry *dentry,


