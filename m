Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEEC837701A;
	Sat, 17 Oct 2026 17:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259725; cv=none; b=tyrKtBhoabYmNLYFYMf0PYlBGWoiaXpMUCTu9aIQi9uzdVzYumBn9pLVNptZqYm0XQRLEZfAVeal8q6qzcm5nNWt0Hdcq/deaOI7QRDqvaGr49Yj9c/JWpzierF2om9smQ75zxJ2YB+q35MwPFrVjk3VvS5USi37ETEOdyIxN0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259725; c=relaxed/simple;
	bh=OZkfL9i8dvje6eLWJ3OIwFceIGUxdgVUD2/q1PBPgE8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Th+NyLJ6OJZ0yafEduvWKhTfvKY5NUczRef81kQI/bylJk7sreQy9bwXQYxdBtfrdJN8f4wavJuAXc3vlyqwZx6zXK0W3MZ/wTdOHsuU2Uu3J0DMNB2LDUr1DPg2vUeYTKUA5zcxfwft/RZRu7/udQc8b3V41UOPfA+ZfgUF/BM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x/bw3F3q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x/bw3F3q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 412E81F000C4;
	Sat, 17 Oct 2026 17:55:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259724;
	bh=KEfpYVePBiXTmZkwUw35GRiG9swFKoapDrMaucvroU4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x/bw3F3qvC18qplCR8BvOjiuz3oGxuUwFb/FNKhpysCR2oOCO4yx4+M0f4xPcFz97
	 HxbjvPXYXOq0fe2JUMcti8xXYhs2Zq0LpbB0c88p53pxhiuNGWZgDz+DNsHqWR5+vo
	 F2QdUK/ij33bX43wmQ2azGvgd7GwtZY7C8VgkTJU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Frank Sorenson <sorenson@redhat.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1308/1674] cifs: call pagecache_isize_extended() in cifs_setsize() when extending
Date: Sat, 17 Oct 2026 17:59:40 +0200
Message-ID: <20261017160504.718443802@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 5db7b2e4a868d..1859e3ceb9a4c 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -2908,13 +2908,17 @@ int cifs_truncate_page(struct address_space *mapping, loff_t from)
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
 }
 
-- 
2.53.0



