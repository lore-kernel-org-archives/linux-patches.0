Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93D273D1CA7;
	Wed, 30 Sep 2026 18:48:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794081; cv=none; b=ZOT0aH1t5+EXhsgwbULcDiPuqALkiCt0UYRIhk+Px7XORZV/skb+InHLraEG61ynRjg4qfc5JS2mUcyymkTGUFlhR4RR+dsBD5g0JZ74eOpe3H9hPYety6U4TpIwlffJoHkhFBDTrA4V6DHqkIeDPPs1w6uHqoN0MMswjG8+u+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794081; c=relaxed/simple;
	bh=2/Ijrk9gUtRsNEXnwz6yvl3hbzwvmBGzNtSA6OLW+Qk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=js85nzW6nnDr/08zqTeSPqeDw+kIzduu2/ME31vnZ8LMqrcTDOljNqh0vfMMrvpNAPY8L1XO5a2ztlm4M8t4BA88UTEttqRjILbIJ0GcSJCHtyn9GytOwTl61A9bqfvVSjgrFXB7udMuIu7Rrh7oeHyX7vqTmJGwkXQAq+CzOv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kVQhAl33; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kVQhAl33"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED73D1F000FF;
	Wed, 30 Sep 2026 18:47:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794080;
	bh=YrKtJgP0QOvgzfi4ph5ClewU0/4b1RiIVW9ATnoG1Pw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kVQhAl33/VSQn3EvWZYlwHH0M62hZcLbKKjQ0klXUEQ7NvSabHnp0LYwAgBXUeS4N
	 JQZ/t0uWILhHZzTs/ha0RM58gP2UmlE1AMfx0A/CvLu6xXgJCrgAdvRbJZpj89L5G4
	 avmJ4IOkUvvyewBHx/JLVL9xN1SFKQQRObK69+gk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0084/1193] affs: handle set_blocksize failures
Date: Wed, 30 Sep 2026 17:12:48 +0200
Message-ID: <20260930152436.116983968@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 60685ec76d983..541a87a61fd6a 100644
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
index 58b391446ae1f..6159ba45c843a 100644
--- a/fs/affs/super.c
+++ b/fs/affs/super.c
@@ -392,7 +392,8 @@ static int affs_fill_super(struct super_block *sb, void *data, int silent)
 	size = bdev_nr_sectors(sb->s_bdev);
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



