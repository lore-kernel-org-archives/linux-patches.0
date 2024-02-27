Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAEAE1419B3;
	Tue, 27 Feb 2024 13:47:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041643; cv=none; b=dUatxq2aKByJhPFnGEAm3UjsNZ0mhKo2uxCOkNsK21uQEmPszwBo4NXWguTZTmOrlzE4U5owqkujrZ/VgXB8Msd8x6RC6kVA/G4uaK4TUsqCu55j6O1+djiN6vlnyANG//WPZDuBxB0WeXfM046Z+VX3vQxA1XADiXlp6BLjutQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041643; c=relaxed/simple;
	bh=mMa8aD6lcS8oM0M40V+xKDruZHavkwkqcRO0VEa1VHg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YmoFXfKgBxOqo/C0ECaWNySUSB1DlTmsBR2Wc4FmBSS2YTloEtw2yd9s5mBcfZe0SA+Ww6EUaTuUjoqULOPAa2Y3UYL2hhZL5+Tg+qKo05I8gSVq+QEGNGmYRxfI0vd9gnxZJLi1BMs1NfLG+VQak+lpn0kmZvKMLx6ZyMdTXF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NcWyK4R/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NcWyK4R/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EF0DC433F1;
	Tue, 27 Feb 2024 13:47:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041643;
	bh=mMa8aD6lcS8oM0M40V+xKDruZHavkwkqcRO0VEa1VHg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NcWyK4R/nlEVXmO76eqHHUyD0cpGo3PgCyLk+cndA1nkBelHoVCKyfF8U8/i+U6iV
	 3qHNLxfgDJzzG+WR5jlYHQY3p+wNXWw7xBZPDm62GO4KXicXEojw6VOTJ6RCMrSZli
	 stiTZkfDZ33sOOuBl4RHGWK8Wy1PSz8mnJ0FjghQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Devyn Liu <liudingyuan@huawei.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 020/299] spi: hisi-sfc-v3xx: Return IRQ_NONE if no interrupts were detected
Date: Tue, 27 Feb 2024 14:22:11 +0100
Message-ID: <20240227131626.483781489@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Devyn Liu <liudingyuan@huawei.com>

[ Upstream commit de8b6e1c231a95abf95ad097b993d34b31458ec9 ]

Return IRQ_NONE from the interrupt handler when no interrupt was
detected. Because an empty interrupt will cause a null pointer error:

    Unable to handle kernel NULL pointer dereference at virtual
  address 0000000000000008
    Call trace:
        complete+0x54/0x100
        hisi_sfc_v3xx_isr+0x2c/0x40 [spi_hisi_sfc_v3xx]
        __handle_irq_event_percpu+0x64/0x1e0
        handle_irq_event+0x7c/0x1cc

Signed-off-by: Devyn Liu <liudingyuan@huawei.com>
Link: https://msgid.link/r/20240123071149.917678-1-liudingyuan@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-hisi-sfc-v3xx.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/spi/spi-hisi-sfc-v3xx.c b/drivers/spi/spi-hisi-sfc-v3xx.c
index 9d22018f7985f..1301d14483d48 100644
--- a/drivers/spi/spi-hisi-sfc-v3xx.c
+++ b/drivers/spi/spi-hisi-sfc-v3xx.c
@@ -377,6 +377,11 @@ static const struct spi_controller_mem_ops hisi_sfc_v3xx_mem_ops = {
 static irqreturn_t hisi_sfc_v3xx_isr(int irq, void *data)
 {
 	struct hisi_sfc_v3xx_host *host = data;
+	u32 reg;
+
+	reg = readl(host->regbase + HISI_SFC_V3XX_INT_STAT);
+	if (!reg)
+		return IRQ_NONE;
 
 	hisi_sfc_v3xx_disable_int(host);
 
-- 
2.43.0



