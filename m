Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 149085103A;
	Mon, 11 Dec 2023 18:49:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z7FVA1p2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EB30C433C7;
	Mon, 11 Dec 2023 18:49:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702320561;
	bh=HX/WtPygJxqdxTZsL6/J2gODpq8CHdAM38n8zzuFkFA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z7FVA1p2CC9y4an4Qn5aEjiueqftit4XE2l5H6fEdxEoBbsksDrpwOmfMqAOaVd5v
	 UXdU+FB5Hz3VDhIm/U2H3MhE/MQSXgttVu+8rFICT6MaqAH4jx0cBR1xcuu4uvcpcc
	 Xz5M3vpdUHU1pyF+UGnSa9c3fJZkbxbuRkxhKduw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shifeng Li <lishifeng1992@126.com>,
	Shiraz Saleem <shiraz.saleem@intel.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 079/194] RDMA/irdma: Fix UAF in irdma_sc_ccq_get_cqe_info()
Date: Mon, 11 Dec 2023 19:21:09 +0100
Message-ID: <20231211182040.016362506@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182036.606660304@linuxfoundation.org>
References: <20231211182036.606660304@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Shifeng Li <lishifeng1992@126.com>

[ Upstream commit 2b78832f50c4d711e161b166d7d8790968051546 ]

When removing the irdma driver or unplugging its aux device, the ccq
queue is released before destorying the cqp_cmpl_wq queue.
But in the window, there may still be completion events for wqes. That
will cause a UAF in irdma_sc_ccq_get_cqe_info().

[34693.333191] BUG: KASAN: use-after-free in irdma_sc_ccq_get_cqe_info+0x82f/0x8c0 [irdma]
[34693.333194] Read of size 8 at addr ffff889097f80818 by task kworker/u67:1/26327
[34693.333194]
[34693.333199] CPU: 9 PID: 26327 Comm: kworker/u67:1 Kdump: loaded Tainted: G           O     --------- -t - 4.18.0 #1
[34693.333200] Hardware name: SANGFOR Inspur/NULL, BIOS 4.1.13 08/01/2016
[34693.333211] Workqueue: cqp_cmpl_wq cqp_compl_worker [irdma]
[34693.333213] Call Trace:
[34693.333220]  dump_stack+0x71/0xab
[34693.333226]  print_address_description+0x6b/0x290
[34693.333238]  ? irdma_sc_ccq_get_cqe_info+0x82f/0x8c0 [irdma]
[34693.333240]  kasan_report+0x14a/0x2b0
[34693.333251]  irdma_sc_ccq_get_cqe_info+0x82f/0x8c0 [irdma]
[34693.333264]  ? irdma_free_cqp_request+0x151/0x1e0 [irdma]
[34693.333274]  irdma_cqp_ce_handler+0x1fb/0x3b0 [irdma]
[34693.333285]  ? irdma_ctrl_init_hw+0x2c20/0x2c20 [irdma]
[34693.333290]  ? __schedule+0x836/0x1570
[34693.333293]  ? strscpy+0x83/0x180
[34693.333296]  process_one_work+0x56a/0x11f0
[34693.333298]  worker_thread+0x8f/0xf40
[34693.333301]  ? __kthread_parkme+0x78/0xf0
[34693.333303]  ? rescuer_thread+0xc50/0xc50
[34693.333305]  kthread+0x2a0/0x390
[34693.333308]  ? kthread_destroy_worker+0x90/0x90
[34693.333310]  ret_from_fork+0x1f/0x40

Fixes: 44d9e52977a1 ("RDMA/irdma: Implement device initialization definitions")
Signed-off-by: Shifeng Li <lishifeng1992@126.com>
Link: https://lore.kernel.org/r/20231121101236.581694-1-lishifeng1992@126.com
Acked-by: Shiraz Saleem <shiraz.saleem@intel.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/irdma/hw.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/irdma/hw.c b/drivers/infiniband/hw/irdma/hw.c
index 8aa507e87df37..9399d82560c92 100644
--- a/drivers/infiniband/hw/irdma/hw.c
+++ b/drivers/infiniband/hw/irdma/hw.c
@@ -578,9 +578,6 @@ static void irdma_destroy_cqp(struct irdma_pci_f *rf)
 	struct irdma_cqp *cqp = &rf->cqp;
 	int status = 0;
 
-	if (rf->cqp_cmpl_wq)
-		destroy_workqueue(rf->cqp_cmpl_wq);
-
 	status = irdma_sc_cqp_destroy(dev->cqp);
 	if (status)
 		ibdev_dbg(to_ibdev(dev), "ERR: Destroy CQP failed %d\n", status);
@@ -745,6 +742,9 @@ static void irdma_destroy_ccq(struct irdma_pci_f *rf)
 	struct irdma_ccq *ccq = &rf->ccq;
 	int status = 0;
 
+	if (rf->cqp_cmpl_wq)
+		destroy_workqueue(rf->cqp_cmpl_wq);
+
 	if (!rf->reset)
 		status = irdma_sc_ccq_destroy(dev->ccq, 0, true);
 	if (status)
-- 
2.42.0



