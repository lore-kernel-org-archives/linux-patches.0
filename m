Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FA304F7CCF;
	Thu, 17 Sep 2026 16:52:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789663967; cv=none; b=Q9KWDaW+d3GoHP+1a8xMxrSfMFe3ZHLhSshbVqtBXG/MYip/EmM/0F7SZ9TZaxNj7RXRhpfeDTRMs/DIUAQOSwmfkrIxekElDCgf0QZIDpmeZPijdA6LXa06Z3O2NUhC1yx8pME3zgX0W66vr7HF5IMg5RRYcGK66vj7FwNACCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789663967; c=relaxed/simple;
	bh=4+ChK37IHcetQABQj1v9nH/ZxbexAkb2CNyTZtsV4V0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fihUDCK7cPNwnmDTSDOiFgFY3OWveRXS2uCD5sr8BZGoUz/hTUZKpdwuV1cUGQekw1jmoBbNSducNoiZkyhqbfd4n+R6jGTl3c+JY4OEQZlSYhEm0SVK3AKszcOsJKdymJHSsPLE7w/V4GycG7L0clkLqKlMtp5klEKT8JYGuPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TbjknGqv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TbjknGqv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2C9F1F000FF;
	Thu, 17 Sep 2026 16:52:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789663966;
	bh=mqmp36VB/DiLE1FSWi87z4ix12W53yrcFqAUQ7kOnz8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TbjknGqvI+136Ks+UUkaR1k/Omhl014ifRnrKQzA6817lIj0nc2lLbusEMqXKs01G
	 ziFW64Ky2XqEXqzcRr3pVTA7jxMD1xtvMODt3sxOvBVeNOQGK6+u6VAZncbWY02n2U
	 jZpHfXL5CUjVE9V3MCF/V1fzv78zixzmVQnMHgPs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0176/1250] affs: handle set_blocksize failures
Date: Thu, 17 Sep 2026 15:59:31 +0100
Message-ID: <20260917151556.870334455@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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
index ac4e9a02910b7..99e54e3453ac1 100644
--- a/fs/affs/affs.h
+++ b/fs/affs/affs.h
@@ -225,11 +225,6 @@ static inline bool affs_validblock(struct super_block *sb, int block)
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
index 44f8aa883100e..994f1199beaf1 100644
--- a/fs/affs/super.c
+++ b/fs/affs/super.c
@@ -357,7 +357,8 @@ static int affs_fill_super(struct super_block *sb, struct fs_context *fc)
 	size = bdev_nr_sectors(sb->s_bdev);
 	pr_debug("initial blocksize=%d, #blocks=%d\n", 512, size);
 
-	affs_set_blocksize(sb, PAGE_SIZE);
+	if (!sb_set_blocksize(sb, PAGE_SIZE))
+		return -EINVAL;
 	/* Try to find root block. Its location depends on the block size. */
 
 	i = bdev_logical_block_size(sb->s_bdev);
@@ -373,7 +374,8 @@ static int affs_fill_super(struct super_block *sb, struct fs_context *fc)
 		if (ctx->root_block < 0)
 			sbi->s_root_block = (ctx->reserved + size - 1) / 2;
 		pr_debug("setting blocksize to %d\n", blocksize);
-		affs_set_blocksize(sb, blocksize);
+		if (!sb_set_blocksize(sb, blocksize))
+			return -EINVAL;
 		sbi->s_partition_size = size;
 
 		/* The root block location that was calculated above is not
-- 
2.53.0



