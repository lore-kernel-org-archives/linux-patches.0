Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91B5A35A29E;
	Tue, 26 Aug 2025 14:37:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756219071; cv=none; b=K4bsX18nerDzTLFVD4TNZKFDAiHyr6/SH34cWy5pznhPrY4G2457mNUY/6O2L5E3Jnuumgc6tTiQUBz8l1e18Y1+RKt884/6W9YMPHfcBbpTY8zPo3AXmToCNMlRqXCAyxMhEuYLcizXsDLGtkGRrF52v4ZHH4ceWZwNJNMTKWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756219071; c=relaxed/simple;
	bh=FjMqsq9z1mzeFBdvGUn0P0DNXBFzXcHdbZ7BXTRphzw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gqS9pjRySR7g/uKcrJv3S+DqvglpImsAlIhtRWEfVPKTLDrzHTckDiVl4xXmzkwk7RY7i2j8xloHSGa6LMAefN+uQLWPTRE773zJOImqgacxEnIRcTYrQW/BIB05xY3of2/pJKFpyXTx6zWWikBpuzdb8W44Gu2MPBJiGZNf+RQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zT6iRS7d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zT6iRS7d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84941C113CF;
	Tue, 26 Aug 2025 14:37:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756219070;
	bh=FjMqsq9z1mzeFBdvGUn0P0DNXBFzXcHdbZ7BXTRphzw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zT6iRS7dcL+NsFYtcvLe8WSnDr8xUutxzMys3rkF5So1+fa6P8fnZg0oUdtNk9BiN
	 bUUu3X28PZJ9FmVZ8twprDb+LwpyPI3NC4Iw6Z6xCheVZPPBT1YunUHjkMsTnsc3pF
	 YlZcxmvYSHj3Q3pVpMajX9rIBNG0UB+39wqGIdsg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+cffd18309153948f3c3e@syzkaller.appspotmail.com,
	Arnaud Lecomte <contact@arnaud-lcm.com>,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 241/403] jfs: upper bound check of tree index in dbAllocAG
Date: Tue, 26 Aug 2025 13:09:27 +0200
Message-ID: <20250826110913.487250859@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 15f885d2fa3d..17c4e7bdf283 100644
--- a/fs/jfs/jfs_dmap.c
+++ b/fs/jfs/jfs_dmap.c
@@ -1457,6 +1457,12 @@ dbAllocAG(struct bmap * bmp, int agno, s64 nblocks, int l2nb, s64 * results)
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



