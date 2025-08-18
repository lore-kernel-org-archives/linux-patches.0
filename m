Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCA2F320397;
	Mon, 18 Aug 2025 13:07:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522475; cv=none; b=o02CORkKs23Gkv4MucO93xSpLtCBBYzqZKNCBLto98saYr/9tGbIYm/WO9eSnOLJexrhNu+B8ybjDuAhl2iZrM3MGxUM8COjdLRLcMdKobivWSJMM3IRMkGB4xJhyEEpn2QDt26JAS0K13s3r4kTd7eQEhiriyvxJbwWt9TptZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522475; c=relaxed/simple;
	bh=lzYXAkeP6AuMkSpkFAQGarexW4aREpxRVfxM4CKYH+Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Os7UETTSrZ4JbbIVVqymKDcLZNXm1/JiIsWVcuJB0DgdNWLVaxUzKCh/NpsPNQyEWYjM9RcfmC/zm/z6au6ZjP4MBJ9v1eC+zgl8hRwBSESlBNCjp7VSdkh126LY1yLDTFfPQGYLSDBG8juuSITpY+mFAH0nmjT/lX22NdnL+Ng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1XPPcgWs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1XPPcgWs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0383C4CEEB;
	Mon, 18 Aug 2025 13:07:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522475;
	bh=lzYXAkeP6AuMkSpkFAQGarexW4aREpxRVfxM4CKYH+Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1XPPcgWs+2wzPdq6C2DHqYSTJ+3CvMG94ArXQSo6VbDQeom2J7Uj3ZtqCoThQRrbg
	 oITi0Ft4NWZiMl7nt4+C6Q7pBmFaD/qClJO2tqrIfqrGpRZjGjvO7qL5A7uL0vxUPy
	 6ovYLCf4i7nX8Md89s8gfL1Elm72RMIQbhAIFBlI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+cffd18309153948f3c3e@syzkaller.appspotmail.com,
	Arnaud Lecomte <contact@arnaud-lcm.com>,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 294/444] jfs: upper bound check of tree index in dbAllocAG
Date: Mon, 18 Aug 2025 14:45:20 +0200
Message-ID: <20250818124459.982813548@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Arnaud Lecomte <contact@arnaud-lcm.com>

[ Upstream commit c214006856ff52a8ff17ed8da52d50601d54f9ce ]

When computing the tree index in dbAllocAG, we never check if we are
out of bounds realative to the size of the stree.
This could happen in a scenario where the filesystem metadata are
corrupted.

Reported-by: syzbot+cffd18309153948f3c3e@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=cffd18309153948f3c3e
Tested-by: syzbot+cffd18309153948f3c3e@syzkaller.appspotmail.com
Signed-off-by: Arnaud Lecomte <contact@arnaud-lcm.com>
Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/jfs/jfs_dmap.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/jfs/jfs_dmap.c b/fs/jfs/jfs_dmap.c
index 5a877261c3fe..cdfa699cd7c8 100644
--- a/fs/jfs/jfs_dmap.c
+++ b/fs/jfs/jfs_dmap.c
@@ -1389,6 +1389,12 @@ dbAllocAG(struct bmap * bmp, int agno, s64 nblocks, int l2nb, s64 * results)
 	    (1 << (L2LPERCTL - (bmp->db_agheight << 1))) / bmp->db_agwidth;
 	ti = bmp->db_agstart + bmp->db_agwidth * (agno & (agperlev - 1));
 
+	if (ti < 0 || ti >= le32_to_cpu(dcp->nleafs)) {
+		jfs_error(bmp->db_ipbmap->i_sb, "Corrupt dmapctl page\n");
+		release_metapage(mp);
+		return -EIO;
+	}
+
 	/* dmap control page trees fan-out by 4 and a single allocation
 	 * group may be described by 1 or 2 subtrees within the ag level
 	 * dmap control page, depending upon the ag size. examine the ag's
-- 
2.39.5



