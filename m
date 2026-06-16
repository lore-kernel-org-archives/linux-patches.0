Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D24E3D45CB;
	Tue, 16 Jun 2026 18:09:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781633383; cv=none; b=FfphK816QB2G5YX6S4lDYAuaF1q9cdbLxCVTiOrYR/sbiervy6Zm1lYXuwl3litW2/1CAtzyPvVv/PvULaNNsQ3o8/tuqIZ5NzfGu6HO4MRRMtsbO1QfEIp9OZ3ygLI/etWypRpGhpQZCyJ5EdBsM2xIlU/KXXhfYATP2wREVUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781633383; c=relaxed/simple;
	bh=vraXheyRBc0RLyGaWcmVuj61ZZ/lsfs6GpPtVgSTagM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y9zXynHVzZfg2H6mDuOEzD+aJlIo/ZmLfY3Db5+QwLaQHKk4d4kr2KRz87J/zsICy6EVYwP3yYsDTTX1V06y2vl86Yfn8LIcw81YguwJlTczWWBeYZUUefurDN+8o7UsypUmby3dBMlg18WVgfDxKMCullU7f8ka0im5TSna7ZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MKVKIOxJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MKVKIOxJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 711ED1F000E9;
	Tue, 16 Jun 2026 18:09:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781633382;
	bh=BqUae3BRQv06aVvfiMbXTKRQkN3e1vuOqFME785CAfI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MKVKIOxJBTJhDnT5LMRwAo/OpLlWioiFQ5CwBcGZ249a7uGQqn28rSf5rzD1Zd5re
	 ShyUms4ivOzlsMYDNZk98Z53Z4jPDgoqcvma6CyoO5tZ3Qe75I6h+KZ7eSCXuDo5oz
	 XF1bDBcOtJotcZqUSQ+CDzxfX/kCPuW7hIblkZIs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiasheng Jiang <jiashengjiangcool@gmail.com>,
	Zhu Yanjun <yanjun.Zhu@linux.dev>,
	Leon Romanovsky <leon@kernel.org>,
	Ben Hutchings <benh@debian.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 051/411] RDMA/rxe: Fix double free in rxe_srq_from_init
Date: Tue, 16 Jun 2026 20:24:49 +0530
Message-ID: <20260616145102.995640913@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiasheng Jiang <jiashengjiangcool@gmail.com>

commit 0beefd0e15d962f497aad750b2d5e9c3570b66d1 upstream.

In rxe_srq_from_init(), the queue pointer 'q' is assigned to
'srq->rq.queue' before copying the SRQ number to user space.
If copy_to_user() fails, the function calls rxe_queue_cleanup()
to free the queue, but leaves the now-invalid pointer in
'srq->rq.queue'.

The caller of rxe_srq_from_init() (rxe_create_srq) eventually
calls rxe_srq_cleanup() upon receiving the error, which triggers
a second rxe_queue_cleanup() on the same memory, leading to a
double free.

The call trace looks like this:
   kmem_cache_free+0x.../0x...
   rxe_queue_cleanup+0x1a/0x30 [rdma_rxe]
   rxe_srq_cleanup+0x42/0x60 [rdma_rxe]
   rxe_elem_release+0x31/0x70 [rdma_rxe]
   rxe_create_srq+0x12b/0x1a0 [rdma_rxe]
   ib_create_srq_user+0x9a/0x150 [ib_core]

Fix this by moving 'srq->rq.queue = q' after copy_to_user.

Fixes: aae0484e15f0 ("IB/rxe: avoid srq memory leak")
Signed-off-by: Jiasheng Jiang <jiashengjiangcool@gmail.com>
Link: https://patch.msgid.link/20260112015412.29458-1-jiashengjiangcool@gmail.com
Reviewed-by: Zhu Yanjun <yanjun.Zhu@linux.dev>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
[bwh: Backported to 5.15: There was no assignment to init->attr.max_wr
 here; don't add it]
Signed-off-by: Ben Hutchings <benh@debian.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe_srq.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_srq.c b/drivers/infiniband/sw/rxe/rxe_srq.c
index eb1c4c3b3a7865..595d4e7b91d0b8 100644
--- a/drivers/infiniband/sw/rxe/rxe_srq.c
+++ b/drivers/infiniband/sw/rxe/rxe_srq.c
@@ -100,8 +100,6 @@ int rxe_srq_from_init(struct rxe_dev *rxe, struct rxe_srq *srq,
 		return -ENOMEM;
 	}
 
-	srq->rq.queue = q;
-
 	err = do_mmap_info(rxe, uresp ? &uresp->mi : NULL, udata, q->buf,
 			   q->buf_size, &q->ip);
 	if (err) {
@@ -118,6 +116,8 @@ int rxe_srq_from_init(struct rxe_dev *rxe, struct rxe_srq *srq,
 		}
 	}
 
+	srq->rq.queue = q;
+
 	return 0;
 }
 
-- 
2.53.0



