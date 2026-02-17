Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65E6937646D;
	Tue, 17 Feb 2026 20:44:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771361068; cv=none; b=t1fcSNXnKItrjGr+nJ+7OugUOisN94rJkcoBxVm4gwWO4Yuk06lc7THcbxDFwep8ZBzsT7fg2oCluHOVfv1xkiUhKUkA+oS/fa1Gc75QyqbhaxAsOxHsm9PSkevMLTbflTS6CqnN0yt48RmFLsf0/50NO4QybfoSKq0nY1rQAVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771361068; c=relaxed/simple;
	bh=vEfyLO9oVqGEvRbYYVQMHUuepnpvURq8gkDmykyad0c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oworlgBU9zy4sm5ls0IV/4sqngDrgrFiIL0vaMvibAFqcbg5wNWWDusnqZGqaw02UYd8SyfKeV2jiXCL79NIOx7LF0WSvqXojhp23SNspIu7RkIDUPY/rf+HcgZ0fRcs/7iKVsiNNNReBrnA74hYxjXtw1bsoacZGB16rANfvy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CfOwooqB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CfOwooqB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB247C4CEF7;
	Tue, 17 Feb 2026 20:44:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771361068;
	bh=vEfyLO9oVqGEvRbYYVQMHUuepnpvURq8gkDmykyad0c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CfOwooqBOI2CZOKvV97KHwB4dkc2X+WjucvfRu+ZqOjkeE5Ly/nkpb+5sHsod1eyU
	 Ae/+mW4I45eMUlv9DsjUta3jwyFEwQnaw7aNBU/COf4NkO2S7YVqmOVqpNXngecHFq
	 HQNboojiMZP+Iytt5fXV8fgmU5ohNnHXzCfr/4Dw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+7eedce5eb281acd832f0@syzkaller.appspotmail.com,
	Edward Adam Davis <eadavis@qq.com>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>
Subject: [PATCH 5.15 04/39] nilfs2: Fix potential block overflow that cause system hang
Date: Tue, 17 Feb 2026 21:31:13 +0100
Message-ID: <20260217200003.100149224@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260217200002.929083107@linuxfoundation.org>
References: <20260217200002.929083107@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


