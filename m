Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA50F3C3C;
	Fri, 27 Sep 2024 12:32:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727440336; cv=none; b=fshujdxrmsGGu8pynUys3khLXpFuRuHn6xje5Bbzxpzlo8Rq2+ckOJthYOoeq+uqb5a/AeNjYLvi2gX8AlCHVqwbTdNhgvvjviH02mwi6yQEQXgPo3w8bmqFAbEjF0CwTHIBny3KVMhLLglDa4ej/r5hLIFYWCrEZU+FTeVk/pE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727440336; c=relaxed/simple;
	bh=R180KTU1Ja9qVTw9Q4FYxQSeTdRO1rVAOsZbj2Wurwc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jmXsV2T/NeKEqOywWC7G74+E2Yq4dHnwH8VBvxKuj3gegvjbijwcAsnj3ArcbgxpbSfi7WCKvUTZE79IXFYms4DJFsRqUpzsqh6qsvUvpfhiSpsXJ9nU3z8Mzj/7bITwYYlaFJSBbfsxcvGlYWZIv1oyzLG2tpJsF5iyiaQmILs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BbWnwZTp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BbWnwZTp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 652B1C4CEC4;
	Fri, 27 Sep 2024 12:32:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727440336;
	bh=R180KTU1Ja9qVTw9Q4FYxQSeTdRO1rVAOsZbj2Wurwc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BbWnwZTpnYWi6MI4MOTv2bVgyTVn8jCn7hMC8J/g9sEI/1r+jdb/2aCm7ukP9R+dU
	 C2s/9nChmWK8gb9dQaJiSjfMHQSEpiGBgW9fBZZaQ29oAhcslFk365+bcf14eWZE7N
	 5uWj1tnZWmbziiYhjRmMzObKuxxhmFrFXuL7abFg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Long Li <leo.lilong@huawei.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Leah Rumancik <leah.rumancik@gmail.com>,
	Chandan Babu R <chandanbabu@kernel.org>
Subject: [PATCH 6.1 46/73] xfs: fix ag count overflow during growfs
Date: Fri, 27 Sep 2024 14:23:57 +0200
Message-ID: <20240927121721.786303025@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20240927121719.897851549@linuxfoundation.org>
References: <20240927121719.897851549@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Long Li <leo.lilong@huaweicloud.com>

[ Upstream commit c3b880acadc95d6e019eae5d669e072afda24f1b ]

I found a corruption during growfs:

 XFS (loop0): Internal error agbno >= mp->m_sb.sb_agblocks at line 3661 of
   file fs/xfs/libxfs/xfs_alloc.c.  Caller __xfs_free_extent+0x28e/0x3c0
 CPU: 0 PID: 573 Comm: xfs_growfs Not tainted 6.3.0-rc7-next-20230420-00001-gda8c95746257
 Call Trace:
  <TASK>
  dump_stack_lvl+0x50/0x70
  xfs_corruption_error+0x134/0x150
  __xfs_free_extent+0x2c1/0x3c0
  xfs_ag_extend_space+0x291/0x3e0
  xfs_growfs_data+0xd72/0xe90
  xfs_file_ioctl+0x5f9/0x14a0
  __x64_sys_ioctl+0x13e/0x1c0
  do_syscall_64+0x39/0x80
  entry_SYSCALL_64_after_hwframe+0x63/0xcd
 XFS (loop0): Corruption detected. Unmount and run xfs_repair
 XFS (loop0): Internal error xfs_trans_cancel at line 1097 of file
   fs/xfs/xfs_trans.c.  Caller xfs_growfs_data+0x691/0xe90
 CPU: 0 PID: 573 Comm: xfs_growfs Not tainted 6.3.0-rc7-next-20230420-00001-gda8c95746257
 Call Trace:
  <TASK>
  dump_stack_lvl+0x50/0x70
  xfs_error_report+0x93/0xc0
  xfs_trans_cancel+0x2c0/0x350
  xfs_growfs_data+0x691/0xe90
  xfs_file_ioctl+0x5f9/0x14a0
  __x64_sys_ioctl+0x13e/0x1c0
  do_syscall_64+0x39/0x80
  entry_SYSCALL_64_after_hwframe+0x63/0xcd
 RIP: 0033:0x7f2d86706577

The bug can be reproduced with the following sequence:

 # truncate -s  1073741824 xfs_test.img
 # mkfs.xfs -f -b size=1024 -d agcount=4 xfs_test.img
 # truncate -s 2305843009213693952  xfs_test.img
 # mount -o loop xfs_test.img /mnt/test
 # xfs_growfs -D  1125899907891200  /mnt/test

The root cause is that during growfs, user space passed in a large value
of newblcoks to xfs_growfs_data_private(), due to current sb_agblocks is
too small, new AG count will exceed UINT_MAX. Because of AG number type
is unsigned int and it would overflow, that caused nagcount much smaller
than the actual value. During AG extent space, delta blocks in
xfs_resizefs_init_new_ags() will much larger than the actual value due to
incorrect nagcount, even exceed UINT_MAX. This will cause corruption and
be detected in __xfs_free_extent. Fix it by growing the filesystem to up
to the maximally allowed AGs and not return EINVAL when new AG count
overflow.

Signed-off-by: Long Li <leo.lilong@huawei.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_fs.h |    2 ++
 fs/xfs/xfs_fsops.c     |   13 +++++++++----
 2 files changed, 11 insertions(+), 4 deletions(-)

--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -257,6 +257,8 @@ typedef struct xfs_fsop_resblks {
 #define XFS_MAX_AG_BLOCKS	(XFS_MAX_AG_BYTES / XFS_MIN_BLOCKSIZE)
 #define XFS_MAX_CRC_AG_BLOCKS	(XFS_MAX_AG_BYTES / XFS_MIN_CRC_BLOCKSIZE)
 
+#define XFS_MAX_AGNUMBER	((xfs_agnumber_t)(NULLAGNUMBER - 1))
+
 /* keep the maximum size under 2^31 by a small amount */
 #define XFS_MAX_LOG_BYTES \
 	((2 * 1024 * 1024 * 1024ULL) - XFS_MIN_LOG_BYTES)
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -115,11 +115,16 @@ xfs_growfs_data_private(
 
 	nb_div = nb;
 	nb_mod = do_div(nb_div, mp->m_sb.sb_agblocks);
-	nagcount = nb_div + (nb_mod != 0);
-	if (nb_mod && nb_mod < XFS_MIN_AG_BLOCKS) {
-		nagcount--;
-		nb = (xfs_rfsblock_t)nagcount * mp->m_sb.sb_agblocks;
+	if (nb_mod && nb_mod >= XFS_MIN_AG_BLOCKS)
+		nb_div++;
+	else if (nb_mod)
+		nb = nb_div * mp->m_sb.sb_agblocks;
+
+	if (nb_div > XFS_MAX_AGNUMBER + 1) {
+		nb_div = XFS_MAX_AGNUMBER + 1;
+		nb = nb_div * mp->m_sb.sb_agblocks;
 	}
+	nagcount = nb_div;
 	delta = nb - mp->m_sb.sb_dblocks;
 	/*
 	 * Reject filesystems with a single AG because they are not


