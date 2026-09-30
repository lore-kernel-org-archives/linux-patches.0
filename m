Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A7ED4F68CD;
	Wed, 30 Sep 2026 15:33:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790782441; cv=none; b=e+BAIO52MG1wxILR6X/rfCj3QqviF+iQrA/L+IenXBtA9OheMQw6yTlyB32v5s2Fo2GfYkE4w7d4dZc2cY3tbGYTek84OiQOWSyDYQMmIoPqPiv9lDkjkZ68pEIVciuRzQpx1I4uVRKuTgvPkr8LSs01Kz/629I5QcI6cDYeHhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790782441; c=relaxed/simple;
	bh=egeYhMhHUILJ+T1sTNefgtWWJBtJ3Gl7UvNAkpdCmno=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E66PYcj57r7S130u49pKVTNM+yFWpGm15/AyyjPeHqRvSSwk1B5+hP5c8JI3UdR+P8eZVWYbHEjL6j+tczeZRtDzaAVLfUH12t0R09xfBZDY8weVc3i5ID89xlIKfBmgoxtW8v02StlEJdyPnwQnZiZlnHd7OSUBwSvr0lS6efc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SVsHUSbQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SVsHUSbQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03E071F00893;
	Wed, 30 Sep 2026 15:33:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790782425;
	bh=jxbJSvcctnnSj+dhJoujo29AseFzisEGWoC3X56rM8c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SVsHUSbQOwXyEz5iPBM0daDZwLuGYbzsEWPfvEliyr+GytVt4SXLHo6sdaGtfRdu4
	 FylBw3Tu5pp4jiOPVQhQ8y2ZpalsFV6vRHRDfNlKUtWuYaRgLfhwklwDpYKP6zYJl4
	 IECP4ujCxiYpEvvOTH/S67BFtrMR1AsGroElJT0c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 042/595] affs: handle set_blocksize failures
Date: Wed, 30 Sep 2026 17:18:55 +0200
Message-ID: <20260930152348.634868379@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 0861182af5983a39bd2a891966436c5679b74a45 ]

affs uses buffer_heads, which don't handle block size > PAGE_SIZE well.
Without this, mounting we will hit the

        BUG_ON(offset >= folio_size(folio));

in folio_set_bh on the first __bread_gfp call.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Link: https://patch.msgid.link/20260511071701.2456211-7-hch@lst.de
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/affs/affs.h  | 5 -----
 fs/affs/super.c | 6 ++++--
 2 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/fs/affs/affs.h b/fs/affs/affs.h
index a755bef7c4c7f..ccb5c02ecfd4b 100644
--- a/fs/affs/affs.h
+++ b/fs/affs/affs.h
@@ -220,11 +220,6 @@ static inline bool affs_validblock(struct super_block *sb, int block)
 	       block < AFFS_SB(sb)->s_partition_size);
 }
 
-static inline void
-affs_set_blocksize(struct super_block *sb, int size)
-{
-	sb_set_blocksize(sb, size);
-}
 static inline struct buffer_head *
 affs_bread(struct super_block *sb, int block)
 {
diff --git a/fs/affs/super.c b/fs/affs/super.c
index c6c2a513ec92d..a7073d814e154 100644
--- a/fs/affs/super.c
+++ b/fs/affs/super.c
@@ -392,7 +392,8 @@ static int affs_fill_super(struct super_block *sb, void *data, int silent)
 	size = i_size_read(sb->s_bdev->bd_inode) >> 9;
 	pr_debug("initial blocksize=%d, #blocks=%d\n", 512, size);
 
-	affs_set_blocksize(sb, PAGE_SIZE);
+	if (!sb_set_blocksize(sb, PAGE_SIZE))
+		return -EINVAL;
 	/* Try to find root block. Its location depends on the block size. */
 
 	i = bdev_logical_block_size(sb->s_bdev);
@@ -407,7 +408,8 @@ static int affs_fill_super(struct super_block *sb, void *data, int silent)
 		if (root_block < 0)
 			sbi->s_root_block = (reserved + size - 1) / 2;
 		pr_debug("setting blocksize to %d\n", blocksize);
-		affs_set_blocksize(sb, blocksize);
+		if (!sb_set_blocksize(sb, blocksize))
+			return -EINVAL;
 		sbi->s_partition_size = size;
 
 		/* The root block location that was calculated above is not
-- 
2.53.0



