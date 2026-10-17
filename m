Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E79A437BE64;
	Sat, 17 Oct 2026 16:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254873; cv=none; b=P5lBpiMBHtUEWZC4OI6hZelY5H4i8/wIqRPsS4oGV/ONK36LE90r8XJkGkr3K8QijaIoFrcNlF+f1Sksf2xi9taT1zludJuBU1W0lW+JpRcO+UmLY99JpPCa7jIC5g7uMUtPIpnOYea5M7xB6NYnm40FFYOnPMOqepSgxTJttZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254873; c=relaxed/simple;
	bh=VYB4lXxOqRCmmgpOD5Fl4QC/XnZ5TYyvMIWU0UfYEoc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TSy8u9dis+dC3r4x+SKuHTMzvPPFaVl+sUHXsSR/IbZCCFuf5Nj79m/fqs04j4PgGqvS9LmF+TNXA4X2ZtR3v8oj3bhsL8RUCMyKB/BBf/OJzzpjHFyTpYDnI9SaCaexgfFeb3fY6DZ+xm0+WIHT4ia68ePhtpaBwsz7+DzT6Rk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ug8aQmnY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ug8aQmnY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 494E51F000C4;
	Sat, 17 Oct 2026 16:34:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254872;
	bh=mY+tmW3WADqEP9KxdJ9OAmvGvKZPbt91oGuE5x68+/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ug8aQmnYGA+uzb7wldI8ev820V/eerZGOlYYm/9OJyXfrJj4eoz+autM+sEwxRM+l
	 1m9RNwwTASLsbuLykj8wzNdTPO0yULguQxG9yoDSmzOk5z13GAj0DpfFUTYzN0ZYtj
	 N6L2pk3U0fNrIDK4fOzKGY+g2v4pxsiRBHzHvwp4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 589/869] f2fs: fix to avoid potential deadloop in f2fs_fsync_node_pages()
Date: Sat, 17 Oct 2026 17:57:10 +0200
Message-ID: <20261017160052.154647732@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 111eba597a4a4..8a11623dbf1ef 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -1916,6 +1916,11 @@ int f2fs_fsync_node_pages(struct f2fs_sb_info *sbi, struct inode *inode,
 		f2fs_debug(sbi, "Retry to write fsync mark: ino=%u, idx=%lx",
 			   ino, page_folio(last_page)->index);
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



