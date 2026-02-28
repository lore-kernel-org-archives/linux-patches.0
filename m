Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 709563A2AEE
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:17:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302667; cv=none; b=jHu1Yya0+/UVN4LwLeQBXhnlrL7NcP2n45tExM9+NDaq+5O3n0atmRvcV5s+U8fZDAnus9NEKEmdM0FuKuFt6IONvA7XU22DrwzM48BY/r1a/j9KH/+kVlQ81os6WeEipGfSSoLWRSV/lZzY+2Iia1kB9AmRp3KpxTIHBZ/9BNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302667; c=relaxed/simple;
	bh=D0JuzD0UYNCYJnmg7Qaij4uP3+/Spy2cFWysCyh3qPo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dXr+cEFsLbUxr5JzfsyacQqxnTGSgwWH1YtLAKRh6rc3b6BEo0ZwvYsYjXkO4HbkjdOLQvQ3b29Il2JXwo30m5KWFlnHgnLGdfdDm04CU/pi0sLuVukC0o71oRf3YI51Muyoa/omEYGWXzwN3IbsaH8FHHwgGFGbS5ohw8Fb3HM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J/ukziNr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J/ukziNr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C36E5C116D0;
	Sat, 28 Feb 2026 18:17:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302667;
	bh=D0JuzD0UYNCYJnmg7Qaij4uP3+/Spy2cFWysCyh3qPo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J/ukziNr059KZOrxTB4SyZTS3f7W2jcEA7EMSZSKmOUHRkrIDrtmqDEZuBZgihW1W
	 iPBNzzasILNm5cPnbwcHPT7cjr5ZhIk9hC0bEhm+3VYyu+CMRyzCBpRRPdFk7QPDX8
	 xI986UqZkY+5Ii/UDffPryRpsqAQr+NOPrg1qCKz01gmuFyzO6nUM48D89z1Msw6m9
	 nCgZiMSaQqcAF55YylAv2FGAMu2GVrSWyrEmqihiJdg+Cy3k/OZzKOiH2hlogv9IWo
	 AyfDP7bfN1ohyteXTcAZb1dpvIZ3LzomI8gwxU0YTyv5E/3Owk8hRHW+joXDQZbzKp
	 uz0WLkuCP0+hA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Deepanshu Kartikey <kartikey406@gmail.com>,
	syzbot+ea1cd4aa4d1e98458a55@syzkaller.appspotmail.com,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 014/147] gfs2: Fix use-after-free in iomap inline data write path
Date: Sat, 28 Feb 2026 13:15:22 -0500
Message-ID: <20260228181736.1605592-14-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181736.1605592-1-sashal@kernel.org>
References: <20260228181736.1605592-1-sashal@kernel.org>
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
index 1e0e350b5a5a5..10b0151b2789d 100644
--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -1115,10 +1115,18 @@ static int gfs2_iomap_begin(struct inode *inode, loff_t pos, loff_t length,
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
@@ -1132,6 +1140,9 @@ static int gfs2_iomap_end(struct inode *inode, loff_t pos, loff_t length,
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

