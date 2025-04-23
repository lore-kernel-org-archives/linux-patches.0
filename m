Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E14511F193C;
	Wed, 23 Apr 2025 14:58:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420303; cv=none; b=i3A3L0lEyq9ShMgsFBvpXbw9oKXF8MB0IMXWl3N2GyFYd52IEUKCPNpLwabQ+tuqxoTn21ZfYR6zGEgnAgEGFkh9p5P2w0GG5INgd07HPIWmblqxbvBfXgWVM8qJtbokXDO/5fazHU4zpWoBC8ZOf7BsKRLd5s71ReOZHhZTmDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420303; c=relaxed/simple;
	bh=ElJlXbZBmyxcsboAeemP1gZGIsjFojUGM4iDaL52sB8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BV9p+hGmI62fsv0CVl9sn7qXMxlF2IqPNlWnVIfaWRQwN6pj8Hi3vx6vlIwdvHJdyOytaliIUO3xXf5PANBxkT0TuQOJzjyMSo5zVlsLClRlUMqZPyHB7eGmNyOtCMkrfRBHTMRCHHRpeC/p687sMpOc9wPBkA90p59URdnJBCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=njNjQrvC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="njNjQrvC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72776C4CEE2;
	Wed, 23 Apr 2025 14:58:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420302;
	bh=ElJlXbZBmyxcsboAeemP1gZGIsjFojUGM4iDaL52sB8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=njNjQrvCCnVoDe+QC3KCT2XkH6cJEXC9LI1LM+1au8TL5lBi/5FSWWu0srWC3uGu2
	 WIF52+WNFf4hgPQP95XDmVI1FNQUP13N7ZRniKOyvakkLkgV6qBpqZumBvGnE/tveu
	 E4BbD41De7JzZZdx4KCKDcTiCABlDkGGrImjxnHg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 035/291] f2fs: dont retry IO for corrupted data scenario
Date: Wed, 23 Apr 2025 16:40:24 +0200
Message-ID: <20250423142625.830451583@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

[ Upstream commit 1534747d3170646ddeb9ea5f7caaac90359707cf ]

F2FS-fs (dm-105): inconsistent node block, nid:430, node_footer[nid:2198964142,ino:598252782,ofs:118300154,cpver:5409237455940746069,blkaddr:2125070942]
F2FS-fs (dm-105): inconsistent node block, nid:430, node_footer[nid:2198964142,ino:598252782,ofs:118300154,cpver:5409237455940746069,blkaddr:2125070942]
F2FS-fs (dm-105): inconsistent node block, nid:430, node_footer[nid:2198964142,ino:598252782,ofs:118300154,cpver:5409237455940746069,blkaddr:2125070942]
F2FS-fs (dm-105): inconsistent node block, nid:430, node_footer[nid:2198964142,ino:598252782,ofs:118300154,cpver:5409237455940746069,blkaddr:2125070942]
F2FS-fs (dm-105): inconsistent node block, nid:430, node_footer[nid:2198964142,ino:598252782,ofs:118300154,cpver:5409237455940746069,blkaddr:2125070942]
F2FS-fs (dm-105): inconsistent node block, nid:430, node_footer[nid:2198964142,ino:598252782,ofs:118300154,cpver:5409237455940746069,blkaddr:2125070942]
F2FS-fs (dm-105): inconsistent node block, nid:430, node_footer[nid:2198964142,ino:598252782,ofs:118300154,cpver:5409237455940746069,blkaddr:2125070942]
F2FS-fs (dm-105): inconsistent node block, nid:430, node_footer[nid:2198964142,ino:598252782,ofs:118300154,cpver:5409237455940746069,blkaddr:2125070942]
F2FS-fs (dm-105): inconsistent node block, nid:430, node_footer[nid:2198964142,ino:598252782,ofs:118300154,cpver:5409237455940746069,blkaddr:2125070942]
F2FS-fs (dm-105): inconsistent node block, nid:430, node_footer[nid:2198964142,ino:598252782,ofs:118300154,cpver:5409237455940746069,blkaddr:2125070942]

If node block is loaded successfully, but its content is inconsistent, it
doesn't need to retry IO.

Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/inode.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/f2fs/inode.c b/fs/f2fs/inode.c
index 0f350368dea73..b8296b0414fcb 100644
--- a/fs/f2fs/inode.c
+++ b/fs/f2fs/inode.c
@@ -695,8 +695,12 @@ void f2fs_update_inode_page(struct inode *inode)
 		if (err == -ENOENT)
 			return;
 
+		if (err == -EFSCORRUPTED)
+			goto stop_checkpoint;
+
 		if (err == -ENOMEM || ++count <= DEFAULT_RETRY_IO_COUNT)
 			goto retry;
+stop_checkpoint:
 		f2fs_stop_checkpoint(sbi, false, STOP_CP_REASON_UPDATE_INODE);
 		return;
 	}
-- 
2.39.5



