Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E772563FA3;
	Wed,  9 Sep 2026 14:41:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964904; cv=none; b=XO8EzJYsCElITddasQnR+lbrGvoHm0+6IiV608oLSdVs6FQJ/8y87ZtOXx09pUxExMcv2dVVW7HjUei/0TIeu+Vmp5/z8U6AX8jNgnbJlArb8ixSNNULB6G4J+hj1jqP4Jxdcuo/YRRVt4w+pKjKCm2FcPMSG/F+/gRFnGGcGpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964904; c=relaxed/simple;
	bh=BtEQ7FLK55fWTbLm63pxBjUYm61/v3b7EIkQ8hTgkY8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CnXjgpTQvqw10lOiBTd+PJnrliY2r9Wc2U6Wb6mk62OOoSIDEeT5uayOXBQDTrqmxhnLLvywA6Y7tdt91jtL4fZ3XanUzxI5VaFlIxBP3t0zoEj3XAHvaIy1C93BP0M04bJ+Z1BDZhhObnN1r26x8y24o96gzORMboMpfgSeMxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=deFWxwC5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="deFWxwC5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9ED01F00A3A;
	Wed,  9 Sep 2026 14:41:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964903;
	bh=/FU6VmqYDvzA1/rWQqnncfnm/8Rf3mURRNL8dUjsiw0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=deFWxwC5T5RawCalrop1asGdyoy698OGUJ4nHTYqBi2tHGvk5mbE4LNepbm7jsgpn
	 bsaqY0dogP+VKRMhXPMCgfpPmR/hPihKRz10ZXlbDwcmYhdfecsXQijjA8Q8UHWtTn
	 5AoCHqsnNwNqusn8N+upJA3Jz49xSlBdZU/Q+ukA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Huiwen He <hehuiwen@kylinos.cn>,
	Frank Sorenson <sorenson@redhat.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.18 583/583] cifs: add fscache_resize_cookie() to cifs_setsize()
Date: Wed,  9 Sep 2026 15:44:28 +0200
Message-ID: <20260909134257.984738632@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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
 
 void cifs_resize_file_locked(struct inode *inode, loff_t offset)


