Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CEB2385D7C;
	Sat, 12 Sep 2026 07:19:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197602; cv=none; b=hoChlj3XoWcZKYyHJ5hZP5+y0o06ileekJ+S26hCpMQ8+xdUAILg170uczY68zMLS6XR5PGnEwANjGAYGZ7uUj7XOnj7yDqWZrPmEjeZbpBKU3E8lD6Y9Q+bnF0AhHUe66/4GyO19TqGLgauBu2rdMrsa5PADZZ6/c+lTdvVLdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197602; c=relaxed/simple;
	bh=3JoY22aNSjyEm0yQ7dLjOMrR5yYUF1XDx/5OVejvebE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bVustgTfW5Q0WLh7s2QiulDV8As/qItEglTfd20XTSw+xu6G42x4syqCEFmpjBd5NCMDtcPLHX5+Y2e4PMBD0sMhcn3K2I75gbgZ/E0dAfPRANA89IJdFAFpnIPzf6lmc/Fio/6sHAPI0caHMdZE7HrO6ceAofANug4fBD1U1wo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nda6c7Jz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nda6c7Jz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 779661F00893;
	Sat, 12 Sep 2026 07:19:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197595;
	bh=FEgud7t8o4PHvJZBvdHEIRH5PpW6oYH/ell/YrFl7Dw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nda6c7Jz16SI9fQnWf0q1MC5Mv9RXeTJEQeRjJosAg1QC6ci0+7FszrpuPnlpfpcO
	 Di5y305ORpk2cKar2HMvN1+8cH+3wz+1ocdbj5dcSsexz8y+x3TtCfmAocDQjyn+GG
	 6XYIyxHUiWsHwnVA/vkWHWNZCNawvqeD9vnJhtL4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0207/1815] nvmet-rdma: fix response resource leak on queue teardown
Date: Sat, 12 Sep 2026 08:32:37 +0200
Message-ID: <20260912065653.858183294@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>

[ Upstream commit 0114dd303b373522dea06053aabae34bdd33a7c4 ]

When an nvme target with rdma transport is removed while I/Os are in
flight, a response can be posted but its send completion is never
delivered before the connection is torn down. As a result
nvmet_rdma_send_done() and nvmet_rdma_release_rsp() are never called for
the response, and this leaks the allocated RDMA read/write context and
request SGLs.

These leaks are recreated by running blktests nvme/061 with the rdma
transport and the siw driver. Kernel kmemleak feature reports them as
follows:

  unreferenced object 0xffff88812bc490c0 (size 32):
    comm "kworker/2:1H", pid 409, jiffies 4307744490
    backtrace (crc 89afd339):
      __kmalloc_noprof+0x5f9/0x890
      sgl_alloc_order+0x7b/0x380
      nvmet_req_alloc_sgls+0x290/0x4f0 [nvmet]
      nvmet_rdma_map_sgl_keyed+0x241/0x12e0 [nvmet_rdma]
      nvmet_rdma_handle_command+0x73e/0xb80 [nvmet_rdma]
      __ib_process_cq+0x149/0x4c0 [ib_core]
      ib_cq_poll_work+0x49/0x160 [ib_core]
      process_one_work+0x8b2/0x1640
      worker_thread+0x5fd/0xfe0
      kthread+0x367/0x460
      ret_from_fork+0x655/0x9d0
      ret_from_fork_asm+0x1a/0x30

  unreferenced object 0xffff88814bd05e80 (size 64):
    comm "kworker/3:1H", pid 148, jiffies 4295195428
    backtrace (crc e35510cb):
      __kmalloc_noprof+0x5f9/0x890
      rdma_rw_ctx_init+0x333/0x1fa0 [ib_core]
      nvmet_rdma_map_sgl_keyed+0x5c8/0x12e0 [nvmet_rdma]
      nvmet_rdma_handle_command+0x73e/0xb80 [nvmet_rdma]
      __ib_process_cq+0x149/0x4c0 [ib_core]
      ib_cq_poll_work+0x49/0x160 [ib_core]
      process_one_work+0x8b2/0x1640
      worker_thread+0x5fd/0xfe0
      kthread+0x367/0x460
      ret_from_fork+0x655/0x9d0
      ret_from_fork_asm+0x1a/0x30

To avoid the memory leaks, reclaim the memory of the in-flight responses
when the queue QP is torn down. Call nvmet_rdma_free_rsp_resources()
that frees up the RDMA read/write context and the request SGLs of such
responses.

Fixes: 8f000cac6e7a ("nvmet-rdma: add a NVMe over Fabrics RDMA target driver")
Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/rdma.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/nvme/target/rdma.c b/drivers/nvme/target/rdma.c
index 3c34f235e542e..de5a88fbb2337 100644
--- a/drivers/nvme/target/rdma.c
+++ b/drivers/nvme/target/rdma.c
@@ -1345,9 +1345,27 @@ static int nvmet_rdma_create_queue_ib(struct nvmet_rdma_queue *queue)
 	goto out;
 }
 
+static bool nvmet_rdma_reclaim_rsp(struct sbitmap *sb, unsigned int bitnr,
+				   void *data)
+{
+	struct nvmet_rdma_queue *queue = data;
+
+	nvmet_rdma_free_rsp_resources(&queue->rsps[bitnr]);
+
+	return true;
+}
+
 static void nvmet_rdma_destroy_queue_ib(struct nvmet_rdma_queue *queue)
 {
 	ib_drain_qp(queue->qp);
+
+	/*
+	 * Reclaim resources of a response that is still in-flight when the
+	 * queue is being torn down. This happens when the connection was
+	 * forcefully disconnected while an I/O is in flight.
+	 */
+	sbitmap_for_each_set(&queue->rsp_tags, nvmet_rdma_reclaim_rsp, queue);
+
 	if (queue->cm_id)
 		rdma_destroy_id(queue->cm_id);
 	ib_destroy_qp(queue->qp);
-- 
2.53.0



