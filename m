Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D030C1F76D1;
	Tue,  3 Dec 2024 16:21:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242870; cv=none; b=UTRL4uNf6+E3fimGn6UOPQWHZm5vkPbtZQY1GNcmdMNw/MCGOU/kEFjzDtL6qGPqSqo+5rHXu4lz/KmNwV6F91Rx6lrpVUd/uICU4VCOIeuBCIjBJ5RpPxCIg8DSAQX3bRe+X9ipOtj26bH6ggb2rJjO1+/Oo+IMu7QrE0JV+Ts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242870; c=relaxed/simple;
	bh=TO6XrHbC8m2CtJmCNBqVKdTI71/QsK4SZNAanj3qVzY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c4j8beTUWyrFmGF9Tp22K2cD/soKwOL8pTxzzthYm2Ien15td00WEQMY2cZiG9eJW4yZUBy4wrtOlUEhiQyo4CddABdnt+CACBz/ygFa5pvkRV/lmnZ7Vio6tW2Zh7Y0VsSt+T4I5v01EsG4edITDSpBOVfQcesAnE2zNc8twao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qcvtq1O0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qcvtq1O0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45109C4CED6;
	Tue,  3 Dec 2024 16:21:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242870;
	bh=TO6XrHbC8m2CtJmCNBqVKdTI71/QsK4SZNAanj3qVzY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qcvtq1O0B/6YJkLmP43HZUfJ6bpmo16FVfvCei+4CoyvB6tuHWkdlglKCMH7Hh71w
	 h5Lvy+WJ+1HcuBB9dM8E+sYtDM4ZtqJ5K1uPw9JygvDltSq1J08VGmbIkJ4dpbQY0U
	 FNcYwx8rXv/k19QSsTkDMiqwL6g7JQ1PYyfeNVEo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Coddington <bcodding@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	Chuck Lever <chuck.lever@oracle.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 818/826] nfs/blocklayout: Dont attempt unregister for invalid block device
Date: Tue,  3 Dec 2024 15:49:05 +0100
Message-ID: <20241203144815.660704758@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Coddington <bcodding@redhat.com>

[ Upstream commit 3a4ce14d9a6b868e0787e4582420b721c04ee41e ]

Since commit d869da91cccb ("nfs/blocklayout: Fix premature PR key
unregistration") an unmount of a pNFS SCSI layout-enabled NFS may
dereference a NULL block_device in:

  bl_unregister_scsi+0x16/0xe0 [blocklayoutdriver]
  bl_free_device+0x70/0x80 [blocklayoutdriver]
  bl_free_deviceid_node+0x12/0x30 [blocklayoutdriver]
  nfs4_put_deviceid_node+0x60/0xc0 [nfsv4]
  nfs4_deviceid_purge_client+0x132/0x190 [nfsv4]
  unset_pnfs_layoutdriver+0x59/0x60 [nfsv4]
  nfs4_destroy_server+0x36/0x70 [nfsv4]
  nfs_free_server+0x23/0xe0 [nfs]
  deactivate_locked_super+0x30/0xb0
  cleanup_mnt+0xba/0x150
  task_work_run+0x59/0x90
  syscall_exit_to_user_mode+0x217/0x220
  do_syscall_64+0x8e/0x160

This happens because even though we were able to create the
nfs4_deviceid_node, the lookup for the device was unable to attach the
block device to the pnfs_block_dev.

If we never found a block device to register, we can avoid this case with
the PNFS_BDEV_REGISTERED flag.  Move the deref behind the test for the
flag.

Fixes: d869da91cccb ("nfs/blocklayout: Fix premature PR key unregistration")
Signed-off-by: Benjamin Coddington <bcodding@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/blocklayout/dev.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/nfs/blocklayout/dev.c b/fs/nfs/blocklayout/dev.c
index 6252f44479457..cab8809f0e0f4 100644
--- a/fs/nfs/blocklayout/dev.c
+++ b/fs/nfs/blocklayout/dev.c
@@ -20,9 +20,6 @@ static void bl_unregister_scsi(struct pnfs_block_dev *dev)
 	const struct pr_ops *ops = bdev->bd_disk->fops->pr_ops;
 	int status;
 
-	if (!test_and_clear_bit(PNFS_BDEV_REGISTERED, &dev->flags))
-		return;
-
 	status = ops->pr_register(bdev, dev->pr_key, 0, false);
 	if (status)
 		trace_bl_pr_key_unreg_err(bdev, dev->pr_key, status);
@@ -58,7 +55,8 @@ static void bl_unregister_dev(struct pnfs_block_dev *dev)
 		return;
 	}
 
-	if (dev->type == PNFS_BLOCK_VOLUME_SCSI)
+	if (dev->type == PNFS_BLOCK_VOLUME_SCSI &&
+		test_and_clear_bit(PNFS_BDEV_REGISTERED, &dev->flags))
 		bl_unregister_scsi(dev);
 }
 
-- 
2.43.0



