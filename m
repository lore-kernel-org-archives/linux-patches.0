Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B5661E871;
	Fri,  6 Dec 2024 15:01:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497304; cv=none; b=G9qVfwTQ/b3BE6bBP8cLogvljI6Bl0mafIhH52YNYG2EaO0JrhRgn23b5y7klMB7Z2NcsKX/mw78TBAxkp7w4x+nnXZlE8yQbElROagKCfVqx50sCn7zJpvUQxqpEA96Wj/5tYL1apW1pebnftzbQ+MXokkPuVmexdoKuy2umAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497304; c=relaxed/simple;
	bh=g0CH2BmaUK3Wc3s4MzpMrKk8XPKdlj4hXbtX5bJfYbI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TbYwaWonZDYWFoC8DzPp3SygsFgNP/3HwItpdW0eufGt7ZKPDK6L85yISz9qtxH66n2ITCj3Cga9qG4/6O7tfMVa0eS5BCJ+Q3QrUaSe+Qbjg/Px4QwyuAZTLtbQknYqrWj7Mvc17mghnJ6xgEqcMHWzmSEgjuCMPpw9fN4wUAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KghCB485; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KghCB485"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2B07C4CED1;
	Fri,  6 Dec 2024 15:01:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497304;
	bh=g0CH2BmaUK3Wc3s4MzpMrKk8XPKdlj4hXbtX5bJfYbI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KghCB485rWP8XrTcfcYmpeCs9eUK+aQmlU99p/5S7ZpRQt3TGKZxhLOxLA2Xlcp95
	 yAeokMpRNGhV4ecNrLMYQGxq0wccb0zsiKbsLdKu5uYdeyd7Tyxwkw0317L4lnQ1R6
	 0Vp4Re3FnS+/IhosVz95HhCAkohpYSntyYf86jTI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+6c0b301317aa0156f9eb@syzkaller.appspotmail.com,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 254/676] erofs: handle NONHEAD !delta[1] lclusters gracefully
Date: Fri,  6 Dec 2024 15:31:13 +0100
Message-ID: <20241206143703.251895511@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 6bd435a565f61..76566c2cbf63e 100644
--- a/fs/erofs/zmap.c
+++ b/fs/erofs/zmap.c
@@ -234,7 +234,7 @@ static int z_erofs_load_compact_lcluster(struct z_erofs_maprecorder *m,
 	unsigned int amortizedshift;
 	erofs_off_t pos;
 
-	if (lcn >= totalidx)
+	if (lcn >= totalidx || vi->z_logical_clusterbits > 14)
 		return -EINVAL;
 
 	m->lcn = lcn;
@@ -409,7 +409,7 @@ static int z_erofs_get_extent_decompressedlen(struct z_erofs_maprecorder *m)
 	u64 lcn = m->lcn, headlcn = map->m_la >> lclusterbits;
 	int err;
 
-	do {
+	while (1) {
 		/* handle the last EOF pcluster (no next HEAD lcluster) */
 		if ((lcn << lclusterbits) >= inode->i_size) {
 			map->m_llen = inode->i_size - map->m_la;
@@ -421,14 +421,16 @@ static int z_erofs_get_extent_decompressedlen(struct z_erofs_maprecorder *m)
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
@@ -437,8 +439,7 @@ static int z_erofs_get_extent_decompressedlen(struct z_erofs_maprecorder *m)
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



