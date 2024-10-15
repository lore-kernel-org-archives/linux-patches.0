Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3401C1C57B1;
	Tue, 15 Oct 2024 12:01:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993692; cv=none; b=r4tJXMoOkbQa3KoZQ3PkxZq3c9E57EaL4BFtFs1sYwc6DeKHzm10e2o2CZfOyishBt/DgrW+JBkgI0M3v7In6XmeI7jIHBu8fbCThUkA1xrmge3u+z3Kr8DQPGv7MawxQMhnpRliSoggpHqZDMso/nJ/ULJNxeLE43yfWi7U/Sk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993692; c=relaxed/simple;
	bh=/BJB9U59gNSTIjsaurdFPeAdUZWphYSBOQAaYY5kZIc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z8qg4tzyd3D1ixZNzM8+rvf2273Cp4SIIEu+VXN+xGE4XxskZyPUAlt4CXVtF5k6qeMGYiSqq3dbneLNuRa2UYK/DSfVy1gbkaOQHAoyklAGMhsga0HcfQX3zNL35yTLq+y/4a2D+jf1KL3nnL/eO3iqzw+2NuHbsry2q6M2Fdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YBZEu49O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YBZEu49O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98066C4CEC6;
	Tue, 15 Oct 2024 12:01:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993692;
	bh=/BJB9U59gNSTIjsaurdFPeAdUZWphYSBOQAaYY5kZIc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YBZEu49OyEsKqWFDNQl2abaFLmt6mWLix2mhijMx2Aky1KDanZ6wML8DPfQ+8SV31
	 XLzmOn5IDuHfqL7jQdUA8kYdkLSLgJmxih304QS5N4MUlWhilbAFkXi3UAYLT3IEAN
	 46WZ1fJ2kmOAkD5WZPjbG2jKQ21rCihiWKjKkC0Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edward Adam Davis <eadavis@qq.com>,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	syzbot+dca05492eff41f604890@syzkaller.appspotmail.com
Subject: [PATCH 5.15 455/691] jfs: check if leafidx greater than num leaves per dmap tree
Date: Tue, 15 Oct 2024 13:26:43 +0200
Message-ID: <20241015112458.406890337@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Edward Adam Davis <eadavis@qq.com>

[ Upstream commit d64ff0d2306713ff084d4b09f84ed1a8c75ecc32 ]

syzbot report a out of bounds in dbSplit, it because dmt_leafidx greater
than num leaves per dmap tree, add a checking for dmt_leafidx in dbFindLeaf.

Shaggy:
Modified sanity check to apply to control pages as well as leaf pages.

Reported-and-tested-by: syzbot+dca05492eff41f604890@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=dca05492eff41f604890
Signed-off-by: Edward Adam Davis <eadavis@qq.com>
Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/jfs/jfs_dmap.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/jfs/jfs_dmap.c b/fs/jfs/jfs_dmap.c
index 1eb28c4ccee54..2c8905391ad3e 100644
--- a/fs/jfs/jfs_dmap.c
+++ b/fs/jfs/jfs_dmap.c
@@ -3010,9 +3010,10 @@ static void dbAdjTree(dmtree_t *tp, int leafno, int newval, bool is_ctl)
 static int dbFindLeaf(dmtree_t *tp, int l2nb, int *leafidx, bool is_ctl)
 {
 	int ti, n = 0, k, x = 0;
-	int max_size;
+	int max_size, max_idx;
 
 	max_size = is_ctl ? CTLTREESIZE : TREESIZE;
+	max_idx = is_ctl ? LPERCTL : LPERDMAP;
 
 	/* first check the root of the tree to see if there is
 	 * sufficient free space.
@@ -3044,6 +3045,8 @@ static int dbFindLeaf(dmtree_t *tp, int l2nb, int *leafidx, bool is_ctl)
 		 */
 		assert(n < 4);
 	}
+	if (le32_to_cpu(tp->dmt_leafidx) >= max_idx)
+		return -ENOSPC;
 
 	/* set the return to the leftmost leaf describing sufficient
 	 * free space.
-- 
2.43.0



