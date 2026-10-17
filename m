Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B314A37701A;
	Sat, 17 Oct 2026 17:57:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259841; cv=none; b=at+WapaRMkmcNAoM7u3lJ9WQ3k25VCmiMJjoSuRh8lf/y7gS2+zWPvnb0K9PBPaVuK9Vkyl32+/cGT8DofwiYMaLUlzpJCRDqvLRcbuWDNn1OzxP7v35rzTdCnmIL0RHfUXHg/XLuXUQp/KiW0j/hcpcqmHbAQQVozg9kgHrcDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259841; c=relaxed/simple;
	bh=sVLYQTXPDLj4aFtnAVj4P0G8rtvawXVmNG90Kt4KzNY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GMof4Y9LdqOHochUQdCdooAlHQ0ZStG8uyGfXu8bc9MyWLXQ/5UaDa/ZbbO/Wkg/inCOi15eQCgG8iJMat4CDAnNc2kUhPX7ALIpJhdvxlEy2mkiBS/IbJ+t9o31QvaMEkzyvMO9XvN/kOudfU390hg4i+98LC8vns30oW4fcFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kGiJpdUm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kGiJpdUm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FF0B1F000C4;
	Sat, 17 Oct 2026 17:57:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259840;
	bh=ndaBqGFXrRQQAtuwOlPZsweYTGeZ1zEWmhubtdI9ZuQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kGiJpdUmiMmbqF9EKf1PSzt+aM8HomK/OMJRLx8jqvVFVOhF2UU+1OgVtVMp2zP+V
	 sn33qsN1OBQhQwvnW+0p896CSoukvILy9eyV4LMyRmbgUrUAzvM1Yx/v2CxMXvXnfJ
	 HE0Z/BzWDrxCE34RgYNz13p8ES6PknmIQEzz7jfY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1348/1674] f2fs: fix to avoid potential deadloop in f2fs_fsync_node_pages()
Date: Sat, 17 Oct 2026 18:00:20 +0200
Message-ID: <20261017160505.759551749@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Chao Yu <chao@kernel.org>

[ Upstream commit ce366bfa821ec81dd45bde547ee31e659306cc61 ]

There is potential deadloop in race condition:

Thread A				Thread B
- fsync
 - f2fs_do_sync_file
  - f2fs_fsync_node_pages
   - last_fsync_dnode
    - folio_get(last_folio)
					- f2fs_setattr
					 - f2fs_truncate
					  - f2fs_truncate_blocks
					   - f2fs_do_truncate_blocks
					    - f2fs_truncate_inode_blocks
					     - truncate_dnode
					      - truncate_node
					       - invalidate_mapping_pages
					        - folio->mapping = NULL
   - is_node_folio alwasy return false
   - atomic && !marked is always true,
     then goto retry

Cc: stable@kernel.org
Fixes: 608514deba38 ("f2fs: set fsync mark only for the last dnode")
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/node.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 890ff1d341013..8aa52629f788c 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -1904,6 +1904,11 @@ int f2fs_fsync_node_pages(struct f2fs_sb_info *sbi, struct inode *inode,
 		f2fs_debug(sbi, "Retry to write fsync mark: ino=%u, idx=%lx",
 			   ino, last_page->index);
 		lock_page(last_page);
+		if (unlikely(last_page->mapping != NODE_MAPPING(sbi))) {
+			f2fs_put_page(last_page, 1);
+			ret = -EAGAIN;
+			goto out;
+		}
 		f2fs_wait_on_page_writeback(last_page, NODE, true, true);
 		set_page_dirty(last_page);
 		unlock_page(last_page);
-- 
2.53.0



