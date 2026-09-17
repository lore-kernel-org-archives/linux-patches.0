Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7362D502781;
	Thu, 17 Sep 2026 17:53:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667596; cv=none; b=NJ/yoCC0OuAdz2HP8zAHJ6QJBpxyes7pNdh9NWjj+KuWP2MglyvYN94AxXrp4iQNhtrK5VmFYZ2AdLnwNfHEJ2qo0+iNrBWzKdZvdQo7ve/IW2QZZVwO0yFsBbB2xzvV3jUL7OtxpfJ/1nj7tuYTSYIQM9SB8x6j+0ihRIN/yFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667596; c=relaxed/simple;
	bh=FLDeSzX0B+kPf1lmyPO3SULps1gWXxuxmfGA+f+JyWo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DaOb2CP0fYohYdiT0a5yOXC+9Xr6wJV3+KGlzCuRb6N4jWusvNyXXa4CDPwOR3fqw49SOaPdOn3SMqbR86OM5YDYTi8xC9wgUVQomMHLiQ+yhzLfE42/3DO3UVM6w1t4797zsijthuabVHhwD/HZL/sPQ0GM1YS6R38H0p+0bd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z7jvLD/K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z7jvLD/K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9F901F000FF;
	Thu, 17 Sep 2026 17:53:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667595;
	bh=nrOpusngLYUog7RijQAzSwkjEGU9hdHlcDgq1RSaPCE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z7jvLD/KdVyG8vV3iwNcGSZNYwQ05Wt/Dj8ZIiFkVHIg8u1nhiz+glypPDRIoXV6/
	 3mJ9wCusQ4ddtGl/lV3hLA29PkRqtVpFZ7Yt3tkB3kjbz7eaItWCaK3UbcQSfQWB1G
	 GrJQvkzeGBk8nhJFRPTaGf5bWhnEQGP25F7PUYGg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0128/1102] omfs: handle set_blocksize failures
Date: Thu, 17 Sep 2026 16:01:11 +0100
Message-ID: <20260917151542.726905037@linuxfoundation.org>
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

[ Upstream commit 18c3d6fcb557f920c9143711497625e70153874c ]

omfs uses buffer_heads, which don't handle block size > PAGE_SIZE well.
Without this, mounting we will hit the

        BUG_ON(offset >= folio_size(folio));

in folio_set_bh on the first __bread_gfp call.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Signed-off-by: Christoph Hellwig <hch@lst.de>
Link: https://patch.msgid.link/20260511071701.2456211-11-hch@lst.de
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/omfs/inode.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/omfs/inode.c b/fs/omfs/inode.c
index eb5a5fb26a791..0189f58566d79 100644
--- a/fs/omfs/inode.c
+++ b/fs/omfs/inode.c
@@ -477,7 +477,8 @@ static int omfs_fill_super(struct super_block *sb, void *data, int silent)
 	sb->s_time_min = 0;
 	sb->s_time_max = U64_MAX / MSEC_PER_SEC;
 
-	sb_set_blocksize(sb, 0x200);
+	if (!sb_set_blocksize(sb, 0x200))
+		goto end;
 
 	bh = sb_bread(sb, 0);
 	if (!bh)
@@ -529,7 +530,8 @@ static int omfs_fill_super(struct super_block *sb, void *data, int silent)
 	 * Use sys_blocksize as the fs block since it is smaller than a
 	 * page while the fs blocksize can be larger.
 	 */
-	sb_set_blocksize(sb, sbi->s_sys_blocksize);
+	if (!sb_set_blocksize(sb, sbi->s_sys_blocksize))
+		goto out_brelse_bh;
 
 	/*
 	 * ...and the difference goes into a shift.  sys_blocksize is always
-- 
2.53.0



