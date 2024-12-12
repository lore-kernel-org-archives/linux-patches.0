Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A986F211493;
	Thu, 12 Dec 2024 17:49:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025771; cv=none; b=pJahMHDVC2jirdKnOczlAPKbv6HfwP/t9RC652lgh2JyJTsJ12x7e67l9HEIcNU2gL2KWp4eav0ObfNcDfAPEOqMSK0GVej5yyMEtow/cLPi8BfeWSDOLR0GqPjBT4DaEDlZQ+CFfRtyR++FmZBA4K7vXxlXwhd3AW6NI0LCqSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025771; c=relaxed/simple;
	bh=nTqdnmyQ/Zo0dvo4XQSI5V5PGd1qtKiATzP6xQ8vxsw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gz8Bqe8fdJkYAOAmiccHm/ONu0DEpo5IUgOKq5q7+RAv95ObZwEkLkNu8+hpnv2LDOLwe8ZJLc26r6c4xWirnagu2ZEy4uz7WuAvHdSywPIwQApST84pPceZU8LiuX+4C9FUw8mabw8JSWCSLENRMydK3Z/05Mdk8d38ziq/D0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BxTZWMFB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BxTZWMFB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F7A2C4CECE;
	Thu, 12 Dec 2024 17:49:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734025771;
	bh=nTqdnmyQ/Zo0dvo4XQSI5V5PGd1qtKiATzP6xQ8vxsw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BxTZWMFBM6HMYcfycXus1kHJQVJtrPU6L53kEdkRJ/lG57OfQGyLYXFlsOpOYywwK
	 75V76v7w1MzWrDDwWGxCU97CA33/RHM09j/YGK2X2YCEgRdFxmiJvO8s4BcnXkhiVM
	 6sjNzNotake64Bag583Rn+CH01Ee9G5UkyJ15bfw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+b5ca8a249162c4b9a7d0@syzkaller.appspotmail.com,
	Ghanshyam Agrawal <ghanshyam1898@gmail.com>,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 283/321] jfs: fix shift-out-of-bounds in dbSplit
Date: Thu, 12 Dec 2024 16:03:21 +0100
Message-ID: <20241212144241.157771646@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
References: <20241212144229.291682835@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ghanshyam Agrawal <ghanshyam1898@gmail.com>

[ Upstream commit a5f5e4698f8abbb25fe4959814093fb5bfa1aa9d ]

When dmt_budmin is less than zero, it causes errors
in the later stages. Added a check to return an error beforehand
in dbAllocCtl itself.

Reported-by: syzbot+b5ca8a249162c4b9a7d0@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=b5ca8a249162c4b9a7d0
Signed-off-by: Ghanshyam Agrawal <ghanshyam1898@gmail.com>
Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/jfs/jfs_dmap.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/jfs/jfs_dmap.c b/fs/jfs/jfs_dmap.c
index 00258a551334a..d83ac5f5888a4 100644
--- a/fs/jfs/jfs_dmap.c
+++ b/fs/jfs/jfs_dmap.c
@@ -1886,6 +1886,9 @@ dbAllocCtl(struct bmap * bmp, s64 nblocks, int l2nb, s64 blkno, s64 * results)
 			return -EIO;
 		dp = (struct dmap *) mp->data;
 
+		if (dp->tree.budmin < 0)
+			return -EIO;
+
 		/* try to allocate the blocks.
 		 */
 		rc = dbAllocDmapLev(bmp, dp, (int) nblocks, l2nb, results);
-- 
2.43.0



