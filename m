Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA1E44EE858;
	Tue, 13 Oct 2026 12:18:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893918; cv=none; b=MCl6IOP9vnF80NOCsiaiRHe63sZJc+oJt2V3/yQRNFYVqWMCst72bs3R4xOow9zFC/p1tXMcImkgMNtw+vGKPh/9yW2II/J35IzqWU77SkLV4OKRkwHQHe7w8J6HowK9GDzN9cczYFdjry9GrI/oqZPlNioSIJIWr/rUa50BRlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893918; c=relaxed/simple;
	bh=Rcby63QwQ4Urkqyq/nvLWSls/Qtx22ANPyr1bel27kk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=apksf4szDiRsGvN7VdU+ecOZ+lNHMa0i0THNy9fDCwXn5KYAIH+izjH8+ur2+KFQKGUp9peoN12+xAd+2zuUQ8yubJR4w3+uOMhvgjTwrv6LxmTGnDwGoweJWjXVr/qmiiLtabkhSVG68eOdMLkK5qHqhwxizqOs1MPH5eRVoZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ezLbBspG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ezLbBspG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36BE11F000FF;
	Tue, 13 Oct 2026 12:18:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893917;
	bh=tmp/jXIJxdp3aKCoWtA/WkuL3qmOZCqQrF6ey3Wck2E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ezLbBspGBBAKqp8dXP/yNzMmj4JgPIBUlbuAU+Z5kLsoMzLedtUPqGOsJj3q6lOja
	 AgZt5uLpSPJIeBECXw8XGo4AltWRQDovSCK5DubW4WLKB4hAR6dLQpBP+6Qw036/xL
	 eZw6ln80lnULLxwyBSFCZ0xFVJv7CwMohd30WQ0Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Frank Sorenson <sorenson@redhat.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 384/621] cifs: call pagecache_isize_extended() in cifs_setsize() when extending
Date: Tue, 13 Oct 2026 13:36:19 +0200
Message-ID: <20261013112929.957120662@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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
 fs/smb/client/inode.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index ebc3edf33d20e..ade7ecb3f350b 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -3030,7 +3030,10 @@ int cifs_fiemap(struct inode *inode, struct fiemap_extent_info *fei, u64 start,
 
 void cifs_setsize(struct inode *inode, loff_t offset)
 {
+	loff_t old_size;
+
 	spin_lock(&inode->i_lock);
+	old_size = i_size_read(inode);
 	i_size_write(inode, offset);
 	/*
 	 * Until we can query the server for actual allocation size,
@@ -3039,6 +3042,8 @@ void cifs_setsize(struct inode *inode, loff_t offset)
 	inode->i_blocks = CIFS_INO_BLOCKS(offset);
 	spin_unlock(&inode->i_lock);
 	inode_set_mtime_to_ts(inode, inode_set_ctime_current(inode));
+	if (offset > old_size)
+		pagecache_isize_extended(inode, old_size, offset);
 	truncate_pagecache(inode, offset);
 	netfs_wait_for_outstanding_io(inode);
 	fscache_resize_cookie(cifs_inode_cookie(inode), offset);
-- 
2.53.0



