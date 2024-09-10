Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E38818C324;
	Tue, 10 Sep 2024 10:41:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964913; cv=none; b=SPK6pFFSR7zmvbiln6a+tZg1PywpijNbV0ydyGpStKqfGMN9e8Pwb7EDd2rvdvoD3mPdOHZ4Ihz/Yg43ql14aqqoTNFLIylLf+LLqL9wO+V1b8O6AjB29kfANA3ANJqMdwgxOQu3oiWujxCm3TrLGu8j3rFsJjJvalfVh5wQKEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964913; c=relaxed/simple;
	bh=tG0XoHJXqjNpFQuXbSbRda+xqaNe9sgboEwaeIXmX+0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TMD7H71bn+56X6fl1IXsU/PTj/YKaAuY22Bz3JFcyIIH8mKRLP4lNRO1oN7U93rKlQCST5Fv4KM3SrSrwK7XqjT7w8CLqSS+ocK16DuxWWkvPgE/JYmnhBgBofXNNgp3tSfiKqFGN/9vF3GLvz1PYWu0RQfdbD5BvZ/iO6oshSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Heywf/l6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Heywf/l6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3B45C4CEC3;
	Tue, 10 Sep 2024 10:41:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964913;
	bh=tG0XoHJXqjNpFQuXbSbRda+xqaNe9sgboEwaeIXmX+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Heywf/l65dU9Hd/QGwoYc8FP/wJaeHQl2E8/PVlrh5b8aQOP81XEnhvdRU7Qes3uL
	 uPAS+uAxLjjQnWOUYZcyBBg8DJFXX/d2VlTfQkkMXelveQlC1AF4EKKuj6pljzIChU
	 iQJvNoA5cFyNGuUdjZZMQbG5KSelfS7CdNfCP/Wc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.10 074/186] nilfs2: fix state management in error path of log writing function
Date: Tue, 10 Sep 2024 11:32:49 +0200
Message-ID: <20240910092557.574073600@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092554.645718780@linuxfoundation.org>
References: <20240910092554.645718780@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ryusuke Konishi <konishi.ryusuke@gmail.com>

commit 6576dd6695f2afca3f4954029ac4a64f82ba60ab upstream.

After commit a694291a6211 ("nilfs2: separate wait function from
nilfs_segctor_write") was applied, the log writing function
nilfs_segctor_do_construct() was able to issue I/O requests continuously
even if user data blocks were split into multiple logs across segments,
but two potential flaws were introduced in its error handling.

First, if nilfs_segctor_begin_construction() fails while creating the
second or subsequent logs, the log writing function returns without
calling nilfs_segctor_abort_construction(), so the writeback flag set on
pages/folios will remain uncleared.  This causes page cache operations to
hang waiting for the writeback flag.  For example,
truncate_inode_pages_final(), which is called via nilfs_evict_inode() when
an inode is evicted from memory, will hang.

Second, the NILFS_I_COLLECTED flag set on normal inodes remain uncleared.
As a result, if the next log write involves checkpoint creation, that's
fine, but if a partial log write is performed that does not, inodes with
NILFS_I_COLLECTED set are erroneously removed from the "sc_dirty_files"
list, and their data and b-tree blocks may not be written to the device,
corrupting the block mapping.

Fix these issues by uniformly calling nilfs_segctor_abort_construction()
on failure of each step in the loop in nilfs_segctor_do_construct(),
having it clean up logs and segment usages according to progress, and
correcting the conditions for calling nilfs_redirty_inodes() to ensure
that the NILFS_I_COLLECTED flag is cleared.

Link: https://lkml.kernel.org/r/20240814101119.4070-1-konishi.ryusuke@gmail.com
Fixes: a694291a6211 ("nilfs2: separate wait function from nilfs_segctor_write")
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Tested-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nilfs2/segment.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -1833,6 +1833,9 @@ static void nilfs_segctor_abort_construc
 	nilfs_abort_logs(&logs, ret ? : err);
 
 	list_splice_tail_init(&sci->sc_segbufs, &logs);
+	if (list_empty(&logs))
+		return; /* if the first segment buffer preparation failed */
+
 	nilfs_cancel_segusage(&logs, nilfs->ns_sufile);
 	nilfs_free_incomplete_logs(&logs, nilfs);
 
@@ -2077,7 +2080,7 @@ static int nilfs_segctor_do_construct(st
 
 		err = nilfs_segctor_begin_construction(sci, nilfs);
 		if (unlikely(err))
-			goto out;
+			goto failed;
 
 		/* Update time stamp */
 		sci->sc_seg_ctime = ktime_get_real_seconds();
@@ -2140,10 +2143,9 @@ static int nilfs_segctor_do_construct(st
 	return err;
 
  failed_to_write:
-	if (sci->sc_stage.flags & NILFS_CF_IFILE_STARTED)
-		nilfs_redirty_inodes(&sci->sc_dirty_files);
-
  failed:
+	if (mode == SC_LSEG_SR && nilfs_sc_cstage_get(sci) >= NILFS_ST_IFILE)
+		nilfs_redirty_inodes(&sci->sc_dirty_files);
 	if (nilfs_doing_gc())
 		nilfs_redirty_inodes(&sci->sc_gc_inodes);
 	nilfs_segctor_abort_construction(sci, nilfs, err);


