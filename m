Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 031482511F;
	Fri, 24 Nov 2023 19:15:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O+GEs4Wn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C673C433C7;
	Fri, 24 Nov 2023 19:15:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700853315;
	bh=ZwJPcb3fUKD5XhalPjET9FYBvQBJC5WV3S/RHStm514=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O+GEs4Wn7MS5Bzh141TQwIBpMWFaUmtK/EpMVSPL1CIRmakRR2G729PUIgSUl0qhL
	 MhgnDKsMhOKUmMhE2l0Bz9LMFWVOHvCMK+cv0/Gtw7/9stHyqaYlC7C2w9Hkn50xXR
	 NnwRjg8gIZpHSgjBCAmcJ/Pkr1JacEJqP9toR1Go=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Dave Chinner <dchinner@redhat.com>,
	Dave Chinner <david@fromorbit.com>,
	Leah Rumancik <leah.rumancik@gmail.com>,
	Chandan Babu R <chandanbabu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 140/297] xfs: dont leak xfs_buf_cancel structures when recovery fails
Date: Fri, 24 Nov 2023 17:53:02 +0000
Message-ID: <20231124172005.158958560@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172000.087816911@linuxfoundation.org>
References: <20231124172000.087816911@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

[ Upstream commit 8db074bd84df5ccc88bff3f8f900f66f4b8349fa ]

If log recovery fails, we free the memory used by the buffer
cancellation buckets, but we don't actually traverse each bucket list to
free the individual xfs_buf_cancel objects.  This leads to a memory
leak, as reported by kmemleak in xfs/051:

unreferenced object 0xffff888103629560 (size 32):
  comm "mount", pid 687045, jiffies 4296935916 (age 10.752s)
  hex dump (first 32 bytes):
    08 d3 0a 01 00 00 00 00 08 00 00 00 01 00 00 00  ................
    d0 f5 0b 92 81 88 ff ff 80 64 64 25 81 88 ff ff  .........dd%....
  backtrace:
    [<ffffffffa0317c83>] kmem_alloc+0x73/0x140 [xfs]
    [<ffffffffa03234a9>] xlog_recover_buf_commit_pass1+0x139/0x200 [xfs]
    [<ffffffffa032dc27>] xlog_recover_commit_trans+0x307/0x350 [xfs]
    [<ffffffffa032df15>] xlog_recovery_process_trans+0xa5/0xe0 [xfs]
    [<ffffffffa032e12d>] xlog_recover_process_data+0x8d/0x140 [xfs]
    [<ffffffffa032e49d>] xlog_do_recovery_pass+0x19d/0x740 [xfs]
    [<ffffffffa032f22d>] xlog_do_log_recovery+0x6d/0x150 [xfs]
    [<ffffffffa032f343>] xlog_do_recover+0x33/0x1d0 [xfs]
    [<ffffffffa032faba>] xlog_recover+0xda/0x190 [xfs]
    [<ffffffffa03194bc>] xfs_log_mount+0x14c/0x360 [xfs]
    [<ffffffffa030bfed>] xfs_mountfs+0x50d/0xa60 [xfs]
    [<ffffffffa03124b5>] xfs_fs_fill_super+0x6a5/0x950 [xfs]
    [<ffffffff812b92a5>] get_tree_bdev+0x175/0x280
    [<ffffffff812b7c3a>] vfs_get_tree+0x1a/0x80
    [<ffffffff812e366f>] path_mount+0x6ff/0xaa0
    [<ffffffff812e3b13>] __x64_sys_mount+0x103/0x140

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_buf_item_recover.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
index dc099b2f4984c..635f7f8ed9c2d 100644
--- a/fs/xfs/xfs_buf_item_recover.c
+++ b/fs/xfs/xfs_buf_item_recover.c
@@ -1044,9 +1044,22 @@ void
 xlog_free_buf_cancel_table(
 	struct xlog	*log)
 {
+	int		i;
+
 	if (!log->l_buf_cancel_table)
 		return;
 
+	for (i = 0; i < XLOG_BC_TABLE_SIZE; i++) {
+		struct xfs_buf_cancel	*bc;
+
+		while ((bc = list_first_entry_or_null(
+				&log->l_buf_cancel_table[i],
+				struct xfs_buf_cancel, bc_list))) {
+			list_del(&bc->bc_list);
+			kmem_free(bc);
+		}
+	}
+
 	kmem_free(log->l_buf_cancel_table);
 	log->l_buf_cancel_table = NULL;
 }
-- 
2.42.0



