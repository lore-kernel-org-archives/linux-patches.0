Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10D0A1AB6C9;
	Tue,  3 Dec 2024 15:52:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241178; cv=none; b=KzalIMO5zQYB0xLVMpCJU6CpUKnjzonPxGZGHgAlgs4CQgimFCZBmfqc0+7oeMAded2TVeJ5B4GNg86YjlRoPqE79MSAwaLvHYDG6KNO6pgMB1zTjDnpayEWuXFgsgIXFv9UL0oT2xjuKNafS0x5ObXHHBu8uU2YJyKA4iC5TFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241178; c=relaxed/simple;
	bh=EXKEXzIXQv4qbHqap2BQKroLWs+oYuFmYsU66558f8Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o6pETKIsqccaiZxVOFzZigoQQPAtvCxAFfnFBYnl1hPvplvyRDBo3O9KnYdzprdGuGwHEsEvvKucYMO9omprAg+vyjhTekEsz2pmg6gxp9+GBie1RYN5Nxmy5QMX+uUB3wafzz37NjhjH8EQt6yP2GP0iCmWMglR0clTXh1en6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sk692lxv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sk692lxv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7269FC4CECF;
	Tue,  3 Dec 2024 15:52:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241177;
	bh=EXKEXzIXQv4qbHqap2BQKroLWs+oYuFmYsU66558f8Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sk692lxvR2r+IR9HFbgDXefq8Sx7lAT/XFxpGYFDopvuz0iDSCIozEFoNb0Znd61v
	 v8u91uwfLXTCjloH2K+f7q28zl93Otvhh8NOh5gnu6F2orZF6B0D9wyaw22m5JHAo7
	 vn6vjQIl1+naPNbKMYRQPTaxLB3gIZjdcoX3otUM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+6c0b301317aa0156f9eb@syzkaller.appspotmail.com,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 349/826] erofs: handle NONHEAD !delta[1] lclusters gracefully
Date: Tue,  3 Dec 2024 15:41:16 +0100
Message-ID: <20241203144757.377810749@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Gao Xiang <hsiangkao@linux.alibaba.com>

[ Upstream commit 0bc8061ffc733a0a246b8689b2d32a3e9204f43c ]

syzbot reported a WARNING in iomap_iter_done:
 iomap_fiemap+0x73b/0x9b0 fs/iomap/fiemap.c:80
 ioctl_fiemap fs/ioctl.c:220 [inline]

Generally, NONHEAD lclusters won't have delta[1]==0, except for crafted
images and filesystems created by pre-1.0 mkfs versions.

Previously, it would immediately bail out if delta[1]==0, which led to
inadequate decompressed lengths (thus FIEMAP is impacted).  Treat it as
delta[1]=1 to work around these legacy mkfs versions.

`lclusterbits > 14` is illegal for compact indexes, error out too.

Reported-by: syzbot+6c0b301317aa0156f9eb@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/r/67373c0c.050a0220.2a2fcc.0079.GAE@google.com
Tested-by: syzbot+6c0b301317aa0156f9eb@syzkaller.appspotmail.com
Fixes: d95ae5e25326 ("erofs: add support for the full decompressed length")
Fixes: 001b8ccd0650 ("erofs: fix compact 4B support for 16k block size")
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Link: https://lore.kernel.org/r/20241115173651.3339514-1-hsiangkao@linux.alibaba.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/zmap.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/fs/erofs/zmap.c b/fs/erofs/zmap.c
index a076cca1f5473..4535f2f0a0147 100644
--- a/fs/erofs/zmap.c
+++ b/fs/erofs/zmap.c
@@ -219,7 +219,7 @@ static int z_erofs_load_compact_lcluster(struct z_erofs_maprecorder *m,
 	unsigned int amortizedshift;
 	erofs_off_t pos;
 
-	if (lcn >= totalidx)
+	if (lcn >= totalidx || vi->z_logical_clusterbits > 14)
 		return -EINVAL;
 
 	m->lcn = lcn;
@@ -390,7 +390,7 @@ static int z_erofs_get_extent_decompressedlen(struct z_erofs_maprecorder *m)
 	u64 lcn = m->lcn, headlcn = map->m_la >> lclusterbits;
 	int err;
 
-	do {
+	while (1) {
 		/* handle the last EOF pcluster (no next HEAD lcluster) */
 		if ((lcn << lclusterbits) >= inode->i_size) {
 			map->m_llen = inode->i_size - map->m_la;
@@ -402,14 +402,16 @@ static int z_erofs_get_extent_decompressedlen(struct z_erofs_maprecorder *m)
 			return err;
 
 		if (m->type == Z_EROFS_LCLUSTER_TYPE_NONHEAD) {
-			DBG_BUGON(!m->delta[1] &&
-				  m->clusterofs != 1 << lclusterbits);
+			/* work around invalid d1 generated by pre-1.0 mkfs */
+			if (unlikely(!m->delta[1])) {
+				m->delta[1] = 1;
+				DBG_BUGON(1);
+			}
 		} else if (m->type == Z_EROFS_LCLUSTER_TYPE_PLAIN ||
 			   m->type == Z_EROFS_LCLUSTER_TYPE_HEAD1 ||
 			   m->type == Z_EROFS_LCLUSTER_TYPE_HEAD2) {
-			/* go on until the next HEAD lcluster */
 			if (lcn != headlcn)
-				break;
+				break;	/* ends at the next HEAD lcluster */
 			m->delta[1] = 1;
 		} else {
 			erofs_err(inode->i_sb, "unknown type %u @ lcn %llu of nid %llu",
@@ -418,8 +420,7 @@ static int z_erofs_get_extent_decompressedlen(struct z_erofs_maprecorder *m)
 			return -EOPNOTSUPP;
 		}
 		lcn += m->delta[1];
-	} while (m->delta[1]);
-
+	}
 	map->m_llen = (lcn << lclusterbits) + m->clusterofs - map->m_la;
 	return 0;
 }
-- 
2.43.0



