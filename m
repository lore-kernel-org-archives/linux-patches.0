Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15690364059;
	Sat, 12 Sep 2026 08:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201692; cv=none; b=eBjSx+ijGw5hkLnNdwX0gEwX2FqpvCB+yscrL6HhiORQvRrv+9qju5X2KlO16ELaqSf7Xv0x3hIJPDTHoucP7DsavuqEPUXz5z++ZbA8KyouHrdQav4zLt3D2MMq/03OQr+EkiPzIoCYQVyJVjPVh/IGenhnz1byitZrOGLFriY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201692; c=relaxed/simple;
	bh=iPylLVNwRgljdfghuORlPuwuSPraNrzHHgEdIqfsX9U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kaOlPwnOmvsiFhHI1rbtPz+2eVi4olP8SwKwidoI32Z/3ZwYZB+EwTiKX1fTOUn7j7L+0isipIuZrk6QPIl0hC4fqAM+oNHPkvufq7yIfwnfrB8XpCpmG8Rit1zndGmlEdVioQidCHKvFu0Xj8LCPs7bdyVP03b1f2kF8K84UqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vNEFgx+j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vNEFgx+j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 198F81F00893;
	Sat, 12 Sep 2026 08:28:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201691;
	bh=AliwTgBWFDSaAMQCcR9qrsncA9k6lBdPx1hcANWwfJY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vNEFgx+jUMTrvteZiJFZwggvwRFuAcwks0TjjOGQQ6PBiHY3X/WRy5P2JcvSiHGwL
	 WW8A4CsZ8goq87Jd774BBH1A5n00Ira//X6y5VNqoNsS8RS9whpLLYH+aS73CMU+Sq
	 5sIoOKuOygbpoHSMFqSIfqQH0vXt6bSKgIQgoLJw=
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
Subject: [PATCH 7.2 1046/1815] fat: release buffer head after rebuilding parent
Date: Sat, 12 Sep 2026 08:46:36 +0200
Message-ID: <20260912065713.573085341@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 509eea96a457d..6e1b371711edd 100644
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



