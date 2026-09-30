Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 970E151FCC8;
	Wed, 30 Sep 2026 17:51:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790717; cv=none; b=eUQKlhpHByR08aYWNyj6oHy2xTkYUzzjKiLzl3dZs20u22cgdrjuU/1z26Rs4cDQn/jwV2Oyb78sd3RT8goS0YEbImiSscWt3T1RDltnTspHz3clxlU9brTy0HUEqJk+BoltiZZcqMbrljaFExo+yRBE14R9UiuYxyhXDniAb7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790717; c=relaxed/simple;
	bh=6A0Qo8c8c74KFihf7T9bTlknsPYcpaIIC7Ua1FWpjm8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZI/UXuJ/ut8kof9+F8YSEDWxRcgrRiAYZgOyO2C2o592vJia0LeK7nR/DeNCxGNhaOwijlmxD4tF2wrrMJuA6Puq3CHZ1jpuaffkwoNyXezlx/Gq1uL9ncBBUnluJn06ThOlkDiG5Bbu49in5JBo2WsIC2Oqa9OokGcLEznCk7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E4cS3i/R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E4cS3i/R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEF231F00898;
	Wed, 30 Sep 2026 17:51:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790716;
	bh=ijqXYmwa8fVxarZERJyT5bNe4HLaveEsEumOiT+SCYQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E4cS3i/RUbyXrc/9HRcmaHUyUNNavF3ESExg7WJSwv7C7txzhBIPzf0tGP0BaqAm+
	 9UpYz7SHOqKlJBrNtZcUxCyyh9/EL0ZrZoh1ItMvBAv9AJcUnMQ8cSKz/nY2ahq4KR
	 Ca8s2Buotw5RokBNsLCT1xUw6BFZS97cP7zpii70=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 049/752] affs: handle set_blocksize failures
Date: Wed, 30 Sep 2026 17:18:39 +0200
Message-ID: <20260930152359.215582166@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index bfa89e131ead0..af34fc78a9fb5 100644
--- a/fs/affs/affs.h
+++ b/fs/affs/affs.h
@@ -226,11 +226,6 @@ static inline bool affs_validblock(struct super_block *sb, int block)
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



