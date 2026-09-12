Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F4303905E6;
	Sat, 12 Sep 2026 16:32:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789230769; cv=none; b=N5dG50DR1qGjt3sBiQnWMM2IkOM15VGDIJQ1fFzdicQW2/lZJS1UJc8ArHOgcdK6mnfx/96m8gHoAYInA2mF865g+Xjye1xScnoxRI2rM7OTYT5GzYPJn4O+Xu6xgzYC4UQy3ES9vrPg1mgbhNmheh6Kh5Q3NdJio6rDhn7j5Zw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789230769; c=relaxed/simple;
	bh=QWuBQ+P7P0GGIBNmOhpozgjQo36xqbnmQggomM9IZ8U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uVDDQmpzGntmB4ruJRBSaPy4fGF+TPqJaXDr0kIaVfhX1V7+Do2bgepoXlVff3kV2IPFJeEG2R1+mMytdCwDRsvTEvDdZwrOtMwf0p1fmXeFvVr4WWbCS7f/hZqgRDGXl/AN6KPO04t/pBEYdaDqY8xbeZ7Lma49P5hHUu7oRas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0Q4WvTpG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0Q4WvTpG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A47B01F000FF;
	Sat, 12 Sep 2026 16:32:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789230768;
	bh=I9DV4EpxmflFQsBE3iR5XWTWiUoDPxBJ2GCaEbTLJ50=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0Q4WvTpGpWFo5/ztzn1gCpA/rgRh4+05ZPEhdXz53lwo9fI55w3ex1Il29Zoqh7gh
	 cIcn8cPDlROigdiYeXtL9LqQVZrYmUFgNu5n+WF6bpwfKhmmh8Po1TuyzQPTgoHiN9
	 5FCSyfYupQPm8yXvoDW5K6D3tlVpn1Acgp3OVUhM=
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
Subject: [PATCH 6.1 0861/1191] fat: release buffer head after rebuilding parent
Date: Sat, 12 Sep 2026 08:59:49 +0200
Message-ID: <20260912065607.590410410@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



