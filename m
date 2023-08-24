Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 578151119B
	for <patches@lists.linux.dev>; Thu, 24 Aug 2023 14:54:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D002FC433C7;
	Thu, 24 Aug 2023 14:54:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692888868;
	bh=FCr8xMNc3eqSURdYKbyAEF5ViIltiMt6rSCPyUt2Dgk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VFvPaZx59QwQ3Bpdblh2cadz/hMTk34RLo/rPQtnKg3ho7a3FVlJSE8RVZPDvTKQc
	 F9ktHa3ncul9E3YQ/mVi6ubj3Rs8rhiQAzu8RwaHBHXYSs5rVk/pWVfKHwfMLyMpP9
	 tKwlfKwK5q9iuhDyDo6C3+K9FxStjqdVjoZJl1q8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengfeng Ye <dg573847474@gmail.com>,
	Ray Jui <ray.jui@broadcom.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Wolfram Sang <wsa@kernel.org>
Subject: [PATCH 5.15 070/139] i2c: bcm-iproc: Fix bcm_iproc_i2c_isr deadlock issue
Date: Thu, 24 Aug 2023 16:49:53 +0200
Message-ID: <20230824145026.706664452@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230824145023.559380953@linuxfoundation.org>
References: <20230824145023.559380953@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Chengfeng Ye <dg573847474@gmail.com>

commit 4caf4cb1eaed469742ef719f2cc024b1ec3fa9e6 upstream.

iproc_i2c_rd_reg() and iproc_i2c_wr_reg() are called from both
interrupt context (e.g. bcm_iproc_i2c_isr) and process context
(e.g. bcm_iproc_i2c_suspend). Therefore, interrupts should be
disabled to avoid potential deadlock. To prevent this scenario,
use spin_lock_irqsave().

Fixes: 9a1038728037 ("i2c: iproc: add NIC I2C support")
Signed-off-by: Chengfeng Ye <dg573847474@gmail.com>
Acked-by: Ray Jui <ray.jui@broadcom.com>
Reviewed-by: Andi Shyti <andi.shyti@kernel.org>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-bcm-iproc.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/drivers/i2c/busses/i2c-bcm-iproc.c
+++ b/drivers/i2c/busses/i2c-bcm-iproc.c
@@ -243,13 +243,14 @@ static inline u32 iproc_i2c_rd_reg(struc
 				   u32 offset)
 {
 	u32 val;
+	unsigned long flags;
 
 	if (iproc_i2c->idm_base) {
-		spin_lock(&iproc_i2c->idm_lock);
+		spin_lock_irqsave(&iproc_i2c->idm_lock, flags);
 		writel(iproc_i2c->ape_addr_mask,
 		       iproc_i2c->idm_base + IDM_CTRL_DIRECT_OFFSET);
 		val = readl(iproc_i2c->base + offset);
-		spin_unlock(&iproc_i2c->idm_lock);
+		spin_unlock_irqrestore(&iproc_i2c->idm_lock, flags);
 	} else {
 		val = readl(iproc_i2c->base + offset);
 	}
@@ -260,12 +261,14 @@ static inline u32 iproc_i2c_rd_reg(struc
 static inline void iproc_i2c_wr_reg(struct bcm_iproc_i2c_dev *iproc_i2c,
 				    u32 offset, u32 val)
 {
+	unsigned long flags;
+
 	if (iproc_i2c->idm_base) {
-		spin_lock(&iproc_i2c->idm_lock);
+		spin_lock_irqsave(&iproc_i2c->idm_lock, flags);
 		writel(iproc_i2c->ape_addr_mask,
 		       iproc_i2c->idm_base + IDM_CTRL_DIRECT_OFFSET);
 		writel(val, iproc_i2c->base + offset);
-		spin_unlock(&iproc_i2c->idm_lock);
+		spin_unlock_irqrestore(&iproc_i2c->idm_lock, flags);
 	} else {
 		writel(val, iproc_i2c->base + offset);
 	}


