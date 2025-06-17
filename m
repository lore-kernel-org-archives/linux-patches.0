Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CA4028C024;
	Tue, 17 Jun 2025 16:11:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176689; cv=none; b=bExUgIc3AlfrhGKW44nZHnC2t2ceLMCvQhTSM8vEmHwDZiTzqfNQGLxUh1OFXCFA8Y/dSsOnAS+9kYXNbkQ0XN1XPWxDtEhFmEPHUolgiGz+SlRNqqf6bXR+P3EogI8UdfWMxgGrwxJBFe+9ShaybyfjtjxFwU9rar1mzGEyLdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176689; c=relaxed/simple;
	bh=UJambC8+oPdfGi4k4l94NwTtoYs2n7loHeRc0ZjKN3k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lzFj1nn5LvThoq37T8lfYVTkJ6SuwMCSqnbfzJZYPtSBQQ6w306LVaQt4+xACJtRMF/P8NOrxTEehSzgHw01owXu8eqHdNE0WXxyZKZs/oXUnOBFpxd5gNx+ZQ51ZdHCWDn4r6m1TI2QFSCaycxOL63J3e2i9XQ5C03dqVN4eEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fc+dS3ep; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fc+dS3ep"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D563C4CEE3;
	Tue, 17 Jun 2025 16:11:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176689;
	bh=UJambC8+oPdfGi4k4l94NwTtoYs2n7loHeRc0ZjKN3k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fc+dS3epkqbFTjmKMFxcpXtDtgVYunh+m7VUZohi6RUqmGh2Qr5kt3flT339jmJIX
	 vhHP3YN953Wg6HyM2Co/B36LHZ8VscX2PKtdSUaTudu5Nw9pp2gl77oIto+y7ZGSVo
	 nBuQjNBWwQf3MLmUricHYq5N7ZRKXtETNCIuUcL0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Wentao Liang <vulab@iscas.ac.cn>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 254/512] nilfs2: do not propagate ENOENT error from nilfs_btree_propagate()
Date: Tue, 17 Jun 2025 17:23:40 +0200
Message-ID: <20250617152429.890243013@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Ryusuke Konishi <konishi.ryusuke@gmail.com>

[ Upstream commit 8e39fbb1edbb4ec9d7c1124f403877fc167fcecd ]

In preparation for writing logs, in nilfs_btree_propagate(), which makes
parent and ancestor node blocks dirty starting from a modified data block
or b-tree node block, if the starting block does not belong to the b-tree,
i.e.  is isolated, nilfs_btree_do_lookup() called within the function
fails with -ENOENT.

In this case, even though -ENOENT is an internal code, it is propagated to
the log writer via nilfs_bmap_propagate() and may be erroneously returned
to system calls such as fsync().

Fix this issue by changing the error code to -EINVAL in this case, and
having the bmap layer detect metadata corruption and convert the error
code appropriately.

Link: https://lkml.kernel.org/r/20250428173808.6452-3-konishi.ryusuke@gmail.com
Fixes: 1f5abe7e7dbc ("nilfs2: replace BUG_ON and BUG calls triggerable from ioctl")
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: Wentao Liang <vulab@iscas.ac.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nilfs2/btree.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/nilfs2/btree.c b/fs/nilfs2/btree.c
index ef5061bb56da1..9c51a4ac2627f 100644
--- a/fs/nilfs2/btree.c
+++ b/fs/nilfs2/btree.c
@@ -2103,11 +2103,13 @@ static int nilfs_btree_propagate(struct nilfs_bmap *btree,
 
 	ret = nilfs_btree_do_lookup(btree, path, key, NULL, level + 1, 0);
 	if (ret < 0) {
-		if (unlikely(ret == -ENOENT))
+		if (unlikely(ret == -ENOENT)) {
 			nilfs_crit(btree->b_inode->i_sb,
 				   "writing node/leaf block does not appear in b-tree (ino=%lu) at key=%llu, level=%d",
 				   btree->b_inode->i_ino,
 				   (unsigned long long)key, level);
+			ret = -EINVAL;
+		}
 		goto out;
 	}
 
-- 
2.39.5



