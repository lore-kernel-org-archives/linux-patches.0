Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5674A196C75;
	Thu,  6 Jun 2024 14:08:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717682909; cv=none; b=KX89ihzkWwybfkou6RP78DRivrWv70pHRAeGxTMXSDEd4kKQpTOQOe9rAZuLl1zLJnmqd2T0QTeEAYIOZBUYxyOLkpTFYD0zc5VEJMnmdmgam3//FaZRbaQt3/54iBK21mi/qZxli0rOpnubVdP6eOFGb/sYSByqqjFN7v0KRQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717682909; c=relaxed/simple;
	bh=Fs5/e+NfsJWSVHWR8HOVg43MGTvPpqONI/mOZphfJzg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FIWbdHMdUDFcZAobibHME/xq2KKu7YUxbDbEOk3XqW7tT5wcey7Ps0h9S9Oem+AOoxxU59Sg2hKap3ye31hzXmG9pxh/5uyIeMY4ltBPYdCpYwoq14JHf91fJePZ/Rz5XLrMqtYVFdAvF4GiSsAcazUmsN+vk+3esh9fVFbRZqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EMNnFUe0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EMNnFUe0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 275EFC2BD10;
	Thu,  6 Jun 2024 14:08:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717682909;
	bh=Fs5/e+NfsJWSVHWR8HOVg43MGTvPpqONI/mOZphfJzg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EMNnFUe03i3rZxJ7jWF/v/NkqpGj9gst4RZCQiQRpKC9XyqFAnAeDggJ4U+yvnxwb
	 zJ73tDqnWRJa2AcuPOe0tz957o+iV5HXQamdSgBixgDpY2nRRC/e+Y9RqzwQ1NrGGq
	 KHnd6YoCuwmUsFNUHleGp6RFTbtBp4zjgAJg3Uu4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 009/374] f2fs: fix to wait on page writeback in __clone_blkaddrs()
Date: Thu,  6 Jun 2024 15:59:48 +0200
Message-ID: <20240606131652.043424685@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index 1761ad125f97a..06e3a69b45dc7 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -1325,6 +1325,9 @@ static int __clone_blkaddrs(struct inode *src_inode, struct inode *dst_inode,
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



