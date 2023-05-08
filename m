Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B01FB168C5
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:47:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ECFEC433EF;
	Mon,  8 May 2023 10:47:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683542873;
	bh=s8Xmz8VdBjcI34aoBM3Iu6ndDRRe9lhqstXwP+IWaPw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tlx9cff4oANThkiGerCF03wxtZdiYIhxhwYLpxEwlMgPSawplTjE48s4t1BtMcjbf
	 MOlkQG9bEwmEeYVoq0xwShglkCyuBcNaRspEE+Z7n9c6R68i+ccO3VbqJKiNz4K2yh
	 ZOKhcB0QOO5OiPejRDUkCDzI766FSmCBYpQ1GwMg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 576/663] ext4: fix i_disksize exceeding i_size problem in paritally written case
Date: Mon,  8 May 2023 11:46:42 +0200
Message-Id: <20230508094447.967939067@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094428.384831245@linuxfoundation.org>
References: <20230508094428.384831245@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zhihao Cheng <chengzhihao1@huawei.com>

[ Upstream commit 1dedde690303c05ef732b7c5c8356fdf60a4ade3 ]

It is possible for i_disksize can exceed i_size, triggering a warning.

generic_perform_write
 copied = iov_iter_copy_from_user_atomic(len) // copied < len
 ext4_da_write_end
 | ext4_update_i_disksize
 |  new_i_size = pos + copied;
 |  WRITE_ONCE(EXT4_I(inode)->i_disksize, newsize) // update i_disksize
 | generic_write_end
 |  copied = block_write_end(copied, len) // copied = 0
 |   if (unlikely(copied < len))
 |    if (!PageUptodate(page))
 |     copied = 0;
 |  if (pos + copied > inode->i_size) // return false
 if (unlikely(copied == 0))
  goto again;
 if (unlikely(iov_iter_fault_in_readable(i, bytes))) {
  status = -EFAULT;
  break;
 }

We get i_disksize greater than i_size here, which could trigger WARNING
check 'i_size_read(inode) < EXT4_I(inode)->i_disksize' while doing dio:

ext4_dio_write_iter
 iomap_dio_rw
  __iomap_dio_rw // return err, length is not aligned to 512
 ext4_handle_inode_extension
  WARN_ON_ONCE(i_size_read(inode) < EXT4_I(inode)->i_disksize) // Oops

 WARNING: CPU: 2 PID: 2609 at fs/ext4/file.c:319
 CPU: 2 PID: 2609 Comm: aa Not tainted 6.3.0-rc2
 RIP: 0010:ext4_file_write_iter+0xbc7
 Call Trace:
  vfs_write+0x3b1
  ksys_write+0x77
  do_syscall_64+0x39

Fix it by updating 'copied' value before updating i_disksize just like
ext4_write_inline_data_end() does.

A reproducer can be found in the buganizer link below.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=217209
Fixes: 64769240bd07 ("ext4: Add delayed allocation support in data=writeback mode")
Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20230321013721.89818-1-chengzhihao1@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/inode.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 96517785a9f89..0b87665aaff13 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3149,6 +3149,9 @@ static int ext4_da_write_end(struct file *file,
 	    ext4_has_inline_data(inode))
 		return ext4_write_inline_data_end(inode, pos, len, copied, page);
 
+	if (unlikely(copied < len) && !PageUptodate(page))
+		copied = 0;
+
 	start = pos & (PAGE_SIZE - 1);
 	end = start + copied - 1;
 
-- 
2.39.2



