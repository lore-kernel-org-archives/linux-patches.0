Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E22947ECC6;
	Thu, 20 Aug 2026 17:32:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247149; cv=none; b=Y1Z8tOleOxt4yi5NiVY7SrxwlVpqi5KfHBUIJF0Nnt2I6o8MI6AGMMsHxonawY6x61Oug0jWWdvilixihGuD/Vv1v5k7HB4koE7qJ0pkv2Q4YxQr2+7JMv/U9k1zfzQg2g/a2lVKOlnZ7D6PSFbz7JE1de4ANgvsoK7nkKnksCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247149; c=relaxed/simple;
	bh=n/6dq9plsJAzyROaxy1c0+xKIxeiptbzNgS386EDQy8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fiaZ0kfSW4jpYV1z20mPPHXe+jLiSUqTIhbjnNvCUXd7PkGwFlMzoOhxozNVzY7vKpT0NU4u4mBgdhzxR6DL1MrO7+7DHY6gkN2Z2Kz/DbY2J3Dny35fCg8n0iQ7uAPpfB/5FidIq0gtl740DlpsB8yjOVk41JSapWjoYXW/kKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mBIdkW+9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mBIdkW+9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D5611F000E9;
	Thu, 20 Aug 2026 17:32:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247148;
	bh=iWZKcFFCD4BbMrvO8tV5BYlYeGTEecdngUkq5gVrRTY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mBIdkW+95KjESMkbxzZ2MRv6Z04Je9XYkfjLFu2Bw1FyCCQHJVmRidipt5+MlKW/0
	 t9U6zj3W9f17GImoJAYIjnfOtMj2iN8gBKnlJioh+ukOwOxqU92xmGpKp9oIHJIGjA
	 sGgAa6o4/8FWlNwhgYSfhwUN1H4BwuD2P/gv80dM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Huiwen He <hehuiwen@kylinos.cn>,
	Frank Sorenson <sorenson@redhat.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 166/220] cifs: add fscache_resize_cookie() to cifs_setsize()
Date: Thu, 20 Aug 2026 16:55:56 +0200
Message-ID: <20260820145228.465691865@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145223.480031205@linuxfoundation.org>
References: <20260820145223.480031205@linuxfoundation.org>
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

From: Frank Sorenson <sorenson@redhat.com>

[ Upstream commit fa724e235cfdb0fb0bb427d0f9dfe864ae27403e ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/inode.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -2966,6 +2966,7 @@ void cifs_setsize(struct inode *inode, l
 	cifs_i->time = 0;
 	truncate_pagecache(inode, offset);
 	netfs_wait_for_outstanding_io(inode);
+	fscache_resize_cookie(cifs_inode_cookie(inode), offset);
 }
 
 static int


