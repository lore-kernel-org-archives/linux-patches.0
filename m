Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216228;
	b=wr5hZJ5XZQjlS/vUl3IspR53OK50tg5Ho6DGeWtkTP4x8tiTOMyFojD4+fBUxJjvmfln
	 P7INBAP7+RiefzgJk8Hw9NOcii0WnIdV69+Yfue6Zk8MK7sPGBQ01K1cFXNRw3MyAy0Mg
	 XVHKqTmKpA6/b8Ivm4JIcP8iAX5Y6iZUC0utrSlIJLSGplobJeRRnOgJTf7cyfJqvL5Zb
	 6nYdlCUUKVRvSFluQUDvyyiX+RbSnMpSigP7+hx2JdNbS4hWOq1rQO7r1lzu6N/uH3smi
	 DCrmRqB8lEhoNlZktrkOLKzbY8Hv5f3e2GIxpinzJMXG89MqqjfVZzzG95l2UaM1vSw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216228;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ojTcHP9DzpbK0YxFzoGb008bsXe0+KsVRx6PIZ2Rids=;
	b=nZ62Pt9wiKYT8fFste6hRICP2ezN+swTqtde9uIhOE4pEjG6oTWP7EmF0vvHHlq08r0b
	 xJirfRnIqZEOsaW6Oa1ovYLF1nE9rTZmtOHM7Y5gmkfPOJyoFEv/pbgw+hzzBArF6hLhR
	 yNe4gx/hMAEHUcXH0KpxcAZ4xpXvgoZoeE9g6g1T65mU6cd5Lw+JY30VpmgkoXKrRl3Ib
	 2L8h0/+E5W9o/XvN/wufhsmyoj7VoZtB98hxMDDzW86WUCO10Dc9r/iFSlV1d+LtrqLKg
	 zGxqqi7/27C1YxgzYNpng/uiMUVHcsx3W1blP2LBcBFm4PrulWccdR8VGgEeFZmdQ/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u4jDf3Y1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58092606A330;
	Wed, 28 Oct 2026 19:37:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u4jDf3Y1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 592DA1F01825;
	Wed, 28 Oct 2026 19:37:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216227;
	bh=ojTcHP9DzpbK0YxFzoGb008bsXe0+KsVRx6PIZ2Rids=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u4jDf3Y10RstFQFaKZ/Oi8QOZm2IggnLCQwvM/0/0EqzW0cogUtmEfZJgjnS3oEZ+
	 Fokch/km7037hUa7+/LfQ3spiTwpCPvy8cBGVGSiMQOPpRRXw1Sb90MXWH0mslw7yY
	 fgNvLejMSS+vJ7vn0AnwkXWkjZpVh6buyyd7/q6E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1485/1887] f2fs: fix to avoid potential deadloop in f2fs_fsync_node_pages()
Date: Wed, 28 Oct 2026 17:59:41 +0100
Message-ID: <20261028170533.244612680@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 81ca7b42b984c..233448ba3a299 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -1891,6 +1891,11 @@ int f2fs_fsync_node_pages(struct f2fs_sb_info *sbi, struct inode *inode,
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



