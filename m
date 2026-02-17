Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49B1B2D46D6;
	Tue, 17 Feb 2026 20:42:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771360960; cv=none; b=kSr57x1l5agWyq+ELYnpeJlSHn/HITYVMnC9NR7LcO/+F8OkRqAWWetHcmnCrcFd30t6uirIrhVoHSa5aRQZIPl2a++MmetfsDFoSbk9+bD4LIRTUfcaN5CZ3+Qjnd3eoCp8z9M7mSKu7w/5CC+y5aMf5MUieTqY+7p19wgqG/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771360960; c=relaxed/simple;
	bh=XJqWCOIT5HSY3klfiwpieASXnxUfZ72lW/5cuoC+HoM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PhR2jYzuFSrgqyDfVmpK/uHbU/mcW2BIOSboXbj1isAzz1walqd2Jz+GcuaNR3YK7A6+Bf0rcJK5ICYM99Q6AiKQmGliLwz1b3zbLWqJETdry5HXF+SQYR7qHfDxG0oOzkB0RXYC5qPmcJzdyNhmy5n5jjGXKYPf3JDNT9Fi5dg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kvYT8DOy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kvYT8DOy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62DFBC4CEF7;
	Tue, 17 Feb 2026 20:42:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771360960;
	bh=XJqWCOIT5HSY3klfiwpieASXnxUfZ72lW/5cuoC+HoM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kvYT8DOyI1z5WwVMKZYf7sQ3wKRnAgcnOlr5fHVFI3K3AoElb9ibeIBT+CU/kgfg5
	 bfrDzeq7X/LBgLStFa4PEQgZVgxRa+nm5oI2TfafLU6V/0B4uLsmSdv0LebASoTFg3
	 BeqCPeKSxmAVqS93lsUtmx4iuI4O2hBjeCBV2ASY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+7eedce5eb281acd832f0@syzkaller.appspotmail.com,
	Edward Adam Davis <eadavis@qq.com>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>
Subject: [PATCH 5.10 04/24] nilfs2: Fix potential block overflow that cause system hang
Date: Tue, 17 Feb 2026 21:31:17 +0100
Message-ID: <20260217200000.879901190@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260217200000.708219618@linuxfoundation.org>
References: <20260217200000.708219618@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Edward Adam Davis <eadavis@qq.com>

commit ed527ef0c264e4bed6c7b2a158ddf516b17f5f66 upstream.

When a user executes the FITRIM command, an underflow can occur when
calculating nblocks if end_block is too small. Since nblocks is of
type sector_t, which is u64, a negative nblocks value will become a
very large positive integer. This ultimately leads to the block layer
function __blkdev_issue_discard() taking an excessively long time to
process the bio chain, and the ns_segctor_sem lock remains held for a
long period. This prevents other tasks from acquiring the ns_segctor_sem
lock, resulting in the hang reported by syzbot in [1].

If the ending block is too small, typically if it is smaller than 4KiB
range, depending on the usage of the segment 0, it may be possible to
attempt a discard request beyond the device size causing the hang.

Exiting successfully and assign the discarded size (0 in this case)
to range->len.

Although the start and len values in the user input range are too small,
a conservative strategy is adopted here to safely ignore them, which is
equivalent to a no-op; it will not perform any trimming and will not
throw an error.

[1]
task:segctord state:D stack:28968 pid:6093 tgid:6093  ppid:2 task_flags:0x200040 flags:0x00080000
Call Trace:
 rwbase_write_lock+0x3dd/0x750 kernel/locking/rwbase_rt.c:272
 nilfs_transaction_lock+0x253/0x4c0 fs/nilfs2/segment.c:357
 nilfs_segctor_thread_construct fs/nilfs2/segment.c:2569 [inline]
 nilfs_segctor_thread+0x6ec/0xe00 fs/nilfs2/segment.c:2684

[ryusuke: corrected part of the commit message about the consequences]

Fixes: 82e11e857be3 ("nilfs2: add nilfs_sufile_trim_fs to trim clean segs")
Reported-by: syzbot+7eedce5eb281acd832f0@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=7eedce5eb281acd832f0
Signed-off-by: Edward Adam Davis <eadavis@qq.com>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Viacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nilfs2/sufile.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/nilfs2/sufile.c
+++ b/fs/nilfs2/sufile.c
@@ -1091,6 +1091,9 @@ int nilfs_sufile_trim_fs(struct inode *s
 	else
 		end_block = start_block + len - 1;
 
+	if (end_block < nilfs->ns_first_data_block)
+		goto out;
+
 	segnum = nilfs_get_segnum_of_block(nilfs, start_block);
 	segnum_end = nilfs_get_segnum_of_block(nilfs, end_block);
 
@@ -1188,6 +1191,7 @@ int nilfs_sufile_trim_fs(struct inode *s
 out_sem:
 	up_read(&NILFS_MDT(sufile)->mi_sem);
 
+out:
 	range->len = ndiscarded << nilfs->ns_blocksize_bits;
 	return ret;
 }


