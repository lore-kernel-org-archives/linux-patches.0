Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25844361648
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:48:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772300923; cv=none; b=iuVYkU6Kk3wYs6U+c0HJJ+O4MuVD/X9DtP6qVgFEd41M2RozmmYi5Vs4uHdRYFw0A6gt+KNz2uli4Co3LuqgEtRlBGLNwZj4n2wJ3AM4Is4UIO2xPne/WXhS0L2HV1lJWMazjI0oKib2v3oJn++ZIVuy5EfySzGHLtl8C8A8wsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772300923; c=relaxed/simple;
	bh=374tPj2mu8u4VHrhq8tRXh7o2UqdGJ4VLtDjst7csRU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CLE9iy56nCm/kxva8KMbyj8kugn5gtBdaAg8lIou3/QeaYrs6hhsuzR7ptkBvNowWPPHmirehGAq2pPkSoWiapBfWpQQcFI7Wpi6vbTgmrqQM/DN/I5t7Q4SI+RK7b46/7ZFEVApcEZForbiUxJPzTRxit2QFwnDHctmDNHyTMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZvnLQd1p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZvnLQd1p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DC9FC19423;
	Sat, 28 Feb 2026 17:48:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772300923;
	bh=374tPj2mu8u4VHrhq8tRXh7o2UqdGJ4VLtDjst7csRU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZvnLQd1p4oumwPPjRCjN2hKKktXRyB9Ygnj4HD/hPJYtjatnAUmqIltyJ/e55MEDQ
	 HVkqGepQTlfDCL/OH/pssZ9G1Q/gFxXQIHtWg+tspaapu8OXK54SMNhPdmj8e5Ra6p
	 kaXWRbN57tDbpE0PBCZDLicrocB7RMyOn83VjvgRzdMnYxQaLovJIKrtS7MQtVLAFi
	 OY7oJnci6KVA4THbmasd7WG7q7YehNdoak+DGXPiiO3JZBEhOnB4k6OchqKoMRRbrc
	 3/tDsblugHFVNS4FtO8XSORwUZTv2dL/+Z6HKjzRMPDTvDoOYPZRI369yJf8z74D/s
	 H0YJC2adIZoHw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 040/752] gfs2: fiemap page fault fix
Date: Sat, 28 Feb 2026 12:35:51 -0500
Message-ID: <20260228174750.1542406-40-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Andreas Gruenbacher <agruenba@redhat.com>

[ Upstream commit e411d74cc5ba290f85d0dd5e4d1df8f1d6d975d2 ]

In gfs2_fiemap(), we are calling iomap_fiemap() while holding the inode
glock.  This can lead to recursive glock taking if the fiemap buffer is
memory mapped to the same inode and accessing it triggers a page fault.

Fix by disabling page faults for iomap_fiemap() and faulting in the
buffer by hand if necessary.

Fixes xfstest generic/742.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/inode.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index 63d9fe7464344..03dd54fb7e8c8 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -2192,6 +2192,14 @@ static int gfs2_getattr(struct mnt_idmap *idmap,
 	return 0;
 }
 
+static bool fault_in_fiemap(struct fiemap_extent_info *fi)
+{
+	struct fiemap_extent __user *dest = fi->fi_extents_start;
+	size_t size = sizeof(*dest) * fi->fi_extents_max;
+
+	return fault_in_safe_writeable((char __user *)dest, size) == 0;
+}
+
 static int gfs2_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 		       u64 start, u64 len)
 {
@@ -2201,14 +2209,22 @@ static int gfs2_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 
 	inode_lock_shared(inode);
 
+retry:
 	ret = gfs2_glock_nq_init(ip->i_gl, LM_ST_SHARED, 0, &gh);
 	if (ret)
 		goto out;
 
+	pagefault_disable();
 	ret = iomap_fiemap(inode, fieinfo, start, len, &gfs2_iomap_ops);
+	pagefault_enable();
 
 	gfs2_glock_dq_uninit(&gh);
 
+	if (ret == -EFAULT && fault_in_fiemap(fieinfo)) {
+		fieinfo->fi_extents_mapped = 0;
+		goto retry;
+	}
+
 out:
 	inode_unlock_shared(inode);
 	return ret;
-- 
2.51.0

