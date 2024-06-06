Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1B081B29A4;
	Thu,  6 Jun 2024 14:16:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683400; cv=none; b=BJVsO/2LrOmVsZUWhDBUz48XlIsXdUqEdD9htutACw/wxu+Y4w7sM/9BARHOF4nQ4zcBg5F9Dr291nBkImOeIMalhvHJYnBv3prdM8GJW7uccfQaHIWSOx1q7kaFwk50UNDQUnRFB4xmAKcxNT1sNM3PHsH1VmkvcK55iOkcQro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683400; c=relaxed/simple;
	bh=PgQuOTiMSvTQfIXBm9o8ecdj8N/nCMZVoBVQDc42KaA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TVpzxWkD4s7PphBhwabjQEZKPeHOj4QRrb/2WVKso871HkNGkn+nRjATmYPKcjFzcXD3do03pSpUo8f1ePUw+DOF2RNeD3lENlhgVQNhYN1nw1MM8yaTUHuwJ6k7gWAw/w8e0NcOOJkNZmaq6ILbRd+IwUMyh2qaGEobIGgTcKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TI1DwPUP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TI1DwPUP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E55CC2BD10;
	Thu,  6 Jun 2024 14:16:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683400;
	bh=PgQuOTiMSvTQfIXBm9o8ecdj8N/nCMZVoBVQDc42KaA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TI1DwPUPobqmb3MboiiyRUryADbIqoxDAuGy73Tm7hRItBJCoHSb9Oe4K+RRc/BfI
	 WuifVWecX1qrresF62ZpR++cY/c/OpXVSooUPhG3c8wwO4NC6XCukzMZIzgwv3XP7w
	 Br6USAvvOO3wZjSn3Z9kgc1vWjEC9VTiUiLu7bvE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 284/473] f2fs: fix to wait on page writeback in __clone_blkaddrs()
Date: Thu,  6 Jun 2024 16:03:33 +0200
Message-ID: <20240606131709.280109276@linuxfoundation.org>
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

[ Upstream commit d3876e34e7e789e2cbdd782360fef2a777391082 ]

In below race condition, dst page may become writeback status
in __clone_blkaddrs(), it needs to wait writeback before update,
fix it.

Thread A				GC Thread
- f2fs_move_file_range
  - filemap_write_and_wait_range(dst)
					- gc_data_segment
					 - f2fs_down_write(dst)
					 - move_data_page
					  - set_page_writeback(dst_page)
					  - f2fs_submit_page_write
					 - f2fs_up_write(dst)
  - f2fs_down_write(dst)
  - __exchange_data_block
   - __clone_blkaddrs
    - f2fs_get_new_data_page
    - memcpy_page

Fixes: 0a2aa8fbb969 ("f2fs: refactor __exchange_data_block for speed up")
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/file.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 2fbc8d89c600b..9b325290d6a54 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -1314,6 +1314,9 @@ static int __clone_blkaddrs(struct inode *src_inode, struct inode *dst_inode,
 				f2fs_put_page(psrc, 1);
 				return PTR_ERR(pdst);
 			}
+
+			f2fs_wait_on_page_writeback(pdst, DATA, true, true);
+
 			memcpy_page(pdst, 0, psrc, 0, PAGE_SIZE);
 			set_page_dirty(pdst);
 			set_page_private_gcing(pdst);
-- 
2.43.0



