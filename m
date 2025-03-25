Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF32325745F;
	Tue, 25 Mar 2025 12:27:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905669; cv=none; b=jAMLyObnSl3hVAUf1JkdCRjhXOYLx2nbnbsMgcANRUlZUkyi/Ke9TMEwySQsxsOD4lv8R6hpe1/Oc0AlQxGGGmQuRMvNoIPJq/3Pl0Vujeu0nZN+XaGqPUv80qoSwOAzI2HXF0cL1G3SE4KE/JmUaOwCi7Bcr+Gxnkky3ymptaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905669; c=relaxed/simple;
	bh=8tRmqafhXgPULLasVK5YxwZo601+CCPalOMA3xz2G0A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JseNEBBYrdWJYhptr/+NpDtacT60c/C77cNaGZIDxkWW8dsMNPUjcCV/HRUANvgo9K97UF5lH5egAbn08VQSycp7YJd56MmoE+FdO50iWJYE03cQ7Nqc+fz4Zq0blGFYuqV2X2iL+DbJpWLyM4ch/T2swv5sr7nsA391ry+jTYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bY9mANlp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bY9mANlp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6490AC4CEE4;
	Tue, 25 Mar 2025 12:27:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905669;
	bh=8tRmqafhXgPULLasVK5YxwZo601+CCPalOMA3xz2G0A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bY9mANlpOakIGoF1ayRTgMsbrD8a5dObjLLVC/nj8gpJKQq1i/EFERgw94ahBBuP4
	 ym/b9G0YdFIeB/gZllwu4amymAomUljxGZy5r+vuEelLhM0F1GgkRGuBwFzWoveWud
	 /su4NSJ3ImkLu220DJXQDwRvjxduiqWX/J4VohEU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Long Li <leo.lilong@huawei.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Chandan Babu R <chandanbabu@kernel.org>,
	Catherine Hoang <catherine.hoang@oracle.com>,
	Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 6.1 099/198] xfs: fix perag leak when growfs fails
Date: Tue, 25 Mar 2025 08:21:01 -0400
Message-ID: <20250325122159.248314607@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122156.633329074@linuxfoundation.org>
References: <20250325122156.633329074@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Long Li <leo.lilong@huawei.com>

[ Upstream commit 7823921887750b39d02e6b44faafdd1cc617c651 ]

[ 6.1: resolved conflicts in xfs_ag.c and xfs_ag.h ]

During growfs, if new ag in memory has been initialized, however
sb_agcount has not been updated, if an error occurs at this time it
will cause perag leaks as follows, these new AGs will not been freed
during umount , because of these new AGs are not visible(that is
included in mp->m_sb.sb_agcount).

unreferenced object 0xffff88810be40200 (size 512):
  comm "xfs_growfs", pid 857, jiffies 4294909093
  hex dump (first 32 bytes):
    00 c0 c1 05 81 88 ff ff 04 00 00 00 00 00 00 00  ................
    01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace (crc 381741e2):
    [<ffffffff8191aef6>] __kmalloc+0x386/0x4f0
    [<ffffffff82553e65>] kmem_alloc+0xb5/0x2f0
    [<ffffffff8238dac5>] xfs_initialize_perag+0xc5/0x810
    [<ffffffff824f679c>] xfs_growfs_data+0x9bc/0xbc0
    [<ffffffff8250b90e>] xfs_file_ioctl+0x5fe/0x14d0
    [<ffffffff81aa5194>] __x64_sys_ioctl+0x144/0x1c0
    [<ffffffff83c3d81f>] do_syscall_64+0x3f/0xe0
    [<ffffffff83e00087>] entry_SYSCALL_64_after_hwframe+0x62/0x6a
unreferenced object 0xffff88810be40800 (size 512):
  comm "xfs_growfs", pid 857, jiffies 4294909093
  hex dump (first 32 bytes):
    20 00 00 00 00 00 00 00 57 ef be dc 00 00 00 00   .......W.......
    10 08 e4 0b 81 88 ff ff 10 08 e4 0b 81 88 ff ff  ................
  backtrace (crc bde50e2d):
    [<ffffffff8191b43a>] __kmalloc_node+0x3da/0x540
    [<ffffffff81814489>] kvmalloc_node+0x99/0x160
    [<ffffffff8286acff>] bucket_table_alloc.isra.0+0x5f/0x400
    [<ffffffff8286bdc5>] rhashtable_init+0x405/0x760
    [<ffffffff8238dda3>] xfs_initialize_perag+0x3a3/0x810
    [<ffffffff824f679c>] xfs_growfs_data+0x9bc/0xbc0
    [<ffffffff8250b90e>] xfs_file_ioctl+0x5fe/0x14d0
    [<ffffffff81aa5194>] __x64_sys_ioctl+0x144/0x1c0
    [<ffffffff83c3d81f>] do_syscall_64+0x3f/0xe0
    [<ffffffff83e00087>] entry_SYSCALL_64_after_hwframe+0x62/0x6a

Factor out xfs_free_unused_perag_range() from xfs_initialize_perag(),
used for freeing unused perag within a specified range in error handling,
included in the error path of the growfs failure.

Fixes: 1c1c6ebcf528 ("xfs: Replace per-ag array with a radix tree")
Signed-off-by: Long Li <leo.lilong@huawei.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_ag.c |   34 +++++++++++++++++++++++++---------
 fs/xfs/libxfs/xfs_ag.h |    3 +++
 fs/xfs/xfs_fsops.c     |    5 ++++-
 3 files changed, 32 insertions(+), 10 deletions(-)

--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -259,6 +259,30 @@ xfs_agino_range(
 	return __xfs_agino_range(mp, xfs_ag_block_count(mp, agno), first, last);
 }
 
+/*
+ * Free perag within the specified AG range, it is only used to free unused
+ * perags under the error handling path.
+ */
+void
+xfs_free_unused_perag_range(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		agstart,
+	xfs_agnumber_t		agend)
+{
+	struct xfs_perag	*pag;
+	xfs_agnumber_t		index;
+
+	for (index = agstart; index < agend; index++) {
+		spin_lock(&mp->m_perag_lock);
+		pag = radix_tree_delete(&mp->m_perag_tree, index);
+		spin_unlock(&mp->m_perag_lock);
+		if (!pag)
+			break;
+		xfs_buf_hash_destroy(pag);
+		kmem_free(pag);
+	}
+}
+
 int
 xfs_initialize_perag(
 	struct xfs_mount	*mp,
@@ -352,15 +376,7 @@ out_free_pag:
 	kmem_free(pag);
 out_unwind_new_pags:
 	/* unwind any prior newly initialized pags */
-	for (index = first_initialised; index < agcount; index++) {
-		spin_lock(&mp->m_perag_lock);
-		pag = radix_tree_delete(&mp->m_perag_tree, index);
-		spin_unlock(&mp->m_perag_lock);
-		if (!pag)
-			break;
-		xfs_buf_hash_destroy(pag);
-		kmem_free(pag);
-	}
+	xfs_free_unused_perag_range(mp, first_initialised, agcount);
 	return error;
 }
 
--- a/fs/xfs/libxfs/xfs_ag.h
+++ b/fs/xfs/libxfs/xfs_ag.h
@@ -106,6 +106,9 @@ struct xfs_perag {
 #endif /* __KERNEL__ */
 };
 
+
+void xfs_free_unused_perag_range(struct xfs_mount *mp, xfs_agnumber_t agstart,
+			xfs_agnumber_t agend);
 int xfs_initialize_perag(struct xfs_mount *mp, xfs_agnumber_t agcount,
 			xfs_rfsblock_t dcount, xfs_agnumber_t *maxagi);
 int xfs_initialize_perag_data(struct xfs_mount *mp, xfs_agnumber_t agno);
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -153,7 +153,7 @@ xfs_growfs_data_private(
 			(delta > 0 ? XFS_GROWFS_SPACE_RES(mp) : -delta), 0,
 			XFS_TRANS_RESERVE, &tp);
 	if (error)
-		return error;
+		goto out_free_unused_perag;
 
 	last_pag = xfs_perag_get(mp, oagcount - 1);
 	if (delta > 0) {
@@ -227,6 +227,9 @@ xfs_growfs_data_private(
 
 out_trans_cancel:
 	xfs_trans_cancel(tp);
+out_free_unused_perag:
+	if (nagcount > oagcount)
+		xfs_free_unused_perag_range(mp, oagcount, nagcount);
 	return error;
 }
 


