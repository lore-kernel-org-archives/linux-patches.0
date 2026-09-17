Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D06CA371041;
	Thu, 17 Sep 2026 17:52:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667529; cv=none; b=srVo3VlDYmyfR6q/n6BJIa5BO/vjfo6nXnlN48uPBPpW/ak5LSsZLxyj7BCkV4ztIwKxd6evtlUU27v7MOU+kr4FLRWGLbmsW5OB83SdAbezpgomMVOUOt9TJ4OVEqhnm0W7AOMPiF84GEyLCDGlSEWg//uJHFun1237FiB4SMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667529; c=relaxed/simple;
	bh=xZQlwsnxwBlpCAFAVdo5YRwzW9Z5qX+k00NmqRpHJEs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JHWL1096vHymz4G5YpfPiydP78fjkvg4FdexxWueQ1nbBhkU+c7QpS2D+MUFEjsWOzf3u5I/AKhI7thRpj+bxN/YErvcBlEmLvmeDnzxeMBVoSSqTu9Ykuk0LjoXLKtkdr+CuYA5m4D+9OP4wS5XKpjS4I+FHTJNDgrweFqMwCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GCrf6yty; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GCrf6yty"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32D7B1F000FF;
	Thu, 17 Sep 2026 17:52:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667527;
	bh=wDcmgs6GaXHItuiU4zQjEtcmRZaINPqXpyshqcYkngw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GCrf6ytyctu4zjiGbb+taza4toY+/9CCTWtDSujtYZGl20GlIO1CxKJ7KJZirvEpA
	 MBF0SGTNHYVSPixpBGA56PUW4fhtNZJwz9gnc8DltuZW6PgTiUhE31zapOg3tOJDWL
	 HTYmzhGCt+w+d/lXD/sbHQosr6xxzlWXmcef5b/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0122/1102] affs: handle set_blocksize failures
Date: Thu, 17 Sep 2026 16:01:05 +0100
Message-ID: <20260917151542.574180024@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index e8c2c4535cb37..9466e72ed3bbd 100644
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
index 3c5821339609c..ff64df645f81f 100644
--- a/fs/affs/super.c
+++ b/fs/affs/super.c
@@ -391,7 +391,8 @@ static int affs_fill_super(struct super_block *sb, void *data, int silent)
 	size = bdev_nr_sectors(sb->s_bdev);
 	pr_debug("initial blocksize=%d, #blocks=%d\n", 512, size);
 
-	affs_set_blocksize(sb, PAGE_SIZE);
+	if (!sb_set_blocksize(sb, PAGE_SIZE))
+		return -EINVAL;
 	/* Try to find root block. Its location depends on the block size. */
 
 	i = bdev_logical_block_size(sb->s_bdev);
@@ -406,7 +407,8 @@ static int affs_fill_super(struct super_block *sb, void *data, int silent)
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



