Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EA7C1FFC4A;
	Thu, 13 Feb 2025 14:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458526; cv=none; b=qvKOREWKocReogUzKXgothI2Jf1qX+39tv/Z67MZa29/OP2KW7bmnZ9vN1UJGy2y1OqTFRANsat+1hM5X2pI3Rst43NiI8MtvdWO9CnZM0k2FYcg/JJM+qlppCjJPYwAc8wmocscoE1e2egJ8pyvmVUURwysGzSMFdgeKy8Pft8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458526; c=relaxed/simple;
	bh=RSG2n/CK9b+RbXHHfeKDl9HnZr06nuCy8cPjEekVvic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C3sdPAMAyeogcossGsNYB5TkCTEFNuEXVjkWq5VI0ygtBk1pdIX6lWuaF+h728fvmLKjs5X6H1lGKJrnL3qR1JE8xIEVcWxNoCYWj8fiFiTY+SQ5AkA1tW53b5McSiqvYdPdZd/ADWCZWFVia0nwx9Il613Che83fj7acvgjwdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SEl1MCwg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SEl1MCwg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4F07C4CEE4;
	Thu, 13 Feb 2025 14:55:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458526;
	bh=RSG2n/CK9b+RbXHHfeKDl9HnZr06nuCy8cPjEekVvic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SEl1MCwgI4RQqlMh7rr//ddcgjPxKBDw1H4SFwcmOHnZb0X0VMp8byehTSQTfNhbx
	 lPJd3kAtkTCRc128Y+OJowt9dFffYbr27UDeigw0iqDjALAdGnIhfVOtRIE68YXuo6
	 vOUElkHGzsP9RF15giahZIJj8/p/pez3VdZzJU3w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Long Li <leo.lilong@huawei.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.12 406/422] xfs: fix mount hang during primary superblock recovery failure
Date: Thu, 13 Feb 2025 15:29:15 +0100
Message-ID: <20250213142452.222422525@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Long Li <leo.lilong@huawei.com>

commit efebe42d95fbba91dca6e3e32cb9e0612eb56de5 upstream

When mounting an image containing a log with sb modifications that require
log replay, the mount process hang all the time and stack as follows:

  [root@localhost ~]# cat /proc/557/stack
  [<0>] xfs_buftarg_wait+0x31/0x70
  [<0>] xfs_buftarg_drain+0x54/0x350
  [<0>] xfs_mountfs+0x66e/0xe80
  [<0>] xfs_fs_fill_super+0x7f1/0xec0
  [<0>] get_tree_bdev_flags+0x186/0x280
  [<0>] get_tree_bdev+0x18/0x30
  [<0>] xfs_fs_get_tree+0x1d/0x30
  [<0>] vfs_get_tree+0x2d/0x110
  [<0>] path_mount+0xb59/0xfc0
  [<0>] do_mount+0x92/0xc0
  [<0>] __x64_sys_mount+0xc2/0x160
  [<0>] x64_sys_call+0x2de4/0x45c0
  [<0>] do_syscall_64+0xa7/0x240
  [<0>] entry_SYSCALL_64_after_hwframe+0x76/0x7e

During log recovery, while updating the in-memory superblock from the
primary SB buffer, if an error is encountered, such as superblock
corruption occurs or some other reasons, we will proceed to out_release
and release the xfs_buf. However, this is insufficient because the
xfs_buf's log item has already been initialized and the xfs_buf is held
by the buffer log item as follows, the xfs_buf will not be released,
causing the mount thread to hang.

  xlog_recover_do_primary_sb_buffer
    xlog_recover_do_reg_buffer
      xlog_recover_validate_buf_type
        xfs_buf_item_init(bp, mp)

The solution is straightforward, we simply need to allow it to be
handled by the normal buffer write process. The filesystem will be
shutdown before the submission of buffer_list in xlog_do_recovery_pass(),
ensuring the correct release of the xfs_buf as follows:

  xlog_do_recovery_pass
    error = xlog_recover_process
      xlog_recover_process_data
        xlog_recover_process_ophdr
          xlog_recovery_process_trans
            ...
              xlog_recover_buf_commit_pass2
                error = xlog_recover_do_primary_sb_buffer
                  //Encounter error and return
                if (error)
                  goto out_writebuf
                ...
              out_writebuf:
                xfs_buf_delwri_queue(bp, buffer_list) //add bp to list
                return  error
            ...
    if (!list_empty(&buffer_list))
      if (error)
        xlog_force_shutdown(log, SHUTDOWN_LOG_IO_ERROR); //shutdown first
      xfs_buf_delwri_submit(&buffer_list); //submit buffers in list
        __xfs_buf_submit
          if (bp->b_mount->m_log && xlog_is_shutdown(bp->b_mount->m_log))
            xfs_buf_ioend_fail(bp)  //release bp correctly

Fixes: 6a18765b54e2 ("xfs: update the file system geometry after recoverying superblock buffers")
Cc: stable@vger.kernel.org # v6.12
Signed-off-by: Long Li <leo.lilong@huawei.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_buf_item_recover.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)


--- a/fs/xfs/xfs_buf_item_recover.c
+++ b/fs/xfs/xfs_buf_item_recover.c
@@ -1036,12 +1036,21 @@ xlog_recover_buf_commit_pass2(
 		error = xlog_recover_do_primary_sb_buffer(mp, item, bp, buf_f,
 				current_lsn);
 		if (error)
-			goto out_release;
+			goto out_writebuf;
 	} else {
 		xlog_recover_do_reg_buffer(mp, item, bp, buf_f, current_lsn);
 	}
 
 	/*
+	 * Buffer held by buf log item during 'normal' buffer recovery must
+	 * be committed through buffer I/O submission path to ensure proper
+	 * release. When error occurs during sb buffer recovery, log shutdown
+	 * will be done before submitting buffer list so that buffers can be
+	 * released correctly through ioend failure path.
+	 */
+out_writebuf:
+
+	/*
 	 * Perform delayed write on the buffer.  Asynchronous writes will be
 	 * slower when taking into account all the buffers to be flushed.
 	 *


