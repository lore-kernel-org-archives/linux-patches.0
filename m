Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63EBF5381
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 10:44:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1505C433C8;
	Mon, 19 Jun 2023 10:44:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687171495;
	bh=yYRZOfSY4K/fBcSUl6kbFY/O8J+kUVfRISDeqiFaAuM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vXtGepxnA9wkikhKOuCoNk11YaSagfHjc+vfzAwO3TFosV4/+WmWFdLLrCU4iXSGf
	 nzr6zi7gPS7beZBN43QRuxFII92OmJTH3hTDoxiLs5TfFtdmrCk8mnbAk7EDujCT9u
	 8jNd5mz0eBriNUChkoSokKT7oZR6ZeVVwNuJmU2I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	syzbot+33494cd0df2ec2931851@syzkaller.appspotmail.com,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 051/166] nilfs2: fix possible out-of-bounds segment allocation in resize ioctl
Date: Mon, 19 Jun 2023 12:28:48 +0200
Message-ID: <20230619102157.246837230@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102154.568541872@linuxfoundation.org>
References: <20230619102154.568541872@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ryusuke Konishi <konishi.ryusuke@gmail.com>

commit fee5eaecca86afa544355569b831c1f90f334b85 upstream.

Syzbot reports that in its stress test for resize ioctl, the log writing
function nilfs_segctor_do_construct hits a WARN_ON in
nilfs_segctor_truncate_segments().

It turned out that there is a problem with the current implementation of
the resize ioctl, which changes the writable range on the device (the
range of allocatable segments) at the end of the resize process.

This order is necessary for file system expansion to avoid corrupting the
superblock at trailing edge.  However, in the case of a file system
shrink, if log writes occur after truncating out-of-bounds trailing
segments and before the resize is complete, segments may be allocated from
the truncated space.

The userspace resize tool was fine as it limits the range of allocatable
segments before performing the resize, but it can run into this issue if
the resize ioctl is called alone.

Fix this issue by changing nilfs_sufile_resize() to update the range of
allocatable segments immediately after successful truncation of segment
space in case of file system shrink.

Link: https://lkml.kernel.org/r/20230524094348.3784-1-konishi.ryusuke@gmail.com
Fixes: 4e33f9eab07e ("nilfs2: implement resize ioctl")
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Reported-by: syzbot+33494cd0df2ec2931851@syzkaller.appspotmail.com
Closes: https://lkml.kernel.org/r/0000000000005434c405fbbafdc5@google.com
Tested-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nilfs2/sufile.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/fs/nilfs2/sufile.c
+++ b/fs/nilfs2/sufile.c
@@ -779,6 +779,15 @@ int nilfs_sufile_resize(struct inode *su
 			goto out_header;
 
 		sui->ncleansegs -= nsegs - newnsegs;
+
+		/*
+		 * If the sufile is successfully truncated, immediately adjust
+		 * the segment allocation space while locking the semaphore
+		 * "mi_sem" so that nilfs_sufile_alloc() never allocates
+		 * segments in the truncated space.
+		 */
+		sui->allocmax = newnsegs - 1;
+		sui->allocmin = 0;
 	}
 
 	kaddr = kmap_atomic(header_bh->b_page);


