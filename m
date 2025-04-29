Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4833F1917E3;
	Tue, 29 Apr 2025 17:38:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948319; cv=none; b=NdnBPqAvf0aIvGppUoRt4TzWE9hF0UNU+vueKPF4Oy1ro0x42igffI3Z5JWc0+lsFGGNpeoYacIlgwkUq6X66JyQu+O4WBUGBT0yuChDySLkZ6V0EzUo/c0Youad/45smHpX7BhNbwzUhS7SgTyGxz7r2nMEgD415VVsFHdChfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948319; c=relaxed/simple;
	bh=mZIJqLUBJzoigHhMb3lW2f4mca+MmJ8ywtIe1lhiy1I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tc+i/pBUg1/J0w7wSc05AgHV9iE4jo4ec0ITxvoVMHfETs0HiUxOrKNPihojhC/8hIMF7kJ4JvulAJCSohiKllbiZhOWvXiQbrXKFndgrD3uHPsFgiPZddvuEtt5hBjiGSO0aCI0WNsUCWwmd/0CJT1mCopfQJqPimG70flddSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=urqIdg/t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="urqIdg/t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 620E6C4CEE3;
	Tue, 29 Apr 2025 17:38:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948319;
	bh=mZIJqLUBJzoigHhMb3lW2f4mca+MmJ8ywtIe1lhiy1I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=urqIdg/thkX8w6HG00Kr+T25F259OCpXUIEdiaNBxj7hSRjDuKB/teD6pSiDRQX2m
	 D4jAszyuwktIU2ntmTng90yfHCDUswTYZr9ducaYC+t3PUQBaJ+va5PyTnReHOxcyK
	 cS5Rqgduc0lZh9HQsjVZJT1NnbBMF/OxmCxpmoIk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carlos Maiolino <cmaiolino@redhat.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.12 252/280] xfs: Do not allow norecovery mount with quotacheck
Date: Tue, 29 Apr 2025 18:43:13 +0200
Message-ID: <20250429161125.433323726@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
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

From: Carlos Maiolino <cem@kernel.org>

Commit 9f0902091c332b2665951cfb970f60ae7cbdc0f3 upstream

Mounting a filesystem that requires quota state changing will generate a
transaction.

We already check for a read-only device; we should do that for
norecovery too.

A quotacheck on a norecovery mount, and with the right log size, will cause
the mount process to hang on:

[<0>] xlog_grant_head_wait+0x5d/0x2a0 [xfs]
[<0>] xlog_grant_head_check+0x112/0x180 [xfs]
[<0>] xfs_log_reserve+0xe3/0x260 [xfs]
[<0>] xfs_trans_reserve+0x179/0x250 [xfs]
[<0>] xfs_trans_alloc+0x101/0x260 [xfs]
[<0>] xfs_sync_sb+0x3f/0x80 [xfs]
[<0>] xfs_qm_mount_quotas+0xe3/0x2f0 [xfs]
[<0>] xfs_mountfs+0x7ad/0xc20 [xfs]
[<0>] xfs_fs_fill_super+0x762/0xa50 [xfs]
[<0>] get_tree_bdev_flags+0x131/0x1d0
[<0>] vfs_get_tree+0x26/0xd0
[<0>] vfs_cmd_create+0x59/0xe0
[<0>] __do_sys_fsconfig+0x4e3/0x6b0
[<0>] do_syscall_64+0x82/0x160
[<0>] entry_SYSCALL_64_after_hwframe+0x76/0x7e

This is caused by a transaction running with bogus initialized head/tail

I initially hit this while running generic/050, with random log
sizes, but I managed to reproduce it reliably here with the steps
below:

mkfs.xfs -f -lsize=1025M -f -b size=4096 -m crc=1,reflink=1,rmapbt=1, -i
sparse=1 /dev/vdb2 > /dev/null
mount -o usrquota,grpquota,prjquota /dev/vdb2 /mnt
xfs_io -x -c 'shutdown -f' /mnt
umount /mnt
mount -o ro,norecovery,usrquota,grpquota,prjquota  /dev/vdb2 /mnt

Last mount hangs up

As we add yet another validation if quota state is changing, this also
add a new helper named xfs_qm_validate_state_change(), factoring the
quota state changes out of xfs_qm_newmount() to reduce cluttering
within it.

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_qm_bhv.c |   49 ++++++++++++++++++++++++++++++++++---------------
 1 file changed, 34 insertions(+), 15 deletions(-)


--- a/fs/xfs/xfs_qm_bhv.c
+++ b/fs/xfs/xfs_qm_bhv.c
@@ -79,6 +79,28 @@ xfs_qm_statvfs(
 	}
 }
 
+STATIC int
+xfs_qm_validate_state_change(
+	struct xfs_mount	*mp,
+	uint			uqd,
+	uint			gqd,
+	uint			pqd)
+{
+	int state;
+
+	/* Is quota state changing? */
+	state = ((uqd && !XFS_IS_UQUOTA_ON(mp)) ||
+		(!uqd &&  XFS_IS_UQUOTA_ON(mp)) ||
+		 (gqd && !XFS_IS_GQUOTA_ON(mp)) ||
+		(!gqd &&  XFS_IS_GQUOTA_ON(mp)) ||
+		 (pqd && !XFS_IS_PQUOTA_ON(mp)) ||
+		(!pqd &&  XFS_IS_PQUOTA_ON(mp)));
+
+	return  state &&
+		(xfs_dev_is_read_only(mp, "changing quota state") ||
+		xfs_has_norecovery(mp));
+}
+
 int
 xfs_qm_newmount(
 	xfs_mount_t	*mp,
@@ -98,24 +120,21 @@ xfs_qm_newmount(
 	}
 
 	/*
-	 * If the device itself is read-only, we can't allow
-	 * the user to change the state of quota on the mount -
-	 * this would generate a transaction on the ro device,
-	 * which would lead to an I/O error and shutdown
+	 * If the device itself is read-only and/or in norecovery
+	 * mode, we can't allow the user to change the state of
+	 * quota on the mount - this would generate a transaction
+	 * on the ro device, which would lead to an I/O error and
+	 * shutdown.
 	 */
 
-	if (((uquotaondisk && !XFS_IS_UQUOTA_ON(mp)) ||
-	    (!uquotaondisk &&  XFS_IS_UQUOTA_ON(mp)) ||
-	     (gquotaondisk && !XFS_IS_GQUOTA_ON(mp)) ||
-	    (!gquotaondisk &&  XFS_IS_GQUOTA_ON(mp)) ||
-	     (pquotaondisk && !XFS_IS_PQUOTA_ON(mp)) ||
-	    (!pquotaondisk &&  XFS_IS_PQUOTA_ON(mp)))  &&
-	    xfs_dev_is_read_only(mp, "changing quota state")) {
+	if (xfs_qm_validate_state_change(mp, uquotaondisk,
+			    gquotaondisk, pquotaondisk)) {
+
 		xfs_warn(mp, "please mount with%s%s%s%s.",
-			(!quotaondisk ? "out quota" : ""),
-			(uquotaondisk ? " usrquota" : ""),
-			(gquotaondisk ? " grpquota" : ""),
-			(pquotaondisk ? " prjquota" : ""));
+				(!quotaondisk ? "out quota" : ""),
+				(uquotaondisk ? " usrquota" : ""),
+				(gquotaondisk ? " grpquota" : ""),
+				(pquotaondisk ? " prjquota" : ""));
 		return -EPERM;
 	}
 


