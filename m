Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D4A91ABECF;
	Thu, 15 Aug 2024 14:08:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730895; cv=none; b=AwgwPLrQlYBEetPg6LGFIt9rvt9YHsyKIxa6UaAoLKCCElV1m2DmJrzWg+3k+w/3IX5FMmOdCxsNBY7s2TMiSHyBfI2RqRf7lZ5gMXlRxR0znAuf5uAu1hY8l/fun9DII2R0Fw/fbjXW4qLSDSyvRfEz7kUyeADn/9LENdHlLoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730895; c=relaxed/simple;
	bh=DdtJ0zL6B6qj2yLtu0ZITkmjJiYcuydhaoWfx/ehFGI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k4s+hEVoabVQvj4/Ua3yVWL+Ske2dJysxJA8n2ZwS4IueeU2vlldK3iegdxw7StDXAPfWDIijc0VMPwzZLTh1jKAArOR/i7RPPAeAksi9qclvxO56GQbwQmlBHKdhxklfnsXAywcuahqoE3ZDtfBGxV6k9LQXAKZOQ/2gYjJZ8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jUseQ9vA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jUseQ9vA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36DFCC32786;
	Thu, 15 Aug 2024 14:08:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730895;
	bh=DdtJ0zL6B6qj2yLtu0ZITkmjJiYcuydhaoWfx/ehFGI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jUseQ9vAWf+2gMrk7boFaeZaiAbr15HpLfLE1/S4749tcoa1RnTu7QHgeAPb29lFX
	 i6nKQ9mhjrhV9w7KeurgQXwncws65YjSnlOsP0IRIQ0FooRCarXfW+1TYs8CJNTDSu
	 hT6TdYKAHhqyyhliTriQmtPnh5i7sbM438VMDV4c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lizhi Xu <lizhi.xu@windriver.com>,
	Jan Kara <jack@suse.cz>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	syzbot+23bc20037854bb335d59@syzkaller.appspotmail.com
Subject: [PATCH 6.6 27/67] jfs: fix log->bdev_handle null ptr deref in lbmStartIO
Date: Thu, 15 Aug 2024 15:25:41 +0200
Message-ID: <20240815131839.373507495@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131838.311442229@linuxfoundation.org>
References: <20240815131838.311442229@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Lizhi Xu <lizhi.xu@windriver.com>

[ Upstream commit 6306ff39a7fcb7e9c59a00e6860b933b71a2ed3e ]

When sbi->flag is JFS_NOINTEGRITY in lmLogOpen(), log->bdev_handle can't
be inited, so it value will be NULL.
Therefore, add the "log ->no_integrity=1" judgment in lbmStartIO() to avoid such
problems.

Reported-and-tested-by: syzbot+23bc20037854bb335d59@syzkaller.appspotmail.com
Signed-off-by: Lizhi Xu <lizhi.xu@windriver.com>
Link: https://lore.kernel.org/r/20231009094557.1398920-1-lizhi.xu@windriver.com
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/jfs/jfs_logmgr.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/jfs/jfs_logmgr.c b/fs/jfs/jfs_logmgr.c
index c911d838b8ec8..cb6d1fda66a70 100644
--- a/fs/jfs/jfs_logmgr.c
+++ b/fs/jfs/jfs_logmgr.c
@@ -2110,10 +2110,14 @@ static void lbmStartIO(struct lbuf * bp)
 {
 	struct bio *bio;
 	struct jfs_log *log = bp->l_log;
+	struct block_device *bdev = NULL;
 
 	jfs_info("lbmStartIO");
 
-	bio = bio_alloc(log->bdev_handle->bdev, 1, REQ_OP_WRITE | REQ_SYNC,
+	if (!log->no_integrity)
+		bdev = log->bdev_handle->bdev;
+
+	bio = bio_alloc(bdev, 1, REQ_OP_WRITE | REQ_SYNC,
 			GFP_NOFS);
 	bio->bi_iter.bi_sector = bp->l_blkno << (log->l2bsize - 9);
 	__bio_add_page(bio, bp->l_page, LOGPSIZE, bp->l_offset);
-- 
2.43.0



