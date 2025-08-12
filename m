Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2FB621A43B;
	Tue, 12 Aug 2025 19:18:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026283; cv=none; b=Q7HUJE+I2IngoxIz5QKltzbo3HYgA4zg+ID8qW5YFuEeFKeVIuR1ybNJSJQ5xM5Y92aoWiS0//iPOTTKXmAERDEJM4BbQCuJefWMWoFF7GUMIFiRQeKF65RgPCVwq+/9tIHl2urflTbJFaCGMmJQ+mI2M9LjCB4tMHBC1h8IO78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026283; c=relaxed/simple;
	bh=pzCgmtXr/JxkDwgVpG52x5yLd7kkAmG/tvFmf7cy/hk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ngfzVzYWOFlw2oH3gFuQo6TQAc8glyV/7R9kUA0mGtBZlQrKn2Wn6m9+L6gPlYzz/ViqOSL29x4nMnRtrBB4OwQyHQqoROFGxnsM/15+D9gp7ds36QRG4qXX8InYLPgYkQX1s6tymJ+Fbo00p8U6U4zUPMaLvqunu+I3p5nykfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a8sMkCS1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a8sMkCS1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DE35C4CEF0;
	Tue, 12 Aug 2025 19:18:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026282;
	bh=pzCgmtXr/JxkDwgVpG52x5yLd7kkAmG/tvFmf7cy/hk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a8sMkCS1/r4B9Gl8XXy22nVJ1YrVgdU4v82XKhthetwYS7RwrYV5lUpFNnkiVjK13
	 uvxyvD/IWQgzDBwiPc8oe8+lgTyNP7qDbtyPblY5O7BzbfmQGDstqcxivLF0sL1plJ
	 ukIsyhV2okfkfwd334CivyUBtrzjT5nOdtQ6EvSo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baolin Liu <liubaolin12138@163.com>,
	Zhi Long <longzhi@sangfor.com.cn>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 290/480] ext4: Make sure BH_New bit is cleared in ->write_end handler
Date: Tue, 12 Aug 2025 19:48:18 +0200
Message-ID: <20250812174409.393040577@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

[ Upstream commit 91b8ca8b26729b729dda8a4eddb9aceaea706f37 ]

Currently we clear BH_New bit in case of error and also in the standard
ext4_write_end() handler (in block_commit_write()). However
ext4_journalled_write_end() misses this clearing and thus we are leaving
stale BH_New bits behind. Generally ext4_block_write_begin() clears
these bits before any harm can be done but in case blocksize < pagesize
and we hit some error when processing a page with these stale bits,
we'll try to zero buffers with these stale BH_New bits and jbd2 will
complain (as buffers were not prepared for writing in this transaction).
Fix the problem by clearing BH_New bits in ext4_journalled_write_end()
and WARN if ext4_block_write_begin() sees stale BH_New bits.

Reported-by: Baolin Liu <liubaolin12138@163.com>
Reported-by: Zhi Long <longzhi@sangfor.com.cn>
Fixes: 3910b513fcdf ("ext4: persist the new uptodate buffers in ext4_journalled_zero_new_buffers")
Signed-off-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/20250709084831.23876-2-jack@suse.cz
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/inline.c | 2 ++
 fs/ext4/inode.c  | 3 ++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index e5e6bf0d338b..f27d9da53fb7 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -611,6 +611,7 @@ static int ext4_convert_inline_data_to_extent(struct address_space *mapping,
 	} else
 		ret = ext4_block_write_begin(handle, folio, from, to,
 					     ext4_get_block);
+	clear_buffer_new(folio_buffers(folio));
 
 	if (!ret && ext4_should_journal_data(inode)) {
 		ret = ext4_walk_page_buffers(handle, inode,
@@ -890,6 +891,7 @@ static int ext4_da_convert_inline_data_to_extent(struct address_space *mapping,
 		return ret;
 	}
 
+	clear_buffer_new(folio_buffers(folio));
 	folio_mark_dirty(folio);
 	folio_mark_uptodate(folio);
 	ext4_clear_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA);
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 7fcdc01a0220..46bfb39f6108 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1065,7 +1065,7 @@ int ext4_block_write_begin(handle_t *handle, struct folio *folio,
 			}
 			continue;
 		}
-		if (buffer_new(bh))
+		if (WARN_ON_ONCE(buffer_new(bh)))
 			clear_buffer_new(bh);
 		if (!buffer_mapped(bh)) {
 			WARN_ON(bh->b_size != blocksize);
@@ -1282,6 +1282,7 @@ static int write_end_fn(handle_t *handle, struct inode *inode,
 	ret = ext4_dirty_journalled_data(handle, bh);
 	clear_buffer_meta(bh);
 	clear_buffer_prio(bh);
+	clear_buffer_new(bh);
 	return ret;
 }
 
-- 
2.39.5



