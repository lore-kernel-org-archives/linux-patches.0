Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60E23364A4;
	Fri, 24 Nov 2023 18:41:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y6+nWa68"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0D06C433C7;
	Fri, 24 Nov 2023 18:41:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700851274;
	bh=mqtX4fftWtnsPyPHQqAXSdf1PBkaETJ/yd7hAVfDhao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y6+nWa68l52YHa3YyYh2DhYiJYpQIIQQZQewBzp2BCHwuG+yZ+Ef+6SyLVG+X3GzQ
	 aQKL6gKmUm/wa9j07Vy3sWPdd06bWweyGJh0ckPJMeB3sr8R+CZ+4GZxKclB3Hc//x
	 8ZXSHLfS2C7esPFnVW7i91dk+JPNk/9RTI/KFtZA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 6.5 357/491] i3c: master: svc: fix race condition in ibi work thread
Date: Fri, 24 Nov 2023 17:49:53 +0000
Message-ID: <20231124172035.305118139@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172024.664207345@linuxfoundation.org>
References: <20231124172024.664207345@linuxfoundation.org>
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

From: Frank Li <Frank.Li@nxp.com>

commit 6bf3fc268183816856c96b8794cd66146bc27b35 upstream.

The ibi work thread operates asynchronously with other transfers, such as
svc_i3c_master_priv_xfers(). Introduce mutex protection to ensure the
completion of the entire i3c/i2c transaction.

Fixes: dd3c52846d59 ("i3c: master: svc: Add Silvaco I3C master driver")
Cc:  <stable@vger.kernel.org>
Reviewed-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Link: https://lore.kernel.org/r/20231023161658.3890811-2-Frank.Li@nxp.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i3c/master/svc-i3c-master.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/drivers/i3c/master/svc-i3c-master.c
+++ b/drivers/i3c/master/svc-i3c-master.c
@@ -175,6 +175,7 @@ struct svc_i3c_regs_save {
  * @ibi.slots: Available IBI slots
  * @ibi.tbq_slot: To be queued IBI slot
  * @ibi.lock: IBI lock
+ * @lock: Transfer lock, protect between IBI work thread and callbacks from master
  */
 struct svc_i3c_master {
 	struct i3c_master_controller base;
@@ -203,6 +204,7 @@ struct svc_i3c_master {
 		/* Prevent races within IBI handlers */
 		spinlock_t lock;
 	} ibi;
+	struct mutex lock;
 };
 
 /**
@@ -384,6 +386,7 @@ static void svc_i3c_master_ibi_work(stru
 	u32 status, val;
 	int ret;
 
+	mutex_lock(&master->lock);
 	/* Acknowledge the incoming interrupt with the AUTOIBI mechanism */
 	writel(SVC_I3C_MCTRL_REQUEST_AUTO_IBI |
 	       SVC_I3C_MCTRL_IBIRESP_AUTO,
@@ -460,6 +463,7 @@ static void svc_i3c_master_ibi_work(stru
 
 reenable_ibis:
 	svc_i3c_master_enable_interrupts(master, SVC_I3C_MINT_SLVSTART);
+	mutex_unlock(&master->lock);
 }
 
 static irqreturn_t svc_i3c_master_irq_handler(int irq, void *dev_id)
@@ -1204,9 +1208,11 @@ static int svc_i3c_master_send_bdcast_cc
 	cmd->read_len = 0;
 	cmd->continued = false;
 
+	mutex_lock(&master->lock);
 	svc_i3c_master_enqueue_xfer(master, xfer);
 	if (!wait_for_completion_timeout(&xfer->comp, msecs_to_jiffies(1000)))
 		svc_i3c_master_dequeue_xfer(master, xfer);
+	mutex_unlock(&master->lock);
 
 	ret = xfer->ret;
 	kfree(buf);
@@ -1250,9 +1256,11 @@ static int svc_i3c_master_send_direct_cc
 	cmd->read_len = read_len;
 	cmd->continued = false;
 
+	mutex_lock(&master->lock);
 	svc_i3c_master_enqueue_xfer(master, xfer);
 	if (!wait_for_completion_timeout(&xfer->comp, msecs_to_jiffies(1000)))
 		svc_i3c_master_dequeue_xfer(master, xfer);
+	mutex_unlock(&master->lock);
 
 	if (cmd->read_len != xfer_len)
 		ccc->dests[0].payload.len = cmd->read_len;
@@ -1309,9 +1317,11 @@ static int svc_i3c_master_priv_xfers(str
 		cmd->continued = (i + 1) < nxfers;
 	}
 
+	mutex_lock(&master->lock);
 	svc_i3c_master_enqueue_xfer(master, xfer);
 	if (!wait_for_completion_timeout(&xfer->comp, msecs_to_jiffies(1000)))
 		svc_i3c_master_dequeue_xfer(master, xfer);
+	mutex_unlock(&master->lock);
 
 	ret = xfer->ret;
 	svc_i3c_master_free_xfer(xfer);
@@ -1347,9 +1357,11 @@ static int svc_i3c_master_i2c_xfers(stru
 		cmd->continued = (i + 1 < nxfers);
 	}
 
+	mutex_lock(&master->lock);
 	svc_i3c_master_enqueue_xfer(master, xfer);
 	if (!wait_for_completion_timeout(&xfer->comp, msecs_to_jiffies(1000)))
 		svc_i3c_master_dequeue_xfer(master, xfer);
+	mutex_unlock(&master->lock);
 
 	ret = xfer->ret;
 	svc_i3c_master_free_xfer(xfer);
@@ -1540,6 +1552,8 @@ static int svc_i3c_master_probe(struct p
 
 	INIT_WORK(&master->hj_work, svc_i3c_master_hj_work);
 	INIT_WORK(&master->ibi_work, svc_i3c_master_ibi_work);
+	mutex_init(&master->lock);
+
 	ret = devm_request_irq(dev, master->irq, svc_i3c_master_irq_handler,
 			       IRQF_NO_SUSPEND, "svc-i3c-irq", master);
 	if (ret)


