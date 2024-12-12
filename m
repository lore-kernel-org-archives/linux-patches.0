Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E43ED2135B0;
	Thu, 12 Dec 2024 15:49:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734018566; cv=none; b=nHTTxUeZuiGkWfAOtz4aLd/66G2uKT4ysFCcMFlhvcRtYyMXIKu5DGPNh6UlOFv24Ehoy4ZtDCFZvLHtO7PvBCrBYcw5QcU7atQ/ej0wFd4wR75hccqIon2LKKtsahsbt6SQIKV7mEzVPLe2IufYtLm5YQQwVzeFBlfWQHymizo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734018566; c=relaxed/simple;
	bh=KzYJAcLbPaKzkhjlRfrDAoNVGzCf+6OzLbxnLYxZens=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XfiHCsVvvxybnHOfAYZ5sfz/7aQS1TCmiYkDpSkuaR9ttrIPgcjf9LEpzlkothf+HsDiHK0L2sG/wFheioptwLT98avyWfdrelOHpZmv0R8DNY3Qq2/lmOuHQ8h9mK8AK4d8UpIBl92zObvaLJ4Bu/vvg26blozjM5jSMxKHChw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zwL8CRnN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zwL8CRnN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50510C4CECE;
	Thu, 12 Dec 2024 15:49:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734018565;
	bh=KzYJAcLbPaKzkhjlRfrDAoNVGzCf+6OzLbxnLYxZens=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zwL8CRnNnIqowKjykUm3yMZHUv4yBDzieH5Q2sGLqrCE//EQ6mSXhNE+S/hMF9geH
	 IA0G2KNOFpvyxdVqMLTpvXzeZm7XSz+0juDUCOXhKFL+mHrp4iHHAqQIPTmJQG2PCM
	 +3cErvikYgvPNo1y2yFeeEc6azVQ6RVH4XxZGOy0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 297/356] f2fs: print message if fscorrupted was found in f2fs_new_node_page()
Date: Thu, 12 Dec 2024 16:00:16 +0100
Message-ID: <20241212144256.301939891@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
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

From: Chao Yu <chao@kernel.org>

[ Upstream commit 81520c684ca67aea6a589461a3caebb9b11dcc90 ]

If fs corruption occurs in f2fs_new_node_page(), let's print
more information about corrupted metadata into kernel log.

Meanwhile, it updates to record ERROR_INCONSISTENT_NAT instead
of ERROR_INVALID_BLKADDR if blkaddr in nat entry is not
NULL_ADDR which means nat bitmap and nat entry is inconsistent.

Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/node.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index a9ab93d30dceb..dedba481b66d0 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -1331,7 +1331,12 @@ struct page *f2fs_new_node_page(struct dnode_of_data *dn, unsigned int ofs)
 		err = -EFSCORRUPTED;
 		dec_valid_node_count(sbi, dn->inode, !ofs);
 		set_sbi_flag(sbi, SBI_NEED_FSCK);
-		f2fs_handle_error(sbi, ERROR_INVALID_BLKADDR);
+		f2fs_warn_ratelimited(sbi,
+			"f2fs_new_node_page: inconsistent nat entry, "
+			"ino:%u, nid:%u, blkaddr:%u, ver:%u, flag:%u",
+			new_ni.ino, new_ni.nid, new_ni.blk_addr,
+			new_ni.version, new_ni.flag);
+		f2fs_handle_error(sbi, ERROR_INCONSISTENT_NAT);
 		goto fail;
 	}
 #endif
-- 
2.43.0



