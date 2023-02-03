Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CE961FB4
	for <patches@lists.linux.dev>; Fri,  3 Feb 2023 10:22:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF2A3C433D2;
	Fri,  3 Feb 2023 10:22:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675419779;
	bh=0+jcL0cpGh18gP3DGO0pTxKbweqX1ksJ6xgS3QQQsZc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=giNSH+V0tF9YC4KVCHtRpU+dZ4TQ8gQrDOqAj0nn5PA+tN0Q1beG1/cIC7Cp0tZWi
	 Gf1DOYtYkIibtzXOaGJoHDTPA30YqVkITSfPMG9BhegxmJCnV5OL5ddgFt4EfowgJS
	 HqRvsqNCROPcFJHSIDnBhuZcPyDFtybwm5OytxAQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+a8e049cd3abd342936b6@syzkaller.appspotmail.com,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Siddh Raman Pant <code@siddh.me>,
	Chao Yu <chao@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 07/28] erofs/zmap.c: Fix incorrect offset calculation
Date: Fri,  3 Feb 2023 11:12:55 +0100
Message-Id: <20230203101010.285433065@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101009.946745030@linuxfoundation.org>
References: <20230203101009.946745030@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Siddh Raman Pant <code@siddh.me>

[ Upstream commit 6acd87d50998ef0afafc441613aeaf5a8f5c9eff ]

Effective offset to add to length was being incorrectly calculated,
which resulted in iomap->length being set to 0, triggering a WARN_ON
in iomap_iter_done().

Fix that, and describe it in comments.

This was reported as a crash by syzbot under an issue about a warning
encountered in iomap_iter_done(), but unrelated to erofs.

C reproducer: https://syzkaller.appspot.com/text?tag=ReproC&x=1037a6b2880000
Kernel config: https://syzkaller.appspot.com/text?tag=KernelConfig&x=e2021a61197ebe02
Dashboard link: https://syzkaller.appspot.com/bug?extid=a8e049cd3abd342936b6

Reported-by: syzbot+a8e049cd3abd342936b6@syzkaller.appspotmail.com
Suggested-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Signed-off-by: Siddh Raman Pant <code@siddh.me>
Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Link: https://lore.kernel.org/r/20221209102151.311049-1-code@siddh.me
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/zmap.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/erofs/zmap.c b/fs/erofs/zmap.c
index e6d5d7a18fb0..39cc014dba40 100644
--- a/fs/erofs/zmap.c
+++ b/fs/erofs/zmap.c
@@ -793,12 +793,16 @@ static int z_erofs_iomap_begin_report(struct inode *inode, loff_t offset,
 		iomap->type = IOMAP_HOLE;
 		iomap->addr = IOMAP_NULL_ADDR;
 		/*
-		 * No strict rule how to describe extents for post EOF, yet
-		 * we need do like below. Otherwise, iomap itself will get
+		 * No strict rule on how to describe extents for post EOF, yet
+		 * we need to do like below. Otherwise, iomap itself will get
 		 * into an endless loop on post EOF.
+		 *
+		 * Calculate the effective offset by subtracting extent start
+		 * (map.m_la) from the requested offset, and add it to length.
+		 * (NB: offset >= map.m_la always)
 		 */
 		if (iomap->offset >= inode->i_size)
-			iomap->length = length + map.m_la - offset;
+			iomap->length = length + offset - map.m_la;
 	}
 	iomap->flags = 0;
 	return 0;
-- 
2.39.0



