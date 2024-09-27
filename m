Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2348F18BC32;
	Fri, 27 Sep 2024 12:33:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727440392; cv=none; b=DZ6lMbj9PxGx820DoZ6HsZpJTX6IvQSpKduh13E3lqYtplnTLC0cYb8SAT6aUvx1OfvtI0DqAvnyzRyDxxBpkJVFlQqXWmWCYHzMKkBR9bMuVNc9bibalzAcMPzx1IwwzoothQGDLr29mQzJFXUNozu4glmjEkOasReDzNoLAX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727440392; c=relaxed/simple;
	bh=+pzprjT2D6MPh07arqF76vFH0AAnlEPnUxD5AJ+vIco=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eCcpENTxVf4ty/VqtQq8Szn6H95HSIGpPm7rVt14fkfgh2RnmIPrwHYLsLhBY5nZiWievJmwKFzbxQg7eGG6ZkmetA/NrxVPVgtJgSrt6CpgN8RN5m0WthvRYHbpHT4PcIYk6JrlxjxF/m/9w9dp+ZFxcePptawqZ6j+gyDKx+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1mvl9zfZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1mvl9zfZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5BB1C4CEC4;
	Fri, 27 Sep 2024 12:33:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727440392;
	bh=+pzprjT2D6MPh07arqF76vFH0AAnlEPnUxD5AJ+vIco=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1mvl9zfZlHJPBHbu6oRRNJN9cX2/Jc/MxFCaUk9FTbxXDUvG68x3GzIIm3oo3H7Dv
	 busBvteRP1R/s5GaSyxPYFno67NwRbEr4y7JltDyb8adMAqFtiqUwq8XkEcPzfw80+
	 Ng+gM9yb3xMwMqBmy5gf29Ly6mJUv3kKxCR+deCg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengfei Xu <pengfei.xu@intel.com>,
	Dave Chinner <dchinner@redhat.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Leah Rumancik <leah.rumancik@gmail.com>,
	Chandan Babu R <chandanbabu@kernel.org>
Subject: [PATCH 6.1 40/73] xfs: quotacheck failure can race with background inode inactivation
Date: Fri, 27 Sep 2024 14:23:51 +0200
Message-ID: <20240927121721.553232427@linuxfoundation.org>
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

From: Dave Chinner <dchinner@redhat.com>

[ Upstream commit 0c7273e494dd5121e20e160cb2f047a593ee14a8 ]

The background inode inactivation can attached dquots to inodes, but
this can race with a foreground quotacheck failure that leads to
disabling quotas and freeing the mp->m_quotainfo structure. The
background inode inactivation then tries to allocate a quota, tries
to dereference mp->m_quotainfo, and crashes like so:

XFS (loop1): Quotacheck: Unsuccessful (Error -5): Disabling quotas.
xfs filesystem being mounted at /root/syzkaller.qCVHXV/0/file0 supports timestamps until 2038 (0x7fffffff)
BUG: kernel NULL pointer dereference, address: 00000000000002a8
....
CPU: 0 PID: 161 Comm: kworker/0:4 Not tainted 6.2.0-c9c3395d5e3d #1
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.0-0-gd239552ce722-prebuilt.qemu.org 04/01/2014
Workqueue: xfs-inodegc/loop1 xfs_inodegc_worker
RIP: 0010:xfs_dquot_alloc+0x95/0x1e0
....
Call Trace:
 <TASK>
 xfs_qm_dqread+0x46/0x440
 xfs_qm_dqget_inode+0x154/0x500
 xfs_qm_dqattach_one+0x142/0x3c0
 xfs_qm_dqattach_locked+0x14a/0x170
 xfs_qm_dqattach+0x52/0x80
 xfs_inactive+0x186/0x340
 xfs_inodegc_worker+0xd3/0x430
 process_one_work+0x3b1/0x960
 worker_thread+0x52/0x660
 kthread+0x161/0x1a0
 ret_from_fork+0x29/0x50
 </TASK>
....

Prevent this race by flushing all the queued background inode
inactivations pending before purging all the cached dquots when
quotacheck fails.

Reported-by: Pengfei Xu <pengfei.xu@intel.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_qm.c |   40 ++++++++++++++++++++++++++--------------
 1 file changed, 26 insertions(+), 14 deletions(-)

--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -1321,15 +1321,14 @@ xfs_qm_quotacheck(
 
 	error = xfs_iwalk_threaded(mp, 0, 0, xfs_qm_dqusage_adjust, 0, true,
 			NULL);
-	if (error) {
-		/*
-		 * The inode walk may have partially populated the dquot
-		 * caches.  We must purge them before disabling quota and
-		 * tearing down the quotainfo, or else the dquots will leak.
-		 */
-		xfs_qm_dqpurge_all(mp);
-		goto error_return;
-	}
+
+	/*
+	 * On error, the inode walk may have partially populated the dquot
+	 * caches.  We must purge them before disabling quota and tearing down
+	 * the quotainfo, or else the dquots will leak.
+	 */
+	if (error)
+		goto error_purge;
 
 	/*
 	 * We've made all the changes that we need to make incore.  Flush them
@@ -1363,10 +1362,8 @@ xfs_qm_quotacheck(
 	 * and turn quotaoff. The dquots won't be attached to any of the inodes
 	 * at this point (because we intentionally didn't in dqget_noattach).
 	 */
-	if (error) {
-		xfs_qm_dqpurge_all(mp);
-		goto error_return;
-	}
+	if (error)
+		goto error_purge;
 
 	/*
 	 * If one type of quotas is off, then it will lose its
@@ -1376,7 +1373,7 @@ xfs_qm_quotacheck(
 	mp->m_qflags &= ~XFS_ALL_QUOTA_CHKD;
 	mp->m_qflags |= flags;
 
- error_return:
+error_return:
 	xfs_buf_delwri_cancel(&buffer_list);
 
 	if (error) {
@@ -1395,6 +1392,21 @@ xfs_qm_quotacheck(
 	} else
 		xfs_notice(mp, "Quotacheck: Done.");
 	return error;
+
+error_purge:
+	/*
+	 * On error, we may have inodes queued for inactivation. This may try
+	 * to attach dquots to the inode before running cleanup operations on
+	 * the inode and this can race with the xfs_qm_destroy_quotainfo() call
+	 * below that frees mp->m_quotainfo. To avoid this race, flush all the
+	 * pending inodegc operations before we purge the dquots from memory,
+	 * ensuring that background inactivation is idle whilst we turn off
+	 * quotas.
+	 */
+	xfs_inodegc_flush(mp);
+	xfs_qm_dqpurge_all(mp);
+	goto error_return;
+
 }
 
 /*


