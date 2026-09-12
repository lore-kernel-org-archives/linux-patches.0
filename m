Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72B7D2D739C;
	Sat, 12 Sep 2026 14:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789224721; cv=none; b=B3efw/pPfqTLqiy71cgHk5t2ItuIJ1Q/oueskDEd6TYAMdlfePU3JwA9KaT1AXSK356u9lZqVfi0v+pPBF2nw2FuszGw9xFhw6M4/PJMhgX+900zgxzwnTygg2l5UMELOkA64D958H3Ew8RrpaeMSDsxm+ApqWLhgNIOom8S11A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789224721; c=relaxed/simple;
	bh=1SztyoP993/487O6S9KG9FF3U2vi+iy2j27ZKzutx4M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rWkn7YB0kCPK4qQsRn8FUBe908lgppA+qnFfDBIyEV6NK4Xq0pnHFuOe+nRo5sD5gxcfW08wADZF+pXY+J8u2WmNjSmTY+msuI3GsIadnokJgVk6UIepwFjnmnH3/DnEZ594XhMJFM8iE82rifhMPm9xXvAZFMWhCvgy62Yei9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z3c9aIGt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z3c9aIGt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7658B1F000FF;
	Sat, 12 Sep 2026 14:51:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789224720;
	bh=OpmJK7y5tVzEJGXrb/l2C64TswSUhbeyHnKld8Awdbo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z3c9aIGt6BntnVHoj/darFsPVdePuhQdm4ZKiYuGhRJM98I/iN4zwGig+v1KRxUu7
	 xXHZ3cS7lh/T9rnlQMemuw+Vyv137VZUnE5s+wTFtfPVtBMWG47h8HV5qMXRAZluc5
	 hbPsLMEaAPceCmjgndOL+SKIFBmNbVih3ih4qPxc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yichong Chen <chenyichong@uniontech.com>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Christian Brauner <brauner@kernel.org>,
	Amit Sahrawat <a.sahrawat@samsung.com>,
	Namjae Jeon <namjae.jeon@samsung.com>,
	Ravishankar N <ravi.n1@samsung.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1044/1424] fat: release buffer head after rebuilding parent
Date: Sat, 12 Sep 2026 08:57:56 +0200
Message-ID: <20260912065630.687468184@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yichong Chen <chenyichong@uniontech.com>

[ Upstream commit 83e98dbf19ab64e8528e101e20f8d50e1aaa68a8 ]

fat_scan_logstart() leaves the matching directory entry's buffer head in
sinfo.bh for the caller to release, just like fat_scan().

fat_rebuild_parent() uses the directory entry to rebuild the parent inode
for the nostale_ro NFS export path, but does not release sinfo.bh after a
successful scan.  Release it once fat_build_inode() has consumed the
directory entry data.

Link: https://lore.kernel.org/20260715020957.1096309-1-chenyichong@uniontech.com
Fixes: f1e6fb0ab451 ("fat (exportfs): rebuild directory-inode if fat_dget()")
Signed-off-by: Yichong Chen <chenyichong@uniontech.com>
Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Amit Sahrawat <a.sahrawat@samsung.com>
Cc: chenyichong <chenyichong@uniontech.com>
Cc: Namjae Jeon <namjae.jeon@samsung.com>
Cc: Ravishankar N <ravi.n1@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fat/nfs.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/fat/nfs.c b/fs/fat/nfs.c
index 93c97bf45b061..ad4c677d04758 100644
--- a/fs/fat/nfs.c
+++ b/fs/fat/nfs.c
@@ -250,8 +250,10 @@ struct inode *fat_rebuild_parent(struct super_block *sb, int parent_logstart)
 		MSDOS_I(dummy_grand_parent)->i_pos = -1;
 	}
 
-	if (!fat_scan_logstart(dummy_grand_parent, clus_to_match, &sinfo))
+	if (!fat_scan_logstart(dummy_grand_parent, clus_to_match, &sinfo)) {
 		parent = fat_build_inode(sb, sinfo.de, sinfo.i_pos);
+		brelse(sinfo.bh);
+	}
 
 	brelse(parent_bh);
 	iput(dummy_grand_parent);
-- 
2.53.0



