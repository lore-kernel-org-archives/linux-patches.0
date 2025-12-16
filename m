Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F17EC33E37C;
	Tue, 16 Dec 2025 11:20:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884053; cv=none; b=eYn7jmk1VNEGiTLNfC7lOCZZPVKBMeAtGne+4uYQSvi9dv/11EzBpLfx8mR6bYEl9lzJ6eIFL/ZO+ZDPNcQWuT5sRZWetIh/FUrWKgKaGa8X0fHqeihqBrjM1YOBsUWUShFeeVtPrryuMo4OX2RIzh+KiJ5LDClzYzraTvsYJzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884053; c=relaxed/simple;
	bh=wAUUYojT6yUUlQz/iTtcA6BHDaSkuPWynlrgS/xFg6I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lWAE7HbYNpSWbWnoQ4WHZQaoRXhd6OLXSl6Cx/qZUhhePswLBe10csuGSGkyHUBIyw1j8PKaV+2GQznmRNURIsFdUQpnetf5YHEkoHpe+jjpapRKOkLHcxB3qjYO0xCUsK1tfPSG1vnTd5Tyi8q3gCnxYRAaFYXEH2yl9b5ARfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ORoPxFqo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ORoPxFqo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75A5AC16AAE;
	Tue, 16 Dec 2025 11:20:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884052;
	bh=wAUUYojT6yUUlQz/iTtcA6BHDaSkuPWynlrgS/xFg6I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ORoPxFqozGXsPHpuzh8XipszLv10cqXtzqFOb0MYhWEAl8TS7VNfenHQOEtFGV4Mg
	 PcOABEaRteT9lAzwpM0stxdeRNoIJTvPKfg/LiK/FtEy/b0B2MKr/w4nGi6Wku/+Fq
	 xauyTvBzmSFszetwvb7Ts1kV3SNaXRaz0TioaRdM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liu Yi <asatsuyu.liu@gmail.com>,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 079/354] RDMA/rxe: Fix null deref on srq->rq.queue after resize failure
Date: Tue, 16 Dec 2025 12:10:46 +0100
Message-ID: <20251216111323.787068300@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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

From: Zhu Yanjun <yanjun.zhu@linux.dev>

[ Upstream commit 503a5e4690ae14c18570141bc0dcf7501a8419b0 ]

A NULL pointer dereference can occur in rxe_srq_chk_attr() when
ibv_modify_srq() is invoked twice in succession under certain error
conditions. The first call may fail in rxe_queue_resize(), which leads
rxe_srq_from_attr() to set srq->rq.queue = NULL. The second call then
triggers a crash (null deref) when accessing
srq->rq.queue->buf->index_mask.

Call Trace:
<TASK>
rxe_modify_srq+0x170/0x480 [rdma_rxe]
? __pfx_rxe_modify_srq+0x10/0x10 [rdma_rxe]
? uverbs_try_lock_object+0x4f/0xa0 [ib_uverbs]
? rdma_lookup_get_uobject+0x1f0/0x380 [ib_uverbs]
ib_uverbs_modify_srq+0x204/0x290 [ib_uverbs]
? __pfx_ib_uverbs_modify_srq+0x10/0x10 [ib_uverbs]
? tryinc_node_nr_active+0xe6/0x150
? uverbs_fill_udata+0xed/0x4f0 [ib_uverbs]
ib_uverbs_handler_UVERBS_METHOD_INVOKE_WRITE+0x2c0/0x470 [ib_uverbs]
? __pfx_ib_uverbs_handler_UVERBS_METHOD_INVOKE_WRITE+0x10/0x10 [ib_uverbs]
? uverbs_fill_udata+0xed/0x4f0 [ib_uverbs]
ib_uverbs_run_method+0x55a/0x6e0 [ib_uverbs]
? __pfx_ib_uverbs_handler_UVERBS_METHOD_INVOKE_WRITE+0x10/0x10 [ib_uverbs]
ib_uverbs_cmd_verbs+0x54d/0x800 [ib_uverbs]
? __pfx_ib_uverbs_cmd_verbs+0x10/0x10 [ib_uverbs]
? __pfx___raw_spin_lock_irqsave+0x10/0x10
? __pfx_do_vfs_ioctl+0x10/0x10
? ioctl_has_perm.constprop.0.isra.0+0x2c7/0x4c0
? __pfx_ioctl_has_perm.constprop.0.isra.0+0x10/0x10
ib_uverbs_ioctl+0x13e/0x220 [ib_uverbs]
? __pfx_ib_uverbs_ioctl+0x10/0x10 [ib_uverbs]
__x64_sys_ioctl+0x138/0x1c0
do_syscall_64+0x82/0x250
? fdget_pos+0x58/0x4c0
? ksys_write+0xf3/0x1c0
? __pfx_ksys_write+0x10/0x10
? do_syscall_64+0xc8/0x250
? __pfx_vm_mmap_pgoff+0x10/0x10
? fget+0x173/0x230
? fput+0x2a/0x80
? ksys_mmap_pgoff+0x224/0x4c0
? do_syscall_64+0xc8/0x250
? do_user_addr_fault+0x37b/0xfe0
? clear_bhb_loop+0x50/0xa0
? clear_bhb_loop+0x50/0xa0
? clear_bhb_loop+0x50/0xa0
entry_SYSCALL_64_after_hwframe+0x76/0x7e

Fixes: 8700e3e7c485 ("Soft RoCE driver")
Tested-by: Liu Yi <asatsuyu.liu@gmail.com>
Signed-off-by: Zhu Yanjun <yanjun.zhu@linux.dev>
Link: https://patch.msgid.link/20251027215203.1321-1-yanjun.zhu@linux.dev
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe_srq.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_srq.c b/drivers/infiniband/sw/rxe/rxe_srq.c
index 3661cb627d28a..2a234f26ac104 100644
--- a/drivers/infiniband/sw/rxe/rxe_srq.c
+++ b/drivers/infiniband/sw/rxe/rxe_srq.c
@@ -171,7 +171,7 @@ int rxe_srq_from_attr(struct rxe_dev *rxe, struct rxe_srq *srq,
 				       udata, mi, &srq->rq.producer_lock,
 				       &srq->rq.consumer_lock);
 		if (err)
-			goto err_free;
+			return err;
 
 		srq->rq.max_wr = attr->max_wr;
 	}
@@ -180,11 +180,6 @@ int rxe_srq_from_attr(struct rxe_dev *rxe, struct rxe_srq *srq,
 		srq->limit = attr->srq_limit;
 
 	return 0;
-
-err_free:
-	rxe_queue_cleanup(q);
-	srq->rq.queue = NULL;
-	return err;
 }
 
 void rxe_srq_cleanup(struct rxe_pool_elem *elem)
-- 
2.51.0



