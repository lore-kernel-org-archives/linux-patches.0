Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBEA1627EA;
	Tue, 23 Jan 2024 00:53:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971181; cv=none; b=WbBq9+zJFhyNcvVYal7c6JnBhQ5Vrs6UZJGM3SieUshSM5+nNBy/wT0meTGG2dMNF9s0E5mK0bk9CB528h0EbbvLVgS9ymYN5oXpefPJjFnXWatZ3FE3VJO4ASPmD90iId6V55yCGhm5HsWww1y8b8leozL/oLHvd3vepTvChO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971181; c=relaxed/simple;
	bh=q0RgdLH61vzH9xnClr702oglOURilGUPz0Jnm1avVrA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZTa24LbcOpQde92lD7f6r2H1mzcq7rkARyVzjBrRu6UmmDS1cX6Zx8Py/aJupru2QxGI2fc+4wVsuWAW56ywpiHyuiMgGAc3CnEzCj3YdnC2dWnIyIbghw5PwbKBeHsBOiBUIPra2rkU4A6nY1elsmSb/atOmBLlaIzffNq243c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=trWa6SAu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="trWa6SAu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D6E3C433F1;
	Tue, 23 Jan 2024 00:53:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971180;
	bh=q0RgdLH61vzH9xnClr702oglOURilGUPz0Jnm1avVrA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=trWa6SAucuCP7zScLVK+sDnnAJUrGELFSDfgjlTl/+FZs9HGD79CT9e2mCngI2ueZ
	 VYL2BsfbLKRyKu+3aMURZEIWCT/Q+/M7legysZF1joRGi6DsL8/0bUBrq/2CDbLZ16
	 ooUC2CYBxP9eJGFOlCMr0l4H5URx4FS+E4+iZBTA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 198/417] f2fs: fix to wait on block writeback for post_read case
Date: Mon, 22 Jan 2024 15:56:06 -0800
Message-ID: <20240122235758.795244398@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

[ Upstream commit 55fdc1c24a1d6229fe0ecf31335fb9a2eceaaa00 ]

If inode is compressed, but not encrypted, it missed to call
f2fs_wait_on_block_writeback() to wait for GCed page writeback
in IPU write path.

Thread A				GC-Thread
					- f2fs_gc
					 - do_garbage_collect
					  - gc_data_segment
					   - move_data_block
					    - f2fs_submit_page_write
					     migrate normal cluster's block via
					     meta_inode's page cache
- f2fs_write_single_data_page
 - f2fs_do_write_data_page
  - f2fs_inplace_write_data
   - f2fs_submit_page_bio

IRQ
- f2fs_read_end_io
					IRQ
					old data overrides new data due to
					out-of-order GC and common IO.
					- f2fs_read_end_io

Fixes: 4c8ff7095bef ("f2fs: support data compression")
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/data.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 3666c1fd77a6..8b561af37974 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -2490,9 +2490,6 @@ int f2fs_encrypt_one_page(struct f2fs_io_info *fio)
 
 	page = fio->compressed_page ? fio->compressed_page : fio->page;
 
-	/* wait for GCed page writeback via META_MAPPING */
-	f2fs_wait_on_block_writeback(inode, fio->old_blkaddr);
-
 	if (fscrypt_inode_uses_inline_crypto(inode))
 		return 0;
 
@@ -2681,6 +2678,10 @@ int f2fs_do_write_data_page(struct f2fs_io_info *fio)
 		goto out_writepage;
 	}
 
+	/* wait for GCed page writeback via META_MAPPING */
+	if (fio->post_read)
+		f2fs_wait_on_block_writeback(inode, fio->old_blkaddr);
+
 	/*
 	 * If current allocation needs SSR,
 	 * it had better in-place writes for updated data.
-- 
2.43.0



