Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54A00DF40
	for <patches@lists.linux.dev>; Mon, 15 May 2023 16:38:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC6D3C433D2;
	Mon, 15 May 2023 16:38:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684168713;
	bh=G7W4eoBKhhIOADPWKjo/ZrM8cFKiCmHtTGPXaeBZKcc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gc09sUuoA0YR2Jxm4L0idFZVS5XMWQU4sDYkpuRtdt6Eq4XspNa1T3aIgjrU+nL7D
	 XTKRHD0vd/X9DfStqXLFwMiex7LMgm9h6V7Jy5nxGB4DqjccJ1sJfC/ChjI4FdyBRc
	 jgj6n1sDwv1u2NQGRUeCr7RL4TY7vCsndafM9uns=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Reid Tonking <reidt@ti.com>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Tony Lindgren <tony@atomide.com>,
	Wolfram Sang <wsa@kernel.org>
Subject: [PATCH 4.19 018/191] i2c: omap: Fix standard mode false ACK readings
Date: Mon, 15 May 2023 18:24:15 +0200
Message-Id: <20230515161707.860435453@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161707.203549282@linuxfoundation.org>
References: <20230515161707.203549282@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Reid Tonking <reidt@ti.com>

commit c770657bd2611b077ec1e7b1fe6aa92f249399bd upstream.

Using standard mode, rare false ACK responses were appearing with
i2cdetect tool. This was happening due to NACK interrupt triggering
ISR thread before register access interrupt was ready. Removing the
NACK interrupt's ability to trigger ISR thread lets register access
ready interrupt do this instead.

Cc: <stable@vger.kernel.org> # v3.7+
Fixes: 3b2f8f82dad7 ("i2c: omap: switch to threaded IRQ support")
Signed-off-by: Reid Tonking <reidt@ti.com>
Acked-by: Vignesh Raghavendra <vigneshr@ti.com>
Reviewed-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-omap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/i2c/busses/i2c-omap.c
+++ b/drivers/i2c/busses/i2c-omap.c
@@ -1027,7 +1027,7 @@ omap_i2c_isr(int irq, void *dev_id)
 	u16 stat;
 
 	stat = omap_i2c_read_reg(omap, OMAP_I2C_STAT_REG);
-	mask = omap_i2c_read_reg(omap, OMAP_I2C_IE_REG);
+	mask = omap_i2c_read_reg(omap, OMAP_I2C_IE_REG) & ~OMAP_I2C_STAT_NACK;
 
 	if (stat & mask)
 		ret = IRQ_WAKE_THREAD;


