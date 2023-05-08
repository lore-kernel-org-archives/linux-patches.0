Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0A441094C
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:58:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F994C433D2;
	Mon,  8 May 2023 10:58:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683543520;
	bh=vaDW+pMskZ06wVM0nSA+WW0HTIbPuEn+CC9mZ315wMY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ECfYZHkJmH7IOQ/AsohVeffMnCRaIxPW515e58Jsvee7A51gEGomRORzk/LDFRgBz
	 HGhXBH5ikCxUO7YLGlrSdqr2H18hVhEEMa+NNN0aAy9XJrYMkUesTLxQNmlHNANgdj
	 yrAil4tgKuGItAnRk61ypIqGUiIQuPh++K/8ELxY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Reid Tonking <reidt@ti.com>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Tony Lindgren <tony@atomide.com>,
	Wolfram Sang <wsa@kernel.org>
Subject: [PATCH 6.3 078/694] i2c: omap: Fix standard mode false ACK readings
Date: Mon,  8 May 2023 11:38:33 +0200
Message-Id: <20230508094435.068507067@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094432.603705160@linuxfoundation.org>
References: <20230508094432.603705160@linuxfoundation.org>
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
@@ -1058,7 +1058,7 @@ omap_i2c_isr(int irq, void *dev_id)
 	u16 stat;
 
 	stat = omap_i2c_read_reg(omap, OMAP_I2C_STAT_REG);
-	mask = omap_i2c_read_reg(omap, OMAP_I2C_IE_REG);
+	mask = omap_i2c_read_reg(omap, OMAP_I2C_IE_REG) & ~OMAP_I2C_STAT_NACK;
 
 	if (stat & mask)
 		ret = IRQ_WAKE_THREAD;


