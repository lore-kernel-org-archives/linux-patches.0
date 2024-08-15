Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4A8A1A01DA;
	Thu, 15 Aug 2024 14:10:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731041; cv=none; b=muNiRSRKpw4L2nPGbuhOAZfRxsLbJyQyuYOz6EGhXKCeEOAQAVEJfzNgn35zFSf1xSXIqUgL86gotQ5sjM+MmxBqYBl/bxWDjQZeW5WuSE0SnLrSYSm+NCwzACbeBbeaozDcywNtX2NO8GAnTtFkr95Ebe6jKQ9mcG7+b//LFVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731041; c=relaxed/simple;
	bh=deco8o9dY/E1cOOCptV8R9umO7mAaQiiEJf7uh9lEQg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OS/LY7myg082qTMnSUXf7ztLqkslMDp8aVc84F0P5oFlpwvcXpfOTLKd4KY05sDr2F56EtFypFB4VYXa26jANs4i+lQ6AzPDflpG4keknQFU3lReHxBKGLb/oaV1VDdnyfvpz5XVmNgD+R27XFC3kQVAsV7aD205PgRFvxxeCQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ScDewjBa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ScDewjBa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B2CDC4AF0C;
	Thu, 15 Aug 2024 14:10:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731041;
	bh=deco8o9dY/E1cOOCptV8R9umO7mAaQiiEJf7uh9lEQg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ScDewjBaKo0D1ms2mcRnMlh1quxlLi37BSsVUTXZXiHxaHsLqbcSz4RlpqWgrLMp4
	 QmRB6zlN0RjHdSk6Mnl6WdWv0LPCbka8b5mhFSBTeUxCc/VdoEq+kLdk0DynXbI/Dl
	 TYymMIA2XE97niO3tBHudYOklpD1GObnZ/WJB8Gc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+61be3359d2ee3467e7e4@syzkaller.appspotmail.com,
	Pei Li <peili.dev@gmail.com>,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 58/67] jfs: Fix shift-out-of-bounds in dbDiscardAG
Date: Thu, 15 Aug 2024 15:26:12 +0200
Message-ID: <20240815131840.530719668@linuxfoundation.org>
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

From: Pei Li <peili.dev@gmail.com>

[ Upstream commit 7063b80268e2593e58bee8a8d709c2f3ff93e2f2 ]

When searching for the next smaller log2 block, BLKSTOL2() returned 0,
causing shift exponent -1 to be negative.

This patch fixes the issue by exiting the loop directly when negative
shift is found.

Reported-by: syzbot+61be3359d2ee3467e7e4@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=61be3359d2ee3467e7e4
Signed-off-by: Pei Li <peili.dev@gmail.com>
Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/jfs/jfs_dmap.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/jfs/jfs_dmap.c b/fs/jfs/jfs_dmap.c
index 8eec84c651bfb..19eddbc5d616b 100644
--- a/fs/jfs/jfs_dmap.c
+++ b/fs/jfs/jfs_dmap.c
@@ -1626,6 +1626,8 @@ s64 dbDiscardAG(struct inode *ip, int agno, s64 minlen)
 		} else if (rc == -ENOSPC) {
 			/* search for next smaller log2 block */
 			l2nb = BLKSTOL2(nblocks) - 1;
+			if (unlikely(l2nb < 0))
+				break;
 			nblocks = 1LL << l2nb;
 		} else {
 			/* Trim any already allocated blocks */
-- 
2.43.0



