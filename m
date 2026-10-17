Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 440927404E;
	Sat, 17 Oct 2026 16:33:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254810; cv=none; b=oIULuDtnO2QkEYhG+LMYhPbqIO2ir2j3LPG9yptFvzPDeCimh9LpueXb6TWcQciUniw3L6LsIleuD2boNlf4BmQCf3uiL6VHMr/KnqnVwheHFVIztAtXMll+V1pL0hF/JiTDGmWC2k24ff+/Zmv2Ciaco5CYNhVFMSTlusPVghE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254810; c=relaxed/simple;
	bh=T7sCPzNCe+mXpc8rIGQpMdN4sqXYi3Ql+IU+ZMYzu0k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UTXiOMUwQ1vLcFKWPJAVgWPoUsCheoERYQST2rdXbYyMeErlUiaAnAB9pVfRZaLwzQS2cHmqwlU0H+QBKISEHZuKwXLk/CAWQU8cAAxXCUzbSPf3ptp4fFjG4zMcCxlc77+ZFtHDzUB42zPdIMjhOOOIiKQ/WNlwoDcnqB/YO1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WHQheJOs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WHQheJOs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 990461F000C4;
	Sat, 17 Oct 2026 16:33:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254809;
	bh=vewQErBjKRzP1DMyeLilcX9/8GDkKk1gbj64G9qDbuc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WHQheJOsznfo81TqjYIglkFfKb5Qzkf4kZxiCENzu2Kc2fUNvPNNcf6wWyxJVNssb
	 LO0Q0gri3AC4jGNSA4lWEt6XMb6b/o79FYj79ApaFKulDvoJxSDPB3BgrmC09eHONP
	 +XCs4KdB5aB7S3WxinEc1Pl09Hd4RxV3PFMZMlGo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Frank Sorenson <sorenson@redhat.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 570/869] cifs: call pagecache_isize_extended() in cifs_setsize() when extending
Date: Sat, 17 Oct 2026 17:56:51 +0200
Message-ID: <20261017160051.683790565@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

[ Upstream commit c510edb9734af1c274d18f4f31a471a166bbc7e8 ]

cifs_setsize() calls truncate_pagecache() but skips
pagecache_isize_extended() on extension.  truncate_setsize() shows
the correct pattern:

  i_size_write(inode, newsize);
  if (newsize > oldsize)
      pagecache_isize_extended(inode, oldsize, newsize);
  truncate_pagecache(inode, newsize);

pagecache_isize_extended() zeroes the tail of the page straddling old
EOF.  Without it, dirty bytes in that region can be written back to
the server, exposing stale data in the newly extended range.

Cc: stable@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Frank Sorenson <sorenson@redhat.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/inode.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index db8a96e04e4d7..e75ac895d3b4a 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -2959,13 +2959,17 @@ int cifs_truncate_page(struct address_space *mapping, loff_t from)
 void cifs_setsize(struct inode *inode, loff_t offset)
 {
 	struct cifsInodeInfo *cifs_i = CIFS_I(inode);
+	loff_t old_size;
 
 	spin_lock(&inode->i_lock);
+	old_size = i_size_read(inode);
 	i_size_write(inode, offset);
 	spin_unlock(&inode->i_lock);
 
 	/* Cached inode must be refreshed on truncate */
 	cifs_i->time = 0;
+	if (offset > old_size)
+		pagecache_isize_extended(inode, old_size, offset);
 	truncate_pagecache(inode, offset);
 	netfs_wait_for_outstanding_io(inode);
 	fscache_resize_cookie(cifs_inode_cookie(inode), offset);
-- 
2.53.0



