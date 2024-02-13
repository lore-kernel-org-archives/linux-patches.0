Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 512645FB86;
	Tue, 13 Feb 2024 17:27:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845260; cv=none; b=FlT7a/zI2+4+I280EaGdUcr73bXwEAQqoCvNs4RxTljtfYh4mvrSFqGPnGGZf3CBvUHkaVmFD8WMuslBq94yMZsTnyu8Ad78U4UZ4KOnQN2dUR9nPrntNbk/8hNvecM7RY7wEY33oaYEQ+ceu1CIzlBdWG3aLKQ/UIvIgdSw3rI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845260; c=relaxed/simple;
	bh=6Xyfe9kk9yQMjRKBaboXswzejPHa40Cjpd/VGFvxNq4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fUSEoW73aliQTluu8uTzB00ydOcB/vw7Qs+X7JzsTCqAUzKAmJ9TahXjkc3f0H5dYyWoE2oWKIhkvQWajzL4TVepO12CAAypzQ8I35AqVhe2LmsoAUNQ/MUJrBRMyIaA+nRTrkIvLFYFvTjlcx42tF4myYTZnMvfnSSLC9XHYck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oNVnrFBL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oNVnrFBL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4AA9C433C7;
	Tue, 13 Feb 2024 17:27:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845260;
	bh=6Xyfe9kk9yQMjRKBaboXswzejPHa40Cjpd/VGFvxNq4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oNVnrFBLPUJinLATVeAHjOVkrJ8Q8+362aXel/npBEp5y7WUqvRuvn3BxhpvBWQDA
	 n8fmoHnE/0lwiIIZb3ihRJEWfKVJJtbwKTpoUWoxINeAyXNF188I/LT5IluEtjQ7OI
	 PB54/pi/4hHPKU23hGYANiBgN2yKbSUVw665lT8g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leah Rumancik <leah.rumancik@gmail.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Chandan Babu R <chandanbabu@kernel.org>,
	Catherine Hoang <catherine.hoang@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 030/121] xfs: up(ic_sema) if flushing data device fails
Date: Tue, 13 Feb 2024 18:20:39 +0100
Message-ID: <20240213171853.860615853@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171852.948844634@linuxfoundation.org>
References: <20240213171852.948844634@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leah Rumancik <leah.rumancik@gmail.com>

commit 471de20303dda0b67981e06d59cc6c4a83fd2a3c upstream.

We flush the data device cache before we issue external log IO. If
the flush fails, we shut down the log immediately and return. However,
the iclog->ic_sema is left in a decremented state so let's add an up().
Prior to this patch, xfs/438 would fail consistently when running with
an external log device:

sync
  -> xfs_log_force
  -> xlog_write_iclog
      -> down(&iclog->ic_sema)
      -> blkdev_issue_flush (fail causes us to intiate shutdown)
          -> xlog_force_shutdown
          -> return

unmount
  -> xfs_log_umount
      -> xlog_wait_iclog_completion
          -> down(&iclog->ic_sema) --------> HANG

There is a second early return / shutdown. Make sure the up() happens
for it as well. Also make sure we cleanup the iclog state,
xlog_state_done_syncing, before dropping the iclog lock.

Fixes: b5d721eaae47 ("xfs: external logs need to flush data device")
Fixes: 842a42d126b4 ("xfs: shutdown on failure to add page to log bio")
Fixes: 7d839e325af2 ("xfs: check return codes when flushing block devices")
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_log.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 51c100c86177..ee206facf0dc 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1893,9 +1893,7 @@ xlog_write_iclog(
 		 * the buffer manually, the code needs to be kept in sync
 		 * with the I/O completion path.
 		 */
-		xlog_state_done_syncing(iclog);
-		up(&iclog->ic_sema);
-		return;
+		goto sync;
 	}
 
 	/*
@@ -1925,20 +1923,17 @@ xlog_write_iclog(
 		 * avoid shutdown re-entering this path and erroring out again.
 		 */
 		if (log->l_targ != log->l_mp->m_ddev_targp &&
-		    blkdev_issue_flush(log->l_mp->m_ddev_targp->bt_bdev)) {
-			xlog_force_shutdown(log, SHUTDOWN_LOG_IO_ERROR);
-			return;
-		}
+		    blkdev_issue_flush(log->l_mp->m_ddev_targp->bt_bdev))
+			goto shutdown;
 	}
 	if (iclog->ic_flags & XLOG_ICL_NEED_FUA)
 		iclog->ic_bio.bi_opf |= REQ_FUA;
 
 	iclog->ic_flags &= ~(XLOG_ICL_NEED_FLUSH | XLOG_ICL_NEED_FUA);
 
-	if (xlog_map_iclog_data(&iclog->ic_bio, iclog->ic_data, count)) {
-		xlog_force_shutdown(log, SHUTDOWN_LOG_IO_ERROR);
-		return;
-	}
+	if (xlog_map_iclog_data(&iclog->ic_bio, iclog->ic_data, count))
+		goto shutdown;
+
 	if (is_vmalloc_addr(iclog->ic_data))
 		flush_kernel_vmap_range(iclog->ic_data, count);
 
@@ -1959,6 +1954,12 @@ xlog_write_iclog(
 	}
 
 	submit_bio(&iclog->ic_bio);
+	return;
+shutdown:
+	xlog_force_shutdown(log, SHUTDOWN_LOG_IO_ERROR);
+sync:
+	xlog_state_done_syncing(iclog);
+	up(&iclog->ic_sema);
 }
 
 /*
-- 
2.43.0



