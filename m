Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68F97171A1
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:20:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D55ABC433EF;
	Mon, 22 May 2023 19:20:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684783242;
	bh=8vu415bm7cRMTv6jb4cllI2JnLcimu50U+uPxJ2hhJY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MAxX26YUiFTSYqiMMPFLdLu48vG9oleO9YzoeEYZIEpZIIVRExJahrl/Q9RfSjtD0
	 vg+5By1gpk+vks60YDsnnuyGyKwZJFXsanJJNARYtz6ad5ZiaQeGgftYoGTfM2EP2C
	 HPvuQNnBqF/mnDSRVDW+deEWh/IbH6QgNLSzYyzM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jimmy Assarsson <extja@kvaser.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.15 178/203] can: kvaser_pciefd: Call request_irq() before enabling interrupts
Date: Mon, 22 May 2023 20:10:02 +0100
Message-Id: <20230522190359.929510038@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190354.935300867@linuxfoundation.org>
References: <20230522190354.935300867@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jimmy Assarsson <extja@kvaser.com>

commit 84762d8da89d29ba842317eb842973e628c27391 upstream.

Make sure the interrupt handler is registered before enabling interrupts.

Fixes: 26ad340e582d ("can: kvaser_pciefd: Add driver for Kvaser PCIEcan devices")
Cc: stable@vger.kernel.org
Signed-off-by: Jimmy Assarsson <extja@kvaser.com>
Link: https://lore.kernel.org/r/20230516134318.104279-4-extja@kvaser.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/kvaser_pciefd.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/net/can/kvaser_pciefd.c
+++ b/drivers/net/can/kvaser_pciefd.c
@@ -1825,6 +1825,11 @@ static int kvaser_pciefd_probe(struct pc
 	if (err)
 		goto err_teardown_can_ctrls;
 
+	err = request_irq(pcie->pci->irq, kvaser_pciefd_irq_handler,
+			  IRQF_SHARED, KVASER_PCIEFD_DRV_NAME, pcie);
+	if (err)
+		goto err_teardown_can_ctrls;
+
 	iowrite32(KVASER_PCIEFD_SRB_IRQ_DPD0 | KVASER_PCIEFD_SRB_IRQ_DPD1,
 		  pcie->reg_base + KVASER_PCIEFD_SRB_IRQ_REG);
 
@@ -1845,11 +1850,6 @@ static int kvaser_pciefd_probe(struct pc
 	iowrite32(KVASER_PCIEFD_SRB_CMD_RDB1,
 		  pcie->reg_base + KVASER_PCIEFD_SRB_CMD_REG);
 
-	err = request_irq(pcie->pci->irq, kvaser_pciefd_irq_handler,
-			  IRQF_SHARED, KVASER_PCIEFD_DRV_NAME, pcie);
-	if (err)
-		goto err_teardown_can_ctrls;
-
 	err = kvaser_pciefd_reg_candev(pcie);
 	if (err)
 		goto err_free_irq;


