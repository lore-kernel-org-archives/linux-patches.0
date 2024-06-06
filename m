Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D127E1B5805;
	Thu,  6 Jun 2024 14:17:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683455; cv=none; b=Nn1gJBxkr16dYuipXFdY0MXDPKMG8kZlBMZCW1ltrM4xk4s0eq1PFIcBXqVOdxB4IGJ5/LIXRZJ/3fave+m+cukpiX0Lv3jIuLfEwciBl0P+ZFvpN1PfprtSzv+X9DrxdVgN3Fdfpmrcgcubhjl4fr8ork6IpZHLt2d10xN8LYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683455; c=relaxed/simple;
	bh=B2lXsrUt8avfhaRMDXWrkogQrwXFeSmvhvba+FQXFCU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yt1fYStvmI4Iih2O1UPvJAncKo8v3Ilei3nSZTEJUDR7mT4sAS49rJV2ZUQNQ6iTFZKgELTr09gGNUktEsmE/5/cmD5GG6UC7r2FKo3rjweWsbFcXw0jDAjYUmwhcn/nu0dUrqiUxdomLtEZC76+Ml+qz4F2btyK8t2f+hLWJNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yxLAX0BD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yxLAX0BD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0736C2BD10;
	Thu,  6 Jun 2024 14:17:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683455;
	bh=B2lXsrUt8avfhaRMDXWrkogQrwXFeSmvhvba+FQXFCU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yxLAX0BDf/8IcECAxDQuANRWVmhczNamaXgbl5bCw+XFF+BEz7MXbxp1GohQW4V9j
	 BWoVIcaE5cdqZ7qQsbPeGXMezkET7o2r03Z6/k9KsSnmtHPVqMGmhdBO64Is+QY8Tr
	 0EOpGRyS0NmQrN/z0iVMLKCeVqUq12Jc5dQaAe7c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 343/473] f2fs: fix to release node block count in error path of f2fs_new_node_page()
Date: Thu,  6 Jun 2024 16:04:32 +0200
Message-ID: <20240606131711.252349259@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

From: Chao Yu <chao@kernel.org>

[ Upstream commit 0fa4e57c1db263effd72d2149d4e21da0055c316 ]

It missed to call dec_valid_node_count() to release node block count
in error path, fix it.

Fixes: 141170b759e0 ("f2fs: fix to avoid use f2fs_bug_on() in f2fs_new_node_page()")
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/node.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index fcf22a50ff5db..745ecf5523c9b 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -1307,6 +1307,7 @@ struct page *f2fs_new_node_page(struct dnode_of_data *dn, unsigned int ofs)
 	}
 	if (unlikely(new_ni.blk_addr != NULL_ADDR)) {
 		err = -EFSCORRUPTED;
+		dec_valid_node_count(sbi, dn->inode, !ofs);
 		set_sbi_flag(sbi, SBI_NEED_FSCK);
 		f2fs_handle_error(sbi, ERROR_INVALID_BLKADDR);
 		goto fail;
@@ -1333,7 +1334,6 @@ struct page *f2fs_new_node_page(struct dnode_of_data *dn, unsigned int ofs)
 	if (ofs == 0)
 		inc_valid_inode_count(sbi);
 	return page;
-
 fail:
 	clear_node_page_dirty(page);
 	f2fs_put_page(page, 1);
-- 
2.43.0



