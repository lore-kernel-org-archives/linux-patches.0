Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 799FB26056D;
	Wed, 25 Feb 2026 01:41:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983717; cv=none; b=VFHzIrXslUsBOaQ2cXxgFn/pw/WrvTo8pv66syU4p7Ucejb6Ul5MiZm7vIXuHv18Ldx1EVm0VeovyfAUQOxy/hn8cY6dThvwJZQmdRmbc3QQAfwXLQMs5+Lw/s4EYEiVJdgzkqL+bWAiTLDZneGWKvDgVM66RPndH1/We/09ieI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983717; c=relaxed/simple;
	bh=Bka3rrZhPMbT2lB7/ZqTJJGRenrsywcFI/01M1ahDgk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OwN6H17GzVJm7SsgQ0jc+GIA4tB465ZGB9NgmZW0gxppNPcwiz78kOyRHJ+O6jRwEzQWOjMmaPH12w/HerY6EAYMGT0TtNVzD+ALtYChP1Jwv9Ycroj2QdUaDwWR4MEzrHhdzAkg+qICi0I3r80XYKmWs7nht+GBpmcjRGL63Zs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sQdvSRlT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sQdvSRlT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42D70C116D0;
	Wed, 25 Feb 2026 01:41:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983717;
	bh=Bka3rrZhPMbT2lB7/ZqTJJGRenrsywcFI/01M1ahDgk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sQdvSRlTEO2kU38jsgMogyJUdWTzyZK+70CD5jM5UtIMcL1k+kviXeun/ntKKdZBV
	 /xdjwvuR487CI9MlccdDmAltYHGTZ/GDzXiKF9ZzVIHlpWBVcPQOHpW6cIpJebvA9F
	 ZUrb/CaATlRctop+DiBIk6FTt3LPLV55bWeOVRNU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+ea1cd4aa4d1e98458a55@syzkaller.appspotmail.com,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 015/641] gfs2: Fix use-after-free in iomap inline data write path
Date: Tue, 24 Feb 2026 17:15:41 -0800
Message-ID: <20260225012349.329016823@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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
index 131091520de6b..fdcac8e3f2ba2 100644
--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -1127,10 +1127,18 @@ static int gfs2_iomap_begin(struct inode *inode, loff_t pos, loff_t length,
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
@@ -1144,6 +1152,9 @@ static int gfs2_iomap_end(struct inode *inode, loff_t pos, loff_t length,
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



