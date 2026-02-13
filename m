Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 525DB35FF61;
	Fri, 13 Feb 2026 13:55:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770990909; cv=none; b=rp3DhDnpYAVZ0lid/FHvcKVmrn5FBR0T1aoXSKZiD8x1PDiqUmRO+qaDxZJBAOP1NZbxgY1bggiVqTRix1y9Iwg5o+IdEUiSeuxFwV1YSP57V/gMjwLEna79yLOkSsOEtb6fVT+Ru/dlY4yunomqeA3qGKvD9bQr3WZXxsFU53c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770990909; c=relaxed/simple;
	bh=/+ZBDWpQIsCzuzi3RGGcL5spJWbOHIhekl3k7ENqgy8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sbpjP3VsSm6wIASm2SyCQM9FqMMQFsJ4XkgeLUpjflbuDkk5wB2fDQLIcIWabDZoLk/ZRLFiz1MLPpPe2xMNP/XPr0/NkCnfYBHsd1E43jlk573Y17UjHBgSjfxHJc9JJqlG8Llzk+UFYCayELf502UCpsQqD6nm9eGRtURmSPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vDkFzRq4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vDkFzRq4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3C10C116C6;
	Fri, 13 Feb 2026 13:55:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770990909;
	bh=/+ZBDWpQIsCzuzi3RGGcL5spJWbOHIhekl3k7ENqgy8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vDkFzRq4/949/IES4h4lCRrtyQDRO7J73nGu3Dp6LuPKcOtQlVBPUL6eiukpnKBeT
	 XDr83NdCkPEvg8m5aYOhJpN+Y2jHQgV/qc1ZmSV29fN+lBzLZ/w5o9kpgVb/tXpIPv
	 T5hNNyDncUQ76g50Pd6n8oPZtkzcNhMVkt8RXfuM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+7eedce5eb281acd832f0@syzkaller.appspotmail.com,
	Edward Adam Davis <eadavis@qq.com>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>
Subject: [PATCH 6.12 11/24] nilfs2: Fix potential block overflow that cause system hang
Date: Fri, 13 Feb 2026 14:48:30 +0100
Message-ID: <20260213134705.141008653@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260213134704.728003077@linuxfoundation.org>
References: <20260213134704.728003077@linuxfoundation.org>
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
@@ -1106,6 +1106,9 @@ int nilfs_sufile_trim_fs(struct inode *s
 	else
 		end_block = start_block + len - 1;
 
+	if (end_block < nilfs->ns_first_data_block)
+		goto out;
+
 	segnum = nilfs_get_segnum_of_block(nilfs, start_block);
 	segnum_end = nilfs_get_segnum_of_block(nilfs, end_block);
 
@@ -1203,6 +1206,7 @@ int nilfs_sufile_trim_fs(struct inode *s
 out_sem:
 	up_read(&NILFS_MDT(sufile)->mi_sem);
 
+out:
 	range->len = ndiscarded << nilfs->ns_blocksize_bits;
 	return ret;
 }


