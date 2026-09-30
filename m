Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9712D5226AE;
	Wed, 30 Sep 2026 17:52:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790734; cv=none; b=Re2CixRaxEo1494AdImkg1/T46UfZWIUy1OP2I15KugAXT4it4Cku/OdZuyzbgj0GYwmQpbFVAdmY/d1yWZTu3hclmONP2JtzFjpR3WfXXEfwbJMj4A4UPJmW/v71m9WyvJSr5RhuCifg8xUes3bEEdDHzc8woRdt4Iz0ytAHaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790734; c=relaxed/simple;
	bh=mk1eQ1q0IYMHUiobH3GL7iUZc336ZfT4KtDY0dSrEz0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jOqgnIBcQoQ7gegPLMyhqd/QlWlUeYygazAN9NEZEcfDKNXM9oEGNob/+ROrhjdiVaVYn+T4Uc7P50rPeIRmRHXieaVBuukd04yFTsvMEewibBdH/Lwe/AeHhiiK3mKPD+GX6GWpBGJo0+x1TxRSq3vUpdYC8PJQCmuh2OvyG90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kL/we8cj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kL/we8cj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFC011F000FF;
	Wed, 30 Sep 2026 17:52:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790733;
	bh=CgcQcKBrJTBUiTZ/d7gt8Zj/Nz4s44n2A8SA4buzD44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kL/we8cjM/B+RX7Db9wwqrssfJyETABAKcOglDdKAP8OA0VLu6FKKEHWBaDXuyES5
	 zE7ECYpotSfJ/+25s8rFblwFpYyyH0+TO/6F5gtRRs1Ce7zYm8/EYItteQOwrLx2Xo
	 VnpQycclpeuAw+6hwvWytdmnf3TZ/O9J4Ad5AfKE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 055/752] omfs: handle set_blocksize failures
Date: Wed, 30 Sep 2026 17:18:45 +0200
Message-ID: <20260930152359.348261557@linuxfoundation.org>
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
index 9773846daa4bc..760f675a73d92 100644
--- a/fs/omfs/inode.c
+++ b/fs/omfs/inode.c
@@ -480,7 +480,8 @@ static int omfs_fill_super(struct super_block *sb, void *data, int silent)
 	sb->s_time_min = 0;
 	sb->s_time_max = U64_MAX / MSEC_PER_SEC;
 
-	sb_set_blocksize(sb, 0x200);
+	if (!sb_set_blocksize(sb, 0x200))
+		goto end;
 
 	bh = sb_bread(sb, 0);
 	if (!bh)
@@ -532,7 +533,8 @@ static int omfs_fill_super(struct super_block *sb, void *data, int silent)
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



