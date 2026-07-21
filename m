Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 551D1356A12;
	Tue, 21 Jul 2026 20:45:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666748; cv=none; b=f9A0YNQQr22KEUqxZvdB6Zh7Tl+CGxb7/GMWkNVkPnlyrfsWeNRaOtWG6zR0MBbZZ122ab1JPe+FSVUGJ9bLNDYvUFmLWxq+3MkS14vIvav7OExNkoIUpciY0tmd9yud2gZt1gnCT0xmiu6oTW/sgnkFKn7j3pUh8L6JU2QZUeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666748; c=relaxed/simple;
	bh=AvXYS6J09uXclDyTZdc1KRMLUyRCKyTgWNKLVI8MNjA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gGHvOQWBLEwkd+no2wZjuygYTejYF8DYMhZmgDOC84q9YEb1P9m8BJ7M6T1zTPnCdxRYyIN7iqEFYMh9t2SqbkukMtus/OYA39WOoxo1PsmnrMlPImfE5JtRFcuCyQMjGWcxWuAHuxyNqbRt17bSxmacrtgNkyHl/Of4jSuAhmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IgkJYGxT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IgkJYGxT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA9C31F000E9;
	Tue, 21 Jul 2026 20:45:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666747;
	bh=VaNVtKFuHjcL38djw52qMXCm7raGCYhwZtcv8T8wMs4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IgkJYGxTBssx2KCaccLnIplh5C703oat0Dj4rO73GGtPZPe1Tkdn9DyFDpT7uW5bm
	 Pqul4QRPa5uW4RoF3hHQNfmSEvrUJ4Cx3US3T2CHHbdEdGhBcu9MBeSKHTzVlsQo9+
	 1RUC4DvXTQbn8pMNzWhskBmyZcTPx9vZFxK7DGOg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0800/1266] spi: sh-msiof: abort transfers when reset times out
Date: Tue, 21 Jul 2026 17:20:37 +0200
Message-ID: <20260721152459.760460637@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 65c11909659c6b..6d0376b6e53234 100644
--- a/drivers/spi/spi-sh-msiof.c
+++ b/drivers/spi/spi-sh-msiof.c
@@ -242,7 +242,7 @@ static irqreturn_t sh_msiof_spi_irq(int irq, void *data)
 	return IRQ_HANDLED;
 }
 
-static void sh_msiof_spi_reset_regs(struct sh_msiof_spi_priv *p)
+static int sh_msiof_spi_reset_regs(struct sh_msiof_spi_priv *p)
 {
 	u32 mask = SICTR_TXRST | SICTR_RXRST;
 	u32 data;
@@ -251,8 +251,8 @@ static void sh_msiof_spi_reset_regs(struct sh_msiof_spi_priv *p)
 	data |= mask;
 	sh_msiof_write(p, SICTR, data);
 
-	readl_poll_timeout_atomic(p->mapbase + SICTR, data, !(data & mask), 1,
-				  100);
+	return readl_poll_timeout_atomic(p->mapbase + SICTR, data,
+					 !(data & mask), 1, 100);
 }
 
 static const u32 sh_msiof_spi_div_array[] = {
@@ -926,7 +926,9 @@ static int sh_msiof_transfer_one(struct spi_controller *ctlr,
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



