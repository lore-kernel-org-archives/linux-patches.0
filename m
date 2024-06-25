Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA74412EBEA;
	Tue, 25 Jun 2024 09:38:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308289; cv=none; b=e2pPr8Wob0qP+LwCaTzc9UjKc52pcnT9eL2AKXXIxGLAOOWET9+25CLRN5OdtOTWeUFUo6G3c25Wb2MJhNXPU1pRh6VgXwZ6spuy4ucY3npg0H8h16rzIjaFMt004+gIhgFWEDJ4+xQNgk3BAUagkql7obJYnw1nUSbWk4ip6e4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308289; c=relaxed/simple;
	bh=V8E9lEeT1QIUOP4utvg/8wmRtZAmuJD/02NE2wlH9LI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DT/IdbccRgAOCBQCIpKXahXHl+cIr71WoBEurW+0ZxnH9qkSMxJ7ka4l46UamUs9XXxl71ox+lDciPJIhR9Fi93e11bs3lBix/mVBvICiZQr7g/xTxPBJM+7vKjbkk4bwZfSfdLi+SFBemBC/F7SljCZO3TSUiLn2BIUTLqRqZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Alz/cusP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Alz/cusP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61C05C32781;
	Tue, 25 Jun 2024 09:38:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308288;
	bh=V8E9lEeT1QIUOP4utvg/8wmRtZAmuJD/02NE2wlH9LI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Alz/cusPvWSSQyZka5S50u5VehMB0n7V0ywnCcxeGzBaISJy5s5HqhEvIKWsBWFUE
	 8aGBbqPhqv+4kir7wIcS4XnCSyhY1R1Q6U88x09r/cIOIVIsfHkhmJteDBOS7GfUrB
	 hGxgLk+5gUaWdO2/YF02jf0PRtGgDtDslH4/8HqQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roman Smirnov <r.smirnov@omp.ru>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 071/250] f2fs: fix to detect inconsistent nat entry during truncation
Date: Tue, 25 Jun 2024 11:30:29 +0200
Message-ID: <20240625085550.791382804@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>
References: <20240625085548.033507125@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

[ Upstream commit 92c556ed6318e13c16746495a8d4513129eb9b0f ]

As Roman Smirnov reported as below:

"
There is a possible bug in f2fs_truncate_inode_blocks():

    if (err < 0 && err != -ENOENT)
    			goto fail;
        ...
        offset[1] = 0;
        offset[0]++;
        nofs += err;

If err = -ENOENT then nofs will sum with an error code,
which is strange behaviour. Also if nofs < ENOENT this will
cause an overflow. err will be equal to -ENOENT with the
following call stack:

truncate_nodes()
  f2fs_get_node_page()
     __get_node_page()
        read_node_page()
"

If nat is corrupted, truncate_nodes() may return -ENOENT, and
f2fs_truncate_inode_blocks() doesn't handle such error correctly,
fix it.

Reported-by: Roman Smirnov <r.smirnov@omp.ru>
Closes: https://lore.kernel.org/linux-f2fs-devel/085b27fd2b364a3c8c3a9ca77363e246@omp.ru
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/node.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 7df5ad84cb5ea..15c9a9f5750bc 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -1187,7 +1187,17 @@ int f2fs_truncate_inode_blocks(struct inode *inode, pgoff_t from)
 		default:
 			BUG();
 		}
-		if (err < 0 && err != -ENOENT)
+		if (err == -ENOENT) {
+			set_sbi_flag(F2FS_P_SB(page), SBI_NEED_FSCK);
+			f2fs_handle_error(sbi, ERROR_INVALID_BLKADDR);
+			f2fs_err_ratelimited(sbi,
+				"truncate node fail, ino:%lu, nid:%u, "
+				"offset[0]:%d, offset[1]:%d, nofs:%d",
+				inode->i_ino, dn.nid, offset[0],
+				offset[1], nofs);
+			err = 0;
+		}
+		if (err < 0)
 			goto fail;
 		if (offset[1] == 0 &&
 				ri->i_nid[offset[0] - NODE_DIR1_BLOCK]) {
-- 
2.43.0



