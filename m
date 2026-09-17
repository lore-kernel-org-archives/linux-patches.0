Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EF1B3B9922;
	Thu, 17 Sep 2026 17:52:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667563; cv=none; b=t1cMJWxqOtN7R4B938k4ypYrQEoK7ZiUYDIvg8q+Bret9fVRZBgFzRrrv/a95JlnSGgwgkPfXADUgV0a9F2wGSVuqBLphjPiAQiQGZL8n+nsuQI7tiJRceJ9aCorUQqNQHsKeJIwHGXiQI2h/tpcu0Ta1AW9Qy2bIeK4VEPREe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667563; c=relaxed/simple;
	bh=t3a7IoYkL3i5+qaYBpEEOrU0sWX5IzCFK48P/hJsI9s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SyPd4x5wrQ+/mgRuGm/ZICVTDrLgmxJy3pvotwuPvv+cpcYea/9WzjtGNzvrvfS5JwMUePGM/ctPamJWYTYG6hkCCzkKToLO7xhpkjF8SDDyYPoe5Rl2VNnzKLRJSfT19XpgBMGVGpa4K4qkc8oZ6wF/iqL9uwhxNo9j8RYjBSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L3er5vil; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L3er5vil"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2FC91F000FF;
	Thu, 17 Sep 2026 17:52:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667562;
	bh=eYvcP9ZrouM9sBpxeDsTpPhBQcej58UZu341iufiUHM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L3er5vilcRxA4ifw4IT6k5u4/fbB8ywWAYPlQzuEYsmpsJxaIWs+gIryOuOZm4Tdx
	 jTLE/nJ2FsVCIA03dwnCSWoeTO5O752/fUhz+ST2e2LFhMXfKuS6FsAgpUPgc/qwFy
	 k7u4WzCgawFcsjoL8paNFj03I+EgL90d8e453FGE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0127/1102] hpfs: handle set_blocksize failures
Date: Thu, 17 Sep 2026 16:01:10 +0100
Message-ID: <20260917151542.701958638@linuxfoundation.org>
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
index e73717daa5f90..10113587c96fb 100644
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



