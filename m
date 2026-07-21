Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B864B22B8DF;
	Tue, 21 Jul 2026 18:18:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657924; cv=none; b=ozwtMsoPWwKZrJNqxnyKBDAcU3jdlrXCpapZZnevlF78vAp7pheCom5xePSvXRqBKN/MtNSPm1Ex/0gjgmmwqYgBwW/NQq9Gx4BT8k0D9/JiXQ2PPqfYg5a1WMJYWyOnh8C6G1ksNRDYoRZknq2q8XmjKLFoTuC56P781Ps+ZEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657924; c=relaxed/simple;
	bh=AnFWESZW7f+SPghJhIvWtsTnaXrT3ss3AwpywnHdNuQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=plYm9GWASm5+8XE4TjDcMIr/D0Bre9ghQEzHMkXCXqkv/dL4Le5dHwfBwrNNGYI8g/lUapggtoz2KlIWUHgpUVeKgVE6IrUNn3QyPe7751ENXWtPBW2lL0NPDW08XXLP1KNgolmA7GF5RsI48N3YM8Sz3TQz1K78jjWh55l/XZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rsk1qa81; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rsk1qa81"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAAB61F000E9;
	Tue, 21 Jul 2026 18:18:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657923;
	bh=l35mG1/sv3YCy31g2c9hx1KVvOcihFCGUY2+b7631+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Rsk1qa81aztMgFOH3Gm9z1U9kTHqPUeVEYNH6t/kB5ohKOgQRZS9zPYMywjNZGnD0
	 L4QR3U44xiYe6OtZPJN9LEIMui1CxA5XMfEZ33CizyKt3HnEipJpW75qiyvPlJ3QwL
	 sPnHRxnNQ181zSfj+x7991mFl1jF/NpPCKMXtbZI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0949/1611] spi: sh-msiof: abort transfers when reset times out
Date: Tue, 21 Jul 2026 17:17:45 +0200
Message-ID: <20260721152536.736607003@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 6dbaa4d288432c697cea47028480481b8b29bd6a ]

sh_msiof_spi_reset_regs() asserts TX/RX reset and polls until the reset
bits clear, but the poll result is ignored. sh_msiof_transfer_one() can
therefore continue programming a transfer after the controller did not
leave reset.

Return the reset poll result from the helper and abort the transfer on
timeout, matching the existing transfer path's error-return style.

Fixes: fedd6940682a ("spi: sh-msiof: Add reset of registers before starting transfer")
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260623135834.55442-1-pengpeng@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-sh-msiof.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/spi/spi-sh-msiof.c b/drivers/spi/spi-sh-msiof.c
index 7f4135a3bda23c..a4ae96290aa240 100644
--- a/drivers/spi/spi-sh-msiof.c
+++ b/drivers/spi/spi-sh-msiof.c
@@ -114,7 +114,7 @@ static irqreturn_t sh_msiof_spi_irq(int irq, void *data)
 	return IRQ_HANDLED;
 }
 
-static void sh_msiof_spi_reset_regs(struct sh_msiof_spi_priv *p)
+static int sh_msiof_spi_reset_regs(struct sh_msiof_spi_priv *p)
 {
 	u32 mask = SICTR_TXRST | SICTR_RXRST;
 	u32 data;
@@ -123,8 +123,8 @@ static void sh_msiof_spi_reset_regs(struct sh_msiof_spi_priv *p)
 	data |= mask;
 	sh_msiof_write(p, SICTR, data);
 
-	readl_poll_timeout_atomic(p->mapbase + SICTR, data, !(data & mask), 1,
-				  100);
+	return readl_poll_timeout_atomic(p->mapbase + SICTR, data,
+					 !(data & mask), 1, 100);
 }
 
 static void sh_msiof_spi_set_clk_regs(struct sh_msiof_spi_priv *p,
@@ -834,7 +834,9 @@ static int sh_msiof_transfer_one(struct spi_controller *ctlr,
 	int ret;
 
 	/* reset registers */
-	sh_msiof_spi_reset_regs(p);
+	ret = sh_msiof_spi_reset_regs(p);
+	if (ret)
+		return ret;
 
 	/* setup clocks (clock already enabled in chipselect()) */
 	if (!spi_controller_is_target(p->ctlr))
-- 
2.53.0



