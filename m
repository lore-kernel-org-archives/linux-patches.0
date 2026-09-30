Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF4573D47D4;
	Wed, 30 Sep 2026 18:48:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794099; cv=none; b=PiVc8xcTvjmqDFK5vBkBU0iZV7P9TPuMSW7aP88QD6NjHymgEG/sE0RNpe+U5Vz6jf/ssZlKr2hfkTlymebfNjSBmv4SlZDDUBiznDnNF4kjC2KeMql+yo9oOwhEjiK4Ez9+CR0KS5YwBZEYGXKMZ7g9qD09X/xc+RDp8ZFifPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794099; c=relaxed/simple;
	bh=wIwKJUJQMUhBv+iJ5D+7INTIQDSLQvRQpTsrrqpG5/I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BFH5iZP3xL2imCUEmYqQi3qWvk5j+GZZHrN/yAPKY5J1JJQeUX2FmD7JTuIFjYc5YM6OvcMCmS/ls2UDT8fhUSkZ3QIEU1szRHgvTmGXqxk7ZemSrx3MWkfcErJcLSoeIooUgUsISNgowxdWjX78tO/uTo+gQXJtQ4AjnboJdYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fW2sVpSg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fW2sVpSg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 486AF1F000FF;
	Wed, 30 Sep 2026 18:48:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794097;
	bh=hCLAgXvJR/m3F1tZYOQgnqWn4mdinYS5JWpS9XslptA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fW2sVpSgeToaVwuPqBq0J5cj73rywOTIYuBEc3/OP1BX/bV/iAqfpHCKCaRIKnlFD
	 lG/X2W/IrlCZFNvZHIyc1hsfNC5yfhg7HASLr40pCWPqX67liXY9cQwSTdScH4P0Iz
	 I7kjJjNvwq3DOAXtMk90PNuga0j5dTc41dnOW+dg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0090/1193] omfs: handle set_blocksize failures
Date: Wed, 30 Sep 2026 17:12:54 +0200
Message-ID: <20260930152436.243105800@linuxfoundation.org>
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
index 60ef691aeb702..979d9c4c5c107 100644
--- a/fs/omfs/inode.c
+++ b/fs/omfs/inode.c
@@ -479,7 +479,8 @@ static int omfs_fill_super(struct super_block *sb, void *data, int silent)
 	sb->s_time_min = 0;
 	sb->s_time_max = U64_MAX / MSEC_PER_SEC;
 
-	sb_set_blocksize(sb, 0x200);
+	if (!sb_set_blocksize(sb, 0x200))
+		goto end;
 
 	bh = sb_bread(sb, 0);
 	if (!bh)
@@ -531,7 +532,8 @@ static int omfs_fill_super(struct super_block *sb, void *data, int silent)
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



