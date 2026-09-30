Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73D8150E5A0;
	Wed, 30 Sep 2026 15:34:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790782450; cv=none; b=amX9GkK9LOm4wxE7wjaMi+fYxIhvDDvnvdvbM1E1gOQBB7F46fZ8sigypaXoc2r1gi9fLwZ5w4/lP7jmTeJ5YRy3LKueiZfd7DOhnlQTJQUbB860meISUkdNw8wFCF/JX/cMEJSLQt9imbmKEUeeH8gTh/1pUIetXzeqcfk3Dp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790782450; c=relaxed/simple;
	bh=HiyC1FZcBagwNNtoYG1WPukff9q+hcVFqHe+FQNhV0w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IWhly1a+cEdaT2xXrFKyJxU/36BqSTEqOEWx2HwCnhErRNLKMzT5tIlev9zZkEpBGJXHhWaBSQDiYnVYFkWBLsGJEvcwpAx6p1nL2ZMBPvNnDHGgmx0WpVay4Pt0c+R0MQ+EjWYWU2GNMszjnpheDtarHYR26OdzExdCJ54xXp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nMrT6LaX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nMrT6LaX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC8731F000FF;
	Wed, 30 Sep 2026 15:34:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790782442;
	bh=KP+nkPv0/Cv0vwPC+HPE/H8JtexTm4PI2vGqrwH3K28=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nMrT6LaXNrcVBiMm8xv4cLxx8kAum1Wcs4tRSsjDtXSvNRYqCjG7ErNGw7Bcr/0c3
	 CEn/WdtGPlkmmuwETeHsEHGCKCZDHVYfZDLGXi0TOucAY/GyPcSMl1tBdkMNFIRbEK
	 MttrnuuJx5Q/41uoz5pQL5znFrJz0tNDj31wSkGc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 047/595] hpfs: handle set_blocksize failures
Date: Wed, 30 Sep 2026 17:19:00 +0200
Message-ID: <20260930152348.743471182@linuxfoundation.org>
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

[ Upstream commit a405996f23e04942aad064ab8d50c55827482872 ]

hpfs uses buffer_heads, which don't handle block size > PAGE_SIZE well.
Without this, mounting will hit the

        BUG_ON(offset >= folio_size(folio));

in folio_set_bh on the first __bread_gfp call.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Link: https://patch.msgid.link/20260511071701.2456211-3-hch@lst.de
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/hpfs/super.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/hpfs/super.c b/fs/hpfs/super.c
index a7dbfc8920227..a7c1f3ed04599 100644
--- a/fs/hpfs/super.c
+++ b/fs/hpfs/super.c
@@ -584,7 +584,8 @@ static int hpfs_fill_super(struct super_block *s, void *options, int silent)
 	}
 
 	/*sbi->sb_mounting = 1;*/
-	sb_set_blocksize(s, 512);
+	if (!sb_set_blocksize(s, 512))
+		goto bail0;
 	sbi->sb_fs_size = -1;
 	if (!(bootblock = hpfs_map_sector(s, 0, &bh0, 0))) goto bail1;
 	if (!(superblock = hpfs_map_sector(s, 16, &bh1, 1))) goto bail2;
-- 
2.53.0



