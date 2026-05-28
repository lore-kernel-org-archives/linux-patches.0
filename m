Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50F323368B5;
	Thu, 28 May 2026 20:35:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000547; cv=none; b=SA9C6fb+OLmyrhsUF9JtaA0+hbNsSavKbmusAGf8Nk4d9iSICTYMtz0MS3psdKR75jNlNdhzE7ap9qaEV16lawgzXw2RcNkJRTcJun6FKwwQfs2YBXMYv+9YYU8zRcnEgbLWWWmt7LcnzL+wx2nBNOuQpCJMuB6mrdB770Qpnso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000547; c=relaxed/simple;
	bh=JzhRK8QS65ILq5cGIc/DxIoF5EestzvKVDp/lAQBazQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AUm3iIjJBleHSDT7Xj5yxuwau6fABFONo7Uiom3jxKkbw753ubiauYhaNQJvqm2bCn+0Y4yrAQFSfXA8EqePsdbq/Tw+4ldyQcAvPbubfow0GE+xhNDfbIGm1NTQK9hicH0FgTbjzmd9JBszK9ZhLzrePU4TRSsUK2f5DJhPDO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iaNIctz0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iaNIctz0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A68BF1F000E9;
	Thu, 28 May 2026 20:35:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000546;
	bh=ka+Brd9pgBXVQstZ3AZDcyv7brQdfSGOrCKIhpBurvU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iaNIctz0C/im5doVLJNeqBKtzycU1RAH06uOSQDa9vIvUSM35XiWzJhMs5FYGKaxR
	 /TqA5SC+NJRxBFALzbVrbDSpTODrb8RfbffYBeO6ctcDDEmk4Q2l4eQD5t1C594IfJ
	 skvDbq5oNh0/Shk1uPykwQ0YOKVttbs9N0G5I0+M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zilin Guan <zilin@seu.edu.cn>,
	Dawei Feng <dawei.feng@seu.edu.cn>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 082/272] qed: fix double free in qed_cxt_tables_alloc()
Date: Thu, 28 May 2026 21:47:36 +0200
Message-ID: <20260528194631.674905531@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194629.379955525@linuxfoundation.org>
References: <20260528194629.379955525@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dawei Feng <dawei.feng@seu.edu.cn>

commit 2bccfb8476ca5f3548afbd623dc7a6980d4e77de upstream.

If one of the later PF or VF CID bitmap allocations fails,
qed_cid_map_alloc() jumps to cid_map_fail and frees the previously
allocated CID bitmaps before returning an error. qed_cxt_tables_alloc()
then calls qed_cxt_mngr_free(), which invokes qed_cid_map_free()
again.

Fix this by setting each CID bitmap pointer to NULL after bitmap_free()
to avoid double free.

The bug was first flagged by an experimental analysis tool we are
developing for kernel memory-management bugs while analyzing
v6.13-rc1. The tool is still under development and is not yet publicly
available. Manual inspection confirms that the bug is still
present in v7.1-rc3.

Runtime reproduction was not attempted because exercising the failing
allocation path requires device-specific setup.

Fixes: fe56b9e6a8d9 ("qed: Add module with basic common support")
Cc: stable@vger.kernel.org
Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
Signed-off-by: Dawei Feng <dawei.feng@seu.edu.cn>
Link: https://patch.msgid.link/20260520070323.2762379-1-dawei.feng@seu.edu.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/qlogic/qed/qed_cxt.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/ethernet/qlogic/qed/qed_cxt.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_cxt.c
@@ -1038,11 +1038,13 @@ static void qed_cid_map_free(struct qed_
 
 	for (type = 0; type < MAX_CONN_TYPES; type++) {
 		bitmap_free(p_mngr->acquired[type].cid_map);
+		p_mngr->acquired[type].cid_map = NULL;
 		p_mngr->acquired[type].max_count = 0;
 		p_mngr->acquired[type].start_cid = 0;
 
 		for (vf = 0; vf < MAX_NUM_VFS; vf++) {
 			bitmap_free(p_mngr->acquired_vf[type][vf].cid_map);
+			p_mngr->acquired_vf[type][vf].cid_map = NULL;
 			p_mngr->acquired_vf[type][vf].max_count = 0;
 			p_mngr->acquired_vf[type][vf].start_cid = 0;
 		}


