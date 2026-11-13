Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585568;
	b=JvZRsXNdGRxplr69JLyhOuxxYV7EVO5cVXbBe8ly3Xj5oiyo7fENZkXAF+Rp4KRlG90S
	 Q/7DzAyxGX4MOOtX0olJ2tlLhNDNto0zIc1H4ZLjBMjn41ZGPKIb92JDoecgcNKKKR7+A
	 z70cn5nytNyAThKlrGahScpTFeAScFq6GLzsOC17AUpGNwgv7nO+uq57anBdp/bHfquJc
	 zeMe7IZL0y9nrB1A+yVB+eV4Si1llXi21iEmpEIZcsfvDsRyWDWv1fny8Al1o6WhFBLP2
	 TrnhAQ836U2BtNDhgATolG3vHkMvI6/xPpKx3aMJLrFV4XDPygm1cCDhShfxQT4fkJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585568;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VW2tviEt7ipabe7eDpgj2l4Lvan2NC6kHGYC2Qm0DvA=;
	b=4Fvdcx6/mwKgN6ssPm1NEeiN+NNGCgfBU4uR7a3AmXgGSTAVY+PPKbF/WSkcttAAdC1W
	 dOkXxJv29SE1L4O+Sl3hnKsfqFFB7QzbSgYf948eoXkSMlXl9dzK9GnRSrX/Qp1GFPsq9
	 5IKYefkm0q0KsE75LNeOemVu5T1WPqbKr5JzBzGcPqKXvSlWGg2k/+3rNYmy/Uakq7rrS
	 uBNh8MgPMxBV/Bzye28fj9h/Y+J/fn4h4P/kKox8/6N6+BjQ6oew4ZnR8HWBSij956/DT
	 aaVv7XZdOkOtAd1o52p6fk10BiPd4KKGQJVqk61bO4/9P7sp7Z6KBPANMkdAk4UWX4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UXXhzXjL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F867606BA88;
	Fri, 13 Nov 2026 15:59:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UXXhzXjL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF9D01F000C4;
	Fri, 13 Nov 2026 15:59:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585567;
	bh=VW2tviEt7ipabe7eDpgj2l4Lvan2NC6kHGYC2Qm0DvA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UXXhzXjLAPMjrvxmZX7G4a3f7mknKHvkf1EDlB3amPH8etydkdxeYnsN4VxIe0B90
	 m6WlY75Cx1x7luaftLZpMiC4NSfc/OOeCCcL/Xt/yJFkR6XG1I94ypQ5cDYos7Goh6
	 gP4wWPCRde3Lo4KKz6ayHwHp3NwIPWtMnLlyanb0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nilay Shroff <nilay@linux.ibm.com>,
	Christian Aurich Zanettini Martins <christian.aurichzm@gmail.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 203/507] nvme-rdma: fix NULL queue->ctrl dereference on reconnect
Date: Fri, 13 Nov 2026 10:48:27 -0500
Message-ID: <20261113153801.360381944@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Aurich Zanettini Martins <christian.aurichzm@gmail.com>

[ Upstream commit 3ee50a2d76f278ea0ced45716a62730059283787 ]

Since commit 2a8513091d2f ("nvme-rdma: parallelize I/O queue allocation
and startup"), a reconnect that gets more I/O queues than before grows
the tag set before the new queues are set up. queue->ctrl is only set
by nvme_rdma_setup_io_queues(), so I/O submitted in between reaches
nvme_rdma_queue_rq() on a queue that was never allocated and
dereferences a NULL queue->ctrl:

  BUG: kernel NULL pointer dereference, address: 000000000000034c
  RIP: 0010:nvme_rdma_queue_rq+0x52/0xb90

Set queue->ctrl for every queue when allocating the controller. Such
requests are then requeued like on any other queue that is not live.

Fixes: 2a8513091d2f ("nvme-rdma: parallelize I/O queue allocation and startup")
Cc: stable@vger.kernel.org
Reviewed-by: Nilay Shroff <nilay@linux.ibm.com>
Signed-off-by: Christian Aurich Zanettini Martins <christian.aurichzm@gmail.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/rdma.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
index 5b9b540693b51..ff7b9e3796140 100644
--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@ -735,7 +735,6 @@ static int nvme_rdma_setup_io_queues(struct nvme_rdma_ctrl *ctrl,
 	for (i = 0; i < nr_queues; i++) {
 		struct nvme_rdma_queue *queue = &ctrl->queues[first + i];
 
-		queue->ctrl = ctrl;
 		queue->queue_size = queue_size;
 
 		ctxs[i].queue = queue;
@@ -798,7 +797,6 @@ static int nvme_rdma_configure_admin_queue(struct nvme_rdma_ctrl *ctrl,
 	bool pi_capable = false;
 	int error;
 
-	ctrl->queues[0].ctrl = ctrl;
 	ctrl->queues[0].queue_size = NVME_AQ_DEPTH;
 	error = nvme_rdma_alloc_queue(&ctrl->queues[0]);
 	if (error)
@@ -2284,7 +2282,7 @@ static struct nvme_rdma_ctrl *nvme_rdma_alloc_ctrl(struct device *dev,
 		struct nvmf_ctrl_options *opts)
 {
 	struct nvme_rdma_ctrl *ctrl;
-	int ret;
+	int ret, i;
 
 	ctrl = kzalloc_obj(*ctrl);
 	if (!ctrl)
@@ -2343,6 +2341,9 @@ static struct nvme_rdma_ctrl *nvme_rdma_alloc_ctrl(struct device *dev,
 	if (!ctrl->queues)
 		goto out_free_ctrl;
 
+	for (i = 0; i < ctrl->ctrl.queue_count; i++)
+		ctrl->queues[i].ctrl = ctrl;
+
 	ret = nvme_init_ctrl(&ctrl->ctrl, dev, &nvme_rdma_ctrl_ops,
 				0 /* no quirks, we're perfect! */);
 	if (ret)
-- 
2.53.0



