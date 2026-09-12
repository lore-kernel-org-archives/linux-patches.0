Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10BCF346774;
	Sat, 12 Sep 2026 14:36:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789223807; cv=none; b=cdI9FHpgoLOTmH2O/LeQ3eOW/0Z2sZZP53I2W1hEXyprzHZYUHCjGNpyAW7yhslSmmpsFEr0Au/WcUxPKSfiOaNiTG2qu0D5N4ZZyfIA4MAA9GVEYi7YrAei0bYzkLM9A3ztCVnxYbEl6q5FEA2VG2f6RcG0vgPQ+188zf0EQSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789223807; c=relaxed/simple;
	bh=OXH9s67pEyLQ8skTkU4BdG17adczI2nvTCHfVs2Q9tI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dSdb0x1Qbc8anoTK31oaWAobW8pFCrOLKFeAilDmMDwyKIbVScrbbWOqMekJKwM3o8zRPrGkX6WewJXm5vkEPUNZO+qMhya61VbgAShFcDh9n27YJU9aiDYIq7iJac5ABeOrGeXQBx/bUG5g+1sGybXs/g3AyNlrLW1OT/+RQBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C9IKf49y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C9IKf49y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BD861F000FF;
	Sat, 12 Sep 2026 14:36:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789223805;
	bh=IS/p5KHbrttS9KJjxLB70sMEoz8s1NcxKe1jbUFPAwE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C9IKf49y8scIfmokPh/4mLCmUJW/uQWdhkxGXAkL5RUSNy3+YzQB/nHcPPGh3cgFH
	 u2rUxWOAwbl2l4KWC1eMNSFnaqtNzamKo3hZOYmOHnsETMXfeytxQgftddF/4SXME4
	 eZKcKtLu6tiAMZ066JYAoJCDJs2BJpmo/iYRD1lw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	TanZheng <tanzheng@kylinos.cn>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0821/1424] RDMA/srpt: Fix srpt_alloc_rw_ctxs() unwind counters
Date: Sat, 12 Sep 2026 08:54:13 +0200
Message-ID: <20260912065625.689687419@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: TanZheng <tanzheng@kylinos.cn>

[ Upstream commit b38f98e176050850f41bb6415f3a71400056623e ]

When srpt_alloc_rw_ctxs() fails partway through a multi-buffer indirect
descriptor, the unwind path destroys RDMA contexts but leaves stale
n_rw_ctx and n_rdma values (and a dangling rw_ctxs pointer). Later
sq_wr_avail accounting in srpt_queue_response() or srpt_write_pending()
can then subtract the wrong number of send queue credits.

Reset the counters and clear rw_ctxs after freeing the heap
allocation before returning an error.

Fixes: b99f8e4d7bcd ("IB/srpt: convert to the generic RDMA READ/WRITE API")
Signed-off-by: TanZheng <tanzheng@kylinos.cn>
Link: https://patch.msgid.link/20260715101550.45345-1-kensanya@163.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 13e1fc5e2759a..4a90e7d84d5c9 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -959,6 +959,7 @@ static int srpt_alloc_rw_ctxs(struct srpt_send_ioctx *ioctx,
 	struct srpt_rdma_ch *ch = ioctx->ch;
 	struct scatterlist *prev = NULL;
 	unsigned prev_nents;
+	u8 n_rdma, n_rw_ctx;
 	int ret, i;
 
 	if (nbufs == 1) {
@@ -970,6 +971,9 @@ static int srpt_alloc_rw_ctxs(struct srpt_send_ioctx *ioctx,
 			return -ENOMEM;
 	}
 
+	n_rw_ctx = ioctx->n_rw_ctx;
+	n_rdma = ioctx->n_rdma;
+
 	for (i = ioctx->n_rw_ctx; i < nbufs; i++, db++) {
 		struct srpt_rw_ctx *ctx = &ioctx->rw_ctxs[i];
 		u64 remote_addr = be64_to_cpu(db->va);
@@ -1016,6 +1020,9 @@ static int srpt_alloc_rw_ctxs(struct srpt_send_ioctx *ioctx,
 	}
 	if (ioctx->rw_ctxs != &ioctx->s_rw_ctx)
 		kfree(ioctx->rw_ctxs);
+	ioctx->rw_ctxs = NULL;
+	ioctx->n_rw_ctx = n_rw_ctx;
+	ioctx->n_rdma = n_rdma;
 	return ret;
 }
 
-- 
2.53.0



