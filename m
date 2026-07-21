Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D98B0224B05;
	Tue, 21 Jul 2026 22:46:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673991; cv=none; b=AJEGGf+jkTJeK9roola2mSiunXXVoABfLlFdBIlI3Wd2FYFuu47hnDbEMJHuoqEkASl2HxyhVa5Heb9YDjavcR6XafSPUhDb974Z8miK5fkoQ85t9Ec+wWdHGJvc/Kh44jMheeW6Lvt5ftf2w/PyCex16gJULRhxaDI6he8b9GI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673991; c=relaxed/simple;
	bh=MMydbikZawMBFCn5fG0ayl8FP2qOtxPgMdZ1Dej3O9A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VtdpIiIMk/L1GOYMdcC9iSHEHVADbYDveWtP1bgGRYpnqCv/ZGDngTecZXgH7m6tbzrRm3QpuSCQX+w+az/8Kio+5f7bLw97YhBkmkIKs3q/atwJDOETu0fJCLSjTfPcuJzQO8nAWwVaQ4ubPd0X0fs+DJ5wWfQgAcMVsRZudWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PPOIYcHy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PPOIYcHy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AA6C1F000E9;
	Tue, 21 Jul 2026 22:46:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673990;
	bh=rSY9rmYdHjKG/ah0vUGA5qvorYDd038oNPqjjMBMrso=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PPOIYcHyCTu1Ahe3iUkK6aMM3WVwirxjrhhLLivOwl1ttrQicG9moWzzdGSdW02Kg
	 4rbz4UbnyZuhg9ZyD4XZG6oXiG7YMbAheZ6HFB8PHLiSkrTDhCdp+c5JCFvthilVLJ
	 egkCTqKs1Zb0Fi+m4TUr37oYnVG2H8wqCxuOsEzg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 373/699] spi: sh-msiof: abort transfers when reset times out
Date: Tue, 21 Jul 2026 17:22:12 +0200
Message-ID: <20260721152404.108369130@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index f1ca8b5356bcfd..6c026b193548a6 100644
--- a/drivers/spi/spi-sh-msiof.c
+++ b/drivers/spi/spi-sh-msiof.c
@@ -243,7 +243,7 @@ static irqreturn_t sh_msiof_spi_irq(int irq, void *data)
 	return IRQ_HANDLED;
 }
 
-static void sh_msiof_spi_reset_regs(struct sh_msiof_spi_priv *p)
+static int sh_msiof_spi_reset_regs(struct sh_msiof_spi_priv *p)
 {
 	u32 mask = SICTR_TXRST | SICTR_RXRST;
 	u32 data;
@@ -252,8 +252,8 @@ static void sh_msiof_spi_reset_regs(struct sh_msiof_spi_priv *p)
 	data |= mask;
 	sh_msiof_write(p, SICTR, data);
 
-	readl_poll_timeout_atomic(p->mapbase + SICTR, data, !(data & mask), 1,
-				  100);
+	return readl_poll_timeout_atomic(p->mapbase + SICTR, data,
+					 !(data & mask), 1, 100);
 }
 
 static const u32 sh_msiof_spi_div_array[] = {
@@ -923,7 +923,9 @@ static int sh_msiof_transfer_one(struct spi_controller *ctlr,
 	int ret;
 
 	/* reset registers */
-	sh_msiof_spi_reset_regs(p);
+	ret = sh_msiof_spi_reset_regs(p);
+	if (ret)
+		return ret;
 
 	/* setup clocks (clock already enabled in chipselect()) */
 	if (!spi_controller_is_slave(p->ctlr))
-- 
2.53.0



