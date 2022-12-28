Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B42981C07
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:13:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BF78C433EF;
	Wed, 28 Dec 2022 16:13:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672244037;
	bh=yWgWVInGX15cBm14H/GZkLbe2Rka6W6tksxROauDpu8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ef6atoKoE7XFg/PJzwyjwTrv7so+QIO/mj9KWn4B0wsGxnHrWr8XdJ6vyozV1m/u1
	 6zsIePjou81GiFm8iZna89i+QGwVJ0n7DFkZKcPupGMdBwWYr0GD7gyk12lNLT5vbp
	 m08TcMv6MFSPdTPHY25GH5uHNEd019t8GKWsIOLo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mukesh Ojha <quic_mojha@quicinc.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0599/1146] f2fs: fix the assign logic of iocb
Date: Wed, 28 Dec 2022 15:35:38 +0100
Message-Id: <20221228144346.442528364@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mukesh Ojha <quic_mojha@quicinc.com>

[ Upstream commit 0db18eec0d9a7ee525209e31e3ac2f673545b12f ]

commit 18ae8d12991b ("f2fs: show more DIO information in tracepoint")
introduces iocb field in 'f2fs_direct_IO_enter' trace event
And it only assigns the pointer and later it accesses its field
in trace print log.

Unable to handle kernel paging request at virtual address ffffffc04cef3d30
Mem abort info:
ESR = 0x96000007
EC = 0x25: DABT (current EL), IL = 32 bits

 pc : trace_raw_output_f2fs_direct_IO_enter+0x54/0xa4
 lr : trace_raw_output_f2fs_direct_IO_enter+0x2c/0xa4
 sp : ffffffc0443cbbd0
 x29: ffffffc0443cbbf0 x28: ffffff8935b120d0 x27: ffffff8935b12108
 x26: ffffff8935b120f0 x25: ffffff8935b12100 x24: ffffff8935b110c0
 x23: ffffff8935b10000 x22: ffffff88859a936c x21: ffffff88859a936c
 x20: ffffff8935b110c0 x19: ffffff8935b10000 x18: ffffffc03b195060
 x17: ffffff8935b11e76 x16: 00000000000000cc x15: ffffffef855c4f2c
 x14: 0000000000000001 x13: 000000000000004e x12: ffff0000ffffff00
 x11: ffffffef86c350d0 x10: 00000000000010c0 x9 : 000000000fe0002c
 x8 : ffffffc04cef3d28 x7 : 7f7f7f7f7f7f7f7f x6 : 0000000002000000
 x5 : ffffff8935b11e9a x4 : 0000000000006250 x3 : ffff0a00ffffff04
 x2 : 0000000000000002 x1 : ffffffef86a0a31f x0 : ffffff8935b10000
 Call trace:
  trace_raw_output_f2fs_direct_IO_enter+0x54/0xa4
  print_trace_fmt+0x9c/0x138
  print_trace_line+0x154/0x254
  tracing_read_pipe+0x21c/0x380
  vfs_read+0x108/0x3ac
  ksys_read+0x7c/0xec
  __arm64_sys_read+0x20/0x30
  invoke_syscall+0x60/0x150
  el0_svc_common.llvm.1237943816091755067+0xb8/0xf8
  do_el0_svc+0x28/0xa0

Fix it by copying the required variables for printing and while at
it fix the similar issue at some other places in the same file.

Fixes: bd984c03097b ("f2fs: show more DIO information in tracepoint")
Signed-off-by: Mukesh Ojha <quic_mojha@quicinc.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/trace/events/f2fs.h | 34 +++++++++++++++++++---------------
 1 file changed, 19 insertions(+), 15 deletions(-)

diff --git a/include/trace/events/f2fs.h b/include/trace/events/f2fs.h
index c6b372401c27..ff57e7f9914c 100644
--- a/include/trace/events/f2fs.h
+++ b/include/trace/events/f2fs.h
@@ -322,7 +322,7 @@ TRACE_EVENT(f2fs_unlink_enter,
 		__field(ino_t,	ino)
 		__field(loff_t,	size)
 		__field(blkcnt_t, blocks)
-		__field(const char *,	name)
+		__string(name,  dentry->d_name.name)
 	),
 
 	TP_fast_assign(
@@ -330,7 +330,7 @@ TRACE_EVENT(f2fs_unlink_enter,
 		__entry->ino	= dir->i_ino;
 		__entry->size	= dir->i_size;
 		__entry->blocks	= dir->i_blocks;
-		__entry->name	= dentry->d_name.name;
+		__assign_str(name, dentry->d_name.name);
 	),
 
 	TP_printk("dev = (%d,%d), dir ino = %lu, i_size = %lld, "
@@ -338,7 +338,7 @@ TRACE_EVENT(f2fs_unlink_enter,
 		show_dev_ino(__entry),
 		__entry->size,
 		(unsigned long long)__entry->blocks,
-		__entry->name)
+		__get_str(name))
 );
 
 DEFINE_EVENT(f2fs__inode_exit, f2fs_unlink_exit,
@@ -940,25 +940,29 @@ TRACE_EVENT(f2fs_direct_IO_enter,
 	TP_STRUCT__entry(
 		__field(dev_t,	dev)
 		__field(ino_t,	ino)
-		__field(struct kiocb *,	iocb)
+		__field(loff_t,	ki_pos)
+		__field(int,	ki_flags)
+		__field(u16,	ki_ioprio)
 		__field(unsigned long,	len)
 		__field(int,	rw)
 	),
 
 	TP_fast_assign(
-		__entry->dev	= inode->i_sb->s_dev;
-		__entry->ino	= inode->i_ino;
-		__entry->iocb	= iocb;
-		__entry->len	= len;
-		__entry->rw	= rw;
+		__entry->dev		= inode->i_sb->s_dev;
+		__entry->ino		= inode->i_ino;
+		__entry->ki_pos		= iocb->ki_pos;
+		__entry->ki_flags	= iocb->ki_flags;
+		__entry->ki_ioprio	= iocb->ki_ioprio;
+		__entry->len		= len;
+		__entry->rw		= rw;
 	),
 
 	TP_printk("dev = (%d,%d), ino = %lu pos = %lld len = %lu ki_flags = %x ki_ioprio = %x rw = %d",
 		show_dev_ino(__entry),
-		__entry->iocb->ki_pos,
+		__entry->ki_pos,
 		__entry->len,
-		__entry->iocb->ki_flags,
-		__entry->iocb->ki_ioprio,
+		__entry->ki_flags,
+		__entry->ki_ioprio,
 		__entry->rw)
 );
 
@@ -1407,19 +1411,19 @@ TRACE_EVENT(f2fs_write_checkpoint,
 	TP_STRUCT__entry(
 		__field(dev_t,	dev)
 		__field(int,	reason)
-		__field(char *,	msg)
+		__string(dest_msg, msg)
 	),
 
 	TP_fast_assign(
 		__entry->dev		= sb->s_dev;
 		__entry->reason		= reason;
-		__entry->msg		= msg;
+		__assign_str(dest_msg, msg);
 	),
 
 	TP_printk("dev = (%d,%d), checkpoint for %s, state = %s",
 		show_dev(__entry->dev),
 		show_cpreason(__entry->reason),
-		__entry->msg)
+		__get_str(dest_msg))
 );
 
 DECLARE_EVENT_CLASS(f2fs_discard,
-- 
2.35.1



