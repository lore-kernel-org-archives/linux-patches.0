Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 593A3342CAD;
	Tue, 11 Nov 2025 01:39:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825163; cv=none; b=NT5eHMFKpycE7FBsDMSHWo9+XOq7uGfPHXqUU0GSLxIryDEoh/8bkbG/7ScFBDsIlsjpVYMrq8EKcjmw+006eDAtUU3mCkWSOjGnptf/NV5TQE0kvBLHE7YsX7n1lReAy7qstWVgF9YFwvUlAyAwEd9t/uyTgn+UWHzl0YMPxDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825163; c=relaxed/simple;
	bh=o37TYFAO5N+ll9Yn+XEFXbOhObjE9Wxwlx7QVv9ixoo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QovpItjArlcHa/DFaLY/V5KXFWL3sKkI+IHNh2VU294lOigNI+01IjVGKFpBDZ11pRMiASjD9HxyX6x1vaxbZB5usvJijMRXjld2Zq0YAjsfPnRSDPXg1k/r1uYAdfoxCmLadIjEGfgpwnSmjay07z1IrVT2M8BhZg5moeHaUYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PhH7BDPN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PhH7BDPN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADB8BC4AF09;
	Tue, 11 Nov 2025 01:39:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825163;
	bh=o37TYFAO5N+ll9Yn+XEFXbOhObjE9Wxwlx7QVv9ixoo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PhH7BDPNDuqvcuhvaqe6+IZ52vpMYJBQQPOsuyBL6zJeGT8iwHiIdXlxHMXE9gUza
	 TvtNPraKKGuLaGjGNDZoU1zJTfNCP559OnD75QJbYdjJGkm92anbiyJ4DUS93aebGH
	 Tl4pd695EnORhkBv+s4Wu5lWZNIGFFiZRDEewiH8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuhao Fu <sfual@cse.ust.hk>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 687/849] RDMA/uverbs: Fix umem release in UVERBS_METHOD_CQ_CREATE
Date: Tue, 11 Nov 2025 09:44:17 +0900
Message-ID: <20251111004553.035480885@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shuhao Fu <sfual@cse.ust.hk>

[ Upstream commit d8713158faad0fd4418cb2f4e432c3876ad53a1f ]

In `UVERBS_METHOD_CQ_CREATE`, umem should be released if anything goes
wrong. Currently, if `create_cq_umem` fails, umem would not be
released or referenced, causing a possible leak.

In this patch, we release umem at `UVERBS_METHOD_CQ_CREATE`, the driver
should not release umem if it returns an error code.

Fixes: 1a40c362ae26 ("RDMA/uverbs: Add a common way to create CQ with umem")
Signed-off-by: Shuhao Fu <sfual@cse.ust.hk>
Link: https://patch.msgid.link/aOh1le4YqtYwj-hH@osx.local
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/uverbs_std_types_cq.c |  1 +
 drivers/infiniband/hw/efa/efa_verbs.c         | 16 +++++++---------
 2 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_std_types_cq.c b/drivers/infiniband/core/uverbs_std_types_cq.c
index 37cd375565104..fab5d914029dd 100644
--- a/drivers/infiniband/core/uverbs_std_types_cq.c
+++ b/drivers/infiniband/core/uverbs_std_types_cq.c
@@ -206,6 +206,7 @@ static int UVERBS_HANDLER(UVERBS_METHOD_CQ_CREATE)(
 	return ret;
 
 err_free:
+	ib_umem_release(umem);
 	rdma_restrack_put(&cq->res);
 	kfree(cq);
 err_event_file:
diff --git a/drivers/infiniband/hw/efa/efa_verbs.c b/drivers/infiniband/hw/efa/efa_verbs.c
index 886923d5fe506..542d25e191ea6 100644
--- a/drivers/infiniband/hw/efa/efa_verbs.c
+++ b/drivers/infiniband/hw/efa/efa_verbs.c
@@ -1216,13 +1216,13 @@ int efa_create_cq_umem(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
 		if (umem->length < cq->size) {
 			ibdev_dbg(&dev->ibdev, "External memory too small\n");
 			err = -EINVAL;
-			goto err_free_mem;
+			goto err_out;
 		}
 
 		if (!ib_umem_is_contiguous(umem)) {
 			ibdev_dbg(&dev->ibdev, "Non contiguous CQ unsupported\n");
 			err = -EINVAL;
-			goto err_free_mem;
+			goto err_out;
 		}
 
 		cq->cpu_addr = NULL;
@@ -1251,7 +1251,7 @@ int efa_create_cq_umem(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
 
 	err = efa_com_create_cq(&dev->edev, &params, &result);
 	if (err)
-		goto err_free_mem;
+		goto err_free_mapped;
 
 	resp.db_off = result.db_off;
 	resp.cq_idx = result.cq_idx;
@@ -1299,12 +1299,10 @@ int efa_create_cq_umem(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
 	efa_cq_user_mmap_entries_remove(cq);
 err_destroy_cq:
 	efa_destroy_cq_idx(dev, cq->cq_idx);
-err_free_mem:
-	if (umem)
-		ib_umem_release(umem);
-	else
-		efa_free_mapped(dev, cq->cpu_addr, cq->dma_addr, cq->size, DMA_FROM_DEVICE);
-
+err_free_mapped:
+	if (!umem)
+		efa_free_mapped(dev, cq->cpu_addr, cq->dma_addr, cq->size,
+				DMA_FROM_DEVICE);
 err_out:
 	atomic64_inc(&dev->stats.create_cq_err);
 	return err;
-- 
2.51.0



