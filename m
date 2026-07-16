Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AAA84248BC;
	Thu, 16 Jul 2026 14:11:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211118; cv=none; b=QXcaNWC+sSyen0y6W0igHdKjWoGKsmEjOByyZlbY/c1abbQ8mrNVmR68DO2cM+Ax+OsaL53x/2ho2Fl/uN233YdYWb5HJXRFcZ98QAejnRLStF99EKqNI2QcLF1RAnXCRH5jbViu1bhcb5bGgFgAbyR5PsIk/BOuXJRJ0b3KFQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211118; c=relaxed/simple;
	bh=57KshtylMSzKlqmJe60g7OWaWzZZXYEtN2Tll9CITuM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OUepHat6ES/12LdX/g0FJI4EacJ5/Fs25hQ9X8m9K4EVoM72BQigD6g8/cr2YXMFwxIjAVhrZNobGUIBEmPLS3icRHDbGL/sWr6xq63DnwYRsAgfudf5ITR9WPzApUZ5coyND67HaPswcC33UDN0qXlDgxq9C5/9AhLgKn/VBPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F1KttJCy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F1KttJCy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE0D21F00A3A;
	Thu, 16 Jul 2026 14:11:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211117;
	bh=d6qwOovvDc8uGqOlcxRiry0Aw0mnaKuWizImlAHUJho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F1KttJCyU2iSChWj9381+7CfwAZNU+efXB87dmERe3XI4/V1gn2cjBSO9GCZGHXqs
	 rqoauIie1lNG5BklndHoUvDLAH5yesQKvwyciHCVhC5ZaWB6hOhXZmdF9tkqReCRDs
	 aPp+X48BRwvsZ0bYRLEPVBCaWJErIdFdxp/wb7mQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dawei Feng <dawei.feng@seu.edu.cn>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 279/480] xfs: fix memory leak in xfs_dqinode_metadir_create()
Date: Thu, 16 Jul 2026 15:30:26 +0200
Message-ID: <20260716133050.860432377@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dawei Feng <dawei.feng@seu.edu.cn>

commit 45de375b25060edf46e20abb36521ba530336ceb upstream.

If xfs_metadir_create() fails in xfs_dqinode_metadir_create(), the current
code returns directly, leaking the allocated update and transaction state.
If the subsequent commit fails, the caller-owned inode reference is left
behind.

Fix this memory leak by routing the create failure path through
xfs_metadir_cancel().  For both create and commit failures, finish and
release any inode returned to the caller, mirroring the unwind pattern in
xfs_metadir_mkdir().

The bug was first flagged by an experimental analysis tool we are
developing for kernel memory-management bugs while analyzing
v6.13-rc1. The tool is still under development and is not yet publicly
available. Manual inspection confirms that the bug is still
present in v7.1.1.

An x86_64 allyesconfig build showed no new warnings. Runtime validation
used kprobe fault injection during `mount -o uquota` on a metadir XFS
image. Injecting xfs_metadir_create() reproduced the old active-update path
that left mount stuck later in mount setup; after this change, the same
injection reported cancel_hits=1 and irele_hits=1. Injecting
xfs_metadir_commit() exercised the old inode-reference leak path; after
this change, it reported irele_hits=1.

Fixes: e80fbe1ad8ef ("xfs: use metadir for quota inodes")
Cc: stable@vger.kernel.org # v6.13
Signed-off-by: Dawei Feng <dawei.feng@seu.edu.cn>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_dquot_buf.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/fs/xfs/libxfs/xfs_dquot_buf.c
+++ b/fs/xfs/libxfs/xfs_dquot_buf.c
@@ -436,17 +436,27 @@ xfs_dqinode_metadir_create(
 
 	error = xfs_metadir_create(&upd, S_IFREG);
 	if (error)
-		return error;
+		goto out_cancel;
 
 	xfs_trans_log_inode(upd.tp, upd.ip, XFS_ILOG_CORE);
 
 	error = xfs_metadir_commit(&upd);
 	if (error)
-		return error;
+		goto out_irele;
 
 	xfs_finish_inode_setup(upd.ip);
 	*ipp = upd.ip;
 	return 0;
+
+out_cancel:
+	xfs_metadir_cancel(&upd, error);
+out_irele:
+	/* Have to finish setting up the inode to ensure it's deleted. */
+	if (upd.ip) {
+		xfs_finish_inode_setup(upd.ip);
+		xfs_irele(upd.ip);
+	}
+	return error;
 }
 
 #ifndef __KERNEL__


