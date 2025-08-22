Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C2212FB624;
	Fri, 22 Aug 2025 12:37:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755866255; cv=none; b=j1OxEPrUriOvDgUDmIclk5AHXVdhrdbp1E5UZtgOhO79z3pzZ1OhP3v6Qd/qAXOv8B3x2ek7wLKLziZIdMMlyG+4xubl7VK2rY4SMExqPX/0Vj48HJn78FOfLeuG7ef5twa0IChZliHtXtwcAUExOm4Xd+yFN7+BoGVY7H7/o5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755866255; c=relaxed/simple;
	bh=3LfyqM3/eKtFcgK2d0osZjxCIlqQZaIk5/T253+1zbc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HscsXj3+aM6bB+ADEfe3N2A9+mGNXfeoS4m6h5PWZey8HrdnKeyQnhplH41IaRLYPXRvgOjAW8j801vHXd/fGBz2QEFCl+Pz9yY46iHrb9iEznvaWxFc4p84YQjVCoFWxgJ9lWivRw2kI1wn+4f4RTOuhHmyM74eerDHwiYcx0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HO8a3Ylz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HO8a3Ylz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BFD2C4CEED;
	Fri, 22 Aug 2025 12:37:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755866254;
	bh=3LfyqM3/eKtFcgK2d0osZjxCIlqQZaIk5/T253+1zbc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HO8a3YlzsDdKSqpRzJAdxsDQqTfqcZKOwy1ckLWJjONaZtJqajK18R8KRkEfEID66
	 SXVHy8hn3vsVxovFaezeKvfLTGPtr+lAvM93b4IRZsXe/LpQBkx4zQsdOBXxu/wDLk
	 kk0sA0mng7G7CLvIBG93yud4AIH5n4EjAlPf3x/o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Yi <yi.zhang@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 6.16 6/9] ext4: enhance tracepoints during the folios writeback
Date: Fri, 22 Aug 2025 14:37:06 +0200
Message-ID: <20250822123517.021539660@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250822123516.780248736@linuxfoundation.org>
References: <20250822123516.780248736@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Yi <yi.zhang@huawei.com>

commit 6b132759b0fe78e518abafb62190c294100db6d6 upstream.

After mpage_map_and_submit_extent() supports restarting handle if
credits are insufficient during allocating blocks, it is more likely to
exit the current mapping iteration and continue to process the current
processing partially mapped folio again. The existing tracepoints are
not sufficient to track this situation, so enhance the tracepoints to
track the writeback position and the return value before and after
submitting the folios.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/20250707140814.542883-7-yi.zhang@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/inode.c             |    5 ++++-
 include/trace/events/ext4.h |   42 +++++++++++++++++++++++++++++++++++++-----
 2 files changed, 41 insertions(+), 6 deletions(-)

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2936,7 +2936,8 @@ retry:
 		}
 		mpd->do_map = 1;
 
-		trace_ext4_da_write_pages(inode, mpd->start_pos, wbc);
+		trace_ext4_da_write_folios_start(inode, mpd->start_pos,
+				mpd->next_pos, wbc);
 		ret = mpage_prepare_extent_to_map(mpd);
 		if (!ret && mpd->map.m_len)
 			ret = mpage_map_and_submit_extent(handle, mpd,
@@ -2974,6 +2975,8 @@ retry:
 		} else
 			ext4_put_io_end(mpd->io_submit.io_end);
 		mpd->io_submit.io_end = NULL;
+		trace_ext4_da_write_folios_end(inode, mpd->start_pos,
+				mpd->next_pos, wbc, ret);
 
 		if (ret == -ENOSPC && sbi->s_journal) {
 			/*
--- a/include/trace/events/ext4.h
+++ b/include/trace/events/ext4.h
@@ -482,16 +482,17 @@ TRACE_EVENT(ext4_writepages,
 		  (unsigned long) __entry->writeback_index)
 );
 
-TRACE_EVENT(ext4_da_write_pages,
-	TP_PROTO(struct inode *inode, loff_t start_pos,
+TRACE_EVENT(ext4_da_write_folios_start,
+	TP_PROTO(struct inode *inode, loff_t start_pos, loff_t next_pos,
 		 struct writeback_control *wbc),
 
-	TP_ARGS(inode, start_pos, wbc),
+	TP_ARGS(inode, start_pos, next_pos, wbc),
 
 	TP_STRUCT__entry(
 		__field(	dev_t,	dev			)
 		__field(	ino_t,	ino			)
 		__field(       loff_t,	start_pos		)
+		__field(       loff_t,	next_pos		)
 		__field(	 long,	nr_to_write		)
 		__field(	  int,	sync_mode		)
 	),
@@ -500,16 +501,47 @@ TRACE_EVENT(ext4_da_write_pages,
 		__entry->dev		= inode->i_sb->s_dev;
 		__entry->ino		= inode->i_ino;
 		__entry->start_pos	= start_pos;
+		__entry->next_pos	= next_pos;
 		__entry->nr_to_write	= wbc->nr_to_write;
 		__entry->sync_mode	= wbc->sync_mode;
 	),
 
-	TP_printk("dev %d,%d ino %lu start_pos 0x%llx nr_to_write %ld sync_mode %d",
+	TP_printk("dev %d,%d ino %lu start_pos 0x%llx next_pos 0x%llx nr_to_write %ld sync_mode %d",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
-		  (unsigned long) __entry->ino, __entry->start_pos,
+		  (unsigned long) __entry->ino, __entry->start_pos, __entry->next_pos,
 		  __entry->nr_to_write, __entry->sync_mode)
 );
 
+TRACE_EVENT(ext4_da_write_folios_end,
+	TP_PROTO(struct inode *inode, loff_t start_pos, loff_t next_pos,
+		 struct writeback_control *wbc, int ret),
+
+	TP_ARGS(inode, start_pos, next_pos, wbc, ret),
+
+	TP_STRUCT__entry(
+		__field(	dev_t,	dev			)
+		__field(	ino_t,	ino			)
+		__field(       loff_t,	start_pos		)
+		__field(       loff_t,	next_pos		)
+		__field(	 long,	nr_to_write		)
+		__field(	  int,	ret			)
+	),
+
+	TP_fast_assign(
+		__entry->dev		= inode->i_sb->s_dev;
+		__entry->ino		= inode->i_ino;
+		__entry->start_pos	= start_pos;
+		__entry->next_pos	= next_pos;
+		__entry->nr_to_write	= wbc->nr_to_write;
+		__entry->ret		= ret;
+	),
+
+	TP_printk("dev %d,%d ino %lu start_pos 0x%llx next_pos 0x%llx nr_to_write %ld ret %d",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  (unsigned long) __entry->ino, __entry->start_pos, __entry->next_pos,
+		  __entry->nr_to_write, __entry->ret)
+);
+
 TRACE_EVENT(ext4_da_write_pages_extent,
 	TP_PROTO(struct inode *inode, struct ext4_map_blocks *map),
 


