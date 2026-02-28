Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C53D5375AAA
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:00:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301623; cv=none; b=kxG5bMuTEPztrTGnxfKVOYyTJDGOfUoKCKiJYNQ9jQdFtEGB46Hzz6nLKWmFFDNY0SXKRG7YvZQ8jXQm5MohbR5A587oSb+KxWthC7hrt1/D/QUrW+gdX3ZoWpcUOc8sfHj+YzWFuDqNZ9jL0on2shQgZ2fiUjunHeaeLjhin2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301623; c=relaxed/simple;
	bh=EG6rL6UnqVRnBlQshjQH7lP4GQ94ULp3gioufnBCaME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gy6TsFJ36VC8vyKRl/bWV08K7VoLztxPyJ5F1aVh8hMARjd1QO0fNvyIc25ZXVejZxd+2SG9ZzWODxxKQiz1aNKOd15whj3yj4yjDwkGlmFxCtODgZIV16/orc5yfu43GxLP6dJqxcQp30LsvgV0+RCmlKTPr4mBTsRsTPx2qKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Xsu/2N3s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Xsu/2N3s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09795C116D0;
	Sat, 28 Feb 2026 18:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301623;
	bh=EG6rL6UnqVRnBlQshjQH7lP4GQ94ULp3gioufnBCaME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xsu/2N3sWRv4F3WgqTJ0yFl4r7JBKPr8AwsOgywUVQuJ/OAgNypLnL8HxizCDtsI3
	 tHzbLxce9bumRa31Y2u4A1MEpclMh0Ll6nCx8jRcfIVr4MEuVLUNkZMX1hOf0IAf6R
	 +Cj2TD2mxS/eDMjeHp25wUVWqRpPissQRiQ6IfpizjZ7iyjEsSCGuv2FD6mXF14xNR
	 qzpsqP/HeuINKdZr83nHgaQlkIrZEnRHzufLFWRP4IB3vxqc4Dp4fv2HL5iseff7Ls
	 HjVVPD+k+LHtyWMmBhIJVFD6AFdfAwPmJ+UHuGjBamBDXs/phTrLfzYtXocMu/D1c6
	 aFU/12wW3WmSQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Deepanshu Kartikey <kartikey406@gmail.com>,
	syzbot+ea1cd4aa4d1e98458a55@syzkaller.appspotmail.com,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 014/385] gfs2: Fix use-after-free in iomap inline data write path
Date: Sat, 28 Feb 2026 12:53:56 -0500
Message-ID: <20260228180011.1568201-14-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Deepanshu Kartikey <kartikey406@gmail.com>

[ Upstream commit faddeb848305e79db89ee0479bb0e33380656321 ]

The inline data buffer head (dibh) is being released prematurely in
gfs2_iomap_begin() via release_metapath() while iomap->inline_data
still points to dibh->b_data. This causes a use-after-free when
iomap_write_end_inline() later attempts to write to the inline data
area.

The bug sequence:
1. gfs2_iomap_begin() calls gfs2_meta_inode_buffer() to read inode
   metadata into dibh
2. Sets iomap->inline_data = dibh->b_data + sizeof(struct gfs2_dinode)
3. Calls release_metapath() which calls brelse(dibh), dropping refcount
   to 0
4. kswapd reclaims the page (~39ms later in the syzbot report)
5. iomap_write_end_inline() tries to memcpy() to iomap->inline_data
6. KASAN detects use-after-free write to freed memory

Fix by storing dibh in iomap->private and incrementing its refcount
with get_bh() in gfs2_iomap_begin(). The buffer is then properly
released in gfs2_iomap_end() after the inline write completes,
ensuring the page stays alive for the entire iomap operation.

Note: A C reproducer is not available for this issue. The fix is based
on analysis of the KASAN report and code review showing the buffer head
is freed before use.

[agruenba: Take buffer head reference in gfs2_iomap_begin() to avoid
leaks in gfs2_iomap_get() and gfs2_iomap_alloc().]

Reported-by: syzbot+ea1cd4aa4d1e98458a55@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=ea1cd4aa4d1e98458a55
Fixes: d0a22a4b03b8 ("gfs2: Fix iomap write page reclaim deadlock")
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/bmap.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/fs/gfs2/bmap.c b/fs/gfs2/bmap.c
index 28ad07b003484..776090fbc9aa5 100644
--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -1124,10 +1124,18 @@ static int gfs2_iomap_begin(struct inode *inode, loff_t pos, loff_t length,
 			goto out_unlock;
 		break;
 	default:
-		goto out_unlock;
+		goto out;
 	}
 
 	ret = gfs2_iomap_begin_write(inode, pos, length, flags, iomap, &mp);
+	if (ret)
+		goto out_unlock;
+
+out:
+	if (iomap->type == IOMAP_INLINE) {
+		iomap->private = metapath_dibh(&mp);
+		get_bh(iomap->private);
+	}
 
 out_unlock:
 	release_metapath(&mp);
@@ -1141,6 +1149,9 @@ static int gfs2_iomap_end(struct inode *inode, loff_t pos, loff_t length,
 	struct gfs2_inode *ip = GFS2_I(inode);
 	struct gfs2_sbd *sdp = GFS2_SB(inode);
 
+	if (iomap->private)
+		brelse(iomap->private);
+
 	switch (flags & (IOMAP_WRITE | IOMAP_ZERO)) {
 	case IOMAP_WRITE:
 		if (flags & IOMAP_DIRECT)
-- 
2.51.0

