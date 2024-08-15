Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 940A81714AE;
	Thu, 15 Aug 2024 13:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729096; cv=none; b=OV+CltstyaHM08RrwZRcbcYQfVQlWlXtELMBPKs9799qcmHrlO2BN9mOfmPiEaVEj9mCUoD+ygJxnMeuN1ZKcd0K1gjIto1Hn2GyCQjMAJuVDXP559n+wGtQ1mA2mbCtEQ117MbUM6AltUCiOSbYOCJIf8m56k6n1YMMd1VwcJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729096; c=relaxed/simple;
	bh=J11mafeUnBmCB7D2iDiVQSNJ3qUV2JAl/JpVzUbWIss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RRSmzDLsXpX5Jf4gqwtS+UQg+a0wCMlsckKZZZoZXxeQecoYDgBefXe0tqbpgjOg2FVXFkjJ8a3bkfsxaZsas+JTueoZEpFkMvHCbMv1WalqK8yV5Zh4VhXB6YCwkenn5UeZsr9IXobKO4HxX9vI1PAnwzguBtCepkuSxS4475o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gBIatPTp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gBIatPTp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C476C32786;
	Thu, 15 Aug 2024 13:38:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729096;
	bh=J11mafeUnBmCB7D2iDiVQSNJ3qUV2JAl/JpVzUbWIss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gBIatPTpfQdjNiINKY2NYvzgv5VvleF3lwPkMt0N+BhVtmN9mgJvQ6YfCL8hGOv6q
	 EdUG098JCGt0BMFtc3JA7kNP6PQZGUbREHH6rCbfpCW8L+IJLGdX9bhYLm40CULRDE
	 yPEc0vTzKIogPlVxMPK1d5d1eZbGp/wCxJXt7utk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+61be3359d2ee3467e7e4@syzkaller.appspotmail.com,
	Pei Li <peili.dev@gmail.com>,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 13/22] jfs: Fix shift-out-of-bounds in dbDiscardAG
Date: Thu, 15 Aug 2024 15:25:21 +0200
Message-ID: <20240815131831.770471259@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131831.265729493@linuxfoundation.org>
References: <20240815131831.265729493@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index cb3cda1390adb..5713994328cbc 100644
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



