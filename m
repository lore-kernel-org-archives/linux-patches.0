Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAB585102A;
	Mon, 11 Dec 2023 18:49:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gm00eMV/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01F6FC433C7;
	Mon, 11 Dec 2023 18:49:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702320580;
	bh=LqJyPARUB5vi+WEeVVfo6prJzZEWCKTWDvbiBpFuqYs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gm00eMV/bHRmX9KZzpAdUQDM3xgq+VBAoLmODMKY8ihOQq+vrbKcnMcFPCjH6UY/W
	 UXGJSc1vm39u9ykl4ykQkk2TzvHlN2ldfLAuU60X0u5xBkLkBY4Xa6i0k8glfqQA1t
	 GfQn/yLJnYwNodJgsAqg/YKzL7fL8hFWaN7egQZ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Ismail, Mustafa" <mustafa.ismail@intel.com>,
	Shifeng Li <lishifeng@sangfor.com.cn>,
	Shiraz Saleem <shiraz.saleem@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 085/194] RDMA/irdma: Avoid free the non-cqp_request scratch
Date: Mon, 11 Dec 2023 19:21:15 +0100
Message-ID: <20231211182040.271004235@linuxfoundation.org>
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

From: Shifeng Li <lishifeng@sangfor.com.cn>

[ Upstream commit e3e82fcb79eeb3f1a88a89f676831773caff514a ]

When creating ceq_0 during probing irdma, cqp.sc_cqp will be sent as a
cqp_request to cqp->sc_cqp.sq_ring. If the request is pending when
removing the irdma driver or unplugging its aux device, cqp.sc_cqp will be
dereferenced as wrong struct in irdma_free_pending_cqp_request().

  PID: 3669   TASK: ffff88aef892c000  CPU: 28  COMMAND: "kworker/28:0"
   #0 [fffffe0000549e38] crash_nmi_callback at ffffffff810e3a34
   #1 [fffffe0000549e40] nmi_handle at ffffffff810788b2
   #2 [fffffe0000549ea0] default_do_nmi at ffffffff8107938f
   #3 [fffffe0000549eb8] do_nmi at ffffffff81079582
   #4 [fffffe0000549ef0] end_repeat_nmi at ffffffff82e016b4
      [exception RIP: native_queued_spin_lock_slowpath+1291]
      RIP: ffffffff8127e72b  RSP: ffff88aa841ef778  RFLAGS: 00000046
      RAX: 0000000000000000  RBX: ffff88b01f849700  RCX: ffffffff8127e47e
      RDX: 0000000000000000  RSI: 0000000000000004  RDI: ffffffff83857ec0
      RBP: ffff88afe3e4efc8   R8: ffffed15fc7c9dfa   R9: ffffed15fc7c9dfa
      R10: 0000000000000001  R11: ffffed15fc7c9df9  R12: 0000000000740000
      R13: ffff88b01f849708  R14: 0000000000000003  R15: ffffed1603f092e1
      ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0000
  -- <NMI exception stack> --
   #5 [ffff88aa841ef778] native_queued_spin_lock_slowpath at ffffffff8127e72b
   #6 [ffff88aa841ef7b0] _raw_spin_lock_irqsave at ffffffff82c22aa4
   #7 [ffff88aa841ef7c8] __wake_up_common_lock at ffffffff81257363
   #8 [ffff88aa841ef888] irdma_free_pending_cqp_request at ffffffffa0ba12cc [irdma]
   #9 [ffff88aa841ef958] irdma_cleanup_pending_cqp_op at ffffffffa0ba1469 [irdma]
   #10 [ffff88aa841ef9c0] irdma_ctrl_deinit_hw at ffffffffa0b2989f [irdma]
   #11 [ffff88aa841efa28] irdma_remove at ffffffffa0b252df [irdma]
   #12 [ffff88aa841efae8] auxiliary_bus_remove at ffffffff8219afdb
   #13 [ffff88aa841efb00] device_release_driver_internal at ffffffff821882e6
   #14 [ffff88aa841efb38] bus_remove_device at ffffffff82184278
   #15 [ffff88aa841efb88] device_del at ffffffff82179d23
   #16 [ffff88aa841efc48] ice_unplug_aux_dev at ffffffffa0eb1c14 [ice]
   #17 [ffff88aa841efc68] ice_service_task at ffffffffa0d88201 [ice]
   #18 [ffff88aa841efde8] process_one_work at ffffffff811c589a
   #19 [ffff88aa841efe60] worker_thread at ffffffff811c71ff
   #20 [ffff88aa841eff10] kthread at ffffffff811d87a0
   #21 [ffff88aa841eff50] ret_from_fork at ffffffff82e0022f

Fixes: 44d9e52977a1 ("RDMA/irdma: Implement device initialization definitions")
Link: https://lore.kernel.org/r/20231130081415.891006-1-lishifeng@sangfor.com.cn
Suggested-by: "Ismail, Mustafa" <mustafa.ismail@intel.com>
Signed-off-by: Shifeng Li <lishifeng@sangfor.com.cn>
Reviewed-by: Shiraz Saleem <shiraz.saleem@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/irdma/hw.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/irdma/hw.c b/drivers/infiniband/hw/irdma/hw.c
index 9399d82560c92..311a1138e838d 100644
--- a/drivers/infiniband/hw/irdma/hw.c
+++ b/drivers/infiniband/hw/irdma/hw.c
@@ -1170,7 +1170,6 @@ static int irdma_create_ceq(struct irdma_pci_f *rf, struct irdma_ceq *iwceq,
 	int status;
 	struct irdma_ceq_init_info info = {};
 	struct irdma_sc_dev *dev = &rf->sc_dev;
-	u64 scratch;
 	u32 ceq_size;
 
 	info.ceq_id = ceq_id;
@@ -1191,14 +1190,13 @@ static int irdma_create_ceq(struct irdma_pci_f *rf, struct irdma_ceq *iwceq,
 	iwceq->sc_ceq.ceq_id = ceq_id;
 	info.dev = dev;
 	info.vsi = vsi;
-	scratch = (uintptr_t)&rf->cqp.sc_cqp;
 	status = irdma_sc_ceq_init(&iwceq->sc_ceq, &info);
 	if (!status) {
 		if (dev->ceq_valid)
 			status = irdma_cqp_ceq_cmd(&rf->sc_dev, &iwceq->sc_ceq,
 						   IRDMA_OP_CEQ_CREATE);
 		else
-			status = irdma_sc_cceq_create(&iwceq->sc_ceq, scratch);
+			status = irdma_sc_cceq_create(&iwceq->sc_ceq, 0);
 	}
 
 	if (status) {
-- 
2.42.0



