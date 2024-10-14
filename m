Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3290B1BC063;
	Mon, 14 Oct 2024 15:16:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918993; cv=none; b=YvRCZRMY8sHwOkiIHCKf/WplxgrspdnqxT90k3SVbOtAg8pEOff0xM+beb+b2x3e6dS8vchI7Xt4AdVWZMcujEPdF7J/NnwD1feKPH1I3F67LNPjjp0wpwV7pyYrjB30BjFVCgR6TuCTa2wmgIC7fxC2uBB37B/Ukpjg7NGzn2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918993; c=relaxed/simple;
	bh=R62mvRCJ+XWwVwMnhlylbSWiL8bsfs54oGO4kK2OoT0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nVsO2RtFBiQ2T49Wa1OciMru5Mrv7oFxNCBkYk9d/HQvV2jE51O/IAQgszGKzFb/QqqXhuKLwV7CIzuhnw34m1KliVV7gbz9QiSGDemn4DbOP32H2aZqxFW/6UONOwB6xwZ6wOfsRBDmIOXmv+7CSeBm/2u9FVFINDMM1DGWXPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G1CZNK9z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G1CZNK9z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF489C4CEC3;
	Mon, 14 Oct 2024 15:16:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918993;
	bh=R62mvRCJ+XWwVwMnhlylbSWiL8bsfs54oGO4kK2OoT0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G1CZNK9zFhrtoVzVZDQ2PJKorwd2IcH90hoAGgUF0qVQZ+iZS+KcJRMj95enqvcx0
	 k/CbR9ZEBVhu1Aauq7364LiNFiaQxvkDdIMewt9uwQ5ln00xqyeoai7kYZ78Hqui0s
	 Gu/HzDpcg5xH8NXCKrP/ulB/PDYPE3yWXHfWWdNI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edward Adam Davis <eadavis@qq.com>,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	syzbot+dca05492eff41f604890@syzkaller.appspotmail.com
Subject: [PATCH 6.1 482/798] jfs: check if leafidx greater than num leaves per dmap tree
Date: Mon, 14 Oct 2024 16:17:16 +0200
Message-ID: <20241014141236.909697239@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index b155e18297316..384aa6dfdb95e 100644
--- a/fs/jfs/jfs_dmap.c
+++ b/fs/jfs/jfs_dmap.c
@@ -2944,9 +2944,10 @@ static void dbAdjTree(dmtree_t *tp, int leafno, int newval, bool is_ctl)
 static int dbFindLeaf(dmtree_t *tp, int l2nb, int *leafidx, bool is_ctl)
 {
 	int ti, n = 0, k, x = 0;
-	int max_size;
+	int max_size, max_idx;
 
 	max_size = is_ctl ? CTLTREESIZE : TREESIZE;
+	max_idx = is_ctl ? LPERCTL : LPERDMAP;
 
 	/* first check the root of the tree to see if there is
 	 * sufficient free space.
@@ -2978,6 +2979,8 @@ static int dbFindLeaf(dmtree_t *tp, int l2nb, int *leafidx, bool is_ctl)
 		 */
 		assert(n < 4);
 	}
+	if (le32_to_cpu(tp->dmt_leafidx) >= max_idx)
+		return -ENOSPC;
 
 	/* set the return to the leftmost leaf describing sufficient
 	 * free space.
-- 
2.43.0



