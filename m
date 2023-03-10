Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4549847F
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 13:56:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CD0FC433EF;
	Fri, 10 Mar 2023 13:56:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678456561;
	bh=zFpMjgN9/rxReBjHoThTpqpBbPpHJaVOsFGnKepwRhw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=10PNb95pfvmL1CS4CF0PLrCCBEyp4TMs6F1U3Hs6vH/w4TrySQS3EYi3CSNRoTF1X
	 DBbhvEyEfj0ho8DcInocuvUgqgLa5OYw6z4MqWB7N/9wxi60JRRgfM/7srcJ4hy1VQ
	 IJ2gIKN2ZKM+un0k8T5CZYssm4wZzLOHemsIVswQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 015/211] f2fs: introduce trace_f2fs_replace_atomic_write_block
Date: Fri, 10 Mar 2023 14:36:35 +0100
Message-Id: <20230310133719.198136719@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.689332661@linuxfoundation.org>
References: <20230310133718.689332661@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Chao Yu <chao@kernel.org>

[ Upstream commit 2f3a9ae990a7881c9a57a073bb52ebe34fdc3160 ]

Commit 3db1de0e582c ("f2fs: change the current atomic write way")
removed old tracepoints, but it missed to add new one, this patch
fixes to introduce trace_f2fs_replace_atomic_write_block to trace
atomic_write commit flow.

Fixes: 3db1de0e582c ("f2fs: change the current atomic write way")
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/segment.c           |  3 +++
 include/trace/events/f2fs.h | 37 +++++++++++++++++++++++++++++++++++++
 2 files changed, 40 insertions(+)

diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index b019f63fd5403..af3059236f542 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -255,6 +255,9 @@ static int __replace_atomic_write_block(struct inode *inode, pgoff_t index,
 	}
 
 	f2fs_put_dnode(&dn);
+
+	trace_f2fs_replace_atomic_write_block(inode, F2FS_I(inode)->cow_inode,
+					index, *old_addr, new_addr, recover);
 	return 0;
 }
 
diff --git a/include/trace/events/f2fs.h b/include/trace/events/f2fs.h
index 31d994e6b4ca9..35ecb3118c7d5 100644
--- a/include/trace/events/f2fs.h
+++ b/include/trace/events/f2fs.h
@@ -1293,6 +1293,43 @@ DEFINE_EVENT(f2fs__page, f2fs_vm_page_mkwrite,
 	TP_ARGS(page, type)
 );
 
+TRACE_EVENT(f2fs_replace_atomic_write_block,
+
+	TP_PROTO(struct inode *inode, struct inode *cow_inode, pgoff_t index,
+			block_t old_addr, block_t new_addr, bool recovery),
+
+	TP_ARGS(inode, cow_inode, index, old_addr, new_addr, recovery),
+
+	TP_STRUCT__entry(
+		__field(dev_t,	dev)
+		__field(ino_t,	ino)
+		__field(ino_t,	cow_ino)
+		__field(pgoff_t, index)
+		__field(block_t, old_addr)
+		__field(block_t, new_addr)
+		__field(bool, recovery)
+	),
+
+	TP_fast_assign(
+		__entry->dev		= inode->i_sb->s_dev;
+		__entry->ino		= inode->i_ino;
+		__entry->cow_ino	= cow_inode->i_ino;
+		__entry->index		= index;
+		__entry->old_addr	= old_addr;
+		__entry->new_addr	= new_addr;
+		__entry->recovery	= recovery;
+	),
+
+	TP_printk("dev = (%d,%d), ino = %lu, cow_ino = %lu, index = %lu, "
+			"old_addr = 0x%llx, new_addr = 0x%llx, recovery = %d",
+		show_dev_ino(__entry),
+		__entry->cow_ino,
+		(unsigned long)__entry->index,
+		(unsigned long long)__entry->old_addr,
+		(unsigned long long)__entry->new_addr,
+		__entry->recovery)
+);
+
 TRACE_EVENT(f2fs_filemap_fault,
 
 	TP_PROTO(struct inode *inode, pgoff_t index, unsigned long ret),
-- 
2.39.2



