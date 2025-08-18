Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0D0F335BAA;
	Mon, 18 Aug 2025 13:47:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524828; cv=none; b=OEvijvZDhv01xA5sKtG6aGI5OnVwzw9bEKJ7+4xGhRVm7ZhjH2GrMZkzGDGV4Ao1SL6MDcvO2kOaHbOgpiuYRXVcpCpL+dbEx5SKKvqnLfX6d2QFihhgqqN3wcDUKr+Sb5MmhgqSnyx5FjhRDYS7rG1WR09Qpk9aeSLUTzPFYZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524828; c=relaxed/simple;
	bh=5Ke9Qe4Hgr0M1GS19/+G9pXSCIZhZWWkAOqUe9dXoDs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tiZm/UAhtgJW3dsTsHMMS6KdRj4JHg7UyyljnPkzNP4UD2HUiepczawtcx08mIV4JZgyTgxoDUyIx772X9FaddVKIx7lRkajxqUpjtsVmmmZxGj86LZc2c2OPR/8CLZBTyC6iQ+0vhdcOToiEDbYp1qOSAZMrEgfykorUrKn3II=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=awChgCwY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="awChgCwY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12856C4CEEB;
	Mon, 18 Aug 2025 13:47:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524828;
	bh=5Ke9Qe4Hgr0M1GS19/+G9pXSCIZhZWWkAOqUe9dXoDs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=awChgCwYCzb4b5nxjhPeJtxoeHKcME0wUq7BlIPlioybNQyVP2nJnaCu0Gs5lQzrg
	 PxqK7iNucEmH4TbYPlEODBG5MQWVC/UamzP9gQxjI4qhzwgRiF1ykCEsqkag6brR9Y
	 rf0yJCpkaREoNezTDHWT5JtLcSVcUuDc5ruAdYjM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 076/570] erofs: fix block count report when 48-bit layout is on
Date: Mon, 18 Aug 2025 14:41:03 +0200
Message-ID: <20250818124508.754006993@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gao Xiang <hsiangkao@linux.alibaba.com>

[ Upstream commit 0b96d9bed324a1c1b7d02bfb9596351ef178428d ]

Fix incorrect shift order when combining the 48-bit block count.

Fixes: 2e1473d5195f ("erofs: implement 48-bit block addressing for unencoded inodes")
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Link: https://lore.kernel.org/r/20250807082019.3093539-1-hsiangkao@linux.alibaba.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/super.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/erofs/super.c b/fs/erofs/super.c
index e1e9f06e8342..799fef437aa8 100644
--- a/fs/erofs/super.c
+++ b/fs/erofs/super.c
@@ -313,8 +313,8 @@ static int erofs_read_superblock(struct super_block *sb)
 	sbi->islotbits = ilog2(sizeof(struct erofs_inode_compact));
 	if (erofs_sb_has_48bit(sbi) && dsb->rootnid_8b) {
 		sbi->root_nid = le64_to_cpu(dsb->rootnid_8b);
-		sbi->dif0.blocks = (sbi->dif0.blocks << 32) |
-				le16_to_cpu(dsb->rb.blocks_hi);
+		sbi->dif0.blocks = sbi->dif0.blocks |
+				((u64)le16_to_cpu(dsb->rb.blocks_hi) << 32);
 	} else {
 		sbi->root_nid = le16_to_cpu(dsb->rb.rootnid_2b);
 	}
-- 
2.50.1



