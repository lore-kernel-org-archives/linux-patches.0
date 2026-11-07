Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065520;
	b=4XEw6UrzPW0uHx47Ds+5Xzx8yf50WKO0lYCNf6DL7Sp1iXA7xogjURb43dURH5Z0H624
	 ZFAEMk9EQLPIZeXO7B4aNaO6veYf6jVJWqQT34f3T4N5iLTw89SgjudP+PZxZQLyfPlMm
	 sx5vHM3oWZeQegKeMV+QoGRKH5NU0Ng1yRYiKfOY0splN6ornrrOdJPR8EkPJvourFHuN
	 NuL07b8NK40ABmKRXbe5XN4N8Kx6bq+tF2yd5LAzp1z65WIrsPwJIBOSOLc3+GzT5sq+8
	 wuQSmjf/rUojKtmOTENc/kJLHJ5PxWXGsBuO7/4XscwCN3uMaudlKT+83+4YUdRM2pg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065520;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IlD22tehWBEfEqCwkL06NJi5uEz41tvIXGuIapWWfx4=;
	b=4BLOfevvosj2Yjlc/CqLfImRSBjmRF6VK/R1ODoBR90jUe6eyv/IQ7yQj/gnsJX69jJn
	 TjntoaaRBwxORc6F0UrnuMlL/wVPhrNOMc2rw8wzhUlbvjSamq2e2ylshRescKsm30Jo+
	 59IF+3ej60cK9b2vhV7IMTjSRvI/Cvm9L2ww/N+b9US7h3rsJ/KXD2R9kFF7oubCCN50H
	 /FGO7JWwI4q7miF41Zue/VEfYka33P4sRi1aE5yV2M36opTFZvWkTMfLV5+XCkOxiizO/
	 1R6ednFQ73BSOpv0uwl1oLS+srOKuhNN37stnHf70BtVe8sNvUOwd/ppB5TUnu8wHgg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K9+PV1dT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CD01606A32C;
	Sat,  7 Nov 2026 15:32:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K9+PV1dT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 079621F0089F;
	Sat,  7 Nov 2026 15:31:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065520;
	bh=IlD22tehWBEfEqCwkL06NJi5uEz41tvIXGuIapWWfx4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K9+PV1dT9TyAjv+ojG8/99QqN3ykqiWQyIeDv4yBzWbSyyymLfysmNCLdbIob4+Ux
	 pmDJX8t/eW/lr+WlCCFw11fNSXNt5qSGD0cuMPldxBOEW8RPx5Ra1htZbSW0l47Io8
	 6ZArMS0u/UqtgNh4euSRsqvRjg495AATRTySQMdY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	co+e015e82956da641b@bugs.sh,
	Christoph Hellwig <hch@lst.de>,
	Weiming Shi <bestswngs@gmail.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1201/1257] nvmet-rdma: reject short connection requests
Date: Sat,  7 Nov 2026 08:58:17 -0500
Message-ID: <20261107135012.525243589@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Weiming Shi <bestswngs@gmail.com>

[ Upstream commit 635e760169a87abf03874cd4636cd91b580cb427 ]

nvmet_rdma_parse_cm_connect_req() treats RDMA-CM private data as a
struct nvme_rdma_cm_req but accepts any nonzero private_data_len.  The
iWARP path allocates exactly the peer-provided length, so a six-byte MPA
request reaches the parser and the hsqsize load reads two bytes past the
allocation.

Require the complete request structure before reading any of its fields.
The decoded KASAN report is:

  BUG: KASAN: slab-out-of-bounds in nvmet_rdma_cm_handler
    (drivers/nvme/target/rdma.c:1427 drivers/nvme/target/rdma.c:1475
     drivers/nvme/target/rdma.c:1614 drivers/nvme/target/rdma.c:1814)
  Read of size 2 at addr ff1100010459d366 by task kworker/u16:1/41
  Workqueue: iw_cm_wq cm_work_handler
  Call Trace:
   <TASK>
   dump_stack_lvl (lib/dump_stack.c:94 lib/dump_stack.c:120)
   print_report (mm/kasan/report.c:378 mm/kasan/report.c:482)
   kasan_report (mm/kasan/report.c:595)
   nvmet_rdma_cm_handler
    (drivers/nvme/target/rdma.c:1427 drivers/nvme/target/rdma.c:1475
     drivers/nvme/target/rdma.c:1614 drivers/nvme/target/rdma.c:1814)
   cma_cm_event_handler (drivers/infiniband/core/cma.c:2181)
   iw_conn_req_handler (drivers/infiniband/core/cma.c:2640)
   cm_work_handler
    (drivers/infiniband/core/cm.c:2502
     drivers/infiniband/core/cm.c:3858)
   process_one_work (kernel/workqueue.c:3396)
   worker_thread (kernel/workqueue.c:3479 kernel/workqueue.c:3560)
   kthread (kernel/kthread.c:436)
   ret_from_fork (arch/x86/kernel/process.c:158)
   ret_from_fork_asm (arch/x86/entry/entry_64.S:245)
   </TASK>

  Allocated by task 12:
   __kasan_kmalloc (mm/kasan/common.c:398 mm/kasan/common.c:415)
   __kmalloc_node_track_caller_noprof
    (mm/slub.c:5414 mm/slub.c:5545)
   kmemdup_noprof (mm/util.c:138)
   cm_event_handler
    (drivers/infiniband/core/iwcm.c:194
     drivers/infiniband/core/iwcm.c:1076)
   siw_cm_upcall (drivers/infiniband/sw/siw/siw_cm.c:408)
   siw_proc_mpareq (drivers/infiniband/sw/siw/siw_cm.c:750)
   siw_cm_work_handler (drivers/infiniband/sw/siw/siw_cm.c:1086)

  The buggy address is located 0 bytes to the right of
  allocated 6-byte region [ff1100010459d360, ff1100010459d366)

Cc: stable@vger.kernel.org
Fixes: 8f000cac6e7a ("nvmet-rdma: add a NVMe over Fabrics RDMA target driver")
Reported-by: <co+e015e82956da641b@bugs.sh>
Assisted-by: LLM
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/rdma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvme/target/rdma.c b/drivers/nvme/target/rdma.c
index ffa1e172c259b..075ab58d8c884 100644
--- a/drivers/nvme/target/rdma.c
+++ b/drivers/nvme/target/rdma.c
@@ -1412,7 +1412,7 @@ nvmet_rdma_parse_cm_connect_req(struct rdma_conn_param *conn,
 	struct nvme_rdma_cm_req *req;
 
 	req = (struct nvme_rdma_cm_req *)conn->private_data;
-	if (!req || conn->private_data_len == 0)
+	if (!req || conn->private_data_len < sizeof(*req))
 		return NVME_RDMA_CM_INVALID_LEN;
 
 	if (le16_to_cpu(req->recfmt) != NVME_RDMA_CM_FMT_1_0)
-- 
2.53.0



