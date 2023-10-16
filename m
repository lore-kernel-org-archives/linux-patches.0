Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E871262AC
	for <patches@lists.linux.dev>; Mon, 16 Oct 2023 14:56:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z/in9ENu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C15A7C433C8;
	Mon, 16 Oct 2023 14:56:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1697468195;
	bh=6hO6qnad2BN6aw+VchGfCK6AH8nAKyDAiHC7Vzbj7CA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z/in9ENujWaNBRy6uAeBgdTA/IDgNWof+lB2YHsXk/KPbF9tuTXmsKvFTXHjPEfiS
	 f1THbh1OPSNRg/pE/4oYKHeJb4YOTg3589SOn7ilsHAJM0NrzJ+v/SArC6nLbNfa+u
	 ihh3r/U4FHLQ6YBZYXNIF9ac+kwO1pIoEhJpq3b0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rex Zhang <rex.zhang@intel.com>,
	Lijun Pan <lijun.pan@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Fenghua Yu <fenghua.yu@intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 182/191] dmaengine: idxd: use spin_lock_irqsave before wait_event_lock_irq
Date: Mon, 16 Oct 2023 10:42:47 +0200
Message-ID: <20231016084019.621080732@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231016084015.400031271@linuxfoundation.org>
References: <20231016084015.400031271@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rex Zhang <rex.zhang@intel.com>

[ Upstream commit c0409dd3d151f661e7e57b901a81a02565df163c ]

In idxd_cmd_exec(), wait_event_lock_irq() explicitly calls
spin_unlock_irq()/spin_lock_irq(). If the interrupt is on before entering
wait_event_lock_irq(), it will become off status after
wait_event_lock_irq() is called. Later, wait_for_completion() may go to
sleep but irq is disabled. The scenario is warned in might_sleep().

Fix it by using spin_lock_irqsave() instead of the primitive spin_lock()
to save the irq status before entering wait_event_lock_irq() and using
spin_unlock_irqrestore() instead of the primitive spin_unlock() to restore
the irq status before entering wait_for_completion().

Before the change:
idxd_cmd_exec() {
interrupt is on
spin_lock()                        // interrupt is on
	wait_event_lock_irq()
		spin_unlock_irq()  // interrupt is enabled
		...
		spin_lock_irq()    // interrupt is disabled
spin_unlock()                      // interrupt is still disabled
wait_for_completion()              // report "BUG: sleeping function
				   // called from invalid context...
				   // in_atomic() irqs_disabled()"
}

After applying spin_lock_irqsave():
idxd_cmd_exec() {
interrupt is on
spin_lock_irqsave()                // save the on state
				   // interrupt is disabled
	wait_event_lock_irq()
		spin_unlock_irq()  // interrupt is enabled
		...
		spin_lock_irq()    // interrupt is disabled
spin_unlock_irqrestore()           // interrupt is restored to on
wait_for_completion()              // No Call trace
}

Fixes: f9f4082dbc56 ("dmaengine: idxd: remove interrupt disable for cmd_lock")
Signed-off-by: Rex Zhang <rex.zhang@intel.com>
Signed-off-by: Lijun Pan <lijun.pan@intel.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Fenghua Yu <fenghua.yu@intel.com>
Link: https://lore.kernel.org/r/20230916060619.3744220-1-rex.zhang@intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/idxd/device.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/idxd/device.c b/drivers/dma/idxd/device.c
index 9a15f0d12c799..97b505f1115ab 100644
--- a/drivers/dma/idxd/device.c
+++ b/drivers/dma/idxd/device.c
@@ -492,6 +492,7 @@ static void idxd_cmd_exec(struct idxd_device *idxd, int cmd_code, u32 operand,
 	union idxd_command_reg cmd;
 	DECLARE_COMPLETION_ONSTACK(done);
 	u32 stat;
+	unsigned long flags;
 
 	if (idxd_device_is_halted(idxd)) {
 		dev_warn(&idxd->pdev->dev, "Device is HALTED!\n");
@@ -505,7 +506,7 @@ static void idxd_cmd_exec(struct idxd_device *idxd, int cmd_code, u32 operand,
 	cmd.operand = operand;
 	cmd.int_req = 1;
 
-	spin_lock(&idxd->cmd_lock);
+	spin_lock_irqsave(&idxd->cmd_lock, flags);
 	wait_event_lock_irq(idxd->cmd_waitq,
 			    !test_bit(IDXD_FLAG_CMD_RUNNING, &idxd->flags),
 			    idxd->cmd_lock);
@@ -522,7 +523,7 @@ static void idxd_cmd_exec(struct idxd_device *idxd, int cmd_code, u32 operand,
 	 * After command submitted, release lock and go to sleep until
 	 * the command completes via interrupt.
 	 */
-	spin_unlock(&idxd->cmd_lock);
+	spin_unlock_irqrestore(&idxd->cmd_lock, flags);
 	wait_for_completion(&done);
 	stat = ioread32(idxd->reg_base + IDXD_CMDSTS_OFFSET);
 	spin_lock(&idxd->cmd_lock);
-- 
2.40.1



