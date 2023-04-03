Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 653BE569E
	for <patches@lists.linux.dev>; Mon,  3 Apr 2023 14:19:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC673C433A4;
	Mon,  3 Apr 2023 14:19:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680531575;
	bh=xlUyzh/F61W24kZbGAUNhuT5gpxt5v1aBWAEw9XlWKw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ICXMcqM4y3TxixDJ47N8Z0U/MTugZLY7WISEDdeb1+qUQOQbIhIvnpwJgcr42sHSw
	 aOriFPXVEIWtcp4RuUQ+9nFU4NZ9ngf1LOu1l5nfz2yAJpsqneJuTLhhj3qttCS7+f
	 GzQrgqEa9+SqTKJrafOXY74ontRiVace+k2EGt/Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Emanuele Ghidoli <emanuele.ghidoli@toradex.com>,
	Wolfram Sang <wsa@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 007/104] i2c: imx-lpi2c: check only for enabled interrupt flags
Date: Mon,  3 Apr 2023 16:07:59 +0200
Message-Id: <20230403140404.387607329@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140403.549815164@linuxfoundation.org>
References: <20230403140403.549815164@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alexander Stein <alexander.stein@ew.tq-group.com>

[ Upstream commit 1c7885004567e8951d65a983be095f254dd20bef ]

When reading from I2C, the Tx watermark is set to 0. Unfortunately the
TDF (transmit data flag) is enabled when Tx FIFO entries is equal or less
than watermark. So it is set in every case, hence the reset default of 1.
This results in the MSR_RDF _and_ MSR_TDF flags to be set thus trying
to send Tx data on a read message.
Mask the IRQ status to filter for wanted flags only.

Fixes: a55fa9d0e42e ("i2c: imx-lpi2c: add low power i2c bus driver")
Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Tested-by: Emanuele Ghidoli <emanuele.ghidoli@toradex.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-imx-lpi2c.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/i2c/busses/i2c-imx-lpi2c.c b/drivers/i2c/busses/i2c-imx-lpi2c.c
index a0d045c1bc9e6..13c17afe7102e 100644
--- a/drivers/i2c/busses/i2c-imx-lpi2c.c
+++ b/drivers/i2c/busses/i2c-imx-lpi2c.c
@@ -508,10 +508,14 @@ static int lpi2c_imx_xfer(struct i2c_adapter *adapter,
 static irqreturn_t lpi2c_imx_isr(int irq, void *dev_id)
 {
 	struct lpi2c_imx_struct *lpi2c_imx = dev_id;
+	unsigned int enabled;
 	unsigned int temp;
 
+	enabled = readl(lpi2c_imx->base + LPI2C_MIER);
+
 	lpi2c_imx_intctrl(lpi2c_imx, 0);
 	temp = readl(lpi2c_imx->base + LPI2C_MSR);
+	temp &= enabled;
 
 	if (temp & MSR_RDF)
 		lpi2c_imx_read_rxfifo(lpi2c_imx);
-- 
2.39.2



