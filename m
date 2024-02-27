Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 213FE13B7AB;
	Tue, 27 Feb 2024 14:26:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043979; cv=none; b=k4uW1MRUG2hqE65BnDfUsrFEyi1uELP/iB6BwIYWlnaULTcY9DRvKMzm/R1G1/kF65yLBSi4t9XC9sJMHVjjmBgPwvfMARhieQaBBnfGggA5xFrWm1lQXwnLXZ3lSoMEyo4I5kfiNn+Kllt74Y/up+GGPxFZ4aes2tZT7w9NhVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043979; c=relaxed/simple;
	bh=fb6syoblvWzbaUbkPZQfanFW1SvNXK65ofjzplMK3No=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u5XKWvUL+KZI4jm7SsmGK360L6+c8VF9+0CgTf7bNu0TwY8ANBQyRrrY/W6gUAfvXgDR1grcNOagVM9PriOQI6HpsVjmmJeYjWz9r++c4WmDrWkQwfOamKFuzZSKaXYyOt2ixawxn6A968K6Hv6HL2D+xGmhrIAlW4MFJuX6clw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kiXyvb0l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kiXyvb0l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A03EDC43390;
	Tue, 27 Feb 2024 14:26:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043979;
	bh=fb6syoblvWzbaUbkPZQfanFW1SvNXK65ofjzplMK3No=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kiXyvb0lEYgvktaW6yGA9p5aXzvN1OWjEcUl5SrNsr6zGp7djJSDB4yxsr4fTFNzL
	 j6CdURkGRtybc8bcocwXRs09yDkNllvI3s38J24+aMTGmphrSVDhzkyAGHwDEh/vbM
	 tF3/VdpGTcF3ZMbknwSwDonSGpIkHUXMrrI1dTyM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Devyn Liu <liudingyuan@huawei.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 019/122] spi: hisi-sfc-v3xx: Return IRQ_NONE if no interrupts were detected
Date: Tue, 27 Feb 2024 14:26:20 +0100
Message-ID: <20240227131559.334779733@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131558.694096204@linuxfoundation.org>
References: <20240227131558.694096204@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 4650b483a33d3..e0c3ad73c576d 100644
--- a/drivers/spi/spi-hisi-sfc-v3xx.c
+++ b/drivers/spi/spi-hisi-sfc-v3xx.c
@@ -365,6 +365,11 @@ static const struct spi_controller_mem_ops hisi_sfc_v3xx_mem_ops = {
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



