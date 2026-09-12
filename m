Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AC96372ED0;
	Sat, 12 Sep 2026 18:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789239590; cv=none; b=jLDz9ddqDrIFEpUFgNHj0nCpN9IHPx4F47lTs0RpMoVNxmcMvRw64sVQ3Tbcwpj0UDqlcQl7LHocfIy5C3e+d9pprvjI/R6XapOQjAr9lsEiihgfT0WyTcaoUOfu6caMiGSLzffdx9INHMdjiBuKv80M11sot7SUPQrtQM6G3u0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789239590; c=relaxed/simple;
	bh=O0HYHdhDggfbY542hvIvwD9zGC8gaOHuU5hMjvWGElI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mzjWP9zSdFXT0eVByRUTrXomHsTg2SjUUZP141kAK2TNP2Uqk9lLz5eo8i2OiWEkHXOqii2ybA+54QBySB8qaPu4pRg9tpwLsufPXLojYY3idz7BFOdyTTG64XThAdLnA+IJiOqSJM3HZkM7DsJVu6vZzI+JsEoElW43VkB0v2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lrp7bgSB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lrp7bgSB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 512261F000FF;
	Sat, 12 Sep 2026 18:59:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789239588;
	bh=Z5RwYfskQofetWfB6tkIqHyj8wNUlsv5w1G9WA/q17k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Lrp7bgSBnIUKoUz+OfWw9rq6WjIQABjU24GdYFSVydNmnZC26GfR8fsrp506s7A3/
	 kwsccl2t7OANrOToG+Q9sB2IltFUdaTbEZp8pJU/wYzOjWcT/29MOZO80ItPnb8Sk1
	 GScWgCDn15pLijY33vF+vk89woAB/J3j79rMfqys=
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
Subject: [PATCH 5.15 695/935] fat: release buffer head after rebuilding parent
Date: Sat, 12 Sep 2026 09:02:05 +0200
Message-ID: <20260912065542.781060044@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index bab63eeaf9cbc..bb5f056a639a2 100644
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



